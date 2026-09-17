# Issue Management Mechanism: Implementation Plan

Status: Locked 2026-09-17, plan-reviewed (review-01, findings resolved), pending implementation.
Feature branch: `feature/issue-management`.
Source issue: `ai/issues/open-issue-management-mechanism.md`.
Design note: `ai/notes/issue-management-mechanism-design.md`.

## 1. Goal

Add a lightweight, machine-parseable issue-management mechanism to the protocol,
built on a three-directory structure where a ticket's location is its status.

## 2. Locked decisions

1. Tickets live under `ai/issues/{open,in-progress,closed}/`.
2. The three directories are created at bootstrap and ensured during load-context
   on an already-bootstrapped project.
3. No files live directly under `ai/issues/`.
4. Moving a ticket between states is a `git mv` between the three directories.
   The filename never changes.
5. Reopening a closed ticket moves it back to `open/`.
6. Proof-of-Load indexes `open/` and `in-progress/` by filename and line count.
   The closed count is not required.
7. Status is never a field in the file, only its directory.
8. The issue template format lives in `ai/shared/project-knowledge/issue-template.md`.
   The common policy carries only a compact field list and the propagation rule,
   so the always-loaded policy does not grow.
9. A new `PROCEDURE H: Issue Management` ships in AGENTS.md TIER 3.
10. The pending Grilling and Agent Document Review notes drop their informal
    H/I letter reservations and take letters when they are implemented.

### 2.1 Resolution of the routing-principle tension

The 2026-08-31 routing principle says a TIER 3 procedure should load a
self-contained policy. This mechanism deliberately deviates and lives in the
always-loaded common policy. Reason: the template ensure step must be known
during load-context, and only an always-loaded file can carry that. The
deviation is recorded in `protocol-decisions.md`.

## 3. Ticket format

Header block is plain `Key: Value` lines, then a blank line, then `Description:`,
then zero or more `---`-separated dated update sections. Dates are `YYYY-MM-DD`.

Fields: `Reported`, `Reporter`, `IssueType`, `Severity`, `Size`, `URL`, `Summary`,
`Description`.

- `IssueType` enum: `Feature`, `Defect/Bugfix`, `Improvement/Refactor`,
  `Documentation`, `Task`.
- `Severity`: `P1` to `P4`, or `Human-to-decide (AI estimate: ...)`.
- `Size`: `S`, `M`, `L`, `XL`, or `Human-to-decide (AI estimate: ...)`.
- `URL`: empty until migrated to an external tracker.
- No `Status` field.

### 3.1 Template contract

The compact field list in the common policy and the full template file in
project knowledge are the two halves of one contract:

- Field names and enum values are the binding contract.
- Formatting (blank lines, spacing, example wording) may vary between projects.
- The template file is created only when missing, then treated as canonical
  for that project. It is never rewritten.

## 4. Deliverables

### 4.1 AGENTS.md

- TIER 1: keep the `Project Issues Directory` anchor; the structure is described
  in Procedure A and the policy, not redefined in TIER 1.
- Procedure A Safety Barrier: add an explicit exception permitting creation of
  missing mandatory directories and the missing issue template from the fixed
  list. The "no file content modification" rule still forbids changing any
  existing file.
- Procedure A Step 2: after the audit, run one idempotent `mkdir -p` over the
  fixed mandatory directory list, which gains `issues/open`,
  `issues/in-progress`, `issues/closed`; then create
  `ai/shared/project-knowledge/issue-template.md` if missing.
- Procedure A Step 5: index `open/` and `in-progress/` by filename and line count
  (`*.md` only).
- Procedure A Step 7(g): report open and in-progress issue filenames and line counts.
- Procedure B: reconcile with the new ensure step, and add the template file to
  the bootstrap artifacts.
- New `PROCEDURE H: Issue Management` in TIER 3. Trigger phrases: "manage issues",
  "file an issue", "new issue", "close issue", "reopen issue", "list issues".
  It also supports a read-only list action over the three directories.

### 4.2 ai/policies/ai-policy-common.md

New issue-management subsection: location-based status, the three directories,
the lifecycle, AI-initiated creation rules, the compact field list, and the
template propagation rule. No procedure letters, no step numbers, no markdown
links, per the standing policy-file rules.

### 4.3 ai/shared/project-knowledge/issue-template.md (new)

The full template: header example, all field rules, enum values, the
`---` update-section convention, and the lifecycle note. See §3.1 for the contract.

### 4.4 support-files/validate-protocol.sh (v4.8 to v4.9)

