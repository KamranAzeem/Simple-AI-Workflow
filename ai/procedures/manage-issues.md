# PROCEDURE MANAGE-ISSUES: When the user says "manage issues", "file an issue", "close issue", "list issues", "plan the issue", or "plan issue #N"

## Triggers

- manage issues
- file an issue
- close issue
- list issues
- plan the issue
- plan issue #N

1. **STEP-TICKET**: Resolve the request as create, list, close, or reopen, and resolve the destination and audience. Create under `ai/issues/open/` by default, or in an external tracker when the user supplies an issue or asks for one. For a create request, write the ticket draft. For a list request, read `ai/issues/open/` and `ai/issues/in-progress/`, report filenames, and end. For a close or reopen request, prepare any comment the procedure will post.
2. **STEP-SCRUB-OUTBOUND**: Apply `## Outbound Content Scrub` to the exact text that leaves. State the destination class. Remove secrets in every class. Remove names and internal detail for Class B. Show the scrubbed text and the category report, then wait for approval. Skip on a list or plan request; the plan step scrubs an external entry. For a local ticket, remove secrets only. For a Class A destination, keep names and infrastructure detail.
3. **STEP-POST-TICKET**: Create, close, or reopen the ticket with the approved text. A close moves a local ticket to `closed/` in the branch commit, or closes the external issue when the merge lands. A reopen moves a local ticket to `open/` on a new branch, or reopens the external issue in its tracker.
4. **STEP-PLAN**: On a plan request only, analyze the ticket for gaps and fill them with the user. Write the plan under `ai/plans/` with an `## Evidence` section, the depth from the common policy, and a `## Close Sequence` block. Append the dated plan entry to a local ticket, or post it to an external ticket after `STEP-SCRUB-OUTBOUND`. Do not open a branch.
5. **STEP-REVIEW-PLAN**: Run peer review on the plan automatically. Fix every Critical and Major finding and re-review until `APPROVED`. Record every round in the plan's Peer Review Log.
6. **STEP-STOP**: Return control. The ticket stays in `open/` until the user asks to implement. No step starts another phase.
