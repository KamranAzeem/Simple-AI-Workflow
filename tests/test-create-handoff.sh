#!/bin/bash
# Dev-time fixture for the handoff policy and procedure.
# Usage: ./tests/test-create-handoff.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/tests/handoff"
POLICY="$ROOT/ai/policies/ai-policy-handoff.md"
PROCEDURE="$ROOT/ai/procedures/create-handoff.md"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
WORK="$(mktemp -d /tmp/kilo/handoff-fixture.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT
FAIL=0

present() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file"; then
        echo "PASS: $label"
    else
        echo "FAIL: $label"
        FAIL=1
    fi
}

absent() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file"; then
        echo "FAIL: $label"
        FAIL=1
    else
        echo "PASS: $label"
    fi
}

sections=(
    "## Objective"
    "## Authorization"
    "## Read first"
    "## Scope"
    "## Starting facts"
    "## Steps"
    "## Binding rules"
    "## Shared output paths"
    "## Report back"
    "## Review"
    "## Verification"
)

echo "Policy template and procedure anchors."
for s in "${sections[@]}"; do
    name="${s#\#\# }"
    present "$POLICY" "**$name**" "policy template has $name"
done
present "$PROCEDURE" "- create handoff" "procedure trigger create handoff"
present "$PROCEDURE" "- create a handoff" "procedure trigger create a handoff"
present "$PROCEDURE" "STEP-REVIEW-HANDOFF" "procedure has the review step"
present "$PROCEDURE" "STEP-FINALIZE" "procedure has the finalize step"
present "$PROCEDURE" "STEP-REPORT-HANDOFF" "procedure has the report step"

echo "Valid draft section order."
for s in "${sections[@]}"; do
    present "$DIR/valid-handoff-draft.md" "$s" "valid draft has $s"
done
for s in "${sections[@]}"; do
    present "$DIR/valid-handoff-final.md" "$s" "final handoff has $s"
done
present "$DIR/valid-handoff-final.md" "## Completion" "final handoff has the completion note"

echo "Incomplete draft is refused."
absent "$DIR/invalid-handoff-draft.md" "## Objective" "incomplete draft has no Objective"
absent "$DIR/invalid-handoff-draft.md" "## Scope" "incomplete draft has no Scope"
absent "$DIR/invalid-handoff-draft.md" "## Report back" "incomplete draft has no Report back"
present "$POLICY" "Refuse a handoff that lacks any required section" "policy refuses a missing section"

echo "Trigger namespace and procedure shape."
if bash "$VALIDATOR" --triggers "$PROCEDURE" "$POLICY" >"$WORK/triggers.log" 2>&1; then
    echo "PASS: trigger namespace"
else
    echo "FAIL: trigger namespace"
    cat "$WORK/triggers.log"
    FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
    echo "FAILED: handoff fixture."
    exit 1
fi
echo "PASSED: handoff fixtures and anchors."
exit 0
