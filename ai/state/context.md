<!--
STATE-FILE: context.md is the PRESENT. A Current Status dashboard plus appended checkpoint history.
STATE-FILE: CHRONOLOGICAL ORDER. The ## Current Status section at the top is edited in place each checkpoint. Checkpoint history is appended below it, oldest above and newest at the bottom. Never reorder existing entries. The horizon shield archives the oldest entries when they grow too long.
STATE-FILE: KEEP LEAN. Short bullet entries, one to two lines each. Not a runbook, plan, or ledger. No implementation steps, commands, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
# Project Context

## Current Status
- **Branch**: `master`, synced with origin at fc36781, pushed 2026-08-31
- **Release**: v2.3.0 (2026-08-25); current protocol work merged to master, unreleased
- **Validator**: v4.6, all 8/8 checks pass
- **Markdown lint**: markdownlint-cli2 v0.23.2; clean on new content (pre-existing findings remain in docs + state files)
- **Policy count**: 16 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, windows-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **State files**: located in `ai/state/` (next-steps forward-only, progress append-only history, context = present)
- **Project knowledge**: 9 files; `protocol-decisions.md` is the ADR store; notes split into `ai/notes/` files
- **Next milestones**: protocol design docs (Vision/PRD/Delivery Ledger); TIER 2 vs Non-Negotiables consolidation; Kilo Code docs; multi-assistant + build AI team design; refactoring/codebase-upgrade policy; Procedure H (Grilling); Procedure I (Agent Document Review); sync AGENTS.md to other projects

## Checkpoint History

(Older checkpoint entries are archived in `ai/shared/project-knowledge/context-archive.md`.)

## Checkpoint: CP-2026-08-21-01
- **Branch**: `master`, synced with origin (HEAD 66a408f, no commits)
- **Summary**: Analysis-only. Found Protocol Developer Mode policy-loading bug (AI loads all 16 domain policies instead of only listed ones; one sub-bullet fix), design docs gap, and researched behavioral prompts/Habit Hooks (models game bare metrics 71-88% vs 83% genuine fix with coaching). 6 new next-steps items.

## Checkpoint: CP-2026-08-22-01
- **Branch**: `master`, synced with origin (HEAD 8ea243f, pushed)
- **Summary**: Implemented Protocol Developer Mode policy-loading fix (Exception notes at all 4 policy-scan locations), reviews 01->02 APPROVED, squash-merged b93741c; state files synced to origin. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-22-02
- **Branch**: `master`, pulled to 75bc1fc
- **Summary**: Remote pull + state reconciliation (dropped stale CP-08-09-02), decision reversal recorded, notes consolidation, WaqarSb example, macOS BSD sed fix in sync-agents-md.sh (db74e68). Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-01
- **Branch**: `master`, synced with origin at 1d71e95
- **Summary**: Merged two protocol sessions and released v2.2.0: evidence full-read/no-truncation, external-mutation guardrail, state-file model split (0383025, 1d71e95); Pre-Work Gate + AC Quality; README/slides rewritten; validator 8/8. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-02
- **Branch**: `master`, synced with origin at 16e11f1
- **Summary**: Full-file-read enforcement promoted to TIER 2 mandate, Proof-of-Load line counts, 6-item Non-Negotiables index; committed 16e11f1, v2.3.0 release, context.md horizon shield (kept 5, archived 6); validator 8/8. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-03
- **Branch**: `master`, HEAD a2a5215, not pushed
- **Summary**: Implemented research ideas 1+2+10 (intent-over-metrics, shared-understanding pre-work gate) + root-only scope; added markdownlint-cli2 config and fixed 14 whitespace issues; reviews 01/02 APPROVED, validator 8/8.

## Checkpoint: CP-2026-08-25-04
- **Branch**: `master`, synced with origin at 2bdc118
- **Summary**: Cleanup + research: deleted habit-hooks file + 2 stale artifacts, removed research-derived pending items, committed 2026-08-24 checkpoint, preserved multi-assistant + refactoring notes, verified no sensitive names. Commits 1ae768c/d00b0e6/08a204a/47bd5dc/2bdc118.

## Checkpoint: CP-2026-08-28-01
- **Branch**: `master`, synced with origin at e7c4426; no commits
- **Summary**: Analysis-only. Codebase examination (Procedure G ×3) of mattpocock repos; 3 project knowledge files (1207 lines); proposed Procedure H (Grilling) and Procedure I (Agent Document Review) as on-demand policies following the code-review pattern.

## Latest Checkpoint: CP-2026-08-31-01
- **Branch**: `master`, synced with origin at fc36781, pushed
- **Summary**: Protocol-tightening session. Evidence-based investigation made default (two-layer: TIER 2 instruction + Investigation Contract as top Non-Negotiable), old 6-point Evidence-Based Reasoning section removed, Full File Reads re-sharpened, design-doc chain review gate added, ubiquitous language + ontology dropped, protocol routing principle recorded, notes reorg. Squash-merged fc36781 + pushed; review-02 APPROVED, validator v4.6 8/8.
