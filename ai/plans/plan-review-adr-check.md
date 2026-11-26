# Plan: Catch a missing protocol ADR at plan review

## Goal

Close the authoring and review gap that let the grilling change ship without a protocol ADR entry. Clarify the plan rule and the review checklist so both point at the existing meta rule. Add no policy module, no trigger, and no duplicated rule. Ship PATCH v7.12.1.

## Evidence

- The grilling policy change (v7.12.0) shipped without a `design-docs/protocol-decisions.md` entry. The checkpoint caught it and the entry was added late.
- `ai/policies/ai-policy-meta.md:42` already applies the ADR entry rule to every protocol or policy change, and `:43` requires the `ADR-INDEX` line. The rule is not missing.
- `ai/policies/ai-policy-issue-management.md:82` says "Keep the HLD, LLD, and ADR content inside the plan file." The plan template's `## Decisions (ADR)` section is plan-local, so a reader can treat it as the protocol ADR entry.
- `ai/policies/ai-policy-code-review.md:66` is the procedural-completeness dimension. It checks the close actions and the terminal gate, not the protocol ADR entry.
- The `ADR-INDEX` gate in `tests/test-docs-audit.sh` compares the index to the headings that exist; it cannot detect a decision that should exist. Completeness needs the review.
- The live tree is 26 policies, 16 procedures, and 55 triggers. The fix adds no module and no trigger.

## Depth

S. Context plus acceptance criteria; no HLD or LLD is required.

## Context

The fix is two clarifications in existing rules, each pointing at the meta policy as the single source. The issue-management line removes the plan-local ambiguity for the author; the code-review line gives the reviewer a check. Neither restates the ADR rule, so the meta policy stays the one place that defines it. This is not a new policy layer.

The plan itself carries the protocol ADR entry and its index line, so the fix demonstrates the rule it adds.

Out of scope: a new policy module, a new trigger, a test that inspects the git diff, and a change to the meta policy rule itself.

## Decisions (ADR)

- ADR-1, fix at authoring and review, not with a new policy. The rule exists; the two stages need the pointer.
- ADR-2, reference the meta rule, do not restate it. Both new lines say "the meta policy's ADR entry rule" and leave the definition in one place.
- ADR-3, no diff-based test. The `ADR-INDEX` gate cannot detect a missing decision, and a test that reads the git diff is brittle at this boundary. A dry-run plan review is the check.
- ADR-4, PATCH v7.12.1. This is a process clarification; the lowest conservative version applies.
- ADR-5, the plan carries its own protocol ADR entry and index line.

## Deltas

`ai/policies/ai-policy-issue-management.md:82`:

- Replace "Keep the HLD, LLD, and ADR content inside the plan file." with "Keep the HLD, LLD, and plan-local ADR content inside the plan file. A plan that changes `AGENTS.md`, a policy, or a procedure also applies the meta policy's ADR entry rule."

`ai/policies/ai-policy-code-review.md:66`:

- Append: "For a plan that changes `AGENTS.md`, a policy, or a procedure, confirm the meta policy's ADR entry rule is satisfied by the plan and the diff. Report a missing entry as Major."

`design-docs/protocol-decisions.md`:

- Append the entry "2026-11-26: A policy change plan carries the protocol ADR entry" with the context and consequences.
- Add its `ADR-INDEX` line.

Release:

- `docs/announcements/v7.12.1.md`: new PATCH announcement. Point the README banner at it.
- `README.md`: banner v7.12.1 and the trigger-count line updated to v7.12.1.
- `tests/test-readme-shape.sh` and `tests/test-docs-audit.sh`: the v7.12.1 banner and announcement checks.

Record:

- Append the dated plan entry to the ticket now; close it in the branch commit with the plan attached.

## Acceptance Criteria

- AC-1: the plan rule distinguishes plan-local ADRs from the protocol entry and points at the meta rule. Assertion: `rg -n 'plan-local ADR|meta policy.s ADR entry rule' ai/policies/ai-policy-issue-management.md` matches.
- AC-2: the review checklist checks the entry for a policy or procedure change. Assertion: `rg -n 'meta policy.s ADR entry rule' ai/policies/ai-policy-code-review.md` matches.
- AC-3: no new policy module, trigger, or duplicated rule. Assertion: the policy count is 26, the procedure count is 16, the trigger count is 55, and `rg -n 'Apply the ADR entry rule' ai/policies` shows the meta policy only.
- AC-4: the plan's own protocol ADR entry and index line are present. Assertion: the entry exists in the store, its index line exists, and the docs audit passes.
- AC-5: a dry-run plan review works. Assertion: a hypothetical policy-change plan without the design-docs delta is flagged Major by the new review line; with the delta it passes. The dry run is recorded in the review.
- AC-6: the validation is green. Assertion: authoring and triggers PASSED, `validate-protocol.sh` 8/8, `tests/run-all.sh` 35/35, markdownlint 0.
- AC-7: the release is recorded. Assertion: the v7.12.1 announcement exists, the README banner links it, the annotated tag `v7.12.1` exists, and the GitHub Release is public.

## Verification

1. The `rg` checks from AC-1 to AC-3.
2. `bash tests/test-docs-audit.sh` and the ADR index check.
3. A dry-run plan review, recorded in the review.
4. `bash support-files/validate-policy-authoring.sh AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
5. `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
6. `bash support-files/validate-protocol.sh`.
7. `bash tests/run-all.sh`.
8. `markdownlint-cli2 'docs/**/*.md' '*.md' 'AGENTS.md' 'ai/issues/**/*.md'`.

PowerShell fixtures remain PENDING when `pwsh` is absent, as today.

## Peer Review Log

- 2026-11-26, review-203: CHANGES REQUESTED. One Minor: the code-review line did not set the severity for a missing ADR entry, and AC-5 expects Major. Fixed.
- 2026-11-26, review-204: APPROVED.

## Risks and Rollback

- Risk: the two lines feel like policy piling. Mitigation: both point at the meta rule and add no module, trigger, or duplicate rule; the counts are checked.
- Risk: the authoring line is read as allowing plan-local ADRs to replace the protocol entry. Mitigation: it says "plan-local" and then names the meta rule for a policy or procedure change.
- Risk: the dry run is manual. Mitigation: it is recorded in the review, and the plan review itself is a live test.
- Rollback: revert the two lines and the ADR entry on the branch before the merge; after the merge, fix forward on a new branch and ship a follow-up PATCH.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: commit the plan, the ticket update, the uncommitted v7.12.0 checkpoint, and the late grilling ADR correction as a chore baseline on `master` before opening the branch.
- Branch: `policy/plan-adr-check`.
- Ticket: close `ai/issues/open/plan-review-catch-missing-protocol-adr.md` in the branch commit with the plan attached under `## Implementation Plan`.
- Release: v7.12.1, PATCH. Write `docs/announcements/v7.12.1.md`, point the README banner at it, tag `v7.12.1` after the merge, push `master` and the tag, and publish the public GitHub Release.
- Evidence: the `rg` checks, the counts, the docs audit, the dry-run review, the authoring and trigger validators, `validate-protocol.sh` 8 of 8, `tests/run-all.sh`, and `markdownlint-cli2` 0 are recorded in the checkpoint and the review.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.
