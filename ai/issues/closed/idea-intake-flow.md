Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add an idea intake flow to issue management with an Idea issue type

Description:

Source: `ai/notes/notes.md` point 2 (2026-11-24).

Goal: every idea is filed as a ticket, so the brainstorm or grilling is recorded in the ticket instead of the chat or the assistant's private state. The flow is idea, file it as `IssueType: Idea`, grill it, then continue the normal steps or close it with a dated `Won't fix` note. The checkpoint discussed-idea line stays as the backstop.

Decisions:

- Trigger: one literal phrase, `file an idea`, in `PROCEDURE MANAGE-ISSUES`. `new idea` and `I want to work on this idea` are close variants.
- Classification: `IssueType: Idea`. Keep `Label` for `Insufficient Information` and `Unworkable` only.
- Placement: one bullet in `### Ticket Content` in the issue policy. No new section, no new procedure.
- Drop path: move the ticket to `closed/` with a dated `Won't fix` note. No new label.
- The checkpoint discussed-idea line stays.

Scope:

- Add `Idea` to the `IssueType` list in `ai/policies/ai-policy-issue-management.md` and `ai/shared/project-knowledge/issue-template.md`.
- Add `file an idea` to the `PROCEDURE MANAGE-ISSUES` triggers.
- Add one `### Ticket Content` bullet: an idea is a ticket with `IssueType: Idea`; grill it, then continue or close with a dated `Won't fix` note.
- Add the flow to `docs/workflow-guide.md` and `docs/simple-ai-workflow-slides.md`.
- Update the trigger count from 53 to 54 in the README, the deck, the toolchain note, and the tests.
- Extend `tests/test-issue-policy.sh` for the type and the trigger.
- Do not refactor the rest of the issue system.

Acceptance criteria:

- `file an idea` dispatches MANAGE-ISSUES; no bare `idea` trigger is added, and the close variants are documented.
- `IssueType: Idea` is in the policy and the template; `Label` keeps its two workability values.
- The bullet states the grill, the normal continuation, and the dated `Won't fix` close; the checkpoint line stays.
- The guide and deck describe the flow.
- The trigger count is 54 in the current count statements; historical records are unchanged.
- The validator, authoring checks, suite, markdownlint, and link checks pass.

---
2026-11-24
Plan attached below.

## Implementation Plan

# Plan: Idea intake and close-sequence clarity

## Evidence

- Investigation on 2026-11-24 read `ai/policies/ai-policy-issue-management.md`, `ai/procedures/manage-issues.md`, `ai/procedures/implement-plan.md`, `ai/procedures/write-checkpoint.md`, `ai/policies/ai-policy-thinking-modes.md`, `ai/policies/ai-policy-common.md`, `ai/shared/project-knowledge/issue-template.md`, the relevant ADRs, the README, the guide, the deck notes, and the issue-policy test.
- The idea flow already exists: `file an issue`, the type list, the brainstorming or grilling gap-fill, and the checkpoint discussed-idea line (`ai/policies/ai-policy-issue-management.md:44-65`; `ai/procedures/write-checkpoint.md:22`).
- The 2026-11-19 ADR rejected an idea policy section as duplicate and too heavy (`design-docs/protocol-decisions.md:1154-1160`). This plan uses one type, one trigger, one bullet, and one deck line, not a section.
- `Label` is reserved for workability (`ai/shared/project-knowledge/issue-template.md:44-45`), so `Idea` belongs in `IssueType`.
- The current trigger count is 53, stated in `README.md:172`, `docs/simple-ai-workflow-slides.md:432`, `tests/test-readme-shape.sh:82`, `tests/test-global-settings-repair-fixture.sh:75` via `ai/shared/project-knowledge/protocol-verification-toolchain.md:67`, and `tests/test-team-knowledge.sh:123`. `tests/test-slides.sh:200-208` derives the count from the sources.
- The word `idea` appears across the protocol, docs, and README in unrelated senses such as "one idea at a time" and "architectural ideas"; a bare trigger would collide.
- The close-sequence conflict: `implement-plan.md:8-13` and the ADRs (`design-docs/protocol-decisions.md:773-787`) say the implementation request delivers the plan's close sequence; the guide, README, deck, and common policy say the merge needs a third approval (`docs/workflow-guide.md:399,618`; `README.md:82`; `docs/simple-ai-workflow-slides.md:407,626`; `ai/policies/ai-policy-common.md:71`).
- Observed twice on 2026-11-24: the docs batch and the Kanban stopped after the branch and asked for `merge it` after the implementation request.
- The issue management policy and procedures were last changed on 2026-11-18 (`fbaed83`) and were not changed on 2026-11-24. The separate-approval wording entered on 2026-11-18 (`eb91256`) and the guide sentence on 2026-11-19 (`2f3a081`).
- The trigger-count scan returned 53; the file history returned `fbaed83 2026-11-18`; `git log -S "Get separate approval for a trunk merge"` returned `eb91256 2026-11-18`.
- The user approved all 11 grilling recommendations on 2026-11-24; the decisions are recorded in the two tickets.

