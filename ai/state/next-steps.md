<!--
STATE-FILE: next-steps.md is the FUTURE. A forward-only backlog, not a history.
STATE-FILE: CHRONOLOGICAL ORDER. Oldest at the top, newest at the bottom. Append new items at the tail. Delete each item the moment it is done; never leave a ticked, checked, or struck-through entry. No history accumulates here.
STATE-FILE: KEEP LEAN. Short bullet items, one to two lines each. Not a runbook, plan, or ledger. No sub-bullets, command transcripts, or rationale. Use ai/shared/project-knowledge/ for durable detail.
-->
CP-2026-09-04-01

## Pending
- [ ] Document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (spec in notes.md).
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`.
- [ ] Create protocol design docs: Vision, PRD, and Delivery Ledger (ledger priority); ADRs = `protocol-decisions.md`; lean HLD, LLD per module (note: `ai/notes/protocol-routing-principle-and-consolidation-follow-up.md`).
- [ ] Work the multi-assistant + build AI team design (note: `ai/notes/multi-assistant-workflow-design.md`).
- [ ] Decide on and draft the refactoring/codebase-upgrade policy (note: `ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md`).
- [ ] Implement Procedure H (Grilling) + `ai-policy-grilling.md` (design in notes.md, ~50 lines, no external deps).
- [ ] Implement Procedure I (Agent Document Review) + `ai-policy-document-review.md` (design in notes.md, ~60 lines, no external deps).
- [ ] Consolidate the TIER 2 vs Non-Negotiables always-on canonical home (note: `ai/notes/protocol-routing-principle-and-consolidation-follow-up.md`).
- [ ] Policies→skills rename (ai/policies/→ai/skills/, `ai-policy-<name>.md`→`<name>.md`, Active Expertise→Active Skills; global dir + sync + loader + validator; change-request + HLD/LLD/ACs/Ledger; note: `ai/notes/policies-to-skills-rename-proposal-2026-09-04.md`). Coordinate with the TIER2 consolidation item above.
- [ ] Local-first knowledge retrieval proposal (source precedence in Investigation Contract; not "RAG"; note: `ai/notes/local-first-knowledge-retrieval-proposal.md`).

## Deferred
- [ ] (Breaking) Procedure E precedence rework: let resume read the latest checkpoint's authoritative state, not only the summary.
- [ ] (Separate project) AI-team dispatcher/watcher runtime and per-agent status files for true parallelism.
- [ ] (Revisit when parallel) Adopt per-agent status files before concurrent state-file writes (Scenario B, CP-2026-06-30-02); the board is not race-safe.

[MIGRATION-2026-08-08] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 — **Project AI State Files** resolves to ai/state/
