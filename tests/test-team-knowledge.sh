#!/bin/bash
# Dev-time fixture for the optional team knowledge store.
# The boot index is AI-driven, so this test pins the module shapes, the wiring,
# the fixture layout, and the documented degradation behavior.
# Usage: ./tests/test-team-knowledge.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-team-knowledge.md"
PROC="$ROOT/ai/procedures/knowledge-publish.md"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
MAIN_VALIDATOR="$ROOT/support-files/validate-protocol.sh"
LOAD_CONTEXT="$ROOT/ai/procedures/load-context.md"
FIXTURE="$ROOT/tests/team-alpha"

fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        fail_case "$label"
    else
        pass "$label"
    fi
}

# --- policy shape ---
if [ -f "$POLICY" ]; then
    pass "team policy exists"
    if [ "$(sed -n '1p' "$POLICY")" = "# 🚫 DO NOT MODIFY THIS FILE" ]; then
        pass "team policy guard is first"
    else
        fail_case "team policy guard is missing or not first"
    fi
    present "$POLICY" "# AI Policy: Team Knowledge" "team policy title"
    present "$POLICY" "<!-- AI-ASSISTANT: READ-ONLY START -->" "team policy READ-ONLY START"
    present "$POLICY" "<!-- AI-ASSISTANT: READ-ONLY END -->" "team policy READ-ONLY END"
    present "$POLICY" "## Scope" "team policy Scope"
    present "$POLICY" "## References" "team policy References"
    present "$POLICY" "- Mode: procedure" "team policy is procedure-loaded"
    present "$POLICY" "- Load in: knowledge-publish" "team policy names the publish procedure"
    present "$POLICY" "## Team Knowledge Protocol" "team policy protocol section"
    present "$POLICY" "project knowledge, then team knowledge, then personal global knowledge" "team policy states precedence"
    present "$POLICY" "Class A" "team policy states the destination class"
    present "$POLICY" "10 KB" "team policy states the soft target"
    present "$POLICY" "15 KB" "team policy states the split review"
    present "$POLICY" "100-file" "team policy states the store threshold"
    present "$POLICY" "16 KB" "team policy states the boot bound"
    present "$POLICY" "team-knowledge/" "team policy uses the team-knowledge path"
else
    fail_case "team policy exists"
fi

# --- procedure shape ---
if [ -f "$PROC" ]; then
    pass "publish procedure exists"
    if [ "$(sed -n '1p' "$PROC")" = "# PROCEDURE KNOWLEDGE-PUBLISH: Publish a lesson to the team knowledge store" ]; then
        pass "publish procedure H1"
    else
        fail_case "publish procedure H1"
    fi
    present "$PROC" "- update team knowledge" "update team knowledge trigger"
    present "$PROC" "- publish team knowledge" "publish team knowledge trigger"
    present "$PROC" "- publish to team knowledge" "publish to team knowledge trigger"
    for step in STEP-LOAD-TEAM-POLICY STEP-RESOLVE-PUBLISH-SCOPE STEP-CLASSIFY-AND-SCRUB STEP-DEDUPE STEP-WRITE-LESSON STEP-OPEN-PR STEP-REPORT-PUBLISH; do
        present "$PROC" "$step" "publish step $step"
    done
    present "$PROC" "never merge" "publish procedure never merges"
    present "$PROC" "do not apply the local sensitive-names list" "publish procedure keeps the local names list out"
    present "$PROC" "team-knowledge/" "publish procedure uses the team-knowledge path"
else
    fail_case "publish procedure exists"
fi

# --- boot wiring ---
present "$ROOT/AGENTS.md" "Team AI Knowledge Directory" "AGENTS.md has the team directory anchor"
present "$ROOT/AGENTS.md" "Team AI Knowledge Repository" "AGENTS.md has the team repository anchor"
present "$ROOT/AGENTS.md" "STEP-TEAM-KNOWLEDGE-INDEX loads" "AGENTS.md amends the Policy Loading Set"
present "$ROOT/ai/policies/ai-policy-common.md" "Team AI Knowledge Directory" "common policy names the team store"
present "$ROOT/ai/policies/ai-policy-common.md" "Index the configured" "common policy indexes the configured team store"
present "$LOAD_CONTEXT" "STEP-TEAM-KNOWLEDGE-INDEX" "load context has the team index step"
present "$LOAD_CONTEXT" "ITEM TEAM-KNOWLEDGE-INDEX" "load context has the team index proof item"
present "$LOAD_CONTEXT" "filenames" "load context indexes filenames only"
present "$LOAD_CONTEXT" "missing or unreadable" "load context documents the degradation"
present "$LOAD_CONTEXT" "Team AI Knowledge Directory" "load context reads the team key"
present "$LOAD_CONTEXT" "team-knowledge/" "load context indexes the team-knowledge path"

if [ -f "$LOAD_CONTEXT" ]; then
    knowledge_line="$(grep -n 'STEP-KNOWLEDGE-INDEXING' "$LOAD_CONTEXT" | head -1 | cut -d: -f1)"
    team_line="$(grep -n 'STEP-TEAM-KNOWLEDGE-INDEX' "$LOAD_CONTEXT" | head -1 | cut -d: -f1)"
    if [ -n "$knowledge_line" ] && [ -n "$team_line" ] && [ "$team_line" -gt "$knowledge_line" ]; then
        pass "team index runs after the knowledge index"
    else
        fail_case "team index runs after the knowledge index"
    fi
fi

if [ "$(wc -l < "$ROOT/AGENTS.md")" -le 160 ]; then
    pass "AGENTS.md stays under 160 lines"
else
    fail_case "AGENTS.md stays under 160 lines"
