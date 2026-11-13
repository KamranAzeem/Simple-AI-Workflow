#!/bin/bash
# Dev-time fixture test for the trigger declarations.
# Usage: ./tests/test-trigger-rules.sh
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

make_procedure() {
    local path="$1" name="$2" triggers="$3"
    mkdir -p "$(dirname "$path")"
    {
        printf '# PROCEDURE %s: Fixture procedure\n\n' "$name"
        printf '## Triggers\n\n'
        printf '%s\n\n' "$triggers"
        printf '1. **STEP-ONE**: Do the fixture.\n'
    } > "$path"
}

make_procedure_no_triggers() {
    local path="$1" name="$2"
    mkdir -p "$(dirname "$path")"
    {
        printf '# PROCEDURE %s: Fixture procedure\n\n' "$name"
        printf '1. **STEP-ONE**: Do the fixture.\n'
    } > "$path"
}

make_thin_agents() {
    local path="$1" extra="${2:-}"
    {
        printf '## TIER CONFIGURATION\n\n- Fixture.\n\n'
        printf '## TIER READ-FIRST-RULES\n\n- Fixture.\n\n'
        printf '## Shared Protocol Steps\n\n- **STEP-PROTOCOL-INDEX**: Rebuild.\n\n'
        printf '## Protocol Dispatch\n\n- Resolve.\n\n'
        printf '## TIER TRIGGERED-PROCEDURES\n\n- Store.\n\n'
        printf '## TIER APPENDIX\n\n- Pointer.\n'
        [ -n "$extra" ] && printf '\n%s\n' "$extra"
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

mkdir -p "$WORK/ai/policies" "$WORK/ai/procedures"

make_policy "$WORK/ai/policies/ai-policy-cloud.md" "Cloud" "- cloud standards"
run_case "valid policy with a trigger" 0 "PASSED" "$WORK/ai/policies/ai-policy-cloud.md"

make_policy "$WORK/ai/policies/ai-policy-empty.md" "Empty" ""
run_case "policy without triggers" 0 "PASSED" "$WORK/ai/policies/ai-policy-empty.md"

make_policy "$WORK/ai/policies/ai-policy-one.md" "One" "- cloud standards"
make_policy "$WORK/ai/policies/ai-policy-two.md" "Two" "- cloud standards"
run_case "cross-module policy duplicate" 1 'duplicate trigger' "$WORK/ai/policies/ai-policy-one.md" "$WORK/ai/policies/ai-policy-two.md"

make_policy "$WORK/ai/policies/ai-policy-short.md" "Short" "- cloud"
make_policy "$WORK/ai/policies/ai-policy-long.md" "Long" "- cloud standards"
run_case "cross-module policy containment" 1 'trigger overlap' "$WORK/ai/policies/ai-policy-short.md" "$WORK/ai/policies/ai-policy-long.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" $'- load context\n- load context using agents.md protocol'
run_case "same-module procedure close variants" 0 "PASSED" "$WORK/ai/procedures/load-context.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" $'- load context\n- load-context'
run_case "same-module procedure exact duplicate" 0 "PASSED" "$WORK/ai/procedures/load-context.md"

make_policy "$WORK/ai/policies/ai-policy-emptyblock.md" "Empty Block" "- placeholder standard"
rewrite "$WORK/ai/policies/ai-policy-emptyblock.md" '!/^- placeholder standard$/{print}'
run_case "empty policy trigger block" 1 'empty trigger block' "$WORK/ai/policies/ai-policy-emptyblock.md"

make_policy "$WORK/ai/policies/ai-policy-two-sections.md" "Two Sections" "- one standard"
printf '\n## Triggers\n\n- two standard\n' >> "$WORK/ai/policies/ai-policy-two-sections.md"
run_case "second policy trigger section" 1 'more than one' "$WORK/ai/policies/ai-policy-two-sections.md"

make_policy "$WORK/ai/policies/ai-policy-upper.md" "Upper" "- Cloud Standards"
run_case "uppercase policy phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-upper.md"

make_policy "$WORK/ai/policies/ai-policy-nonascii.md" "Non ASCII" "- cloud standärds"
run_case "non-ASCII policy phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-nonascii.md"

make_policy "$WORK/ai/policies/ai-policy-emptynorm.md" "Empty Normalized" "- -"
run_case "empty normalized policy phrase" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-emptynorm.md"

make_policy "$WORK/ai/policies/ai-policy-misplaced.md" "Misplaced" ""
rewrite "$WORK/ai/policies/ai-policy-misplaced.md" '{print} /^## Rules$/{print ""; print "## Triggers"; print ""; print "- misplaced standard"}'
run_case "misplaced policy trigger" 1 'invalid policy shape' "$WORK/ai/policies/ai-policy-misplaced.md"

make_policy "$WORK/ai/policies/random.md" "Random" "- random standard"
run_case "bad policy filename" 1 'name mismatch' "$WORK/ai/policies/random.md"

make_policy "$WORK/ai/policies/ai-policy-placeholder.md" "Placeholder" "- cloud #N"
run_case "placeholder in a policy trigger" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-placeholder.md"

make_procedure "$WORK/ai/procedures/manage-issues.md" "MANAGE-ISSUES" "- plan issue #N"
run_case "placeholder in a procedure trigger" 0 "PASSED" "$WORK/ai/procedures/manage-issues.md"

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
run_case "prose inside a policy trigger" 1 'invalid trigger block' "$WORK/ai/policies/ai-policy-malformed.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" "- cloud*"
run_case "wildcard procedure trigger" 1 'invalid trigger block' "$WORK/ai/procedures/load-context.md"
make_procedure "$WORK/ai/procedures/manage-issues.md" "MANAGE-ISSUES" "- plan #N issue"
run_case "non-trailing procedure placeholder" 1 'invalid trigger block' "$WORK/ai/procedures/manage-issues.md"
make_procedure "$WORK/ai/procedures/manage-issues.md" "MANAGE-ISSUES" "- #N"
run_case "procedure placeholder alone" 1 'invalid trigger block' "$WORK/ai/procedures/manage-issues.md"

make_procedure "$WORK/ai/procedures/manage-issues.md" "MANAGE-ISSUES" "- plan issue #N"
make_policy "$WORK/ai/policies/ai-policy-base.md" "Base" "- plan issue"
run_case "placeholder base collision" 1 'duplicate trigger' "$WORK/ai/procedures/manage-issues.md" "$WORK/ai/policies/ai-policy-base.md"

make_policy "$WORK/ai/policies/ai-policy-domain-first.md" "Domain First" ""
rewrite "$WORK/ai/policies/ai-policy-domain-first.md" '/^## Scope$/{print "## Overview"; print ""; print "- overview"; print ""; print "## Triggers"; print ""; print "- after overview"; print ""} {print}'
run_case "trigger after a domain section" 1 'first section after the purpose' "$WORK/ai/policies/ai-policy-domain-first.md"

make_policy "$WORK/ai/policies/ai-policy-subheading.md" "Subheading" "- subheading standard"
rewrite "$WORK/ai/policies/ai-policy-subheading.md" '/^## Triggers$/{print "### Note"; print ""; print "note text"; print ""} {print}'
run_case "subheading before the trigger section" 1 'immediately follow the purpose' "$WORK/ai/policies/ai-policy-subheading.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" "- load context"
run_case "valid procedure module" 0 "PASSED" "$WORK/ai/procedures/load-context.md"

make_procedure_no_triggers "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT"
run_case "procedure module without triggers" 1 'missing triggers' "$WORK/ai/procedures/load-context.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" "- load context"
printf '\n**Aliases**: load context\n' >> "$WORK/ai/procedures/load-context.md"
run_case "procedure module with aliases" 1 'aliases are not allowed' "$WORK/ai/procedures/load-context.md"

make_procedure "$WORK/ai/procedures/wrong-name.md" "LOAD-CONTEXT" "- load context"
run_case "procedure module bad stem" 1 'name mismatch' "$WORK/ai/procedures/wrong-name.md"

make_thin_agents "$WORK/AGENTS.md"
run_case "thin AGENTS.md" 0 "PASSED" "$WORK/AGENTS.md"

make_thin_agents "$WORK/AGENTS.md" "### PROCEDURE LOAD-CONTEXT: old"
run_case "AGENTS.md with a procedure" 1 'procedure content' "$WORK/AGENTS.md"

make_procedure "$WORK/ai/procedures/cloud-standards.md" "CLOUD-STANDARDS" "- cloud standards"
make_policy "$WORK/ai/policies/ai-policy-cloud-dup.md" "Cloud Dup" "- cloud standards"
run_case "policy and procedure duplicate" 1 'duplicate trigger' "$WORK/ai/procedures/cloud-standards.md" "$WORK/ai/policies/ai-policy-cloud-dup.md"

make_thin_agents "$WORK/AGENTS.md" "# PROCEDURE LOAD-CONTEXT: old"
run_case "thin AGENTS.md with an H1 procedure" 1 'procedure content' "$WORK/AGENTS.md"

make_thin_agents "$WORK/AGENTS.md" "**Aliases**: load context"
run_case "thin AGENTS.md with aliases" 1 'procedure content' "$WORK/AGENTS.md"

make_thin_agents "$WORK/AGENTS.md"
rewrite "$WORK/AGENTS.md" '!/^## Protocol Dispatch$/{print}'
run_case "thin AGENTS.md missing a section" 1 'missing required section' "$WORK/AGENTS.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" "- load context"
printf '\n**Loads**: ai-policy-common.md\n' >> "$WORK/ai/procedures/load-context.md"
run_case "procedure module with a Loads line" 1 '**Loads** line is not allowed' "$WORK/ai/procedures/load-context.md"

mkdir -p "$WORK/ai/procedures"
{
    printf '<!-- leading comment -->\n'
    printf '# PROCEDURE LOAD-CONTEXT: Fixture procedure\n\n'
    printf '## Triggers\n\n- load context\n'
} > "$WORK/ai/procedures/load-context.md"
run_case "procedure module H1 not first" 1 'must start with' "$WORK/ai/procedures/load-context.md"

{
    printf '# PROCEDURE LOAD-CONTEXT: Fixture procedure\n\n'
    printf '## Body\n\n- body content\n\n'
    printf '## Triggers\n\n- load context\n'
} > "$WORK/ai/procedures/load-context.md"
run_case "procedure triggers after a body section" 1 'first section' "$WORK/ai/procedures/load-context.md"

{
    printf '# PROCEDURE LOAD-CONTEXT: Fixture procedure\n\n'
    printf '1. **STEP-ONE**: Before the triggers.\n\n'
    printf '## Triggers\n\n- load context\n'
} > "$WORK/ai/procedures/load-context.md"
run_case "procedure body before triggers" 1 'immediately follow the H1' "$WORK/ai/procedures/load-context.md"

make_procedure "$WORK/ai/procedures/load-context.md" "LOAD-CONTEXT" "- load context"
run_case "valid procedure module in --triggers mode" 0 "PASSED" --triggers "$WORK/ai/procedures/load-context.md"

# --- --index oracle ---
make_policy "$WORK/ai/policies/ai-policy-fixture-one.md" "Fixture One" "- fixture one"
make_procedure "$WORK/ai/procedures/fixture-proc.md" "FIXTURE-PROC" "- fixture proc"
index_out="$(cd "$WORK" && bash "$VALIDATOR" --index ai/policies/ai-policy-fixture-one.md ai/procedures/fixture-proc.md 2>&1)"
index_rc=$?
cases=$((cases + 1))
expected_index='policy|global|fixture-one|ai/policies/ai-policy-fixture-one.md|triggers=fixture one|headings=# DO NOT MODIFY THIS FILE;# AI Policy: Fixture One;## Triggers;## Scope;## Rules;## References|effective=yes|conflict=none
procedure|global|FIXTURE-PROC|ai/procedures/fixture-proc.md|triggers=fixture proc|headings=# PROCEDURE FIXTURE-PROC: Fixture procedure;## Triggers|effective=yes|conflict=none
summary|modules=2|policies=1|procedures=1|triggers=2|conflicts=0|errors=0|error_classes=none'
if [ "$index_rc" -ne 0 ] || [ "$index_out" != "$expected_index" ]; then
    printf 'FAIL: index golden (exit %s)\n--- expected ---\n%s\n--- actual ---\n%s\n' "$index_rc" "$expected_index" "$index_out"
    failures=$((failures + 1))
else
    printf 'PASS: index golden\n'
fi

make_policy "$WORK/ai/policies/ai-policy-index-bad.md" "Index Bad" "- Bad"
run_case "index invalid trigger" 1 "summary|" --index "$WORK/ai/policies/ai-policy-index-bad.md"
make_procedure_no_triggers "$WORK/ai/procedures/index-no-trig.md" "INDEX-NO-TRIG"
run_case "index procedure without triggers" 1 "summary|" --index "$WORK/ai/procedures/index-no-trig.md"
make_policy "$WORK/ai/policies/ai-policy-index-shape.md" "Index Shape" "- index shape" "yes"
run_case "index tolerates a shape gap" 0 "errors=1" --index "$WORK/ai/policies/ai-policy-index-shape.md"

# --- legacy shape coverage ---
make_policy "$WORK/ai/policies/ai-policy-legacy-title.md" "Legacy Title" "- legacy title"
sed -i 's/^# AI Policy: .*/# AI Assistant Policy: Legacy Title/' "$WORK/ai/policies/ai-policy-legacy-title.md"
run_case "legacy old title" 1 "missing policy title" "$WORK/ai/policies/ai-policy-legacy-title.md"
make_policy "$WORK/ai/policies/ai-policy-legacy-refs.md" "Legacy Refs" "- legacy refs" "yes"
run_case "legacy missing references" 1 "missing '## References'" "$WORK/ai/policies/ai-policy-legacy-refs.md"
make_policy "$WORK/ai/policies/ai-policy-legacy-purpose.md" "Legacy Purpose" "- legacy purpose"
sed -i '/^Govern the fixture behavior\.$/d' "$WORK/ai/policies/ai-policy-legacy-purpose.md"
run_case "legacy missing purpose" 1 "purpose must be a one-line sentence" "$WORK/ai/policies/ai-policy-legacy-purpose.md"

echo "---"
if [ "$failures" -ne 0 ]; then
    printf 'FAILED: %s of %s cases failed.\n' "$failures" "$cases"
    exit 1
fi
printf 'PASSED: %s cases.\n' "$cases"
exit 0
