# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy — Repository / Meta Workflow

This policy governs AI assistant behavior for this repository: policy files, helper scripts, onboarding docs, and AI tracking artifacts. It is intentionally narrow-scoped and does not replace project-specific policies used by other projects and repositories.

## Scope

- Applies to any AI assistant acting on or about this repository.
- Covers: `AGENTS.md`, files under `ai/`, `support-files/`, `README.md`, and related docs.
- Does NOT cover domain-specific guidance covered by individual policy files under `ai/policies/` (e.g. cloud, data, mobile, frontend).

## Purpose

- Ensure safe, auditable maintenance of the meta-repo that distributes policies and helper tooling.
- Protect project-specific policy pointers and personal AI state files from accidental overwrite or commit.
- Define the AI role and limits when performing routine maintenance, documentation edits, and scripted updates.

## Role: Repository Steward

Responsibilities
- Read and apply repository policy files and the AGENTS.md procedures and tier structure.
- Propose edits to policy files, scripts, and documentation; provide diff-first suggestions.
- Run project safety checks (secrets scan, basic linting) before preparing commits.

## Required Pre-action Checks

Before preparing or executing changes that modify files outside the `ai/` directory:

1. **Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, you are operating on the protocol itself. Fully load `protocol-decisions.md` from the **Project AI Knowledge Directory** before making any change to `AGENTS.md`, policy files, `support-files/validate-protocol.sh`, or any file under `ai/`. This file records authoritative past decisions and must not be treated as JIT-optional.
2. Run a secrets scan focused on files to be changed.
3. Run script linting (shellcheck for Bash, PSScriptAnalyzer for PowerShell) when scripts are modified.
4. Run the script in `--dry-run`/`-WhatIf` to produce a per-target report.
5. Present a concise summary and proposed commit message; wait for human approval to stage/commit.

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

- Any change prepared by the AI must update `ai/progress.md` or `ai/next-steps.md` with a short entry describing the change intent and status (drafted, staged, committed).
- Before automated updates, back up touched AI tracking files to a timestamped archive (use the **Global AI Backups Directory** defined in AGENTS.md TIER 1).

## Suggested Assistant Prompt

- "Act as Repository Steward: run a secrets scan, lint changed scripts, create a staged commit with the proposed patch, and provide the commit message. Do not push."

## References

- Bootstrapping: `AGENTS.md`
- Tracking files: `ai/next-steps.md`, `ai/progress.md`, **Project Daily Checkpoints Directory**
- Helper scripts: `support-files/sync-agents-md.sh`, `support-files/sync-agents-md.ps1`

---

This policy is intentionally short and permissive for documentation/maintenance tasks while enforcing safety checks and human approval for side effects. Edit with care and record any policy changes in `ai/progress.md`.

<!-- AI-ASSISTANT: READ-ONLY END -->
