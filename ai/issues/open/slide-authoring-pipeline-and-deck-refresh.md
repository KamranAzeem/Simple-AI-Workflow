Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Move new and changed slide diagrams to a D2/Mermaid pipeline and add a presentation standard, then refresh the deck for v7.7.x

Description:

## Problem

- The 28 diagrams in `docs/slides/diagrams/` are hand-authored 1600x900 SVGs with absolute coordinates and inline font sizes. 76 labels are exactly 24px; `knowledge-skills.svg` has 51 inline size declarations and `context-window.svg` has 46. Raising a font size makes text collide because nothing reflows.
- The deck has a canonical Markdown file, a generated HTML file, 28 SVGs, a PPTX, and 59 PNG previews. There is no source-to-output build or manifest; the SVG is both source and output. The PPTX drifts from the HTML deck.
- `docs/slides/diagrams/compaction.svg` is a hand redraw (57 lines), not an export from `ai/artifacts/Simple-AI-Workflow.pptx`. It does not match the Google Slides original.
- The deck still carries old terms: `Global ~/.ai/`, `global knowledge`, and `global skills` at `docs/simple-ai-workflow-slides.md:249`; `project and global knowledge` at `docs/slides/diagrams/six-jobs.svg:35`. The v7.7.x names are Workflow, User, Team, Project; `ai/knowledge/`, `knowledge/`, and `user-settings.md`.
- The full review took 47 minutes and repeated AI reads of 59 PNGs. The static font floor is 24, and `tests/test-slides.sh:183` only checks the MoE diagram.

## Desired outcome

- One code-driven source per new or changed diagram. Use D2 for architecture and layout diagrams, and Mermaid for flows. Keep the generated SVGs in `docs/slides/diagrams/`; leave untouched legacy SVGs as they are.
- A build script and manifest. The manifest records each diagram as source-backed or legacy with a reason. Never hand-edit a generated SVG. A test fails when a source does not build or a referenced SVG is neither source-backed nor legacy.
- A 32-unit diagram font floor through the tool theme. No inline size below 32; allow a recorded exception only for a dense diagram.
- PPTX-origin diagrams are exported, not redrawn. The compaction slide matches the PPTX.
- The canonical Markdown is refreshed for v7.7.x, and no old term remains.
- A short presentation standard/policy fixes the narrative, layout, type, source-of-truth, and review rules, so future slide work starts from defaults instead of discussion.
- A full build, render, and review pass finishes in under 15 minutes; only changed or flagged slides are inspected; one diff-scoped peer review; no full 59-PNG AI read.

## Proposed approach

- Use the installed tools: D2 at `~/.local/bin/d2`, Mermaid CLI at `~/.nvm/versions/node/v24.19.0/bin/mmdc`.
- Add `docs/slides/diagrams/src/` for `.d2` and `.mmd`, add `support-files/build-slide-diagrams.sh` and a manifest that records each diagram as source-backed or legacy with a reason, and generate the SVGs.
- Keep `docs/simple-ai-workflow-slides.md` canonical. Keep `build-slides-html.sh` unless the plan retires it; rebuild the HTML from the Markdown.
- Export the PPTX diagrams with LibreOffice, or rebuild them once in D2/Mermaid with the PPTX as the visual reference. Do not hand-draw.
- Update the visual-system knowledge and the fixture to the 32 floor, the source check, and the PPTX rule.
- Update the deck text and only the diagrams that carry the changed terms: three roots, six jobs, knowledge/skills, two scopes, root files.
- Review loop: static guard, build, render, inspect changed or flagged slides, one diff-scoped peer review.

## Acceptance criteria

- AC-1: Every new or changed diagram has a D2 or Mermaid source; the manifest records each diagram as source-backed or legacy with a reason; the build script regenerates the source-backed diagrams; a test fails when a source does not build or a referenced SVG is neither source-backed nor legacy. Assertion: the build and the extended `tests/test-slides.sh`.
- AC-2: Every generated diagram label is at least 32 units; no inline size below 32 in a generated SVG; legacy hand-authored SVGs keep their 24-unit floor until converted; the fixture scans generated SVGs. Assertion: `tests/test-slides.sh`.
- AC-3: The compaction and other PPTX-origin diagrams match the PPTX, with an export or a rebuilt source rather than a hand redraw. Assertion: a rendered PNG compared with the PPTX slide; the source is recorded.
- AC-4: No old term remains in the deck, speaker notes, or diagrams. Assertion: `rg` for `Global AI|global knowledge|global skills|ai/shared/project-knowledge|global-settings`.
- AC-5: The presentation standard/policy exists and passes the authoring validator; it covers narrative, layout, type, source-of-truth, and review. Assertion: the validator and the policy tests.
- AC-6: A full build, render, and review pass takes under 15 minutes; only changed or flagged slides are inspected; one diff-scoped peer review; no full 59-PNG AI read. Assertion: the checkpoint records the elapsed time and the review scope.
- AC-7: The suite passes; no new test script unless the plan justifies one; extend `tests/test-slides.sh`.
- AC-8: The HTML deck is rebuilt and the rendered PNGs are inspected; the release is a PATCH if the plan carries one.

## Out of scope

- Redesigning the deck story or narrative.
- Converting all 28 diagrams in one pass; convert the changed and PPTX-origin diagrams first.
- Playwright or browser geometry checks; keep the static guard and the existing audit.
- The 47-minute full visual pass.

## Notes

- `ai/issues/open/presentation-policy.md` is the policy home and is deferred; this ticket adds the toolchain and deck execution. The plan decides whether to fold or supersede it.
- `ai/issues/open/slide-deck-review-speed.md` holds the trimmed review scope and is deferred; do not duplicate it.
- The tools are recorded in the user settings: D2 `~/.local/bin/d2` v0.9.0, `mmdc` `~/.nvm/versions/node/v24.19.0/bin/mmdc` v12.2.0, and Chrome `/usr/bin/google-chrome`. `mmdc` runs with `-p ~/.ai/settings/puppeteer-config.json`.
- Evidence: 28 SVGs; 76 labels at 24px; 51 and 46 inline sizes; `compaction.svg` is 57 lines; the PPTX is `ai/artifacts/Simple-AI-Workflow.pptx`; the previews are in `ai/artifacts/slides-preview/`.
- No branch exists yet; the ticket stays in `open/`.

---

2026-11-26

Plan: `ai/plans/slide-authoring-pipeline-and-presentation-policy.md`.
