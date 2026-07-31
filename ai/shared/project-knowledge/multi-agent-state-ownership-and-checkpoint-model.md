# Multi-Agent State Ownership & Checkpoint Model

**Date**: 2026-06-30 — Session CP-2026-06-30-02 (branch `feature/boot-full-load-policies-and-global-knowledge`)
**Status**: Contract decided and partially implemented in the protocol today. Runtime (AI-team dispatcher) and Procedure E precedence rework explicitly deferred.

This note captures a design discussion about context freshness/integrity, checkpoint direction, and multi-agent state ownership, and records what was implemented versus deferred.

---

## 1. Problem space

Four intertwined questions were examined:

1. **Context freshness / integrity** — when is the AI's in-memory view authoritative, and when is the on-disk copy?
2. **Checkpoint direction** — does a checkpoint read state into memory, or write memory into state?
3. **Ownership** — who is allowed to write the three state files (`context.md`, `progress.md`, `next-steps.md`)?
4. **Multi-agent state** — how do multiple agents/roles share state without corrupting it?

## 2. Decisions

### 2.1 Checkpoint direction is memory → disk
The AI's active in-memory context is the freshest source of truth for what was accomplished in a session. A checkpoint **serialises that fresh state INTO** the three files. It is a write-down, not a re-read to discover what is current. The on-disk files are the stale targets being updated.

### 2.2 The pre-write read is a reconcile, not a memory refresh
"Read before write" is retained but reframed. Its only purposes are:
- **(a) Preserve append-only history**: `progress.md` is an append/archive ledger (Procedure C Step 2). A blind memory-driven write could drop existing lines; the read prevents that.
- **(b) Detect drift**: another agent, or context compaction, may have changed the files since the AI last saw them.

**Precedence**: fresh in-memory deltas are authoritative for new/changed content; the disk read must never overwrite fresh work with a stale cached/summarised copy. Genuine same-item conflicts → stop and flag, do not silently pick one.

The earlier "Fresh-Read Before Write" wording (CP-2026-06-29-01) read like "distrust your memory and re-read", which is wrong for the normal case and dangerous for weak models (they may parrot disk and drop their own deltas). The reframe fixes that.

### 2.3 State files are single-writer (orchestrator-owned)
The three state files are the **canonical project narrative**, written **only** by the project-root orchestrator (the AI session that owns the project root). This eliminates the multi-writer contention that motivated read-before-write in the first place.

### 2.4 Awareness vs. authorship — the key separation
The hard part ("long-running team-mates need to know what others are doing, so they must write the state files") dissolves once you separate two concerns:
- **Awareness** ("who is doing what right now") = **read** the coordination board.
- **Canonical narrative** = **single writer** (orchestrator).

A role needing awareness does not need to *write* the canonical files. It writes its status to the board; it reads the board to see others. Conflating awareness with write-authority was the trap.

### 2.5 Surfaces and their writers

| Surface | Writer | Readers | Purpose |
|---|---|---|---|
| `progress.md` / `next-steps.md` / `context.md` | Orchestrator only | all | Canonical project narrative |
| Coordination board (`ai/shared/coordination.md`) | whoever claims/releases a task (small own-row write) | all | Live "who's doing what" — awareness channel |
| Handoffs (`ai/shared/handoffs/`) | task author / assignee | dispatcher, assignee | Task in / result out |
| Role-scoped knowledge (`…/project-knowledge/role-*.md`) | that role only | all | Each role's durable memory across sleeps |

### 2.6 Checkpoint is two-phase
1. **Inbound reconcile** — read the coordination board + new/changed handoffs (+ refresh Project Knowledge index) → fold other agents' work into orchestrator memory.
2. **Outbound write** — write fresh orchestrator memory → the three state files (memory → disk, single writer).

The "read" in phase 1 is of the board (purpose-built multi-writer surface), not the state files.

## 3. The AI-team / role model (deferred runtime)

Two execution models were discussed for role-based agents (developer, marketing, security, doc-controller):
- **Always-on persistent processes** — continuously running team-mates.
- **Watch-spawned (preferred)** — a watcher monitors `ai/shared/handoffs/`; on a new handoff it spawns the right role, hands it the task, the role completes, records its result on the board/handoff/role-knowledge, and sleeps.

