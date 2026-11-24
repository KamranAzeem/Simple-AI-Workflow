Reported: 2026-11-24
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Full slide deck review: per-slide screenshots, layout and diagram checks, and a voice rewrite.

Description:

Review all 59 slides of `docs/simple-ai-workflow-slides.md` and the HTML deck with per-slide 1600x900 screenshots. Check text size, diagram size and placement, layout, overflow and clipping, and whether each diagram matches its slide. Rewrite the speaker notes and the guide sections the deck cites in the user's voice. Rebuild the HTML, re-render, and re-review.

The user's words: "There are some slides that I do not like" and "the tone seem somewhat robotic and stiff. What happened to using my tone / voice / style?"

This ticket supersedes `ai/issues/closed/token-saving-strategies-slide.md`. The token slide, the MoE diagram, the HTML build and render flow, the tests, and the review reports carry over. The token branch is committed and held as the review base; it is not merged or released on its own.

Source: the user's request on 2026-11-24; `docs/simple-ai-workflow-slides.md`; `support-files/render-slides-preview.sh`; `~/.ai/settings/global-user-settings.md`; `ai-policy-common.md` (`## Humanized Output`); `ai/shared/project-knowledge/slide-deck-visual-system.md`.

Scope:

- 59 slides, per-slide PNGs, visual and structural checks.
- Story body 2.4rem, appendix 1.9rem, the special-slide heights, and 84/98vh for the full-slide diagrams; labels at least 24 units or a recorded exception; layout, overflow, and diagram accuracy.
- The catalog em-dash separator replaced by a colon; the visual system updated with the appendix size, the 24-unit rule, and the separator.
- The voice rewrite of the speaker notes and the cited guide sections 7, 13, 14, 23, and 24.
- The HTML rebuild, `bash tests/run-all.sh`, the validator, markdownlint, shellcheck, and the user's visual approval.
- The release draft and its documents when the release is confirmed.

Acceptance criteria:

- Every slide reviewed; a per-slide findings log; 59 slides and the 59 PNGs in the findings log.
- No overflow or clipping; story body 2.4rem and appendix 1.9rem; full-slide diagrams within 84/98vh and the special slides keep their heights; every label at least 24 units or a recorded exception.
- The notes and the cited guide sections in the user's voice; the banned words and em dashes absent; the catalog has no em dashes.
- `bash tests/run-all.sh`, the validator, markdownlint, and shellcheck pass; the implementation review is APPROVED.
- The release documents are written when confirmed; the user's visual approval is in the checkpoint and the ticket; one merge and release.

---
2026-11-24
Visual approval: the user approved the deck after the ladder, customer-root, quality-loop, and arrow fixes, on 2026-11-24.
Review: review-115 APPROVED (0 Critical, 0 Major, 0 Minor).
Gates: suite 31/31, validator 8/8, markdownlint 0, shellcheck 0, audit 59/0 overflow.
Release: v7.3.1 prepared on the branch; publication follows this close.
Plan attached below.

## Implementation Plan

# Full slide deck review: screenshots, layout, diagrams, and voice

**Status**: Implementation complete; review-115 APPROVED; awaiting the checkpoint, ticket close, and delivery.
**Repo**: KamranAzeem/Simple-AI-Workflow
**Base**: feature/token-saving-strategies-slide (commit 94a7b2f; one commit ahead of master, verified at review-111; the preflight re-checks the head)
**Branch**: feature/full-slide-deck-review (created at implementation)
**Merge mode**: direct
**Issue**: `ai/issues/in-progress/full-slide-deck-review.md`

## Objective

Review all 59 slides of `docs/simple-ai-workflow-slides.md` and the HTML deck with per-slide 1600x900 screenshots. Check text size, diagram size and placement, layout, overflow, and each diagram's content. Rewrite the speaker notes and the guide sections the deck cites in the user's voice. Rebuild the HTML, re-render, and re-review.

