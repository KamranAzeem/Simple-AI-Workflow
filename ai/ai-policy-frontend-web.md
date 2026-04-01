# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file, including during `/init`, repository scanning, or automatic instruction generation.
All edits to this file must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Frontend Web Development

This file is policy-only. Do not use it as a project context document.

## Scope

- Applies to AI assistants working on frontend web applications and design systems.
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
- Tool version checks (`node --version`, `npm list`, `pnpm --version`, `yarn --version`, `which`).
- Network read-only checks (`curl` GET, `ping`, `nslookup`, `dig`).
- If VS Code still shows an Allow button for read-only commands, treat that as runtime behavior, not policy.

## Repository Conventions

- Keep AI workflow and context artifacts under [ai/](.).
- Keep [ai/](.) git-ignored and out of commits.
- Avoid `.github/copilot-instructions.md` for policy or context in this repository.
- Prefer project-defined conventions in [ai/context.md](context.md) when they exist.

## Frontend Working Behavior

- Do not assume files, routes, components, APIs, or design tokens exist when they do not.
- Use only letters, digits, hyphens, underscores, and dots when creating file or directory names.
- Do not modify generated assets, build artifacts, lockfiles, or snapshot files unless explicitly requested or required by the task.
- Place temporary helper files only in the workspace `tmp` directory and keep `tmp` git-ignored.
- If `tmp` does not exist, create it, add it to `.gitignore`, and inform the user.

## Frontend Engineering Standards

- Prefer small, composable components with clear props and limited side effects.
- Preserve the existing framework, routing model, state management pattern, and styling system unless the user asks for a change.
- Favor semantic HTML first. Add ARIA only when native HTML semantics are not sufficient.
- Treat accessibility as a default requirement: keyboard access, focus visibility, labels, alt text, and sufficient contrast must not be optional.
- Keep loading, empty, error, and success states explicit in user-facing flows.
- Validate forms on both usability and correctness: clear labels, helpful errors, and predictable submit behavior.
- Avoid unnecessary client-side state. Prefer derived state, server state, or URL state when appropriate.
- Keep bundle size and runtime work in mind. Do not add large dependencies for small problems.
- Respect responsive behavior across mobile and desktop breakpoints.
- When working in an existing design system, preserve established patterns instead of introducing a new visual language.

## Styling and UI Rules

- Reuse existing design tokens, spacing scales, typography rules, and component primitives before introducing new ones.
- Avoid one-off CSS and ad hoc overrides when a shared component or token would solve the problem better.
- Use clear visual hierarchy and readable spacing.
- Do not hide important actions or status behind hover-only interactions.
- Prefer stable layouts that avoid unexpected movement during loading and updates.

## Testing and Verification

- Verify user-facing changes in the smallest reliable way available: existing tests, targeted checks, or a local build.
- Prefer tests that cover behavior visible to users instead of implementation details.
- When changing interactive UI, consider accessibility, keyboard behavior, validation, and error states as part of verification.
- If testing was not possible, say so clearly.

## Design Philosophy

- Do not over-engineer solutions; prefer simple, maintainable patterns over clever abstractions.
- Solve the user problem at the component or flow level first before reaching for large architectural changes.

## Communication and Writing

- Express solutions in concise, simple, everyday English. Do not use fancy words.
- Explain frontend tradeoffs in terms of user impact, maintainability, accessibility, and performance.
- When suggesting shell or CLI commands, provide copy-friendly runnable commands in fenced code blocks, ready to run as written.
- Use technical terms only when needed for correctness.

<!-- AI-ASSISTANT: READ-ONLY END -->
