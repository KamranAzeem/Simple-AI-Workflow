# Proof-of-Load report should index the ai/issues/ directory

## Problem

A new `ai/issues/` directory concept was introduced (2026-09-08) to track known
protocol gaps/bugs as individual files (see
`checkpoint-procedure-never-writes-daily-checkpoint-file.md` for the first
example), but this directory has no defined place in the protocol yet:

- It is not listed in `AGENTS.md` TIER 1 Configuration as a named directory.
- Procedure A ("load context") has no step that indexes or reports on it.
- The Proof-of-Load report (Procedure A Step 7) has no bullet mentioning open
  issues.

Right now an AI running "load context" has no way to learn that open protocol
issues exist unless a human tells it to look.

## Proposed fix

- Add **Project/Global Issues Directory** (naming TBD — likely global-only, since
  issues are about the protocol itself, not per-project) to `AGENTS.md` TIER 1.
- Add a step to Procedure A (Discovery or Knowledge Loading) that indexes files in
  `ai/issues/` (filenames only, like Project Knowledge indexing — these can grow
  and don't need full-text load at boot).
- Add a bullet to the Proof-of-Load report (Step 7) listing open issues found
  (count + filenames), so every fresh session surfaces known gaps without the
  human needing to remember to ask.
- Decide on a lifecycle: how an issue file is marked resolved/closed (delete?
  move to an `ai/issues/resolved/` subfolder? add a `## Status` field like
  `protocol-decisions.md` entries use?).

## Status

Open — deferred, future work. Not yet actioned. Reported by Kamran during an
elmera project session, 2026-09-08, alongside the first issue file.
