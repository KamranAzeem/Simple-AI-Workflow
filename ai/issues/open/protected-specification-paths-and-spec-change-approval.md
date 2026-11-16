Reported: 2026-11-13
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Protect tests and specs from AI edits and require approval for spec changes

Description:

Problem: a test or spec is only a contract if the AI implementing the change cannot rewrite it to pass. Today the protocol has validators, fixtures, and peer review, but no rule or check prevents an implementation change from weakening a test or widening a spec. The parent TDD ticket adds specs; this ticket protects them.

Target layout (human decision, 2026-11-13):

- Tests live at the project-root `/tests/`.
- Specs live under `/design-docs/`, with the exact subpath decided with the parent ticket.
- `support-files/` stays thin: validators, sync scripts, and dev tooling only, with no tests.

Proposed mechanism (to mature):

- Declare protected paths in a policy: `/tests/` and the selected spec paths under `/design-docs/`.
- A change that is not itself a spec change must not modify a protected path.
- A plan lists its scope as a path allow-list. A changed path outside the allow-list, including any protected path, fails the gate.
- A spec change requires explicit human approval and an ADR entry in `design-docs/protocol-decisions.md`.
- Optionally, a hash manifest of spec files detects silent edits. Regenerate it only through an explicit trigger.

Non-goals:

- No runtime scripts; the protocol runtime stays script-free.
- No trust in the AI to self-approve a spec change.
- No rewrite of all tests in one pass.

Acceptance criteria:

- The protected paths are defined in a policy, and the policy says the AI must not edit them to make a test pass.
- A check fails when an implementation change touches a protected path without an approval marker.
- The spec-change path is documented: explicit human approval plus an ADR entry.
- A test proves the gate rejects an implementation change that modifies a spec.
- A legitimate spec change passes through the documented path.
- `validate-protocol.sh` (or the new gate) passes.
- The docs explain the red-first rule and the spec-change path.

Open questions:

- What is the approval marker: a plan section, a commit trailer, or a ledger entry?
- Is a hash manifest worth the friction, or is the path allow-list plus peer review enough?
- Does the gate run locally, in CI, or both?
- How does a spec change stay atomic with the implementation it enables?
- Who signs off on a spec change, and does that differ for an ADR-only change?

Related: `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `design-docs/protocol-decisions.md`, `support-files/validate-protocol.sh`.
