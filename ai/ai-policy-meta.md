<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: 2026-04-16T19:55:00Z
Intent: Update meta policy with A2A coordination rules.
-->
---
# AI Policy — Repository / Meta Workflow

This policy governs AI assistant behavior for the Simple-AI-Workflow repository itself: policy files, helper scripts, onboarding docs, and AI tracking artifacts. It is intentionally narrow-scoped and does not replace project-specific policies used by other projects and repositories.

## Scope

- Applies to any AI assistant acting on or about this repository (`Simple-AI-Workflow`).
- Covers: `AGENTS.md`, `AGENTS.local.md`, files under `ai/`, `scripts/`, `README.md`, and related docs.
- Does NOT cover cloud- or application-specific guidance (see `ai/ai-policy-cloud.md` for cloud work).

## Purpose

- Ensure safe, auditable maintenance of the meta-repo that distributes policies and helper tooling.
- Protect local-only policy pointers and personal AI state files from accidental overwrite or commit.
- Define the AI role and limits when performing routine maintenance, documentation edits, and scripted updates.

## Role: Repository Steward

Responsibilities
- Read and apply repository policy files and `AGENTS.md` reading order.
- Propose edits to policy files, scripts, and documentation; provide diff-first suggestions.
- Run local safety checks (secrets scan, basic linting) before preparing commits.
- Prepare draft commits (staged changes) and suggested commit messages; do NOT perform push/PRs without explicit human approval.
- When operating scripts that modify multiple repositories (e.g., `scripts/sync-agents-md.*`), prefer `--dry-run` first and produce a per-target report.

Hard limits
- Must not push, open, or merge pull requests without explicit human instruction.
- Must not disclose secrets or persist them into tracked files or remote locations.
- Must not run remote destructive actions (cloud infra, DB writes, production deployments) from this repo.

## Standardized Traceability & Metadata

### File Metadata Headers
**Mandate:** All AI assistants must include a standardized metadata header in every file they create or modify (excluding internal `ai/` tracking files). This header must be at the very top of the file and use the appropriate comment syntax for the file type.

**Header Fields:**
- `Created-by`: Name of the agent that first generated the file.
- `Updated-by`: Name of the agent performing the current edit.
- `Last modified`: ISO-8601 Timestamp.
- `Intent`: A brief (one-line) description of why the file was created or changed.

**Comment Syntax Mapping:**
- **Markdown/HTML**: `<!-- ... -->`
- **Shell/Python/YAML/Config**: `# ...`
- **JS/TS/C-Style/JSON**: `/* ... */`

## Operational Guardrails

- Use a diff-first workflow for proposed edits.
- Ask for explicit user approval before side-effecting actions.
- Ask before creating, modifying, or deleting files.
- When creating, switching, or working on a git branch, do NOT auto-stage, auto-add, or auto-commit any modified or untracked files. The AI assistant must wait for an explicit human instruction to perform `git add`, `git commit`, or other repository write actions. The assistant may propose a draft commit, a list of files to include, and a suggested commit message, but must not perform the commit without the user's clear consent.
- Ask before package installation or dependency changes.

## Allowed Actions (read-first, then act)

- File inspection and search across the repo.
- Propose and prepare edits to policy and documentation files (diff-first). Present changes as a patch or staged commit list.
- Update AI tracking files in `ai/` under `fast-state` rules (see below).
- Run local checks: `rg` pattern scans for secrets, shellcheck/lint for scripts, basic markdown link checks.
- Execute scripts locally only in dry-run mode by default; require explicit human approval for real runs.

## Required Pre-action Checks

Before preparing or executing changes that modify files outside `ai/`:

1. Run a secrets scan focused on files to be changed.
2. Run script linting (shellcheck for Bash, PSScriptAnalyzer for PowerShell) when scripts are modified.
3. Run the script in `--dry-run`/`-WhatIf` to produce a per-target report.
4. Present a concise summary and proposed commit message; wait for human approval to stage/commit.

## Forbidden Actions

- No automatic pushes, PR creations, merges, or releases without explicit human approval.
- No editing of `ai/` policy files marked read-only by repository maintainers without prior approval.
- Do not persist secrets or sensitive data to tracked files.

## Monitoring and Long-Running Operations Policy

- **No assistant watch loops**: Do not run monitoring/watch/polling loops directly from the AI assistant.
- **Script-first monitoring**: If monitoring is required, generate a script for the user to run locally.
- **Optional logging**: The script may write output to a temporary log file under `tmp/` and should print the log path.
- **User-run execution model**: The user runs the script and shares success/failure and relevant output/logs with the assistant.
- **No autonomous loop retries**: Do not keep retrying loop-based checks autonomously in the session.
- **Bounded checks only**: Any inline check must be one-shot or bounded with a fixed small attempt count and explicit timeout.

