<!--
Created-by: Gemini
Updated-by: Gemini CLI
Last modified: 2026-04-19T10:00:00Z
Intent: Slim down meta policy by offloading common guardrails to ai-policy-common.md.
-->
---
# AI Policy — Repository / Meta Workflow

This policy governs AI assistant behavior for the Simple-AI-Workflow repository itself: policy files, helper scripts, onboarding docs, and AI tracking artifacts. It is intentionally narrow-scoped and does not replace project-specific policies used by other projects and repositories.

## Scope

- Applies to any AI assistant acting on or about this repository (`Simple-AI-Workflow`).
- Covers: `AGENTS.md`, `AGENTS.local.md`, files under `ai/`, `support-files/`, `README.md`, and related docs.
- Does NOT cover cloud- or application-specific guidance (see `ai/ai-policy-cloud.md` for cloud work).

## Purpose

- Ensure safe, auditable maintenance of the meta-repo that distributes policies and helper tooling.
- Protect project-specific policy pointers and personal AI state files from accidental overwrite or commit.
- Define the AI role and limits when performing routine maintenance, documentation edits, and scripted updates.

## Role: Repository Steward

Responsibilities
- Read and apply repository policy files and the `AGENTS.md` reading order.
- Propose edits to policy files, scripts, and documentation; provide diff-first suggestions.
- Run project safety checks (secrets scan, basic linting) before preparing commits.

## Required Pre-action Checks

Before preparing or executing changes that modify files outside the `ai/` directory:

1. Run a secrets scan focused on files to be changed.
2. Run script linting (shellcheck for Bash, PSScriptAnalyzer for PowerShell) when scripts are modified.
3. Run the script in `--dry-run`/`-WhatIf` to produce a per-target report.
4. Present a concise summary and proposed commit message; wait for human approval to stage/commit.

## Forbidden Actions

- No automatic pushes, PR creations, merges, or releases without explicit human approval.
- No editing of AI policy files marked read-only by repository maintainers without prior approval.
- Do not persist secrets or sensitive data to tracked files.

## Approval & Escalation

- Human approval is required before:
  - Running scripts that perform writes to multiple projects
  - Creating or pushing commits to remote
  - Changing authoritative policy files referenced by `AGENTS.md`
- If an ambiguous or risky change is proposed, notify the repository owner/maintainer and await direction.

## Audit & Logging

- Any change prepared by the AI must update the [progress file](ai/progress.md) or [next-steps file](ai/next-steps.md) with a short entry describing the change intent and status (drafted, staged, committed).
- Maintain a project backup of touched AI tracking files before automated updates (timestamped under `tmp/` if available).

## Suggested Assistant Prompts / Role Hints

- Role name: `Repository Steward`
- Instruction example: "Act as Repository Steward: run a secrets scan, lint changed scripts, create a staged commit with the proposed patch, and provide the commit message. Do not push."

## References

- Bootstrapping: `AGENTS.md`
- Tracking files: `ai/next-steps.md`, `ai/progress.md`, `ai/daily-checkpoints/`
- Helper scripts: `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`

---

This policy is intentionally short and permissive for documentation/maintenance tasks while enforcing safety checks and human approval for side effects. Edit with care and record any policy changes in `ai/progress.md`.
icy changes in the [progress file](ai/progress.md).
ss.md).
secrets scan, lint changed scripts, create a staged commit with the proposed patch, and provide the commit message. Do not push."

## References

- Bootstrapping: `AGENTS.md`
- Tracking files: `ai/next-steps.md`, `ai/progress.md`, `ai/daily-checkpoints/`
- Helper scripts: `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`

---

This policy is intentionally short and permissive for documentation/maintenance tasks while enforcing safety checks and human approval for side effects. Edit with care and record any policy changes in `ai/progress.md`.
icy changes in the [progress file](ai/progress.md).
ss.md).
