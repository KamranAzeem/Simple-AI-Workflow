Reported: 2026-09-09
Reporter: Kamran Azeem / Kilo
IssueType: Feature
Severity: Human-to-decide
Size: Human-to-decide
URL:
Summary: Load-context should create the required ai/ directories when they are missing

Description:

## Problem

Procedure A Step 2 (Structural Audit, Existence-First) verifies the mandatory
`ai/` directories exist and then **only reports missing items — it does not
create them**. The line reads: "Verify **Project Coordination File** exists.
Only report missing items — do not create them."

Only Procedure B (Repo is Empty / bootstrap) ever creates missing directories.
So during a normal "load context" boot-up, if a required `ai/` directory is
absent, the AI merely reports it and continues. A directory added to the
protocol for existing projects will never be auto-created unless the project is
re-bootstrapped from empty.

The user wants a simple, non-over-engineered boot-up check that ensures the
required `ai/` directories exist by creating any that are missing.

## Prior decision this touches (reversal candidate)

This conflicts with the recorded decision in `protocol-decisions.md` (2026-07-04,
CP-2026-07-04-04): "Procedure A Step 2: changed from 'Only propose mkdir -p for
missing items' to 'Only report missing items — do not create them.' Fixes AI
getting stuck on silent mkdir -p output."

That change was made to stop the AI from blocking on an empty-set `mkdir -p`
whose output is silent. Any fix must preserve that intent: a single,
deterministic, idempotent create loop, never a multi-step silent scan.

## Proposed fix

In Procedure A, after the Structural Audit verifies the mandatory directories,
create any that are missing. Keep it trivial:

- Use `mkdir -p` (idempotent and safe to run when the directory already exists).
- Operate on a short, fixed list of required `ai/` directories.
- Do not branch, do not ask, do not prompt — just ensure they exist.

### Simple list of ai/ directories to check and create

- `ai/artifacts/`
- `ai/code-review-reports/`
- `ai/daily-checkpoints/`
- `ai/issues/`
- `ai/issues/open/`
- `ai/issues/in-progress/`
- `ai/issues/closed/`
- `ai/notes/`
- `ai/pending/`
- `ai/plans/`
- `ai/policies/`
- `ai/policies/compliance/`
- `ai/secrets/`
- `ai/shared/`
- `ai/shared/handoffs/`
- `ai/shared/project-knowledge/`
- `ai/state/`

Related file (non-directory, considered optional for this issue): ensure
`ai/shared/coordination.md` also exists, since Procedure A Step 2 already
verifies it.

## Acceptance criteria

- Running "load context" on a repo missing one or more required `ai/`
  directories results in those directories being created (verified by a
  subsequent `find` or `ls`).
- Existing directories are left untouched.
- No silent-block or prompt is introduced (respects the 2026-07-04 rationale).
- The change stays limited to the `ai/` directory list; no broader filesystem
  side effects.

---
2026-09-17
Implemented on `feature/issue-management`. Procedure A Step 2 now runs one
idempotent `mkdir -p` over the fixed list above, extended with `ai/issues/open/`,
`ai/issues/in-progress/`, and `ai/issues/closed/`, and creates the issue template
when it is missing. The read-only Safety Barrier was amended to permit exactly
those creates and nothing else. The 2026-07-04 intent is preserved: one
deterministic loop, no prompt, no stall on silent output. Moves to `closed/`
when the branch merges.
