Reported: 2026-11-09
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L for design and pilot; XL as a full program)
Label:
URL:
Summary: Verify procedure behavior through TDD or spec-driven acceptance tests, then extend to the whole protocol

Description:

Problem: the protocol is verified for shape, not behavior. The validators, the reference test, and the 43-case trigger fixture prove that modules are well-formed and that the trigger namespace is sound. Nothing proves that following a procedure produces its intended artifacts: state-file writes, header and size rules, diary appends, ticket transitions, dispatch choices, the recovery refusal to read state files, and failure handling. A change can pass every check and still alter behavior silently. "If you cannot verify it, do not ship it" is not satisfiable for most procedures today.

Idea: drive procedure behavior through TDD or spec-driven development. Specify the observable contract of a procedure, write a failing acceptance scenario, then change the procedure until the scenario passes.

Proposed direction (to mature):

- Treat a procedure's observable contract as its spec: trigger and inputs, preconditions, side effects, postconditions, invariants, and failure modes.
- Test behavior with scenario fixtures. Run a procedure against a throwaway fixture project with a workflow clone, then assert on artifacts, not prose. Assert canonical headers, ordering, sizes, required sections, ticket moves, dispatch decisions, and refusal paths.
- Keep the runtime script-free. Dev-time tests live at the project-root `/tests/`. The `support-files/` directory stays thin: validators, sync scripts, and other dev tooling only, with no tests. Moving the current test scripts out of `support-files/` is part of this work.
- Extend the existing fixture pattern; `support-files/test-trigger-rules.sh` is the precedent.
- Pilot three procedures with observable artifacts: WRITE-CHECKPOINT, POST-COMPACTION-RECOVERY, and MANAGE-ISSUES. Expand only after the pattern proves itself.

Scope expansion (2026-11-13, human decision):

- Goal: bring the whole protocol under spec-driven development, slowly and in steps, not in one pass.
- Tests live at the project-root `/tests/`.
- Specs live under `/design-docs/`, alongside the design documents they describe. Candidate form: one spec per policy section or procedure, with the exact layout decided during planning.
- `support-files/` stays thin and minimal: as few files as possible, and no tests.
- Specs are read-only to the AI during implementation. The AI must not weaken or rewrite a test or spec to make it pass. See the child ticket for the protection mechanism.
- Every protocol change names the failing test it will make pass (red first). A smoke subset runs per change; the full suite runs before a release tag.
- Testability split: mechanical invariants gate every change; behavioral scenarios use fixtures; judgment stays with peer review. Do not assert prose.
- Phases:
  1. Inventory the existing invariants and map each to a test.
  2. Cover state-file headers and chronology, issue schema, handoff validity, scrub fixtures, and ADR per change.
  3. Add behavioral fixtures for dispatch and refusal.
  4. Add protected-path enforcement.
  5. Require a failing test in every protocol-change plan.
- Risks: brittle prose tests, the AI optimizing the checker (Goodhart), spec drift away from the policy, and cost per change. Mitigate with structure-level assertions, a link from each spec to the policy section it guards, a fast smoke subset, and a sanctioned spec-change path.

Open questions to resolve before planning:

- Where exactly do specs live under `/design-docs/`, and how do they relate to Vision, PRD, HLD, LLD, and the Delivery Ledger?
- What is the spec format: a contract section per module, a generated manifest, or a separate spec file?
- How deterministic must an LLM-run scenario be? Define the invariants and the repeat count; never assert prose.
- What is the gate and the cost? A smoke subset per change, the full suite before a release tag, and who runs it.
- What does "verify" mean per artifact class? Structure to a validator, behavior to a scenario, judgment to peer review.
- How are the existing tests migrated from `support-files/` to `/tests/` without breaking the validator anchors, docs, and sync scripts?

Scope: this ticket covers the design and a pilot, not a rewrite of all procedures. The full-protocol program is phased and delivered through child tickets.

Related: `ai/issues/open/protected-specification-paths-and-spec-change-approval.md`, `ai/issues/open/protocol-design-docs.md`, `design-docs/protocol-decisions.md`, `ai/shared/project-knowledge/protocol-verification-toolchain.md`, `support-files/test-trigger-rules.sh`.

---
2026-11-13
The `/tests/` structural move is delivered as step 0 of `ai/plans/outbound-content-scrub-implementation-plan.md`. The phases below start from the new layout. This ticket still owns the test strategy, the protected-spec mechanism, and the phased coverage.

---
2026-11-13
The handoff validity fixture is delivered as part of the handoff work at `tests/test-create-handoff.sh`, which covers a phase 2 item. The phases below start with the handoff fixture in place.
