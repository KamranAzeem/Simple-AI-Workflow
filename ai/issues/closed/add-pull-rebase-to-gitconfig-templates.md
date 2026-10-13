Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Add pull.rebase = true to the gitconfig templates, and make defaultBranch handling explicit
Label:

Description:

Deferred backlog item, now being worked.

- Add `[pull] rebase = true` to both gitconfig templates: the `ini` block in `ai/policies/ai-policy-common.md`, and the `ini` plus `git config` blocks in `docs/global-user-settings.md`.
- `pull.rebase` is a recommendation only, not part of the config adequacy check.
- Make the `defaultBranch` rule explicit: for a new config, `main` is fine; never change a `defaultBranch` that is already set; do not enforce `main`.

Acceptance criteria:

- Both templates carry `pull.rebase = true`; the docs bash block carries `git config --global pull.rebase true`.
- `pull.rebase` is not added to the adequacy list or the detection command.
- The policy states plainly that an existing `defaultBranch` is never changed.
- markdownlint 0 for the set; validator green; reference test PASS.

---
2026-10-13
Closed on branch `chore/pull-rebase-gitconfig`. Added `[pull] rebase = true` to both templates (a recommendation, not an adequacy key), added the `git config --global pull.rebase true` command to the docs template, and made the `defaultBranch` rule explicit (main for a new config, never change an existing value). Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-34 APPROVED.
