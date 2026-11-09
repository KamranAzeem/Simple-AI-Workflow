#!/bin/bash
# Dev-time fixture test for the trigger declaration rules.
# Usage: ./support-files/test-trigger-rules.sh
# Exit 0 when every case passes, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

failures=0
cases=0

make_policy() {
    local path="$1" title="$2" triggers="$3" no_refs="${4:-no}"
    mkdir -p "$(dirname "$path")"
    {
        printf '# DO NOT MODIFY THIS FILE\n\n'
        printf 'Test fixture.\n\n'
        printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n'
        printf '# AI Policy: %s\n\n' "$title"
        printf 'Govern the fixture behavior.\n\n'
        if [ -n "$triggers" ]; then
            printf '## Triggers\n\n'
            printf '%s\n\n' "$triggers"
        fi
        printf '## Scope\n\n- Fixture scope.\n\n'
        printf '## Rules\n\n- Follow the fixture.\n\n'
        if [ "$no_refs" != "yes" ]; then
            printf '## References\n\n- Fixture reference.\n\n'
        fi
        printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
    } > "$path"
}

make_agents() {
    local path="$1" aliases="$2"
    {
        printf '## TIER TRIGGERED-PROCEDURES\n\n'
        printf '### PROCEDURE LOAD-CONTEXT: When the user says "load context"\n\n'
        printf '**Aliases**: %s\n\n' "$aliases"
        printf '### PROCEDURE UPDATE-DESIGN-DOCS: When the user says "update design documents"\n\n'
        printf '**Aliases**: update design-docs; update design docs\n'
    } > "$path"
}

