#!/bin/bash
# Dev-time fixture for the optional protocol index helper.
# The boot builds its index with built-in tools; this helper is a maintainer tool.
# Usage: ./tests/test-protocol-index.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HELPER="$ROOT/support-files/index-protocol.sh"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
fail=0

pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

write_policy() {
    local path="$1" title="$2" trigger="${3:-}"
    {
        printf '# DO NOT MODIFY THIS FILE\n\n'
        printf 'Fixture.\n\n'
        printf '<!-- AI-ASSISTANT: READ-ONLY START -->\n\n'
        printf '# AI Policy: %s\n\n' "$title"
        printf 'Govern the fixture.\n\n'
        if [ -n "$trigger" ]; then
            printf '## Triggers\n\n- %s\n\n' "$trigger"
        fi
        printf '## Scope\n\n- Fixture.\n\n'
        printf '## Rules\n\n- Follow the fixture.\n\n'
        printf '## References\n\n- Fixture.\n\n'
        printf '<!-- AI-ASSISTANT: READ-ONLY END -->\n'
    } > "$path"
}

module_line() {
    printf '%s\n' "$1" | awk -F'|' -v t="$2" -v s="$3" -v n="$4" \
        '$1==t && $2==s && $3==n {print; exit}'
}

field() {
    printf '%s\n' "$1" | awk -F'|' -v f="$2" '{print $f; exit}'
}

assert_contains() {
    local haystack="$1" needle="$2" label="$3"
    if printf '%s\n' "$haystack" | grep -qF -- "$needle"; then
        pass "$label"
    else
        fail_case "$label is missing"
    fi
}

run_helper() {
    local project="$1"
    ( cd "$project" && bash "$HELPER" 2>&1 )
}

# A normal project policy and the dev index regression.
PROJECT="$WORK/normal"
mkdir -p "$PROJECT/ai/policies"
write_policy "$PROJECT/ai/policies/ai-policy-sample.md" "Sample"
write_policy "$PROJECT/ai/policies/ai-policy-target.md" "Target"
printf 'archive\n' > "$PROJECT/ai/policies/canary.tar.gz"
out="$(run_helper "$PROJECT")"
rc=$?
if [ "$rc" -eq 0 ]; then pass "the helper exits 0 on a valid project"; else fail_case "the helper exited $rc"; fi
assert_contains "$out" 'summary|modules=' "the helper prints a summary"
line="$(module_line "$out" policy project sample)"
if [ -n "$line" ]; then pass "the helper indexes the project policy"; else fail_case "the helper missed the project policy"; fi
if [ "$(field "$line" 8)" = "effective=yes" ]; then pass "the project line is effective"; else fail_case "the project effective field is wrong"; fi
t="$(module_line "$out" policy project target)"
if [ -n "$t" ]; then pass "the helper indexes a name containing tar"; else fail_case "the helper excluded a target name"; fi
if printf '%s\n' "$out" | grep -q 'canary.tar'; then fail_case "the helper indexed an archive"; else pass "the helper skips the archive"; fi
dev="$(cd "$PROJECT" && bash "$VALIDATOR" --index "$PROJECT/ai/policies/ai-policy-sample.md" 2>&1)"
assert_contains "$dev" 'effective=yes|conflict=none' "the dev index output still has the fixed fields"
assert_contains "$dev" 'summary|modules=1' "the dev index summary is unchanged"

# Same-name shadowing.
SHADOW="$WORK/shadow"
mkdir -p "$SHADOW/ai/policies"
write_policy "$SHADOW/ai/policies/ai-policy-common.md" "Common Fixture"
out="$(run_helper "$SHADOW")"
g="$(module_line "$out" policy global common)"
p="$(module_line "$out" policy project common)"
if [ "$(field "$g" 8)" = "effective=shadowed:common" ]; then pass "the global common is shadowed"; else fail_case "the global common is not shadowed"; fi
if [ "$(field "$p" 8)" = "effective=yes" ]; then pass "the project common stays effective"; else fail_case "the project common effective field is wrong"; fi

# Trigger conflict.
CONFLICT="$WORK/conflict"
mkdir -p "$CONFLICT/ai/policies"
write_policy "$CONFLICT/ai/policies/ai-policy-sample.md" "Sample" "cloud standards"
out="$(run_helper "$CONFLICT")"
s="$(module_line "$out" policy project sample)"
c="$(module_line "$out" policy global cloud)"
if [ "$(field "$s" 9)" = "conflict=duplicate:cloud" ]; then pass "the project sample reports the duplicate"; else fail_case "the project sample conflict is wrong"; fi
if [ "$(field "$c" 9)" = "conflict=duplicate:sample" ]; then pass "the global cloud reports the duplicate"; else fail_case "the global cloud conflict is wrong"; fi
assert_contains "$out" 'conflicts=1' "the dev conflict count is preserved"