The token branch is the base, not a discard. Its token slide, MoE diagram, HTML build and render flow, tests, and review reports are reused. The token ticket is closed as superseded by this ticket.

## Scope

In:

- Per-slide PNGs for all 59 slides via `bash support-files/render-slides-preview.sh`.
- The visual and structural checks: text size, diagram size and placement, overflow, clipping, balance, and diagram accuracy.
- The voice rewrite of the speaker notes and the guide sections the deck cites: Sections 7, 13, 14, 23, and 24.
- The catalog format fix: replace the em-dash separator with a colon and update the visual system.
- The visual system update: appendix 1.9rem, the 24-unit label rule, and the catalog separator.
- The HTML deck rebuild, the tests, the validator, markdownlint, shellcheck, and the implementation peer review.
- The release draft and its three documents when the release is confirmed.
- The user's visual approval, the checkpoint, the ticket close, and the delivery.

Out:

- The presentation policy and the Google Slides and Gate 2 item.
- New deck topics beyond the review.
- Changes to the build and render flow. The template CSS may change for layout.
- The rest of `docs/workflow-guide.md` beyond the cited sections; the review reports its words-to-avoid hits without rewriting them.
- The customization-tracking fix, which has its own branch.

## HLD

- **One artifact, two passes**: a visual and structural pass over every rendered slide, and a voice pass over the speaker notes and the cited guide sections. The facts and the storyboard stay; the presentation changes.
- **Screenshot surface**: the renderer already produces 1600x900 PNGs for all slides in `ai/artifacts/slides-preview/`. The review is per slide, not a skim of the deck.
- **Findings log**: one line per slide in `ai/artifacts/slides-review/findings.md`, with the PNG, the observed issue, the fix, and the status. The user's named dislikes are prioritized; the log still covers all 59.
- **Type scale**: the story body is 2.4rem; the appendix is 1.9rem; the title slide is 1.5rem; the section prompts are 1.8rem; the section list is 1.65rem; the diagram-slide title is 3.3rem with a 1.9rem subtitle. This is the user's 2026-11-24 size choice.
- **Diagram floor and special heights**: the 24-unit label floor is a target for the diagram text. The review measured every SVG; it raised the labels and records the slide-20 exception. Full-slide titled diagrams use 84vh and image-only diagrams 98vh; the 95vh titled request cannot fit with the 2.4rem body and the title. The road-trip (38vh), axe (35vh), customer root (74vh), and close (26vh) keep their fitted heights; the title image stays hidden.
- **Voice**: the user's settings (`~/.ai/settings/global-user-settings.md`) and the common policy's `## Humanized Output`. First person where the notes address the audience; short sentences; plain words; a story where it helps. Remove the stiff third person, the "the audience" framing, and the "old deck" references. Keep the intentional visible line "We sharpen your axe. We also chop wood" as an explicit exception unless the user asks otherwise. Keep the technical claims and re-verify them.
- **Catalog**: the visual system mandates an em-dash separator in every catalog line, which conflicts with the common policy's em-dash ban. Replace it with a colon across the catalog and update the visual system, so the ban can be absolute and testable.
- **Delivery**: the review branch stacks on the committed token branch. The combined change merges once, so the deck the user dislikes is not released first.

### ADRs

