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

Agreed requirements (the mechanism now lives in `ai/policies/ai-policy-common.md`,
and the final decisions and reversals are recorded in
`ai/shared/project-knowledge/protocol-decisions.md`):

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

---

2026-09-17

There is a new observation in issue management, especially related to the filenames.

In the early design, I thought that having a status prefix in the filename would be easier for both the user and the AI. However, as more and more issues are being created, the status prefix is becoming an eyesore, a cognitive overload. The user going through the tickets have to visually filter out "open-" and "closed-" , and only then the user is able to make sense of the slug. This is tiring.

I propose that the issues directory has a "closed" subdirectory inside it, where the closed tickets live without a need for a "closed-" prefix. The open tickets can simply live in the main ai/issues/ directory without the "open-" prefix. The proof of load can simply scan the ai/issues/ directory and list all tickets and index them for JIT.

When an issue is "not open" , it can then be moved into the closed subdirectory'. This means there is no juglary with the filename at any stage of the ticket.

For kanban board (future), the fields are still there in the tickets, that can be referenced. The kanban mechanism can scan the ai/issues/closed directory too, and show them under the "done/closed" column. This is for later.

---
2026-09-17
Decisions locked and implemented on `feature/issue-management`. Tickets now live in `ai/issues/{open,in-progress,closed}/`. A ticket's location is its status, the filename is its slug only, and there is no status prefix or suffix. Filenames never change; moving between states is a directory move. Proof-of-Load indexes `open/` and `in-progress/` by filename and line count, and omits the closed count. The three directories and the issue template are created at bootstrap and ensured during load-context. A new issue-management procedure ships in `AGENTS.md`, the mechanism is defined in `ai-policy-common.md`, and the full template lives in `ai/shared/project-knowledge/issue-template.md`. Moves to `closed/` when the branch merges.

---
2026-09-17
Closed: squash-merged to `master` as `be4e4b1` and pushed to `origin/master`. The ticket moved `open/` to `in-progress/` to `closed/`, following its own new lifecycle. Related project knowledge updated: `ai/policies/ai-policy-common.md`, `ai/shared/project-knowledge/issue-template.md`, `ai/shared/project-knowledge/protocol-decisions.md`.

---
2026-09-19
Future scope carried over from the retired issue-management design note, so no
design detail is lost:
- External tracker transfer: the `URL` field stays empty until the user asks to
  migrate tickets to GitHub, GitLab, or Jira; each migrated ticket then has its
  `URL` filled in.
- Kanban rendering: the three status directories map to To Do, Doing, and Done
  columns. The board reads `Severity` and `Size` from the ticket header fields
  and scans `ai/issues/closed/` for the Done column.
