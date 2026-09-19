# Context Archive

Historical checkpoint entries from `ai/state/context.md`, bulk-archived by the Sliding Horizon Shield. Older entries are kept here for reference; the live file holds only the 5 most recent.

---

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

## Checkpoint: CP-2026-07-04-04
- **Summary**: Mega session covering customization-at-root, sync auto-migration, Humanized Output section, 2 new policies, cross-reference audit, bootstrap audit/creation separation, archive/backup directory exclusions, compliance directory reference cleanup, v2.0.0 GitHub release
- **Key deliverables**: 40 commits since v1.0.0, 14 TIER 1 config anchors, 11 code reviews (review-04 through review-10), README diagram updated, validator v4.5
- **NOT pushed to origin**

## Checkpoint: CP-2026-07-31-01
- **Current Branch**: `feature/post-compaction-recovery-rename` — squash-merged to master as f61a680
- **Summary**: Post-Compaction Recovery work: renamed Procedure E, simplified to additive reload, concrete compaction signals added, PreCompact hook created, Proof-of-Load widened, user memory trigger deleted, README/slides/setup-guide updated, new Post-Compaction Recovery slide with four-box context-window diagram.
- **Key deliverables**: 4 commits (58f22a4, 4465a54, 36de4b6, e6ea76d), validator v4.6 8/8

## Checkpoint: CP-2026-08-02-01
- **Current Branch**: `master` — clean, synced with origin (f61a680)
- **Summary**: Research session — investigated Kilo Code context condensing for PostCompact hook equivalents. No hooks found; AGENTS.md always-on as system instructions (survives compaction by architecture). Decided human backstop is sufficient; no slash command needed. Todo added to notes.md for Kilo Code documentation updates. feature/post-compaction-recovery-rename squash-merged and pushed.
- **Key deliverables**: notes.md todo added; no commits this session (notes.md change only)

## Checkpoint: CP-2026-08-05-01
- **Current Branch**: `master` — 1 commit ahead of origin (HEAD: e82729c)
- **Summary**: Fixed ai-policy-common.md fragile internal-label references. Removed all procedure-letter (A/C/E/F), step-number (Step 4), and TIER-1 references; replaced with plain phrases. Fixed Generated File Validation list indentation. Committed to master (e82729c). Validator v4.6 8/8.
- **Key deliverables**: 1 commit (e82729c), ai-policy-common.md fixed, next-steps.md duplicate sections cleaned up

