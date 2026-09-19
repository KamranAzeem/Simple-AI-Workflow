<!-- State file (future). Open items only, oldest first, delete on done. Short bullets. Never drop an unfinished item. -->
## Pending
- [ ] Document Kilo Code support in post-compaction-reload-trigger-setup.md and compaction-trigger-problem.md (spec in notes.md).
- [ ] Sync updated AGENTS.md to other projects via `sync-agents-md.sh`.
- [ ] Create protocol design docs: Vision, PRD, and Delivery Ledger (ledger priority); ADRs = `protocol-decisions.md`; lean HLD, LLD per module (note: `ai/notes/protocol-routing-principle-and-consolidation-follow-up.md`).
- [ ] Work the multi-assistant + build AI team design (note: `ai/notes/multi-assistant-workflow-design.md`).
- [ ] Decide on and draft the refactoring/codebase-upgrade policy (note: `ai/notes/refactoring-and-upgrading-best-practices-2026-08-25.md`).
- [ ] Implement the Grilling procedure + policy (design in `ai/notes/grilling-procedure-design-note.md`).
- [ ] Implement the Agent Document Review procedure + policy (design in `ai/notes/agent-document-review-procedure-design-note.md`).
- [ ] Consolidate the TIER 2 vs Non-Negotiables always-on canonical home (note: `ai/notes/protocol-routing-principle-and-consolidation-follow-up.md`).
- [ ] Policies→skills rename (ai/policies/→ai/skills/, `ai-policy-<name>.md`→`<name>.md`, Active Expertise→Active Skills; global dir + sync + loader + validator; change-request + HLD/LLD/ACs/Ledger; note: `ai/notes/policies-to-skills-rename-proposal-2026-09-04.md`). Coordinate with the TIER2 consolidation item above.

## Deferred
- [ ] (Breaking) Procedure E precedence rework: let resume read the latest checkpoint's authoritative state, not only the summary.
- [ ] (Separate project) AI-team dispatcher/watcher runtime and per-agent status files for true parallelism.
- [ ] (Revisit when parallel) Adopt per-agent status files before concurrent state-file writes (Scenario B, CP-2026-06-30-02); the board is not race-safe.
- [ ] Bounded boot-time staleness heuristic for the local-first retrieval proposal (note: `ai/notes/local-first-knowledge-retrieval-proposal.md`).
