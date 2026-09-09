# Issue Management Mechanism — Locked Design Decisions

Status: Locked 2026-09-09 (agreed between Kamran and the AI before implementation).
This note records the agreed design. The implementation issue is
`ai/issues/open-P2-L-issue-management-mechanism.md`.

## Purpose

A lightweight, robust issue tracker inside `ai/issues/`, driven by plain
markdown files, usable by the AI and later parsed into a kanban board and
exported to GitHub/GitLab/Jira. The protocol must stay light: one template,
one naming convention, one status mechanism.

## Filename = single source of truth for status

No `Status` field lives inside the file. Status is derived entirely from the
filename prefix, so the scanner and Proof-of-Load never open a file to learn its
state (avoids the Token Rationing cost and the text-drift risk that motivated the
CP-2026-09-09-02 rejection of a content Status field).

Filename pattern: `<status>-<priority>-<size>-<slug>.md`

| Status | Prefix | Example |
|---|---|---|
| Open (not started) | `open-` | `open-P2-L-issue-management-mechanism.md` |
| In progress | `in-progress-` | `in-progress-P2-L-issue-management-mechanism.md` |
| Closed | `closed-` | `closed-P2-L-issue-management-mechanism.md` |

- Open uses `open-P#-` for uniformity with the other two prefixes.
- Priority is always `P1`/`P2`/`P3`/`P4`; size is `S`/`M`/`L`/`XL`.
- Slug: compressed summary, kebab-case, self-explanatory, capped around 40-50
  chars, allowed char set only.
- Scanner / Proof-of-Load lists **open + in-progress** by filtering out
  `closed-*.md` files. A future kanban maps prefix to column.

## Lifecycle (now the standing flow)

`open issue -> implementation -> closed issue + update related project-knowledge`

- Create: file with the template, using the naming convention.
- In progress: rename prefix `open-` -> `in-progress-`.
- Closed: rename prefix to `closed-`, append a dated update section, and update
  any related project-knowledge files.
- All renames are in place (`git mv` in this repo); reopening strips the prefix.

## Issue file template

Header block is plain `Key: Value` lines, then a blank line, then the
Description section, then zero or more `---`-separated dated update sections.
Dates are `YYYY-MM-DD` everywhere (no other format).

```
Reported: 2026-09-09
Reporter: Kamran Azeem / Kilo
IssueType: Feature
Severity: P2
Size: L
URL:
Summary: <one line, readable>

Description:

<multiline detail, steps to replicate, what was tried>

---
2026-09-09
<update, progress, resolution>
```

### Field rules

- `Reported`: always filled, `YYYY-MM-DD`.
- `Reporter`: username / AI assistant name.
- `IssueType` enum: `Feature`, `Defect/Bugfix`, `Improvement/Refactor`,
  `Documentation`, `Task`.
- `Severity`: P1 (Must Have), P2 (Should Have), P3 (Could Have), P4 (Won't Have
  / not an issue, no effort).
- `Size`: S (2h), M (4h), L (8h), XL (too large, needs breakdown/grooming).
- `URL`: mostly empty; filled when migrated to GitHub/GitLab/Jira.
- `Summary`: one readable line, placed directly above the Description section.
- `Status`: not a field — it is the filename prefix (see above).
- On AI-initiated creation: `Severity`/`Size` are set to
  `Human-to-decide (AI estimate: M)` and the human updates them later. The file
  is always created immediately; creation never waits on a human.

## Template location and propagation

The **template format lives in `ai-policy-common.md`** (the common policy that
defines the issue mechanism). On load-context / bootstrap, the AI writes that
template into each project's `ai/shared/project-knowledge/issue-template.md`,
then uses it for every new issue. There is no tracked repo template file; the
format ships inside the always-loaded common policy and is instantiated per
project. Keeping it out of `ai/issues/` prevents the AI from confusing it with a
real issue and keeps the `ai/issues/` directory logic simple.

## AI-initiated creation

When the AI identifies something that should be tracked, it drafts and creates
the issue file immediately (never waits on a human). It fills `Reported`/
`Reporter`/`IssueType`/`Summary` and best-guess `Severity`/`Size`, marking the
latter two as `Human-to-decide (AI estimate: ...)`.

## Transfer to external VCS

The `URL` field stays empty until a migration. Later the user may ask the AI to
transfer issues from `ai/issues/` to GitHub/GitLab/Jira via CLI or web, filling
the `URL` field on each migrated issue. This is a follow-on feature, not in the
initial scope.

## Backfill

When the mechanism is implemented, the existing issue files are converted to the
new layout (add header block, rename to the status-prefixed convention). This
covers the two `closed-` files already present and the open
`ai/issues/boot-up-should-create-required-ai-directories.md`.

## Implementation plan (for the implementing session)

Work on a feature branch (`feature/issue-management`). This plan is the source
of truth so a later/fresh session does not need the original discussion.

1. `ai/policies/ai-policy-common.md` — add the issue mechanism: the field list,
   naming/status-prefix convention, lifecycle (open -> implement -> closed +
   update related project knowledge), AI-initiated creation rules, the template
   format block, and the ensure-template-in-project-knowledge step.
2. `AGENTS.md` — add a Procedure trigger in TIER 3 (Issue Management); document
   the status-prefix convention; add the ensure-required-`ai/`-dirs-and-template
   step to load-context/bootstrap (this also resolves the related
   `boot-up-should-create-required-ai-directories.md` issue).
3. `support-files/validate-protocol.sh` — add an anchor/check for the trigger and
   template presence.
4. `ai/shared/project-knowledge/protocol-decisions.md` — record the unified
   design and the supersession of the CP-2026-09-09-02 "no status field" stance.
5. Backfill: convert the two `closed-` files and the open
   `boot-up-should-create-required-ai-directories.md` to the new layout.
6. Run Procedure D (peer review) proactively, per the standing rule in
   `ai-customization.md`.
7. On approval, commit; then close the implementation issue and update related
   project knowledge.

Alignment rules to observe (from `protocol-decisions.md`): policy files must not
use procedure letters or step numbers; no markdown hyperlinks in policy files;
author from the end-user project-root perspective; Protocol Developer Mode rules
apply in this repo.
