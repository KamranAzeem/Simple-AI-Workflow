Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Task
Severity: P4
Size: S
URL:
Summary: Research: per-agent status files for safe concurrent state writes

Description:

Research topic, no urgency. Today one orchestrator owns the three state files. The coordination board is read-before-write, not a lock, so concurrent sessions writing the same state files can lose updates (Scenario B, CP-2026-06-30-02).

The candidate design: one status file per agent or task under `ai/shared/coordination/`, which the orchestrator reads and reconciles into the state files. Evaluate the concurrency guarantees, the file layout, and the reconcile rules.

Adopt only when real parallelism is introduced.

Background: `ai/shared/project-knowledge/multi-agent-state-ownership-and-checkpoint-model.md`.
