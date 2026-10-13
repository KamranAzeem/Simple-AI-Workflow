Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Consolidate every markdown-formatting rule scattered across the protocol into one Markdown Output policy in the common policy file
Label:

Description:

Goal: move all markdown formatting rules into one coherent `## Markdown Output` section in `ai/policies/ai-policy-common.md`, remove duplication, and resolve the conflicts listed at the end. Keep the result direct and what-focused.

Where the rules live today (inventory):

1. Generated File Validation (ai/policy-common.md, generated-file section): before presenting a generated file, run the type's linter and fix all issues. Markdown uses `markdownlint --fix`. Exempt: `ai/` tracking files, auto-generated configs, lock files, vendor files.

2. Markdownlint rule set (`.markdownlint-cli2.jsonc`): disables ul-style, ul-indent, line-length, blanks-around-headings, single-title, ol-prefix, list-marker-space, blanks-around-lists, no-emphasis-as-heading, table-column-style, first-line-heading; sets no-duplicate-heading to siblings-only.

3. Communication Standards (ai/policy-common.md): readability rules (clear headings, bullet points, copy-friendly code blocks), collaborative tone, token efficiency.

4. Humanized Output (ai/policy-common.md): sentence structure, words to use and avoid, tone, patterns to kill (no em dashes, no negative parallelisms, no rule of three, no promotional language, no hedging stacks, no vague attributions, no faux analysis, no list-bombing, no exhaustive caveats), writing style by medium (reports/documents, emails, research, git commits never self-identify as AI, chat). This is prose style, not markdown mechanics; keep it separate and cross-reference it.

5. Policy-file link rules (ADR entries in protocol-decisions.md): policy files and AGENTS.md MUST NOT contain markdown hyperlinks `[text](path)`; use a Bold Anchor or backticks. Links inside `ai/policies/` use `../`-relative paths; `docs/` links to `docs/` must not be prefixed with `docs/`.

6. Protocol customization rule (ai-customization.md, Development Workflow): rules must be direct what-only statements with no why prose; do not use markdown tables anywhere; user-facing documentation may keep some prose.

7. Global user settings (`~/.ai/settings/global-user-settings.md`): communication uses markdown with plain paragraphs, headings, bullets, and code blocks only, no tables; no decorative symbols (ticks, arrows, emoji), use `[PASSED]`, `[FAILED]`, `[PENDING]`.

8. Ticket format (ai/shared/project-knowledge/issue-template.md + Issue Management Protocol): a header block of `Key: Value` lines, then `Description:`, then zero or more `---`-separated dated update sections; dates are `YYYY-MM-DD`; no `Status` field; minimum prose (short customer-facing status update, no long paragraphs, no command transcripts).

9. Ticket File Scope (ai/policy-common.md): ticket files hold decisions, outcomes, blockers, and customer-visible references only. They exclude CLI output, runbooks, AI handover notes, and session diary content.

10. State-file formatting (ai/policy-common.md, State File Ownership Protocol): a one-line rule comment; chronological order; at most three short bullets per item; no prose, no command transcripts, no rationale, no step detail; a dashboard plus an Active Working Context section.

11. Code-review report format (ai/policy-code-review.md, Report Format): Title, Date, Scope, Reviewer, then Critical / Major / Minor / Suggestions / Not Checked, then a Verdict; a severity classification (Critical blocks commit, Major fix before commit, Minor fix when convenient).

12. Plan and ADR conventions: an implementation plan has Metadata, Goal, Non-goals, Change set, Acceptance criteria, Verification steps, Process. An ADR entry is self-contained (Problem, Decision, Rationale, Status) with no commit hashes, branch names, removed-plan references, or non-committed reports.

13. IDs and file naming (Design Documentation Standards): every requirement, component, and design item gets an ID (`REQ-NNN`, `HLD-NNN`, `LLD-NNN`, `ADR-NNN`); documents follow the Verbose File Naming rule.

Conflicts and duplication to resolve:

- Tables: the customization rule bans markdown tables in protocol files, but `ai/policy-common.md` (ID Convention) and `ai/policy-code-review.md` (severity classification) contain tables. Decide: ban tables and convert those, or allow them under a stated exception, and make the policy text comply.
- Lint exemption: `ai/` files are exempt from Generated File Validation, so tickets, plans, checkpoints, and review reports have unconstrained markdown. Decide whether these are linted or explicitly exempt.
- Em dashes: Humanized Output bans em dashes, but generated docs still contain them (the comparison doc has 38). Decide how the ban is enforced for generated files, not only for chat.
- Link rules: no hyperlinks in policy files, yet docs and the README use relative links. State the exact scope (which file classes use which link style).

Acceptance criteria:

- AC1: one `## Markdown Output` section in `ai/policies/ai-policy-common.md` holds every markdown-mechanics rule (headings, lists, tables, code fences, links, filenames).
- AC2: no markdown-formatting rule is duplicated elsewhere; other sections cross-reference the one section. Prose style stays in Humanized Output and is cross-referenced.
- AC3: the table conflict is resolved (banned and converted, or permitted with a stated exception) and all policy text complies.
- AC4: the link rules (no hyperlinks in policy files; `../`-relative in `ai/policies/`; no `docs/` prefix within `docs/`) live in the one section.
- AC5: the markdownlint config and Generated File Validation are cross-referenced, and the `ai/`-file lint exemption is stated explicitly.
- AC6: validator 8/8, reference test PASS, markdownlint 0.

---
2026-10-12
Plan: `ai/plans/consolidate-markdown-formatting-policy-implementation-plan.md`. Pre-work decisions: mechanics only, prose stays in Humanized Output; universal rules to the common policy while personal preferences stay in `ai-customization.md` and global settings; ban markdown tables in protocol files and convert the two existing tables; keep `ai/` tracking files lint-exempt.

---
2026-10-12 (refinement)

- Tables: ban markdown tables in every document, protocol or user-facing. The only exception is when the user explicitly asks for a table, for example in a user-facing report or a presentation slide.
- Linter-agnostic conventions: the policy must state the markdown conventions from `.markdownlint-cli2.jsonc` in plain, linter-agnostic terms, so any user can reproduce them in the markdown linter of their choice.

---
2026-10-12 (formatting rules and enforcement)

- Enable blanks-around-headings and blanks-around-lists: a blank line before and after every heading, and above and below every list.
- Proper list indentation (2 spaces per level, never tabs) and one space after each list marker.
- A consistent unordered marker and a consistent ordered-list prefix.
- Keep no maximum line length, so prose is not hard-wrapped.
- Enforcement is going forward only. New and edited markdown must pass; existing files are grandfathered and fixed only when touched or when the user asks. No repo-wide sweep, and no file is exempt.
- Optional extras under consideration: code-fence-style `backtick`, hr-style `---`, and `proper-names`.

---
2026-10-12

Closed on branch `feature/consolidate-markdown-policy`. Delivered: the `## Markdown Output` section in `ai-policy-common.md`, the table ban with the explicit-user-request exception, the linter-agnostic conventions, the table-to-list conversions in `ai-policy-common.md` and `ai-policy-code-review.md`, the stricter `.markdownlint-cli2.jsonc` (now including code-fence-style, hr-style, and proper-names), and the `ai-customization.md` update. Enforcement is going forward only. Verified: validator v6.0 8/8, reference test PASS, markdownlint 0 on the edited files. Peer review review-11 APPROVED. ADR recorded in `protocol-decisions.md`.