- **ADR-001**: Keep the token branch as the review's base. Reason: the user rejected the visual and voice quality, not the HTML build and render flow or the token content. Consequence: the token ticket closes as superseded; the token work is committed first; the review branch is created from that commit; the combined delivery merges once; both branches are deleted after the merge.
- **ADR-002**: Use the existing renderer for per-slide PNGs. Reason: it already renders each slide at 1600x900; no new tooling is needed. Consequence: the findings log references `ai/artifacts/slides-preview/`; the renderer's port remains 8765.
- **ADR-003**: Rewrite the voice, keep the facts and the storyboard. Reason: the user's complaint is presentation, not content; a rewrite that changes the claims would need new evidence. Consequence: the notes and the cited guide sections are rewritten; every claim is re-checked against the guide, the policies, and the procedure.
- **ADR-004**: Review the visuals and the voice in one ticket. Reason: the user sees them as one quality problem; a visual-only pass would leave the stiff tone. Consequence: the plan's acceptance criteria cover both; the user approves both.
- **ADR-005**: Hold the release until the review passes. Reason: avoid shipping a deck the user dislikes. Consequence: v7.3.1 is deferred; the release version is confirmed at the release draft.
- **ADR-006**: Replace the catalog's em-dash separator with a colon. Reason: the common policy bans em dashes and the user's voice rules avoid them; the visual system's em-dash mandate is the conflict. Consequence: the catalog and the visual system change together; the fixture scans the deck for em dashes.
- **ADR-007**: Include the release documents in the delivery when the release is confirmed. Reason: the token plan carried an announcement, a banner, and a release-practices entry; a release without them is incomplete. Consequence: the plan has a release-draft step and the three documents; if the release is not confirmed, the plan records no release and skips the tag and publish.
- **ADR-008**: Bind the voice scope to the speaker notes and the cited guide sections. Reason: the user's complaint is the deck, and the cited sections are the deck's guide surface. Consequence: the whole guide is out of scope; the review reports its other words-to-avoid hits without rewriting them.
- **ADR-009**: Treat the 24-unit label floor as a target with recorded exceptions, not a silent hard gate. Reason: at least 14 existing SVGs use text below 24 units, and the visual system permits a smaller scale on dense diagrams. Consequence: the review raises the labels it can and records each exception with the user's approval; the fixture asserts the MoE floor; the findings log reports the rest.

## LLD

1. **Render**: run `PORT=8765 bash support-files/render-slides-preview.sh`; confirm 59 PNGs in `ai/artifacts/slides-preview/`. Record the deck count and the PNG count.
2. **Inspect each slide**: for every PNG, check:
   - text: no overflow or clipping; the story body is 2.4rem; the appendix is 1.9rem; the title and section dividers keep their template sizes unless the visual pass shows a problem; headings readable; no orphan lines;
   - diagram: full-slide diagrams fit the 84vh titled or 98vh image-only rule; the road-trip, axe, and close keep their template heights; the title image stays hidden; every label is at least 24 units or has a recorded user-approved exception; no overlap; the diagram matches the slide text;
   - layout: balance, margins, whitespace, and the title and body relationship.
