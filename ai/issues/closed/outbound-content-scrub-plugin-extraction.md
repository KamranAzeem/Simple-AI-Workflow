Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Move the outbound content scrub rules to a trigger-loaded plug-in and leave a generic invariant in the common policy

Description:

**Context**: the pilot of the six common extraction children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The unit table names the target, the trigger, the three loading procedures, and the generic invariant.

**Scope**:

- Create `ai-policy-outbound-content-scrub.md` with the guard and markers, the title `# AI Policy: Outbound Content Scrub`, a one-line purpose, `## Triggers` with `- outbound content scrub`, `## Loading` with `- Mode: trigger`, `## Scope`, the moved `## Outbound Content Scrub` rules, and `## References`.
- Move the 64 lines of rules from the common policy: destination classes, always remove, keep, detection, placeholders, approval and report, override, non-text artifacts, and procedure use.
- Keep the `## Outbound Content Scrub` heading in the common policy with a generic invariant: remove secrets and identifying data before any artifact leaves the project; the outbound-content-scrub contract owns the classes and the detailed rules.
- Update `MANAGE-ISSUES`, `IMPLEMENT-PLAN`, and `CREATE-HANDOFF` to load the plug-in explicitly and apply `## Outbound Content Scrub`.
- Update `tests/test-outbound-content-scrub.sh`: the class and secret anchors move to the plug-in, the common policy gains the invariant check, and the trigger, loading, and procedure loads are asserted.
- Clarify the loading contract: a declaration states the self-declared path, and a procedure may load a policy explicitly. This is the first policy that uses both the trigger and explicit procedure loads.
- Add the ADR entry and update the current docs.
- No release. The program release waits until every unit is done.

**Out of scope**:

- Any change to the scrub rules themselves.
- Any other extraction child.
- Any release, tag, or trunk merge.

**Acceptance criteria**:

- The new policy passes the authoring validator and has the trigger, the trigger mode, and the moved rules.
- The policy count is 20, and `support-files/validate-protocol.sh` raises the floor to 20.
- The common policy keeps the `## Outbound Content Scrub` heading and a generic invariant, and its boundary rule still passes: no policy file name outside the canonical header literal, and References still two bullets.
- The three procedures load the plug-in by name.
- The scrub fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The loading clarification is in the meta policy, the spec, and the docs.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the pilot extraction and the loading clarification.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/policy-loading-contract-and-load-path-tests.md`, `ai/issues/in-progress/common-policy-boundary-cleanup.md`, `ai-policy-common.md`, `ai-policy-meta.md`, `tests/test-outbound-content-scrub.sh`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The common policy held the section at lines 119 to 182: the intro and nine `###` subsections.
- The unit table names the target, the trigger `outbound content scrub`, the three loading procedures, and the pilot role.
- The three procedures referenced the section: MANAGE-ISSUES line 13, IMPLEMENT-PLAN line 13, CREATE-HANDOFF line 12.
- The scrub fixture asserted the section and the class details in the common policy.
- The validator anchor at `validate-protocol.sh:68` requires the heading in the common policy.
- The common boundary rule allows no `ai-policy-*.md` name outside the canonical header literal, and References must stay two bullets.
- The loading contract allows one declared mode; explicit procedure loads are instructions. The pilot is the first policy to use both, so the contract gains one clarifying sentence.

## Red Run (T1)

`bash tests/test-outbound-content-scrub.sh` exited 1 before the change: the plug-in file was missing, so the section, Class A, Class B, the secret rule, the trigger, and the loading checks failed; the common policy still held the class details; and the three procedures did not name the plug-in.

## Green Run (T8)

- `bash tests/test-outbound-content-scrub.sh`: PASSED.
- `bash tests/run-all.sh`: 11 test scripts pass.
- `bash support-files/validate-protocol.sh`: 8/8, policy scan 20 with floor 20.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/*.md ai/procedures/*.md`: PASSED.
- `--index`: 34 modules, 20 policies, 14 procedures, 42 triggers, 0 conflicts, 0 errors.
- shellcheck: clean.
- markdownlint: 0 issues.

## High-Level Design

- The rules move to a global plug-in. The common policy keeps the heading and one generic invariant, so the protocol anchor and the three procedure pointers stay valid.
- The plug-in declares `Mode: trigger` with `outbound content scrub`, and the three procedures load it by name and apply the section.
- The scrub fixture moves its rule anchors to the plug-in, asserts the common invariant, and proves the trigger, the loading declaration, and the three procedure loads.
- The loading contract states that a declaration is the self-declared path, and a procedure may load a policy explicitly.

## Low-Level Design and Acceptance Criteria

- T1: the fixture moves the rule anchors, adds the common invariant and the class-detail absence, and asserts the trigger, the loading mode, and the three procedure loads.
- T2: `ai-policy-outbound-content-scrub.md` exists with the guard, markers, title, purpose, trigger, trigger mode, scope, moved rules, and references; the floor rises to 20.
- T3: the common policy keeps the `## Outbound Content Scrub` heading and one generic invariant, losing about 60 lines.
- T4: the three procedures load the plug-in by name.
- T5: the meta policy, the loading spec, and the howto record the explicit-procedure-load clarification.
- T6: the scrub fixture and the suite are green.
- T7: the docs and the ADR record the pilot and the clarification.
- T8: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The common heading stays, so the validator anchor and the procedure pointers remain valid.
- The trigger mode plus explicit procedure loads could read as two paths: the clarification states the distinction.
- The boundary rule could break if the common invariant names the file: it names only the contract.
- The fixture could keep stale anchors: it moves every rule anchor to the plug-in.
- No release: the program release waits for all units.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the boundary commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/outbound-content-scrub-plugin-extraction.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_22-05_review-07.md`: APPROVED.
- Implementation round 2, `ai/code-review-reports/2026-11-16_22-18_review-08.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the plug-in, the common invariant, the three procedure loads, the loading clarification, the fixture move, the floor at 20, the docs, and the ADR. The suite is green, and implementation review 08 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.
