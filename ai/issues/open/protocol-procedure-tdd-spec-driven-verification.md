Reported: 2026-11-09
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Verify procedure behavior through TDD or spec-driven acceptance tests

Description:

Problem: the protocol is verified for shape, not behavior. The validators, the reference test, and the 43-case trigger fixture prove that modules are well-formed and that the trigger namespace is sound. Nothing proves that following a procedure produces its intended artifacts: state-file writes, header and size rules, diary appends, ticket transitions, dispatch choices, the recovery refusal to read state files, and failure handling. A change can pass every check and still alter behavior silently. "If you cannot verify it, do not ship it" is not satisfiable for most procedures today.

Idea: drive procedure behavior through TDD or spec-driven development. Specify the observable contract of a procedure, write a failing acceptance scenario, then change the procedure until the scenario passes.

Proposed direction (to mature):

- Treat a procedure's observable contract as its spec: trigger and inputs, preconditions, side effects, postconditions, invariants, and failure modes.
- Test behavior with scenario fixtures. Run a procedure against a throwaway fixture project with a workflow clone, then assert on artifacts, not prose. Assert canonical headers, ordering, sizes, required sections, ticket moves, dispatch decisions, and refusal paths.
- Keep the harness dev-time only under `support-files/`; runtime stays script-free.
- Extend the existing fixture pattern; `support-files/test-trigger-rules.sh` is the precedent.
- Pilot three procedures with observable artifacts: WRITE-CHECKPOINT, POST-COMPACTION-RECOVERY, and MANAGE-ISSUES. Expand only after the pattern proves itself.

Open questions to resolve before planning:

- Where does the contract live? A generated test manifest, a `## Contract` section in each module, or the procedure body as the only source. A second normative source risks drift.
- How deterministic must an LLM-run scenario be? Define the invariants and the repeat count; never assert prose.
- What is the gate and the cost? A smoke subset per change, the full suite before a release tag, and who runs it.
- What does "verify" mean per artifact class? Structure to a validator, behavior to a scenario, judgment to peer review. Every shipped procedure should name its method.

Scope: design and pilot only. No change to the dispatch model, no runtime scripts, and no rewrite of all procedures in one pass.

Related: `design-docs/protocol-decisions.md`, `ai/shared/project-knowledge/protocol-verification-toolchain.md`, `support-files/test-trigger-rules.sh`.
