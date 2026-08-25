# Multi-Assistant Workflow + Build AI Team — Design & Requirements

Status: pending

This note combines two related ideas. (1) The **multi-assistant coordination contract**: how several assistants work the same project via `AGENTS.md` + coordination primitives. Extracted from the `feature/multi-assistant-workflow` branch (commit `1a0ef61`). (2) The **build-AI-team runtime**: a dispatcher/watcher that spawns and manages AI roles, drawn from `ai/shared/project-knowledge/multi-agent-state-ownership-and-checkpoint-model.md` §3, §4, §7. The AI-team runtime sits on top of the protocol contract; see the reconciliation notes before resuming.

---

## Overview
**Purpose**: enable multiple AI assistants (different models, different runtimes) to safely collaborate on the same project or sibling repositories under a parent directory, while keeping the user experience extremely simple.

### Goals
- Allow multiple assistants (VS Code Chat-integrated agents and CLI agents) to perform tasks concurrently without corrupting files.
- Present a single, consistent guidance surface to the user via `AGENTS.md` + `ai/` tracking files.
- Keep complexity hidden from users; the workflow must feel like "one assistant" even if multiple agents operate.

### UX Principles
- Minimal configuration for users: one `AGENTS.md` (or `AGENTS.local.md`) per project and optional per-repo `ai/agent-config.md` for advanced settings.
- Dry-run first: any multi-target action must offer a preview (`--dry-run` / `-WhatIf`) and per-target summary.
- Human-in-the-loop for side effects: pushes, merges, destructive changes require explicit approval.

## High-level approach
- Single source of truth: `AGENTS.md` describes which policy to use and where AI tracking lives.
- Coordination primitives (small, explicit):
  - `ai/agent-config.md` (optional): per-repo assistant preferences (role hints, allowed assistants, preferred assistant order).
  - `.ai-lock` (lightweight lock): optional advisory lock file updated by assistants to indicate exclusive work on a path/repo. Advisory and ephemeral.
  - `ai/tasks/` (work queue): simple markdown tasks that assistants can claim by adding a `claimed-by` field and timestamp; human-visible and easy to audit.
  - Checkpoints and audit: `ai/progress.md`, `ai/next-steps.md` used for cross-assistant coordination and auditable history.

## Roles and responsibilities
- **Repository Steward (policy)**: single guidance and gatekeeper rules (already `ai/ai-policy-meta.md`).
- **Lead assistant (optional)**: one assistant acts as the coordinator for a multi-step flow (may be the VS Code assistant); it orchestrates which other assistants take which tasks.
- **Worker assistants**: perform isolated tasks (e.g., run analysis, draft PR text, refactor a small module). They must follow the Repository Steward policy.

## Conflict prevention and safety
- Use advisory locks: before making multi-file edits across repos, a worker should request a lock (create `.ai-lock` entry) and release it after staging changes.
- Per-target dry-run and diff-first workflow: always present diffs; do not auto-apply without explicit human approval.
- Staging branches per-assistant or per-task: assistants stage changes in a named feature branch (`feature/ai/<task-id>-<assistant>`) to avoid step-on commits.
- File ownership metadata: optional YAML frontmatter the assistant can write into files it manages (e.g., `# managed-by: repo-steward`) to reduce accidental edits by other agents.

## Coordination patterns (simple, robust)
- **Leader/Orchestrator**: the VS Code assistant (or a configured leader) assigns tasks and records assignments into `ai/tasks/`.
- **Independent workers**: CLI agents pick unclaimed tasks from `ai/tasks/`, run dry-run, and post results back to `ai/tasks/` or a per-task draft file.
- **Merge flow**: human reviews staged branches and merges; assistants prepare PRs but do not push without permission.

## Data & Security
- Secrets: never store secrets in `ai/` or commit them. Assistants must run secret scans before staging commits.
- Logs and audit: every assistant action that changes files must append a short entry to `ai/progress.md` or create a task-level audit file under `ai/tasks/`.

## Implementation plan (MVP)
1. Define `ai/agent-config.example.md` and `ai/tasks/README.md` describing minimal fields.
2. Implement simple task queue: `ai/tasks/*.md` where each task includes ID, description, claimed-by, status, result-path.
3. Advisory lock helper: small script `scripts/ai-lock.sh` and PowerShell parity to create/release locks and check status.
4. Update `scripts/sync-agents-md.*` to respect `ai/agent-config.md` and to write per-target dry-run reports into `ai/tasks/` when operating across multiple repos.
5. Document coordinator patterns in `docs/multi-assistant-workflow.md` (this file).

