Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Task
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Decide the ownership and activation of the universal engineering and testing standards versus the opt-in coding-baseline policy

Description:

**Context**: the coding-baseline unit of the plugin-extraction program (`extract-common-policy-sections-into-standalone-plugin-policies.md`). The unit table says to merge the common policy's 46 lines of Universal Engineering and Testing Standards into `ai-policy-coding-baseline.md`. The user deferred the unit on 2026-11-16 for a thorough investigation before any change.

**The conflict**:

- The 46 lines are always-on rules today: tests required, TDD first, lint and typecheck before done, and the engineering principles.
- `ai-policy-coding-baseline.md` is opt-in. It activates only through `coding-baseline` in `## Active Expertise` or by asking for the policy by name.
- The policy's Scope says: "Treat `ai-policy-common.md` as the owner of the engineering principles this policy applies." Merging the principles into the policy inverts that ownership.
- A straight merge either makes always-on rules opt-in, or forces the whole coding-baseline policy to load at boot. Neither is behavior-preserving.

**Options to investigate**:

1. Keep the universal standards in the common policy as invariants and skip the extraction. No behavior change; the program loses one unit.
2. Move the 46 lines to a new always-on policy, `ai-policy-engineering-standards.md`, with `Mode: boot`, and have the coding baseline point at it. No activation change, but a 23rd policy and no boot-payload reduction.
3. Merge the 46 lines into the coding baseline and make the coding baseline `Mode: boot`. Rejects the opt-in design and loads the whole policy at boot.
4. Merge the 46 lines into the coding baseline and keep it opt-in. Weakens the always-on rules.

**Questions**:

- Are the universal engineering and testing standards invariants, or task rules that may be opt-in?
- How much of the coding baseline does a user need before the opt-in is justified?
- What is the boot-payload cost of each option?
- Does the answer hold for a ten-line user project and for a large multi-repo project?
- Which docs, tests, policy count, and validator floor change per option?

**Acceptance criteria**:

- The chosen option is recorded in the parent extraction ticket and in an ADR.
- If the standards move, the target policy, the loading path, the common invariant, the validator anchors, the fixtures, the docs, and the policy count are updated and green.
- If they stay, the parent ticket records the decision and the unit is removed from the program scope.
- The program release does not ship while this ticket is open, because the parent release gate requires every unit to be resolved.

**Out of scope**: any code, policy, or validator change before the investigation concludes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai-policy-common.md` (`## Universal Engineering Standards`, `## Universal Testing Standards`), `ai-policy-coding-baseline.md`, `design-docs/protocol-decisions.md`.

---
2026-11-16
Resolved: the universal engineering and testing standards stay in the common policy, and the coding-baseline extraction is removed from the program scope. The reasons are recorded in the ADR and the parent ticket: most of the 45 lines are delivery and operational rules used by non-code work, the TDD rule is referenced by three domain policies on paths where the coding baseline is inactive, the Git Configuration template is used by bootstrap, and making the baseline mandatory would add 10.2 KB to every session and end the opt-in model. No policy change.
