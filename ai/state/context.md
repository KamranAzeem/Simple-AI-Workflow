<!--
STATE-FILE: context.md is the PRESENT. A Current Status dashboard plus appended checkpoint history.
STATE-FILE: CHRONOLOGICAL ORDER. The ## Current Status section at the top is edited in place each checkpoint. Checkpoint history is appended below it, oldest above and newest at the bottom. Never reorder existing entries. The horizon shield archives the oldest entries when they grow too long.
STATE-FILE: KEEP LEAN. Short bullet entries, one to two lines each. Not a runbook, plan, or ledger. No implementation steps, commands, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
# Project Context

## Current Status
- **Branch**: `master`, synced with origin at 16899ea (verified this session via `git fetch --all --prune`, no divergence — the earlier "07e9474, git-drift flagged" note was stale, CP-2026-09-07-02 was already committed/pushed); uncommitted: this session's daily-checkpoint fix
- **Release**: v2.3.0 (2026-08-25); current protocol work merged to master, unreleased
- **Validator**: v4.7, all 8/8 checks pass (bumped this session; new "Write Daily Checkpoint File" anchor check added)
- **Markdown lint**: markdownlint-cli2 v0.23.2; README.md 0 issues
- **Policy count**: 16 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, windows-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **State files**: located in `ai/state/` (next-steps forward-only, progress append-only history, context = present)
- **Daily checkpoints**: Procedure C now has a mandatory write step (step 2); `ai/daily-checkpoints/` was lagging (last file 2026-09-04.md while state files were at CP-2026-09-07-02) — this is the exact symptom the fix addresses, now current as of this checkpoint
- **Project knowledge**: 10 files; `protocol-decisions.md` is the ADR store; notes split into `ai/notes/` files
- **Next milestones**: policies→skills rename (coordinate with TIER2 consolidation; change-request + HLD/LLD/ACs/Ledger; analysis in `ai/notes/policies-to-skills-rename-proposal-2026-09-04.md`); local-first knowledge retrieval proposal (note: `ai/notes/local-first-knowledge-retrieval-proposal.md`); protocol design docs (Vision/PRD/Delivery Ledger); TIER 2 vs Non-Negotiables consolidation; Kilo Code docs; multi-assistant + build AI team design; refactoring/codebase-upgrade policy; Procedure H (Grilling); Procedure I (Agent Document Review); sync AGENTS.md to other projects; discuss second open issue (proof-of-load-report-should-index-issues-directory.md)

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

## Checkpoint: CP-2026-09-07-02
- **Branch**: `master`, synced with origin at 16899ea, pushed (correction 2026-09-09: this checkpoint's commit was verified via `git fetch` + `git rev-parse` as already committed and pushed — the "Not committed" note previously recorded here was stale and was the source of a git-drift flag; no actual divergence between local and origin ever existed)
- **Summary**: README Common instructions restructure + local-first retrieval discussion. Extracted the long post-compaction bullet into a dedicated "### Post-compaction recovery" numbered subsection; moved the bootstrap note up under the Common instructions table; rewrote the "Review and maintenance phrases" list to keep each verbatim instruction in full (no bare triggers / no split "what it does" column). Analyzed the local-first knowledge retrieval idea — framed it as source-precedence in the Investigation Contract, deliberately NOT "RAG" (no embedding store intended); created proposal note, indexed in notes.md, added a todo to next-steps. README markdownlint 0 issues, validator v4.6 8/8.
- **Key deliverables**: README.md (post-compaction subsection + bootstrap note move + verbatim phrases list); ai/notes/local-first-knowledge-retrieval-proposal.md; notes.md pending index; next-steps.md todo. Commit 16899ea.

## Latest Checkpoint: CP-2026-09-09-01
- **Branch**: `master`, synced with origin at 16899ea (drift check completed this session: `git fetch --all --prune` confirmed local HEAD == origin/master, no divergence); uncommitted (this session's changes)
- **Summary**: Fixed the checkpoint-procedure issue reported from an elmera session (`ai/issues/checkpoint-procedure-never-writes-daily-checkpoint-file.md`) — Procedure C never had a step that wrote `ai/daily-checkpoints/`, only read from it, causing state files to race ahead of the checkpoint-file directory. Confirmed the bug live in this repo (state files at CP-2026-09-07-02, latest daily-checkpoint file was 2026-09-04.md). Added new Procedure C step 2 "Write Daily Checkpoint File" to AGENTS.md (old steps 2/3/4 renumbered 3/4/5; one internal cross-ref fixed). Deliberately used this repo's own established `YYYY-MM-DD.md`-one-file-per-day convention (verified via `2026-08-25.md` holding 4 sections) rather than the issue's proposed `YYYY-MM-DD-NN.md` naming from a different project. Mirrored in `ai-policy-common.md` (Daily Checkpoint File Mandate, no step numbers per the 2026-08-05 rule), `validate-protocol.sh` (v4.6→v4.7, new anchor check), `docs/workflow-guide.md` §14, `docs/simple-ai-workflow-slides.md`. Created the missing `ai/artifacts/` directory (pre-existing structural gap, unrelated, blocking the validator). Updated issue file to Resolved and added a dated entry to `protocol-decisions.md`. Peer review (Procedure D) → review-01 APPROVED, no findings. Validator v4.7 8/8. Not committed — pending user approval per Non-Negotiable #6.
- **Key deliverables**: `AGENTS.md` (Procedure C); `ai/policies/ai-policy-common.md`; `support-files/validate-protocol.sh` (v4.7); `docs/workflow-guide.md`; `docs/simple-ai-workflow-slides.md`; `ai/issues/checkpoint-procedure-never-writes-daily-checkpoint-file.md`; `ai/shared/project-knowledge/protocol-decisions.md`; `ai/code-review-reports/2026-09-09_15-30_review-01.md`; `ai/daily-checkpoints/2026-09-09.md` (this checkpoint, the fix's own first live use); `ai/artifacts/` (new dir).