## Checkpoint: CP-2026-08-08-01
- **Current Branch**: `master` — synced with origin (HEAD: 18b5946)
- **Summary**: Large session. Two feature branches merged and pushed. Windows SysAdmin policy added (policy #16). README fully rewritten. New comparison doc for Copilot/Claude/ChatGPT/Cursor. Design Documentation Standards expanded with Vision, ID convention (REQ/HLD/LLD/ADR-NNN), and mandatory Delivery Ledger. Workflow guide, slides, and README updated with design flow. Notes processed: windows-system-admin done, Vision/PRD/TLD/LLD/ledger done (TLD resolved as not needed), writing style pending user articles.
- **Key deliverables**: 3 commits (65c0f92, 0e869d7, 18b5946); 1 new policy; 1 new doc; 2 feature branches merged and deleted; validator v4.6 8/8

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/

## Checkpoint: CP-2026-08-09-01
- **Current Branch**: `master` — synced with origin (HEAD: 9183c52, pushed)
- **Summary**: State-files directory release and environment setup. State files moved to `ai/state/` (CP-2026-08-08-02, commit 9183c52, squash-merged to master, pushed, branch deleted). v2.1.0 GitHub release created with full changelog (14 commits, 40 files since v2.0.0). Global settings tools list updated for Fedora 44 Linux (verified paths, tools installed via dnf). Writing style training set up: distilled guide in `~/.ai/global-knowledge/writing-style-and-examples.md` (fully loaded at boot), raw examples reviewed and deleted (not stored anywhere), notes.md item marked Processed. context.md horizon shield run (17 entries > 10): 5 most recent kept, 12 archived to `ai/shared/project-knowledge/context-archive.md`.
- **Key deliverables**: v2.1.0 release; commit 9183c52; 1 new project knowledge file (context-archive.md); 1 new global knowledge file (writing-style-and-examples.md)

## Checkpoint: CP-2026-08-21-01
- **Current Branch**: `master` — synced with origin (HEAD: 66a408f, no commits)
- **Summary**: Analysis-only. Found Protocol Developer Mode policy-loading bug (AI loads all 16 domain policies instead of only listed ones; one sub-bullet fix), design docs gap, and researched behavioral prompts/Habit Hooks (models game bare metrics 71-88% vs 83% genuine fix with coaching). 6 new next-steps items.

## Checkpoint: CP-2026-08-22-01
- **Current Branch**: `master` — synced with origin (HEAD: 8ea243f, pushed)
- **Summary**: Implemented Protocol Developer Mode policy-loading fix (Exception notes at all 4 policy-scan locations), reviews 01->02 APPROVED, squash-merged b93741c; state files synced to origin. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-22-02
- **Current Branch**: `master` — pulled to 75bc1fc
- **Summary**: Remote pull + state reconciliation (dropped stale CP-08-09-02), decision reversal recorded, notes consolidation, [redacted] example, macOS BSD sed fix in sync-agents-md.sh (db74e68). Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-01
- **Current Branch**: `master` — synced with origin at 1d71e95
- **Summary**: Merged two protocol sessions and released v2.2.0: evidence full-read/no-truncation, external-mutation guardrail, state-file model split (0383025, 1d71e95); Pre-Work Gate + AC Quality; README/slides rewritten; validator 8/8. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-02
- **Current Branch**: `master` — synced with origin at 16e11f1
- **Summary**: Full-file-read enforcement promoted to TIER 2 mandate, Proof-of-Load line counts, 6-item Non-Negotiables index; committed 16e11f1, v2.3.0 release, context.md horizon shield (kept 5, archived 6); validator 8/8. Detail in protocol-decisions.md.

## Checkpoint: CP-2026-08-25-03
- **Current Branch**: `master` — HEAD a2a5215, not pushed
- **Summary**: Implemented research ideas 1+2+10 (intent-over-metrics, shared-understanding pre-work gate) + root-only scope; added markdownlint-cli2 config and fixed 14 whitespace issues; reviews 01/02 APPROVED, validator 8/8.

## Checkpoint: CP-2026-08-25-04
- **Branch**: `master`, synced with origin at 2bdc118
- **Summary**: Cleanup + research: deleted habit-hooks file + 2 stale artifacts, removed research-derived pending items, committed 2026-08-24 checkpoint, preserved multi-assistant + refactoring notes, verified no sensitive names. Commits 1ae768c/d00b0e6/08a204a/47bd5dc/2bdc118.

## Checkpoint: CP-2026-08-28-01
- **Branch**: `master`, synced with origin at e7c4426; no commits
- **Summary**: Analysis-only. Codebase examination (Procedure G ×3) of mattpocock repos; 3 project knowledge files (1207 lines); proposed Procedure H (Grilling) and Procedure I (Agent Document Review) as on-demand policies following the code-review pattern.

## Checkpoint: CP-2026-08-31-01
- **Branch**: `master`, synced with origin at fc36781, pushed
- **Summary**: Protocol-tightening session. Evidence-based investigation made default (two-layer: TIER 2 instruction + Investigation Contract as top Non-Negotiable), old 6-point Evidence-Based Reasoning section removed, Full File Reads re-sharpened, design-doc chain review gate added, ubiquitous language + ontology dropped, protocol routing principle recorded, notes reorg. Squash-merged fc36781 + pushed; review-02 APPROVED, validator v4.6 8/8.

## Checkpoint: CP-2026-09-04-01
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

## Checkpoint: CP-2026-09-09-01
- **Branch**: `master`, synced with origin at f716105, pushed (correction: this entry originally said "Not committed" — the user reviewed and approved the commit in this same session)
- **Summary**: Fixed the checkpoint-procedure issue reported from an [redacted] session (`ai/issues/closed-checkpoint-procedure-never-writes-daily-checkpoint-file.md`) — Procedure C never had a step that wrote `ai/daily-checkpoints/`, only read from it, causing state files to race ahead of the checkpoint-file directory. Confirmed the bug live in this repo (state files at CP-2026-09-07-02, latest daily-checkpoint file was 2026-09-04.md). Added new Procedure C step 2 "Write Daily Checkpoint File" to AGENTS.md (old steps 2/3/4 renumbered 3/4/5; one internal cross-ref fixed). Deliberately used this repo's own established `YYYY-MM-DD.md`-one-file-per-day convention (verified via `2026-08-25.md` holding 4 sections) rather than the issue's proposed `YYYY-MM-DD-NN.md` naming from a different project. Mirrored in `ai-policy-common.md` (Daily Checkpoint File Mandate, no step numbers per the 2026-08-05 rule), `validate-protocol.sh` (v4.6→v4.7, new anchor check), `docs/workflow-guide.md` §14, `docs/simple-ai-workflow-slides.md`. Created the missing `ai/artifacts/` directory (pre-existing structural gap, unrelated, blocking the validator). Updated issue file to Resolved and added a dated entry to `protocol-decisions.md`. Peer review (Procedure D) → review-01 APPROVED, no findings. Validator v4.7 8/8.
- **Key deliverables**: `AGENTS.md` (Procedure C); `ai/policies/ai-policy-common.md`; `support-files/validate-protocol.sh` (v4.7); `docs/workflow-guide.md`; `docs/simple-ai-workflow-slides.md`; `ai/issues/closed-checkpoint-procedure-never-writes-daily-checkpoint-file.md`; `ai/shared/project-knowledge/protocol-decisions.md`; `ai/code-review-reports/2026-09-09_15-30_review-01.md`; `ai/daily-checkpoints/2026-09-09.md` (this checkpoint, the fix's own first live use); `ai/artifacts/` (new dir). Commit f716105.

## Checkpoint: CP-2026-09-09-02
- **Branch**: `feature/proof-of-load-issues-directory-indexing` (off `master` @ f716105), uncommitted
- **Summary**: Formalized `ai/issues/` in the protocol (see `ai/issues/closed-proof-of-load-report-should-index-issues-directory.md`). Added **Project Issues Directory** (`ai/issues/`) to `AGENTS.md` TIER 1, scoped per-project not global (corrected from the issue's own "global-only" guess — issues can cover the protocol or any sibling project under the same root). Procedure A Step 2 now audits it, Step 5 indexes it by filename + line count excluding `closed-`-prefixed files, Step 7 adds Proof-of-Load bullet (g). Lifecycle: rejected `open/`/`closed/` subdirectories and a `## Status` content field in favor of a flat directory with a `closed-` filename prefix (avoids the same text-drift risk CP-01 fixed, and avoids a directory-existence question). `validate-protocol.sh` v4.7→v4.8 (CONFIG_KEYS + PROJECT_SUBS + new anchor check). Both existing issue files renamed with the `closed-` prefix; the second's Status updated to Resolved, dogfooding the new convention on itself. Validator run 3× across the edit sequence, 8/8 pass each time. Peer review (Procedure D) → review-02 APPROVED, no findings (2 non-blocking suggestions).
- **Key deliverables**: `AGENTS.md` (TIER 1 + Procedure A Steps 2/5/7); `support-files/validate-protocol.sh` (v4.8); `ai/shared/project-knowledge/protocol-decisions.md`; `ai/issues/closed-checkpoint-procedure-never-writes-daily-checkpoint-file.md` + `ai/issues/closed-proof-of-load-report-should-index-issues-directory.md` (both renamed); `ai/code-review-reports/2026-09-09_16-17_review-02.md`; `ai/daily-checkpoints/2026-09-09.md` (CP-02 section).

## Checkpoint: CP-2026-09-09-03
- **Branch**: `master`, synced with origin at 2149bc8, pushed
- **Summary**: Squash-merged `feature/proof-of-load-issues-directory-indexing` into `master` per user approval: committed on the feature branch (`3db16cd`), squash-merged (`git merge --squash`), committed on `master` as `2149bc8`, pushed to `origin/master` (`f716105..2149bc8`). Local feature branch force-deleted after confirming zero content diff vs `master` (expected, since squash merges aren't recognized by git as "fully merged").
- **Key deliverables**: `master` @ 2149bc8, pushed; local branch `feature/proof-of-load-issues-directory-indexing` removed.

## Checkpoint: CP-2026-09-09-04
- **Branch**: `master`, synced with origin at 2149bc8 (clean tree at session start; the CP-09-09-02 work is now committed to master, no feature branch)
- **Summary**: Designed and filed the issue-management mechanism (feature). Locked the design with the user, then wrote `ai/notes/issue-management-mechanism-design.md` (locked decisions + full implementation plan). Filed the first proper issue `ai/issues/open-P2-L-issue-management-mechanism.md` using the new template (dogfooded on itself), and filed the related `ai/issues/boot-up-should-create-required-ai-directories.md`. Also ran a full load-context (Procedure A) at session start and reviewed the repo for cross-machine resume readiness. Confirmed the design note belongs in `ai/notes/` (working spec) with the authoritative record deferred to `protocol-decisions.md` until implementation. No protocol files changed this session.
- **Key deliverables**: `ai/notes/issue-management-mechanism-design.md`; `ai/issues/open-P2-L-issue-management-mechanism.md`; `ai/issues/boot-up-should-create-required-ai-directories.md`; `ai/notes/notes.md` (user requirement capture).

## Checkpoint: CP-2026-09-10-01
- **Branch**: `master`, synced with origin at 2ead9bf at session start
- **Summary**: Simplified the issue filename convention before implementation: priority/size dropped from the filename (mutable, so they stay in the `Severity`/`Size` header fields only), `ai/issues/open-P2-L-issue-management-mechanism.md` renamed to `open-issue-management-mechanism.md`, design note updated (filename table + a future-kanban note on reading `Severity`/`Size` from the header), live references updated in `notes.md`/`context.md`/`next-steps.md` (historical entries in `progress.md` and the daily-checkpoint file left untouched, since they describe what was true at the time). Also documented the checkpoint commit-hash one-commit lag as expected/benign (a commit can't record its own hash) with light one-line additions to `ai-policy-common.md`, `AGENTS.md` Proof-of-Load step (d), and README.md's context-health table.
- **Key deliverables**: `ai/issues/open-issue-management-mechanism.md` (renamed); `ai/notes/issue-management-mechanism-design.md`; `ai/notes/notes.md`; `ai/policies/ai-policy-common.md`; `AGENTS.md`; `README.md`.

## Checkpoint: CP-2026-09-10-02
- **Branch**: `master`, synced with origin at 37e31e5 at session start
- **Summary**: Self-requested peer review of CP-2026-09-10-01 (`ai/code-review-reports/2026-09-10_11-08_review-01.md`, CHANGES REQUESTED) found 2 Major findings (protocol files edited without first fully loading `protocol-decisions.md`; no ADR entry added for the two decisions, breaking the file's established convention) and 3 Minor (two stale `context.md` bullets; inconsistent daily-checkpoint entry style). Fixed: `protocol-decisions.md` read in full (865 lines) and a new dated entry added; `context.md`'s "Branch" and "Daily checkpoints" bullets corrected; the CP-2026-09-10-01 daily-checkpoint entry rewritten to match the file's established Problem/Fix/Files-changed/Validation/Status structure.
- **Key deliverables**: `ai/shared/project-knowledge/protocol-decisions.md`; `ai/state/context.md`; `ai/daily-checkpoints/2026-09-10.md`.

## Checkpoint: CP-2026-09-10-03
- **Branch**: `master`, synced with origin at a60ecc7 at session start
- **Summary**: User asked why `protocol-decisions.md` had grown so long (865 lines) and requested consolidation without losing value. Analysed and presented options A (strip stale transient status notes)/B (condense pure-bookkeeping entries)/C (structural horizon shield); user approved A+B, declined C. Removed 7 stale "Not done in this session, pending commit" bullets and 2 stale "Key configuration values" snapshot blocks; condensed one pure-bookkeeping entry from 7 lines to 2. File: 865 -> 839 lines, plus a closing ADR entry documenting the cleanup itself. No decision, rejected alternative, or reversal content was dropped.
- **Key deliverables**: `ai/shared/project-knowledge/protocol-decisions.md`.
