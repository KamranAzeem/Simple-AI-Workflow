# Project Context

## Latest Checkpoint: CP-2026-06-22-03
- **Current Branch**: master (HEAD: 0ca1d36) — uncommitted changes (docs/policy edits)
- **Last Summarized Hash**: 0ca1d36

## Session Summary (2026-06-22)
- **Codebase Examination → triggered procedure**: Changed from "opt-in Active Expertise" to "Procedure G trigger" (same pattern as code-review). Updated policy, README, docs/guide, docs/customization-guide, slides. AGENTS.md Procedure G addition provided for manual application.
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
