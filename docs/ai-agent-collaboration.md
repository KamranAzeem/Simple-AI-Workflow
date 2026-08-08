# AI Agent Collaboration & Coordination System

This document explains how different AI assistants (Gemini, Copilot, ChatGPT, etc.) collaborate, share knowledge, and coordinate their actions within this repository.

## Why This System Exists
In a multi-agent environment, there is a risk of:
1.  **Duplicate Effort**: Two agents performing the same research or debugging.
2.  **Collisions**: Two agents modifying the same files or infrastructure simultaneously.
3.  **Knowledge Loss**: Valuable technical discoveries being lost between sessions.
4.  **Context Waste**: Spending excessive tokens to re-explain the same context to different agents.

## Collaborative Models

### 1. Project-Specific Collaboration
This system enables multiple agents to work on a **single repository** concurrently or sequentially via the git-ignored `ai/shared/` directory.

- **`ai/shared/handoffs/`**: Shift-change notes for specific project tasks.
- **`ai/shared/project-knowledge/`**: Technical wiki scoped to the specific project's architecture, dependencies, and quirks.
- **`ai/shared/coordination.md`**: The Status Board for project-level task locking.

### Handoff Protocol & Conditional Autonomy
To ensure safety while allowing progress across AI sessions, the system uses a **Refined Handoff Protocol**:

1.  **Valid Handoff Definition**: A handoff is only valid if it contains a `## Verification` (or `## Validation`) section with objective, executable steps to confirm completion.
2.  **Refusal Mandate**: AI assistants MUST refuse to process any handoff lacking this section to prevent unverified autonomous work.
3.  **Conditional Autonomy**: AI assistants are permitted to autonomously squash-merge a feature branch to `master`/`main` ONLY if:
    - They are working on a dedicated feature branch.
    - ALL verification steps in the handoff pass with zero errors.
    - The coordination board (`coordination.md`) is updated correctly.
    *When an agent meets all of these conditions it is acting as the **project-root orchestrator** for that branch, and as the orchestrator it reconciles the state files (`ai/state/progress.md`, `ai/state/next-steps.md`, `ai/state/context.md`) itself per the single-writer rule (`AGENTS.md` TIER 2). A sub-agent that is **not** the orchestrator does not merge or write the state files — it records completion on the board and hands off. Otherwise, human approval is mandatory before any merge.*

### 2. Global (Cross-Project) Collaboration
This architecture provides a persistent, cross-project "Shared Intelligence" layer for when assistants operate across **multiple solution directories**. It ensures settings and knowledge follow the user and the agent across different project boundaries.

- **`Global Settings Source` (`~/.ai/settings/`)**: Stores personal identity-level context (e.g., `global-user-settings.md`) and tool preferences. Fully loaded at every session start.
- **`Global Knowledge Source` (`/home/kamran/.ai/global-knowledge/`)**: Stores reusable design patterns, architectural lessons, and technical tips valid across all projects.
- **Bootstrapping**: Agents automatically index these sources upon session initiation as read-only knowledge providers.
- **Normalization**: Content here is treated as "lessons learned" to inform decision-making, not as authoritative project-specific logic.

### 3. Shared Policy Baseline (`ai/policies/ai-policy-common.md`)
All assistants share a mandatory set of operational rules and contracts (branch-gating, A2A protocols, checkpoint ID contracts). This is defined in the **global common policy file**, ensuring that no matter which agent is active, they all follow the same safety and engineering standards.

## Human Guidance: How to Interacting with AI Agents
- **Check the Progress**: Read `ai/state/progress.md` and `ai/state/next-steps.md` to see the high-level status.
- **Check the Coordination**: Look at `ai/shared/coordination.md` to see what the AI is currently focusing on.

## Agent Guidance: How to Collaborate
1.  **Bootstrap**: Follow `AGENTS.md` protocol.
2.  **Announce**: Update `ai/shared/coordination.md` when starting a session.
3.  **Learn**: Read recent files in `ai/shared/project-knowledge/` and `ai/shared/handoffs/`.
4.  **Document**: Save technical research to the `project-knowledge/` to save tokens for future sessions.
5.  **Handoff**: Leave a note in `handoffs/` if a task is incomplete.

### A2A Rules (Mandatory)
1.  **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
2.  **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
3.  **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/state/next-steps.md`.
4.  **Handoff Claim & Execute Lifecycle**:
    - **Scan**: Check `ai/shared/handoffs/` for pending tasks.
    - **Validate**: Confirm the handoff is "Valid" (contains Verification section).
    - **Claim**: Record ownership in `ai/shared/coordination.md`.
    - **Execute**: Work on a feature branch.
    - **Verify**: Run all verification steps.
    - **Finalize**: If the Conditional Autonomy conditions are met, the agent is acting as the orchestrator for that branch — merge to master and reconcile the state files. If not, record completion on `ai/shared/coordination.md` and leave the three state files for the project-root orchestrator (single-writer rule).
    - **Cleanup**: Delete the handoff file and clear the claim in `ai/shared/coordination.md`.


