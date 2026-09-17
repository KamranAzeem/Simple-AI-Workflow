# Issue Management Mechanism: Locked Design Decisions

Status: Locked 2026-09-09. Revised 2026-09-10 (filename simplified) and
2026-09-17 (status moved from a filename prefix to a directory).
This note records the agreed design. The implementation issue is
`ai/issues/in-progress/issue-management-mechanism.md`, and the implementation
plan is `ai/plans/issue-management-mechanism-implementation-plan.md`.

## Purpose

A lightweight, robust issue tracker inside `ai/issues/`, driven by plain
markdown files, usable by the AI and later parsed into a kanban board and
exported to GitHub/GitLab/Jira. The protocol must stay light: one template,
one naming convention, one status mechanism.

## Location is the single source of truth for status

No `Status` field lives inside the file. Status comes entirely from which
directory the ticket sits in, so the scanner never opens a file to learn its
state. This avoids the Token Rationing cost and the text-drift risk that
motivated the CP-2026-09-09-02 rejection of a content Status field.

```text
ai/issues/
  open/          tickets not started
  in-progress/   tickets being worked
  closed/        tickets done and merged
```

- Filename: `<slug>.md`, lowercase kebab-case, self-explanatory, capped around
  40-50 chars. No status prefix or suffix. The filename never changes.
- No file sits directly under `ai/issues/`.
- Moving between states is a directory move (`git mv` when the repo tracks
  `ai/`). Reopening moves a ticket from `closed/` back to `open/`.
- Proof-of-Load lists `open/` and `in-progress/` by filename and line count, and
  does not index `closed/`.
- Future kanban: the three directories map to three columns. Priority and size
  come from the header fields, read only when the board is built.

## Lifecycle (the standing flow)

`open issue -> implementation -> closed issue + update related project-knowledge`

- Create: file with the template under `open/`.
- Start: move to `in-progress/`.
- Close: move to `closed/`, append a dated update section, and update related
  project knowledge. A ticket reaches `closed/` only when its fix is merged.
- Reopen: move back to `open/`.

## Issue file template

The header block is plain `Key: Value` lines, then a blank line, then
`Description:`, then zero or more `---`-separated dated update sections. Dates
are `YYYY-MM-DD`. The full template lives at
`ai/shared/project-knowledge/issue-template.md`.

Fields: `Reported`, `Reporter`, `IssueType`, `Severity`, `Size`, `URL`, `Summary`,
`Description`.

### Field rules

- `Reported`: always filled, `YYYY-MM-DD`.
- `Reporter`: username / AI assistant name.
- `IssueType` enum: `Feature`, `Defect/Bugfix`, `Improvement/Refactor`,
  `Documentation`, `Task`.
- `Severity`: `P1` (must have), `P2` (should have), `P3` (could have),
  `P4` (will not do), or `Human-to-decide (AI estimate: Pn)`.
- `Size`: `S` (about 2h), `M` (about 4h), `L` (about 8h), `XL` (needs
  breakdown), or `Human-to-decide (AI estimate: <size>)`.
- `URL`: empty until migrated to GitHub/GitLab/Jira.
- `Summary`: one readable line, directly above `Description:`.
- No `Status` field.

## Template location and propagation

The compact field list lives in `ai-policy-common.md`, so the always-loaded
policy can drive creation. The full template lives in the project's
`ai/shared/project-knowledge/issue-template.md`. The bootstrap and load-context
procedures create the file when it is missing and never overwrite it. The field
names and enums are the contract; formatting may vary between projects.

## AI-initiated creation

When the AI identifies something that should be tracked, it drafts and creates
the ticket immediately (never waits on a human). It fills `Reported`/`Reporter`/
`IssueType`/`Summary` and best-guess `Severity`/`Size`, marking the latter two as
`Human-to-decide (AI estimate: ...)`.

## Transfer to external VCS

The `URL` field stays empty until a migration. Later the user may ask the AI to
transfer tickets to GitHub/GitLab/Jira, filling the `URL` field on each migrated
ticket. This is a follow-on feature, not in scope.

## Routing-principle deviation

The 2026-08-31 routing principle says a TIER 3 procedure should load its own
self-contained policy. This mechanism keeps its rules in the always-loaded
`ai-policy-common.md` instead, because the template ensure step must be known
during load-context, and only an always-loaded file carries that. Recorded as a
conscious deviation in `protocol-decisions.md`.

## Backfill and implementation plan

See `ai/plans/issue-management-mechanism-implementation-plan.md` for the backfill
mapping table and the step-by-step implementation plan.

## Alignment rules (from `protocol-decisions.md`)

Policy files must not use procedure letters or step numbers; no markdown
hyperlinks in policy files; author from the end-user project-root perspective;
Protocol Developer Mode rules apply in this repo.
