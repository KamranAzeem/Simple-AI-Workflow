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
- Implemented on `feature/slide-pipeline-and-presentation-policy`; reviews 165/166 APPROVED; v7.8.0 prepared.

---

2026-11-26

Closed. The implementation plan is attached below.

## Implementation Plan

# Plan: Slide authoring pipeline and presentation policy

## Goal

Add a D2/Mermaid pipeline for new or simple slide diagrams, add a presentation policy that fixes the standard, refresh the deck for v7.7.x, and keep the build and review loop under 15 minutes.

## Evidence

- Ticket `ai/issues/open/slide-authoring-pipeline-and-deck-refresh.md` (P2/L).
- The deck: `docs/simple-ai-workflow-slides.md` (769 lines), `docs/slides/simple-ai-workflow-slides.html` (928 lines), 59 slides, 28 SVGs, 59 preview PNGs.
- Hand-authored SVG cost: 76 labels at 24px; `knowledge-skills.svg` has 51 inline `font-size` declarations; `context-window.svg` has 46.
- Font floor: `ai/knowledge/slide-deck-visual-system.md:12` and `:21` say 24; `tests/test-slides.sh:183` only checks the MoE diagram.
- Stale terms: `docs/simple-ai-workflow-slides.md:249` (`Global ~/.ai/`, `global knowledge`, `global skills`), `:562` (`Global knowledge`), and `docs/slides/diagrams/six-jobs.svg:35` (`project and global knowledge`).
- Count surfaces: `support-files/validate-protocol.sh:377` (floor 25); `tests/test-user-settings-repair-fixture.sh:71`; `tests/test-team-knowledge.sh:189`; `tests/test-readme-shape.sh:82-84`; `README.md:219`; `docs/simple-ai-workflow-slides.md:438`; `docs/slides/simple-ai-workflow-slides.html:527`; `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:86`; `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:28`; `ai/knowledge/slide-deck-visual-system.md:39`. Historical announcements keep their old counts.
- Current counts: 25 policies, 16 procedures, 58 triggers, 33 test scripts.
- The deck build: `support-files/build-slides-html.sh` (38 lines) injects the Markdown into `support-files/slides-html.template.html`; `render-slides-preview.sh` (66 lines) and `audit-slides.sh` (58 lines) render and audit.
- The guide's `### The compaction phenomenon` embeds `docs/slides/diagrams/compaction.svg`; the deck's ladder is the six-level design and the PPTX has a different seven-level table.
- Tools: D2 v0.9.0 at `~/.local/bin/d2`; `mmdc` v12.2.0 at `~/.nvm/versions/node/v24.19.0/bin/mmdc`; Chrome `/usr/bin/google-chrome`; `~/.ai/settings/puppeteer-config.json`. D2 and mmdc smoke tests pass.
- The full review took 47 minutes; the trimmed scope in `ai/issues/open/slide-deck-review-speed.md` keeps the static guard, the exact 59 count, the subset render, and the audit-first loop.
- `ai/issues/open/presentation-policy.md` is the policy home and is deferred.

## Depth

M design depth, L execution breadth. Use the light path: context, a pipeline sketch, one ADR, and acceptance criteria. No separate HLD or LLD. The pipeline is one build script, one manifest, and one test extension; the policy is one module. This keeps the work fast and the plan readable.

## Context

The user wants the fastest slide path with low token use. The hand-authored SVGs are the bottleneck: they have no layout engine, so font increases collide; they are source and output, so every change is manual; the deck has no source-to-output build; the compaction diagram is a hand redraw; and the full review reads 59 PNGs twice.

The pipeline is: `docs/slides/diagrams/src/<name>.d2|.mmd` -> `support-files/build-slide-diagrams.sh` -> `docs/slides/diagrams/<name>.svg`, with `docs/slides/diagrams/manifest.tsv` recording source-backed or legacy with a reason. The test reads the manifest, checks every Markdown reference, and scans generated SVGs for a font below 32. The Markdown deck stays canonical; `build-slides-html.sh` rebuilds the HTML. Keep `build-slides-html.sh`: it is a 38-line injector, and retiring it adds work.

The change has four parts: a presentation policy that fixes the standard, the D2/Mermaid pipeline with a 32-unit floor, a content refresh for the v7.7.x scopes and stores, and a fast review loop that inspects only changed or flagged slides. The policy adds one module and one trigger, so the floor moves to 26 and the trigger count to 59; every current count surface must move with it. A new policy and trigger is a MINOR release, so v7.8.0 supersedes the ticket's PATCH note.

## Decisions (ADR)

````markdown
## 2026-11-26: Slides use a code-driven diagram pipeline and a presentation policy

The slide deck uses code-driven diagram sources. D2 is the default; Mermaid is an approved exception for sequence or flow diagrams that D2 handles poorly. Every new or changed diagram has a source in `docs/slides/diagrams/src/`, a manifest entry, and a generated SVG. The manifest marks untouched SVGs as legacy with a reason. Generated diagrams use a 32-unit font floor; legacy SVGs keep 24 until converted. A diagram already carried by the guide keeps its existing SVG; do not redraw it. The deck's six-level ladder keeps its existing SVG. The Markdown deck is canonical; the HTML is generated. The review loop is a static guard, a build, a render, and an inspection of changed or flagged slides only.

