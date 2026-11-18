Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Move the knowledge protocols and file standards to a trigger-loaded plug-in

Description:

**Context**: the second of the six common extraction children in `extract-common-policy-sections-into-standalone-plugin-policies.md`. The unit table names the target, the trigger, the three loading procedures, and the size.

**Scope**:

- Create `ai-policy-knowledge.md` with the guard and markers, the title `# AI Policy: Knowledge`, a one-line purpose, `## Triggers` with `- knowledge file standards`, `## Loading` with `- Mode: trigger`, `## Scope`, the moved `## Global Knowledge Protocol`, `## Project Knowledge Protocol`, and `## Knowledge File Standards` sections, and `## References`.
- Move 140 lines: the global protocol, the project protocol, the ticket file scope, the file standards, the lookup, the retirement, the header literal, and the repair conservation contract.
- Keep a generic knowledge invariant in the common policy: read the Global AI Settings Directory in full at boot, index both knowledge stores at boot, load a file in full on demand, and the knowledge contract owns the standards.
- The boot payload does not shrink: the index step runs at every boot and loads the plug-in. The gain is modularity and the one-way boundary.
- Update the common policy's verbose-file-naming rule, which points at `## Knowledge File Standards`.
- Update `MANAGE-ISSUES`? No. Update `LOAD-CONTEXT` (index step), `WRITE-CHECKPOINT` (both knowledge updates), and `REPAIR-KNOWLEDGE-FILES` (the load step) to load the plug-in.
- Move the validator knowledge anchors and the legacy-phrase grep to the new policy.
- Move the knowledge fixture's policy anchors to the new policy and assert the common invariant, the trigger, the loading mode, and the three procedure loads.
- Raise the policy floor to 21.
- Add the ADR entry and update the current docs.
- No release.

**Out of scope**:

- Any change to the knowledge rules themselves.
- The skills section, which stays in the common policy.
- The issue-management, design-docs, coding-baseline, and thinking-modes children.

**Acceptance criteria**:

- The new policy passes the authoring validator and has the trigger, the trigger mode, and the moved rules.
- The common policy keeps a generic knowledge invariant and names no policy file outside the canonical header literal; its References stay two bullets.
- The common policy's verbose-file-naming rule no longer points at the moved section.
- The three procedures load the plug-in by name.
- The knowledge fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The validator knowledge anchors and the legacy-phrase guard point at the new policy.
- The policy count and the floor are 21.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the extraction.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/outbound-content-scrub-plugin-extraction.md`, `ai-policy-common.md`, `ai-policy-meta.md`, `tests/test-knowledge-repair-fixture.sh`, `support-files/validate-protocol.sh`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- The common policy held the global protocol, the project protocol, the ticket file scope, the file standards, the lookup, the retirement, the header literal, and the repair conservation contract.
- The Global Knowledge Protocol also carried the Global AI Settings Directory full load, which `STEP-LOADING` uses before the knowledge index step; it stays in the common invariant.
- The unit table names `ai-policy-knowledge.md`, the trigger `knowledge file standards`, and the three loading procedures.
- The validator anchors and the legacy-phrase guard pointed at the common policy; the knowledge fixture anchored the same rules there.
- The boot payload does not shrink: the index step runs at every boot and loads the plug-in. The gain is modularity and the one-way boundary.

## Red Run (T1)

`bash tests/test-knowledge-repair-fixture.sh --all` exited 1: the plug-in file was missing, the moved anchors failed, and the common invariant, the trigger, the loading mode, and the three procedure loads were absent.

## Green Run (T6)

- The knowledge fixture: PASSED, store files=5.
- `tests/run-all.sh`: 11 scripts pass.
- Protocol validator: 8/8, policy scan 21 with floor 21.
- Authoring: PASSED.
- Index: 35 modules, 21 policies, 14 procedures, 43 triggers, 0 conflicts, 0 errors.
- shellcheck clean; markdownlint 0.

## High-Level Design

- The knowledge protocols and standards move to a global plug-in. The common policy keeps a three-bullet `## Knowledge Invariant`: the settings full load, the boot index of both stores, and the contract pointer.
- The plug-in declares `Mode: trigger` with `knowledge file standards`; LOAD-CONTEXT, WRITE-CHECKPOINT, and REPAIR-KNOWLEDGE-FILES load it.
- The validator anchors and the knowledge fixture move. The policy count and floor become 21.

## Low-Level Design and Acceptance Criteria

- T1: the knowledge fixture moves its anchors to the plug-in and checks the common invariant, the trigger, the loading mode, and the three procedure loads.
- T2: `ai-policy-knowledge.md` exists with the guard, markers, title, purpose, trigger, trigger mode, scope, the moved rules minus the settings bullet, and references.
- T3: the common policy keeps the `## Knowledge Invariant` and the naming rule points at the knowledge contract.
- T4: the three procedures load the plug-in.
- T5: the validator anchors and the legacy-phrase guard move to the new policy.
- T6: the fixture and the suite are green.
- T7: the floor is 21; the validation doc, the verification-toolchain note, and the ADR are updated.
- T8: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The settings rule could move behind `STEP-LOADING`: it stays in the common invariant.
- The common naming rule could dangle: it points at the knowledge contract.
- The validator and the fixture could keep the old anchors: both move.
- The policy count could drift: the floor is 21.
- The repair conservation contract is large: moved verbatim and proven by the fixture.
- No release: the program release waits for all units.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the outbound pilot commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/knowledge-plugin-extraction.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_22-45_review-09.md`: APPROVED. Two planning traps fixed before implementation.
- Implementation round 2, `ai/code-review-reports/2026-11-16_23-05_review-10.md`: APPROVED. The duplicated settings-precedence bullet was removed.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the knowledge plug-in, the common invariant, the naming-rule pointer, the three procedure loads, the validator and fixture move, the floor at 21, the validation doc, the verification-toolchain note, and the ADR. The suite is green, and implementation review 10 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.
