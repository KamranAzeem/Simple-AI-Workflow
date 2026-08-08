<!--
Created-by: GitHub Copilot
Updated-by: GitHub Copilot
Last modified: 2026-05-21T00:00:00+02:00
Intent: Create missing mandatory coordination board file per AGENTS.md protocol.
-->

# Agent Coordination Board

This file is the shared coordination board for all AI assistants working in this repository.
It must be read before claiming a task and cleared after completing it. It is also the
**awareness channel**: agents learn what others are doing by reading this board, not by
reading each other's state files.

## Ownership Model

- **State files are single-writer**: `ai/state/context.md`, `ai/state/progress.md`, and `ai/state/next-steps.md`
  are the canonical project narrative and are written **only** by the project-root orchestrator.
- **Sub-agents and role-based team members do NOT write the three state files.** They report
  their work here (the board), in their handoff file, and in role-scoped Project Knowledge files.
- The orchestrator **reconciles** this board into the state files at each checkpoint (Procedure C).

## Active Tasks

_No tasks currently claimed._

## Protocol

- **Claim**: Before starting a task, add an entry: `[AGENT-NAME] [TIMESTAMP] — <task description>`
- **Clear**: After completing a task (or on handoff), update your entry to a completion record
  here (`[AGENT-NAME] [TIMESTAMP] — DONE: <result / where outputs live>`) and write any durable
  findings to role-scoped Project Knowledge. **Do NOT write the three state files** — the
  orchestrator folds your completion record into them at the next checkpoint.
- **Atomic Update**: Always read this file immediately before writing to it to reduce conflicts.
  This is cooperative coordination, not a lock — keep entries small and append/own-row to
  minimise the race window. For real parallelism, use one status file per agent/task instead of
  a shared board.
