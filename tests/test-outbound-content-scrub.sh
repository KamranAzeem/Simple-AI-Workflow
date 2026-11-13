#!/bin/bash
# Dev-time fixture for the outbound content scrub contract.
# Usage: ./tests/test-outbound-content-scrub.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/tests/outbound-content-scrub"
FAIL=0

present() {
    local file="$1" text="$2" label="$3"
    if grep -qF "$text" "$file"; then
        echo "PASS: $label"
    else
        echo "FAIL: $label"
        FAIL=1
    fi
}

absent() {
    local file="$1" text="$2" label="$3"
    if grep -qF "$text" "$file"; then
        echo "FAIL: $label"
        FAIL=1
    else
        echo "PASS: $label"
    fi
}

echo "Class A fixture: same customer keeps names and infrastructure detail."
present "$DIR/class-a-input.md" "api_live_EXAMPLE_TOKEN_123" "Class A input contains the token"
absent "$DIR/class-a-expected.md" "api_live_EXAMPLE_TOKEN_123" "Class A expected removes the token"
present "$DIR/class-a-expected.md" "<redacted-secret>" "Class A expected has the secret placeholder"
present "$DIR/class-a-expected.md" "Jane" "Class A expected keeps the customer contact"
present "$DIR/class-a-expected.md" "Acme Corporation" "Class A expected keeps the customer name"
present "$DIR/class-a-expected.md" "app.acme.internal" "Class A expected keeps the internal host"
present "$DIR/class-a-expected.md" "10.20.30.40" "Class A expected keeps the private IP"

echo "Class B fixture: external audience removes names and internal detail."
present "$DIR/class-b-input.md" "Jane Doe" "Class B input contains the person name"
present "$DIR/class-b-input.md" "Acme Corporation" "Class B input contains the company name"
present "$DIR/class-b-input.md" "app.acme.internal" "Class B input contains the internal host"
present "$DIR/class-b-input.md" "8.8.8.8" "Class B input contains the public IP"
present "$DIR/class-b-input.md" "jane.doe@acme.example" "Class B input contains the email"
present "$DIR/class-b-input.md" "550e8400-e29b-41d4-a716-446655440000" "Class B input contains the GUID"
present "$DIR/class-b-input.md" "api_live_EXAMPLE_TOKEN_123" "Class B input contains the token"

absent "$DIR/class-b-expected.md" "Jane Doe" "Class B expected removes the person name"
absent "$DIR/class-b-expected.md" "Acme Corporation" "Class B expected removes the company name"
absent "$DIR/class-b-expected.md" "app.acme.internal" "Class B expected removes the internal host"
absent "$DIR/class-b-expected.md" "wiki.acme.internal" "Class B expected removes the internal wiki host"
absent "$DIR/class-b-expected.md" "8.8.8.8" "Class B expected removes the public IP"
absent "$DIR/class-b-expected.md" "jane.doe@acme.example" "Class B expected removes the email"
absent "$DIR/class-b-expected.md" "550e8400-e29b-41d4-a716-446655440000" "Class B expected removes the GUID"
absent "$DIR/class-b-expected.md" "api_live_EXAMPLE_TOKEN_123" "Class B expected removes the token"
present "$DIR/class-b-expected.md" "10.20.30.0/24" "Class B expected keeps the private subnet"
present "$DIR/class-b-expected.md" "192.0.2.10" "Class B expected uses a documentation address"
present "$DIR/class-b-expected.md" "user@example.com" "Class B expected uses the email placeholder"
present "$DIR/class-b-expected.md" "<redacted-id>" "Class B expected uses the identifier placeholder"
present "$DIR/class-b-expected.md" "<redacted-secret>" "Class B expected uses the secret placeholder"
present "$DIR/class-b-expected.md" "<internal-host>" "Class B expected uses the internal-host placeholder"

echo "Policy and procedure anchors."
present "$ROOT/ai/policies/ai-policy-common.md" "## Outbound Content Scrub" "common policy has the section"
present "$ROOT/ai/policies/ai-policy-common.md" "Class A, internal or same audience" "common policy defines Class A"
present "$ROOT/ai/policies/ai-policy-common.md" "Class B, external or different audience" "common policy defines Class B"
present "$ROOT/ai/policies/ai-policy-common.md" "Remove passwords, tokens" "common policy removes secrets in every class"
present "$ROOT/ai/procedures/manage-issues.md" "STEP-SCRUB-OUTBOUND" "manage-issues defines the scrub step"
present "$ROOT/ai/procedures/implement-plan.md" "STEP-SCRUB-OUTBOUND" "implement-plan references the scrub step"

if [ "$FAIL" -ne 0 ]; then
    echo "FAILED: outbound content scrub fixture."
    exit 1
fi
echo "PASSED: outbound content scrub fixtures and policy anchors."
exit 0
