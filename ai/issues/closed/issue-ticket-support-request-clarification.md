Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Clarify the difference between ticket, issue, and support request with examples

Description:

Source: `ai/notes/notes.md` point 4 (2026-11-24).

Delivery: this ticket ships on the combined documentation/slides branch with the other Documentation tickets from `ai/notes/notes.md`.

Goal: one small comparison table in this order: ticket, issue, support request. Give one example each.

Confirmed definitions:

| Term | Primary purpose | Typical creator | One-line example |
|---|---|---|---|
| Ticket | The overarching record or container that tracks any task from start to finish. | Automated system, support agent, or team member. | "Ticket #4092: Investigate and resolve the login outage reported by enterprise clients." |
| Issue | Tracks a specific code problem, bug, or new feature idea. | Developer, QA, or product manager. | "The checkout button throws a 500 error when applying a discount code on mobile." |
| Support request | Asks for help, guidance, or account/service assistance. | End user or customer. | "I forgot my password and the reset email is not arriving. Can you unlock my account?" |

Summary points:

- A ticket is the tracking container. A support request often enters as a support ticket, and a bug it reveals is linked to or converted into an engineering issue.
- An issue is engineering work in a codebase. It documents a defect, technical debt, or an enhancement.
- A support request is user-facing help. It rarely needs a source-code change and is handled by support.

Scope:

- Add the comparison table to `docs/workflow-guide.md`.
- Add one slide or speaker note to `docs/simple-ai-workflow-slides.md`.
- Keep the order ticket, issue, support request.

Acceptance criteria:

- The guide and the deck use the confirmed order and definitions.
- Each row has one example.
- The links resolve, markdownlint is clean, and the slide fixture passes.

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
