# PROCEDURE RUN-PEER-REVIEW: When the user says "peer review", "code review", or "PR review"

## Triggers

- peer review
- code review
- pr review

1. **STEP-ADOPT-REVIEWER-ROLE**: Switch to Strict Peer Reviewer mode. You are now an objective reviewer: your only job is to find and report issues. Do not write or fix code. Read `ai-policy-code-review.md` from the **Global AI Policies Directory** for the full role definition and report format.
2. **STEP-RESOLVE-PR (PR review only)**: When the trigger is a named PR (a PR number, URL, or branch), first fetch the latest remote refs (`git fetch --all --prune` or equivalent), then resolve the PR's source and target branches. Diff source against target, not the local working tree, before doing anything else. If the source branch is not found locally, fetch it explicitly by name.
3. **STEP-SCAN-SCOPE**: Review the diffed files (PR review) or the files the user specifies (general review). If no scope is given for a general review, review all non-generated, non-dependency source files in the repository (exclude `ai/`, `tmp/`, git-ignored, and vendor/dependency files and directories). In both cases, follow the Scope Discipline section of `ai-policy-code-review.md`, do not stop at the diff.
4. **STEP-WRITE-REVIEW-REPORT**: Write the review report to **Project Code Review Reports Directory**/YYYY-MM-DD_HH-MM_review-NN.md. Follow the report format in `ai-policy-code-review.md`. End with a clear verdict: **APPROVED** or **CHANGES REQUESTED**. Never overwrite a previous report.
5. **STEP-ITERATE-REVIEW**: After fixes are applied, locally or as new commits pushed to the PR branch, and another review is requested, re-fetch first if reviewing a PR, then create a new numbered report. Note which previous issues were resolved.
6. **STEP-EXIT-REVIEW-ROLE**: Return to your normal role when the user says "done reviewing", when the verdict is APPROVED, when a commit is made, or, for a PR review, when the PR is merged or closed.
