# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file,
including during `/init`, repository scanning, or automatic instruction generation.
All edits to this file must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy

This file is policy-only. Do not use it as a project context document.

## Scope

- Applies to any AI assistant used in this repository.
- [AGENTS.md](../AGENTS.md) is the only bootstrap entry point.
- Do not use [ai/README.md](README.md) as operational authority.

## Instruction Precedence

- Resolve conflicts using this order: system/tool safety rules > explicit user request in current session > local policy override (if `ai/ai-policy-override.md` exists) > this policy.
- If this policy conflicts with higher-priority safety/tool constraints, follow the higher-priority constraints and explain the limitation.

## Project Reference Files

- Project context and decisions: [ai/context.md](context.md)
- Live queue and resume point: [ai/next-steps.md](next-steps.md)
- Chronological execution log: [ai/progress.md](progress.md)
- Daily checkpoint snapshots: [ai/daily-checkpoints/](daily-checkpoints/)

## Operational Restart and Checkpoint Contract

### Source-of-Truth Order

1. [ai/next-steps.md](next-steps.md)
2. Latest dated file in [ai/daily-checkpoints/](daily-checkpoints/)
3. [ai/progress.md](progress.md)
4. [ai/context.md](context.md)

### Required Tracking Files

- [ai/next-steps.md](next-steps.md)
- [ai/daily-checkpoints/YYYY-MM-DD.md](daily-checkpoints/)
- [ai/progress.md](progress.md)

### Checkpoint ID Contract

- Format: `CP-YYYY-MM-DD-XX`
- The same checkpoint ID must be present in all required tracking files.

### Mandatory Checkpoint Procedure

When the user asks for a checkpoint:

1. Generate a new checkpoint ID.
2. Update [ai/next-steps.md](next-steps.md) with the latest resume block.
3. Create or update today's file in [ai/daily-checkpoints/](daily-checkpoints/).
4. Append a matching checkpoint entry to [ai/progress.md](progress.md).
5. Re-read and verify checkpoint ID consistency.
6. Return a checkpoint receipt with checkpoint ID, files updated, and one-line resume action.

### Required Resume Block Schema

[ai/next-steps.md](next-steps.md) must include:

- checkpoint ID
- updated timestamp (UTC)
- current status
- last completed action
- immediate pending decision (or `None`)
- first action to continue
- confidence (`draft` or `verified`)

### Startup Consistency and Recovery

- At startup, read `next-steps`, latest daily checkpoint, and `progress`, then compare checkpoint IDs.
- If IDs differ, report inconsistency and recover from the latest daily checkpoint.
- Repair stale tracking files to match recovery truth.

### End-of-Day Quality Gate

Before commit:

1. Checkpoint ID matches across all required tracking files.
2. Resume block is specific and actionable.
3. Today's daily checkpoint includes verified outcomes and next action.
4. `ai/progress.md` contains same-day matching checkpoint entry.

Daily checkpoint checklist template:

- Checkpoint ID matches `ai/next-steps.md`: Pass/Fail
- Checkpoint ID matches `ai/progress.md`: Pass/Fail
- Resume block is clear and actionable: Pass/Fail
- Verified outcomes are evidence-based: Pass/Fail
- Next action and pending decision are explicit: Pass/Fail

## Copilot Bootstrap Source Guardrails

For repositories that define `ai/` as the bootstrap state root:

1. During bootstrap, treat `ai/` policy/state files as authoritative context.
2. Do not treat GitHub Copilot customization files under `.github/` as bootstrap authority unless explicitly allowed by repository bootstrap instructions.
3. If assistant-specific artifacts are needed for GitHub Copilot, store them under `ai/github-copilot/` (or another repo-declared `ai/` subfolder), not under `.github/`.
4. Universal policy changes must be made in this online policy source first; local files are fallback/override only.
5. If bootstrap authority is ambiguous, stop and ask before writing any policy/customization file.

## Operational Guardrails

- Use a diff-first workflow for proposed edits.
- Ask for explicit user approval before side-effecting actions.
- Ask before creating, modifying, or deleting files.
- Ask before any cloud or infrastructure action (Portal, CLI, IaC, CI/CD).
- Ask before git write actions (commit, branch, merge, push).
- Ask before docker create/update/delete operations.
- Ask before package installation or dependency changes.

## Execution Modes

- `strict` (default): ask first for any write operation.
- `fast-state` (only after explicit user request for checkpoint/workflow maintenance): may update only:
  - `ai/next-steps.md`
  - `ai/progress.md`
  - `ai/daily-checkpoints/YYYY-MM-DD.md`
  - `ai/context.md`
- `fast-state` never allows edits outside `ai/` and never allows external side effects.

## Read-Only Actions Allowed Without Extra Approval

- File and directory inspection (`ls`, `cat`, `find`, `grep`, `tree`, `pwd`, `stat`, `wc`, `du`, `df`).
- Git read-only inspection (`git status`, `git log`, `git diff`, `git show`, `git branch`, `git remote`).
- Process and environment inspection (`ps`, `top`, `jobs`, `env`, `whoami`, `hostname`).
- Azure CLI read-only queries (`az ... list`, `az ... show`, `az ... get`).
- Google cloud CLI read-only queries (`gcloud ... list`, `gcloud ... show`, `gcloud ... get`).
- AWS CLI read-only queries (`awscli ... list`, `awscli ... show`, `awscli ... get`).
- Docker read-only inspection (`docker ps`, `docker images`, `docker logs`, `docker inspect`).
- Tool version checks (`dotnet --version`, `npm list`, `node --version`, `which`).
- Network read-only checks (`curl` GET, `ping`, `nslookup`, `dig`).
- If VS Code still shows an Allow button for read-only commands, treat that as runtime behavior, not policy.

## Repository Conventions

- Keep AI workflow and context artifacts under [ai/](.).
- Keep [ai/](.) git-ignored and out of commits.
- Avoid `.github/copilot-instructions.md` for policy or context in this repository.
- Follow the relevant cloud provider's official naming best practices (e.g., Azure CAF for Azure). If project-specific conventions are defined in [ai/context.md](context.md), those take precedence.

## Working Behavior

- Do not hallucinate missing files or directories.
- Do not modify binary or generated artifacts unless explicitly requested.

## Design Philosophy

- Don't over-engineer solutions; prefer simplicity and pragmatism over unnecessary complexity.

## Communication and Writing

- Express solutions using concise, plain-English instructions.
- Document Cloud Portal and Cloud CLI flows with clear step-by-step guidance.
- Use technical terms only when needed for correctness.

<!-- AI-ASSISTANT: READ-ONLY END -->