# Same-name shadowing with a redeclared trigger: not a duplicate.
SAMENAME="$WORK/samename"
mkdir -p "$SAMENAME/ai/policies"
write_policy "$SAMENAME/ai/policies/ai-policy-cloud.md" "Cloud Fixture" "cloud standards"
out="$(run_helper "$SAMENAME")"
g="$(module_line "$out" policy global cloud)"
p="$(module_line "$out" policy project cloud)"
if [ "$(field "$g" 8)" = "effective=shadowed:cloud" ]; then pass "the same-name global is shadowed"; else fail_case "the same-name global is not shadowed"; fi
if [ "$(field "$p" 9)" = "conflict=none" ]; then pass "the same-name replacement has no conflict"; else fail_case "the same-name replacement conflict is wrong"; fi
if [ "$(field "$g" 9)" = "conflict=none" ]; then pass "the same-name shadow has no conflict"; else fail_case "the same-name shadow conflict is wrong"; fi
assert_contains "$out" 'conflicts=0' "the same-name fixture has zero conflicts"

# A different-name policy that uses a shadowed global's reserved trigger is a duplicate.
RESERVED="$WORK/reserved"
mkdir -p "$RESERVED/ai/policies"
write_policy "$RESERVED/ai/policies/ai-policy-cloud.md" "Cloud Shadow"
write_policy "$RESERVED/ai/policies/ai-policy-sample.md" "Sample" "cloud standards"
out="$(run_helper "$RESERVED")"
s="$(module_line "$out" policy project sample)"
c="$(module_line "$out" policy global cloud)"
sc="$(module_line "$out" policy project cloud)"
if [ "$(field "$s" 9)" = "conflict=duplicate:cloud" ]; then pass "the reserved-trigger user names the shadowed global"; else fail_case "the reserved-trigger user conflict is wrong"; fi
if [ "$(field "$c" 9)" = "conflict=duplicate:sample" ]; then pass "the shadowed global names the reserved-trigger user"; else fail_case "the shadowed global conflict is wrong"; fi
if [ "$(field "$sc" 9)" = "conflict=none" ]; then pass "the same-name replacement stays clean"; else fail_case "the same-name replacement conflict is wrong"; fi
assert_contains "$out" 'conflicts=1' "the reserved-trigger fixture has one conflict"

# Empty default globs print one clear message.
EMPTY="$WORK/empty"
mkdir -p "$EMPTY"
out="$(cd "$EMPTY" && bash "$VALIDATOR" --index 2>&1)"; rc=$?
if [ "$rc" -eq 2 ]; then pass "the empty index exits 2"; else fail_case "the empty index exited $rc"; fi
assert_contains "$out" 'no top-level modules match the default globs' "the empty index prints one clear message"
if printf '%s\n' "$out" | grep -q 'unreadable module'; then fail_case "the empty index reports unreadable modules"; else pass "the empty index has no unreadable-module lines"; fi

# First boot: no project ai/ directory.
FIRST="$WORK/first"
mkdir -p "$FIRST"
out="$(run_helper "$FIRST")"
assert_contains "$out" 'summary|modules=' "the first boot prints a summary"
if printf '%s\n' "$out" | grep -q '^policy|project|'; then fail_case "the first boot indexed a project module"; else pass "the first boot has no project module"; fi

# Hidden, tmp, archive, and symlink canaries.
CANARY="$WORK/canary"
mkdir -p "$CANARY/ai/policies/.canaryhidden" "$CANARY/ai/policies/tmp"
write_policy "$CANARY/ai/policies/ai-policy-visible.md" "Visible"
write_policy "$CANARY/ai/policies/.canaryhidden/ai-policy-canaryhidden.md" "Canary Hidden"
write_policy "$CANARY/ai/policies/tmp/ai-policy-canarytmp.md" "Canary Tmp"
ln -s ai-policy-visible.md "$CANARY/ai/policies/ai-policy-canarylink.md"
out="$(run_helper "$CANARY")"
if printf '%s\n' "$out" | grep -q 'canaryhidden'; then fail_case "the helper indexed a hidden canary"; else pass "the helper skips hidden entries"; fi
if printf '%s\n' "$out" | grep -q 'canarytmp'; then fail_case "the helper indexed a tmp canary"; else pass "the helper skips tmp"; fi
if printf '%s\n' "$out" | grep -q 'canarylink'; then fail_case "the helper indexed a symlink"; else pass "the helper skips symlinks"; fi

# Encoding: no BOM and no CR.
if [ "$(printf '%s' "$out" | head -c 3 | od -An -tx1 | tr -d ' ')" = "efbbbf" ]; then fail_case "the helper emitted a BOM"; else pass "the helper has no BOM"; fi
if printf '%s' "$out" | grep -q $'\r'; then fail_case "the helper emitted CR"; else pass "the helper is LF"; fi

# A helper copy without the validator reports the missing tool.
STUB="$WORK/stub"
mkdir -p "$STUB/support-files"
cp "$HELPER" "$STUB/support-files/index-protocol.sh"
out="$(cd "$PROJECT" && bash "$STUB/support-files/index-protocol.sh" 2>&1)"; rc=$?
if [ "$rc" -eq 2 ]; then pass "the optional helper reports the missing validator"; else fail_case "the missing validator did not exit 2"; fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: protocol index fixture."
    exit 1
fi
echo "PASSED: protocol index fixture."
exit 0
