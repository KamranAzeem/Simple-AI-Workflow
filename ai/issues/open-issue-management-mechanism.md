Reported: 2026-09-09
Reporter: Kamran Azeem / Kilo
IssueType: Feature
Severity: P2
Size: L
URL:
Summary: Add a lightweight issue-management mechanism to the protocol

Description:

The protocol has no defined way to create, track, or close issues. `ai/issues/`
exists and was formalized in TIER 1 (CP-2026-09-09-02), but that only covers the
directory, directory scanning, and Proof-of-Load indexing. There is no issue
template, no naming convention, no lifecycle, and no procedure for an AI to
create or close an issue. We have started using the directory informally
(see the two `closed-` files and the open directory-creation issue), which shows
the directory already has a purpose but no defined shape.

This feature adds a lightweight but robust issue-management mechanism that keeps
the protocol light while making `ai/issues/` reliable and machine-parseable.

Agreed requirements (see the design note
`ai/notes/issue-management-mechanism-design.md` for the full spec):

- Filename is the single source of truth for status (no Status field inside the
  file). Prefixes: `open-...`, `in-progress-...`, `closed-...`. Priority/size
  stay in the header fields only, not the filename (they're mutable).
- Lifecycle that becomes the standing flow: open issue -> implementation ->
  closed issue + update related project-knowledge.
- A simple issue file template with fields: Reported, Reporter, IssueType,
  Severity (P1-P4), Size (S/M/L/XL), URL, Summary, Description, and repeatable
  dated `---` update sections. Dates are YYYY-MM-DD. Summary sits directly above
  Description.
- The template format lives in `ai-policy-common.md` (where the mechanism is
  defined) and is written to each project's
  `ai/shared/project-knowledge/issue-template.md` during load-context/bootstrap;
  it is never placed in `ai/issues/`.
- A Procedure trigger in AGENTS.md TIER 3 for issue management, plus rules in
  `ai-policy-common.md`.
- AI-initiated creation files an issue immediately, marking Severity/Size as
  `Human-to-decide (AI estimate: ...)`; creation never waits on a human.
- A URL field that stays empty until the issue is migrated to GitHub/GitLab/Jira.
- Backfill existing issue files (the two `closed-` files and the open
  directory-creation issue) to the new layout.

Scope note: transferring issues to an external VCS (GitHub/GitLab/Jira) is a
follow-on capability that uses the URL field; it is not part of this issue.

---
2026-09-09
Opened as the first issue filed with the new template. Design decisions locked
and captured in `ai/notes/issue-management-mechanism-design.md`.

---
2026-09-10
Revised filename convention before implementation: priority/size dropped from
the filename (they're mutable, already live in the `Severity`/`Size` header
fields, and encoding them in the name forced a rename on every reprioritize).
Filename is now `<status>-<slug>.md`. File renamed to
`open-issue-management-mechanism.md`. Design note updated to match.
