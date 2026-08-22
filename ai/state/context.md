<!--
STATE-FILE: APPEND-ONLY. Append new content at the tail of this file. Do not insert, prepend, or edit content above existing entries. The most recent entry is always the last one.
STATE-FILE: KEEP LEAN. This file manages AI assistant state (what was done, what is pending, current context). No detailed implementation steps, commands, runbooks, investigation notes, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
# Project Context

## Current Status
- **Branch**: `master` — pulled to 75bc1fc, local uncommitted work (this checkpoint) ready to commit
- **Release**: v2.1.0 tagged and released on GitHub with full changelog (2026-08-08)
- **Validator**: v4.6, all 8/8 checks pass
- **Policy count**: 16 modular policies (common, meta, cloud, api-backend, web-frontend, data, linux-system-admin, windows-system-admin, mobile-apps, dba, observability, code-review, codebase-examination, accounting, academic-researcher, career-coaching)
- **State files**: located in `ai/state/` (progress.md, context.md, next-steps.md) with APPEND-ONLY / KEEP LEAN headers
- **Next milestones**: Kilo Code docs; design docs drafts (vision/PRD/HLD in ai/notes/); behavioral coaching rule + Habit Hooks opt-in + TDD sub-rules in policy files; docs pattern guides; sync AGENTS.md to other projects
- **Pending work moved here from remote**: 6 items queued on the other machine (design docs, behavioral coaching, Habit Hooks, TDD sub-rules, 3 doc guides) — to be worked on this machine only

## Checkpoint History

## Latest Checkpoint: CP-2026-08-09-01
- **Current Branch**: `master` — synced with origin (HEAD: 9183c52, pushed)
- **Summary**: State-files directory release and environment setup. State files moved to `ai/state/` (CP-2026-08-08-02, commit 9183c52, squash-merged to master, pushed, branch deleted). v2.1.0 GitHub release created with full changelog (14 commits, 40 files since v2.0.0). Global settings tools list updated for Fedora 44 Linux (verified paths, tools installed via dnf). Writing style training set up: distilled guide in `~/.ai/global-knowledge/writing-style-and-examples.md` (fully loaded at boot), raw examples reviewed and deleted (not stored anywhere), notes.md item marked Processed. context.md horizon shield run (17 entries > 10): 5 most recent kept, 12 archived to `ai/shared/project-knowledge/context-archive.md`.
- **Key deliverables**: v2.1.0 release; commit 9183c52; 1 new project knowledge file (context-archive.md); 1 new global knowledge file (writing-style-and-examples.md)

