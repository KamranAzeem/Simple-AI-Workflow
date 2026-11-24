Reported: 2026-11-24
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add a dedicated token-saving strategies slide, including the MoE diagram and its limits.

Description:

Add one dedicated slide to the deck that collects the token-saving strategies the protocol uses, and include the MoE diagram. The slide must state where the MoE analogy is accurate and where it is not.

Source: the user's request on 2026-11-24; `docs/workflow-guide.md` Section 13 (Token Rationing & JIT Context Loading); `docs/simple-ai-workflow-slides.md` line 671; the `token-budget.svg` diagram.

Token-saving strategies to cover:

- Boot loads only the always-needed set: the common policy plus the Active Expertise policies. Other policies load by trigger or by name.
- Knowledge is indexed at boot, not loaded: Global, Project, and Team knowledge contribute paths, filenames, and domains; the full text loads only when a task needs it.
- The boot discovery is scoped: boot roots, the exclusion list, and the 16 KB cap; when a root exceeds the cap, print counts and query the rest on demand.
- Skills are indexed by name and a one-line description; the body loads for the task only.
- State files are summaries: three short bullets per item, 300-character lines, a 30,720-byte shared budget, and a 14-day progress window; the daily checkpoints are the archive.
- The latest checkpoint is read once and reused. Post-compaction recovery does not read the state files.
- The trigger index is ephemeral: rebuilt at load context, recovery, and checkpoint; it is not a cache.
- Release checks (validator and lint) run at release time, not on every boot.
- The token-budget and JIT model keep the context window lean; see the `token-budget.svg` diagram.

MoE assessment for the slide:

- A real Mixture-of-Experts model routes each token to a subset of experts. Total parameters grow, while active parameters per token stay small. It saves inference compute per token, not prompt or context tokens. It costs memory (all experts resident) and routing overhead.
- The protocol's analogy is conditional loading: route a request to the relevant policy or skill "expert" instead of loading every policy. That does save context tokens, but the router is the user, a trigger, or Active Expertise, not a learned gate. A wrong route can miss a rule; the always-on common policy is the safety net.
- The slide must say "MoE-inspired conditional loading," not "MoE saves context." Show the difference: sparse activation versus sparse context.
- The diagram should show a router sending a request to two of N experts, beside a panel of "all policies loaded" versus "active expertise only."

Draft the diagram as `docs/slides/diagrams/moe-routing.svg`, or use the user's existing MoE diagram or PPTX source.

Acceptance criteria:

- One dedicated slide, with speaker notes, placed with the maintenance and token material.
- The MoE diagram is included and follows the deck's visual system.
- The slide covers the strategies above and states the MoE limits; it does not claim MoE saves prompt tokens.
- `docs/workflow-guide.md` Section 13 is cross-referenced; add a guide note only if the slide introduces a concept the guide does not carry.
- `tests/test-slides.sh`, markdownlint, and the deck checks pass; peer review is approved.

---
2026-11-24
Plan attached below.

---
2026-11-24
Superseded by the full slide deck review ticket at `ai/issues/open/full-slide-deck-review.md`. The token slide, the MoE diagram, the HTML build and render flow, the tests, and the review reports carry into that ticket. The work is committed on its own branch and held as the review's base; it is not merged and not released. The attached plan's 78vh decision is replaced by 84vh in the current visual system and template; the visual and release approvals move to the review ticket.

## Implementation Plan

**Note (2026-11-24)**: This plan is superseded. The token work is committed on the token branch. The 78vh decision is replaced by 84vh in the review plan and the current visual system; the visual and release approvals moved to the review ticket. The catalog em dash and the appendix type are addressed in the review plan.

# Token-saving strategies slide

**Status**: Superseded. The token work is committed on the token branch; the visual and release approvals moved to the full slide deck review ticket; the 78vh decision is replaced by 84vh in the review plan and the visual system.
**Repo**: KamranAzeem/Simple-AI-Workflow
**Base**: master
**Branch**: feature/token-saving-strategies-slide (created at implementation)
**Merge mode**: direct
**Issue**: `ai/issues/in-progress/token-saving-strategies-slide.md`

## Objective

Add one dedicated deck slide on the protocol's token-saving strategies, with a MoE diagram and the honest MoE distinction. Start the local server for the HTML deck during the work so the user can review the deck as it changes.

## Scope

In:

- The new slide and its speaker notes in `docs/simple-ai-workflow-slides.md`.
- The new diagram `docs/slides/diagrams/moe-routing.svg`, or the MoE diagram recovered from `ai/artifacts/Simple-AI-Workflow.pptx` and adapted into that same path.
- A short "MoE analogy" note in `docs/workflow-guide.md` Section 13.
- The slide and preview test additions.
- The HTML deck and the rendered PNG review.
- The patch release v7.3.1, the announcement, the README banner, and the release-practices entry, if the user confirms the release.
- The ticket close and the checkpoint.

