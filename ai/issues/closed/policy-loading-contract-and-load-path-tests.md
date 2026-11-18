Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L; breakdown T1 to T10 in the plan)
Label:
URL:
Summary: Define the ## Loading contract, enforce it in the authoring validator, and add load-path behavior tests

Description:

**Context**: child of `protocol-procedure-tdd-spec-driven-verification.md` and the prerequisite for the plugin-extraction program. The extraction ticket records it as the first unit: it owns the loading shape in the meta policy, `tests/test-policy-load-paths.sh`, the shape wrapper, and the scenario spec template.

**Problem**: plugin loading is prose today. `CREATE-HANDOFF` says it loads `ai-policy-handoff.md`, and nothing checks the name. The validator checks file shape, not whether a declared load path exists. Once rules move out of the always-loaded common policy, a wrong path silently drops the rule. This child builds the declaration and the test that make the load path checkable.

**Decisions settled in grilling (2026-11-16)**:

- One optional `## Loading` section. Placement: after the one-line purpose when there is no `## Triggers`, after `## Triggers` when there is one, and always before `## Scope`.
- Absent `## Loading` means legacy behavior: boot load, and triggers still work as today. No existing policy file is edited in this child.
- One declared path per policy. `Mode: trigger` requires at least one Triggers bullet. Every other mode forbids `## Triggers`.
- Grammar, one key per line:

```text
## Loading
- Mode: boot|trigger|procedure|expertise
- Load in: <procedure-file-stem>
```

- `Load in:` is required when `Mode: procedure` and forbidden for every other mode. The value is the lowercase kebab file stem, for example `manage-issues`.
- `Mode: auto` is dropped permanently. Its runtime meaning was never defined, and `boot` and `procedure` cover the real cases.
- Adding a non-trigger mode to a policy that has triggers requires deleting the triggers, because the one-path rule forbids both. Document this in the custom-policy howto.
- The grammar has two owners: the meta policy states the meaning as a normative literal, and the validator enforces keys, modes, and placement. A fixture proves they agree.
- Specs are a separate class from design documents. They live under `design-docs/specs/`, one page, six headings. The `"update design documents"` restriction does not cover them.
- Replace the hardcoded policy list and 19-policy count in `support-files/validate-protocol.sh` with a directory scan.
- `--index` prints the declared mode and the correct scope: `project` for a project path, not the current hardcoded `global`.

**Artifacts**:

1. `ai-policy-meta.md`: the `## Loading` grammar, placement, and one-path rule inside `## Procedure and Policy Authoring`.
2. `support-files/validate-policy-authoring.sh`: accept the optional slot; validate keys, modes, placement, and the trigger and `Load in` relations; exclude `## Loading` from the domain-section list at line 250 so it cannot satisfy the domain-section rule; named errors. It does not resolve `Load in:` targets; that is the test's job.
3. `tests/test-policy-load-paths.sh`: the six assertions, run against temporary fixture policies with failing cases first. It resolves `Load in:` against an explicit procedure root.
4. `tests/test-policy-shape.sh`: runs the authoring validator over every policy, procedure, and `AGENTS.md` so a new file cannot skip the shape rules. `tests/run-all.sh` runs every test script for the gate.
5. `design-docs/specs/spec-template.md` and `design-docs/specs/policy-loading-contract.md`. The second is the template's first use.
6. `support-files/validate-protocol.sh`: the dynamic baseline.
7. Docs and slides: `README.md`, `docs/how-policies-work-in-this-workflow.md`, `docs/ai-customization-guide.md`, `docs/protocol-validation-system.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, and the loading-grammar section of `docs/custom-policy-howto.md`.
8. `ai/shared/project-knowledge/protocol-verification-toolchain.md`: new commands, counts, and fixtures.

**Load-path assertions**:

- every `Load in:` names an existing procedure module file;
- every `Mode: trigger` policy has at least one `## Triggers` bullet;
- `--index` prints the mode and the correct scope for a project path;
- a malformed Loading fails with a named error: unknown mode, unknown key, `Mode: procedure` without `Load in:`, `Load in:` with another mode, or `Mode: trigger` with no trigger;
- an absent Loading stays valid;
- every policy file named inside a procedure module exists.

**Red-first order**: write the failing load-path test and the failing shape cases, run them, record the failures, then add the grammar, the validator, the baseline change, the template, and the docs.

**Out of scope**:

- Converting the 19 existing policies to declare Loading; each converts when its unit touches it.
- Trigger-dispatch behavior changes and plugin loading itself.
- Migrating existing project policies; the boundary child and the program own that.

**Acceptance criteria**:

