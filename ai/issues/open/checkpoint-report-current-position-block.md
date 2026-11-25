Reported: 2026-11-25
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Show the current queue and last active item in the checkpoint report

Description:

The checkpoint report's transaction log uses `[NEXT-STEPS] Nothing to add` when `ai/state/next-steps.md` did not change. That line is a delta, so it hides the current pending queue and the last active item. The user observed this on 2026-11-25: the report said `Nothing to add` while `next-steps.md` held nine items and the active item was "Plan the scope normalization; settle the release and alias window; presets next; init after."

Proposed change: add a `Current position` block to `STEP-CHECKPOINT-REPORT` in `ai/procedures/write-checkpoint.md`, before the state-file transaction log.

- `Next up`: list the active item first, then the remaining open items from `ai/state/next-steps.md`. List all when there are ten or fewer; otherwise list the active item plus a count and the `next-steps.md` pointer.
- `Last active`: name the newest progress entry, or the work item just completed.
- Keep the transaction log as the delta; the block does not replace it.

The state files remain canonical. The report is a chat summary, not a new state file.

Evidence:

- `STEP-CHECKPOINT-REPORT` in `ai/procedures/write-checkpoint.md` (line 67) currently requires only the grouped step summary and the transaction log.
- `STEP-TRANSACTION-LOG` (lines 24-27) is the delta format.
- `next-steps.md` is "open items only, oldest first"; `progress.md` is "newest at bottom."
- The 2026-11-25 checkpoint is the observed example.

Acceptance criteria:

- `STEP-CHECKPOINT-REPORT` requires the `Current position` block before the transaction log.
- The block lists `Next up` with the active item first and all open items when ten or fewer; otherwise the active item plus a count and the `next-steps.md` pointer. `Last active` names the newest progress entry.
- The transaction log remains the delta.
- The change has an ADR in `design-docs/protocol-decisions.md`; the procedure-text assertion, validator, suite, and markdownlint pass; no new test file.
- No state-file change.

Open questions: None. The block name is `Current position`; the ten-or-fewer rule is settled. The release level is a planning decision.

2026-11-25

Plan: `ai/plans/checkpoint-report-current-position-block.md` (S, light path). Approved at review-148.