3. **Log findings**: write `ai/artifacts/slides-review/findings.md`, one line per slide: the slide number, the PNG path, the issue, the intended fix, and the status. Prioritize the user's named slides.
4. **Fix the visuals**: edit `docs/simple-ai-workflow-slides.md`, the SVGs under `docs/slides/diagrams/`, and the CSS in `support-files/slides-html.template.html` only when the layout requires it. Update `ai/shared/project-knowledge/slide-deck-visual-system.md`: correct the appendix to 1.9rem, add the 24-unit label rule, change the catalog separator to a colon, and replace the dense-diagram smaller-scale guidance (all occurrences) with the recorded-exception rule. Replace the catalog's em dashes in the deck. Measure every SVG's label sizes; raise the labels below 24 units or record the exception with the user.
5. **Rewrite the voice**: rewrite the speaker notes and the guide sections the deck cites in `docs/workflow-guide.md`: Sections 7, 13, 14, 23, and 24. Apply the settings' voice and the common policy's `## Humanized Output`; keep the intentional visible "We sharpen your axe. We also chop wood" line as an exception. Keep the facts, the owning sections, and the technical terms. Report the words-to-avoid hits in Sections 1, 10, and 16 without rewriting them.
6. **Rebuild and re-render**: run `bash support-files/build-slides-html.sh`; confirm the HTML changes only as expected; re-run the renderer; re-inspect all 59 slides, because a template CSS change can affect any slide.
7. **Tests**: update `tests/test-slides.sh` for the changed phrases and the size and voice checks. Assert 59 slides (the 58 separator lines plus one); do not assert the PNGs in the fixture. Record the 59 PNGs from LLD 1 in the findings log and the Evidence. Report the diagrams below the 24-unit floor (except the MoE) in the findings log. Assert the story 2.4rem and appendix 1.9rem values, the MoE 24-unit floor, and no em dashes in the deck or the cited guide sections. Scan the notes and the cited guide for the common policy's banned words and em dashes. Do not hardcode the user's personal words-to-avoid list in the repo; check that list in the review.
8. **Validation**: run `bash tests/run-all.sh`, `support-files/validate-protocol.sh`, markdownlint, and shellcheck on every changed shell file (`tests/test-slides.sh` and any changed build or render script); all pass.
9. **Review**: run the implementation peer review; fix every Critical and Major finding; re-review until APPROVED.
10. **Release draft**: if the release is confirmed, write `docs/announcements/<version>.md`, move the README banner to `<version>`, and add the `<version>` entry to `ai/shared/project-knowledge/release-practices.md`. Show the exact draft; wait for the user's edits and approval; write the final documents in the branch.
11. **Approval and close**: show the rebuilt deck; record the user's visual approval in the checkpoint and the ticket; run the checkpoint; close the ticket with the plan attached; delete the plan file.
12. **Deliver**: merge the review branch to master, delete the review and token branches, push, and tag and publish the confirmed release.

## Evidence

- The token base: commit 94a7b2f, one commit ahead of master, verified at review-111; the implementation preflight re-checks the head SHA and count.
- The deck: `docs/simple-ai-workflow-slides.md` (769 lines, 59 slides); the built HTML `docs/slides/simple-ai-workflow-slides.html`.
- The renderer: `support-files/render-slides-preview.sh` (headless Chrome, 1600x900, `ai/artifacts/slides-preview/`); the renderer is run manually for the review; the fixture invokes the build with `bash`.
- The build: `support-files/build-slides-html.sh` and `support-files/slides-html.template.html`; the fixture invokes the build with `bash`.
- The visual rules: `ai/shared/project-knowledge/slide-deck-visual-system.md` (2.4rem story, 1.9rem appendix, 84vh titled diagrams, 98vh image-only). The 24-unit label rule is in the fixture and the visual system. The review raised the labels and records the slide-20 exception.
- The voice: `~/.ai/settings/global-user-settings.md` and `ai-policy-common.md` (`## Humanized Output`).
- The user's feedback, quoted: "There are some slides that I do not like" and "the tone seem somewhat robotic and stiff. What happened to using my tone / voice / style?"
- The token base: `ai/issues/closed/token-saving-strategies-slide.md` and the held token branch.
- The release documents: `docs/announcements/<version>.md`, `README.md`, and `ai/shared/project-knowledge/release-practices.md`.
- The suite: `bash tests/run-all.sh`; the slide fixture is part of the suite; record the result.
- The close evidence: the terminal-gate output, the merge commit, the branch deletions, the tag, the GitHub Release URL, and the checkpoint.

## Acceptance Criteria

- All 59 slides are rendered and reviewed; `ai/artifacts/slides-review/findings.md` records every slide.
- No text overflow or clipping; the story body is 2.4rem and the appendix 1.9rem; the full-slide diagrams fit 84/98vh and the special slides keep their heights; every label is at least 24 units or has the recorded user-approved exception; each diagram matches its slide.
- The speaker notes and the cited guide sections are in the user's voice; the common policy's banned words and em dashes are absent; the catalog has no em dashes; the technical claims are preserved and re-verified.
- The HTML deck rebuilds reproducibly; the findings log records the 59 PNGs.
- `bash tests/run-all.sh`, `support-files/validate-protocol.sh`, markdownlint, and shellcheck pass; the implementation review is APPROVED.
- When the release is confirmed, the announcement, the README banner, and the release-practices entry are written and approved; otherwise the plan records no release and skips the tag and publish.
- The user's visual approval is recorded in the checkpoint and the ticket; the ticket closes with the plan; the review branch merges to master; the token and review branches are deleted; the release is tagged and published when confirmed.

