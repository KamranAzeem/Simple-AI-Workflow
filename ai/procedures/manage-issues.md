# PROCEDURE MANAGE-ISSUES: When the user says "manage issues", "file an issue", "close issue", "list issues", "plan the issue", or "plan issue #N"

## Triggers

- manage issues
- file an issue
- close issue
- list issues
- plan the issue
- plan issue #N

1. **STEP-TICKET**: Create, list, close, or reopen a ticket. Create under `ai/issues/open/` by default, or in an external tracker when the user supplies an issue or asks for one. A list request reads `ai/issues/open/` and `ai/issues/in-progress/` and reports filenames. Set the fields from the template. A ticket-only request ends here. To reopen, move a local ticket to `open/` on a new branch, or reopen the external issue in its tracker.
2. **STEP-PLAN**: On a plan request only, analyze the ticket for gaps and fill them with the user. Write the plan under `ai/plans/` with an `## Evidence` section, the depth from the common policy, and a `## Close Sequence` block. Append or post the dated plan entry. Do not open a branch.
3. **STEP-REVIEW-PLAN**: Run peer review on the plan automatically. Fix every Critical and Major finding and re-review until `APPROVED`. Record every round in the plan's Peer Review Log.
4. **STEP-STOP**: Return control. The ticket stays in `open/` until the user asks to implement. No step starts another phase.
