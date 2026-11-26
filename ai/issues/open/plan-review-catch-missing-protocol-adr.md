Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: The plan-local ADR section hides the required protocol ADR entry, and the plan review has no check for it, so a policy change can ship without a design-docs entry.

Description:

The grilling policy change (v7.12.0) shipped without a `design-docs/protocol-decisions.md` entry. The checkpoint caught it and the entry was added late.

The rule already exists:

- `ai/policies/ai-policy-meta.md:42` applies the ADR entry rule to every protocol or policy change.
- `ai/policies/ai-policy-meta.md:43` requires the `ADR-INDEX` line.

The gap is authoring and review, not a missing rule:

- `ai/policies/ai-policy-issue-management.md:82` says "Keep the HLD, LLD, and ADR content inside the plan file." The plan template's `## Decisions (ADR)` section is plan-local, and a reviewer can read it as satisfying the protocol ADR rule.
- `ai/policies/ai-policy-code-review.md:66`, the procedural-completeness dimension, checks the close actions but not the protocol ADR entry.

Proposed fix, two clarifications that reference the existing rule:

1. `ai/policies/ai-policy-issue-management.md:82`: distinguish plan-local ADR content from the protocol entry. A plan that changes `AGENTS.md`, a policy, or a procedure also adds the `design-docs/protocol-decisions.md` entry and its `ADR-INDEX` line.
2. `ai/policies/ai-policy-code-review.md:66`: for a plan that changes `AGENTS.md`, a policy, or a procedure, confirm the plan and the diff carry the protocol ADR entry and its index line.

No piling:

- No new policy module, no new trigger, no duplicated rule. Both lines point to the meta policy as the single source.
- The policy count stays 26, the procedure count stays 16, and the trigger count stays 55.

Acceptance criteria:

- The issue-management plan rule distinguishes plan-local ADRs from the protocol entry and names the design-docs file and the index line for a policy or procedure change.
- The code-review procedural-completeness dimension checks the protocol ADR entry for a policy or procedure change.
- No new policy module, trigger, or duplicated rule; the counts stay 26/16/55.
- A dry-run plan review of a policy change without the design-docs delta fails, and with it passes.
- The v7.12.1 ADR entry and index line exist; the docs audit passes.
- Authoring and triggers PASSED; suite 35/35; markdownlint 0.

Related: the grilling ADR correction and the v7.12.0 checkpoint are uncommitted and will ride this ticket's baseline.

---
2026-11-26
Filed from the grilling ADR gap. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/plan-review-adr-check.md` (S). Decision: two clarifications that point at the meta rule; no new module, trigger, or duplicate rule; PATCH v7.12.1. Peer review pending; no branch yet.