A new `ai-policy-presentation.md` states the standard, with `Mode: trigger` and the `presentation standards` trigger. The workflow policy floor becomes 26 and the trigger count becomes 59. The project-specific visual system stays in `ai/knowledge/slide-deck-visual-system.md`.

Context: the hand-authored SVGs have absolute coordinates and 76 labels at 24px, so raising the font collides. The deck has no source-to-output build, the compaction SVG is a hand redraw, and the full review took 47 minutes. The user wants the fastest path with low token use.

Consequences: the deck is rebuilt on the new sources; the old presentation-policy and slide-deck-review-speed tickets are superseded; the count surfaces move to 26 policies and 59 triggers; the next slide work starts from the standard, not a discussion.
````

## Deltas

1. `ai-policy-presentation.md` (new)
   - Add the workflow policy: purpose, scope, `## Loading` with `Mode: trigger`, `## Triggers` with `presentation standards`, narrative, layout, type and palette, source of truth, diagram pipeline, review, and references.
   - State the 32-unit generated-diagram floor, D2 default, Mermaid exception, source/manifest rule, guide/ladder rule, Markdown-canonical rule, and the changed-or-flagged review loop.
   - Move the policy floor to 26 and the trigger count to 59.
2. `design-docs/protocol-decisions.md`
   - Append the ADR above; add it to the `tests/test-docs-audit.sh` assertions.
3. Count sweep
   - Update `support-files/validate-protocol.sh:377`, `tests/test-user-settings-repair-fixture.sh:71`, `tests/test-team-knowledge.sh:189`, `tests/test-readme-shape.sh:82-84`, `README.md:219`, the deck Markdown and HTML counts, the compared doc, the map, and the visual-system knowledge.
   - Run `rg -n "25 policies|58 triggers|POLICY_FLOOR=25|all 25 policies|25 policy modules"` after the edits; update every current surface and leave the historical announcements.
   - If a fixture enumerates the policy set (`tests/test-policy-load-paths.sh`, `tests/test-policy-shape.sh`), add the new policy; the authoring and index validators already scan it.
4. Diagram pipeline
   - The D2 pipeline is for new or simple diagrams; the deck's existing diagrams are legacy with a reason.
   - Add `docs/slides/diagrams/manifest.tsv` with each diagram as source-backed or legacy with a reason.
   - Add `support-files/build-slide-diagrams.sh`; use D2 by default and Mermaid only for an approved exception. Accept `D2_BIN` and `MMDC_BIN` overrides; use the Puppeteer config for Mermaid.
   - Use a shared D2 style for the 32-unit font and the teal/slate palette.
5. Review tooling
   - Add a slide range to `support-files/render-slides-preview.sh`.
   - Keep `audit-slides.sh`; update its note for the 32 floor.
6. Tests
   - Extend `tests/test-slides.sh`: read the manifest; check every reference; fail on a missing source or output; scan generated SVGs for a font below 32; keep the legacy 24 with a reason; update the deck catalog and the 26/59 counts.
   - Extend `tests/test-docs-audit.sh` with the new ADR title and clause assertions.
   - No new test script.
7. `ai/knowledge/slide-deck-visual-system.md`
   - Record the 32-unit generated floor, the D2/Mermaid pipeline, the source/manifest rule, the guide/ladder rule, the fast review loop, and the 26-policy catalog.
8. `docs/simple-ai-workflow-slides.md` and the generated HTML
   - Replace the old scope and store names with Workflow, User, Team, Project; `ai/knowledge/`, `knowledge/`, and `user-settings.md`.
   - Convert the changed diagrams and rebuild the HTML; add the new policy to the appendix.
9. `README.md` and `docs/announcements/v7.8.0.md`
   - Update the policy and trigger counts and the banner; add the v7.8.0 announcement.
10. `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md`
    - Move the policy line to 26 modules, 12 domain and 14 protocol; add the presentation policy to the protocol set.
11. Tickets
    - Append the dated plan entry to the new ticket.
    - Close `presentation-policy.md` and `slide-deck-review-speed.md` as superseded with a dated note.
    - At close, attach the plan to the new ticket, delete the plan file, and move the ticket to `closed/`.
12. State
    - Checkpoint on the branch; update the knowledge and issue counts.

## Acceptance Criteria