Out:

- Policy and procedure changes.
- The bootstrap and the other docs or slide tickets.
- The manual Google Slides copy.
- The global settings and the team store.

## HLD

- **Placement**: after `## Load the index, not the world` (the context-budget slide) and before `## When the context is compacted, the rules can vanish`. The deck flows index, then route, then compaction.
- **One full-diagram slide**: the title asserts, the SVG carries the model-versus-protocol contrast and the strategy labels, and the slide has no bullet list or paragraph. The preview renders the titled diagram at 78vh, the visual system's diagram-slide convention; the image-only pure diagrams keep the separate 88vh path.
- **The diagram has two panels**:
  - Left, the model: a router sends each token to a few of N experts. All parameters stay resident; active parameters per token stay low. It saves compute per token, not prompt tokens, and it costs memory and routing.
  - Right, the protocol: the common policy and the state are always on; knowledge and skills are indexed; the user, a trigger, or the Active Expertise routes a task to the relevant policy or skill; reads are scoped; the state is compact; the trigger index is ephemeral; the release checks run at release time. The common policy is the floor. A muted "other policies: not loaded" box makes the contrast with the "common policy and active expertise" set explicit.
- **The strategy labels and the notes together cover the issue's list**. Labels 1, 2, 3, 4, 7, and 8 sit on the diagram; the notes add 5, 6, and 9.
- **Honesty**: the slide says "MoE-inspired conditional loading" visibly and in the notes. The notes state the difference: sparse activation saves compute per token; the protocol's routing saves context tokens, and a wrong route can miss a rule.
- **The diagram source**: inspect `ai/artifacts/Simple-AI-Workflow.pptx` first. If it carries a MoE diagram, adapt it into `docs/slides/diagrams/moe-routing.svg`; otherwise create that SVG. Record the choice in the evidence.
- **The guide**: Section 13 gains a short `### The MoE analogy` note with the same distinction, so the deck and the guide agree.
- **The HTML deck**: `support-files/build-slides-html.sh` builds `docs/slides/simple-ai-workflow-slides.html` from the canonical Markdown, embedding the source and the reveal.js and marked CDNs. `python3 -m http.server 8765 --bind 127.0.0.1 --directory "$(git rev-parse --show-toplevel)"` serves it; the user opens `http://127.0.0.1:8765/docs/slides/simple-ai-workflow-slides.html`. The renderer opens the same page.
- **The release**: a patch, v7.3.1, because the deck and the guide are user-facing documentation.

### ADRs

- **ADR-001**: Place the slide between the index slide and the compaction slide. Reason: the deck already teaches the index idea, the slide explains the routing idea, and compaction follows. Consequence: the slide's hash and the manual Google Slides copy shift by one; the fixture asserts the slide content, not the hash.
- **ADR-002**: Use one full-slide two-panel SVG, not a bullet list plus a small image. Reason: the visual system renders a titled diagram at 78vh and an image-only pure diagram at 88vh, and the strategy labels fit in the diagram. Consequence: the SVG uses a style block with a smaller scale; the smallest label is 24 units in the 1600x900 viewBox; the titled slide renders at 78vh; the rendered PNG is checked for overlap.
- **ADR-003**: Frame the MoE as conditional loading, not as token saving. Reason: MoE saves compute per token, not prompt tokens; the protocol's routing saves context tokens; the common policy is the floor. Consequence: the slide, the notes, and the guide state the limit; the fixture asserts the exact phrase.
- **ADR-004**: Ship the user-facing deck and guide change as a patch release, v7.3.1, only when the user confirms it. Reason: the protocol treats user-facing docs as release-worthy, and the release notes belong on GitHub Releases while the short announcement stays in `docs/announcements/`. Consequence: the release docs are drafted for approval, written in the branch, and tagged only when confirmed; otherwise the ticket records no release.
- **ADR-005**: Run the HTML deck during the implementation and wait for the user's visual approval before the branch commit. Reason: the "review along the way" request makes the rendered slide a real gate, not a cosmetic step. Consequence: the approval is recorded in the checkpoint and the ticket.

## LLD

1. `docs/simple-ai-workflow-slides.md`: after the closing `---` of the "Load the index, not the world" slide, insert:

   ```markdown
   ## Route the context, do not load it all

   ![MoE-inspired context routing](slides/diagrams/moe-routing.svg)

   <!-- Speaker notes: ... the nine strategies, the MoE limit, the owning sections ... -->
   ```

   The title is the assertion. The speaker notes enumerate all nine strategies and state "MoE-inspired conditional loading" and the limit. The notes cite the owning sections.

