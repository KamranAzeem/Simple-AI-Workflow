Reported: 2026-10-13
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Clarify that a plan is not a design document and never lives under design-docs/
Label:

Description:

A plan is not a design document. While building an application or solution, you create actual design documents (vision, PRD, HLD, LLD (with AC), risk and gap analysis, ADRs) that live in `design-docs/`. When you work an issue, you create a plan against that issue, and the plan carries its own HLD, LLD, AC, and ADR content inside the plan file. The plan is temporary and its lifecycle is attached to the issue.

Consequences to state:
- A plan is not a design document.
- A plan lives under `ai/` (for example `ai/plans/`), never under `design-docs/`.
- The AI must not suggest moving plan files into `design-docs/`.

Observed: pulling the latest workflow and syncing to a real project, the AI suggested moving plan files from `ai/plans/` into `design-docs/`. This must not happen.

Placement: the Design Documentation Standards location rule (which defines what lives in `design-docs/`) and the Issue Management Protocol plan mandate (where plans are created, and where the error occurred).

Acceptance criteria:
- The common policy states that a plan is not a design document, that plans live under `ai/` and never in `design-docs/`, and that the AI must not suggest moving plans there.
- The plan mandate says the plan's HLD, LLD (with AC), and ADR content lives inside the plan file.
- Validator green; reference test PASS; markdownlint 0.

---
2026-10-13
Closed on branch `feature/plan-not-design-doc`. Added the "a plan is not a design document" rule to the Design Documentation Standards location rule and the Issue Management Protocol plan mandate. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS. Peer review review-30 APPROVED.
