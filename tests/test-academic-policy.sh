#!/bin/bash
# Dev-time fixture for the academic policy rewrite: the expertise loading, the sections, and the anchors.
# Usage: ./tests/test-academic-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-academic-researcher.md"
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
present "## Role: Senior Research Collaborator, Mentor and Integrity Advisor" "role section"
present "## 1. Governing Frameworks" "frameworks section"
present "## 2. Core Integrity Principles" "core principles section"
present "## 3. Source Quality and Evidence Standards" "source quality section"
present "## 4. Ethical Rules: DO" "ethical DO section"
present "## 5. Unethical Practices: DO NOT" "DO NOT section"
present "## 17. Research Process Workflow" "process section"
present "## 18. Literature Review Standards" "literature section"
present "## 22. Verification and Validation" "verification section"
present "### Stage 1: Formulating the research problem" "stage 1"
present "### Stage 9: Preparation of the manuscript" "stage 9"
present "Singapore Statement" "framework: Singapore Statement"
present "ALLEA" "framework: ALLEA"
present "ORI" "framework: ORI"
present "COPE" "framework: COPE"
present "ICMJE" "framework: ICMJE"
present "CRediT" "framework: CRediT"
present "FAIR" "framework: FAIR"
present "Helsinki" "framework: Helsinki"
present "Belmont" "framework: Belmont"
present "Menlo" "framework: Menlo"
present "GDPR" "framework: GDPR"
present "Q1" "source quality: Q1"
present "PREPRINT: not peer-reviewed" "source quality: preprint label"
present "VENUE UNVERIFIED" "source quality: unverified venue label"
present "Think. Check. Submit." "source quality: predatory screening"
present "CORE A*" "source quality: CORE ranking"
present "fabricate" "ethics: fabrication"
present "plagiaris" "ethics: plagiarism"
present "iThenticate" "plagiarism: originality check"
present "Plan S" "open access: Plan S"
present "IRB" "human subjects: IRB"
present "ISO/IEC 29147" "security: coordinated disclosure"
present "effect size" "statistics: effect size"
present "PRISMA" "literature: PRISMA"
present "literature matrix" "literature: matrix"
present "non-normative" "example is marked non-normative"
present "## References" "references section"

if grep -q 'Appendix: Gaps Identified' "$POLICY" 2>/dev/null; then
    printf 'FAIL the changelog appendix remains\n'
    fail=1
else
    printf 'PASS the changelog appendix is gone\n'
fi

checkpoint_count="$(grep -c 'Supervision checkpoint' "$POLICY" 2>/dev/null || true)"
if [ "$checkpoint_count" = "3" ]; then
    printf 'PASS all three supervision checkpoints are present\n'
else
    printf 'FAIL expected 3 supervision checkpoints, found %s\n' "$checkpoint_count"
    fail=1
fi

index_out="$(bash "$VALIDATOR" --index "$POLICY" 2>&1)"
if printf '%s\n' "$index_out" | grep -q '|academic-researcher|'; then
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
    echo "FAILED: academic policy fixture."
    exit 1
fi
echo "PASSED: academic policy fixture."
exit 0