- The validator accepts the widened layout and rejects every malformed Loading with a named error.
- The six assertions pass, and the failing run before implementation is recorded in the plan.
- No existing policy declares `## Loading`; the handoff policy's prose `## Loading` heading is renamed to `## Load Behavior`, its content unchanged.
- `validate-protocol.sh` passes with a directory-scan baseline and a floor that catches mass deletion.
- `tests/run-all.sh` runs every test script, and the ADR entry exists in `design-docs/protocol-decisions.md`.
- `--index` reports mode and scope; 41 triggers, 0 conflicts, 0 errors.
- Both test scripts are in `tests/`; `tests/test-policy-shape.sh` covers every policy and procedure.
- The spec template exists and is used by the load-path spec.
- Docs, slides, and the verification-toolchain knowledge file are updated.
- Full suite green: validators, all fixtures, shellcheck, and markdownlint.

**Delivery**: first commit on `feature/plugin-extraction`. No trunk merge, tag, or release until the user's live test on the actual project passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/open/protocol-procedure-tdd-spec-driven-verification.md`, `ai-policy-meta.md`, `ai-policy-common.md`, `design-docs/protocol-decisions.md`, `support-files/validate-policy-authoring.sh`, `support-files/validate-protocol.sh`.

---
2026-11-16
Plan written; plan attached below. It carries the baseline evidence, the grammar, the validator rules, the six assertions, the red-first order, the docs scope, and the delivery gate. Peer review is next, before any implementation.

---
2026-11-16
Plan review round 1: CHANGES REQUESTED (`ai/code-review-reports/2026-11-16_21-07_review-01.md`). Resolved in the plan and this ticket: file existence moved to the load-path test; `Mode: auto` deferred; ADR task added; dynamic baseline gains a floor; the one-path migration note added; `Load in:` form aligned; suite runner added; `Mode: expertise` scope stated; breakdown recorded. Round 2 pending.

---
2026-11-16
Dropped `Mode: auto` permanently by user decision. It had no defined runtime behavior, and `boot` and `procedure` cover the real cases. The v1 modes are `boot`, `trigger`, `procedure`, and `expertise`. The parent extraction ticket records the removal.

## Implementation Plan

## Evidence

