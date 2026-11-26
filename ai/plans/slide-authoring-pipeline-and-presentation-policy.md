# Plan: Slide authoring pipeline and presentation policy

## Goal

Replace hand-authored slide SVGs with a D2/Mermaid source-to-SVG pipeline, add a presentation policy that fixes the standard, refresh the deck for v7.7.x, and keep the build and review loop under 15 minutes.

## Evidence

- Ticket `ai/issues/open/slide-authoring-pipeline-and-deck-refresh.md` (P2/L).
- The deck: `docs/simple-ai-workflow-slides.md` (769 lines), `docs/slides/simple-ai-workflow-slides.html` (928 lines), 59 slides, 28 SVGs, 59 preview PNGs.
- Hand-authored SVG cost: 76 labels at 24px; `knowledge-skills.svg` has 51 inline `font-size` declarations; `context-window.svg` has 46.
- Font floor: `ai/knowledge/slide-deck-visual-system.md:12` and `:21` say 24; `tests/test-slides.sh:183` only checks the MoE diagram.
- Stale terms: `docs/simple-ai-workflow-slides.md:249` (`Global ~/.ai/`, `global knowledge`, `global skills`), `:562` (`Global knowledge`), and `docs/slides/diagrams/six-jobs.svg:35` (`project and global knowledge`).
- Count surfaces: `support-files/validate-protocol.sh:377` (floor 25); `tests/test-user-settings-repair-fixture.sh:71`; `tests/test-team-knowledge.sh:189`; `tests/test-readme-shape.sh:82-84`; `README.md:219`; `docs/simple-ai-workflow-slides.md:438`; `docs/slides/simple-ai-workflow-slides.html:527`; `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:86`; `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:28`; `ai/knowledge/slide-deck-visual-system.md:39`. Historical announcements keep their old counts.
- Current counts: 25 policies, 16 procedures, 58 triggers, 33 test scripts.
- The deck build: `support-files/build-slides-html.sh` (38 lines) injects the Markdown into `support-files/slides-html.template.html`; `render-slides-preview.sh` (66 lines) and `audit-slides.sh` (58 lines) render and audit.
- The PPTX `ai/artifacts/Simple-AI-Workflow.pptx` is git-ignored; `soffice` is at `/usr/bin/soffice`. The compaction and AI ladder are the known PPTX-origin diagrams.
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

The slide deck uses code-driven diagram sources. D2 is the default; Mermaid is an approved exception for sequence or flow diagrams that D2 handles poorly. Every new or changed diagram has a source in `docs/slides/diagrams/src/`, a manifest entry, and a generated SVG. The manifest marks untouched SVGs as legacy with a reason. Generated diagrams use a 32-unit font floor; legacy SVGs keep 24 until converted. The PPTX-origin diagrams are rebuilt in D2 with the PPTX as the visual reference, or exported when a faithful rebuild is not possible. The Markdown deck is canonical; the HTML is generated. The review loop is a static guard, a build, a render, and an inspection of changed or flagged slides only.

A new `ai-policy-presentation.md` states the standard, with `Mode: trigger` and the `presentation standards` trigger. The workflow policy floor becomes 26 and the trigger count becomes 59. The project-specific visual system stays in `ai/knowledge/slide-deck-visual-system.md`.

Context: the hand-authored SVGs have absolute coordinates and 76 labels at 24px, so raising the font collides. The deck has no source-to-output build, the compaction SVG is a hand redraw, and the full review took 47 minutes. The user wants the fastest path with low token use.

Consequences: the deck is rebuilt on the new sources; the old presentation-policy and slide-deck-review-speed tickets are superseded; the count surfaces move to 26 policies and 59 triggers; the next slide work starts from the standard, not a discussion.
````

## Deltas

1. `ai-policy-presentation.md` (new)
   - Add the workflow policy: purpose, scope, `## Loading` with `Mode: trigger`, `## Triggers` with `presentation standards`, narrative, layout, type and palette, source of truth, diagram pipeline, review, and references.
   - State the 32-unit generated-diagram floor, D2 default, Mermaid exception, source/manifest rule, PPTX rule, Markdown-canonical rule, and the changed-or-flagged review loop.
   - Move the policy floor to 26 and the trigger count to 59.
2. `design-docs/protocol-decisions.md`
   - Append the ADR above; add it to the `tests/test-docs-audit.sh` assertions.
3. Count sweep
   - Update `support-files/validate-protocol.sh:377`, `tests/test-user-settings-repair-fixture.sh:71`, `tests/test-team-knowledge.sh:189`, `tests/test-readme-shape.sh:82-84`, `README.md:219`, the deck Markdown and HTML counts, the compared doc, the map, and the visual-system knowledge.
   - Run `rg -n "25 policies|58 triggers|POLICY_FLOOR=25|all 25 policies|25 policy modules"` after the edits; update every current surface and leave the historical announcements.
   - If a fixture enumerates the policy set (`tests/test-policy-load-paths.sh`, `tests/test-policy-shape.sh`), add the new policy; the authoring and index validators already scan it.
4. Diagram pipeline
   - Add `docs/slides/diagrams/src/` with D2 sources for the changed diagrams and the PPTX-origin compaction and AI ladder.
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
   - Record the 32-unit generated floor, the D2/Mermaid pipeline, the source/manifest rule, the PPTX rule, the fast review loop, and the 26-policy catalog.
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
- AC-3: No generated SVG has a font below 32; legacy SVGs keep 24 with a reason. Assertion: the fixture scan over the generated SVG set.
- AC-4: The compaction and AI ladder match the PPTX. Assertion: the D2 source and a rendered PNG compared with the PPTX slide; a faithful export is the fallback.
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
- Run `bash support-files/render-slides-preview.sh <changed range>` and the full render for the record; compare the compaction and ladder PNGs with the PPTX.
- Run `gh release view v7.8.0` after the release.

## Peer Review Log

- review-165 on 2026-11-26: APPROVED. See `ai/code-review-reports/2026-11-26_11-28_review-165.md`. 0 Critical, 0 Major, 0 Minor, 3 Suggestions.

## Risks and Rollback

- Risk: the count sweep misses a surface. Mitigation: run the count grep after the edits; the tests pin the floor, the README, and the deck.
- Risk: a 32-unit floor overflows a dense diagram. Mitigation: convert the dense diagram, or record one exception with the slide and the reason.
- Risk: Mermaid needs Chrome. Mitigation: D2 is the default; Mermaid is the exception and uses the Puppeteer config.
- Risk: the PPTX is a local, git-ignored reference. Mitigation: rebuild in D2 with the PPTX open; the D2 source is the durable record; export a faithful SVG/PNG only as the fallback.
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
