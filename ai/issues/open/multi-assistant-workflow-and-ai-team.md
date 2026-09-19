Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: XL
URL:
Summary: Multi-assistant coordination contract and AI-team runtime support

Description:

Two related pieces. (1) Multi-assistant coordination contract: how several assistants work the same project through AGENTS.md plus coordination primitives. (2) Build-AI-team runtime: a dispatcher/watcher that spawns and manages AI roles. The runtime sits on top of the protocol contract and is a separate project; it must not be built into AGENTS.md.

The runtime half is tracked separately in `ai-team-runtime-dispatcher-watcher.md`, so this ticket focuses on the contract.

Scope:
- Coordination primitives proposed: optional ai/agent-config.md, advisory .ai-lock, an ai/tasks/ work queue with claimed-by, and checkpoints plus audit history.
- Roles: repository steward (policy), optional lead/coordinator, worker assistants.
- Safety: advisory locks, dry-run and diff-first, staged branches per assistant or task, secrets scan before staging.
- Coordination patterns: leader/orchestrator assigns; workers pick unclaimed tasks; the human reviews and merges.
- Runtime execution models: always-on persistent processes, or watch-spawned (preferred) where a watcher sees a new handoff, spawns the role, the role completes and reports, then sleeps. Identity is persistent, execution is ephemeral.
- True parallelism (Scenario B): the board is read-before-write, not a lock, so concurrent writers to the same state files can lose updates. The safe path is one status file per agent or task under ai/shared/coordination/, with the orchestrator reconciling.

Important: the draft predates the current state model (ai/state/, single-writer ownership, ai/shared/coordination.md). Reconcile it with the current model before resuming, to avoid two competing designs. Full design moved to `ai/shared/project-knowledge/multi-assistant-workflow-design.md`.

Size is XL because it needs a breakdown into a contract piece and a separate runtime project.

Acceptance criteria (refine after reconciliation):
- A single coordination contract that does not duplicate the current single-writer and board model.
- Dry-run for multi-target actions; human approval before any push or merge.
- No external-tool dependency.
