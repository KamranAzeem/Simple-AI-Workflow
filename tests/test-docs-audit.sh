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
COMPACTION_KNOWLEDGE="$ROOT/ai/knowledge/compaction-trigger-problem.md"
PROCEDURE="$ROOT/ai/procedures/post-compaction-recovery.md"
AGENTS="$ROOT/AGENTS.md"
LEARNING="$ROOT/docs/example-learning-session-runbook.md"
COMPARED="$ROOT/docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md"
GUIDE="$ROOT/docs/workflow-guide.md"
README="$ROOT/README.md"
ANNOUNCE="$ROOT/docs/announcements/v7.5.0.md"
ANNOUNCE6="$ROOT/docs/announcements/v7.6.0.md"
ANNOUNCE61="$ROOT/docs/announcements/v7.6.1.md"
ANNOUNCE62="$ROOT/docs/announcements/v7.6.2.md"
DECISIONS="$ROOT/design-docs/protocol-decisions.md"
MAP="$ROOT/ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md"
ANNOUNCE77="$ROOT/docs/announcements/v7.7.0.md"
ANNOUNCE771="$ROOT/docs/announcements/v7.7.1.md"
ANNOUNCE780="$ROOT/docs/announcements/v7.8.0.md"
ANNOUNCE781="$ROOT/docs/announcements/v7.8.1.md"
ANNOUNCE782="$ROOT/docs/announcements/v7.8.2.md"
ANNOUNCE790="$ROOT/docs/announcements/v7.9.0.md"
ANNOUNCE7100="$ROOT/docs/announcements/v7.10.0.md"
ANNOUNCE7110="$ROOT/docs/announcements/v7.11.0.md"

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
missing "docs/global-user-settings.md"

for doc in \
    docs/workflow-guide.md \
    docs/ai-customization-guide.md \
    docs/ai-customization.md \
    docs/user-settings.md \
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

present "$POST_COMPACT" "does not run automatically" "post-compaction guide says the procedure is manual"
present "$POST_COMPACT" "run post-compaction recovery procedure" "post-compaction guide gives the manual phrase"
present "$POST_COMPACT" "always-on" "post-compaction guide keeps AGENTS.md always-on in Kilo"
present "$POST_COMPACT" "visible in chat" "post-compaction guide states the summary is visible"
present "$POST_COMPACT" "The human step" "post-compaction guide keeps the human step"

present "$COMPACTION_KNOWLEDGE" "manual" "knowledge note says the recovery is manual"
present "$COMPACTION_KNOWLEDGE" "no current harness exposes one that works that way" "knowledge note states the harness gap"
present "$COMPACTION_KNOWLEDGE" "always-on" "knowledge note keeps AGENTS.md always-on in Kilo"
present "$COMPACTION_KNOWLEDGE" "visible in chat" "knowledge note states the summary is visible"
present "$COMPACTION_KNOWLEDGE" "The human step" "knowledge note keeps the human step"

present "$PROCEDURE" "Manual after conversation compaction" "procedure title says manual"
present "$PROCEDURE" "No harness hook currently fires this procedure" "procedure states the harness gap"
absent "$PROCEDURE" "Automatic after conversation compaction" "procedure title drops the automatic claim"
present "$PROCEDURE" "[Reloading key files into context...]" "procedure keeps the reload sentinel"

present "$AGENTS" "the user runs" "always-on rule says the user runs the recovery"
present "$AGENTS" "no harness hook fires it" "always-on rule states the harness gap"
present "$GUIDE" "not automatic" "workflow guide says the recovery is not automatic"
present "$GUIDE" "run post-compaction recovery procedure" "workflow guide gives the manual phrase"
absent "$GUIDE" "Zero-touch resume" "workflow guide drops the zero-touch claim"

absent "$LEARNING" "Cline" "learning runbook drops Cline"

present "$COMPARED" "fixed shape" "compared doc names the fixed shape"
present "$COMPARED" "predictable" "compared doc names predictability"
present "$COMPARED" "single-assistant" "compared doc names the single-assistant audience"
absent "$COMPARED" "VS Code versus CLI" "compared doc drops the VS Code versus CLI framing"

