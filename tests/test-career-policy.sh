#!/bin/bash
# Dev-time fixture for the career policy rewrite: the expertise loading and the rule anchors.
# Usage: ./tests/test-career-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-career-coaching.md"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
fail=0

present() {
    local text="$1" label="$2"
    if grep -qF -- "$text" "$POLICY" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

present "## Loading" "policy declares its loading"
present "- Mode: expertise" "policy declares the expertise mode"
present "## Role: Career Coach and Hiring Manager" "role section"
present "hybrid" "role keeps the hybrid persona"
present "hiring manager" "role keeps the hiring-manager half"
present "career coach" "role keeps the coach half"
present "## Core Standards" "core standards section"
present "### ATS Compliance" "ATS compliance subsection"
present "### Conciseness" "conciseness subsection"
present "### Honest & Direct Feedback" "feedback subsection"
present "### Actionable Edits" "actionable edits subsection"
present "## Interview Coaching Protocol" "interview protocol section"
present "### STAR Method" "STAR section"
present "### Mock Session Rules" "mock session section"
present "Situation" "STAR: situation"
present "Task" "STAR: task"
present "Action" "STAR: action"
present "Result" "STAR: result"
present "400 words" "rule: cover letter length"
present "one question at a time" "rule: one question at a time"
present "## Testing and Validation" "testing section"
present "Keyword Match" "rule: keyword match"
present "## Examples" "example section"
present "non-normative" "examples are marked non-normative"
present "career-coaching" "customization sample is preserved"
present "## References" "references section"

if grep -q 'Sample Customization' "$POLICY" 2>/dev/null; then
    printf 'FAIL the old sample heading remains\n'
    fail=1
else
    printf 'PASS the old sample heading is gone\n'
fi

index_out="$(bash "$VALIDATOR" --index "$POLICY" 2>&1)"
if printf '%s\n' "$index_out" | grep -q '|career-coaching|'; then
    if printf '%s\n' "$index_out" | grep -q 'mode=expertise'; then
        printf 'PASS index reports the expertise mode\n'
    else
        printf 'FAIL index does not report the expertise mode\n'
        printf '%s\n' "$index_out"
        fail=1
    fi
else
    printf 'FAIL index does not list the policy\n'
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: career policy fixture."
    exit 1
fi
echo "PASSED: career policy fixture."
exit 0
