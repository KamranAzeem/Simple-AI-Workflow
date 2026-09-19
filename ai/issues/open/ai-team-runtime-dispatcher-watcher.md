Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P4
Size: XL
URL:
Summary: AI-team runtime: dispatcher/watcher that spawns and manages role agents

Description:

The runtime half of the multi-assistant work, tracked separately from the coordination contract (`multi-assistant-workflow-and-ai-team.md`). It is a separate project and must not be built into `AGENTS.md`.

Scope:
- Watch `ai/shared/handoffs/` for new handoffs and spawn the right role.
- Queue tasks, prevent double dispatch, handle crash recovery, and lock in-progress handoffs.
- Support watch-spawned roles: identity is persistent, execution is ephemeral.
- No external-tool dependency.

Reconcile with the current protocol model (single-writer state, coordination board) before designing. Background: `ai/shared/project-knowledge/multi-assistant-workflow-design.md`.

Acceptance criteria (refine after reconciliation):
- A dispatcher that spawns roles from handoffs without double dispatch.
- Roles report to the board and their handoff; they never write the three state files.
- Runs as a standalone project on top of the protocol.
