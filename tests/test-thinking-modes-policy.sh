#!/bin/bash
# Dev-time fixture for the thinking-modes plug-in boundary and loads.
# Usage: ./tests/test-thinking-modes-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
MODES="$ROOT/ai/policies/ai-policy-thinking-modes.md"
MANAGE="$ROOT/ai/procedures/manage-issues.md"
IMPLEMENT="$ROOT/ai/procedures/implement-plan.md"
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

present "$COMMON" "## Thinking Modes" "common has the thinking-modes invariant"
absent "$COMMON" "## Grilling" "common no longer holds the grilling mode"
absent "$COMMON" "## Brainstorming" "common no longer holds the brainstorming mode"
absent "$COMMON" "ai-policy-thinking-modes.md" "common names no thinking-modes policy file"
present "$COMMON" "the thinking-modes contract" "the Pre-Work Gate points at the contract"
present "$MODES" "- grill me" "plug-in declares the grilling trigger"
present "$MODES" "- brainstorm" "plug-in declares the brainstorming trigger"
present "$MODES" "- Mode: trigger" "plug-in declares the trigger mode"
present "$MODES" "## Grilling" "plug-in holds the grilling mode"
present "$MODES" "## Brainstorming" "plug-in holds the brainstorming mode"
present "$MANAGE" "ai-policy-thinking-modes.md" "manage-issues loads the plug-in"
present "$IMPLEMENT" "ai-policy-thinking-modes.md" "implement-plan loads the plug-in"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: thinking-modes plug-in fixture."
    exit 1
fi
echo "PASSED: thinking-modes plug-in fixture."
exit 0
