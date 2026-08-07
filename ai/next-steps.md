CP-2026-08-05-01

## Pending
- [ ] Process notes.md: document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (see notes.md for full spec)
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`
- [ ] Human (when ready): push master to origin — HEAD is e82729c

## Deferred
- [ ] (Breaking — design as one coherent change later): Procedure E precedence rework so resume may read the latest checkpoint's single-writer-authoritative state instead of trusting only the lossy summary.
- [ ] (Separate project): AI-team dispatcher/watcher runtime (role lifecycle, watch-spawned execution) and per-agent status files for true parallelism. Not part of the protocol contract.
- [ ] REVISIT WHEN PARALLEL (Scenario B from CP-2026-06-30-02): Before running multiple AI agents/sessions that may write the three state files *concurrently*, adopt the per-agent-status-file model (one file per agent under `ai/shared/coordination/`, orchestrator reconciles). The current cooperative board is not race-safe for simultaneous writes; today's single-orchestrator model only holds when writes are serialized in time. Sequential role-switching in one session (Scenario A) is already safe and needs nothing.
- [ ] Future (not now): discuss whether to add TLD.md / LLD.md to bound protocol scope and size
- [ ] (Optional, carried) Review `ai/sessions/` directory — exists but not referenced in any policy or doc; document its purpose or remove it