Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Bring the issue tickets and state files to clean markdown lint
Label:

Description:

The first markdown cleanup covered the shipped/living set only. The remaining lint issues are in the workflow's own tracking files, and these stay part of linting:

- `ai/issues/**` (open, in-progress, closed)
- `ai/state/**` (progress, context, next-steps)

Em dashes are out of scope for this ticket and get a separate pass.

Acceptance criteria:

- `ai/issues/**` and `ai/state/**` pass lint with 0 issues.
- The shipped/living set stays at 0 issues.
- Validator green; reference test PASS; formatting-only changes.
