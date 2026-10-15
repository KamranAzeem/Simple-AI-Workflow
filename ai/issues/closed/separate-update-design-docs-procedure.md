Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Add a careful, confirmation-gated "update design docs" procedure

Description:

Design documents are sensitive and must stay pure. They hold the design of the application or a component, never operational bookkeeping such as commit hashes or session trivia, and they must not be touched without the user's explicit permission. This is why they are out of scope for the consolidated "checkpoint" (`consolidate-checkpoint-updates-into-one-command.md`).

This ticket adds a standalone `"update design docs"` procedure that:

- Handles design documents only. It never updates project knowledge or global knowledge.
- Finds the design documents wherever they live: `ai/shared/project-knowledge/` (not yet migrated), or `design-docs/` at the project root or in a component or repo subdirectory.
- Proposes every change and waits for the user's explicit confirmation before writing anything.
- Never writes operational bookkeeping (commit hashes, branch names, session trivia) into a design document.

Acceptance criteria:

- A new trigger runs the procedure, and it covers design docs only.
- Every proposed change is confirmed with the user before it is written.
- No operational bookkeeping is ever written into a design document.
- The checkpoint never invokes this procedure.
- Validator green; reference test PASS; ADR entry added; peer review APPROVED.

---
2026-10-13
Pre-work analysis (readiness check). The ticket is a good seed but not yet workable; a plan cannot be written from it as-is. Captured so far: the why, the trigger `"update design docs"`, four core behaviors, and five acceptance criteria.

Gaps to resolve before it is workable:

- Where it lives: a new procedure in `AGENTS.md` TIER TRIGGERED-PROCEDURES, or a policy file.
- The procedure name and its step list.
- Which design documents it covers (the chain: Vision, PRD, HLD, LLD (with AC), Risk and Gap Analysis, ADRs, Delivery Ledger) and how it chooses.
- The find mechanism (naming conventions, the boot `design-docs/` index, the `project-knowledge/` fallback, multi-repo), and behavior when none exist or several do.
- What "the work to fold in" means, and whether a last-synced point is tracked.
- The confirmation flow: per change, a proposed diff, or a batch.
- Idempotency: does it remember what it already synced.
- Whether it adds ADRs and updates the Delivery Ledger.
- Scope bound and failure or abort behavior.
- Docs sync (workflow guide, README, slides).

Not labelled `Insufficient Information` because the gaps are fillable with the user. Next step when picked up: Brainstorming, then Grilling, then the plan.

---
2026-10-15
Work started. Brainstormed and grilled the design to convergence; all gaps are closed. Plan: `ai/plans/update-design-docs-procedure-implementation-plan.md` (carries the HLD, the LLD with AC, and the ADRs).

Key decisions: trigger `"update design documents"` (alias `"update design docs"`); procedure `UPDATE-DESIGN-DOCS` in `AGENTS.md` with detail in a new `ai/policies/ai-policy-design-docs.md`; lowercase suffix doc-type vocabulary; scope from directory location with no manifest; update writes in place and `"migrate design docs"` is the only cross-location mover; extraction moves, never copies; the Delivery Ledger updates on design-doc change, not at checkpoint; post-compaction recovery and the checkpoint re-affirmation index design docs.

Next: plan review, then implementation on `feature/separate-update-design-docs-procedure`.

---
2026-10-16
Implemented and peer-reviewed. Delivered: `PROCEDURE UPDATE-DESIGN-DOCS` (12 steps) and `PROCEDURE MIGRATE-DESIGN-DOCS` (5 steps) in `AGENTS.md`; new policy `ai/policies/ai-policy-design-docs.md`, loaded only on the trigger; the update/migrate trigger split; design-doc JIT indexing added to post-compaction recovery and the checkpoint re-affirmation; and the Delivery Ledger moved off the checkpoint to the update procedure.

Docs synced: README common instructions plus a "Design documents" section, two slides, workflow-guide sections 15 and 22, the customization guide and template (`## Design Docs`), and the comparison-doc policy counts. Plan: `ai/plans/update-design-docs-procedure-implementation-plan.md`. ADR recorded in `design-docs/protocol-decisions.md`.

Verified: validator v6.1 8/8, reference test PASS (11 procedures, 79 steps), markdownlint 0, no broken links. Peer review APPROVED. Closed as the final change before the squash merge.
