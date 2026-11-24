#!/bin/bash
# Slide deck fixture: the Architect story, the Concepts act, the assistant
# anatomy, the context window, the out-of-band ai/ memory, the project brain,
# the AI ladder, the two root files, compliance, quality, token discipline,
# Git safety, the three roots, the two dials, the knowledge and skills map,
# the full policy and procedure catalog, the team gate, the axe assets, the
# derived counts, and the local preview and renderer.
# Usage: ./tests/test-slides.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DECK="$ROOT/docs/simple-ai-workflow-slides.md"
GUIDE="$ROOT/docs/workflow-guide.md"
README="$ROOT/README.md"
PREVIEW="$ROOT/support-files/preview-slides.html"
RENDER="$ROOT/support-files/render-slides-preview.sh"

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

present_ci() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qiF -- "$needle" "$file"; then
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

if [ ! -f "$DECK" ]; then
    echo "FAIL: docs/simple-ai-workflow-slides.md is missing."
    exit 1
fi

separators="$(grep -c '^---$' "$DECK" || true)"
if [ "$separators" -ge 30 ]; then
    pass "deck has at least 30 slide separators"
else
    fail_case "deck has $separators separators; the story needs at least 30"
fi

for phrase in \
    "The Architect and the Peer" \
    "reliable peer" \
    "A plain chat has no fixed shape" \
    "The workflow is a protocol, not a platform" \
    "definition of done" \
    "fixed few steps" \
    "not always a Git repository" \
    "You are the architect. The AI is your peer." \
    "one person, one project, one peer" \
    "Load context" \
    "Plan the issue" \
    "Implement the plan" \
    "Review" \
    "Checkpoint" \
    "project's memory" \
    "Two dials" \
    "Three scopes, two kinds of memory" \
    "Sharpening the axe" \
    "Six jobs, one protocol" \
    "This is not about going faster" \
    "deliberate friction" \
    "Same task, two shapes" \
    "The repository is the proof" \
    "Team features are not for everyone" \
    "Team knowledge and team skills" \
    "Publish a lesson" \
    "Multiple assistants, turn by turn" \
    "Five minutes to the first loop" \
    "Global AI Workflow Directory" \
    "Global User AI Directory" \
    "ai-customization.md" \
    "Part 1: Concepts" \
    "An AI assistant is a brain, a memory, and your tools" \
    "only knows what is in its context" \
    "The ai/ directory is out-of-band memory" \
    "git-ignored" \
    "not application code" \
    "The ai/ directory is the project's brain" \
    "What this is, and what it is not" \
    "The same protocol scales to a solution root" \
    "Part 2: The Workflow" \
    "Part 3: Proof" \
    "not a secrets vault" \
    "The AI ladder" \
    "Two small files start the whole thing" \
    "Compliance is a dial, not a badge" \
    "Quality is a loop, not a hope" \
    "Load the index, not the world" \
    "Git is your safety net" \
    "TDD" \
    "kanban-board" \
    "**Idea**: an unvetted proposal." \
    "The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's \`## Close Sequence\`" \
    "the implementation request approves the plan's close sequence" \
    "The guide and README describe the protocol; the protocol modules are authoritative." \
    "The state is not a black box" \
    "Ticket, issue, or support request" \
    "Skills are a layer, not the workflow" \
    "No vibe coding" \
    "One-shot prompts are not the goal" \
    "When the context is compacted" \
    "manual reload" \
    "no harness hook currently fires it" \
    "Academic research" \
    "bootstrap-project" \
    "load-context" \
    "run-peer-review" \
    "outbound-content-scrub" \
    "team-knowledge" \
    "Required Compliance" \
    "create-handoff" \
    "knowledge-publish" \
    "examine-codebase" \
    "update-design-docs" \
    "migrate-design-docs"; do
    present "$DECK" "$phrase" "deck names: $phrase"
done

if awk '/^---$/{exit} {print}' "$DECK" | grep -qF "Think like a wave surfer"; then
    pass "first slide sets the training framing"
else
    fail_case "first slide missing the training framing"
fi
absent "$GUIDE" "wave surfer" "guide does not get the wave-surfer framing"
if awk 'f{print} /^---$/{f=1}' "$DECK" | grep -qiF "wave surfer"; then
    fail_case "wave-surfer framing appears after the first slide"
else
    pass "wave-surfer framing stays on the first slide"
fi
present "$DECK" "The recovery is manual" "compaction slide note says manual"
present "$DECK" "  - **Idea**" "deck indents the idea under Issue"
present "$ROOT/docs/slides/diagrams/compaction.svg" "Manual recovery" "compaction diagram names manual recovery"

for group in "Setup" "Daily loop" "Memory" "Quality" "Delivery" "Maintenance" "Team" "Compliance" "Domain expertise" "Traits and skills" "Commands"; do
    present "$DECK" "Appendix: $group" "appendix group: $group"