## Context

The docs are descriptive; the protocol modules govern. The AI treated a repeated user-facing sentence as a rule, which caused the extra approval. This plan aligns the docs to the protocol and adds an explicit note that the guide and README describe the modules and do not override them.

The user approved the minimal idea intake and the two-step close sequence. The plan combines both because they share the guide, deck, README, and tests, and the combined change is small. No new procedure and no new policy section. `ai/procedures/implement-plan.md` and `ai/procedures/write-checkpoint.md` are unchanged.

## HLD

Part A, idea intake:

- Add `Idea` to the `IssueType` list in the issue policy and the issue template.
- Add one literal trigger, `file an idea`, to `PROCEDURE MANAGE-ISSUES`. Name `new idea` and `I want to work on this idea` as close variants in the procedure H1, not as separate `## Triggers` entries.
- Add one bullet to `### Ticket Content`: an idea is a ticket with `IssueType: Idea`; grill it, then continue the normal steps or close it with a dated `Won't fix` note.
- Keep `Label` for `Insufficient Information` and `Unworkable` only.
- Keep the checkpoint discussed-idea line as the backstop.
- Add one guide paragraph after `:395` in Section 16 and one sub-bullet under the **Issue** record on the deck's "Ticket, issue, or support request" slide. Do not change the three-record lead-in.

Part B, close-sequence clarity:

- Use this canonical sentence in the guide, README, and deck: "The implementation request is the approval for the branch, the commits, the push, and the close sequence named in the plan's `## Close Sequence`, including the trunk merge, tag, release, and external writes. The branch approval alone covers only commits and pushes on the branch. Ask for a separate approval only when the plan does not name the action or the request is not an implementation request."
- Use this common-policy clause: "Get separate approval for a trunk merge, a tag, a release, and an external system write; the implementation request that triggers PROCEDURE IMPLEMENT-PLAN is that separate approval when the plan's `## Close Sequence` names the action, otherwise ask."
- Keep the protected-branch gate for a plan that does not name the action, for a request that is not an implementation request, and for an external ticket that needs its tracker update.
- Add the descriptive note: "This guide describes the protocol. The protocol modules (`AGENTS.md`, the policies, and the procedures) are authoritative." The README version says "This page describes the protocol." The deck speaker note says "The guide and README describe the protocol; the protocol modules are authoritative."
- Add two ADR entries: the two-step close sequence, and the docs-as-descriptive principle.

Release: v7.3.0 minor, with the announcement, README banner, and release-practices entry. The new type and trigger make this a minor; the wording fix alone would be a patch.

## LLD

