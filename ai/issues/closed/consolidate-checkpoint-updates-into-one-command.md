Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Make the single "checkpoint" command perform every upkeep step, so no update is forgotten

Description:

The upkeep work is split across several commands, and the user (and users in general) are prone to forget some of them. Today these are separate:

- "checkpoint" updates the three state files and the daily diary.
- "update project knowledge" refreshes `ai/shared/project-knowledge/`.
- "update global knowledge" refreshes `~/.ai/global-knowledge/`.
- "update design docs" advances the `design-docs/` chain (HLD, LLD (with AC), ADRs, Delivery Ledger).

Goal: a single "checkpoint" command performs all of this in one pass, so nothing is forgotten. The individual triggers may remain as aliases for their single step, but "checkpoint" must cover the whole set.

Open questions to fill during brainstorming (not yet answered):

- Exact scope: what should a consolidated checkpoint cover, and what should it deliberately leave out?
- Global knowledge is user-space and cross-project. Does a project checkpoint belong there, and under what condition?
- Design docs do not exist in every project. How should the checkpoint behave when they are absent or unaffected?
- Ordering, atomicity, and what to do when one step fails.
- How to keep the checkpoint fast and bounded so it does not balloon.
- Reporting: what the user sees at the end.
- Should the checkpoint also commit and push, or stay a working-tree-only operation?
- Configuration: a per-project switch to enable or skip each sub-step.

Pre-work analysis will fill these before any plan is written.

---
2026-10-13
Design docs are OUT of scope. Design documents are sensitive and must stay pure: they hold the design of the application or the component, never operational bookkeeping such as commit hashes or session trivia, and must not be touched without the user's explicit permission. The checkpoint must never read or write design documents, in any location (`ai/shared/project-knowledge/`, `design-docs/` at the project root, or a component or repo subdirectory).

Design docs, if handled at all, get a separate procedure that covers design docs only and confirms every proposed change with the user before writing anything.

Revised checkpoint scope: state files, diary, project knowledge, global knowledge, issue housekeeping, a stale-knowledge scan, and one grouped report. Never git. Never design docs.

---
2026-10-13
Grilling complete. Converged design (full session saved in `ai/notes/notes.md`):

- `PROCEDURE WRITE-CHECKPOINT` becomes the single umbrella. Steps, in order: state files (one atomic write) -> diary -> state-file trimming -> project knowledge -> global knowledge -> issue housekeeping + stale-knowledge scan (report-only) -> grouped report. Context re-affirmation stays condition-gated.
- The state-file write and the diary are the most important steps; they run first and always, and no later failure may prevent them.
- Global knowledge qualifies only for genuinely cross-project, reusable lessons; otherwise confirm "nothing to add".
- The stale-knowledge scan reuses the existing 90-day check, report-only, no auto-edit.
- Issue housekeeping is report-only: flag an `in-progress/` ticket with no live branch, or an executed plan left in `ai/plans/`.
- The grouped report is printed in chat: one line per step (`updated` / `nothing to add` / `failed`), plus the state-file transaction log.
- Fixed behavior, no per-project toggles. Never git. Never design docs.
- Keep `"update project knowledge"` and `"update global knowledge"` as thin single-step triggers.
- Docs: explain in the README and the slides that `"checkpoint"` performs the knowledge updates behind the scenes, saving at least two extra user instructions.
- If one step fails, run the rest and report the failure loudly. Deltas since the last checkpoint only; never start new work; never rewrite large files.

Design docs are out of scope here; see the separate ticket `separate-update-design-docs-procedure.md`.

Plan: `ai/plans/consolidate-checkpoint-updates-into-one-command-implementation-plan.md`

---
2026-10-13
Closed on branch `feature/consolidate-checkpoint-command`. `PROCEDURE WRITE-CHECKPOINT` is now the single umbrella: added global-knowledge, housekeeping + stale-scan (report-only), and grouped-report steps; added the two single-step aliases; recorded the boundaries (never git, never design docs) and the failure rule; synced the policy, workflow guide, README, slides, and the toolchain count (62 steps). Design docs moved to the separate ticket `separate-update-design-docs-procedure.md`. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-37 APPROVED.
