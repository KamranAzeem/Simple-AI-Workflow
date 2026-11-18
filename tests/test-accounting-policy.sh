#!/bin/bash
# Dev-time fixture for the accounting policy rewrite: the expertise loading and the rule anchors.
# Usage: ./tests/test-accounting-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-accounting.md"
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
present "## Role: Accounting and Financial Analyst" "role section"
present "## Accounting Standards" "accounting standards section"
present "## Data Integrity and Confidentiality" "data integrity section"
present "**Accuracy First**" "rule: accuracy first"
present "**Double-Entry Principle**" "rule: double-entry"
present "**Materiality**" "rule: materiality"
present "**Consistency**" "rule: consistency"
present "**Going Concern**" "rule: going concern"
present "**Confidentiality**" "rule: confidentiality"
present "**Data Retention**" "rule: data retention"
present "**Reconciliation**" "rule: reconciliation"
present "**Audit Trail**" "rule: audit trail"
present "**Balance Check**" "rule: balance check"
present "**Cross-Verification**" "rule: cross-verification"
present "**Reasonableness Test**" "rule: reasonableness"
present "trial balance" "rule: trial balance"
present "seven years" "rule: retention example"
present "GAAP" "reference: GAAP"
present "IFRS" "reference: IFRS"
present "## Examples" "example section"
present "non-normative" "example is marked non-normative"

if grep -q 'Assistant Prompt' "$POLICY" 2>/dev/null; then
    printf 'FAIL the old prompt section heading remains\n'
    fail=1
else
    printf 'PASS the old prompt section heading is gone\n'
fi

index_out="$(bash "$VALIDATOR" --index "$POLICY" 2>&1)"
if printf '%s\n' "$index_out" | grep -q '|accounting|'; then
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
    echo "FAILED: accounting policy fixture."
    exit 1
fi
echo "PASSED: accounting policy fixture."
exit 0