- Repository: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, base `master` including `f612a64`.
- Branch: `feature/plugin-extraction`, created and pushed; it tracks `origin/feature/plugin-extraction`.
- `bash support-files/validate-protocol.sh`: passed 8/8, exit 0. Step 6 scans the policy directory with a floor of 19.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/*.md ai/procedures/*.md`: `PASSED`.
- `bash support-files/validate-policy-authoring.sh --index ai/policies/*.md ai/procedures/*.md`: `modules=33|policies=19|procedures=14|triggers=41|conflicts=0|errors=0`.
- `AGENTS.md` passed to `--index` is counted as a policy module: 34 modules, 20 policies.
- Four policies declare `## Triggers`: `api-backend`, `cloud`, `data`, `dba`.
- `ai-policy-handoff.md` used `## Loading` as a prose section heading. It is renamed to `## Load Behavior` so the reserved declaration heading is free. No other policy uses `## Loading`.

## Red Run (T1)

Before the validator change, `bash tests/test-policy-load-paths.sh` exited 1:

- Nine invalid cases were accepted by the validator: unknown mode, unknown key, missing Mode, procedure without `Load in:`, `Load in:` without procedure mode, trigger mode without a trigger, triggers on a non-trigger mode, duplicate Loading, and placement after Scope.
- The index oracle printed no mode field, so both index assertions failed.
- The five valid cases and the two repository path checks passed.

## Green Run (T8)

- `bash tests/run-all.sh`: 10 scripts pass.
- `bash support-files/validate-protocol.sh`: 8/8; policy directory scan reports 19 with floor 19.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/*.md ai/procedures/*.md`: PASSED.
- `--index`: 33 modules, 19 policies, 14 procedures, 41 triggers, 0 conflicts, 0 errors; every policy reports `mode=legacy` and `global`.
- shellcheck: clean on every changed script.
- markdownlint: 0 issues on the changed markdown set.
- Floor proof in a repository copy: 20 policies pass; 18 fail with the floor error.
- The fixture covers eleven invalid forms, including an invalid `Load in:` value, a duplicate `Load in:`, and prose before Loading.

## High-Level Design

- Add one optional `## Loading` section to the policy shape. It is metadata, like `## Triggers`, and sits below it.
- Declare exactly one load path per policy: `Mode: boot`, `Mode: trigger`, `Mode: procedure`, or `Mode: expertise`.
- `Mode: auto` is dropped permanently.
- `Mode: procedure` carries `Load in: <procedure-file-stem>` in lowercase kebab, matching `ai/procedures/<name>.md`.
- Enforce the shape in the authoring validator. Publish the grammar in the meta policy. Prove them equal with fixtures.
- Add a load-path test that resolves every declared path against an explicit root, and a shape wrapper that validates every policy and procedure.
- Ship one scenario spec template and use it for the load-path contract.

## Low-Level Design and Acceptance Criteria

**T1. Failing load-path test, red first.** `tests/test-policy-load-paths.sh` builds fixture policies under `ai/policies/`, resolves `Load in:` against an explicit root, and asserts the six checks. The failing run is recorded above.

**T2. Authoring grammar.** `ai-policy-meta.md` defines placement, the key set, the four modes, the one-path rule, and `Load in:`. The handoff policy's prose `## Loading` heading is renamed `## Load Behavior`.

**T3. Validator enforcement.** The optional slot is accepted; syntax and placement are checked; trigger and `Load in:` relations are enforced; Loading is excluded from the domain-section list; the validator does not resolve `Load in:` targets. Named errors cover unknown mode, unknown key, duplicate Mode, duplicate `Load in:`, duplicate section, invalid `Load in:` value, missing or forbidden `Load in:`, trigger-mode without a trigger, triggers on a non-trigger mode, and placement.

**T4. Shape wrapper and suite runner.** `tests/test-policy-shape.sh` validates every policy, procedure, and `AGENTS.md`, and proves a broken fixture fails. `tests/run-all.sh` runs every test script.

**T5. Index and dynamic baseline.** `--index` prints the mode and the scope. `validate-protocol.sh` scans the policy directory with a floor of 19.

**T6. Spec template and first spec.** `design-docs/specs/spec-template.md` and `design-docs/specs/policy-loading-contract.md` exist; the design-docs policy exempts specs.

**T7. Docs and slides.** README, the policy docs, the workflow guide, the slides, the custom-policy howto, and the verification-toolchain knowledge file are updated with the validated-now, honored-later split.

**T8. Full gate.** Both validators, `tests/run-all.sh`, shellcheck, and markdownlint are green.

**T9. ADR entry.** The Loading contract decision is recorded in `design-docs/protocol-decisions.md`, and the removal is recorded in the extraction ticket.

**T10. Review and commit.** Implementation reviews 03 and 04: CHANGES REQUESTED then APPROVED. The change is committed on `feature/plugin-extraction`.

## The Six Load-Path Assertions

- every `Load in:` names an existing `ai/procedures/<name>.md`, resolved by the test against an explicit root;
- every `Mode: trigger` policy has at least one Triggers bullet;
- `--index` prints the mode and the correct scope for a project path;
- a malformed Loading fails with the expected named error;
- an absent Loading stays valid;
- every policy file matching `ai-policy-*.md` named inside a procedure module exists.

`Mode: expertise` is declaration-only in v1. The validator does not read `ai-customization.md`, and the load-path test records the missing check as a known gap.

## Risks and Mitigations

- Prose and checker drift: the fixture is the tie-breaker.
- The domain-section gap: Loading is excluded and a real domain section is still required.
- Policy-count baseline: a directory scan with a floor catches a retirement.
- Scope reporting: computed from the path.
- Docs drift: markdownlint gates it.
- Migration trap: a non-trigger mode forbids triggers; the howto documents the deletion step.
- Removed mode: `auto` is dropped permanently.
- Heading collision: the handoff policy's prose heading is renamed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `master` at the tracking commit.
- Branch: `feature/plugin-extraction`, pushed to origin.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/policy-loading-contract-and-load-path-tests.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test on the actual project passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Round 1, `ai/code-review-reports/2026-11-16_21-07_review-01.md`: CHANGES REQUESTED. Five Major findings, all resolved.
- Round 2, `ai/code-review-reports/2026-11-16_21-10_review-02.md`: APPROVED. Minors fixed in the same round.
- Implementation round 3, `ai/code-review-reports/2026-11-16_21-30_review-03.md`: CHANGES REQUESTED. One Major: the docs claimed the loader honors the declaration now. Resolved with the validated-now, honored-later split. Minors resolved.
- Implementation round 4, `ai/code-review-reports/2026-11-16_21-34_review-04.md`: APPROVED.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the `## Loading` grammar, the validator, the index mode and scope, the dynamic baseline with a floor, the load-path fixture, the shape wrapper, the suite runner, the spec template and first spec, the docs and slides, the custom-policy howto, and the ADR. The full suite is green, and implementation reviews 03 and 04 ended APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.

---
2026-11-16
Project-policy loading behavior is dropped from the program. The declaration governs global policies, which already load through Active Expertise, a trigger phrase, boot, or an explicit procedure load. A project policy keeps the legacy boot load. The docs, the spec, and the ADR now state this, and no loader unit is added.
