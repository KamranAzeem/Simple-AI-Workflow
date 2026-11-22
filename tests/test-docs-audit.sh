#!/bin/bash
# Docs audit fixture: the retired docs are gone, the survivors are current,
# the provider path is Kilo Code, and the compared doc tells the fixed-shape story.
# Usage: ./tests/test-docs-audit.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROVIDER="$ROOT/docs/ai-provider-selection-guide.md"
SETUP="$ROOT/docs/setup.md"
POST_COMPACT="$ROOT/docs/post-compaction-reload-trigger-setup.md"
COMPACTION_KNOWLEDGE="$ROOT/ai/shared/project-knowledge/compaction-trigger-problem.md"
LEARNING="$ROOT/docs/example-learning-session-runbook.md"
COMPARED="$ROOT/docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md"
GUIDE="$ROOT/docs/workflow-guide.md"
README="$ROOT/README.md"

fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        fail_case "$label"
    else
        pass "$label"
    fi
}

exists() {
    if [ -f "$ROOT/$1" ]; then
        pass "kept doc: $1"
    else
        fail_case "kept doc missing: $1"
    fi
}

missing() {
    if [ -e "$ROOT/$1" ]; then
        fail_case "retired doc still present: $1"
    else
        pass "retired doc is gone: $1"
    fi
}

missing "docs/protocol-name-migration-map-2026-10-06.md"
missing "docs/vscode-cline-provider-setup-for-beginners.md"
missing "docs/ai-agent-collaboration.md"

for doc in \
    docs/workflow-guide.md \
    docs/ai-customization-guide.md \
    docs/ai-customization.md \
    docs/global-user-settings.md \
    docs/compliance-guide.md \
    docs/custom-policy-howto.md \
    docs/how-policies-work-in-this-workflow.md \
    docs/policy-influence-on-ai-work.md \
    docs/post-compaction-reload-trigger-setup.md \
    docs/protocol-validation-system.md \
    docs/setup.md \
    docs/ai-policy-mobile-apps-guide.md \
    docs/codebase-examination-guide.md \
    docs/multi-agent-runbook.md \
    docs/example-learning-session-runbook.md \
    docs/simple-ai-workflow-slides.md \
    docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md \
    docs/ai-provider-selection-guide.md; do
    exists "$doc"
done

present "$PROVIDER" "Kilo Code" "provider guide names Kilo Code"
absent "$PROVIDER" "Cline" "provider guide drops Cline"
present "$SETUP" "## Kilo Code Setup" "setup has the Kilo Code setup"
present "$SETUP" "Kilo Code" "setup names Kilo Code"

present "$POST_COMPACT" "always-on" "post-compaction guide keeps AGENTS.md always-on in Kilo"
present "$POST_COMPACT" "visible in chat" "post-compaction guide states the summary is visible"
present "$POST_COMPACT" "human backstop" "post-compaction guide keeps the human backstop"
present "$POST_COMPACT" "No slash command" "post-compaction guide needs no slash command"

present "$COMPACTION_KNOWLEDGE" "always-on" "knowledge note keeps AGENTS.md always-on in Kilo"
present "$COMPACTION_KNOWLEDGE" "visible in chat" "knowledge note states the summary is visible"
present "$COMPACTION_KNOWLEDGE" "human backstop" "knowledge note keeps the human backstop"

absent "$LEARNING" "Cline" "learning runbook drops Cline"

present "$COMPARED" "fixed shape" "compared doc names the fixed shape"
present "$COMPARED" "predictable" "compared doc names predictability"
present "$COMPARED" "single-assistant" "compared doc names the single-assistant audience"
absent "$COMPARED" "VS Code versus CLI" "compared doc drops the VS Code versus CLI framing"

present "$GUIDE" "### Agent Collaboration" "guide has the agent collaboration section"
present "$GUIDE" "coordination board" "guide names the coordination board"
present "$GUIDE" "multi-agent-runbook.md" "guide links the multi-agent runbook"

present "$README" "docs/ai-provider-selection-guide.md" "README docs index links the provider guide"
present "$README" "docs/multi-agent-runbook.md" "README docs index links the multi-agent runbook"
present "$README" "docs/example-learning-session-runbook.md" "README docs index links the learning runbook"
present "$README" "docs/personas/" "README docs index links the personas"
absent "$README" "docs/vscode-cline-provider-setup-for-beginners.md" "README drops the Cline guide"
absent "$README" "docs/protocol-name-migration-map" "README drops the migration map"
absent "$README" "docs/ai-agent-collaboration.md" "README drops the collaboration notes"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: docs audit fixture."
    exit 1
fi
echo "PASSED: docs audit fixture (retired docs gone, Kilo Code path, fixed-shape comparison, collaboration merge, docs index)."
exit 0
