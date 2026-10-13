Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Fix the markdown lint error in two tickets created earlier this session
Label:

Description:

Two tickets created earlier this session put a list immediately after `Acceptance criteria:` with no blank line, which fails MD032 (blanks-around-lists). They were committed without a lint check.

- `ai/issues/closed/remove-em-dashes-from-shipped-files.md` (line 19).
- `ai/issues/closed/add-pull-rebase-to-gitconfig-templates.md` (line 19).

Acceptance criteria:

- Both tickets pass markdownlint.
- Full-repo lint returns to 0.
