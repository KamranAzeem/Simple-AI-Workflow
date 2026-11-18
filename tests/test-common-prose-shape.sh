#!/bin/bash
# Dev-time fixture for the common-policy prose shape.
# Usage: ./tests/test-common-prose-shape.sh [policy-file]
# Exit 0 when the policy is rules-only and one sentence per item, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
F="${1:-$ROOT/ai/policies/ai-policy-common.md}"
fail=0

pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

start="$(grep -n '^<!-- AI-ASSISTANT: READ-ONLY START -->$' "$F" | cut -d: -f1 | head -1)"
end="$(grep -n '^<!-- AI-ASSISTANT: READ-ONLY END -->$' "$F" | cut -d: -f1 | head -1)"
if [ -z "$start" ] || [ -z "$end" ]; then
    echo "FAIL: the READ-ONLY markers are missing."
    exit 1
fi

body="$(sed -n "$((start + 1)),$((end - 1))p" "$F")"
clean="$(printf '%s\n' "$body" | awk '/^```/{f=!f; next} !f')"

# --- one sentence per list item; no banned normative word; one nesting level ---
purpose_allowed=0
bad_word=0
bad_sentence=0
bad_prose=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in
        '#'*) continue ;;
        '<!--'*) continue ;;
    esac
    if [[ "$line" == '**'*'**' ]] && [[ "$line" != *': '* ]]; then
        continue
    fi
    if [[ "$line" =~ ^[[:space:]]*([-*]|[0-9]+\.)[[:space:]] ]]; then
        item="$(printf '%s\n' "$line" | sed -E 's/^[[:space:]]*([-*]|[0-9]+\.)[[:space:]]+//')"
        item="$(printf '%s\n' "$item" | sed -E 's/`[^`]*`/code/g; s/\be\.g\./eg/g; s/\bi\.e\./ie/g; s/\bvs\./vs/g')"
        if printf '%s\n' "$item" | grep -Eqi '\b(should|prefer|consider|try|appropriate|reasonable|small|large|etc)\b'; then
            printf 'FAIL banned word: %s\n' "$line"
            bad_word=1
        fi
        if printf '%s\n' "$item" | grep -Eq '[.!?][[:space:]]+[A-Z`]'; then
            printf 'FAIL multi-sentence item: %s\n' "$line"
            bad_sentence=1
        fi
        if [[ "$line" =~ ^[[:space:]]{6,} ]]; then
            printf 'FAIL nesting deeper than one level: %s\n' "$line"
            bad_sentence=1
        fi
        continue
    fi
    if [ "$purpose_allowed" -eq 0 ]; then
        purpose_allowed=1
        continue
    fi
    printf 'FAIL prose outside a rule: %s\n' "$line"
    bad_prose=1
done <<< "$clean"

[ "$bad_word" -eq 0 ] || fail=1
[ "$bad_sentence" -eq 0 ] || fail=1
[ "$bad_prose" -eq 0 ] || fail=1
[ "$bad_word" -eq 0 ] && pass 'no banned normative word'
[ "$bad_sentence" -eq 0 ] && pass 'one sentence per item and at most one nesting level'
[ "$bad_prose" -eq 0 ] && pass 'no prose outside rules'

# --- compatibility anchors ---
for anchor in '## Skills' '200 characters' 'the user is responsible' '## Outbound Content Scrub' 'The outbound-content-scrub contract owns' '## Knowledge Invariant' 'Global AI Settings Directory' '## Issue Invariant' '## Design Invariant' 'the thinking-modes contract' '## State File Ownership Protocol' '### Canonical State-File Headers' '## Markdown Output' 'Humanized Output'; do
    if printf '%s\n' "$clean" | grep -qF "$anchor"; then
        :
    else
        fail_case "missing anchor: $anchor"
    fi
done

if printf '%s\n' "$clean" | grep -q 'Class A, internal or same audience'; then
    fail_case 'the common policy names Class A'
fi
if printf '%s\n' "$clean" | grep -q 'Class B, external or different audience'; then
    fail_case 'the common policy names Class B'
fi
if printf '%s\n' "$clean" | grep -Eq 'ai-policy-[a-z0-9-]+\.md'; then
    fail_case 'the common policy names a policy file'
fi
if printf '%s\n' "$clean" | grep -Eq '^## (Loading|Triggers)$'; then
    fail_case 'the common policy declares Loading or Triggers'
fi
for phrase in 'Squash-merge to trunk' 'Run the checkpoint on the branch' 'Attach the final plan' 'Replace the active plan link' 'replace its link with'; do
    if printf '%s\n' "$clean" | grep -Fqi "$phrase"; then
        fail_case "ordered-close phrase in the common policy: $phrase"
    fi
done

refs="$(printf '%s\n' "$clean" | awk '/^## References$/{f=1;next} f{print}')"
ref_count="$(printf '%s\n' "$refs" | grep -cE '^- ' || true)"
if [ "$ref_count" -ne 2 ]; then
    fail_case "the References section has $ref_count bullets"
fi

if [ "$fail" -eq 0 ]; then
    echo "PASSED: common-policy prose shape."
    exit 0
fi
echo "FAILED: common-policy prose shape."
exit 1
