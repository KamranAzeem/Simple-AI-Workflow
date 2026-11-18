Reported: 2026-11-16
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Remove every per-policy reference from the common policy and rewrite it to the authoring standard

Description:

**Context**: first unit of the plugin-extraction program (`extract-common-policy-sections-into-standalone-plugin-policies.md`), after the external loading-contract prerequisite. The program model is one-way: a plug-in may reference the common policy, and the common policy never references a plug-in. This child establishes that boundary.

**Scope**:

- Rewrite the title to `# AI Policy: Common Guardrails`.
- Fix the guard and marker spacing: one blank line between the guard sentence and the `READ-ONLY START` marker.
- Replace every per-policy reference with a generic invariant:
  - the handoff autonomy line in the branch-gating section;
  - the handoff refusal line in A2A item 4;
  - the design-docs ownership line in the design-document section;
  - the code-review severity line;
  - the coding-baseline ownership line;
  - the References list.
- Exempt the canonical state-file header literal: it names the source file by design and is copied verbatim into every state file.
- Limit `## References` to `AGENTS.md` and the procedure layer.
- Remove the handoff policy's line "Rely on the always-on pointer in the common policy when the policy has not been loaded."
- Remove the validator's legacy common-title exemption for `# AI Assistant Policy:`.
- Add a dev-time fixture, `tests/test-common-boundary.sh`, that pins the title, the Reference whitelist, the no-policy-name rule, the handoff line removal, and the old-title rejection.
- Add the ADR entry.

**Out of scope**:

- Any section extraction. The behavioral prose stays in the common policy.
- Any `AGENTS.md` change.
- Any loader behavior. The loading contract governs global policies; project policies keep the legacy boot load.
- The six common extraction children and the five legacy children.

**Acceptance criteria**:

- The common policy contains no `ai-policy-<name>.md` reference, in a path or a bare name, outside the canonical state-file header blocks.
- `## References` lists only `AGENTS.md` and the procedure layer.
- The title is `# AI Policy: Common Guardrails`, with the guard and marker spacing fixed.
- The handoff policy no longer relies on the common pointer.
- The validator rejects a common policy carrying the old title.
- The new fixture fails before the change and passes after it; `tests/run-all.sh` is green.
- The authoring and protocol validators pass; shellcheck and markdownlint are clean.
- The ADR entry records the boundary rule, and the validation-system doc, the verification-toolchain file, the howto, and the slides note the one-way rule and the new fixture.

**Delivery**: on `feature/plugin-extraction`; no trunk merge, tag, or release until the user's live test passes.

Related: `ai/issues/open/extract-common-policy-sections-into-standalone-plugin-policies.md`, `ai/issues/in-progress/policy-loading-contract-and-load-path-tests.md`, `ai-policy-common.md`, `ai-policy-handoff.md`, `ai-policy-meta.md`, `support-files/validate-policy-authoring.sh`, `design-docs/protocol-decisions.md`.

## Implementation Plan

## Evidence

- `ai/policies/ai-policy-common.md` line 6 was `# AI Assistant Policy: Common Guardrails & Contracts`; line 3 was the guard sentence and line 4 the START marker, with no blank line between them.
- Per-policy references: line 53 and line 63 (`ai-policy-handoff.md`), line 249 (`ai-policy-design-docs.md`), line 419 (`ai-policy-code-review.md`), line 639 (`ai-policy-coding-baseline.md`), and the References list at lines 861 to 866.
- `ai-policy-handoff.md` line 88 carried the common-pointer line.
- The validator accepted `# AI Assistant Policy:` for the common file only.
- The canonical state-file header blocks name `ai-policy-common.md` four times as their source; the boundary rule exempts them because they are a normative literal copied verbatim into every state file.
- Baseline: 19 policies, 14 procedures, 41 triggers, 10 test scripts, protocol validator 8/8.

## Red Run (T1)

`bash tests/test-common-boundary.sh` exited 1 before the change: the old title, the missing blank line, five prose policy names plus the canonical header self-references, a seven-bullet References list without `AGENTS.md` or the procedure layer, the handoff common-pointer line, and the validator's acceptance of the legacy title.

## Green Run (T7)

- `bash tests/test-common-boundary.sh`: PASSED, nine checks.
- `bash tests/run-all.sh`: 11 scripts pass.
- `bash support-files/validate-protocol.sh`: 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/*.md ai/procedures/*.md`: PASSED.
- `--index`: 33 modules, 19 policies, 14 procedures, 41 triggers, 0 conflicts, 0 errors.
- shellcheck: clean on the validator and the new fixture.
- markdownlint: 0 issues on the changed markdown set.

## High-Level Design

- The common policy is the invariant layer. It names no policy file, no domain, and no plug-in.
- A bare policy name is a reference, even without a directory.
- The handoff refusal stays generic in the common policy; the handoff contract owns the definition and the authorization.
- The title and spacing move to the authoring standard, and the validator stops accepting the legacy title.

## Low-Level Design and Acceptance Criteria

- T1: the `tests/test-common-boundary.sh` fixture pins the title, the blank line, the no-policy-name rule outside the canonical header blocks, the two-bullet References list, the handoff pointer removal, and the old-title rejection.
- T2: the title is `# AI Policy: Common Guardrails`, and the START marker has a blank line above it.
- T3: the five prose references become generic invariants.
- T4: References lists only `AGENTS.md` and the procedure layer.
- T5: the handoff common-pointer line is removed.
- T6: the validator's legacy title exemption is removed.
- T7: the ADR, the validation-system doc, the verification-toolchain file, the howto, and the slides record the one-way rule and the fixture.
- T8: the implementation review is APPROVED, the branch is green, and no trunk merge occurs.

## Risks and Mitigations

- The generic wording weakens the handoff refusal: the handoff contract still owns the definition, and the common policy keeps the refusal mandate.
- A bare name slips through: the fixture scans for bare names outside the canonical header blocks.
- The canonical header names the file by design: the fixture excludes the header blocks, and the ADR records the exemption.
- The validator exemption removal rejects a legacy title: no project copies policies; the clone updates with the branch.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- Base ref: `feature/plugin-extraction` at the loading-contract commit.
- Branch: `feature/plugin-extraction`.
- Merge mode: none for this child. Commits stay on the program branch.
- Ticket: `ai/issues/in-progress/common-policy-boundary-cleanup.md`, stays open until the program merge.
- Trunk merge, tag, and release: deferred until the user's live test passes.
- Evidence: the Evidence, Red Run, Green Run, and Peer Review Log sections.

## Peer Review Log

- Plan round 1, `ai/code-review-reports/2026-11-16_21-45_review-05.md`: APPROVED. Minor findings fixed.
- Implementation round 2, `ai/code-review-reports/2026-11-16_21-52_review-06.md`: APPROVED. The canonical header exemption is recorded; the blockquote stays for a later extraction child.

---
2026-11-16
Implementation complete on `feature/plugin-extraction`: the common title, the guard spacing, five generic reference replacements, the two-bullet References list, the handoff pointer removal, the validator exemption removal, the boundary fixture, the ADR, and the docs. The suite is green, and implementation review 06 is APPROVED. The ticket stays in-progress until the program merge; no trunk merge, tag, or release until the live test passes.
