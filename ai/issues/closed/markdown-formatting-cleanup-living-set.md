Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: One-time markdown cleanup of the shipped/living set and ignore local-only dirs
Label:

Description:

Full-repo markdown lint reports 1505 issues in 190 files, almost all strict blank-line rules (MD022 778, MD032 626, MD030 33, others). About 1486 are auto-fixable.

Two decisions:

- Stop linting git-ignored local directories, because they are local-only artifacts, not shipped markdown.
- Do a one-time fix of the shipped/living set, leaving historical and ignored directories alone.

Scope:

- Add ignores to `.markdownlint-cli2.jsonc`: `ai/secrets/**`, `ai/code-review-reports/**`, `ai/artifacts/**`, `ai/daily-checkpoints/**`.
- Auto-fix (`markdownlint-cli2 --fix`) the shipped/living set: `ai/policies/**`, `docs/**`, root `*.md`, `ai/shared/project-knowledge/**`.
- Manually fix the non-auto issues that remain in that set (MD040 needs a language tag, MD001, MD034).

Out of scope: `ai/issues/**`, `ai/state/**`, and the ignored directories.

Acceptance criteria:

- `.markdownlint-cli2.jsonc` ignores the four local directories.
- The shipped/living set passes lint with 0 issues.
- Validator green; reference test PASS; no content changes beyond formatting.
