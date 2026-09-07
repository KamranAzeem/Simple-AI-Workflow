<!--
STATE-FILE: context.md is the PRESENT. A Current Status dashboard plus appended checkpoint history.
STATE-FILE: CHRONOLOGICAL ORDER. The ## Current Status section at the top is edited in place each checkpoint. Checkpoint history is appended below it, oldest above and newest at the bottom. Never reorder existing entries. The horizon shield archives the oldest entries when they grow too long.
STATE-FILE: KEEP LEAN. Short bullet entries, one to two lines each. Not a runbook, plan, or ledger. No implementation steps, commands, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
# Project Context

## Current Status
- **Branch**: `master`, synced with origin at 07e9474; uncommitted README.md + ai/notes/* + ai/state/*
- **Release**: v2.3.0 (2026-08-25); current protocol work merged to master, unreleased
- **Validator**: v4.6, all 8/8 checks pass
- **Markdown lint**: markdownlint-cli2 v0.23.2; README.md 0 issues
- **Policy count**: 16 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, windows-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **State files**: located in `ai/state/` (next-steps forward-only, progress append-only history, context = present)
- **Project knowledge**: 10 files; `protocol-decisions.md` is the ADR store; notes split into `ai/notes/` files
- **Next milestones**: policies→skills rename (coordinate with TIER2 consolidation; change-request + HLD/LLD/ACs/Ledger; analysis in `ai/notes/policies-to-skills-rename-proposal-2026-09-04.md`); local-first knowledge retrieval proposal (note: `ai/notes/local-first-knowledge-retrieval-proposal.md`); protocol design docs (Vision/PRD/Delivery Ledger); TIER 2 vs Non-Negotiables consolidation; Kilo Code docs; multi-assistant + build AI team design; refactoring/codebase-upgrade policy; Procedure H (Grilling); Procedure I (Agent Document Review); sync AGENTS.md to other projects

## Checkpoint History

(Older checkpoint entries are archived in `ai/shared/project-knowledge/context-archive.md`.)

## Checkpoint: CP-2026-08-25-04
- **Branch**: `master`, synced with origin at 2bdc118
- **Summary**: Cleanup + research: deleted habit-hooks file + 2 stale artifacts, removed research-derived pending items, committed 2026-08-24 checkpoint, preserved multi-assistant + refactoring notes, verified no sensitive names. Commits 1ae768c/d00b0e6/08a204a/47bd5dc/2bdc118.

## Checkpoint: CP-2026-08-28-01
- **Branch**: `master`, synced with origin at e7c4426; no commits
- **Summary**: Analysis-only. Codebase examination (Procedure G ×3) of mattpocock repos; 3 project knowledge files (1207 lines); proposed Procedure H (Grilling) and Procedure I (Agent Document Review) as on-demand policies following the code-review pattern.

## Latest Checkpoint: CP-2026-08-31-01
- **Branch**: `master`, synced with origin at fc36781, pushed
- **Summary**: Protocol-tightening session. Evidence-based investigation made default (two-layer: TIER 2 instruction + Investigation Contract as top Non-Negotiable), old 6-point Evidence-Based Reasoning section removed, Full File Reads re-sharpened, design-doc chain review gate added, ubiquitous language + ontology dropped, protocol routing principle recorded, notes reorg. Squash-merged fc36781 + pushed; review-02 APPROVED, validator v4.6 8/8.

## Latest Checkpoint: CP-2026-09-04-01
- **Branch**: `master`, synced with origin at ab5b7a4, pushed
- **Summary**: Maintenance + analysis. Condensed long historical progress.md/context.md entries to keep-lean (ab5b7a4) — preserved every CP ID, commit hash, validator version, and review outcome; no entries dropped. Analyzed and endorsed the policies→skills rename (ai/policies/→ai/skills/, `ai-policy-<name>.md`→`<name>.md`, Active Expertise→Active Skills): measured blast radius (16 files, 30 ai-policy- refs, 13 Active Expertise / 7 Policies Directory), scoped a freeze on historical records, flagged the common/meta taxonomy nuance + global-dir/sync cascade, recommended coordinating with the TIER2 consolidation, and proposed change-request + HLD/LLD/ACs/Ledger. Not started.
- **Key deliverables**: ab5b7a4 (state condense); ai/notes/policies-to-skills-rename-proposal-2026-09-04.md; next-steps pending item; notes.md proposal captured.

## Checkpoint: CP-2026-09-07-01
- **Branch**: `master`, synced with origin at 07e9474; uncommitted README.md + ai/notes/notes.md
- **Summary**: README correctness + peer review. Verified recent README edits — found and fixed two issues: (1) design-doc flow listed non-existent "Raw-notes"/"ACs" docs (canonical = Notes/Vision/PRD/HLD/LLD/ADRs/Ledger per ai-policy-common.md:223), (2) post-compaction sentence grammar. Added "Review and maintenance phrases" table (8 prompts) to Common instructions using the canonical `ai/shared/project-knowledge/` path. Peer review (Procedure D) → review-01 CHANGES REQUESTED; fixed all findings: "16 domain policies"→12 (only 12 of 16 files are domain policies), markdownlint MD031×2/MD012×2/MD040. README markdownlint now 0 issues, validator v4.6 8/8. Not committed.
- **Key deliverables**: README.md edits (Correctness + Common instructions + lint fixes); ai/code-review-reports/2026-09-07_15-35_review-01.md.

## Latest Checkpoint: CP-2026-09-07-02
- **Branch**: `master`, synced with origin at 07e9474; uncommitted README.md + ai/notes/* + ai/state/* + new ai/notes/local-first-knowledge-retrieval-proposal.md
- **Summary**: README Common instructions restructure + local-first retrieval discussion. Extracted the long post-compaction bullet into a dedicated "### Post-compaction recovery" numbered subsection; moved the bootstrap note up under the Common instructions table; rewrote the "Review and maintenance phrases" list to keep each verbatim instruction in full (no bare triggers / no split "what it does" column). Analyzed the local-first knowledge retrieval idea — framed it as source-precedence in the Investigation Contract, deliberately NOT "RAG" (no embedding store intended); created proposal note, indexed in notes.md, added a todo to next-steps. README markdownlint 0 issues, validator v4.6 8/8. Not committed.
- **Key deliverables**: README.md (post-compaction subsection + bootstrap note move + verbatim phrases list); ai/notes/local-first-knowledge-retrieval-proposal.md; notes.md pending index; next-steps.md todo.
