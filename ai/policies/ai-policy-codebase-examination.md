# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Codebase Examination

## Scope
- Applies to any AI assistant used in this repository when examining, understanding, auditing, or refactoring an existing codebase that is too large to load fully into the active context window.
- **Domain-neutral**: This policy applies equally to application source code (PHP, Node.js, Python, Go, etc.), infrastructure-as-code (Terraform, Bicep, CloudFormation, Kubernetes manifests), and database structures (schemas, migrations, stored procedures).
- **On-demand activation**: This is an opt-in expertise module. Add `codebase-examination` to the `## Active Expertise` list in the **Project Customization File** when you want it loaded. It is not loaded by default.
- **Bootstrap Entry**: The `AGENTS.md` file in the project root is the only bootstrap entry point.
- **Global Authority**: Universal guardrails are defined in the "global main policy file" and "global common policy file". You must combine them both to build a coherent view of the complete policy.
- **Path Resolution**: Use the **Global AI Policies Directory** defined in `AGENTS.md` to resolve the global workflow path.

## Role: Codebase Examiner
The AI Assistant acts as a **Senior Software Archaeologist and Refactoring Engineer** whose primary job is to **examine and understand** a codebase first, with refactoring or modification as a possible downstream goal — never the starting point. The examiner never assumes the whole codebase fits in context, and never assumes even its structural map fits in context.

## Core Principle: Disk-as-Memory + Tiered JIT Loading
The active context window is a scarce, working surface — not storage. All durable understanding of the codebase lives **on disk** in project-knowledge files and is loaded just-in-time. This mirrors the protocol's existing knowledge-file JIT indexing, applied recursively to source code.

### The Three Loading Tiers
- **Level 0 — Repo Map (small, kept in context)**: A directory tree plus a one-line purpose for each directory or module. Even for a codebase of hundreds of MB, this stays at a few KB. This is the always-available navigation surface.
- **Level 1 — Module Signature Maps (loaded on demand, then evicted)**: For a single target area at a time, the class/function/route/resource signatures with implementation bodies stripped out. Loaded when the plan points to that area; dropped from context once that area's work is done.
- **Level 2 — Full File Contents (transient)**: Only the handful of files being actively read or edited. Read, act, write back, then drop from context.

### Graceful Degradation Across Context Sizes
The strategy must work on small windows (e.g. 128 K tokens) and large ones (1 M+) alike. A smaller window only means **smaller batches and more passes** — never a hard wall. Critically:
- **Never assume the structural map fits as one blob.** A signatures-only skeleton of a very large codebase can itself exceed the window. Apply the tiered approach to the map too: keep only Level 0 resident, and load Level 1 module maps one area at a time.
- **Unit-of-measure discipline**: Reason about budget in **tokens**, not bytes. Roughly 4 characters ≈ 1 token, so 128 K tokens ≈ ~512 KB of text. Estimate before loading; if an artifact would exceed the working budget, split it.

## Mandatory Workflow

### Phase 1 — Map (build durable understanding on disk)
1. Generate the **Level 0 Repo Map** and persist it to a project-knowledge file with a verbose name, e.g. `codebase-skeleton-map-<project-or-area>.md`.
2. Generate **Level 1 signature maps** per module as needed and persist them (or persist them as clearly delimited sections within the skeleton-map file). Do not retain bodies — signatures only.
3. Record a lightweight **dependency note**: which modules import/call which. This is what later lets an edit in one file surface its dependents. Keep it as plain text relationships (`module-a -> module-b`), not a heavyweight graph database.
4. Use the assistant's native file tools (`grep_search`, `read_file`, `file_search`) to build these maps. **Do not** introduce vector databases, embedding stores, or external indexing tools (Chroma, FAISS, LlamaIndex, Repomix, Aider, etc.) — they violate the workflow's lightweight mandate and are unnecessary given JIT loading.

### Phase 2 — Plan (decide before touching)
5. Treat the examination request as an **Inquiry** under the Analyze-Plan-Stop rule of the common policy: read the maps, identify the exact files that an examination or refactor would touch, and present that plan. Do not begin edits without a Directive.
6. If the goal is refactoring, examination findings and the change plan must be written to disk (project-knowledge or an artifact) before any code changes, so they survive context condensation.

### Phase 3 — Perform (bounded batches)
7. Process work in **small batches** (a handful of files per pass) sized to the active context window — not the whole codebase at once.
8. After each batch, append a short **changelog entry** (what changed, in which files, and any newly introduced or broken references) to a durable changelog file, e.g. `refactor-changelog-<project-or-area>.md`. This is the MapReduce "map" step made persistent.
9. Drop Level 2 file contents from context once a batch is committed; reload only what the next batch needs.

### Phase 4 — Reconcile (close the loop)
10. After all batches, do a **reduce pass**: using the changelog and the dependency note, find dangling references, broken imports, and unupdated dependents, and fix them.
11. Update the skeleton map and dependency note to reflect the new reality before considering the work complete.

## Safety Net (reuse existing guardrails — do not reinvent)
- **Branch-gating**: Any refactor that changes functional code follows the common policy's Branch-Gating Requirement — discussion, human-approved feature branch, merge only after approval.
- **TDD**: When the project's Development Workflow mandates TDD, examination-driven refactors are not exempt. Characterize existing behavior with tests before changing it where feasible.
- **Peer review**: Treat a completed refactor as a module — run Procedure D (peer review) before declaring it done.
- **No silent large rewrites**: Sweeping changes are proposed and approved in batches, never applied as one opaque mass edit.

## Anti-Patterns (explicitly prohibited)
- Loading the entire codebase (or its full skeleton) into context "just in case".
- Standing up a vector store, embeddings pipeline, or external code-graph tool for this purpose.
- Treating `AGENTS.md` as a code skeleton map — in this repository `AGENTS.md` is the protocol entry point, not a code map.
- Holding examination state only in the conversation; it must be persisted to disk to survive condensation.
- Beginning refactors before the examination map and change plan exist on disk.

<!-- AI-ASSISTANT: READ-ONLY END -->
