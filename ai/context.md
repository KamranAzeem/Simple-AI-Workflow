# Project Context

## Current Status
- **Branch**: `feature/post-compaction-recovery-rename` — 3 commits ahead of master (58f22a4, 4465a54, 36de4b6), NOT merged; uncommitted docs changes in working tree
- **Release**: v2.0.0 tagged and released on GitHub with full changelog
- **Validator**: v4.6, all 8/8 checks pass
- **Policy count**: 15 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **Next milestone**: commit remaining docs changes, merge feature branch to master, then push to origin

## Checkpoint History

## Latest Checkpoint: CP-2026-07-31-01
- **Current Branch**: `feature/post-compaction-recovery-rename` — 3 commits ahead of master, uncommitted working tree
- **Summary**: Post-Compaction Recovery work: renamed Procedure E, simplified to additive reload, concrete compaction signals added to AGENTS.md (literal "Compacted conversation", `<conversation-summary>` XML, machine-generated summary), PreCompact hook at `~/.copilot/hooks/compaction-recovery.json` created, Proof-of-Load Step 7(a) widened to all sections, user memory trigger deleted, README/slides/setup-guide updated, new Post-Compaction Recovery slide with context-window diagrams added to slides, standalone problem-description note saved.
- **Key deliverables**: 3 commits, validator v4.6 8/8, 5 review reports written (review-01 through review-05 on 2026-07-31), uncommitted docs batch pending

## Latest Checkpoint: CP-2026-07-04-04
- **Summary**: Mega session covering customization-at-root, sync auto-migration, Humanized Output section, 2 new policies, cross-reference audit, bootstrap audit/creation separation, archive/backup directory exclusions, compliance directory reference cleanup, v2.0.0 GitHub release
- **Key deliverables**: 40 commits since v1.0.0, 14 TIER 1 config anchors, 11 code reviews (review-04 through review-10), README diagram updated, validator v4.5
- **NOT pushed to origin**

## Latest Checkpoint: CP-2026-07-25-01
- **Current Branch**: `master` — uncommitted working tree changes
- **Summary**: Processed ai/notes/notes.md — created ai-policy-career-coaching.md (consolidates resume, cover letter, interview prep, career strategy, executive recruitment into one policy). Updated README, customization guide, slides, validation script. Created missing ai/plans/ and ai/policies/compliance/ directories. Validator v4.5 all 8/8 pass. Peer review review-01 APPROVED. Uncommitted working tree.
- **Key deliverables**: 1 new policy (career-coaching), 5 doc files updated, 2 missing dirs created

## Latest Checkpoint: CP-2026-07-25-02
- **Current Branch**: `master` — uncommitted working tree changes
- **Summary**: Rewrote ai-policy-academic-researcher.md — adopted friend's comprehensive draft (48→342 lines), internationalized: removed all India/UGC-specific content (UGC 2018 regs, UGC-CARE, DPDP Act), generalized domain focus from Container/Kubernetes Security to generic empirical research. Kept all international frameworks, full research workflow, source quality standards, statistical analysis, and publishing lifecycle. Validator v4.5 all 8/8 pass. Peer review review-02 APPROVED.
- **Key deliverables**: 1 policy fully rewritten (academic-researcher), 2 notes processed

## Latest Checkpoint: CP-2026-07-25-03
- **Current Branch**: `master` — uncommitted working tree changes
- **Summary**: High-effort review of all session work. Fixed two issues in ai-policy-academic-researcher.md: stale cross-reference (§21→§20) and hardcoded tool name in AI-disclosure example (→ [Tool/Vendor]). Validator v4.5 all 8/8 pass.
- **Key deliverables**: 2 bug fixes in policy file, no new files

## Latest Checkpoint: CP-2026-07-04-01
- **Current Branch**: `feature/protocol-improvements` — squash-merged and deleted
- **Summary**: TIER 1 anchor expansion, Project AI State Files directive, Canonical Names & Short Forms, custom policy auto-discovery, Git Workspace Detection, rich context.md horizon shield
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
