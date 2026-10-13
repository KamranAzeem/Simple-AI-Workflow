Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
URL:
Summary: Rewrite the Design Documentation Standards, Pre-Work Gate, and plan-depth in the common policy
Label:

Description:

Rework the design-documentation rules in `ai/policies/ai-policy-common.md`. The document-location move is a separate ticket.

Requirements:

- Chain: `Notes (in ai/notes) → Vision → PRD → HLD → LLD (with AC) → Risk and Gap Analysis (RSK-NNN) → ADRs → Delivery Ledger`.
- Write "LLD" as "LLD (with AC)" throughout; define "AC (Acceptance Criteria)" on first use. AC is a coupling, not a container: small work keeps AC without an LLD, and the Acceptance Criteria Quality gate stays.
- Add Risk and Gap Analysis before ADRs, tracked with an `RSK-NNN` ID.
- Casing: "Notes", "Delivery Ledger".
- ADRs record genuine design decisions only: decision, context, consequences. Never a changelog, diary, or command log. No external references such as commit hashes.
- New projects gather enough requirements to build an MVP, then iterate.
- Large solutions may use layered design docs: layer 1 is the bird's-eye view (major components, modules, subsystems); later layers detail each component.
- Depth is proportional and role-aware: small work is context plus acceptance criteria; medium, large, and architectural work gets the fuller stack. Note briefly how app developers, solution architects, and infrastructure engineers differ.
- Direct what-only rules, no why prose, no markdown tables in the policy file.

Acceptance criteria:

- The common policy states the chain, the LLD (with AC) coupling, Risk and Gap Analysis with RSK-NNN, the Notes/Delivery Ledger casing, the ADR decision-only rule, the MVP-first requirement, layering, and proportional depth.
- Pre-Work Gate and the Issue Management Protocol plan-depth use "LLD (with AC)" and reflect proportionality.
- Validator green; reference test PASS; markdownlint 0 on the edited files.

---
2026-10-12
Plan: `ai/plans/design-documentation-standards-rewrite-plan.md`.

---
2026-10-12
Closed on branch `feature/design-doc-standards`. Rewrote the Design Documentation Standards and aligned the Pre-Work Gate and the plan-depth rule to `LLD (with AC)`. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-21 APPROVED.