rewrite() {
    local file="$1"
    shift
    awk "$@" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

run_case() {
    local name="$1" expect_rc="$2" expect_text="$3"
    shift 3
    local out rc
    out="$(bash "$VALIDATOR" "$@" 2>&1)"
    rc=$?
    cases=$((cases + 1))
    if [ "$rc" -ne "$expect_rc" ]; then
        printf 'FAIL: %s (exit %s, expected %s)\n%s\n' "$name" "$rc" "$expect_rc" "$out"
        failures=$((failures + 1))
        return
    fi
    if [ -n "$expect_text" ] && ! printf '%s\n' "$out" | grep -qF "$expect_text"; then
        printf 'FAIL: %s (missing "%s")\n%s\n' "$name" "$expect_text" "$out"
        failures=$((failures + 1))
        return
    fi
    printf 'PASS: %s\n' "$name"
}

mkdir -p "$WORK/ai/policies"

make_policy "$WORK/ai/policies/ai-policy-cloud.md" "Cloud" "- cloud standards"
run_case "valid policy with a trigger" 0 "PASSED" "$WORK/ai/policies/ai-policy-cloud.md"

make_policy "$WORK/ai/policies/ai-policy-empty.md" "Empty" ""
run_case "policy without triggers" 0 "PASSED" "$WORK/ai/policies/ai-policy-empty.md"

make_policy "$WORK/ai/policies/ai-policy-one.md" "One" "- cloud standards"
make_policy "$WORK/ai/policies/ai-policy-two.md" "Two" "- cloud standards"
run_case "cross-module duplicate" 1 'duplicate trigger' "$WORK/ai/policies/ai-policy-one.md" "$WORK/ai/policies/ai-policy-two.md"

make_policy "$WORK/ai/policies/ai-policy-short.md" "Short" "- cloud"
make_policy "$WORK/ai/policies/ai-policy-long.md" "Long" "- cloud standards"
run_case "cross-module containment" 1 'trigger overlap' "$WORK/ai/policies/ai-policy-short.md" "$WORK/ai/policies/ai-policy-long.md"

make_agents "$WORK/AGENTS.md" "load context; load context using AGENTS.md protocol"
run_case "same-module close variants" 0 "PASSED" "$WORK/AGENTS.md"

make_agents "$WORK/AGENTS.md" "load context; load-context"
run_case "same-module exact duplicate" 0 "PASSED" "$WORK/AGENTS.md"

make_policy "$WORK/ai/policies/ai-policy-emptyblock.md" "Empty Block" "- placeholder standard"
rewrite "$WORK/ai/policies/ai-policy-emptyblock.md" '!/^- placeholder standard$/{print}'
run_case "empty trigger block" 1 'empty trigger block' "$WORK/ai/policies/ai-policy-emptyblock.md"

make_policy "$WORK/ai/policies/ai-policy-two-sections.md" "Two Sections" "- one standard"
printf '\n## Triggers\n\n- two standard\n' >> "$WORK/ai/policies/ai-policy-two-sections.md"
run_case "second trigger section" 1 'more than one' "$WORK/ai/policies/ai-policy-two-sections.md"

make_policy "$WORK/ai/policies/ai-policy-upper.md" "Upper" "- Cloud Standards"
run_case "uppercase phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-upper.md"

make_policy "$WORK/ai/policies/ai-policy-nonascii.md" "Non ASCII" "- cloud standärds"
run_case "non-ASCII phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-nonascii.md"

make_policy "$WORK/ai/policies/ai-policy-emptynorm.md" "Empty Normalized" "- -"
run_case "empty normalized phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-emptynorm.md"

make_policy "$WORK/ai/policies/ai-policy-misplaced.md" "Misplaced" ""
rewrite "$WORK/ai/policies/ai-policy-misplaced.md" '{print} /^## Rules$/{print ""; print "## Triggers"; print ""; print "- misplaced standard"}'
run_case "misplaced trigger section" 1 'invalid policy shape' "$WORK/ai/policies/ai-policy-misplaced.md"

make_policy "$WORK/ai/policies/random.md" "Random" "- random standard"
run_case "bad policy filename" 1 'name mismatch' "$WORK/ai/policies/random.md"

make_policy "$WORK/ai/policies/ai-policy-placeholder.md" "Placeholder" "- cloud #N"
run_case "placeholder in a policy trigger" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-placeholder.md"

make_agents "$WORK/AGENTS.md" "plan issue #N; implement issue #N"
run_case "placeholder alias is allowed" 0 "PASSED" "$WORK/AGENTS.md"

make_policy "$WORK/ai/policies/ai-policy-norefs.md" "No References" "- no refs standard" "yes"
run_case "shape failure in default mode" 1 "missing '## References'" "$WORK/ai/policies/ai-policy-norefs.md"
run_case "shape skipped in --triggers mode" 0 "PASSED" --triggers "$WORK/ai/policies/ai-policy-norefs.md"

make_policy "$WORK/ai/policies/ai-policy-init-cloud.md" "Init Cloud" "- cloud standards"
make_policy "$WORK/ai/policies/ai-policy-init-data.md" "Init Data" "- data standards"
make_policy "$WORK/ai/policies/ai-policy-init-dba.md" "Init DBA" "- database standards"
make_policy "$WORK/ai/policies/ai-policy-init-backend.md" "Init Backend" "- backend standards"
run_case "four initial phrases" 0 "PASSED" "$WORK/ai/policies/ai-policy-init-cloud.md" "$WORK/ai/policies/ai-policy-init-data.md" "$WORK/ai/policies/ai-policy-init-dba.md" "$WORK/ai/policies/ai-policy-init-backend.md"
run_case "four initial phrases in --triggers mode" 0 "PASSED" --triggers "$WORK/ai/policies/ai-policy-init-cloud.md" "$WORK/ai/policies/ai-policy-init-data.md" "$WORK/ai/policies/ai-policy-init-dba.md" "$WORK/ai/policies/ai-policy-init-backend.md"

make_policy "$WORK/ai/policies/ai-policy-punct-a.md" "Punct A" "- cloud standards"
make_policy "$WORK/ai/policies/ai-policy-punct-b.md" "Punct B" "- cloud-standards"
run_case "punctuation duplicate" 1 'duplicate trigger' "$WORK/ai/policies/ai-policy-punct-a.md" "$WORK/ai/policies/ai-policy-punct-b.md"
run_case "punctuation duplicate in --triggers mode" 1 'duplicate trigger' --triggers "$WORK/ai/policies/ai-policy-punct-a.md" "$WORK/ai/policies/ai-policy-punct-b.md"

make_policy "$WORK/ai/policies/ai-policy-malformed.md" "Malformed" $'- valid standard\nprose line'
run_case "prose inside the trigger block" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-malformed.md"

make_agents "$WORK/AGENTS.md" "cloud*"
run_case "wildcard alias" 1 'invalid trigger block' "$WORK/AGENTS.md"
make_agents "$WORK/AGENTS.md" "plan #N issue"
run_case "non-trailing placeholder" 1 'invalid trigger block' "$WORK/AGENTS.md"
make_agents "$WORK/AGENTS.md" "#N"
run_case "placeholder alone" 1 'invalid trigger block' "$WORK/AGENTS.md"

make_agents "$WORK/AGENTS.md" "plan issue #N"
make_policy "$WORK/ai/policies/ai-policy-base.md" "Base" "- plan issue"
run_case "placeholder base collision" 1 'duplicate trigger' "$WORK/AGENTS.md" "$WORK/ai/policies/ai-policy-base.md"

make_policy "$WORK/ai/policies/ai-policy-domain-first.md" "Domain First" ""
rewrite "$WORK/ai/policies/ai-policy-domain-first.md" '/^## Scope$/{print "## Overview"; print ""; print "- overview"; print ""; print "## Triggers"; print ""; print "- after overview"; print ""} {print}'
run_case "trigger after a domain section" 1 'first section after the purpose' "$WORK/ai/policies/ai-policy-domain-first.md"

make_policy "$WORK/ai/policies/ai-policy-subheading.md" "Subheading" "- subheading standard"
rewrite "$WORK/ai/policies/ai-policy-subheading.md" '/^## Triggers$/{print "### Note"; print ""; print "note text"; print ""} {print}'
run_case "subheading before the trigger section" 1 'immediately follow the purpose' "$WORK/ai/policies/ai-policy-subheading.md"

echo "---"
if [ "$failures" -ne 0 ]; then
    printf 'FAILED: %s of %s cases failed.\n' "$failures" "$cases"
    exit 1
fi
printf 'PASSED: %s cases.\n' "$cases"
exit 0