## Latest Checkpoint: CP-2026-08-08-01
- **Current Branch**: `master` — synced with origin (HEAD: 18b5946)
- **Summary**: Large session. Two feature branches merged and pushed. Windows SysAdmin policy added (policy #16). README fully rewritten. New comparison doc for Copilot/Claude/ChatGPT/Cursor. Design Documentation Standards expanded with Vision, ID convention (REQ/HLD/LLD/ADR-NNN), and mandatory Delivery Ledger. Workflow guide, slides, and README updated with design flow. Notes processed: windows-system-admin done, Vision/PRD/TLD/LLD/ledger done (TLD resolved as not needed), writing style pending user articles.
- **Key deliverables**: 3 commits (65c0f92, 0e869d7, 18b5946); 1 new policy; 1 new doc; 2 feature branches merged and deleted; validator v4.6 8/8

## Latest Checkpoint: CP-2026-08-05-01
- **Current Branch**: `master` — 1 commit ahead of origin (HEAD: e82729c)
- **Summary**: Fixed ai-policy-common.md fragile internal-label references. Removed all procedure-letter (A/C/E/F), step-number (Step 4), and TIER-1 references; replaced with plain phrases. Fixed Generated File Validation list indentation. Committed to master (e82729c). Validator v4.6 8/8.
- **Key deliverables**: 1 commit (e82729c), ai-policy-common.md fixed, next-steps.md duplicate sections cleaned up

## Latest Checkpoint: CP-2026-08-02-01
- **Current Branch**: `master` — clean, synced with origin (f61a680)
- **Summary**: Research session — investigated Kilo Code context condensing for PostCompact hook equivalents. No hooks found; AGENTS.md always-on as system instructions (survives compaction by architecture). Decided human backstop is sufficient; no slash command needed. Todo added to notes.md for Kilo Code documentation updates. feature/post-compaction-recovery-rename squash-merged and pushed.
- **Key deliverables**: notes.md todo added; no commits this session (notes.md change only)

## Latest Checkpoint: CP-2026-07-31-01
- **Current Branch**: `feature/post-compaction-recovery-rename` — squash-merged to master as f61a680
- **Summary**: Post-Compaction Recovery work: renamed Procedure E, simplified to additive reload, concrete compaction signals added, PreCompact hook created, Proof-of-Load widened, user memory trigger deleted, README/slides/setup-guide updated, new Post-Compaction Recovery slide with four-box context-window diagram.
- **Key deliverables**: 4 commits (58f22a4, 4465a54, 36de4b6, e6ea76d), validator v4.6 8/8

## Latest Checkpoint: CP-2026-07-04-04
- **Summary**: Mega session covering customization-at-root, sync auto-migration, Humanized Output section, 2 new policies, cross-reference audit, bootstrap audit/creation separation, archive/backup directory exclusions, compliance directory reference cleanup, v2.0.0 GitHub release
- **Key deliverables**: 40 commits since v1.0.0, 14 TIER 1 config anchors, 11 code reviews (review-04 through review-10), README diagram updated, validator v4.5
- **NOT pushed to origin**

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/

## Latest Checkpoint: CP-2026-08-21-01
- **Current Branch**: `master` — synced with origin (HEAD: 66a408f, no new commits this session)
- **Summary**: Analysis-only session. Full context load (Procedure A). Analyzed three improvement areas from notes.md: (1) Protocol Developer Mode policy-loading bug — during context load and post-compaction recovery the AI loads all 16 domain policies from the distribution tree instead of only those listed in ai-customization.md; fix is one sub-bullet added to AGENTS.md TIER 2 Protocol Developer Mode entry; (2) design docs gap — PRD, HLD, vision, ADRs, and delivery ledger still missing for the protocol itself; plan is to draft in ai/notes/ first; (3) research file on behavioral prompts/Habit Hooks/TDD enforcement — key finding: capable models game bare metric scores 71-88% of trials vs 83% genuine fix rate with behavioral coaching; 6 improvements prioritized. 6 new work items added to next-steps.md. No code changes, no commits.
- **Key deliverables**: 6 new items in next-steps.md

## Latest Checkpoint: CP-2026-08-22-01
- **Current Branch**: `master` — synced with origin (HEAD: 8ea243f, pushed)
- **Summary**: Implemented Protocol Developer Mode policy-loading fix. Created feature branch; added Exception notes at all 4 policy-scan locations in AGENTS.md (TIER 2, Procedure A Step 6, Procedure C Step 4, Procedure E Step 5). Peer review round-01 CHANGES REQUESTED (Procedure C Step 4 gap) then round-02 APPROVED. Validator v4.6 8/8. Squash-merged to master as b93741c. Research notes and updated state files committed and pushed for cross-machine continuity (8ea243f). Protocol Developer Mode fix marked done in next-steps.md.
- **Key deliverables**: commit b93741c (AGENTS.md fix); 2 code review reports; notes and state files synced to origin

## Latest Checkpoint: CP-2026-08-22-02
- **Current Branch**: `master` — pulled to 75bc1fc; local uncommitted work being committed as this checkpoint
- **Summary**: Remote pull + state reconciliation, decision reversal recorded, notes consolidation, WaqarSb example. Pulled 3 remote commits (b93741c Protocol Developer Mode policy-loading fix, 8ea243f + 75bc1fc checkpoints); dropped stale local CP-2026-08-09-02 entries (recorded the opposite decision, superseded by b93741c). Recorded decision reversal in protocol-decisions.md: 2026-08-09 "no fix" stance reversed for workflow repo, ordinary-project auto-discovery unchanged, old entry marked Superseded. Fixed macOS BSD sed incompatibility in sync-agents-md.sh (portable BRE temp-file+mv, committed db74e68, review APPROVED). Notes consolidation: removed processed items, marked post-compaction complaint Processed, deleted noticed.md, consolidated pending items into notes.md. Created docs/examples/full-stack-web-mobile-ai-customization.md from WaqarSb customization. Project knowledge updated (sync-scripts-testing.md macOS lesson, protocol-decisions.md).
- **Key deliverables**: sync-agents-md.sh macOS fix (db74e68); protocol-decisions.md decision reversal entry; docs/examples/full-stack-web-mobile-ai-customization.md; notes.md consolidation; state files reconciled to CP-2026-08-22-01 then bumped to -02