## Close Sequence

- **Repo**: KamranAzeem/Simple-AI-Workflow.
- **Base**: `feature/token-saving-strategies-slide` (the committed token base; 94a7b2f, verified at review-111). Confirm the count is at least 1 and record the head SHA at the preflight.
- **Branch**: `feature/full-slide-deck-review`.
- **Merge mode**: direct.
- **Ticket**: `ai/issues/in-progress/full-slide-deck-review.md`; the token ticket is closed as superseded.
- **Preflight**: after the token base commit, the remaining unrelated local items are `ai/notes/notes.md`, `ai/daily-checkpoints/2026-11-23.md`, and the three untracked tickets `ai/issues/open/global-to-workflow-policy-terminology.md`, `ai/issues/open/presentation-policy.md`, and `ai/issues/open/sync-script-init-scaffolding.md`. Park them with `git stash push -u -- <paths>` before the terminal gate, restore them with `git stash pop` after the merge, and re-run the validator to catch any empty mandatory directory the round-trip removes. The `README.md`, `ai/state/*`, `ai/daily-checkpoints/2026-11-24.md`, the review ticket, the review plan, and the closed token ticket are part of the branch.
- **Implementation**: create the review branch from the base; move the review ticket to `in-progress/`; render, review, fix, and rewrite; rebuild the HTML; run the tests and the validator; run the implementation peer review; fix every Critical and Major finding; run the release draft when confirmed; wait for the user's visual approval; run the checkpoint; close the review ticket with the plan under `## Implementation Plan`; replace the active plan link with `Plan attached below.`; delete the plan file.
- **Commit**: commit the review branch; confirm the branch is at least one commit ahead of its base and the tree is clean after the parking; record the terminal-gate output.
- **Delivery**: squash-merge the review branch to `master`; delete the review and token branches; `git push origin master`; when the release is confirmed, `git tag -a <version> -m "Release <version>"`, `git push origin <version>`, and `gh release create <version> --title "<version>" --notes-file docs/announcements/<version>.md`; no post-merge commit.
- **Evidence**: the base SHA and count, the render output, the 59 PNGs, the findings log, the test, validator, lint, and shellcheck output, the implementation review reports, the user's visual approval, the terminal-gate output, the merge commit, the branch deletions, the tag, the GitHub Release URL, and the checkpoint.

## Open Decisions

- The release version: v7.3.1 is proposed; choose v7.4.0 if the review broadens the scope.
- The user's disliked slides: name them at the start; the review covers all 59.
- The per-diagram label-size exceptions: the review records each exception for the user's approval; a dense diagram keeps a smaller scale only with that approval.

## Peer Review Log

- review-110: CHANGES REQUESTED (1 Critical, 10 Major, 9 Minor). Fixed.
- review-111: CHANGES REQUESTED (2 Major, 7 Minor). Fixed.
- review-112: APPROVED (6 Minor; six clarifications applied).
- review-113: CHANGES REQUESTED (5 Major, 8 Minor). Fixed; the out-of-scope words-to-avoid hits left as reported.
- review-114: CHANGES REQUESTED (the tree changed during review: the size pass, the tests, the stale findings). Resolved by the 2.4rem choice.
- review-115: APPROVED (0 Critical, 0 Major, 0 Minor; 3 Suggestions). The 59 PNGs are re-rendered at 12:09; the axe quote, findings headers, and plan thresholds are current.
- The user's 2026-11-24 size decision: keep 2.4rem, update the tests, the visual system, and the plan; the titled diagrams cap at 84vh.
