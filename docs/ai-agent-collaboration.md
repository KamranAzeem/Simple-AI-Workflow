# AI Agent Collaboration & Coordination System

This document explains how different AI assistants (Gemini, Copilot, ChatGPT, etc.) collaborate, share knowledge, and coordinate their actions within this repository.

## Why This System Exists

In a multi-agent environment, there is a risk of:

1. **Duplicate Effort**: Two agents performing the same research or debugging.
2. **Collisions**: Two agents modifying the same files or infrastructure simultaneously.
3. **Knowledge Loss**: Valuable technical discoveries being lost between sessions.
4. **Context Waste**: Spending excessive tokens to re-explain the same context to different agents.

## Collaborative Models

### 1. Project-Specific Collaboration

This system enables multiple agents to work on a **single repository** concurrently or sequentially via the git-ignored `ai/shared/` directory.

- **`ai/shared/handoffs/`**: Shift-change notes for specific project tasks.
- **`ai/shared/project-knowledge/`**: Technical wiki scoped to the specific project's architecture, dependencies, and quirks.
- **`ai/shared/coordination.md`**: The Status Board for project-level task locking.

### Handoff Protocol & Conditional Autonomy

To ensure safety while allowing progress across AI sessions, the system uses a **Refined Handoff Protocol**:

1. **Valid Handoff Definition**: A handoff is valid only when it contains every section in `## Handoff Template` in `ai-policy-handoff.md`, including a `## Verification` section with objective, executable steps.
2. **Refusal Mandate**: AI assistants MUST load `ai-policy-handoff.md` and refuse to process any handoff that lacks a required section.
3. **Conditional Autonomy**: A receiver may merge the branch to trunk only when the handoff is valid, the creation review is APPROVED, every verification step passes with zero errors, and the coordination board (`coordination.md`) is updated. The receiver does not write the three state files. The original orchestrator records the state at the next checkpoint and deletes the handoff. Tags, releases, and external writes need separate approval, and the merge mode is set in `## Merge Policy`.

### 2. Global (Cross-Project) Collaboration

This architecture provides a persistent, cross-project "Shared Intelligence" layer for when assistants operate across **multiple solution directories**. It ensures settings and knowledge follow the user and the agent across different project boundaries.

- **`Global Settings Source` (`~/.ai/settings/`)**: Stores personal identity-level context (e.g., `global-user-settings.md`) and tool preferences. Fully loaded at every session start.
- **`Global Knowledge Source` (`~/.ai/global-knowledge/`)**: Stores reusable design patterns, architectural lessons, and technical tips valid across all projects. Indexed at session start (JIT), then read on demand, unlike Global Settings which loads in full.
- **Bootstrapping**: Agents load Global Settings in full and index Global Knowledge at session initiation as read-only knowledge providers.
- **Normalization**: Content here is treated as "lessons learned" to inform decision-making, not as authoritative project-specific logic.

### 3. Shared Policy Baseline (`ai/policies/ai-policy-common.md`)

All assistants share a mandatory set of operational rules and contracts (branch-gating, A2A protocols, checkpoint ID contracts). This is defined in the **global common policy file**, ensuring that no matter which agent is active, they all follow the same safety and engineering standards.

## Human Guidance: How to Interact with AI Agents

- **Check the Progress**: Read `ai/state/progress.md` and `ai/state/next-steps.md` to see the high-level status.
- **Check the Coordination**: Look at `ai/shared/coordination.md` to see what the AI is currently focusing on.

## Agent Guidance: How to Collaborate

1. **Bootstrap**: Follow `AGENTS.md` protocol.
2. **Announce**: Update `ai/shared/coordination.md` when starting a session.
3. **Learn**: Read recent files in `ai/shared/project-knowledge/` and `ai/shared/handoffs/`.
4. **Document**: Save technical research to the `project-knowledge/` to save tokens for future sessions.
5. **Handoff**: Append a `## Completion` note to the handoff and clear the claim; the original orchestrator records and deletes it at the next checkpoint.

### A2A Rules (Mandatory)

1. **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
2. **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
3. **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/state/next-steps.md`.
4. **Handoff Claim & Execute Lifecycle**:
    - **Scan**: Check `ai/shared/handoffs/` for pending tasks.
    - **Validate**: Load `ai-policy-handoff.md` and confirm the handoff is a Valid Handoff.
    - **Claim**: Record ownership in `ai/shared/coordination.md`.
    - **Execute**: Work on a feature branch.
    - **Verify**: Run all verification steps.
    - **Finalize**: If the conditional autonomy conditions pass, merge to trunk. The receiver does not write the three state files.
    - **Report back**: Append a `## Completion` note to the handoff and clear the claim in `ai/shared/coordination.md`.
    - **Cleanup**: The original orchestrator records the handoff in the state files at the next checkpoint, then deletes the handoff.