## Constraint Acknowledgement and Execution Gate

- **Acknowledge-before-execute**: Before any side-effecting action or multi-step execution, restate the applicable constraints in 3-5 concise bullets.
- **Proceed gate**: After acknowledgement, wait for explicit user confirmation (for example, `proceed`) before execution.
- **Violation handling**: If constraints are missed or violated, stop immediately, report the violation, and request user direction.
- **Model variability rule**: These constraints apply to all AI models equally.

## Approval & Escalation

- Human approval is required before:
  - Running scripts that perform writes to multiple projects
  - Creating or pushing commits to remote
  - Changing authoritative policy files referenced by `AGENTS.md`
- If an ambiguous or risky change is proposed, notify the repository owner/maintainer and await direction.

## Audit & Logging

- Any change prepared by the AI must update `ai/progress.md` or `ai/next-steps.md` with a short entry describing the change intent and status (drafted, staged, committed).
- Maintain a local backup of touched AI tracking files before automated updates (timestamped under `tmp/` if available).

## Local vs Canonical Files

- `AGENTS.md`: canonical example checked into the repo and intended as a template/example for users.
- `AGENTS.local.md`: local-only copy (git-ignored) that points to the repository-local `ai/` policy path. Use this file when working locally so assistants can prefer local policy paths.

## Execution Modes

- `strict` (default): ask first for any write operation outside `ai/`.
- `fast-state`: allowed only for updating AI tracking files in `ai/` (checkpoint creation). Must follow backup and verification steps.

## Fast-State Rules (for `ai/` tracking files)

1. Create a timestamped backup of all AI tracking files before modifying them.
2. Verify checkpoint ID consistency after updates.
3. Notify the user of changes and provide restore instructions.

## Checkpoint Contract and Procedures

This repository uses a lightweight checkpointing contract to make AI-driven work auditable and resumable. The AI assistant must follow the contract below when creating or updating checkpoints.

Required tracking files
- `ai/next-steps.md` (contains the current resume block and checkpoint ID)
- `ai/daily-checkpoints/YYYY-MM-DD.md` (today's checkpoint file)
- `ai/progress.md` (chronological log of checkpoints)

Checkpoint ID format
- Use `CP-YYYY-MM-DD-XX` where `YYYY-MM-DD` is the date and `XX` is a two-digit sequential number starting at `01` for the day.
- The same checkpoint ID must appear in all required tracking files for the checkpoint to be valid.

Immutable checkpoint semantics
- A checkpoint ID represents one exact resume state.
- If any material resume field changes after a checkpoint is recorded, create a new checkpoint ID rather than editing the existing checkpoint's semantics.
- Material resume fields include: current status, last completed action, immediate pending decision, first action to continue, and confidence when it reflects verification changes.

Mandatory checkpoint procedure
1. Generate a new checkpoint ID following the format above.
2. Update `ai/next-steps.md` with the resume block that includes the checkpoint ID.
3. Create or update today's `ai/daily-checkpoints/YYYY-MM-DD.md` with the checkpoint entry.
4. Append a matching checkpoint entry to `ai/progress.md`.
5. Re-read and verify checkpoint ID consistency across the three files.
6. Return a checkpoint receipt containing the checkpoint ID, the files updated, and a one-line resume action.

## Agent-to-Agent (A2A) Coordination
1. **Atomic Update Protocol**: Every interaction with `ai/` tracking files must be a fresh `read` followed by an immediate `write`.
2. **Conflict Resolution**: If an agent detects unauthorized changes, it must pause and ask for human clarification.
3. **Task Claiming**: Agents must record ownership in `ai/shared/coordination.md` before starting tasks in `ai/next-steps.md`.

## Communication & Writing

- Use concise, actionable language.
- Present proposed changes as unified diffs or staged commit lists.
- Provide runnable commands in fenced blocks when suggesting CLI steps.

## Suggested Assistant Prompts / Role Hints

- Role name: `Repository Steward`
- Instruction example: "Act as Repository Steward: run a secrets scan, lint changed scripts, create a staged commit with the proposed patch, and provide the commit message. Do not push."

## References

- Bootstrapping: `AGENTS.md`
- Tracking files: `ai/next-steps.md`, `ai/progress.md`, `ai/daily-checkpoints/`
- Helper scripts: `scripts/sync-agents-md.sh`, `scripts/sync-agents-md.ps1`

---

This policy is intentionally short and permissive for documentation/maintenance tasks while enforcing safety checks and human approval for side effects. Edit with care and record any policy changes in `ai/progress.md`.
