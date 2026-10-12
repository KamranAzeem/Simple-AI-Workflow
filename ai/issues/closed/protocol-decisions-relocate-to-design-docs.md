Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Relocate the protocol ADR store from ai/ to the protocol repo's design-docs/
Label:

Description:

The protocol's own ADR store is `ai/shared/project-knowledge/protocol-decisions.md`. Design documents live beside the code in `design-docs/`, never under `ai/`, so the store moves to the protocol repo's `design-docs/`.

Requirements:
- Move the store to `design-docs/protocol-decisions.md` at the protocol repo root, content unchanged.
- Update the live references: `AGENTS.md` (Protocol Developer Mode and the load steps), `ai-policies/ai-policy-meta.md` (rule 6), `docs/codebase-examination-guide.md`, `docs/simple-ai-workflow-slides.md`, `ai-customization.md`, and `ai/state/context.md`.
- Historical references (closed tickets, daily checkpoints) stay as records.
- Content cleanup to decisions-only is a separate ticket.

Acceptance criteria:
- The store lives at `design-docs/protocol-decisions.md`; no copy remains under `ai/`.
- The live references point to the new location; the validator and reference test stay green; markdownlint 0.

---
2026-10-12
Plan: `ai/plans/protocol-decisions-relocate-to-design-docs-plan.md`.

---
2026-10-12
Closed on branch `feature/relocate-adr-store`. Moved the store to `design-docs/protocol-decisions.md` and updated the live references. Verified: validator v6.0 8/8, reference test PASS, markdownlint 0 on the touched files. Peer review review-26 APPROVED.
