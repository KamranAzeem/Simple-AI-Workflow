# Codebase Examination Guide

How the Simple-AI-Workflow lets an AI assistant examine — and optionally refactor — a codebase that is **larger than its context window**, without heavyweight tooling.

This guide explains the `codebase-examination` expertise module (`ai/policies/ai-policy-codebase-examination.md`). For the design rationale and the evaluation that produced it, see `ai/artifacts/large-codebase-examination-strategy-evaluation.md`.

---

## 1. The Problem

A real application can be tens or hundreds of megabytes across thousands of files. Even with a large context window (128 K, 200 K, or 1 M tokens), you cannot paste the whole thing into a prompt. Trying to do so causes:

- High latency and high API cost.
- Degraded reasoning ("needle in a haystack" — the model loses the relevant detail in a sea of irrelevant code).
- Hard failures when the content simply exceeds the window.

This is not unique to web apps. The same constraint applies to **infrastructure-as-code** (Terraform, Bicep, Kubernetes manifests) and **database structures** (schemas, migrations, stored procedures).

### Bytes are not tokens

A common confusion: "my skeleton map is only 150 KB, so it fits in 128 K tokens." It does — but not for the reason people assume. Roughly **4 characters ≈ 1 token**, so:

- 128 K tokens ≈ ~512 KB of text
- 150 KB of text ≈ ~38 K tokens

So a 150 KB map fits comfortably even in a 128 K window. But for a genuinely large codebase, even a signatures-only skeleton can exceed the window — so the strategy must never assume the map fits as a single blob. Always reason in **tokens**, and estimate before loading.

---

## 2. The Core Idea: Disk-as-Memory + Tiered JIT Loading

The context window is a **working surface**, not storage. Durable understanding lives on disk in project-knowledge files and is loaded just-in-time — the same pattern the protocol already uses for knowledge-file indexing, applied recursively to source code.

### Three loading tiers

- **Level 0 — Repo Map** (small, kept in context)
  - A directory tree plus a one-line purpose for each directory or module.
  - A few KB even for a codebase of hundreds of MB. This is the always-available navigation surface.

- **Level 1 — Module Signature Maps** (loaded on demand, then evicted)
  - For one target area at a time: class, function, route, or resource signatures with implementation bodies stripped out.
  - Loaded when the plan points to that area; dropped once that area's work is done.

- **Level 2 — Full File Contents** (transient)
  - Only the handful of files being actively read or edited. Read, act, write back, then drop from context.

### Graceful degradation across window sizes

A smaller window only means **smaller batches and more passes** — never a hard wall. Critically, the tiering applies to the map itself: if the full skeleton is too big, keep only Level 0 resident and load Level 1 module maps one area at a time. Window size changes *how many files per batch*, not *whether the approach works*.

---

## 3. The Four-Phase Workflow

### Phase 1 — Map (build durable understanding on disk)
1. Generate the Level 0 repo map and persist it with a verbose name, e.g. `codebase-skeleton-map-<project-or-area>.md`.
2. Generate Level 1 signature maps per module as needed; persist them (or as clearly delimited sections in the skeleton-map file). Signatures only — no bodies.
3. Record a lightweight **dependency note** in plain text (`module-a -> module-b`) — this is what later lets an edit in one file surface its dependents.
4. Build these maps with the assistant's native file tools (`grep_search`, `read_file`, `file_search`).

### Phase 2 — Plan (decide before touching)
5. Analyse first: read the maps, identify the exact files an examination or refactor would touch, and present that list. Wait for your go-ahead before editing anything.
6. If refactoring is the goal, write findings and the change plan to disk before any code change — so they survive context compaction.

### Phase 3 — Perform (bounded batches)
7. Process work in small batches (a handful of files per pass) sized to the active window — not the whole codebase at once.
8. After each batch, append a short entry to a durable changelog, e.g. `refactor-changelog-<project-or-area>.md` (what changed, in which files, any new or broken references).
9. Drop Level 2 file contents from context once a batch is committed; reload only what the next batch needs.

### Phase 4 — Reconcile (close the loop)
10. Do a reduce pass: using the changelog and the dependency note, find dangling references, broken imports, and unupdated dependents, and fix them.
11. Update the skeleton map and dependency note to reflect the new reality before declaring the work complete.

---

## 4. What This Deliberately Avoids

This workflow stays lightweight. It does **not** introduce:

- Vector databases or embeddings (Chroma, FAISS).
- External code-graph or indexing tools (LlamaIndex, CodeGraph, Repomix, Aider).
- A separate "planner model" vs "performer model" orchestration — in a single IDE assistant these are just two phases of one agent.

The assistant already has `grep_search`, `read_file`, and `file_search`, plus the protocol's JIT indexing. That is enough.

> Note: in this repository, `AGENTS.md` is the protocol entry point — **not** a code skeleton map. Do not confuse the two.

---

## 5. Safety Net (reused, not reinvented)

Large refactors are risky, so this module leans on guardrails the workflow already defines:

- **Branch-gating** — functional changes happen on a human-approved feature branch, merged only after approval (`ai-policy-common.md`).
- **TDD** — when the project's Development Workflow mandates it, characterize existing behavior with tests before changing it.
- **Peer review** — treat a completed refactor as a module and run a peer review (say `"peer review"`) before declaring it done.
- **No silent mass edits** — sweeping changes are proposed and approved in batches.

---

## 6. How to Activate

Say `"codebase examination"` or `"examine this codebase"` in your AI chat. The policy is loaded on demand (see Procedure G in `AGENTS.md`) — it is not loaded or indexed at boot time, just like the peer review mode.

---

## 7. Worked Example (PHP: mysqli → PDO)

1. **Map** — Build the repo map; persist `codebase-skeleton-map-legacy-shop.md`. Generate Level 1 signatures for the data-access modules only.
2. **Plan** — From the map, identify the 18 files that issue `mysqli_*` calls. Write the migration plan to disk. Pause for approval.
3. **Perform** — Migrate in batches of ~5 files. After each batch, append to `refactor-changelog-legacy-shop.md`. Commit per batch on the feature branch.
4. **Reconcile** — Use the changelog + dependency note to catch callers that passed a `mysqli` connection handle into a shared helper; update them. Update the skeleton map.
5. **Review** — Run peer review; merge after APPROVED.

At no point is the whole application in context — only the repo map plus the current batch.
