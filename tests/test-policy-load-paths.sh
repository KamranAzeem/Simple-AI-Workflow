#!/bin/bash
# Dev-time fixture for the policy ## Loading contract and load-path resolution.
# Usage: ./tests/test-policy-load-paths.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
PROCEDURES="$ROOT"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() {
    printf 'FAIL %s\n' "$1"
    fail=1
}

write_policy() {
    local path="$1" purpose="$2" body="$3"
    mkdir -p "$(dirname "$path")"
    {
        printf '# DO NOT MODIFY THIS FILE\n\n'
        printf 'Fixture policy.\n\n'
        printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n'
        printf '# AI Policy: Fixture\n\n'
        printf '%s\n\n' "$purpose"
        printf '%s' "$body"
        printf '\n## Scope\n\n- Fixture scope.\n\n'
        printf '## Rules\n\n- Follow the fixture.\n\n'
        printf '## References\n\n- Fixture.\n\n'
        printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
    } > "$path"
}

expect_pass() {
    local name="$1" file="$2" out rc
    out="$(bash "$VALIDATOR" "$file" 2>&1)"
    rc=$?
    if [ "$rc" -ne 0 ]; then
        fail_case "$name: validator rejected a valid policy"
        printf '%s\n' "$out"
        return
    fi
    pass "$name"
}

expect_fail() {
    local name="$1" pattern="$2" file="$3" out rc
    out="$(bash "$VALIDATOR" "$file" 2>&1)"
    rc=$?
    if [ "$rc" -eq 0 ]; then
        fail_case "$name: validator accepted an invalid policy"
        printf '%s\n' "$out"
        return
    fi
    if ! printf '%s\n' "$out" | grep -qF "$pattern"; then
        fail_case "$name: missing '$pattern'"
        printf '%s\n' "$out"
        return
    fi
    pass "$name"
}

p() { printf '%s/ai/policies/ai-policy-%s.md' "$WORK" "$1"; }

# Valid declarations, one per mode.
write_policy "$(p pass-boot)" 'Govern the fixture.' $'## Loading\n- Mode: boot\n'
expect_pass 'valid boot mode' "$(p pass-boot)"

write_policy "$(p pass-trigger)" 'Govern the fixture.' $'## Triggers\n- fixture phrase\n\n## Loading\n- Mode: trigger\n'
expect_pass 'valid trigger mode' "$(p pass-trigger)"

write_policy "$(p pass-procedure)" 'Govern the fixture.' $'## Loading\n- Mode: procedure\n- Load in: manage-issues\n'
expect_pass 'valid procedure mode' "$(p pass-procedure)"

write_policy "$(p pass-expertise)" 'Govern the fixture.' $'## Loading\n- Mode: expertise\n'
expect_pass 'valid expertise mode' "$(p pass-expertise)"

write_policy "$(p pass-legacy)" 'Govern the fixture.' ''
expect_pass 'absent Loading stays valid' "$(p pass-legacy)"

# Invalid declarations.
write_policy "$(p fail-mode)" 'Govern the fixture.' $'## Loading\n- Mode: sometimes\n'
expect_fail 'unknown mode' 'invalid loading block: unknown mode' "$(p fail-mode)"

write_policy "$(p fail-key)" 'Govern the fixture.' $'## Loading\n- Mode: boot\n- When: always\n'
expect_fail 'unknown key' 'invalid loading block: unknown key' "$(p fail-key)"

write_policy "$(p fail-no-mode)" 'Govern the fixture.' $'## Loading\n- Load in: manage-issues\n'
expect_fail 'missing mode' 'invalid loading block: missing Mode' "$(p fail-no-mode)"

write_policy "$(p fail-proc-no-target)" 'Govern the fixture.' $'## Loading\n- Mode: procedure\n'
expect_fail 'procedure without Load in' 'invalid loading block: procedure mode needs Load in' "$(p fail-proc-no-target)"

write_policy "$(p fail-bad-target)" 'Govern the fixture.' $'## Loading\n- Mode: procedure\n- Load in: Manage Issues\n'
expect_fail 'invalid Load in value' 'invalid loading block: invalid Load in value' "$(p fail-bad-target)"

write_policy "$(p fail-dup-target)" 'Govern the fixture.' $'## Loading\n- Mode: procedure\n- Load in: manage-issues\n- Load in: load-context\n'
expect_fail 'duplicate Load in' 'invalid loading block: duplicate Load in' "$(p fail-dup-target)"

write_policy "$(p fail-boot-target)" 'Govern the fixture.' $'## Loading\n- Mode: boot\n- Load in: manage-issues\n'
expect_fail 'Load in without procedure mode' 'invalid loading block: Load in without procedure mode' "$(p fail-boot-target)"

write_policy "$(p fail-trigger-empty)" 'Govern the fixture.' $'## Loading\n- Mode: trigger\n'
expect_fail 'trigger mode without a trigger' 'invalid loading block: trigger mode needs a trigger' "$(p fail-trigger-empty)"

write_policy "$(p fail-mode-triggers)" 'Govern the fixture.' $'## Triggers\n- fixture phrase\n\n## Loading\n- Mode: boot\n'
expect_fail 'triggers not allowed for a non-trigger mode' 'invalid loading block: triggers not allowed for this mode' "$(p fail-mode-triggers)"

