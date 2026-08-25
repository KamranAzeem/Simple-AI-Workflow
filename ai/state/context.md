<!--
STATE-FILE: context.md is the PRESENT. A Current Status dashboard plus appended checkpoint history.
STATE-FILE: CHRONOLOGICAL ORDER. The ## Current Status section at the top is edited in place each checkpoint. Checkpoint history is appended below it, oldest above and newest at the bottom. Never reorder existing entries. The horizon shield archives the oldest entries when they grow too long.
STATE-FILE: KEEP LEAN. Short bullet entries, one to two lines each. Not a runbook, plan, or ledger. No implementation steps, commands, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
# Project Context

## Current Status
- **Branch**: `master`, synced with origin at 2bdc118
- **Release**: v2.3.0 (2026-08-25); latest work unreleased
- **Validator**: v4.6, all 8/8 checks pass
- **Markdown lint**: markdownlint-cli2 v0.23.2 active, 0 issues (config `.markdownlint-cli2.jsonc`)
- **Policy count**: 16 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, windows-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **State files**: located in `ai/state/` with per-file headers (next-steps forward-only, progress append-only history, context = present) and one-to-two-line brevity
- **Next milestones**: Kilo Code docs; design docs drafts (vision/PRD/HLD in ai/notes/); multi-assistant + build AI team design; refactoring/codebase-upgrade policy; sync AGENTS.md to other projects

## Checkpoint History

(Older checkpoint entries are archived in `ai/shared/project-knowledge/context-archive.md`.)

## Checkpoint: CP-2026-08-21-01
- **Current Branch**: `master` — synced with origin (HEAD: 66a408f, no new commits this session)
- **Summary**: Analysis-only session. Full context load (Procedure A). Analyzed three improvement areas from notes.md: (1) Protocol Developer Mode policy-loading bug — during context load and post-compaction recovery the AI loads all 16 domain policies from the distribution tree instead of only those listed in ai-customization.md; fix is one sub-bullet added to AGENTS.md TIER 2 Protocol Developer Mode entry; (2) design docs gap — PRD, HLD, vision, ADRs, and delivery ledger still missing for the protocol itself; plan is to draft in ai/notes/ first; (3) research file on behavioral prompts/Habit Hooks/TDD enforcement — key finding: capable models game bare metric scores 71-88% of trials vs 83% genuine fix rate with behavioral coaching; 6 improvements prioritized. 6 new work items added to next-steps.md. No code changes, no commits.
- **Key deliverables**: 6 new items in next-steps.md

## Checkpoint: CP-2026-08-22-01
- **Current Branch**: `master` — synced with origin (HEAD: 8ea243f, pushed)
- **Summary**: Implemented Protocol Developer Mode policy-loading fix. Created feature branch; added Exception notes at all 4 policy-scan locations in AGENTS.md (TIER 2, Procedure A Step 6, Procedure C Step 4, Procedure E Step 5). Peer review round-01 CHANGES REQUESTED (Procedure C Step 4 gap) then round-02 APPROVED. Validator v4.6 8/8. Squash-merged to master as b93741c. Research notes and updated state files committed and pushed for cross-machine continuity (8ea243f). Protocol Developer Mode fix marked done in next-steps.md.
- **Key deliverables**: commit b93741c (AGENTS.md fix); 2 code review reports; notes and state files synced to origin

## Checkpoint: CP-2026-08-22-02
- **Current Branch**: `master` — pulled to 75bc1fc; local uncommitted work being committed as this checkpoint
- **Summary**: Remote pull + state reconciliation, decision reversal recorded, notes consolidation, WaqarSb example. Pulled 3 remote commits (b93741c Protocol Developer Mode policy-loading fix, 8ea243f + 75bc1fc checkpoints); dropped stale local CP-2026-08-09-02 entries (recorded the opposite decision, superseded by b93741c). Recorded decision reversal in protocol-decisions.md: 2026-08-09 "no fix" stance reversed for workflow repo, ordinary-project auto-discovery unchanged, old entry marked Superseded. Fixed macOS BSD sed incompatibility in sync-agents-md.sh (portable BRE temp-file+mv, committed db74e68, review APPROVED). Notes consolidation: removed processed items, marked post-compaction complaint Processed, deleted noticed.md, consolidated pending items into notes.md. Created docs/examples/full-stack-web-mobile-ai-customization.md from WaqarSb customization. Project knowledge updated (sync-scripts-testing.md macOS lesson, protocol-decisions.md).
- **Key deliverables**: sync-agents-md.sh macOS fix (db74e68); protocol-decisions.md decision reversal entry; docs/examples/full-stack-web-mobile-ai-customization.md; notes.md consolidation; state files reconciled to CP-2026-08-22-01 then bumped to -02

## Checkpoint: CP-2026-08-25-01
- **Current Branch**: `master`, synced with origin at 1d71e95
- **Summary**: Merged two protocol sessions and released v2.2.0. Commit 0383025: Evidence-Based full-reads and no-truncation rules, external-mutation guardrail, state-file model split (next-steps forward-only, progress append-only, context present) with brevity and bloat/order checks, context.md reorder, examination fixes (PowerShell sync bug, compliance-guide rewrite, handoff template, runbook, AGENTS.md banner reconciliation), README and slides rewritten in the maintainer voice, two validator checks. Commit 1d71e95: Pre-Work Gate and Acceptance Criteria Quality (AC guide opt-in).
- **Key deliverables**: commits 0383025 and 1d71e95; v2.2.0 release; codebase examination findings artifact; 4 peer reviews APPROVED; validator 8/8.

## Checkpoint: CP-2026-08-25-02
- **Current Branch**: `master`, synced with origin at 16e11f1
- **Summary**: Full-file-read enforcement. Promoted the read rule to a TIER 2 mandate in AGENTS.md (active at boot, load context, compaction, mid-work), added Proof-of-Load line counts, strengthened Evidence-Based Reasoning point 5, added a 6-item Non-Negotiables index to common policy, and a Full File Reads validator anchor. Committed 16e11f1, squash-merged to master, pushed, branch deleted. Released v2.3.0. Ran the context.md horizon shield (11 entries > 10): kept 5 most recent, archived 6 to context-archive.md.
- **Key deliverables**: commit 16e11f1; v2.3.0 release; peer review review-01 APPROVED; validator 8/8.

## Checkpoint: CP-2026-08-25-03
- **Current Branch**: `master`, HEAD a2a5215, not pushed to origin
- **Summary**: Implemented research ideas 1+2+10 (intent-over-metrics phrasing, shared-understanding pre-work gate) and root-only AGENTS.md/ai-customization.md scope; added markdownlint-cli2 config and fixed 14 whitespace issues. Squash-merged a2a5215, branch deleted. Peer reviews review-01/02 APPROVED, validator 8/8, markdownlint 0 issues.
- **Key deliverables**: commit a2a5215; .markdownlint-cli2.jsonc; two peer reviews APPROVED; markdownlint clean.

## Latest Checkpoint: CP-2026-08-25-04
- **Current Branch**: `master`, synced with origin at 2bdc118
- **Summary**: Cleanup and research. Deleted the habit-hooks research file and two stale artifacts; removed research-derived pending items; committed the 2026-08-24 checkpoint; preserved the multi-assistant + build AI team design as a pending note (both feature branches deleted); stored the refactoring/upgrading research note (policy under consideration); verified the repo is free of the sensitive names. Commits 1ae768c, d00b0e6, 08a204a, 47bd5dc, 2bdc118.
- **Key deliverables**: research/artifact cleanup; ai/notes/multi-assistant-workflow-design.md; ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md; protocol-decisions.md entry.
