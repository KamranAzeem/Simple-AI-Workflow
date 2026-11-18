#!/bin/bash
# Dev-time fixture for the common-policy boundary rule.
# Usage: ./tests/test-common-boundary.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
HANDOFF="$ROOT/ai/policies/ai-policy-handoff.md"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail=0
pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

start_line="$(grep -n '^<!-- AI-ASSISTANT: READ-ONLY START -->$' "$COMMON" | cut -d: -f1 | head -1)"
if [ -z "$start_line" ]; then
    fail_case 'the READ-ONLY START marker is missing'
else
    title="$(awk -v start="$start_line" 'NR > start && /^# / { print; exit }' "$COMMON")"
    if [ "$title" = "# AI Policy: Common Guardrails" ]; then
        pass 'the title follows the authoring standard'
    else
        fail_case "the title is '$title'"
    fi

    if [ -n "$(sed -n "$((start_line - 1))p" "$COMMON")" ]; then
        fail_case 'a blank line is missing before the READ-ONLY START marker'
    else
        pass 'a blank line separates the guard and the START marker'
    fi
fi

if grep -q 'DO NOT MODIFY' <(sed -n '1p' "$COMMON"); then
    pass 'the guard line is present'
else
    fail_case 'the guard line is missing'
fi

body="$(awk '
    /^<!-- STATE-FILE-HEADER: .* START -->$/ { in_header = 1; next }
    in_header && /^<!-- STATE-FILE-HEADER: .* END -->$/ { in_header = 0; next }
    !in_header { print }
' "$COMMON")"
policy_names="$(printf '%s\n' "$body" | grep -nE 'ai-policy-[a-z0-9-]+\.md' || true)"
if [ -n "$policy_names" ]; then
    fail_case 'the common policy names a policy file'
    printf '%s\n' "$policy_names"
else
    pass 'the common policy names no policy file'
fi

refs="$(awk '/^## References[[:space:]]*$/{f=1;next} f && /^<!-- AI-ASSISTANT: READ-ONLY END -->/{exit} f' "$COMMON")"
ref_count="$(printf '%s\n' "$refs" | grep -cE '^- ' || true)"
ref_nonblank="$(printf '%s\n' "$refs" | grep -c . || true)"
if [ "$ref_count" -eq 2 ] && [ "$ref_nonblank" -eq 2 ]; then
    pass 'the References section has exactly two bullets'
else
    fail_case "the References section has $ref_count bullets and $ref_nonblank non-blank lines"
fi
if printf '%s\n' "$refs" | grep -qF 'AGENTS.md'; then
    pass 'References names AGENTS.md'
else
    fail_case 'References does not name AGENTS.md'
fi
if printf '%s\n' "$refs" | grep -qF 'procedure layer'; then
    pass 'References names the procedure layer'
else
    fail_case 'References does not name the procedure layer'
fi

if grep -qF 'Rely on the always-on pointer' "$HANDOFF"; then
    fail_case 'the handoff policy still relies on the common pointer'
else
    pass 'the handoff policy no longer relies on the common pointer'
fi

mkdir -p "$WORK/ai/policies"
{
    printf '# DO NOT MODIFY THIS FILE\n\n'
    printf 'Fixture guard.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n'
    printf '# AI Assistant Policy: Common Guardrails & Contracts\n\n'
    printf 'Govern the fixture.\n\n'
    printf '## Scope\n\n- Fixture scope.\n\n'
    printf '## Rules\n\n- Follow the fixture.\n\n'
    printf '## References\n\n- Fixture.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
} > "$WORK/ai/policies/ai-policy-common.md"
out="$(bash "$VALIDATOR" "$WORK/ai/policies/ai-policy-common.md" 2>&1)"
rc=$?
if [ "$rc" -ne 0 ] && printf '%s\n' "$out" | grep -q 'invalid policy shape: missing policy title'; then
    pass 'the validator rejects the legacy common title'
else
    fail_case 'the validator still accepts the legacy common title'
    printf '%s\n' "$out"
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: common-policy boundary fixture."
    exit 1
fi
echo "PASSED: common-policy boundary fixture."
exit 0
