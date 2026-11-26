Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The checkpoint transaction log shows a stale [NEXT-STEPS] line that reads as the queue

Description:

The checkpoint report prints a plain `Next steps` queue and then a state-file transaction log. The log's `[NEXT-STEPS]` line records the next-steps file delta, for example `[NEXT-STEPS] Removed: "..."`, and the user reads it as the pending queue on every checkpoint. The marker collided with the queue label when the queue was renamed to a plain list; it now survives only as the delta.

The log's `[PROGRESS]` and `[CONTEXT]` lines are the progress and context deltas and stay. The fix removes the `[NEXT-STEPS]` line, keeps the log for those two files, and makes the plain `Next steps` section the only queue display. The procedure, the guide, the checkpoint test, and a new ADR change. The release is a PATCH.

---
2026-11-26
Plan attached below.
