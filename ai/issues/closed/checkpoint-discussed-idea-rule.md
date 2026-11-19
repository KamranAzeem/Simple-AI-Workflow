Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: S
Label:
URL:
Summary: Add one next-steps line for each discussed problem or solution at the checkpoint, and clarify the design-docs trigger scope

Description:

**Goal**: A potential problem or solution raised in the discussion is not lost when its scope is not agreed.

**Scope**:

- Add one sentence to the next-steps item in `ai/procedures/write-checkpoint.md`.
- The checkpoint is the writer; no mid-session next-steps write.
- Correct the design-docs trigger scope: the trigger is the user's entry point for design-document edits; the developer-mode ADR entry is part of the change and does not need it.
- Add two design-docs policy bullets and two test checks.
- Add the ADR note on the 2026-10-15 entry and the checkpoint entry.

**Rule**: "Add one next-steps line for each potential problem or solution raised in the discussion, even when its scope is not agreed."

**Acceptance criteria**:

- The sentence is in the next-steps item.
- The checkpoint remains the only state writer.
- The design-docs policy and test pass.
- The ADR note and the checkpoint entry are present.
- The protocol validator, the authoring validator, the suite, and markdownlint pass.

---
2026-11-19
Plan attached below.

## Implementation Plan

# Plan: Checkpoint Discussed-Idea Rule

## Evidence

- The user chose the checkpoint-only path on 2026-11-19: "Add the line at the next checkpoint. Safe." No mid-session next-steps writes.
- The next-steps backlog carried "Add the one-line discussed-idea rule to the checkpoint procedure."
- `ai/procedures/write-checkpoint.md` (66 lines): STEP-ATOMIC-WRITE item 2 writes next-steps, appends atomic actions at the tail, and holds the 5 KB target.
- `design-docs/protocol-decisions.md` (1,142 lines) read in full. Relevant decisions: 2026-09-19 (next-steps is forward-only, delete on done, daily archive), 2026-09-22 (a protocol change is not committed without a dated ADR entry), 2026-10-15 (design docs are written only through the `update design documents` trigger), 2026-10-28 (plans carry evidence, automatic peer review, and a close sequence), 2026-10-29 (the checkpoint is the single upkeep umbrella), 2026-11-03 (merge modes).
- The user corrected the 2026-10-15 reading on 2026-11-19: the trigger is the user's entry point for design-document edits, not a gate on the ADR entry for a protocol change in Protocol Developer Mode. The ADR note and the policy bullets carry the correction.
- Peer review review-25 rejected the earlier policy-heavy proposal; the user chose the one-line checkpoint rule.
- The current protocol validator, authoring validator, and 22-script suite pass; the implementation reruns them.
- No new test for the checkpoint behavior: the suite cannot test it; the open behavior-verification ticket covers that class.

## Change

- File: `ai/procedures/write-checkpoint.md`, STEP-ATOMIC-WRITE item 2.
- Add after "Append new atomic actions at the tail, keeping the order oldest at top and newest at the bottom.":
  - Add one next-steps line for each potential problem or solution raised in the discussion, even when its scope is not agreed.
- File: `ai/policies/ai-policy-design-docs.md`, `## Confirmation and Challenge`:
  - In Protocol Developer Mode, write the ADR entry for a protocol change as part of that change, confirmed by the plan and implement approval.
  - In Protocol Developer Mode, the `update design documents` trigger is not required for that ADR entry.
- File: `tests/test-design-docs-policy.sh`: two checks for the new bullets.
- File: `design-docs/protocol-decisions.md`: the note on the 2026-10-15 entry and the new checkpoint entry.
- File: `docs/announcements/v6.7.1.md` and `README.md`: the release note and banner.
- One sentence in the procedure; two policy bullets; one note and one entry; one release note.

## Acceptance criteria

- The sentence is present in the next-steps item.
- It adds one line per potential problem or solution, with no scope requirement.
- The checkpoint remains the only state writer; no mid-session next-steps write is introduced.
- The design-docs policy bullets and the two test checks pass.
- The ADR note and the checkpoint entry are present.
- The protocol validator, the authoring validator, the 22-script suite, and markdownlint pass.

## Risks and mitigations

- Next-steps noise: one line per item, the 5 KB target, delete on done.
- Stale lines: the checkpoint sees them; the user drops an item and the daily records it.
- A session that ends before the checkpoint can lose an idea: the user chose the checkpoint-only path; the summary is not durable.
- The AI can still miss a discussion: the line is a reminder; the user can ask for it.
- The design-docs trigger could be misread again: the ADR note and the policy bullets state the developer-mode exception.

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-19_01-00_review-26.md`; APPROVED; no Critical or Major; one Minor (name the ADR stop condition) adopted.
- 2026-11-19: the user corrected the trigger scope; the plan carries the policy bullets, the test, the ADR note, and the checkpoint entry.
- Round 2: `ai/code-review-reports/2026-11-19_01-12_review-27.md`; APPROVED; no Critical or Major.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`
- Base: `master`
- Branch: `feature/checkpoint-discussed-idea-rule`, opened at implementation
- Ticket: `ai/issues/open/checkpoint-discussed-idea-rule.md`; move to `in-progress/` at implementation; close on the branch with the plan attached
- Merge: direct (no `## Merge Policy`; default direct); one squash commit
- Files: `ai/procedures/write-checkpoint.md`; `ai/policies/ai-policy-design-docs.md`; `tests/test-design-docs-policy.sh`; `design-docs/protocol-decisions.md`; `docs/announcements/v6.7.1.md`; `README.md`
- ADR: the note on the 2026-10-15 entry and the checkpoint entry are written as part of the change; the plan and implement approval confirms them; no trigger
- Validation: `support-files/validate-protocol.sh`; `support-files/validate-policy-authoring.sh ai/procedures/write-checkpoint.md ai/policies/ai-policy-design-docs.md`; `tests/run-all.sh`; markdownlint-cli2 on the changed files
- Review: implementation peer review; fix Critical and Major; re-review
- Checkpoint: on the branch; remove the next-steps item
- Release: v6.7.1 patch; release note draft-first for approval; tag and GitHub release
- Done: ticket closed with the plan attached; branch merged and deleted; master pushed; release published
