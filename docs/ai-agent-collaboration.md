<!--
Created-by: Gemini
Updated-by: Gemini CLI
Last modified: 2026-05-02T22:50:00Z
Intent: Document Refined Handoff Protocol and Conditional Autonomy rules.
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

## Collaborative Models

### 1. Intra-Project Collaboration
This system enables multiple agents to work on a **single repository** concurrently or sequentially via the git-ignored `ai/shared/` directory.

- **`ai/shared/handoffs/`**: Shift-change notes for specific project tasks.
- **`ai/shared/knowledge-base/`**: Technical wiki scoped to the specific project's architecture, dependencies, and quirks.
- **`ai/shared/coordination.md`**: The Status Board for project-level task locking.

### Handoff Protocol & Conditional Autonomy
To ensure safety while allowing progress across AI sessions, the system uses a **Refined Handoff Protocol**:

1.  **Valid Handoff Definition**: A handoff is only valid if it contains a `## Verification` (or `## Validation`) section with objective, executable steps to confirm completion.
2.  **Refusal Mandate**: AI assistants MUST refuse to process any handoff lacking this section to prevent unverified autonomous work.
3.  **Conditional Autonomy**: AI assistants are permitted to autonomously squash-merge a feature branch to `master`/`main` ONLY if:
    - They are working on a dedicated feature branch.
    - ALL verification steps in the handoff pass with zero errors.
    - All coordination state (coordination.md, progress.md) is updated correctly.
    *Otherwise, human approval is mandatory before any merge.*

### 2. Cross-Project (Centralized) Collaboration
This architecture provides a persistent, cross-project "Shared Intelligence" layer for when assistants operate across **multiple solution directories**. It ensures settings and knowledge follow the user and the agent across different project boundaries.

- **`Central AI Settings Source` (`/home/kamran/.ai/settings/`)**: Stores personal identity-level context (e.g., `about-human.md`) and tool preferences.
- **`Central AI Shared Knowledge Source` (`/home/kamran/.ai/shared-knowledge/`)**: Stores reusable design patterns, architectural lessons, and technical tips valid across all projects.
- **Bootstrapping**: Agents automatically index these sources upon session initiation as read-only knowledge providers.
- **Normalization**: Content here is treated as "lessons learned" to inform decision-making, not as authoritative project-specific logic.

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
4.  **Handoff Claim & Execute Lifecycle**:
    - **Scan**: Check `ai/shared/handoffs/` for pending tasks.
    - **Validate**: Confirm the handoff is "Valid" (contains Verification section).
    - **Claim**: Record ownership in `ai/shared/coordination.md`.
    - **Execute**: Work on a feature branch.
    - **Verify**: Run all verification steps.
    - **Finalize**: Merge to master (if autonomy conditions met) and update `ai/progress.md`.
    - **Cleanup**: Delete the handoff file and clear the claim in `ai/shared/coordination.md`.


