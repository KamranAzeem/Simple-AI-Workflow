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
PREVIEW="$ROOT/docs/slides/simple-ai-workflow-slides.html"
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
if [ "$separators" -eq 58 ]; then
    pass "deck has 59 slides (58 separators)"
else
    fail_case "deck has $((separators + 1)) slides; expected 59"
fi

for phrase in \
    "The Architect and the Peer" \
    "reliable peer" \
    "A plain chat has no fixed shape" \
    "The workflow is a protocol, not a platform" \
    "definition of done" \
    "fixed few steps" \
    "not always a repository" \
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
    "workflow clone" \
    "global settings" \
    "ai-customization.md" \
    "Part 1: Concepts" \
    "An AI assistant is a brain, a memory, and your tools" \
    "only knows what is in its context" \
    "The ai/ directory is out-of-band memory" \
    "git-ignored" \
    "not application code" \
    "The ai/ directory is the project's brain" \
    "What this is, and what it is not" \
    "The same protocol scales to a customer root" \
    "Part 2: The Workflow" \
    "Part 3: Proof" \
    "not a secrets vault" \
    "The AI ladder" \
    "Two small files start the whole thing" \
    "Compliance is a dial, not a badge" \
    "Quality is a loop, not a hope" \
    "JIT indexing" \
    "Triggers and procedures on demand" \
    "A thin \`AGENTS.md\`" \
    "Route the context, do not load it all" \
    "MoE-inspired conditional loading" \
    "Sparse activation is not sparse context" \
    "the 16 KB cap" \
    "saves context tokens" \
    "paths, filenames, and domains" \
    "three short bullets per item" \
    "300-character lines, a 30,720-byte shared budget" \
    "14-day progress window" \
    "the daily checkpoints are the archive" \
    "rebuilt at load context, recovery, and checkpoint" \
    "Team knowledge joins the index" \
    "post-compaction recovery does not read the state files" \
    "Git is your safety net" \
    "TDD" \
    "kanban-board" \
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
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "MoE-inspired conditional loading" "the MoE diagram names conditional loading"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "Sparse activation is not sparse context" "the MoE diagram carries the caption"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "boot set + active expertise" "the MoE diagram names the boot set"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "knowledge index" "the MoE diagram names the knowledge index"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "skill index" "the MoE diagram names the skill index"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "scoped reads" "the MoE diagram names scoped reads"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "ephemeral triggers" "the MoE diagram names the ephemeral triggers"
present "$ROOT/docs/slides/diagrams/moe-routing.svg" "release-time checks" "the MoE diagram names the release-time checks"
if grep -oE 'font-size: [0-9]+px' "$ROOT/docs/slides/diagrams/moe-routing.svg" | awk '{v=$2; gsub(/[^0-9]/,"",v); if (v+0 < 24) bad=1} END{exit bad?0:1}'; then
    fail_case "the MoE diagram uses a font size below 24"
else
    pass "the MoE diagram keeps every font size at 24 or above"
fi
present "$GUIDE" "The MoE analogy" "the guide carries the MoE note"
present "$GUIDE" "saves context tokens" "the guide states the context saving"
present "$GUIDE" "A trigger loads a global policy's body" "the guide names the trigger route"
present "$GUIDE" "a skill description match loads a skill body" "the guide names the skill route"
present "$ROOT/support-files/build-slides-html.sh" "docs/slides/simple-ai-workflow-slides.html" "the build script targets docs/slides/simple-ai-workflow-slides.html"
present "$RENDER" "PORT=\"\${PORT:-8765}\"" "the renderer defaults to the confirmed port"
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

for term in "project" "global" "team" "knowledge" "skill" "road trip" "turn by turn" "brain" "tools" "context window" "out-of-band" "local"; do
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

absent "$DECK" "—" "deck has no em dashes"
absent "$GUIDE" "—" "guide has no em dashes"
for word in delve pivotal underscore testament tapestry showcase vibrant boasts meticulous intricate landscape foster garner interplay bolster; do
    absent "$DECK" "$word" "deck drops the AI-tell word: $word"
    absent "$GUIDE" "$word" "guide drops the AI-tell word: $word"
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
    slides/diagrams/moe-routing.svg \
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

present "$ROOT/support-files/slides-html.template.html" "2.4rem" "the template keeps the 2.4rem story body"
present "$ROOT/support-files/slides-html.template.html" "1.9rem" "the template keeps the 1.9rem appendix"
present "$ROOT/support-files/slides-html.template.html" "1.5rem" "the template keeps the title size"
present "$ROOT/support-files/slides-html.template.html" "1.65rem" "the template keeps the divider size"
present "$ROOT/support-files/slides-html.template.html" "1.8rem" "the template keeps the section prompt size"
present "$ROOT/support-files/slides-html.template.html" "3.3rem" "the template keeps the diagram title size"
present "$ROOT/support-files/slides-html.template.html" "84vh" "the template keeps the titled diagram height"
present "$ROOT/support-files/slides-html.template.html" "98vh" "the template keeps the image-only height"
present "$PREVIEW" "deck-source" "the HTML embeds the Markdown deck"
present "$PREVIEW" "section-slide" "the HTML styles the section dividers"
present "$PREVIEW" "diagram-only" "the HTML sizes the full-slide diagrams"
present "$RENDER" "google-chrome" "renderer uses Google Chrome"
present "$RENDER" "docs/slides/simple-ai-workflow-slides.html" "renderer uses the HTML deck"
build_tmp="$(mktemp)"
if bash "$ROOT/support-files/build-slides-html.sh" "$build_tmp" >/dev/null 2>&1 && cmp -s "$build_tmp" "$PREVIEW"; then
    pass "the HTML deck matches a fresh build"
else
    fail_case "the HTML deck does not match a fresh build"
fi
rm -f "$build_tmp"
present "$README" "docs/simple-ai-workflow-slides.md" "README links the Markdown deck"
present "$README" "docs/slides/simple-ai-workflow-slides.html" "README links the HTML deck"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: slide deck fixture."
    exit 1
fi
echo "PASSED: slide deck fixture (concepts, story, catalog, groups, roots, dials, knowledge and skills, team gate, assets, counts, preview, renderer)."
exit 0
