# Issue Ticket Template

This is the canonical ticket format for issues tracked under `ai/issues/`. The
mechanism itself is defined in `ai-policy-common.md`. Tickets live in one of
three status directories: `open/`, `in-progress/`, or `closed/`.

## Ticket format

The header block is plain `Key: Value` lines, followed by a blank line, then the
`Description:` section, then zero or more `---`-separated dated update sections.
Dates are always `YYYY-MM-DD`.

```text
Reported: 2026-09-09
Reporter: <name / AI assistant name>
IssueType: Feature
Severity: P2
Size: L
Label:
URL:
Summary: <one readable line>

Description:

<multiline detail: what happened, steps to reproduce, what was tried>

---
2026-09-09
<update, progress, or resolution note>
```

## Field rules

- `Reported`: always filled, `YYYY-MM-DD`.
- `Reporter`: the user or AI assistant name that filed it.
- `IssueType`: one of `Feature`, `Defect/Bugfix`, `Improvement/Refactor`,
  `Documentation`, `Task`.
- `Severity`: `P1` (must have), `P2` (should have), `P3` (could have),
  `P4` (will not do, or not an issue), or `Human-to-decide (AI estimate: Pn)`.
- `Size`: `S` (about 2h), `M` (about 4h), `L` (about 8h), `XL` (too large, needs
  breakdown), or `Human-to-decide (AI estimate: <size>)`.
- `URL`: left empty until the ticket is migrated to an external tracker such as
  GitHub, GitLab, or Jira.
- `Label`: empty for a workable ticket, or `Insufficient Information` /
  `Unworkable` when pre-work analysis finds it unworkable. Never use it as a status.
- `Summary`: one readable line, placed directly above the `Description:` section.
- No `Status` field. The ticket's directory is its status.

## Lifecycle

Follow `PROCEDURE MANAGE-ISSUES` to file, list, close, or reopen, and `PROCEDURE IMPLEMENT-PLAN` to deliver an approved plan. A local ticket's directory is its status; an external ticket's state is its status.

Move the file between directories. Never rename it, and never add a status
prefix or suffix.

Append or post the plan file name as a dated entry while active. At close, attach the plan under `## Implementation Plan`, replace the dated link with `Plan attached below.`, and delete the plan file from `ai/plans/`.
