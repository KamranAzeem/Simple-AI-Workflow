<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-04-21T11:45:00Z
Intent: Add API Rate-Limit Mitigation policy to universal guardrails.
-->
---
# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

# AI Assistant Policy — Common Guardrails & Contracts

This file contains the universal operating rules for all AI assistants in this repository.

## Instruction Precedence
- Resolve conflicts using this order: system/tool safety rules > explicit user request in the current session > the [local policy override file](ai/ai-policy-override.md) > specialized policy > this [central common policy file](ai/ai-policy-common.md).

## Feature Development and Branch-Gating
### Branch-Gating Requirement
When implementing new features, architecture changes, or functional code modifications:
1. **Discussion**: Propose and wait for approval.
2. **Branch**: Work on a human-approved feature branch (e.g., `feature/xyz`).
3. **Integration**: Merge only after human approval.
*Exception*: Read-only work, documentation, and AI tracking files do not require branching.

## Agent-to-Agent (A2A) Coordination
1. **Atomic Update Protocol**: Fresh `read` followed by immediate `write` for all AI tracking files.
2. **Operational Synthesis**: Bootstrap is incomplete until requirements are synthesized and a check on the shared directory is performed.
3. **Task Claiming**: Record ownership in the [coordination file](ai/shared/coordination.md) before starting tasks.

## Operational Restart and Checkpoint Contract
### Source-of-Truth Order
1. [next-steps file](ai/next-steps.md)
2. Latest daily checkpoint in the [daily-checkpoints directory](ai/daily-checkpoints/)
3. [progress file](ai/progress.md)
4. [context file](ai/context.md)

### Checkpoint ID Contract
- Format: `CP-YYYY-MM-DD-XX`.
- Must be consistent across all tracking files.
- Material resume field changes require a new ID.

## Standardized Traceability & Metadata
**Mandate**: Include a metadata header in every created or modified file (excluding `ai/` tracking files).
- Fields: `Created-by`, `Updated-by`, `Last modified`, `Intent`.
- **Timestamp Policy**: Always use the human user's local time for all timestamps (ISO-8601 format).

## Session Logging (Flight Recorder)
**Mandate (CLI Assistants only)**: Maintain granular, continuous session logs according to the protocol defined in **AGENTS.md**.
- **Atomic Requirement**: Every conversational turn MUST be appended to the active session log file in `ai/sessions/` within the same turn as the interaction. This ensures a complete, 1:1 history of all user queries, AI reasoning, tool usage, and results.


## Universal Operational Guardrails
- **No side effects without approval**: Ask before file creation/deletion, package installation, or Git write actions.
- **Secrets Awareness**: Check for secrets before any `git add` or `git commit`. Stop and alert if found.
- **No watch loops**: Do not run autonomous monitoring; generate scripts for the user to run instead.
- **Acknowledge-before-execute**: Restate constraints in 3-5 bullets before side-effecting actions.
- **Execution Modes**: `strict` (default) vs `fast-state` (authorized only for AI tracking files).
- **API Rate-Limit Awareness**:
    - **Batching**: Group independent tool calls into a single turn whenever possible to minimize API requests.
    - **Surgical Edits**: Prefer `replace` (targeted edits) over `write_file` (full rewrites) to reduce token payload and processing time.
    - **Throttle Management**: If rate limits are encountered, pause execution and propose a throttled batch strategy to the user.

## Communication Standards
- **Token Efficiency**: Minimize filler; use direct, actionable language.
- **Readability**: Use clear headings, bullet points, and copy-friendly code blocks.
- **Technically Precise**: Use technical terms only when necessary; prefer simple, clear English.
