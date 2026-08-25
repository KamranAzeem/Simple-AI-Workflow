<!--
STATE-FILE: next-steps.md is the FUTURE. A forward-only backlog, not a history.
STATE-FILE: CHRONOLOGICAL ORDER. Oldest at the top, newest at the bottom. Append new items at the tail. Delete each item the moment it is done; never leave a ticked, checked, or struck-through entry. No history accumulates here.
STATE-FILE: KEEP LEAN. Short bullet items, one to two lines each. Not a runbook, plan, or ledger. No sub-bullets, command transcripts, or rationale. Use ai/shared/project-knowledge/ for durable detail.
-->
CP-2026-08-25-03

## Pending
- [ ] Document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (spec in notes.md).
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`.
- [ ] Draft design docs in `ai/notes/` (vision, PRD, HLD), then ADRs and a delivery ledger.
- [ ] Add Habit Hooks opt-in snippet to AGENTS.md TIER 2. (research file, idea 3)
- [ ] Add TDD sub-rules to ai-policy-common.md Rule 1: simplest green, no dead code, test behavior. (research file, idea 4)
- [ ] Add a docs guide for the ATDD opt-in pattern. (research file, idea 7)

## Deferred
- [ ] (Breaking) Procedure E precedence rework: let resume read the latest checkpoint's authoritative state, not only the summary.
- [ ] (Separate project) AI-team dispatcher/watcher runtime and per-agent status files for true parallelism.
- [ ] (Revisit when parallel) Adopt per-agent status files before concurrent state-file writes (Scenario B, CP-2026-06-30-02); the board is not race-safe.

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/
