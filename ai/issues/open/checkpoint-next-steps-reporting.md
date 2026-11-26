Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Make the checkpoint report show the next steps and ticket names without hiding them under Current position

Description:

## Problem

The v7.6.1 checkpoint report put the queue under `Current position`: `Next up` and `Remaining` were inside that block. The only text that looked like a `Next steps` section was the transaction log line `[NEXT-STEPS] Added: "Consume and retire the protocol-verification-toolchain knowledge file" and "Audit the project-knowledge files the protocol secretly relies on."` That line is a delta, not the queue.

The active item read `Plan the scope normalization` and did not name `ai/issues/open/global-to-workflow-policy-terminology.md`, so the rename ticket was not visible. The remaining queue was reduced to a count, hiding the other open items.

## Desired outcome

- Keep `Current position` for status, milestone, and last active.
- Add a distinct `Next steps` section. List the active item first, then the remaining open queue. Name the ticket file or slug for every ticket-backed item. List all open items when ten or fewer; otherwise list the active item plus a count and the `ai/state/next-steps.md` pointer.
- Keep the transaction log separate. The `[NEXT-STEPS]` entry is a delta and must not be the only next-steps display.
- The active item for the last checkpoint should have shown `ai/issues/open/global-to-workflow-policy-terminology.md`.
- Update `STEP-CHECKPOINT-REPORT`, the workflow guide, the ADR, and the fixture that pins the checkpoint report.
- Demonstrate the corrected report on the next checkpoint.

## Acceptance criteria

- A checkpoint report has distinct `Current position` and `Next steps` sections; `Current position` does not carry the queue. Assertion: the procedure and guide text, and a fixture.
- The active next step names its ticket path or slug when one exists; the rename ticket appears as `ai/issues/open/global-to-workflow-policy-terminology.md`. Assertion: the fixture and the next checkpoint report.
- The remaining queue is listed; all open items when ten or fewer; otherwise the active item plus a count and the next-steps pointer. Assertion: the fixture.
- The transaction log is visibly separate; the `[NEXT-STEPS]` entry is a delta only. Assertion: the fixture.
- The next checkpoint report shows the rename ticket and does not repeat the v7.6.1 layout. Assertion: the report.
- The suite passes and the change is released when the plan says so. Assertion: the gate and the release URL.

## Out of scope

- Changing the state-file budget, the issue count, or the actual queue.
- The rename ticket's decisions.
- The transaction log's history.
- The checkpoint's other sections.

## Notes

- The v7.6.1 ADR introduced the `Current position` block. The user is unhappy with how it displays next steps.
- The queue had 11 items; the active rename ticket was paraphrased as `Plan the scope normalization`, and the other 10 were reduced to a count.
- The fix is a report-format change, not a state-model change.
- No plan or branch exists yet.

## Plan

- 2026-11-26: Plan written at `ai/plans/checkpoint-next-steps-reporting.md`; review-158 CHANGES REQUESTED; revised for the user's `[NEXT-STEPS]` label and no release; review-159 APPROVED. Ready for implementation under the user's `continue working` instruction.
