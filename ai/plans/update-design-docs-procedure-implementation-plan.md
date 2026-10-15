# Plan: Add the "update design documents" procedure

- Ticket: `ai/issues/in-progress/separate-update-design-docs-procedure.md`
- Date: 2026-10-15
- IssueType: Feature. Size: M. Severity: P3 (AI estimate).

## Context

Design documents (Vision, PRD, HLD, LLD with AC, Risk and Gap Analysis, ADRs, Delivery Ledger) are sensitive, self-standing artifacts. They never hold work logs, checkpoint targets, or version-control references. The checkpoint procedure never touches them (ADR 2026-10-13). A new confirmation-gated procedure handles them, invoked by the trigger `"update design documents"`.

## Scope

In scope:

- New `PROCEDURE UPDATE-DESIGN-DOCS` in `AGENTS.md` TIER TRIGGERED-PROCEDURES.
- New policy `ai/policies/ai-policy-design-docs.md`, loaded only on the trigger.
- Reload-indexing fix: post-compaction recovery and `STEP-CONTEXT-RE-AFFIRMATION` index design docs.
- Fix the "Delivery Ledger updated at every checkpoint" wording across the protocol.
- README, slides, workflow-guide, customization guide, and customization template updates.
- Validator baseline, reference-integrity test, and an ADR entry.

Out of scope:

- This repo's own `design-docs/protocol-decisions.md`.
- The deferred `protocol-design-docs.md`.
- A policy-as-skills refactor (noted as future work).

## HLD

- `HLD-001` Trigger and placement: `"update design documents"` (alias `"update design docs"`) runs a triggered procedure; the detail lives in a dedicated policy loaded only on the trigger.
- `HLD-002` Document model: fixed lowercase doc-type vocabulary; AC coupled to LLD; IDs per type.
- `HLD-003` Discovery and scope: boot design-docs index, doc-type vocabulary, project-knowledge fallback; scope from directory location; no manifest.
- `HLD-004` Location and migration: design-docs when migrated, project-knowledge otherwise; `"migrate design docs"` is the only cross-location mover; a firm decision may be recorded in the customization file.
- `HLD-005` Extraction: design files found in project-knowledge move, never copy; embedded content is extracted and a one-line pointer is left.
- `HLD-006` Write path and trust: propose, challenge, confirm per doc, then write concisely; refuse rather than corrupt.
- `HLD-007` Reload indexing: post-compaction recovery and checkpoint re-affirmation index global knowledge, project knowledge, and design docs (up to five levels).
- `HLD-008` Wiring: README and slides get a dedicated section and both triggers under common instructions; the workflow guide and customization guide are aligned.

## LLD (with AC)

- `LLD-001` `AGENTS.md` procedure `UPDATE-DESIGN-DOCS`, in TIER TRIGGERED-PROCEDURES, with 12 named steps:
  - `STEP-LOAD-DESIGN-DOCS-POLICY`, `STEP-DETERMINE-LOCATION`, `STEP-RESOLVE-SCOPE`, `STEP-FIND-DOCS`, `STEP-GATHER-DELTAS`, `STEP-PROPOSE-CHANGESET`, `STEP-CHALLENGE`, `STEP-CONFIRM`, `STEP-WRITE`, `STEP-UPDATE-LEDGER`, `STEP-OFFER-MIGRATION`, `STEP-REPORT`.
  - AC1: The procedure is defined once and every step name is unique and resolvable.
  - AC2: The procedure loads `ai-policy-design-docs.md` and never runs inside a checkpoint.

- `LLD-001b` `AGENTS.md` procedure `MIGRATE-DESIGN-DOCS`, the only cross-location mover, with steps `STEP-LOAD-MIGRATION-POLICY`, `STEP-FIND-UNMIGRATED-DOCS`, `STEP-CONFIRM-MIGRATION`, `STEP-MOVE-FILES`, `STEP-REPORT-MIGRATION`.
  - AC: A user who says `"migrate design docs"` gets a defined procedure that lists files, shows the git impact, and moves on approval.

- `LLD-002` Policy `ai/policies/ai-policy-design-docs.md` with the READ-ONLY guard and `READ-ONLY START` / `READ-ONLY END` markers. Content, list-based and concise:
  - Design-doc nature and purity rules.
  - Doc-type vocabulary and naming (suffix form, lowercase).
  - Discovery and scope (directory location, no manifest).
  - Location and migration (detect, offer once per session, acknowledge).
  - Extraction (move, never copy; one-line pointer for embedded content).
  - Confirmation and challenge flow, dry-run, refuse conditions.
  - Conciseness and per-type skeletons.
  - Ledger update rules.
  - AC3: The policy passes the validator markers and contains no markdown hyperlinks or tables.

