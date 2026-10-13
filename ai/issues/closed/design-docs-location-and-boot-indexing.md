Reported: 2026-10-12
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
URL:
Summary: Store design docs beside the code in design-docs/, index them at boot, and offer an optional migration
Label:

Description:

Move design docs out of the AI directory to live with the code.

Requirements:

- Design docs live beside the code in `design-docs/`, never under `ai/`. Single repo: `design-docs/` at the project root. Multi-repo project root: each repo's docs in that repo's `design-docs/`, plus a solution-level rollup in the project-root `design-docs/`, holding links to each repo's ledger.
- The Delivery Ledger keeps its ID-tracked shape and lives in `design-docs/` (one per repo plus the rollup).
- Boot: always index `design-docs/` in the knowledge-indexing step, as a JIT index (filenames plus a short domain), loaded on demand. Scan bound: max 5 levels under the project root, prune heavy trees (`.git`, `node_modules`, `vendor`, `target`, and the like), skip archives. Record the index as a Proof-of-Load item.
- The boot rules must explicitly authorize scanning `design-docs` by name and nothing else.
- Migration is optional: at boot, detect design docs under `ai/shared/project-knowledge/` with no `design-docs/`, and offer to migrate. A `"migrate design docs"` helper moves them with approval and shows the git impact.

Acceptance criteria:

- The common policy states the `design-docs/` location rules and the Delivery Ledger location.
- `AGENTS.md` indexes `design-docs/` at boot and shows the Proof-of-Load item; the scan is bounded and authorized.
- The migration detection and the `"migrate design docs"` helper are stated.
- Validator green; reference test PASS; markdownlint 0 on the edited files.

---
2026-10-12
Plan: `ai/plans/design-docs-location-and-boot-indexing-plan.md`.

---
2026-10-12
Closed on branch `feature/design-docs-location`. Added the design-docs location and migration rules, the boot indexing step, the `ITEM DESIGN-DOCS-INDEX` Proof-of-Load item, and the unprompted-exploration exception. Verified: markdownlint 0, validator v6.0 8/8, reference test PASS (9 items). Peer review review-24 APPROVED.