write_policy "$(p fail-duplicate)" 'Govern the fixture.' $'## Loading\n- Mode: boot\n\n## Loading\n- Mode: expertise\n'
expect_fail 'duplicate Loading section' 'invalid loading block: duplicate loading section' "$(p fail-duplicate)"

# Placement after Scope must fail.
mkdir -p "$WORK/ai/policies"
{
    printf '# DO NOT MODIFY THIS FILE\n\nFixture policy.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n# AI Policy: Fixture\n\nGovern the fixture.\n\n'
    printf '## Scope\n\n- Fixture scope.\n\n'
    printf '## Loading\n- Mode: boot\n\n'
    printf '## Rules\n\n- Follow the fixture.\n\n## References\n\n- Fixture.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
} > "$(p fail-placement)"
expect_fail 'placement after Scope' 'invalid loading block: placement' "$(p fail-placement)"

# Prose between the purpose and Loading must fail.
mkdir -p "$WORK/ai/policies"
{
    printf '# DO NOT MODIFY THIS FILE\n\nFixture policy.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n# AI Policy: Fixture\n\nGovern the fixture.\n\n'
    printf 'Stray prose before the declaration.\n\n'
    printf '## Loading\n- Mode: boot\n\n'
    printf '## Scope\n\n- Fixture scope.\n\n'
    printf '## Rules\n\n- Follow the fixture.\n\n## References\n\n- Fixture.\n\n'
    printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
} > "$(p fail-intervening)"
expect_fail 'prose before Loading' 'invalid loading block: placement' "$(p fail-intervening)"

# Repository checks.

repo_policies=("$ROOT"/ai/policies/ai-policy-*.md)
missing_target=0
for policy in "${repo_policies[@]}"; do
    while IFS= read -r target; do
        [ -n "$target" ] || continue
        if [ ! -f "$PROCEDURES/ai/procedures/$target.md" ]; then
            fail_case "policy $(basename "$policy") names missing procedure '$target'"
            missing_target=1
        fi
    done < <(awk '
        /^## Loading[[:space:]]*$/ { in_load = 1; next }
        in_load && /^##[[:space:]]/ { in_load = 0 }
        in_load && /^- Load in: / { sub(/^- Load in: /, ""); print }
    ' "$policy")
done
[ "$missing_target" -eq 0 ] && pass 'every repo Load in names an existing procedure'

missing_policy=0
for proc in "$ROOT"/ai/procedures/*.md; do
    while IFS= read -r name; do
        [ -n "$name" ] || continue
        if [ ! -f "$ROOT/ai/policies/$name" ]; then
            fail_case "procedure $(basename "$proc") names missing policy '$name'"
            missing_policy=1
        fi
    done < <(grep -ohE 'ai-policy-[a-z0-9-]+\.md' "$proc" | sort -u)
done
[ "$missing_policy" -eq 0 ] && pass 'every policy named in a procedure exists'

# Index mode and scope.
PROJECT="$WORK/project"
mkdir -p "$PROJECT/ai/policies"
write_policy "$PROJECT/ai/policies/ai-policy-project.md" 'Govern the fixture.' $'## Loading\n- Mode: boot\n'
index_out="$(cd "$PROJECT" && bash "$VALIDATOR" --index ai/policies/ai-policy-project.md 2>&1)"
index_rc=$?
if [ "$index_rc" -ne 0 ]; then
    fail_case 'index oracle failed on the project fixture'
    printf '%s\n' "$index_out"
elif ! printf '%s\n' "$index_out" | grep -q 'mode=boot'; then
    fail_case 'index oracle does not print the declared mode'
    printf '%s\n' "$index_out"
elif ! printf '%s\n' "$index_out" | grep -q '|project|'; then
    fail_case 'index oracle does not report project scope'
    printf '%s\n' "$index_out"
else
    pass 'index reports mode and project scope'
fi

assert_mode() {
    local policy="$1" mode="$2" out
    out="$(bash "$VALIDATOR" --index "$ROOT/ai/policies/$policy" 2>&1)"
    if ! printf '%s\n' "$out" | grep -q "mode=$mode"; then
        fail_case "index oracle does not report mode=$mode for $policy"
        printf '%s\n' "$out"
        return 1
    fi
    if ! printf '%s\n' "$out" | grep -q '|global|'; then
        fail_case "index oracle does not report global scope for $policy"
        printf '%s\n' "$out"
        return 1
    fi
    pass "index reports mode=$mode and global scope for $policy"
}

# `common` is the recorded exemption: STEP-WORKFLOW-ACCESS loads it before any policy scan.
assert_mode ai-policy-common.md legacy
assert_mode ai-policy-cloud.md trigger
assert_mode ai-policy-code-review.md procedure
assert_mode ai-policy-web-frontend.md expertise

if [ "$fail" -ne 0 ]; then
    echo "FAILED: policy loading fixture."
    exit 1
fi
echo "PASSED: policy loading fixture (modes, errors, placement, load paths, index scope)."
exit 0
