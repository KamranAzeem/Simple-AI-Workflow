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
- `Summary`: one readable line, placed directly above the `Description:` section.
- No `Status` field. The ticket's directory is its status.

## Lifecycle

1. File the ticket in `ai/issues/open/`.
2. When work starts, move it to `ai/issues/in-progress/`.
3. When the fix is merged, move it to `ai/issues/closed/`, append a dated update
   section, and update any related project knowledge.
4. To reopen, move it back to `ai/issues/open/`.

Move the file between directories. Never rename it, and never add a status
prefix or suffix.
