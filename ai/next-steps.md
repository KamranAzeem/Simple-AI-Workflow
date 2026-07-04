CP-2026-07-04-04

## Pending
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`
- [ ] Human (when ready): push master to origin — this session did NOT push per instruction.
- [ ] Deferred (breaking — design as one coherent change later): Procedure E precedence rework so resume may read the latest checkpoint's single-writer-authoritative state instead of trusting only the lossy summary.
- [ ] Deferred (separate project): AI-team dispatcher/watcher runtime (role lifecycle, watch-spawned execution) and per-agent status files for true parallelism. Not part of the protocol contract.
- [ ] REVISIT WHEN PARALLEL (Scenario B from CP-2026-06-30-02): Before running multiple AI agents/sessions that may write the three state files *concurrently*, adopt the per-agent-status-file model (one file per agent under `ai/shared/coordination/`, orchestrator reconciles). The current cooperative board is not race-safe for simultaneous writes; today's single-orchestrator model only holds when writes are serialized in time. Sequential role-switching in one session (Scenario A) is already safe and needs nothing.
- [ ] Future (not now): discuss whether to add TLD.md / LLD.md to bound protocol scope and size
- [ ] Decide fate of untracked `ai/plans/agents-md-context-reload-improvements.md` (source plan with inflated project-knowledge-count framing) — delete or annotate post-merge
- [ ] (Optional, carried) Review `ai/sessions/` directory — exists but not referenced in any policy or doc; document its purpose or remove it