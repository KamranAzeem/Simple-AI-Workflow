<!--
STATE-FILE: progress.md is the PAST. Append-only history of completed work.
STATE-FILE: CHRONOLOGICAL ORDER. Oldest at the top, newest at the bottom. Append new entries at the tail. Never insert, prepend, edit, delete, or reorder existing entries. The horizon shield archives the oldest entries when the file grows too long.
STATE-FILE: KEEP LEAN. Short bullet entries, one to two lines each. Not a runbook, plan, or ledger. No implementation steps, commands, investigation notes, or knowledge content. Use ai/shared/project-knowledge/ for durable knowledge.
-->
[CP-2026-05-06-01] Updated README.md with AGENTS.md update procedure.
[CP-2026-05-07-01] refactor(protocol): transition to layered customization and standardized knowledge naming.
[CP-2026-05-07-02] refactor(protocol): unify authoritative resources under 'Global' terminology in AGENTS.md.
[CP-2026-05-07-03] init(persona): set System Architect persona and compliance modules in ai-customization.md.
[CP-2026-05-08-01] refactor(terminology): standardized 'Global' and 'Project' scopes repository-wide.
[CP-2026-05-15-01] fix(git): recover diverged master and sync office+home changes.
[CP-2026-05-15-02] sync(agents-md): update AGENTS.md across all 10 project directories.
[CP-2026-05-15-03] analysis(agents-md): refactor proposal drafted and saved to artifacts.
[CP-2026-05-21-01] Protocol hardening for weak models and project-knowledge loading.
[CP-2026-05-21-02] Peer Review Mode implemented, all findings resolved, codebase 100% clean.
[CP-2026-05-21-03] Docs cleanup: remove protocol jargon; add peer review insights and GH Copilot comparison.
[CP-2026-06-18-01] Docs sync, policy cleanup, metadata header removal, validate-protocol v4.0, squash-merged and pushed.
[CP-2026-06-18-02] Context rot explanation and Keeping Context Healthy section added to README and slides; committed.
[CP-2026-06-18-03] Lean protocol / JIT loading on feature/lean-protocol-jit-loading-2026-06 (Global Knowledge JIT, stale refs removed, validator v4.1); reviews 01->02 APPROVED. Detail in protocol-decisions.md.
[CP-2026-06-19-01] Lean protocol feature branch squash-merged to master (5020005) + pushed; Protocol Developer Mode rule, no markdown hyperlinks in policies, validator v4.1. Detail in protocol-decisions.md.
[CP-2026-06-22-01] Verbose File Naming guardrail + on-demand ai-policy-codebase-examination.md (9ea1df8); README/slides/docs updated, validator 12 checks; reviews 01->02 APPROVED.
[CP-2026-06-22-02] Tracked ai/shared/ in git via .gitignore exceptions so protocol-decisions.md + coordination.md survive machine moves (888bdf6).
[CP-2026-06-22-03] Changed codebase-examination to triggered procedure (Procedure G); docs + protocol-decisions.md updated.
[CP-2026-06-22-04] Cleaned ai/ tracking: moved useful notes to knowledge, deleted 25 stale daily checkpoints / 11 reports / 8 notes; validator 8/8, HEAD 984647c.
[CP-2026-06-29-01] State File Proof-of-Read guardrail added to AGENTS.md (Procedure A Step 4/7f, Procedure C Fresh-Read); reviews 01->02 APPROVED; AGENTS.md uncommitted.
[CP-2026-06-30-01] Re-scoped Token Rationing to Project Knowledge only; full-load Settings/Global Knowledge/policies at boot; validator v4.3; reviews 01->02 APPROVED. On feature branch, NOT merged. Detail in protocol-decisions.md.
[CP-2026-06-30-02] Multi-agent state ownership + checkpoint-direction contract (single-writer, memory-to-disk, reconcile-not-overwrite); ownership policy + coordination-board model, validator v4.4, review-03 APPROVED. NOT merged. Detail in protocol-decisions.md.
[CP-2026-06-30-03] Finalized feature/boot-full-load-policies-and-global-knowledge, squash-merged to master (unpushed); single-writer by session identity, Scenario B referenced in next-steps; validator v4.4, review-04 APPROVED.
[CP-2026-07-04-04] Mega session: customization-at-root, sync auto-migration, Humanized Output, policy audit, v2.0.0 release (40 commits since v1.0.0); validator v4.5 8/8. Detail in protocol-decisions.md.
[CP-2026-07-25-01] Created ai-policy-career-coaching.md (4 expertise sub-domains consolidated); README/guide/slides/validator updated; 15 policies; review-01 APPROVED; uncommitted.
[CP-2026-07-25-02] Rewrote ai-policy-academic-researcher.md (internationalized, 342 lines); validator 8/8, review-02 APPROVED; uncommitted.
[CP-2026-07-25-03] Fixed academic-researcher.md stale cross-ref (§21->§20) + hardcoded tool name (-> [Tool/Vendor]); validator 8/8.
[CP-2026-07-31-01] Post-Compaction Recovery: renamed Procedure E, simplified reload, compaction signals, PreCompact hook, docs/slides; commits 58f22a4/4465a54/36de4b6; validator v4.6 8/8.
[CP-2026-08-02-01] Researched Kilo Code condensing (no PreCompact/PostCompact hooks; AGENTS.md always-on survives compaction); no trigger file needed; squash-merged f61a680 + pushed.

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/
[CP-2026-08-09-01] State-files directory release: moved 3 state files to ai/state/ with KEEP LEAN headers + guardrails, committed 9183c52, v2.1.0 release; Fedora 44 env setup; writing-style guide; context.md horizon shield (17->5, archived 12).
[CP-2026-08-21-01] Analysis-only: Protocol Developer Mode policy-loading bug (one sub-bullet fix), design docs gap, behavioral-prompt research (models game bare metrics 71-88% vs 83% with coaching); 6 next-steps items; no commits.
[CP-2026-08-22-01] Protocol Developer Mode policy-loading fix: 4 policy-scan Exception notes in AGENTS.md, reviews 01->02 APPROVED, b93741c + pushed (8ea243f). Detail in protocol-decisions.md.