**Key insight**: the watch-spawned model decouples **identity** (persistent role, accumulates role-knowledge) from **execution** (ephemeral, only runs per task). From a concurrency standpoint a watch-spawned role behaves like an ephemeral worker, which makes the single-writer ownership rule uniform across both models.

**Design principle**: define the **contract** so it is invariant to the execution model. Then "always-on vs watch-spawned" is a deployment choice, not a protocol concern.

## 4. Protocol vs. runtime boundary (scope guard)

- **The protocol (this repo)** defines the **contract**: file ownership, single-writer rule, awareness-via-board, message formats (board/handoff), checkpoint reconcile semantics.
- **The runtime (separate project — the user's "AI team on another machine")** is the **dispatcher/watcher/process lifecycle**: spawning roles, queueing, crash recovery, preventing double-dispatch, locking in-progress handoffs.

The runtime must NOT be built into AGENTS.md. The contract lives here; the runtime is built on top of it elsewhere.

## 5. Concurrency caveats (do not treat as solved)

- The coordination board is still multi-writer. "Read immediately before writing" reduces but does not eliminate races. This is **cooperative coordination, not a lock manager**.
- Mitigations: append-only / one-owned-row-per-task entries with `agent-id + timestamp`; keep writes tiny.
- **Robust variant for real parallelism**: one status file per agent/task in a directory (e.g. `ai/shared/coordination/<agent-or-task>.md`) — no shared-file write contention; the orchestrator reads the directory and reconciles. Adopt only if genuine parallelism is expected.
- Role-scoped knowledge: two agents creating the same filename collide — verbose naming + `agent-id`/task prefix mitigates.

## 6. Implemented today (this branch, non-breaking)

- **AGENTS.md TIER 2**: new mandatory action **"State File Single-Writer Ownership"**.
- **AGENTS.md Procedure C Step 1**: added **Write Direction (memory → disk)**; reframed **Fresh-Read Before Write** as a reconcile with explicit precedence; added **Inbound Reconcile (multi-agent)** sub-step (read board + handoffs before writing state).
- **AGENTS.md Procedure E Step 3**: added a coordination-board read on resume (board is not a state file; state files remain off-limits in E).
- **ai/shared/coordination.md**: added an **Ownership Model** section; fixed the keystone "Clear" step (was "update `ai/progress.md`" → now "record completion on the board; do NOT write state files"); added the concurrency caveat.
- **ai/policies/ai-policy-common.md**: new **State File Ownership Protocol** subsection (single-writer, awareness-vs-authorship, reporting channel, checkpoint direction).
- **support-files/validate-protocol.sh**: v4.3 → v4.4; new `Single-Writer` anchor check; fixed a stale error string.
- **README.md**: Multi-Agent Coordination feature augmented with the single-writer state-ownership bullet.

## 7. Deferred (NOT implemented today)

- **Procedure E precedence rework**: letting Procedure E read the *latest checkpoint's* state files (single-writer authoritative, fresher than a lossy summary) instead of trusting only the summary. This reverses a deliberate safety rule and is a breaking change — defer and design carefully as one coherent change.
- **AI-team runtime**: dispatcher/watcher, role startup, process lifecycle. Separate project.
- **Per-agent status files** (robust concurrency variant) — the safe path for **Scenario B** (multiple agents/sessions writing concurrently). **Revisit trigger**: adopt this the moment more than one agent/session may write the three state files *at the same time* (one file per agent under `ai/shared/coordination/`, orchestrator reconciles — no shared-file write contention). Until then the single-orchestrator model stands, and concurrent sessions are only safe if their writes are **serialized in time**. Sequential role-switching inside one session (**Scenario A**) is unaffected and always safe — it is one writer wearing different hats.
- **TLD.md / LLD.md** scope/size-control documents (user-raised, future).

## 8. Open decisions for the user

1. Board write discipline: single shared board (append/own-row) vs per-agent status files.
2. Procedure E: keep summary-only on resume, or rework to prefer latest checkpoint state + board.
3. When (if ever) to start the AI-team runtime as its own scoped project.
