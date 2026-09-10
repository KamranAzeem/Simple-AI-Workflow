Reported: 2026-09-10
Reporter: Kamran Azeem
IssueType: Feature
Severity: P2
Size: L
URL:
Summary: Load-context should detect and self-heal out-of-order or bloated state/checkpoint files instead of only reporting them

Description:

The protocol already defines ordering and brevity rules for the three
**Project AI State Files** (`ai/state/progress.md` append-only chronological,
`ai/state/next-steps.md` forward-only plus delete-on-done, `ai/state/context.md`
Current Status in place plus appended chronological history — CP-2026-08-24-01
per-file model) and a Horizon Shield to archive `progress.md`/`context.md` when
they grow past their size thresholds (Procedure C). All of this is currently
enforced only at write time, by whichever AI session happens to run a checkpoint
carefully. Nothing in Procedure A (load context) ever checks whether the files
on disk already violate these rules.

In practice this means: on a machine or repo where the state files (or the daily
checkpoint files under `ai/daily-checkpoints/`) drifted out of order or grew
bloated in a past session (weak model, interrupted session, manual edit,
merge from another branch/agent), the files stay broken until a human happens
to notice and asks an AI to fix them. A fresh "load context" session reads the
broken files, may even flag the problem in the Proof-of-Load report, but does
not fix it as part of booting; it just carries on with the task, so the drift
persists across every session until someone raises it explicitly. This is the
same "protocol defines a rule but nothing enforces it automatically" shape as
the checkpoint-procedure-never-writes-daily-checkpoint-file issue
(`ai/issues/closed-checkpoint-procedure-never-writes-daily-checkpoint-file.md`),
applied to file ordering and size instead of file existence.

Two concrete, related gaps:

1. **Order/bloat detection is not part of load context.** Procedure A Step 4
   (State File Proof-of-Read) already reads all three state files and the
   latest daily-checkpoint file and records line counts and CP identifiers —
   it has the data in hand to detect an ordering violation (e.g. a CP ID that
   is chronologically earlier than one already appended above it) or a bloat
   condition (line count past the Horizon Shield threshold, or a daily-checkpoint
   file whose size is clearly abnormal versus its peers) but does not currently
   check for either.
2. **Daily-checkpoint files have no header marker at all.** Each of the three
   state files already carries a one-time `STATE-FILE:` HTML-comment header at
   the top (chronological order + brevity rules — see any file under
   `ai/state/`), so an AI opening the file cold can see the rule inline. Files
   under `ai/daily-checkpoints/` (e.g. `ai/daily-checkpoints/2026-09-09.md`)
   have no equivalent header; they start directly with `# Daily Checkpoint
   YYYY-MM-DD`. There is nothing written into the file itself telling a future
   AI assistant (on this or another machine) to keep entries in date order,
   one file per calendar day, or to stay lean.

Proposed fix (for design/discussion, not locked):

- Extend the load-context procedure (Procedure A) with a check, after the
  existing State File Proof-of-Read step, that verifies: (a) chronological
  order within each state file (CP identifiers strictly increasing, no entry
  out of sequence) and across the daily-checkpoint files (filenames in date
  order, no CP ID in a later-dated file with a value that predates an entry
  in an earlier file); (b) size against the existing Horizon Shield thresholds
  for `progress.md`/`context.md`, plus an equivalent size signal for
  `next-steps.md` (should never legitimately grow large, since items are
  deleted on completion) and for individual daily-checkpoint files.
- When a violation is found, the AI reorders and/or archives as part of the
  load-context flow itself (same archiving mechanics the Horizon Shield already
  uses for `progress.md`/`context.md`), rather than only telling the user
  about it. Reordering/archiving must not drop any entry's content: physically
  move mis-ordered or over-threshold content, do not summarize it away — same
  "without losing value" bar already applied to `protocol-decisions.md`
  consolidation (see `protocol-decisions.md`, 2026-09-10 entry).