done

for policy in \
    "common policy" "global-settings policy" "Meta policy" "Knowledge policy" \
    "Design-docs policy" "Issue-management policy" "Coding-baseline policy" \
    "Code-review policy" "Codebase-examination policy" "Thinking-modes policy" \
    "Handoff policy" "outbound-content-scrub" "team-knowledge" \
    "Academic research" "Accounting" "API backend" "Career coaching" "Cloud" \
    "Data" "DBA" "Linux admin" "Mobile apps" "Observability" "Web frontend" "Windows admin"; do
    present "$DECK" "$policy" "catalog policy: $policy"
done

for procedure in \
    "bootstrap-project" "load-context" "manage-issues" "implement-plan" \
    "write-checkpoint" "run-peer-review" "examine-codebase" "update-design-docs" \
    "migrate-design-docs" "repair-state-files" "repair-knowledge-files" \
    "repair-global-settings" "create-backup" "create-handoff" \
    "post-compaction-recovery" "knowledge-publish"; do
    present "$DECK" "$procedure" "catalog procedure: $procedure"
done

for term in "project" "global" "team" "knowledge" "skill" "road trip" "drivers" "brain" "tools" "context window" "out-of-band" "local"; do
    present_ci "$DECK" "$term" "deck names: $term"
done

for stale in \
    "kamran@wbitt.com" \
    "ls -R" \
    "Cline" \
    "VS Code versus CLI" \
    "28 tests" \
    "476 lines" \
    "128 KB" \
    "GPT-5.4" \
    "the automatic reload after a summary" \
    "Recovery is automatic"; do
    absent "$DECK" "$stale" "deck drops: $stale"
done

policies="$(find "$ROOT/ai/policies" -maxdepth 1 -name '*.md' | wc -l)"
procedures="$(find "$ROOT/ai/procedures" -maxdepth 1 -name '*.md' | wc -l)"
tests="$(find "$ROOT/tests" -maxdepth 1 -name 'test-*.sh' | wc -l)"
docs="$(find "$ROOT/docs" -maxdepth 1 -name '*.md' | wc -l)"
triggers=0
for module in "$ROOT"/ai/policies/*.md "$ROOT"/ai/procedures/*.md; do
    count="$(awk '/^## Triggers/{on=1;next} /^## /{on=0} on && /^- /{c++} END{print c+0}' "$module")"
    triggers=$((triggers + count))
done

for check in "$policies policies" "$procedures procedures" "$triggers triggers" "$tests tests" "$docs user-facing docs"; do
    present "$DECK" "$check" "deck count: $check"
done

for asset in \
    slides/assets/axe.jpg \
    slides/diagrams/three-roots.svg \
    slides/diagrams/two-scopes.svg \
    slides/diagrams/knowledge-skills.svg \
    slides/diagrams/daily-loop.svg \
    slides/diagrams/architect-peer.svg \
    slides/diagrams/before-after.svg \
    slides/diagrams/road-trip.svg \
    slides/diagrams/ai-nutshell.svg \
    slides/diagrams/context-window.svg \
    slides/diagrams/memory-gap.svg \
    slides/diagrams/out-of-band.svg \
    slides/diagrams/project-brain.svg \
    slides/diagrams/is-isnot.svg \
    slides/diagrams/architect-solution.svg \
    slides/diagrams/ai-ladder.svg \
    slides/diagrams/root-files.svg \
    slides/diagrams/compliance.svg \
    slides/diagrams/quality-loop.svg \
    slides/diagrams/git-safety.svg \
    slides/diagrams/token-budget.svg \
    slides/diagrams/six-jobs.svg \
    slides/diagrams/straight-vs-zigzag.svg \
    slides/diagrams/team-gate.svg \
    slides/diagrams/team-publish.svg \
    slides/diagrams/blackbox-state.svg \
    slides/diagrams/skills-layers.svg \
    slides/diagrams/compaction.svg \
    slides/diagrams/first-loop.svg; do
    if [ -f "$ROOT/docs/$asset" ]; then
        pass "asset exists: $asset"
    else
        fail_case "asset missing: $asset"
    fi
    present "$DECK" "$asset" "deck references: $asset"
done

present "$PREVIEW" "../docs/simple-ai-workflow-slides.md" "preview reads the Markdown deck"
present "$PREVIEW" "section-slide" "preview styles the section dividers"
present "$PREVIEW" "diagram-only" "preview sizes the full-slide diagrams"
present "$RENDER" "google-chrome" "renderer uses Google Chrome"
present "$RENDER" "preview-slides.html" "renderer uses the preview"
present "$README" "docs/simple-ai-workflow-slides.md" "README links the Markdown deck"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: slide deck fixture."
    exit 1
fi
echo "PASSED: slide deck fixture (concepts, story, catalog, groups, roots, dials, knowledge and skills, team gate, assets, counts, preview, renderer)."
exit 0
