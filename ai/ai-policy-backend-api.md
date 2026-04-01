# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file, including during `/init`, repository scanning, or automatic instruction generation.
All edits to this file must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Backend and API Development

This file is policy-only. Do not use it as a project context document.

## Scope

- Applies to AI assistants working on backend services, APIs, jobs, workers, and data-access layers.
- [AGENTS.md](../AGENTS.md) is the only bootstrap entry point.
- Do not use [ai/README.md](README.md) as operational authority.

## Instruction Precedence

- Resolve conflicts using this order: system/tool safety rules > explicit user request in the current session > local policy override (if `ai/ai-policy-override.md` exists) > this policy.
- If this policy conflicts with higher-priority safety or tool constraints, follow the higher-priority constraints and explain the limitation.

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

### Immutable Checkpoint Semantics

- A checkpoint ID represents one exact resume state only.
- If any material resume field changes after a checkpoint is recorded, issue a new checkpoint ID instead of editing existing checkpoint semantics.

Material resume fields:
- current status
- last completed action
- immediate pending decision
- first action to continue
- confidence, when it reflects a verification-state change

Consistency rules:
- For each new checkpoint, update `ai/next-steps.md`, today's `ai/daily-checkpoints/YYYY-MM-DD.md`, and `ai/progress.md` together.
- Before declaring state healthy, verify both ID consistency and semantic consistency across matching checkpoint entries.
- If IDs match but resume semantics differ, treat state as inconsistent and repair by issuing a new checkpoint from the latest verified state.

Allowed edits without a new checkpoint ID:
- typo fixes
- formatting-only edits
- non-semantic wording cleanup that does not change meaning

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

1. During bootstrap, treat `ai/` policy and state files as authoritative context.
2. Do not treat GitHub Copilot customization files under `.github/` as bootstrap authority unless explicitly allowed by repository bootstrap instructions.
3. If assistant-specific artifacts are needed for GitHub Copilot, store them under `ai/github-copilot/` (or another repo-declared `ai/` subdirectory), not under `.github/`.
4. Universal policy changes must be made in this central policy source first; local files are fallback or override only.
5. If bootstrap authority is ambiguous, stop and ask before writing any policy or customization file.

## Operational Guardrails

- Use a diff-first workflow for proposed edits.
- Ask for explicit user approval before side-effecting actions.
- Ask before creating, modifying, or deleting files.
- Ask before package installation or dependency changes.
- Ask before Git write actions (commit, branch, merge, push).
- Before running `git add` or `git commit`, or when the user asks to commit work, check the files involved for secrets. If any secrets are found or strongly suspected, stop immediately and alert the user clearly.
- Ask before database schema changes, production data changes, or infrastructure-affecting configuration changes.

## Execution Modes

- `strict` (default): ask first for any write operation.
- `fast-state` (only after explicit user request for checkpoint or workflow maintenance): may update only:
  - `ai/next-steps.md`
  - `ai/progress.md`
  - `ai/daily-checkpoints/YYYY-MM-DD.md`
  - `ai/context.md`
- `fast-state` never allows edits outside `ai/` and never allows external side effects.

## Read-Only Actions Allowed Without Extra Approval

- File and directory inspection (`ls`, `cat`, `find`, `grep`, `tree`, `pwd`, `stat`, `wc`, `du`, `df`).
- Git read-only inspection (`git status`, `git log`, `git diff`, `git show`, `git branch`, `git remote`).
- Process and environment inspection (`ps`, `top`, `jobs`, `env`, `whoami`, `hostname`).
- Tool version checks (`node --version`, `npm list`, `python --version`, `pip list`, `dotnet --version`, `go version`, `which`).
- Network read-only checks (`curl` GET, `ping`, `nslookup`, `dig`).
- If VS Code still shows an Allow button for read-only commands, treat that as runtime behavior, not policy.

## Repository Conventions

- Keep AI workflow and context artifacts under [ai/](.).
- Keep [ai/](.) git-ignored and out of commits.
- Avoid `.github/copilot-instructions.md` for policy or context in this repository.
- Prefer project-defined conventions in [ai/context.md](context.md) when they exist.

## Backend Working Behavior

- Do not assume routes, schemas, tables, queues, topics, jobs, environment variables, or service dependencies exist when they do not.
- Use only letters, digits, hyphens, underscores, and dots when creating file or directory names.
- Do not modify generated files, migration histories, lockfiles, or deployment artifacts unless explicitly requested or required by the task.
- Place temporary helper files only in the workspace `tmp` directory and keep `tmp` git-ignored.
- If `tmp` does not exist, create it, add it to `.gitignore`, and inform the user.

## Backend Engineering Standards

- Preserve the existing framework, application structure, logging pattern, dependency injection pattern, and data-access approach unless the user asks for a change.
- Prefer clear request validation, explicit error handling, and predictable status codes over implicit behavior.
- Keep API contracts stable. Do not introduce breaking response or request changes without calling them out clearly.
- Validate inputs at trust boundaries and sanitize data before persistence, logging, or downstream calls.
- Prefer idempotent operations where retries are likely.
- Keep authentication, authorization, and permission checks explicit.
- Avoid hidden side effects in handlers and service methods.
- Make timeouts, retries, and external service failures visible in code paths that depend on them.
- Treat migrations and data backfills as operationally sensitive work.
- Prefer small, composable services and modules with clear responsibilities.

## Data and API Rules

- Prefer schema-first or contract-aware changes when the project already uses them.
- Keep serialization and deserialization rules explicit.
- Avoid leaking internal fields, secrets, tokens, or stack traces in API responses.
- When adding fields to APIs, prefer additive and backward-compatible changes.
- When changing persistence logic, consider transactions, concurrency, uniqueness, and rollback behavior.
- Keep observability in mind: structured logs, useful error messages, and traceable request flow should not be afterthoughts.

## Testing and Verification

- Verify changes using the smallest reliable checks available: existing tests, targeted tests, linting, type-checking, or a local build.
- Prefer tests that cover behavior at boundaries such as handlers, services, and repositories instead of only internal implementation details.
- When changing APIs, consider request validation, error responses, authorization, and backward compatibility as part of verification.
- If testing was not possible, say so clearly.

## Design Philosophy

- Do not over-engineer solutions; prefer simple, maintainable service boundaries over clever abstractions.
- Solve the user problem at the contract, flow, and data-integrity level before reaching for large architectural changes.

## Communication and Writing

- Express solutions in concise, simple, everyday English. Do not use fancy words.
- Explain backend tradeoffs in terms of correctness, security, maintainability, observability, and operational risk.
- When suggesting shell or CLI commands, provide copy-friendly runnable commands in fenced code blocks, ready to run as written.
- Use technical terms only when needed for correctness.

<!-- AI-ASSISTANT: READ-ONLY END -->