- Add a one-time `STATE-FILE:`-style HTML-comment header to the top of each
  daily-checkpoint file (new files going forward; consider a one-time backfill
  of existing files), stating: one file per calendar day, chronological
  `## CP-<ID>` sections appended at the tail, and to keep entries in the
  established Problem/Fix/Files-changed/Validation/Status narrative style
  (matching the existing state-file header pattern and wording).
- Report any self-heal performed in the Proof-of-Load report (bullet under
  the existing State File Proof-of-Read item), so the fix is visible to the
  user rather than silent.

Scope note: this issue is about detecting and fixing drift that has already
happened by the time load context runs. It does not change how checkpoints
are written going forward (Procedure C's existing Atomic Write Protocol,
per-file ordering model, and Horizon Shield already cover that side).

---
2026-09-10
Opened per user request during a Simple-AI-Workflow protocol-developer session,
prompted by real-world experience: users/machines with older state files that
have drifted out of order or grown bloated, where no AI session has yet been
asked to clean them up, currently have no self-healing path at load time.

---
2026-09-10
User asked whether there was enough detail to implement directly. Reviewed the
issue and found it describes the problem and general direction well, but is
not yet implementable as written. Decided a design pass is needed before any
protocol-file edit; recording the open questions here so they aren't lost.

**Open design questions (must be resolved before implementation):**

1. **Conflicts with an existing Non-Negotiable.** AGENTS.md TIER 2 states:
   "Context Protection: Treat Project AI State Files as read-only during
   bootstrap and context loading." This issue asks the AI to write
   (reorder/archive) those same files during load-context. Needs an explicit
   resolution — e.g. a named exception (parallel to how Protocol Developer
   Mode is an explicit exception to Self-Modification), or running the
   self-heal as a distinct step after Procedure A completes rather than
   during it.
2. **Prompt-only vs. scripted enforcement is undecided.** The proposed fix is
   written as prose instructions for the AI to follow, consistent with how
   the rest of the protocol works (no executable enforcement today). But
   "detect chronological order" and "reorder without losing content" are
   mechanical, error-prone text operations on files that already mix CP
   entries with non-CP lines (e.g. `progress.md`'s `[MIGRATION-...]` marker
   lines) — a naive prompt-driven "sort by CP ID" pass could mishandle those.
   Decide whether this should be backed by a script (like
   `validate-protocol.sh`, extended to report/fix) or stay fully
   prompt-driven.
3. **No concrete thresholds or algorithm proposed.** "CP identifiers strictly
   increasing" and "abnormal size versus peers" are the only detection rules
   offered — no numbers. The existing Horizon Shield thresholds (>50 items
   for `progress.md`, >10 entries for `context.md`) were explicit locked
   decisions; this issue needs equivalent explicit numbers for
   `next-steps.md` and for individual daily-checkpoint files, not just "an
   equivalent size signal."
4. **Scope vs. Procedure E is unstated.** Procedure E (Post-Compaction
   Recovery) deliberately never reads the three state files. Should
   confirm the new self-heal only ever runs in Procedure A (full
   load-context), never in Procedure E.
5. **Backfill of existing daily-checkpoint files is explicitly left open**
   in the proposed fix ("consider a one-time backfill"). The repo has an
   established norm of never rewriting historical file content (see the
   2026-09-10 filename-simplification decision, which left historical
   `progress.md`/daily-checkpoint entries untouched). A header-only addition
   is arguably a different case, but this should be decided explicitly, not
   left as "consider."
6. **Validator impact not scoped.** Every prior protocol behavior change in
   this repo added a matching `validate-protocol.sh` anchor check (e.g. the
   daily-checkpoint-write fix, the issues-directory formalization). This
   issue doesn't mention one; implementation will likely need one (e.g.
   daily-checkpoint header presence).

**Decision**: not proceeding to implementation until these are resolved,
likely via a short design note (same pattern as
`ai/notes/issue-management-mechanism-design.md`).