- `ai/policies/ai-policy-issue-management.md`: add `Idea` to the type list at `:44`; add the idea bullet to `### Ticket Content` after `:59-65`.
- `ai/shared/project-knowledge/issue-template.md`: add `Idea` to the type list at `:36-37`; keep the `Label` rule at `:44-45`.
- `ai/procedures/manage-issues.md`: add `file an idea` to the H1 trigger sentence at `:1` and one `- file an idea` bullet to `## Triggers` at `:3-10`; the H1 names `new idea` and `I want to work on this idea` as close variants.
- `docs/workflow-guide.md`: add the idea paragraph after `:395` in Section 16; replace the close-sequence sentence within `:399` and `:618` with the canonical sentence, keeping the merge-policy and cycle text; add the descriptive note after the cycle at `:618`.
- `docs/simple-ai-workflow-slides.md`: add the idea as a sub-bullet under the **Issue** record on the "Ticket, issue, or support request" slide, leaving the three-record lead-in; replace the close-sequence sentences within the notes at `:407` and `:626`, keeping the rest; replace the Merge policy bullet at `:620` with the two-step model; add the descriptive note to the `:626` note; change `:432` to 54.
- `README.md`: replace the close-sequence sentence within `:82` with the canonical sentence, keeping the cycle; change `:172` to 54; add the descriptive note after `:82`; update the banner at `:1-3` to v7.3.0.
- `ai/policies/ai-policy-common.md`: replace `:71` with the common-policy clause.
- `design-docs/protocol-decisions.md`: add two ADR entries, one for the two-step close sequence and one for the docs-as-descriptive principle.
- `tests/test-issue-policy.sh`: pin the policy and template `Idea` type, the MANAGE-ISSUES `file an idea` trigger, the H1 close variants, the idea bullet, the unchanged `Label` values, and the common-policy clause.
- `tests/test-docs-audit.sh`: pin the guide idea paragraph after `:395`, the canonical sentence, and the guide descriptive note.
- `tests/test-slides.sh`: pin the deck idea sub-bullet under the **Issue** record, the canonical notes, the descriptive note, and the 54 count; the test derives the count from the sources.
- `tests/test-readme-shape.sh`: pin the README canonical sentence, the descriptive note, and 54.
- `tests/test-global-settings-repair-fixture.sh`: pin the toolchain note at 54.
- `tests/test-team-knowledge.sh`: change the golden `triggers=54`.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: change `:67` to 54.
- `docs/announcements/v7.3.0.md`: the release note.
- `ai/shared/project-knowledge/release-practices.md`: the v7.3.0 entry.
- `ai/issues/open/idea-intake-flow.md` and `ai/issues/open/implementation-request-close-sequence-wording.md`: dated plan entries now; close both with the plan attached at implementation.

## Acceptance criteria

- AC-1: `Idea` is in both type lists; `Label` keeps only its two workability values.
- AC-2: `file an idea` is the only new literal trigger and dispatches MANAGE-ISSUES; the H1 names the two close variants; no bare `idea` trigger is added.
- AC-3: The idea bullet states the grill, the normal continuation, and the dated `Won't fix` close; the checkpoint line stays.
- AC-4: The guide, README, and deck note say the protocol modules are authoritative and the docs describe them.
- AC-5: The guide, README, deck notes, and common policy carry the canonical two-step wording; the protected-branch gate remains for a plan that does not name the action, a non-implementation request, and an external ticket that needs its tracker update.
- AC-6: Two ADR entries record the decisions.
- AC-7: The trigger count is 54 in the current README, deck, toolchain note, and tests; the checkpoint updates the current state files; historical announcements, ADRs, release-practices entries, and review reports stay unchanged.
- AC-8: The idea and wording tickets are closed with the plan attached; v7.3.0 is prepared with the announcement, banner, and release-practices entry.
- AC-9: The validator, authoring checks, suite, markdownlint, shellcheck, and link checks pass.

## Close Sequence

- Repo: this repository.
- Base ref: `master`.
- Branch: `feature/idea-intake-and-close-sequence-clarity`.
- Merge mode: `direct`.
- Tickets: `ai/issues/open/idea-intake-flow.md` and `ai/issues/open/implementation-request-close-sequence-wording.md`; close both with this plan attached.
- Checkpoint: write it on the branch before the commit and update the current state files.
- Release: v7.3.0 minor; tag `v7.3.0` and publish the GitHub Release after the merge.
- Evidence: validator 8/8, authoring PASSED, suite green, markdownlint 0, shellcheck 0, link checks pass.

## Peer Review Log

- Round 1 (review-100): CHANGES REQUESTED. 1 Critical, 4 Major, and 8 Minor; fixed.
- Round 2 (review-101): CHANGES REQUESTED. No Critical or Major; 5 Minor fixes requested.
- Round 3 (review-102): APPROVED. No Critical, Major, or Minor; two optional suggestions remain.

---
2026-11-24
Implementation review-103 CHANGES REQUESTED; review-104 APPROVED after the checkpoint, the test strengthening, and the release-note correction.
