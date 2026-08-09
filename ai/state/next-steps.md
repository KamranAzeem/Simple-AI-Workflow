<!--
STATE-FILE: APPEND-ONLY. Append new content at the tail of this file. Do not insert, prepend, or edit content above existing entries. The most recent entry is always the last one.
STATE-FILE: KEEP LEAN. This file manages AI assistant state (what was done, what is pending, current context). No detailed implementation steps, commands, runbooks, investigation notes, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
CP-2026-08-09-01

## Pending
- [ ] Process notes.md: document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (see notes.md for full spec)
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`

## Deferred
- [ ] (Breaking — design as one coherent change later): Procedure E precedence rework so resume may read the latest checkpoint's single-writer-authoritative state instead of trusting only the lossy summary.
- [ ] (Separate project): AI-team dispatcher/watcher runtime (role lifecycle, watch-spawned execution) and per-agent status files for true parallelism. Not part of the protocol contract.
- [ ] REVISIT WHEN PARALLEL (Scenario B from CP-2026-06-30-02): Before running multiple AI agents/sessions that may write the three state files *concurrently*, adopt the per-agent-status-file model (one file per agent under `ai/shared/coordination/`, orchestrator reconciles). The current cooperative board is not race-safe for simultaneous writes; today's single-orchestrator model only holds when writes are serialized in time. Sequential role-switching in one session (Scenario A) is already safe and needs nothing.
- [ ] (Optional, carried) Review `ai/sessions/` directory — exists but not referenced in any policy or doc; document its purpose or remove it

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/
