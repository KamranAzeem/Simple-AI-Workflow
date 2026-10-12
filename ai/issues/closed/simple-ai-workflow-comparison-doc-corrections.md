Reported: 2026-10-10
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Fix a factual error and style-rule violations in the AI-assistants comparison doc

Description:

Review of `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`. Formatting is clean (markdownlint-cli2 reports 0 issues; no trailing whitespace, tabs, or broken tables). Content problems found:

1. Factual error (line 34, repeated in the translation table at line 83): `SKILLS.md` is wrong. GitHub Copilot defines agent skills with a `SKILL.md` (singular) file inside a skill directory (`.github/skills/<name>/SKILL.md`), not one `SKILLS.md`. The same line also calls skills "agents"; skills are task-specific and loaded on demand, which is distinct from custom agents. Sources: VS Code "Use Agent Skills in VS Code" and GitHub docs "Adding agent skills for GitHub Copilot".

2. Contradiction with policy (line 91): the compliance row lists `ai/policies/compliance/` as the mechanism. `ai-policy-common.md` states compliance standards are not stored as on-disk files and must not be scanned. The directory exists but is empty. Only the "built-in AI knowledge" half of the cell is accurate.

3. Incomplete description (line 36): `/memories/` is described as "user-level and session-level". VS Code memory also has a repository scope (`/memories/repo/`).

4. Style-rule violation: the document contains 38 em dashes, including the H1 title. `ai-policy-common.md` (Humanized Output, "Patterns to Kill") bans em dashes and says to use commas, colons, or parentheses instead.

5. Cosmetic naming mismatch: the README links to the document as "Simple AI Workflow vs Copilot, Claude, ChatGPT: a full comparison", but the H1 title (line 1) reads differently.

Acceptance criteria:
- `SKILL.md` corrected in both line 34 and the table at line 83, and the "and agents" wording fixed.
- Compliance cell aligned with the no-on-disk-compliance-files rule.
- `/memories/` description includes repository scope.
- Em dashes removed from the document.
- README link text and document title reconciled.
- markdownlint passes; peer review APPROVED.

---
2026-10-12
Plan: `ai/plans/comparison-doc-corrections-plan.md`. The doc predates the current markdown rules, so the change also converts the two tables (translation and "In Short") to lists, strips the 38 em dashes, and fixes markdown formatting. The doc is user-facing: fixes are from the reader's perspective and keep every mapping.

---
2026-10-12
Closed on branch `feature/comparison-doc-corrections`. Fixed `SKILL.md` in both places, added the `/memories/` repository scope, corrected the compliance entry, removed all 38 em dashes, converted both tables to lists, and reconciled the README link text with the H1. Verified: markdownlint 0 on the doc and README, validator v6.0 8/8, reference test PASS. Peer review review-14 APPROVED.