[MIGRATION-2026-08-22] Local state reconciled with remote. Pulled 3 remote commits (b93741c, 8ea243f, 75bc1fc). Dropped stale local CP-2026-08-09-02 entries. Preserved local notes.md edit only.
[CP-2026-08-22-02] Session: remote pull + reconciliation (dropped stale CP-08-09-02), decision reversal recorded, notes consolidation, WaqarSb example, sync-agents-md.sh macOS BSD sed fix (db74e68). Detail in protocol-decisions.md.
[CP-2026-08-25-01] Merged 2 sessions (0383025, 1d71e95), v2.2.0 release; evidence full-read/no-truncation, external-mutation guardrail, state-file model split, Pre-Work Gate, AC Quality; validator 8/8. Detail in protocol-decisions.md.
[CP-2026-08-25-02] Full-file-read enforcement promoted to TIER 2 mandate, Proof-of-Load line counts, 6-item Non-Negotiables index; 16e11f1, v2.3.0 release, context.md horizon shield (archived 6); validator 8/8. Detail in protocol-decisions.md.
[CP-2026-08-25-03] Implemented research ideas 1+2+10 (intent-over-metrics, shared-understanding pre-work gate) + root-only scope; markdownlint-cli2 config, a2a5215; reviews APPROVED, validator 8/8.
[CP-2026-08-25-04] Cleanup + research: deleted habit-hooks file + 2 stale artifacts, removed 3 research-derived pending items, committed 2026-08-24 checkpoint; commits 1ae768c/d00b0e6/08a204a/47bd5dc/2bdc118.
[CP-2026-08-28-01] Analysis-only: Procedure G x3 codebase examination of mattpocock repos, 3 project knowledge files (1207 lines), proposed Procedure H/I; no commits.
[CP-2026-08-31-01] Protocol-tightening session: evidence-based investigation made default (two-layer: TIER 2 instruction + Investigation Contract); design-doc chain review gate; notes reorg; decisions recorded; squash-merged fc36781, pushed; review-02 APPROVED, validator 8/8.
[CP-2026-09-04-01] Condensed long state-file entries to keep-lean (ab5b7a4); analyzed + endorsed policies→skills rename (ai/policies/→ai/skills/, `ai-policy-<name>.md`→`<name>.md`, Active Expertise→Active Skills) — blast radius measured (16 files, 30 refs; freeze historical records), sequencing with TIER2 consolidation recommended, process = change-request + HLD/LLD/ACs/Ledger; not started. Detail in ai/notes/policies-to-skills-rename-proposal-2026-09-04.md.