2. `docs/slides/diagrams/moe-routing.svg`: a 1600x900 SVG in the deck's visual system, Lato and the teal and slate palette, a `title` and `desc`, and the two panels above. The left panel shows a router and N experts with two active. The right panel shows the always-on common policy and state, the knowledge and skills index, the router, the strategy labels, and the muted "other policies: not loaded" box. The caption adds a different idea: "Sparse activation is not sparse context." The visible phrase "MoE-inspired conditional loading" appears in the diagram. The style block sets the smallest label to 24 units.

3. `docs/workflow-guide.md`: add `### The MoE analogy` under Section 13, after `### Benefits` and before `### Boot-time staleness check`. The note distinguishes the boot set (common policy plus Active Expertise), the trigger route (a global policy), and the skill route (a description match), and states the MoE limit.

4. `tests/test-slides.sh`: add the new SVG to the asset loop and assert the deck reference, the exact phrase "MoE-inspired conditional loading," the caption "Sparse activation is not sparse context," the guide's "The MoE analogy," the HTML deck embeds the Markdown source, the build script reproduces `docs/slides/simple-ai-workflow-slides.html`, the SVG's minimum font-size of 24 units, and the distinctive strategy phrases (16 KB, 30,720 bytes, 300 characters, 14 days, Team knowledge, recovery skips the state files). The renderer's port remains 8765.

5. Release docs: `docs/announcements/v7.3.1.md`; the README banner moves to v7.3.1; `ai/shared/project-knowledge/release-practices.md` gets a v7.3.1 entry. These are written only when the user confirms the release. No test currently pins the banner or the announcement version; add a fixture assertion for the banner and the announcement path if the release ships. The release body goes on GitHub Releases; the short announcement stays in the docs.

6. The HTML deck: build `docs/slides/simple-ai-workflow-slides.html` with the build script before the user review; start the server; give the user the URL; render the PNGs after the diagram and the slide are in place; inspect for overlap and for the 24-unit minimum; wait for the user's visual approval before the branch commit. Record the approval in the checkpoint and the ticket.

7. The ticket: it already carries the dated plan entry. Do not append it again. Move it to `in-progress/` when the branch opens; close it in the branch with the plan under `## Implementation Plan`; replace the active plan link with `Plan attached below.`; delete the plan file.

8. The checkpoint: write it on the branch before the commit.

### The nine strategies and their owners

The slide and the notes together carry all nine. Labels 1, 2, 3, 4, 7, and 8 sit on the diagram; the notes add 5, 6, and 9.

1. **Boot set**: the common policy plus the Active Expertise policies; other policies load by trigger or by name. Owner: the guide Section 13, the policy loading set, the customization.
2. **Knowledge index**: Global, Project, and Team knowledge contribute paths, filenames, and domains at boot; the full text loads on demand. Owner: the guide Section 13 and Section 23.
3. **Scoped boot**: boot roots, the exclusion list, the 16 KB cap, and print-counts-then-query. Owner: the guide Section 13 and the load-context procedure.
4. **Skill index**: name and one-line description; the body loads for the task only. Owner: the guide Section 24.
5. **Compact state**: three short bullets per item, 300-character lines, a 30,720-byte shared budget, a 14-day progress window, and the daily checkpoint archive. Owner: the guide Section 14 and the common policy.
6. **Read the checkpoint once; recovery skips the state files**: the boot reuses the latest checkpoint read, and post-compaction recovery does not read the state files. Owner: the guide Sections 14 and 7 and the recovery procedure. Notes only.
7. **Ephemeral triggers**: the trigger index is rebuilt at load context, recovery, and checkpoint; it is not a cache. Owner: the guide Section 13 and the dispatch rules.
8. **Release-time checks**: the validator and lint run at release time, not on every boot. Owner: the release practices and the meta policy.
9. **JIT indexing**: the context window stays lean; see the JIT indexing slide and the guide Section 13. Owner: the guide Section 13. Notes only.

## Evidence

