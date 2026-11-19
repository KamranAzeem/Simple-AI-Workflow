#!/bin/bash
# Dev-time fixture for the design-docs merge, its loading declaration, and the planning loads.
# Usage: ./tests/test-design-docs-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
POLICY="$ROOT/ai/policies/ai-policy-design-docs.md"
MANAGE="$ROOT/ai/procedures/manage-issues.md"
IMPLEMENT="$ROOT/ai/procedures/implement-plan.md"
UPDATE="$ROOT/ai/procedures/update-design-docs.md"
MIGRATE="$ROOT/ai/procedures/migrate-design-docs.md"
fail=0

present() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

absent() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'FAIL %s\n' "$label"
        fail=1
    else
        printf 'PASS %s\n' "$label"
    fi
}

present "$COMMON" "## Design Invariant" "common has the design invariant"
absent "$COMMON" "### Document Chain" "common no longer holds the document chain"
absent "$COMMON" "ai-policy-design-docs.md" "common names no design policy file"
present "$POLICY" "- Mode: procedure" "policy declares the procedure mode"
present "$POLICY" "- Load in: update-design-docs" "policy names the update procedure"
absent "$POLICY" "Loaded by the update-design-docs procedure module" "the loading note is replaced by a purpose"
present "$POLICY" "Document Chain" "policy holds the document chain"
present "$POLICY" "Requirement Gathering" "policy holds requirement gathering"
present "$POLICY" "Proportional Depth" "policy holds proportional depth"
present "$POLICY" "Layering" "policy holds layering"
present "$POLICY" "At the start of each session" "policy holds the session-start artifact check"
present "$POLICY" "Never reuse or delete an ID" "policy holds the ID rule"
present "$POLICY" "Not Started" "policy holds the ledger status values"
present "$POLICY" "Supplementary Documents" "policy holds the supplementary documents"
present "$POLICY" "Update Discipline" "policy holds the update discipline"
present "$POLICY" "Plans live under" "policy holds the plan-location rule"
present "$POLICY" "write the ADR entry for a protocol change as part of that change" "policy states the developer-mode ADR rule"
present "$POLICY" "trigger is not required for that ADR entry" "policy states the trigger is not required"
present "$MANAGE" "ai-policy-design-docs.md" "manage-issues loads the policy"
present "$IMPLEMENT" "ai-policy-design-docs.md" "implement-plan loads the policy"
present "$UPDATE" "ai-policy-design-docs.md" "update-design-docs loads the policy"
present "$MIGRATE" "ai-policy-design-docs.md" "migrate-design-docs loads the policy"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: design-docs policy fixture."
    exit 1
fi
echo "PASSED: design-docs policy fixture."
exit 0
