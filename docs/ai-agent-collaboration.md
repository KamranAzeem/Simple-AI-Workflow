<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: 2026-04-16T13:50:00Z
Intent: Document the AI agent collaboration and coordination system for human and AI reference.
-->
---
# AI Agent Collaboration & Coordination System

This document explains how different AI assistants (Gemini, Copilot, ChatGPT, etc.) collaborate, share knowledge, and coordinate their actions within this repository.

## Why This System Exists
In a multi-agent environment, there is a risk of:
1.  **Duplicate Effort**: Two agents performing the same research or debugging.
2.  **Collisions**: Two agents modifying the same files or infrastructure simultaneously.
3.  **Knowledge Loss**: Valuable technical discoveries being lost between sessions.
4.  **Context Waste**: Spending excessive tokens to re-explain the same context to different agents.

## How It Works

### 1. The Shared Intelligence Layer (`ai/shared/`)
Located in the git-ignored `ai/` directory, this is the "shared memory" for all assistants.

- **`ai/shared/handoffs/`**: Shift-change notes. When an agent finishes a task, they leave a note here for whoever comes next.
- **`ai/shared/knowledge-base/`**: Technical Wiki. Deep dives into errors, architectural findings, or tool-specific quirks (e.g., "How to handle TimescaleDB 2.x to 17 migrations").
- **`ai/shared/coordination.md`**: The Status Board. Shows who is currently active and what parts of the codebase are currently "locked" for development.

### 2. Standardized Traceability (Metadata Headers)
Every file created or modified by an AI includes a header like this:
```markdown
<!--
Created-by: AgentName
Updated-by: AgentName
Last modified: YYYY-MM-DD
Intent: Explanation of the change.
-->
```
This allows you to look at any file and instantly know **who** changed it and **why**.

### 3. Shared Policy Baseline (`ai/ai-policy-common.md`)
All assistants share a mandatory set of operational rules and contracts (branch-gating, A2A protocols, checkpoint ID contracts). This is defined in the **central common policy file**, ensuring that no matter which agent is active, they all follow the same safety and engineering standards.

### 4. Session Logging (`ai/sessions/`)
Action-oriented CLI agents maintain a detailed log of every command and tool execution (AI Flight Recorder). The strict naming convention, `Session-ID` requirement, and transaction-based logging rules are defined in the **AGENTS.md** bootstrap protocol. This ensures a granular, programmatically-accessible audit trail for all changes.

## Human Guidance: How to Interacting with AI Agents
- **Check the Progress**: Read `ai/progress.md` and `ai/next-steps.md` to see the high-level status.
- **Check the Coordination**: Look at `ai/shared/coordination.md` to see what the AI is currently focusing on.
- **Audit the Files**: Check the headers at the top of files to verify AI-generated content.

## Agent Guidance: How to Collaborate
1.  **Bootstrap**: Follow `AGENTS.md` protocol.
2.  **Announce**: Update `ai/shared/coordination.md` when starting a session.
3.  **Learn**: Read recent files in `ai/shared/knowledge-base/` and `ai/shared/handoffs/`.
4.  **Document**: Save technical research to the `knowledge-base/` to save tokens for future sessions.
5.  **Handoff**: Leave a note in `handoffs/` if a task is incomplete.

### A2A Rules (Mandatory)
1.  **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
2.  **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
3.  **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/next-steps.md`.

*Example: Task Claiming*
To claim a task, an agent should first read `ai/shared/coordination.md` to see existing locks. If clear:
1. Append the task ownership to `ai/shared/coordination.md`.
2. Proceed with the task.
3. Upon completion, remove the ownership entry.