- AC-1: `ai-policy-presentation.md` exists with `Mode: trigger` and `presentation standards`, and passes the authoring validator. Assertion: `bash support-files/validate-policy-authoring.sh ai/policies/ai-policy-presentation.md` prints `PASSED`.
- AC-2: The manifest, build, and test agree. Assertion: `bash support-files/build-slide-diagrams.sh` regenerates every source-backed SVG; `tests/test-slides.sh` fails on a missing source or output and on a reference not in the manifest.
- AC-3: No generated SVG has a font below 32; legacy SVGs keep their current size with a reason, and a future conversion raises them. Assertion: the fixture scan over the generated SVG set.
- AC-4: The compaction uses the guide's existing SVG and the ladder keeps the deck's six-level SVG. Assertion: the guide embed and the deck reference point at the same compaction file; no PPTX redraw is used.
- AC-5: No old term remains in the current deck, speaker notes, or diagrams. Assertion: `rg -n "Global ~/.ai|global knowledge|global skills|ai/shared/project-knowledge|global-settings" docs/simple-ai-workflow-slides.md docs/slides/diagrams` returns no match.
- AC-6: The new policy appears in the deck appendix and every count surface says 26 policies and 59 triggers. Assertion: `rg` on the current surfaces; `tests/test-slides.sh`; `tests/test-readme-shape.sh`.
- AC-7: The full gate passes. Assertion: protocol 8/8, authoring, suite 33/33, index 26/16/59 with 0 conflicts and 0 errors, markdownlint 0, shellcheck 0, no new test script.
- AC-8: The review loop is fast. Assertion: the checkpoint records a full build, render, and review under 15 minutes; only changed or flagged slides inspected; one diff-scoped review; no full 59-PNG read.
- AC-9: v7.8.0 is released; the new ticket is closed; `presentation-policy.md` and `slide-deck-review-speed.md` are closed as superseded. Assertion: `gh release view v7.8.0`; the ticket directories.

## Verification

- Run `bash support-files/build-slide-diagrams.sh`; all source-backed outputs regenerate.
- Run `bash tests/test-slides.sh`; the manifest, references, 32 floor, catalog, and 26/59 counts pass.
- Run `bash tests/run-all.sh`; expect `PASSED: 33 test scripts.`
- Run `bash support-files/validate-protocol.sh`; expect 8/8.
- Run `bash support-files/validate-policy-authoring.sh ai/policies/ai-policy-presentation.md`; expect PASSED.
- Run `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`; expect PASSED.
- Run `bash support-files/index-protocol.sh`; expect 26 policies, 16 procedures, 59 triggers, 0 conflicts, 0 errors.
- Run `markdownlint-cli2 "**/*.md" "#node_modules"`; expect 0.
- Run `shellcheck -S warning support-files/build-slide-diagrams.sh tests/test-slides.sh`; expect 0.
- Run `rg` for the old terms; expect no current hit.
- Run `rg` for the old counts; update every current surface and leave the historical announcements.
- Run `bash support-files/render-slides-preview.sh <changed range>` and the full render for the record; the guide's compaction SVG and the deck's six-level ladder are the reference.
- Run `gh release view v7.8.0` after the release.

## Peer Review Log

- review-165 on 2026-11-26: APPROVED. See `ai/code-review-reports/2026-11-26_11-28_review-165.md`. 0 Critical, 0 Major, 0 Minor, 3 Suggestions.
- review-166 on 2026-11-26: APPROVED. See `ai/code-review-reports/2026-11-26_12-04_review-166.md`. 0 Critical, 0 Major, 0 Minor, 2 Suggestions.

## Risks and Rollback

- Risk: the count sweep misses a surface. Mitigation: run the count grep after the edits; the tests pin the floor, the README, and the deck.
- Risk: a 32-unit floor overflows a dense diagram. Mitigation: convert the dense diagram, or record one exception with the slide and the reason.
- Risk: Mermaid needs Chrome. Mitigation: D2 is the default; Mermaid is the exception and uses the Puppeteer config.
- Risk: the guide's SVG and the deck's ladder are the reference. Mitigation: keep them; the D2 pipeline is for new diagrams.
- Risk: the review still burns tokens. Mitigation: the static guard, the subset render, and the changed-or-flagged inspection; no full 59-PNG read.
- Risk: superseding two deferred tickets loses work. Mitigation: the new plan absorbs their trimmed scopes; the close notes name what moved.
- Rollback: revert the squash commit; the new policy and the pipeline are additive; the old SVGs remain in history; reopen the two tickets if the standard is reversed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base `master`; merge mode `direct`.
- Approval: the implementation request plus this Close Sequence is the approval for the protected-branch baseline, the branch commits and push, the direct squash merge, the v7.8.0 tag and GitHub Release, and the local ticket closes.
- Baseline: on `master`, commit the new ticket, this plan, the state files, the map, and the daily checkpoint as `chore: record the slide pipeline plan and checkpoint`.
- Branch: `feature/slide-pipeline-and-presentation-policy` from the baseline; implementation commit `feature(presentation): add the slide standard and diagram pipeline`.
- Implementation: implement the policy, the pipeline, the content refresh, the tests, and the release docs; run the fast review; attach the plan to the new ticket; close it and the two superseded tickets; delete the plan file; write the checkpoint on the branch.
- Terminal gate: branch at least one commit ahead; clean tree; protocol 8/8; authoring; suite 33/33; index 26/16/59 with 0 conflicts and 0 errors; markdownlint 0; shellcheck 0; no new test script.
- Merge: squash to `master`, delete the branch, push.
- Release: tag `v7.8.0`, push the tag, publish the GitHub Release from the scrubbed announcement, and verify the public URL.
- Checkpoint: after the release; the tickets at `closed/`; the map and state counts updated; no post-merge commits.
- Evidence: the commands and results in the daily checkpoint.