present "$GUIDE" "### Agent Collaboration" "guide has the agent collaboration section"
present "$GUIDE" "coordination board" "guide names the coordination board"
present "$GUIDE" "multi-agent-runbook.md" "guide links the multi-agent runbook"
present "$GUIDE" "Why the state lives with the project" "guide explains the black box problem"
present "$GUIDE" "### The compaction phenomenon" "guide explains the compaction phenomenon"
present "$GUIDE" "Working style: no one-shot pride, no vibe coding" "guide covers one-shot pride and vibe coding"
present "$GUIDE" "Ticket, issue, or support request" "guide clarifies ticket, issue, and support request"
present "$GUIDE" "| Ticket |" "guide table starts with ticket"
present "$GUIDE" "| Issue |" "guide table includes issue"
present "$GUIDE" "| Support request |" "guide table includes support request"
present "$GUIDE" "slides/diagrams/blackbox-state.svg" "guide links the blackbox diagram"
present "$GUIDE" "slides/diagrams/compaction.svg" "guide links the compaction diagram"
present "$GUIDE" "slides/diagrams/skills-layers.svg" "guide links the skills-layers diagram"
present "$GUIDE" "Skills are not the workflow" "guide says skills are not the workflow"
present "$GUIDE" "kanban-board" "guide documents the Kanban example skill"
present "$GUIDE" "An idea is a ticket with \`IssueType: Idea\`" "guide states the idea intake"
present "$GUIDE" "dated \`Won't fix\` note" "guide states the idea close"
present "$GUIDE" "checkpoint discussed-idea line remains the backstop" "guide keeps the checkpoint backstop"
present "$GUIDE" "The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's \`## Close Sequence\`" "guide states the two-step approval"
present "$GUIDE" "This guide describes the protocol. The protocol modules" "guide states the protocol modules are authoritative"
present "$GUIDE" "- **Minor**: fix before approval." "guide makes Minor blocking"
present "$GUIDE" "Every Critical, Major, and Minor finding blocks approval." "guide states the uniform gate"
present "$GUIDE" "an expectation, not a cap" "guide calls the round range an expectation"
absent "$GUIDE" "fix when convenient" "guide drops the old Minor wording"
exists "docs/announcements/v7.5.0.md"
present "$ANNOUNCE" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.5.0" "announcement records the release URL"
present "$README" "docs/announcements/v7.7.0.md" "README points at the v7.7.0 release announcement"
present "$README" "## Path migration in v7.7.0" "README has the v7.7.0 migration table"
present "$ANNOUNCE77" "## Migration map" "v7.7.0 announcement has the migration map"
present "$ANNOUNCE77" "scope-migration-<date>" "v7.7.0 announcement names the backups"
present "$ANNOUNCE77" "removed in v7.8.0" "v7.7.0 announcement names the alias window"
exists "docs/announcements/v7.7.1.md"
present "$ANNOUNCE771" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.7.1" "v7.7.1 announcement records the release URL"
exists "docs/announcements/v7.8.0.md"
present "$ANNOUNCE780" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.8.0" "v7.8.0 announcement records the release URL"
exists "docs/announcements/v7.8.1.md"
present "$ANNOUNCE781" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.8.1" "v7.8.1 announcement records the release URL"
exists "docs/announcements/v7.8.2.md"
present "$ANNOUNCE782" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.8.2" "v7.8.2 announcement records the release URL"
exists "docs/announcements/v7.9.0.md"
present "$ANNOUNCE790" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.9.0" "v7.9.0 announcement records the release URL"
exists "docs/announcements/v7.10.0.md"
present "$ANNOUNCE7100" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.10.0" "v7.10.0 announcement records the release URL"
exists "docs/announcements/v7.11.0.md"
present "$ANNOUNCE7110" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.11.0" "v7.11.0 announcement records the release URL"
present "$README" "docs/announcements/v7.11.0.md" "README points at the v7.11.0 release announcement"
present "$DECISIONS" "## 2026-11-25: Four scopes replace the global wording" "ADR store records the scope decision"
present "$DECISIONS" "## 2026-11-25: The code-review policy owns the uniform blocking gate" "ADR store records the gate owner"
present "$DECISIONS" "## 2026-11-25: The core gate ships alone" "ADR store records the scope cut"
present "$DECISIONS" "This supersedes the 2026-10-28 rule that fixes only Critical and Major." "ADR store records the supersession"
present "$MAP" "the uniform Critical, Major, and Minor gate" "map names the uniform gate"
absent "$MAP" "the critical-and-major review gate" "map drops the old gate name"
absent "$MAP" "currently name only Critical and Major" "map drops the old enforcement wording"
absent "$MAP" "the implementation is pending" "map drops the pending wording"
present "$GUIDE" "Small and medium tickets need context and acceptance criteria" "guide gives S and M the light path"
present "$GUIDE" "large and architectural work needs an HLD, an LLD, acceptance criteria, and ADRs" "guide gives L and XL the full set"
present "$GUIDE" "Use the plan template in the issue policy" "guide cites the plan template"
present "$GUIDE" "each acceptance criterion has at least one behavioral assertion" "guide states the assertion floor"
present "$GUIDE" "small and medium work needs context plus acceptance criteria" "guide aligns the design depth"
present "$GUIDE" "large and architectural work gets the full set" "guide aligns the design full set"
absent "$GUIDE" "medium and larger need an HLD" "guide drops the old plan depth"
absent "$GUIDE" "medium, large, and architectural work gets the full set" "guide drops the old design depth"
exists "docs/announcements/v7.6.0.md"
present "$ANNOUNCE6" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.0" "v7.6.0 announcement records the release URL"
present "$ANNOUNCE61" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.1" "v7.6.1 announcement records the release URL"
present "$GUIDE" "Current position" "guide names the current position block"
present "$GUIDE" "\`Next steps\` section" "guide names the plain next-steps section"
present "$GUIDE" "list every open item" "guide lists every open item"
present "$GUIDE" "with no cap" "guide drops the cap"
present "$GUIDE" "ticket path or slug" "guide names the ticket path rule"
present "$GUIDE" "the log carries no next-steps line" "guide separates the delta from the queue"
present "$GUIDE" "last active item" "guide names the last active item"
absent "$GUIDE" "ten or fewer remain" "guide drops the ten-item rule"
present "$DECISIONS" "## 2026-11-25: The deferred plan-quality rules land" "ADR store records the deferred rules"
present "$DECISIONS" "## 2026-11-25: The checkpoint report shows the current position" "ADR store records the checkpoint report change"
present "$DECISIONS" "## 2026-11-26: The checkpoint queue is separate from the current position" "ADR store records the separated queue"
present "$DECISIONS" "## 2026-11-26: The checkpoint next steps are a plain list" "ADR store records the plain list"
present "$DECISIONS" "## 2026-11-25: Review verdicts bind to the artifact hash" "ADR store records the verdict binding"
present "$DECISIONS" "A review verdict binds to the reviewed artifact's SHA-256." "ADR records the hash binding"
present "$DECISIONS" "A post-approval edit invalidates the approval" "ADR records the post-approval invalidation"
present "$DECISIONS" "becomes a follow-up ticket unless it is a regression" "ADR records the follow-up rule"
present "$DECISIONS" "The verification runbook and the verdict-hash rules are retired" "ADR records the retirement"
present "$DECISIONS" "The per-fixture verification runbook is retired" "ADR records the runbook retirement"
present "$DECISIONS" "The verdict-hash rules are retired" "ADR records the hash retirement"
present "$DECISIONS" "The repository records executable bits explicitly" "ADR records the file-mode constraint"
present "$DECISIONS" "git update-index --chmod=+x" "ADR records the exec-bit command"
present "$DECISIONS" "Slides use a code-driven diagram pipeline and a presentation policy" "ADR records the slide pipeline"
present "$DECISIONS" "D2 is the default" "ADR records D2"
present "$DECISIONS" "ai-policy-presentation.md" "ADR records the presentation policy"
present "$DECISIONS" "32-unit font floor" "ADR records the diagram font floor"
present "$DECISIONS" "The checkpoint transaction log carries no next-steps line" "ADR records the log change"
present "$ANNOUNCE62" "https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.6.2" "v7.6.2 announcement records the release URL"
adr="$(awk '/^## 2026-11-25: Review verdicts bind to the artifact hash/{on=1; print; next} on && /^## /{exit} on' "$DECISIONS")"
if printf '%s\n' "$adr" | grep -qiE 'commit|branch|plan|report'; then
    fail_case "ADR entry has no version-control or plan dependency"