- Replace the `closed-` prefix anchor with the open/in-progress indexing anchor.
- Add `issues/open`, `issues/in-progress`, `issues/closed` to `PROJECT_SUBS`.
- Add a guard that no `*.md` sits directly under `ai/issues/`.
- Add a presence check for `ai/shared/project-knowledge/issue-template.md`.
  Ordering assumption: the load-context ensure step runs before validation.
- Add a `PROCEDURE H:` anchor check.

### 4.5 Structure and backfill

Create the three directories and `ai/issues/in-progress/.gitkeep`. The
`.gitkeep` is needed only in this repo, where `ai/` is tracked; in end-user
projects `ai/` is gitignored and the ensure step recreates the directories.

Closing rule: a ticket moves to `closed/` only after its fix is merged. This
branch is not merged yet, so the two tickets it resolves stay in `in-progress/`.

| Current path | New path | Reported | Reporter | IssueType | Severity | Size |
|---|---|---|---|---|---|---|
| `ai/issues/open-issue-management-mechanism.md` | `ai/issues/in-progress/issue-management-mechanism.md` | 2026-09-09 | Kamran Azeem / Kilo | Feature | P2 | L |
| `ai/issues/boot-up-should-create-required-ai-directories.md` | `ai/issues/in-progress/boot-up-should-create-required-ai-directories.md` | 2026-09-09 | Kamran Azeem / Kilo | Feature | Human-to-decide | Human-to-decide |
| `ai/issues/open-state-file-order-and-bloat-self-healing.md` | `ai/issues/open/state-file-order-and-bloat-self-healing.md` | 2026-09-10 | Kamran Azeem | Feature | P2 | L |
| `ai/issues/open-edit-verification-missing-self-consistency-check.md` | `ai/issues/open/edit-verification-missing-self-consistency-check.md` | 2026-09-10 | Kamran Azeem / GitHub Copilot | Improvement/Refactor | Human-to-decide (AI estimate: P2) | Human-to-decide (AI estimate: S) |
| `ai/issues/closed-checkpoint-procedure-never-writes-daily-checkpoint-file.md` | `ai/issues/closed/checkpoint-procedure-never-writes-daily-checkpoint-file.md` | 2026-09-08 | Kamran Azeem | Defect/Bugfix | Human-to-decide | Human-to-decide |
| `ai/issues/closed-proof-of-load-report-should-index-issues-directory.md` | `ai/issues/closed/proof-of-load-report-should-index-issues-directory.md` | 2026-09-08 | Kamran Azeem | Feature | Human-to-decide | Human-to-decide |

Conversion rules for backfill:

- Add the header block at the top of every file.
- Drop an existing leading `# H1` title; the `Summary` field carries it.
- Keep existing body sections as the `Description` content.
- Convert a terminal `## Status` section into a dated `---` update section:
  drop the `## Status` heading, keep its text as the update body.
- Preserve existing `---`-separated dated sections unchanged.

### 4.6 Records, references, checkpoint

- `ai/notes/issue-management-mechanism-design.md`: revise to the three-directory
  model, keep the template-file section, update the lifecycle, scanner rule,
  backfill table, and implementation plan.
- `ai/shared/project-knowledge/protocol-decisions.md`: dated entry recording the
  two reversals (2026-09-09 subdirectory rejection, 2026-07-04 report-only),
  the location-based design, the template split and its contract, the routing
  deviation, the H allocation, and v4.9.
- Rename `ai/notes/procedure-h-grilling-design-note.md` to
  `ai/notes/grilling-procedure-design-note.md` and
  `ai/notes/procedure-i-agent-document-review-design-note.md` to
  `ai/notes/agent-document-review-procedure-design-note.md`.
- Live reference sync only: `ai/state/context.md`, `ai/state/next-steps.md`,
  `ai/notes/notes.md`, the design note, and the self-reference in
  `ai/issues/open/state-file-order-and-bloat-self-healing.md`. Append-only
  history stays untouched.
- Run a checkpoint (CP-2026-09-17-01): append to `progress.md`, prune completed
  items from `next-steps.md`, edit `context.md` Current Status, and append the
  daily-checkpoint entry to `ai/daily-checkpoints/2026-09-17.md`. This keeps the
  State File Proof-of-Read contract consistent.

## 5. Validation gates

- `support-files/validate-protocol.sh` 8/8.
- `markdownlint-cli2` clean on changed markdown.
- Grep sweep for old filenames and the old `closed-` prefix across `ai/`,
  `README.md`, and `docs/`, confirming no live reference dangles.
- Confirm no `*.md` directly under `ai/issues/`.
- Peer review before any commit. No commit or merge without explicit approval.

## 6. Out of scope

- External tracker migration (the `URL` field is reserved for it).
- A kanban renderer.
- Scripted enforcement of the lifecycle beyond the validator checks.
- Moving the mechanism to a dedicated policy (revisit if the section grows).