- The issue: `ai/issues/in-progress/token-saving-strategies-slide.md`.
- The deck: `docs/simple-ai-workflow-slides.md`; the index slide's closing separator is line 388; the new slide follows it; the compaction slide starts at line 398.
- The JIT indexing slide carries the technique list; the MoE slide carries the diagram.
- `docs/workflow-guide.md` Section 13: start near line 276; `### Benefits` near line 292; `### Boot-time staleness check` near line 298.
- The visual system: `ai/shared/project-knowledge/slide-deck-visual-system.md`. One idea per slide; a full-slide diagram; 78vh for the titled diagram; the palette; the style block; the overlap check; the caption must not repeat the slide title.
- The HTML deck and renderer: `docs/slides/simple-ai-workflow-slides.html` is built by `support-files/build-slides-html.sh` from the canonical Markdown; `support-files/render-slides-preview.sh` starts the server and opens the page; the default port is 8765.
- The slide fixture: `tests/test-slides.sh`. The deck needs at least 30 separators; the asset loop checks the deck references; the HTML deck and the build are checked.
- The release practices: the v7.3.0 entry and the announcement and banner pattern; the release body goes on GitHub Releases.
- The source deck: `ai/artifacts/Simple-AI-Workflow.pptx` exists; slide 34 carries the MoE scene (MoE LLM, the Cloud expert, Medicine/Programming/Automobiles); the new SVG adapts that idea and its labels rather than copying the slide images.
- The MoE definition: a learned gate routes each token to a subset of experts; active parameters per token are fewer than the total; compute per token scales with the active experts; memory scales with all experts; the input token count does not change. The slide states this qualitatively, with no numbers.

## Acceptance Criteria

- The new slide sits between the index slide and the compaction slide, and the deck references `slides/diagrams/moe-routing.svg`.
- The SVG shows the two panels, the strategy labels, the visible phrase "MoE-inspired conditional loading," and the caption "Sparse activation is not sparse context"; it follows the visual system.
- The SVG's smallest label is at least 24 units in the 1600x900 viewBox; the fixture asserts the minimum font-size; the rendered PNG at 78vh shows no overlap; the user's visual approval is recorded in the checkpoint and the ticket before the branch commit.
- The speaker notes enumerate all nine strategies with the owning sections and state the MoE limit.
- The guide states the same MoE distinction; the deck and the guide agree.
- `tests/test-slides.sh`, the suite, `support-files/validate-protocol.sh` (8/8), and markdownlint pass.
- The issue closes with the plan attached; the checkpoint is written on the branch; the terminal gate passes.
- When the user confirms v7.3.1, the release is tagged and published with the announcement; otherwise the close records no release.

## Close Sequence

- **Preflight**: use `Repo: KamranAzeem/Simple-AI-Workflow`, `Base: master`; confirm `git status --porcelain` shows only the plan and the issue (the work files); all unrelated modifications (`.gitignore`, `ai-customization.md`, `ai/state/*`, `ai/daily-checkpoints/*`, `ai/notes/notes.md`, `ai/procedures/load-context.md`, `design-docs/protocol-decisions.md`, `docs/ai-customization-guide.md`, and the three older untracked issues) are stashed or moved to their own ticket and branch; no unrelated commit on `master`.
- **Implementation**: create the branch; move the ticket to `in-progress/`; add the slide, the SVG, the guide note, the tests, and the HTML deck; do not write release docs here; start the server for the HTML deck; wait for the user's visual approval; run the tests, the validator, and markdownlint; run the implementation peer review; fix every Critical and Major finding.
- **Release draft**: if the release is confirmed, draft the announcement, the banner, and the GitHub Release body in a temp file; show the exact draft; wait for the user's edits and approval; write the final docs in the branch.
- **Branch close**: write the checkpoint on the branch and record the visual approval; close the ticket with the plan under `## Implementation Plan` and `Plan attached below.`; delete the plan file.
- **Commit**: commit the branch; confirm the terminal gate: the branch is at least one commit ahead of `master` and the tree is clean; record the gate result.
- **Delivery**: squash-merge to `master`; delete the branch; `git push origin master`; if the release is confirmed, `git tag -a v7.3.1`, `git push origin v7.3.1`, and publish the GitHub Release; otherwise record no release; no post-merge commit.

## Open Decisions

- The release v7.3.1 is proposed. Confirm the version, or choose no release.
- The preview port is 8765 (the renderer default). Confirm it, or choose another port and update the fixture and the renderer together.
- The slide title is "Route the context, do not load it all." Confirm it, or propose another.
- The diagram source is the PPTX if it carries a MoE diagram, adapted into `moe-routing.svg`; otherwise the new SVG. Confirm the choice after the inspection.
- The titled diagram renders at 78vh (the visual system's diagram-slide convention), amended from the plan's earlier 88vh. The user's approval is pending.

## Peer Review Log

- review-105: CHANGES REQUESTED (7 Major, 13 Minor). Fixed.
- review-106: CHANGES REQUESTED (3 Major, 13 Minor). Fixed.
- review-107: APPROVED. Minor polish applied.
- review-108: implementation CHANGES REQUESTED (1 Major, 10 Minor). Fixed; the 78vh amendment is presented for the user's approval.
- review-109: APPROVED (4 Minor; fixed).
