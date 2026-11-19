#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS="$ROOT/AGENTS.md"
COMMON="$ROOT/ai/policies/ai-policy-common.md"
VALIDATOR="$ROOT/support-files/validate-protocol.sh"
fail=0

pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if grep -qF "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label is missing"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if grep -qF "$needle" "$file"; then
        fail_case "$label is present"
    else
        pass "$label is absent"
    fi
}

present "$AGENTS" "Git-Ignored Protocol Files Are Readable" "the readable git-ignored rule in AGENTS.md"
present "$AGENTS" "built-in file-read tool first" "the built-in-first read rule in AGENTS.md"
present "$AGENTS" "use a shell tool" "the shell fallback in AGENTS.md"
present "$AGENTS" "report the fallback" "the fallback report in AGENTS.md"
absent "$AGENTS" "You MUST use shell tools" "the mandatory shell-read sentence in AGENTS.md"

git_rule="$(grep -F 'Git-Ignored Protocol Files Are Readable' "$AGENTS")"
if printf '%s\n' "$git_rule" | grep -q 'ai/state/'; then
    fail_case "the readable rule names ai/state/"
else
    pass "the readable rule has no path list"
fi

present "$COMMON" '## Tool Selection' "the Tool Selection section in the common policy"
present "$COMMON" "Use a purpose-built tool first" "the first rung"
present "$COMMON" "Use the shell second" "the shell rung"
present "$COMMON" "Use Python or another runtime third" "the runtime rung"
present "$COMMON" "Report every fallback" "the fallback report rule"
present "$COMMON" "Never use a lower rung to bypass" "the no-bypass rule"
present "$COMMON" "Never use Python or another runtime to search, create, append to, or edit a file; use the built-in tool." "the runtime file-operation guard"
present "$COMMON" "Use shell search when the purpose-built search cannot reach the path" "the shell-search exception"
absent "$COMMON" "when a purpose-built edit tool exists" "the conditional file-edit wording"
absent "$COMMON" "Built-in Tools First (File Edits)" "the old file-edit rule in the common policy"

present "$VALIDATOR" "Git-Ignored Protocol Files Are Readable" "the validator readable-rule anchor"
present "$VALIDATOR" "You MUST use shell tools" "the validator mandatory-shell negative check"
present "$VALIDATOR" "Built-in Tools First (File Edits)" "the validator file-edit negative check"

if [ "$fail" -eq 0 ]; then
    echo "PASSED: tool selection and readable git-ignored protocol files."
    exit 0
fi
echo "FAILED: tool selection and readable git-ignored protocol files."
exit 1