## Iteration 2 (optional)
- Add lightweight coordinator service (local CLI that sequences claims/releases) — only if users need higher concurrency guarantees.
- Add tests and simulated multi-agent runs in a sandbox directory.

## Acceptance criteria
- Users can run two different assistants (VS Code + CLI) against the same parent directory using the AGENTS.md protocol and:
  - See per-task dry-run outputs for each target.
  - See no file corruption in git history (all edits go to staged branches).
  - Human review is required before any push/merge.
- Minimal configuration: user adds `AGENTS.local.md` and optionally `ai/agent-config.md` per repo.

## Risks and mitigations
- Race conditions on locks: keep locks advisory; prefer branch-based isolation for writes.
- User confusion: present clear human-readable per-task reports and require one-button approval for pushes.
- Complexity creep: keep MVP simple — avoid centralized services unless necessary.

## Next steps (short)
- Create `ai/agent-config.example.md` and `ai/tasks/README.md`.
- Implement `scripts/ai-lock.sh` and `scripts/ai-lock.ps1`.
- Wire `scripts/sync-agents-md.*` to emit per-target reports into `ai/tasks/` when run across multiple repos.

## Build AI team (AI-team runtime)

The multi-assistant workflow above defines the **coordination contract** (who owns what, task/work-queue conventions, advisory locks, dry-run discipline, staged branches). The **AI-team runtime** is the management layer that turns this into a live "team."

### Protocol vs runtime boundary (the scope guard)
- **Protocol (this repo)** defines the contract: file ownership, single-writer state rule, awareness-via-board, message formats (board/handoff), checkpoint-reconcile semantics.
- **Runtime (a separate project — the user's "AI team on another machine")** is the dispatcher/watcher/process lifecycle: spawning roles, queueing, crash recovery, preventing double-dispatch, locking in-progress handoffs.
- The runtime must NOT be built into `AGENTS.md`. The contract lives here; the runtime is built on top of it elsewhere.

### Execution models for role agents (developer, marketing, security, doc-controller)
- **Always-on persistent processes** — continuously running team-mates.
- **Watch-spawned (preferred)** — a watcher monitors `ai/shared/handoffs/`; on a new handoff it spawns the right role, hands it the task, the role completes, records its result on the board / handoff / role-knowledge, and sleeps.
- Key insight: watch-spawned decouples **identity** (persistent role that accumulates role-knowledge) from **execution** (ephemeral, runs only per task), so the single-writer ownership rule stays uniform across both models. "Always-on vs watch-spawned" becomes a deployment choice, not a protocol concern.

### True parallelism (Scenario B)
The coordination board is read-before-write, not a lock, so concurrent sessions writing the *same* state files can lose updates (Scenario B, CP-2026-06-30-02). The safe path for real parallelism is **one status file per agent/task** under `ai/shared/coordination/<agent-or-task>.md`, with the orchestrator reading the directory and reconciling. Revisit trigger: adopt this the moment more than one agent/session may write the three state files at the same time. Until then the single-orchestrator model stands and concurrent sessions are only safe when serialized in time.

## References
- `AGENTS.md`, `ai/ai-policy-meta.md`, `ai/shared/project-knowledge/multi-agent-state-ownership-and-checkpoint-model.md`, `scripts/` helpers, `ai/progress.md` checkpoint contract.

---

## Reconciliation notes (2026-08-25)
- This draft predates the current state-file layout. It references `ai/progress.md`, `ai/next-steps.md`, and `ai/tasks/`; the current protocol uses `ai/state/` (progress/next-steps/context) and the single-writer ownership model.
- The current protocol already has a distinct multi-agent approach: single-writer state ownership, an inbound-reconcile step at checkpoint, `ai/shared/coordination.md` as the coordination board, and role-scoped project-knowledge files. Reconcile this draft with that model before resuming, to avoid two competing designs.
- The proposed files (`ai/agent-config.md`, `ai/tasks/`, `.ai-lock`, `scripts/ai-lock.sh`/`.ps1`) are not part of the current protocol. Treat them as candidate additions for a future multi-assistant iteration.
- Two deferred items already tracked belong here: the **AI-team runtime** (dispatcher/watcher/role lifecycle, separate project) and the **per-agent status files** for real parallelism (Scenario B). Both are in `next-steps.md` deferred and the design note above.
