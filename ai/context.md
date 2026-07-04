# Project Context

## Latest Checkpoint: CP-2026-07-04-01
- **Current Branch**: `feature/protocol-improvements` (off master) — NOT merged, NOT pushed
- **Last Summarized Hash**: 66e22c7 (master HEAD at branch creation)

## What Has Been Done (this session on feature/protocol-improvements)
- Renamed `**Project Policies Directory**` to `**Project AI Policies Directory**`
- Renamed `**Project Knowledge Directory**` to `**Project AI Knowledge Directory**`
- Added all project-scoped TIER 1 config directives (14 directories + Project AI State Files)
- Added Canonical Names & Short Forms section to TIER 1
- Replaced all hardcoded paths in AGENTS.md, policies, and validator with bold anchor references
- Moved **Global User AI Directory** below the human-do-not-modify line
- Added custom policy auto-discovery via recursive scan of **Project AI Policies Directory**
- Added Git Workspace Detection rule to TIER 2
- Added Current Status section to context.md and expanded Procedure C Step 1.3
- Extended horizon shield to cover context.md checkpoint entries
- What's left: peer review of the context.md/Procedure C changes, then merge to master

## Current Status
- **Active branch**: `feature/protocol-improvements`
- **Current milestone**: Consolidate protocol improvements from this session into a merge-ready state
- **Next actions**: Complete peer review, merge to master when approved
- **Open questions**: None

## Checkpoint History

## Latest Checkpoint: CP-2026-06-30-03
- **Current Branch**: `master` — feature branch `feature/boot-full-load-policies-and-global-knowledge` squash-merged into master and deleted. NOT pushed to origin (user handles push).
- **Last Summarized Hash**: (set at next master sync)

## Session Summary (2026-06-30, third checkpoint — finalize/merge)
- **Merged**: the full boot-full-load + single-writer-ownership + checkpoint-reconcile + doc-alignment work squash-merged to master as one commit; feature branch deleted; not pushed.
- **Single-writer clarified (session, not role)**: AGENTS.md TIER 2 and ai-policy-common.md now state state-file ownership is by session/process identity — one session switching role-hats (manager → developer → document-controller) is still the orchestrator and writes the state files normally; the prohibition targets separate sub-agent sessions/processes.
- **Scenario B deferred with a trigger**: concurrent sessions writing the *same* state files is not race-safe under the cooperative board; the per-agent-status-file model is the recorded revisit-when-parallel path (design note §7, next-steps).
- **Validation/review**: validate-protocol.sh green at v4.4; peer review review-04 APPROVED (final merge-readiness).

## Latest Checkpoint: CP-2026-06-30-02
- **Current Branch**: `feature/boot-full-load-policies-and-global-knowledge` (off master) — committed on branch, NOT merged to master (awaiting human review/merge/push)
- **Last Summarized Hash**: (set at next master sync)

