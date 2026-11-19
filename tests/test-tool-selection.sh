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
    if grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label is missing"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if grep -qF -- "$needle" "$file"; then
        fail_case "$label is present"
    else
        pass "$label is absent"
    fi
}

present "$AGENTS" "## Precedence" "the precedence section in AGENTS.md"
present "$AGENTS" "Level 0:" "the Level 0 safety tier"
present "$AGENTS" "Level 5:" "the Level 5 procedure tier"
present "$AGENTS" "A policy trigger never overrides" "the policy-trigger sentence"
present "$AGENTS" "Git-Ignored Protocol Files Are Readable" "the readable git-ignored rule"
present "$AGENTS" "built-in file-read tool first" "the built-in-first read rule"
present "$AGENTS" "use a shell tool" "the shell fallback"
present "$AGENTS" "report the fallback" "the fallback report"
# shellcheck disable=SC2016
present "$AGENTS" '`[PENDING]`' "the missing-tool pending skip"
absent "$AGENTS" "You MUST use shell tools" "the mandatory shell-read sentence"
absent "$AGENTS" "including the bootstrap wedge" "the bootstrap wedge reference"

git_rule="$(grep -F 'Git-Ignored Protocol Files Are Readable' "$AGENTS")"
if printf '%s\n' "$git_rule" | grep -q 'ai/state/'; then
    fail_case "the readable rule names ai/state/"
else
    pass "the readable rule has no path list"
fi

present "$COMMON" '## Tool Selection' "the Tool Selection section in the common policy"
present "$COMMON" "Use a purpose-built harness tool for one operation" "the first rung"
present "$COMMON" "Use the shell second only for a system operation on the host" "the shell rung"
present "$COMMON" "Use a runtime for computation only when neither a built-in tool nor the shell performs it." "the runtime rung"
present "$COMMON" "Run one job per shell call and report each fallback at that call" "the fallback report rule"
present "$COMMON" "Never use a lower rung to bypass" "the no-bypass rule"
present "$COMMON" "Never use Python or another runtime to read, search, create, append to, or edit a file; use the built-in tool." "the runtime file-operation guard"
present "$COMMON" "Use shell search only when the built-in search cannot reach the path" "the shell-search exception"
absent "$COMMON" "when a purpose-built edit tool exists" "the conditional file-edit wording"
absent "$COMMON" "Built-in Tools First (File Edits)" "the old file-edit rule"
absent "$COMMON" "Use a purpose-built tool first" "the old first-rung wording"
absent "$COMMON" "Use the shell second for a command or file operation" "the old shell rung"
absent "$COMMON" "Use Python or another runtime third" "the old runtime rung"

count="$(awk '/^## Tool Selection$/{f=1;next} f&&/^## /{exit} f&&/^- /{c++} END{print c+0}' "$COMMON")"
if [ "$count" -eq 9 ]; then pass "the common ladder has nine bullets"; else fail_case "the common ladder has $count bullets"; fi

present "$VALIDATOR" "## Precedence" "the validator precedence anchor"
present "$VALIDATOR" "Use a purpose-built harness tool for one operation" "the validator first-rung anchor"
present "$VALIDATOR" "Use shell search only when the built-in search cannot reach the path" "the validator shell-search anchor"
present "$VALIDATOR" "index-protocol.sh" "the validator helper-path anchor"
present "$VALIDATOR" "index-source=helper|fallback" "the validator index-source anchor"
present "$VALIDATOR" "age-source=commit|mtime" "the validator age-source anchor"
present "$VALIDATOR" "Git-Ignored Protocol Files Are Readable" "the validator readable-rule anchor"
present "$VALIDATOR" "You MUST use shell tools" "the validator mandatory-shell negative check"
present "$VALIDATOR" "Built-in Tools First (File Edits)" "the validator file-edit negative check"

if [ "$fail" -eq 0 ]; then
    echo "PASSED: tool selection, precedence, and readable git-ignored protocol files."
    exit 0
fi
echo "FAILED: tool selection, precedence, and readable git-ignored protocol files."
exit 1
