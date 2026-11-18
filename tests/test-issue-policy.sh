#!/bin/bash
# Dev-time fixture for the issue-management plug-in boundary and loads.
# Usage: ./tests/test-issue-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
ISSUE="$ROOT/ai/policies/ai-policy-issue-management.md"
MANAGE="$ROOT/ai/procedures/manage-issues.md"
IMPLEMENT="$ROOT/ai/procedures/implement-plan.md"
LOADCTX="$ROOT/ai/procedures/load-context.md"
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

present "$COMMON" "## Issue Invariant" "common has the issue invariant"
absent "$COMMON" "### Work-Item Invariants" "common no longer holds the work-item rules"
present "$ISSUE" "- issue standards" "plug-in declares the issue trigger"
present "$ISSUE" "- ticket standards" "plug-in declares the ticket trigger"
present "$ISSUE" "- Mode: trigger" "plug-in declares the trigger mode"
present "$ISSUE" "### Ticket Fields" "plug-in holds the ticket fields"
present "$ISSUE" "### Plan" "plug-in holds the plan rules"
present "$ISSUE" "### Work-Item Invariants" "plug-in holds the work-item rules"
present "$ISSUE" "ai/shared/project-knowledge/issue-template.md" "plug-in owns the template rule"
present "$LOADCTX" "ai-policy-issue-management.md" "load-context loads the plug-in for a missing template"
present "$LOADCTX" "### Ticket Fields" "load-context builds the template from the fields"
present "$MANAGE" "ai-policy-issue-management.md" "manage-issues loads the plug-in"
present "$IMPLEMENT" "ai-policy-issue-management.md" "implement-plan loads the plug-in"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: issue-management plug-in fixture."
    exit 1
fi
echo "PASSED: issue-management plug-in fixture."
exit 0