## Session Summary (2026-06-30, second checkpoint)
- **Multi-agent state ownership + checkpoint direction (repo-level contract)**: The three state files (`context.md`/`progress.md`/`next-steps.md`) are now formally **single-writer** — written only by the project-root orchestrator. Sub-agents and role-based team members never write them; they report via the coordination board (the awareness channel), handoffs, and role-scoped Project Knowledge. The orchestrator **reconciles** those into the state files at checkpoint.
- **Checkpoint direction is memory → disk**: a checkpoint serialises the orchestrator's fresh in-memory context into the state files. The pre-write "Fresh-Read Before Write" is reframed as a **reconcile** (preserve append-only history + detect drift), not a memory refresh; fresh in-memory deltas win; same-item conflicts stop and flag.
- **Scope discipline**: implemented the protocol *contract* only. The AI-team *runtime* (dispatcher/watcher/role lifecycle, per-agent status files) and the Procedure E precedence rework (resume reading latest-checkpoint state) are deliberately **deferred** (the latter would be breaking).
- **Files**: AGENTS.md (TIER 2 single-writer MANDATORY ACTION; Procedure C Step 1 Write Direction + reconcile + Inbound Reconcile; Procedure E Step 3 board read); coordination.md (Ownership Model + Clear keystone fix + concurrency caveat); ai-policy-common.md (State File Ownership Protocol subsection); validate-protocol.sh v4.3→v4.4 (Single-Writer anchor + stale-string fix); README feature #7 bullet; new design note multi-agent-state-ownership-and-checkpoint-model.md; protocol-decisions.md CP-2026-06-30-02 entry.
- **Validation**: validate-protocol.sh all 8 checks pass at v4.4. **Peer review**: review-03 APPROVED (1 Minor doc-consistency follow-up flagged, out of today's protocol scope).

## Latest Checkpoint: CP-2026-06-30-01
- **Current Branch**: `feature/boot-full-load-policies-and-global-knowledge` (off master) — committed on branch, NOT merged to master (awaiting human review/merge/push)
- **Last Summarized Hash**: (set at next master sync)

## Session Summary (2026-06-30)
- **Context-loading model change (repo-level)**: Token Rationing is now scoped to **Project Knowledge only**. At boot (Procedure A) and on post-condensation recovery (Procedure E), the AI **full-loads** Settings, all Global Knowledge, the common policy, and every active policy referenced in the customization file. Project Knowledge remains shell-indexed at boot and loaded on demand.
- **Reverses** the Global-Knowledge JIT portion of CP-2026-06-18-03 (which had extended index-only loading to Global Knowledge and policies). Project Knowledge index-only behaviour from that session is kept.
- **Files**: AGENTS.md (Procedure A Step 5 Knowledge Loading + Step 6 Policy Loading with design note + Step 4/7b wording + TIER 2 Session Resume + Procedure C condition-gated Step 4 + Procedure E Step 3/5); ai-policy-common.md (Global Knowledge Full Load + Procedure C Step 2→3 fixes); validate-protocol.sh v4.3 (Knowledge Loading + Policy Loading anchors, Token Rationing anchor retained); README/workflow-guide/slides docs; protocol-decisions.md 2026-06-30 entry.
- **Validation**: validate-protocol.sh all 8 checks pass at v4.3.
- **Peer review**: round-01 CHANGES REQUESTED (1 Major: AGENTS.md Step 4 stale "indexed in Step 5") → fixed → round-02 APPROVED.

## Latest Checkpoint: CP-2026-06-29-01
- **Branch (at that time)**: master (HEAD: 9a873bd)

## Session Summary (2026-06-29)
- **State File Proof-of-Read**: Added three protocol guardrails to AGENTS.md — (1) sub-bullet in Procedure A Step 4 requiring fresh read with CP identifier + line count as proof marker and consistency check across state files and latest checkpoint; (2) bullet (f) in Step 7 Proof-of-Load; (3) Fresh-Read Before Write sub-bullet in Procedure C Step 1 preventing writes from cached/summarised context window state.
- **Motivation**: Concrete bug from another session where AI reported progress.md last entry as 23 June when 24th and 25th entries existed — AI admitted it "scanned too quickly."
- **Peer review**: round-01 CHANGES REQUESTED (2 Minor: CP date ambiguity in Step 4/7, "context" wording clash with context.md filename) → fixes applied → round-02 APPROVED.
- **Pending commit**: AGENTS.md + ai/code-review-reports/2026-06-29_review-01.md + ai/code-review-reports/2026-06-29_review-02.md
- **Codebase Examination → triggered procedure**: Changed from "opt-in Active Expertise" to "Procedure G trigger" (same pattern as code-review). Updated policy, README, docs/guide, docs/customization-guide, slides. AGENTS.md Procedure G added.
- **AI tracking cleanup**: Moved useful notes to project-knowledge and docs; tracked pre-existing project knowledge files; deleted stale checkpoints, code review reports, and processed notes.
- **Verbose file-naming rule (binding)**: Added to ai-policy-common.md — AI-generated knowledge/docs/workflow files use descriptive kebab-case (filename = JIT lookup key); application/source code explicitly exempt (follows language/framework idioms). README section updated with the carve-out.
- **Codebase Examination expertise (on-demand)**: New ai-policy-codebase-examination.md (keyword `codebase-examination`) + docs/codebase-examination-guide.md. Domain-neutral; Disk-as-Memory + three-tier JIT loading; four-phase Map/Plan/Perform/Reconcile; lightweight (no vector DBs/external tools); reuses branch-gating/TDD/peer-review.
- **Docs/tooling**: README Key Features #15/#16 + Docs-list de-dup; slides More Features bullets; ai-customization-guide.md expertise table; validate-protocol.sh policy baseline 11 -> 12 (all checks pass).
- **Peer review**: review-01 CHANGES REQUESTED -> fixes -> review-02 APPROVED. Squash-merged to master (9ea1df8).

## Session Summary (2026-06-18)
- **Docs sync**: Updated README, slides, and workflow-guide to reflect Token Rationing, Atomic Write Protocol, and Log Condensation Shield features introduced in the previous squash commit.
- **Policy cleanup**: Fixed corrupted duplicate content in ai-policy-meta; added missing immutability header to ai-policy-code-review; added missing READ-ONLY END tags to 5 policy files; normalized Scope wording in ai-policy-dba and ai-policy-observability.
- **Metadata header removal**: Stripped AI-generated Created-by/Updated-by/Last modified/Intent comment blocks from all 28 markdown files; fixed resulting orphaned leading --- on 25 files.
- **validate-protocol.sh**: Updated to v4.0 (8 anchor checks, 10 config key checks). All checks pass.
- **Branch**: feature/docs-sync-context-shielding-2026-06 squash-merged to master (commit c796089) and pushed to origin.
- **Context rot / load context docs**: Added "Keeping Context Healthy" section to README and slides. Committed to master (5255f33).
- **Built-in Tools First policy rule**: Added to ai-policy-common.md Universal Operational Guardrails. Committed to master (c0f53c0). Code review: APPROVED (review-02).
- **Verbose filename section**: Added to README (50d22f3) and slides (ef6126b) — explains JIT indexing lookup key behaviour; committed to master.
- **Lean protocol / JIT loading (feature branch)**:
  - Feature branch: `feature/lean-protocol-jit-loading-2026-06` (6 commits, HEAD 748e25f)
  - Fixed 8 AGENTS.md issues: Global Knowledge now explicitly JIT-indexed in Step 5 (renamed to "Knowledge Indexing"); Step 4 loads Settings only; Proof-of-Load items (b) and (e) corrected; Procedure E Step 3 changed from "Load all" to "Index all"; Session Resume bullet clarified; stale about-human/tools-preferences Appendix refs removed.
  - Fixed 2 ai-policy-common.md contradictions: Global Knowledge Protocol split into Settings (full load) vs Knowledge (index only); Project Knowledge Protocol changed from "must read every file" to "must index files".
  - Fixed 3 workflow-guide.md issues: Global Knowledge loading description, Session Resume Step 3, Section 13 now lists all three JIT sources.
  - Fixed slides: Token Rationing bullet now names both Global + Project Knowledge; Session Resume bullet; Proof-of-Load bullet; About Human slide path.
  - validate-protocol.sh bumped to v4.1 with 2 new Global Knowledge JIT checks.
  - Code review round 1: CHANGES REQUESTED (review-03). All 4 Major + 2 Minor findings fixed.
  - Code review round 2: APPROVED (review-04).
  - 8 broken markdown links repaired across 5 files (AGENTS.md, ai-policy-common.md, workflow-guide.md ×2, example-learning-session-runbook.md).
  - Branch awaiting human review and merge to master.