else
    pass "ADR entry has no version-control or plan dependency"
fi

retirement="$(awk '/The verification runbook and the verdict-hash rules are retired/{on=1; print; next} on && /^## /{exit} on' "$DECISIONS")"
if printf '%s\n' "$retirement" | grep -qiE 'commit|branch|plan|report'; then
    fail_case "retirement ADR has no version-control or plan dependency"
else
    pass "retirement ADR has no version-control or plan dependency"
fi
present "$MAP" "The plan template, assertion floor, depth, and clean-tree gate are live." "map names the follow-up rules"

for new_test in tests/test-path-probe.sh tests/test-scope-migration.sh; do
    if [ -f "$ROOT/$new_test" ]; then
        pass "v7.7.0 adds $new_test"
    else
        fail_case "v7.7.0 test missing: $new_test"
    fi
done

order="$(awk '/\| Ticket \|/{t=NR} /\| Issue \|/{i=NR} /\| Support request \|/{s=NR} END{if (t && i && s && t < i && i < s) print "ok"; else print "bad"}' "$GUIDE")"
if [ "$order" = "ok" ]; then
    echo "PASS guide keeps the ticket, issue, support request order"
else
    echo "FAIL guide keeps the ticket, issue, support request order"
    fail=1
fi

present "$README" "docs/ai-provider-selection-guide.md" "README docs index links the provider guide"
present "$README" "docs/multi-agent-runbook.md" "README docs index links the multi-agent runbook"
present "$README" "docs/example-learning-session-runbook.md" "README docs index links the learning runbook"
present "$README" "docs/personas/" "README docs index links the personas"
absent "$README" "docs/vscode-cline-provider-setup-for-beginners.md" "README drops the Cline guide"
absent "$README" "docs/protocol-name-migration-map" "README drops the migration map"
absent "$README" "docs/ai-agent-collaboration.md" "README drops the collaboration notes"

if grep -rIl "protocol-verification-toolchain" \
    --exclude=test-docs-audit.sh \
    --exclude-dir=closed \
    --exclude-dir=daily-checkpoints \
    --exclude-dir=code-review-reports \
    "$ROOT/AGENTS.md" "$ROOT/ai/policies" "$ROOT/ai/procedures" "$ROOT/docs" "$ROOT/tests" "$ROOT/ai/knowledge" >/dev/null; then
    fail_case "the retired verification runbook is still named"
else
    pass "the retired verification runbook is not named"
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: docs audit fixture."
    exit 1
fi
echo "PASSED: docs audit fixture (retired docs gone, Kilo Code path, fixed-shape comparison, collaboration merge, docs index)."
exit 0
