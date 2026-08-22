<!--
STATE-FILE: APPEND-ONLY. Append new content at the tail of this file. Do not insert, prepend, or edit content above existing entries. The most recent entry is always the last one.
STATE-FILE: KEEP LEAN. This file manages AI assistant state (what was done, what is pending, current context). No detailed implementation steps, commands, runbooks, investigation notes, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
CP-2026-08-21-01

## Pending
- [ ] Process notes.md: document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (see notes.md for full spec)
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`
- [ ] AGENTS.md TIER 2 — Protocol Developer Mode fix: add sub-bullet stating that during context load and post-compaction recovery, load ONLY the policy files explicitly listed under `## Active Expertise` in ai-customization.md; do NOT scan and load all files from the Project AI Policies Directory (that directory is the protocol's distribution tree, not the active policy set).
- [ ] Design docs — create drafts in `ai/notes/` (git-ignored, not for push yet): simple-ai-workflow-vision.md, simple-ai-workflow-prd.md, simple-ai-workflow-hld.md. Formalize protocol-decisions.md entries into proper ADR format. Create delivery ledger once PRD/HLD are drafted.
- [ ] ai-policy-code-review.md + ai-policy-common.md — add behavioral coaching rule: when surfacing any quality finding, describe intent and expected behavior, never a bare metric score. Flag that capable (Sonnet-class) models game bare scores more aggressively. (Research: Ideas 1+2, notes/ai-coding-quality-behavioral-prompts-habit-hooks-research-2026-08-21.md)
- [ ] AGENTS.md TIER 2 — add Habit Hooks opt-in snippet (~4 lines): if habit-hooks is available in the project, run it before declaring any coding task complete; treat its output as a direct high-priority coaching prompt. Zero overhead if tool not installed. (Research: Idea 3)
- [ ] ai-policy-common.md TDD Rule 1 — add three sub-rules: (a) simplest green — write the minimum code that makes the test pass, no more; (b) no dead code — nothing written that is not referenced by a test; (c) test behavior not implementation shape — tests must survive refactoring. (Research: Idea 4)
- [ ] docs/ — add guides for three opt-in patterns (not AGENTS.md core): ATDD as a standing Development Workflow rule for software projects (Idea 7); Grill Me interview procedure for new feature tasks (Idea 10); Ubiquitous Language project knowledge file pattern (Idea 11). (Research: notes/ai-coding-quality-behavioral-prompts-habit-hooks-research-2026-08-21.md)

## Deferred
- [ ] (Breaking — design as one coherent change later): Procedure E precedence rework so resume may read the latest checkpoint's single-writer-authoritative state instead of trusting only the lossy summary.
- [ ] (Separate project): AI-team dispatcher/watcher runtime (role lifecycle, watch-spawned execution) and per-agent status files for true parallelism. Not part of the protocol contract.
- [ ] REVISIT WHEN PARALLEL (Scenario B from CP-2026-06-30-02): Before running multiple AI agents/sessions that may write the three state files *concurrently*, adopt the per-agent-status-file model (one file per agent under `ai/shared/coordination/`, orchestrator reconciles). The current cooperative board is not race-safe for simultaneous writes; today's single-orchestrator model only holds when writes are serialized in time. Sequential role-switching in one session (Scenario A) is already safe and needs nothing.
- [ ] (Optional, carried) Review `ai/sessions/` directory — exists but not referenced in any policy or doc; document its purpose or remove it

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/
