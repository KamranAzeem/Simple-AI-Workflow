# Checkpoint procedure never writes a daily-checkpoint file

## Problem

Procedure C ("When performing a Checkpoint") only mandates writing to the three
**Project AI State Files** (`progress.md`, `next-steps.md`, `context.md`). No step
in Procedure C creates or appends a dated file in **Project Daily Checkpoints
Directory** (`ai/daily-checkpoints/`).

The directory is treated as a read-time source everywhere it's referenced:
- Procedure A Step 4 ("Loading") reads "the latest checkpoint file"
- `ai-policy-common.md` "Source-of-Truth Order" lists it as position #2
- `ai-policy-common.md` "State File Proof-of-Read" requires the CP identifier to
  be "consistent across all three state files and the latest checkpoint file"

But nothing ever defines the write side. The only mention of creating a checkpoint
file at all is in Procedure B (bootstrap): "create... an initial daily checkpoint"
— a one-time action, never repeated by Procedure C.

## Impact

In practice, a checkpoint file only gets created when an AI session happens to
decide to write one on its own initiative. State files (`progress.md`/`context.md`)
race ahead with new `CP-YYYY-MM-DD-NN` identifiers every checkpoint, while
`ai/daily-checkpoints/` stalls on whatever date a file last happened to be written.
Every fresh "load context" session then reports a CP-identifier mismatch between
the state files and the latest checkpoint file — even though the user performed a
proper checkpoint each time.

Confirmed reproducing across multiple personal projects using this protocol, not
specific to one repo.

## Evidence

- `AGENTS.md` Procedure C, Step 1 "Sequential Execution Order" — lists only the 3
  state files, no daily-checkpoints write step.
- `ai-policy-common.md` "Checkpoint & Backup Procedures" section — only references
  the Project AI Knowledge Directory review mandate, nothing about the checkpoint
  file itself.
- `ai/shared/project-knowledge/protocol-decisions.md` — CP-2026-06-29-01 entry
  added fresh-read and consistency-check rules for the checkpoint file, but
  assumed the write side already existed; no entry anywhere defines when/how a
  checkpoint file is created.
- Real-world example: `ai/daily-checkpoints/2026-09-01-01.md` in the elmera project
  bundles two checkpoints (`CP-2026-09-01-01` and `CP-2026-09-01-02`) into one file,
  because no rule says "one file per checkpoint" or "always write one" — it only
  happened because the AI chose to that day.

## Proposed fix

Add an explicit step to Procedure C (after the Atomic Write Protocol, before or
alongside Log Condensation): write/append a file
`ai/daily-checkpoints/YYYY-MM-DD-NN.md` every time a checkpoint runs, summarizing
what changed this checkpoint (mirrors the informal pattern already seen in
`2026-09-01-01.md`).

Files likely touched:
- `AGENTS.md` — Procedure C (new step)
- `ai-policy-common.md` — "Checkpoint & Backup Procedures" section, cross-reference
  the new step
- `support-files/validate-protocol.sh` — consider an anchor check if one is added
  for other Procedure C steps

Requires Protocol Developer Mode (load `protocol-decisions.md` first) and human
approval before committing, per `AGENTS.md` TIER 2.

## Status

Resolved 2026-09-09. Added an explicit "Write Daily Checkpoint File" step to Procedure C
(new step 2, between the Atomic Write Protocol and Log Condensation; Log Condensation,
Update Project Knowledge, and Context Re-affirmation renumbered to 3/4/5). Uses this
repo's own established convention (`YYYY-MM-DD.md`, one file per day, one `## CP-<ID>`
section appended per checkpoint) rather than the `YYYY-MM-DD-NN.md` per-checkpoint naming
from the elmera example, since that convention was never actually adopted here. Also
updated: `ai-policy-common.md` (Daily Checkpoint File Mandate bullet), `validate-protocol.sh`
(v4.6→v4.7, new anchor check), `docs/workflow-guide.md` §14, `docs/simple-ai-workflow-slides.md`.
See `protocol-decisions.md` (2026-09-09 entry) for the full record. Committed and pushed as f716105.

Originally reported by Kamran during an elmera project session, 2026-09-08.
