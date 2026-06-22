<!--
Created-by: GitHub Copilot
Updated-by: GitHub Copilot
Last modified: 2026-05-21T00:00:00+02:00
Intent: Create missing mandatory coordination board file per AGENTS.md protocol.
-->

# Agent Coordination Board

This file is the shared coordination board for all AI assistants working in this repository.
It must be read before claiming a task and cleared after completing it.

## Active Tasks

_No tasks currently claimed._

## Protocol

- **Claim**: Before starting a task, add an entry: `[AGENT-NAME] [TIMESTAMP] — <task description>`
- **Clear**: After completing a task (or on handoff), remove the entry and update `ai/progress.md`.
- **Atomic Update**: Always read this file immediately before writing to it to avoid conflicts.
