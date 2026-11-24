Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add a blackbox-versus-visible-state section and diagram to the guide and slides

Description:

Source: `ai/notes/notes.md` point 6 (2026-11-24).

Delivery: this ticket ships on the combined documentation/slides branch with the other Documentation tickets from `ai/notes/notes.md`.

The comparison doc already states the problem. The guide and the deck do not have a dedicated section and diagram. Add:

- a guide section that contrasts the assistant's private state outside the project (mixed, per-agent, unauditable) with the fixed `ai/` layout (visible, portable, auditable);
- an SVG diagram and a slide;
- a link to the comparison doc.

Scope:

- Add the section to `docs/workflow-guide.md`.
- Add the diagram to `docs/slides/diagrams/` and reference it from `docs/simple-ai-workflow-slides.md`.
- Keep the comparison doc as the long-form source and avoid duplicating it.

Acceptance criteria:

- The diagram exists and the slide references it.
- The guide section names the three problems: mixed state, per-agent layouts, and no audit trail.
- The slide fixture and link checks pass.

---
2026-11-24
Plan attached below.

## Implementation Plan

# Plan: Documentation and slide additions from the 2026-11-24 notes

## Evidence

- `ai/notes/notes.md` points 1, 4, 5, 6, 7, 8, and 9.
- Seven in-progress Documentation tickets: one-shot prompts, ticket/issue/support request, no vibe coding, blackbox state, wave-surfer framing, skills are not the workflow, and compaction.
- The destinations are `docs/workflow-guide.md` and `docs/simple-ai-workflow-slides.md`; no policy or procedure changes.

## Context

The user approved one branch for the Documentation items. The two Feature tickets, idea intake and the Kanban skill, stay off this branch and keep their own cycles.

## Acceptance criteria

- AC-1: The guide and the deck include the one-shot prompt guidance.
- AC-2: The guide and the deck show ticket, issue, and support request in that order with one example each.
- AC-3: The guide and the deck include the no-vibe-coding framing tied to acceptance criteria.
- AC-4: The guide and the deck include the blackbox state problem with a diagram.
- AC-5: The first slide only carries the training-session framing and the wave-surfer metaphor.
- AC-6: The guide and the deck say skills are part of a workflow and do not replace policies and procedures, with a diagram.
- AC-7: The guide and the deck explain the compaction phenomenon; the deck has a dedicated slide and diagram, and the speaker note keeps the manual recovery.
- AC-8: Links, markdownlint, the slide fixture, the docs audit, the protocol validator, and the suite pass.

## Close Sequence

- Repo: this repository.
- Base ref: `master`.
- Branch: `feature/docs-slides-notes-2026-11-24`.
- Merge mode: `direct`; `ai-customization.md` has no `## Merge Policy`.
- Tickets: the seven Documentation tickets; close them with this plan attached.
- Release: none; documentation and slides only.
- Evidence: link checks, markdownlint 0, shellcheck 0, slide and docs fixtures, protocol 8/8, suite green.

## Peer Review Log

- Round 1 (review-96): CHANGES REQUESTED. 2 Major and 12 Minor; fixed both Major findings and the actionable Minor findings.
- Round 2 (review-97): APPROVED. The remaining test-scope gap was fixed; two optional polish notes remain.