- `LLD-003` `AGENTS.md` reload indexing:
  - `STEP-INDEX-KNOWLEDGE` in `PROCEDURE POST-COMPACTION-RECOVERY` indexes global knowledge, project knowledge, and every `design-docs/` up to five levels.
  - `STEP-CONTEXT-RE-AFFIRMATION` does the same.
  - A named load-report item reports the design-docs index.
  - AC4: After the change, both reloads name all three sets and the design-docs index is reported.

- `LLD-004` Ledger wording fix:
  - Replace "updated at every checkpoint" with "updated by the update-design-documents procedure when a design document changes" in `ai/policies/ai-policy-common.md`, `README.md`, `docs/workflow-guide.md`, and `docs/simple-ai-workflow-slides.md`.
  - AC5: No file states that the checkpoint updates the ledger.

- `LLD-005` User-facing docs:
  - README `## Common instructions` table: add `"update design documents"` and `"migrate design docs"`.
  - Slides: a dedicated design-docs section, and both triggers under commonly used instructions.
  - `docs/workflow-guide.md` section 15: fix the stale location and naming; add the new trigger.
  - `docs/ai-customization-guide.md` and the template `docs/ai-customization.md`: document the optional `## Design Docs` section with `**Location**:`.
  - AC6: User-facing text is in the user's voice, has no em dashes, and has no broken links.

- `LLD-006` Tooling:
  - Validator: add `design-docs` to the policy baseline, add an anchor check for the new procedure, bump the version string.
  - Reference-integrity test: confirm all new names resolve.
  - AC7: Validator is green, the reference test passes, and markdownlint reports zero issues on changed files.

- `LLD-007` ADR entry: a dated entry in `design-docs/protocol-decisions.md`, self-contained.
  - AC8: The entry exists and contains no commit hash, branch name, or report reference.

## ADRs

- `ADR-001` Trigger and placement: primary `"update design documents"`, alias `"update design docs"`; procedure name `UPDATE-DESIGN-DOCS`; detail in a dedicated policy loaded only on the trigger. Rationale: the feature is invoked rarely, so it must not sit in the always-loaded common policy.
- `ADR-002` Document model: fixed lowercase doc-type vocabulary (`vision`, `prd`, `hld`, `lld`, `risk-and-gap-analysis`, `delivery-ledger`, `adr-<nnn>-<short>`); AC stays coupled to LLD. Naming is suffix form; migrated docs use simple names, unmigrated docs use a project token.
- `ADR-003` Discovery and scope: scope comes from directory location, not the filename; discovery is a live scan plus the boot index; no manifest is kept.
- `ADR-004` Location and migration: detect migration state and write in place; offer migration once per session; record a firm user decision in `ai-customization.md` `## Design Docs` only on explicit instruction; otherwise record the detected decision in project knowledge.
- `ADR-005` Update versus migrate: the update procedure never crosses locations; `"migrate design docs"` is the only cross-location mover.
- `ADR-006` Extraction: move, never copy; a mixed source file keeps a one-line pointer to the extracted design doc.
- `ADR-007` Delivery Ledger: updated when a design document lands or changes, by the update procedure, never at checkpoint.
- `ADR-008` Reload indexing: design docs are JIT-indexed at boot, at post-compaction recovery, and at checkpoint re-affirmation, up to five levels.

## Acceptance criteria (ticket mapping)

- The trigger runs the procedure and it covers design docs only.
- Every proposed change is confirmed before it is written.
- No operational bookkeeping is written into a design document.
- The checkpoint never invokes the procedure.
- Validator green, reference test PASS, ADR entry added, peer review APPROVED.

## Verification plan

- `support-files/validate-protocol.sh` exits 0 with the new policy in the baseline.
- `support-files/test-protocol-references.sh` reports PASS.
- `markdownlint-cli2` on changed markdown reports zero issues.
- Manual link check on changed docs.
- Peer review report ends APPROVED.

## Risks

- The `design-docs` vocabulary could collide with an existing component directory name. Mitigation: scope is resolved by path, and an ambiguous match asks.
- Extending reload indexing could add boot cost. Mitigation: the scan is bounded to five levels and reads filenames only.
- User-facing sections must match the user's voice. Mitigation: a style pass before the review.

## Rollout

- Work on `feature/separate-update-design-docs-procedure`.
- Close the ticket as the final change on the branch, squash-merge to `master`, then delete the branch.
