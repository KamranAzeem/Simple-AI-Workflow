Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Remove em dashes from the shipped/living files
Label:

Description:

The Humanized Output style rules ban em dashes (`—`) and ask for commas, colons, or parentheses instead. The shipped/living set carries roughly 334 em dashes across 32 files.

Scope: `ai/policies/**`, `docs/**`, root markdown (`AGENTS.md`, `README.md`, `ai-customization.md`, `LICENSE.md`), `ai/shared/project-knowledge/**`.

Out of scope: the lint-exempt local directories, and `ai/issues/**` and `ai/state/**`.

Acceptance criteria:

- No em dash (`U+2014`) remains in the shipped/living set.
- Replacements read naturally (comma, colon, or parentheses as fits), not a blind swap that creates comma splices.
- Markdown lint stays at 0 for the set; validator green; reference test PASS.