fi

# --- trigger namespace and module counts ---
index_out="$(bash "$VALIDATOR" --index "$ROOT"/ai/policies/ai-policy-*.md "$ROOT"/ai/procedures/*.md 2>&1)"
index_rc=$?
summary="$(printf '%s\n' "$index_out" | grep '^summary|' | tail -1)"
if [ "$index_rc" -eq 0 ] && [ -n "$summary" ]; then
    pass "index oracle accepts the module set"
    for field in "modules=41" "policies=25" "procedures=16" "triggers=54" "conflicts=0" "errors=0"; do
        if printf '%s\n' "$summary" | grep -qF "$field"; then
            pass "index reports $field"
        else
            fail_case "index reports $field"
            printf '%s\n' "$summary"
        fi
    done
else
    fail_case "index oracle accepts the module set"
    printf '%s\n' "$index_out"
fi

# --- fixture store ---
for lesson in postgresql-connection-pool-exhaustion kubernetes-probe-timeout; do
    file="$FIXTURE/team-knowledge/$lesson.md"
    if [ -f "$file" ]; then
        pass "fixture lesson $lesson exists"
        present "$file" "title:" "fixture $lesson title"
        present "$file" "owner:" "fixture $lesson owner"
        present "$file" "source_project:" "fixture $lesson source project"
        present "$file" "created:" "fixture $lesson created"
        present "$file" "updated:" "fixture $lesson updated"
        present "$file" "tags: [" "fixture $lesson tags"
        present "$file" "status: active" "fixture $lesson status"
        present "$file" "superseded_by:" "fixture $lesson tombstone field"
        present "$file" "## Context" "fixture $lesson Context"
        present "$file" "## Rule or Fix" "fixture $lesson Rule or Fix"
        present "$file" "## Why" "fixture $lesson Why"
        present "$file" "## Verify" "fixture $lesson Verify"
        absent "$file" "**Knowledge file.**" "fixture $lesson omits the local knowledge header"
    else
        fail_case "fixture lesson $lesson exists"
    fi
done
if [ -d "$FIXTURE/missing-store" ]; then
    fail_case "fixture missing path stays absent"
else
    pass "fixture missing path stays absent"
fi
if [ -d "$FIXTURE/skills" ]; then
    pass "fixture holds the skills sibling"
else
    fail_case "fixture holds the skills sibling"
fi

# --- docs and validator ---
present "$ROOT/docs/ai-customization-guide.md" "Team AI Knowledge Directory" "guide documents the team directory key"
present "$ROOT/docs/ai-customization-guide.md" "Team AI Knowledge Repository" "guide documents the team repository key"
present "$ROOT/docs/ai-customization-guide.md" "team-knowledge/<lesson-name>.md" "guide uses the team-knowledge path"
present "$ROOT/docs/ai-customization-guide.md" "Class A" "guide states the destination class"
present "$ROOT/docs/ai-customization-guide.md" "local sensitive-names list" "guide keeps the local names list out"
present "$ROOT/docs/workflow-guide.md" "team-knowledge/" "workflow guide uses the team-knowledge path"
present "$ROOT/docs/simple-ai-workflow-slides.md" "team-knowledge/" "slides note uses the team-knowledge path"
present "$ROOT/README.md" "team-knowledge/" "README names the team-knowledge path"
present "$ROOT/docs/ai-customization.md" "team-alpha" "customization template shows a team-named root"
present "$ROOT/docs/slides/diagrams/knowledge-skills.svg" "team-knowledge/" "the diagram labels the team-knowledge path"
present "$ROOT/design-docs/protocol-decisions.md" "Team lessons are Class A" "ADR records the Class A rule"
present "$ROOT/design-docs/protocol-decisions.md" "Team skills are deferred" "ADR records the deferred team skills"
present "$ROOT/docs/ai-customization.md" "Team AI Knowledge Directory" "customization template has the team directory key"
present "$ROOT/docs/ai-customization.md" "Team AI Knowledge Repository" "customization template has the team repository key"
present "$ROOT/docs/announcements/v7.1.0.md" "# v7.1.0" "release announcement exists"
present "$MAIN_VALIDATOR" "POLICY_FLOOR=25" "validator policy floor is 25"
present "$MAIN_VALIDATOR" "Team AI Knowledge Directory" "validator checks the team directory key"
present "$MAIN_VALIDATOR" "Team AI Knowledge Repository" "validator checks the team repository key"
present "$MAIN_VALIDATOR" "team-knowledge/" "validator checks the team-knowledge path"

# --- live-path guard ---
LIVE_FILES=(
    "$POLICY"
    "$PROC"
    "$LOAD_CONTEXT"
    "$ROOT/docs/ai-customization-guide.md"
    "$ROOT/docs/workflow-guide.md"
    "$ROOT/docs/simple-ai-workflow-slides.md"
    "$ROOT/README.md"
    "$ROOT/docs/ai-customization.md"
    "$ROOT/docs/slides/diagrams/knowledge-skills.svg"
)
for live in "${LIVE_FILES[@]}"; do
    if [ ! -f "$live" ]; then
        fail_case "live file exists: $live"
        continue
    fi
    hits="$(grep -nF 'lessons/' "$live" || true)"
    if [ -n "$hits" ]; then
        fail_case "live file still names lessons/: $live"
        printf '%s\n' "$hits"
    else
        pass "live file uses team-knowledge/: $(basename "$live")"
    fi
done

if [ "$fail" -ne 0 ]; then
    echo "FAILED: team knowledge fixture."
    exit 1
fi
echo "PASSED: team knowledge fixture (policy, procedure, boot wiring, triggers, fixtures, docs)."
exit 0
