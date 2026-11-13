Reported: 2026-11-11
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL: <https://github.com/KamranAzeem/Simple-AI-Workflow/issues/6>
Summary: Add a handoff creation procedure, a creation review gate, and a dedicated handoff policy

Description:

The protocol defines a Valid Handoff and a claim lifecycle, but it has no procedure, trigger, required template, or review gate for creating one.

The settled design:

- Add `ai-policy-handoff.md` as the 19th policy. It owns the Valid Handoff definition, the ordered template, the creation review gate, the lifecycle, the authorization, and the conditional autonomy detail.
- Keep the always-on pointer in `ai-policy-common.md`. Refuse a handoff until the handoff policy is loaded and the definition is met.
- Add `ai/procedures/create-handoff.md` with the `create handoff` and `create a handoff` triggers. The draft lives in `ai/artifacts/handoffs/<handoff-slug>/`; the final handoff is `ai/shared/handoffs/<handoff-slug>.md`.
- Review the draft before the final file exists. The final handoff is written only after APPROVED.
- The receiver merges the branch when the review, the Verification, and the Conditional Autonomy conditions pass. The receiver does not write the three state files. The original orchestrator records the board and the handoff at the next checkpoint, then deletes the handoff.
- Internal by default. `## Outbound Content Scrub` applies only when the handoff leaves the project.
- No `AGENTS.md` change. The policy loads explicitly from the procedure and the receiver start phrases.
- The fence-aware policy-validator fix is a prerequisite.
- Release v6.5.0.

Plan attached below.

---
2026-11-13
Plan created. Peer review in progress.

---
2026-11-13
Plan peer review APPROVED. The plan is ready for implementation on `feature/handoff-procedure`. No branch is open and no implementation has started.

## Implementation Plan

> This is the approved plan, attached at implementation time. The dated ticket entries above record the implementation outcome.

# Handoff Procedure and Policy: Implementation Plan

**Ticket**: GitHub #6 at <https://github.com/KamranAzeem/Simple-AI-Workflow/issues/6>, mirrored as `ai/issues/open/handoff-creation-procedure.md`.
**Status**: Planning only. No branch, no implementation, no external writes.
**Size**: L.
**Merge mode**: `direct` (default; `ai-customization.md` has no `## Merge Policy`).
**Release**: v6.5.0 (minor).
**Approval**: The approved plan is the human approval to edit the read-only common policy and to add the new policy and procedure, per `ai-policy-meta.md`.

## Goal

Add a complete handoff creation path: a dedicated handoff policy, a creation procedure, a review gate that refuses an unworkable handoff, and a lifecycle that lets a receiver merge autonomously without breaking the single-writer rule.

## Settled decisions

- Split the handoff rules into `ai/policies/ai-policy-handoff.md`; keep the always-on pointer in the common policy.
- Move the whole `### Conditional Autonomy for Handoffs` section to the handoff policy; the common policy keeps the one-line exception pointer.
- No `AGENTS.md` change. The policy loads explicitly from the procedure and the receiver start phrases.
- The template is an ordered list in the handoff policy, not a fenced `##` block.
- The draft lives in `ai/artifacts/handoffs/<handoff-slug>/`. The final handoff is `ai/shared/handoffs/<handoff-slug>.md`.
- The creation review runs on the draft. The final handoff is written only after APPROVED.
- Resolution A: the receiver merges; the original orchestrator records the state.
- The handoff is internal by default. The outbound scrub applies only when it leaves the project.
- The fence-aware validator fix is a prerequisite.
- 19 policies, 14 procedures, 33 modules. Release v6.5.0.

## Scope

In scope:

- The new handoff policy.
- The common policy pointer and the branch-gating exception pointer.
- The new `CREATE-HANDOFF` procedure.
- The review gate.
- The lifecycle docs and the checkpoint cleanup.
- The fence-aware validator fix and its regression.
- The handoff fixture.
- The counts, docs, ADR, and release announcement.
- The `## Outbound Content Scrub` `### Procedure Use` bullet.

Out of scope:

- A change to `AGENTS.md`.
- A `LOAD-CONTEXT` auto-load.
- A new shared step.
- A new trigger in the policy.
- The TDD program beyond the handoff fixture.
- Updating the GitHub #6 body.

## HLD

Components:

- `ai/policies/ai-policy-handoff.md` owns the contract.
- `ai/policies/ai-policy-common.md` keeps the always-on pointer.
- `CREATE-HANDOFF` executes the contract.
- `RUN-PEER-REVIEW` provides the review gate.
- `WRITE-CHECKPOINT` records the completion and deletes the consumed handoff.
- `LOAD-CONTEXT` does not auto-load; the receiver start phrases load explicitly.
- `tests/` pins the template and the refusal.
- The ADR and the docs explain the behavior.

Ownership:

- The common policy owns the state-file single-writer rule and the outbound scrub.
- The handoff policy references them; it does not restate them.
- The procedure owns the steps.
- The review policy owns the review dimensions.
- The checkpoint owns the state-file writes.

Flow:

1. The user says `create handoff`.
2. The procedure loads the handoff policy and gathers the task, the receiver, the destination, and the authorization.
3. The procedure writes the draft under `ai/artifacts/handoffs/<handoff-slug>/`.
4. The review runs on the draft and returns APPROVED or CHANGES REQUESTED.
5. The author fixes and re-reviews until APPROVED.
6. The procedure writes the final handoff and reports the start phrases.
7. The receiver claims, executes, verifies, and merges.
8. The receiver records the board and the completion note.
9. The original orchestrator records the board and the handoff at the checkpoint, then deletes the handoff.

Failure behavior:

- Missing information: the review is CHANGES REQUESTED; no final handoff.
- A failed verification: the receiver does not merge; it reports and leaves the handoff.
- A destination outside the project: the scrub gate runs before the final handoff leaves.
- A missing handoff policy: the common policy pointer stops the claim until it is loaded.
- A missing file or command: the review is CHANGES REQUESTED.

## LLD with acceptance criteria

### 0. Fence-aware validator fix (prerequisite)

Changes in `support-files/validate-policy-authoring.sh`:

- Add a fence-aware heading extractor that ignores heading-like lines inside fenced code blocks.
- Use it for the `headings` field, the `domain_sections` list, and the trigger-block next-heading detection.
- Add a regression case in `tests/test-trigger-rules.sh`: a policy with a real `## Scope` and a fenced `## Example`; the index lists only the real headings.

Acceptance criteria:

- The common policy `--index` no longer lists `## PRD Requirements`, `## HLD Components`, or `## LLD Items`.
- The three fenced examples stay unchanged.
- The authoring validator and the trigger fixture pass.
- This is its own commit.

### 1. New handoff policy

Create `ai/policies/ai-policy-handoff.md`:

- `# AI Policy: Handoffs`, a one-line purpose, a `## Scope`, domain sections, a `## References`, and the READ-ONLY markers.
- No `## Triggers`.
- Owns the Valid Handoff definition, the ordered template list, the creation review gate, the authorization and merger contract, the lifecycle, the shared output path rule, the state-file and outbound scrub references, and the conditional autonomy conditions.

Template sections, in order:

1. Objective
2. Authorization
3. Read first
4. Scope
5. Starting facts
6. Steps
7. Binding rules
8. Shared output paths
9. Report back
10. Review
11. Verification

Acceptance criteria:

- The policy passes the authoring validator.
- The template is an ordered list, not a fenced `##` block.
- The policy references the common policy for the state-file and outbound rules.
- The policy has no triggers.

### 2. Common policy pointer

Changes in `ai/policies/ai-policy-common.md`:

- A2A item 4 becomes a pointer to `ai-policy-handoff.md` and the refusal until the policy is loaded.
- Move the whole `### Conditional Autonomy for Handoffs` section to `ai-policy-handoff.md`.
- Add one exception pointer at the end of the common policy's branch-gating rule: the handoff autonomy and its conditions are in `ai-policy-handoff.md`.
- `## References` gains `ai-policy-handoff.md`.
- `## Outbound Content Scrub` `### Procedure Use` gains `PROCEDURE CREATE-HANDOFF` for a handoff that leaves the project.

Acceptance criteria:

- The common policy is smaller by the handoff detail.
- The refusal and the branch-gating exception pointer remain always-on.
- The full autonomy conditions live only in `ai-policy-handoff.md`.
- The authoring validator passes.

### 3. New create-handoff procedure

Create `ai/procedures/create-handoff.md`:

- H1: `# PROCEDURE CREATE-HANDOFF: When the user says "create handoff"`.
- Triggers: `create handoff`, `create a handoff`.
- Steps:
  1. Load `ai-policy-handoff.md`.
  2. Gather the task, the receiver type, the author's parallel work, the destination, and the authorization.
  3. Create `ai/artifacts/handoffs/<handoff-slug>/` and write `handoff-draft.md` from the policy template.
  4. Run `RUN-PEER-REVIEW` on the draft. Fix Critical and Major findings and re-review until APPROVED.
  5. If the handoff leaves the project, apply `## Outbound Content Scrub`, show the scrubbed text and category report, and wait.
  6. Write the final `ai/shared/handoffs/<handoff-slug>.md` with the `## Review` line.
  7. Report the path and the start phrases: `load context`, `load ai-policy-handoff.md`, `claim and execute the handoff at <path>`.

Acceptance criteria:

- The procedure passes the authoring validator and the reference test.
- `create handoff` dispatches with no collision.
- The final handoff is not written before APPROVED.
- The procedure references the policy template by heading.

### 4. Review gate

Changes in `ai/procedures/run-peer-review.md`:

- Add a handoff scope: the draft, the read-first files, the verification commands, the template, the authorization, the scope, and the shared output paths.
- The reviewer is read-only.
- The review report goes to `ai/code-review-reports/`; a `review.md` in the working directory and the final handoff's `## Review` line record the verdict.

Acceptance criteria:

- The review answers "can a receiver start this task from the handoff alone?"
- A missing section, a missing file, an unrunnable command, or an unsafe authorization is a Critical or Major finding.
- The final handoff is created only after APPROVED.

### 5. Lifecycle and checkpoint cleanup

Changes:

- `docs/ai-agent-collaboration.md`: the full Valid Handoff definition, the lifecycle, the cleanup order, and remove "acting as the project-root orchestrator."
- `ai/procedures/write-checkpoint.md` `STEP-INBOUND-RECONCILE`: after recording a handoff completion note, delete the handoff.
- The receiver merges and reports; the original orchestrator records the state.

Acceptance criteria:

- No document says both "delete the handoff" and "append a completion note" without an order.
- The receiver does not write the three state files.
- The checkpoint deletes the consumed handoff.

### 6. Load path and no AGENTS.md change

Changes:

- `CREATE-HANDOFF` loads the policy.
- The receiver start phrases load the policy explicitly.
- The common policy pointer is the safety net.
- `LOAD-CONTEXT` does not auto-load the handoff policy.
- `AGENTS.md` is unchanged.

Acceptance criteria:

- `AGENTS.md` stays at 157 lines, 2,399 words, and 16,869 bytes.
- The handoff policy is not in `## Active Expertise`.
- A pending handoff is visible in `ITEM HANDOFFS`.

### 7. Tests, counts, docs, ADR, and release

Changes:

- New executable `tests/test-create-handoff.sh` and fixtures: a valid draft, an invalid draft, the refusal, the review gate, and the template sections.
- `tests/test-protocol-references.sh`: 14 procedures and the new step count.
- `support-files/validate-protocol.sh`: the `CREATE-HANDOFF` anchor, the `ai-policy-handoff.md` anchor, and the 19-policy baseline.
- `docs/protocol-validation-system.md`: 19 policies, 14 procedures, the handoff fixture, and the fence regression.
- `README.md`, `docs/workflow-guide.md`, and `docs/simple-ai-workflow-slides.md`: 18 to 19 policies, 13 to 14 procedures, and the handoff feature.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: the new counts and the handoff fixture.
- `ai/shared/project-knowledge/release-practices.md`: the count if it is the current pattern.
- `docs/multi-agent-runbook.md`: use the procedure and the review gate.
- `design-docs/protocol-decisions.md`: the ADR.
- `docs/announcements/v6.5.0.md`: the release announcement.
- The TDD ticket note: the handoff fixture is a phase 2 item delivered.

Acceptance criteria:

- The validator, authoring, reference, trigger, boot, knowledge, skills, scrub, and handoff fixtures pass.
- Markdownlint and shellcheck pass.
- The counts are 19 policies, 14 procedures, 33 modules, and 41 triggers.
- The ADR and the docs are updated.
- v6.5.0 is released.

## Top-level acceptance criteria

1. `ai/policies/ai-policy-handoff.md` exists and passes the authoring validator.
2. The common policy keeps the always-on pointer and the branch-gating exception pointer.
3. `CREATE-HANDOFF` dispatches with no trigger collision.
4. The draft is reviewed, and the final handoff is written only after APPROVED.
5. The template has all eleven sections in order.
6. The authorization approves the branch and the direct merge when the review, the Verification, and the Conditional Autonomy conditions pass.
7. The receiver does not write the state files; the original orchestrator records the state at the checkpoint.
8. The handoff is internal by default; the scrub applies only when it leaves the project.
9. `AGENTS.md` is unchanged.
10. The fence-aware validator fix and the regression pass.
11. The counts and the docs are updated.
12. v6.5.0 is released.

## Risks and mitigations

- A missed explicit load. Mitigation: the common policy pointer and the start phrases.
- The review is too heavy. Mitigation: a checklist and a read-only dry run; one round when the draft is complete.
- A reviewer who is not independent. Mitigation: a fresh subagent or session when available; state the limit otherwise.
- The state-file single-writer rule. Mitigation: the receiver merges only; the original orchestrator records.
- The fence fix changes the index. Mitigation: a regression fixture and the existing index tests.
- The count changes. Mitigation: the checklist and the validator.
- The policy split adds a load step. Mitigation: the explicit load and the common policy pointer.

## Evidence

Files read in full:

- `ai/policies/ai-policy-common.md` (879 lines), including A2A item 4 at line 73 and `### Conditional Autonomy for Handoffs` at line 57.
- `ai/policies/ai-policy-meta.md` (186 lines), including `### Procedure and Policy Authoring` at line 60.
- `ai/policies/ai-policy-code-review.md` (126 lines).
- `docs/ai-agent-collaboration.md` (74 lines).
- `docs/multi-agent-runbook.md` (167 lines).
- `support-files/validate-policy-authoring.sh` (580 lines).
- `support-files/validate-protocol.sh` (418 lines).
- `tests/test-trigger-rules.sh`, `tests/test-protocol-references.sh`, and `tests/test-load-context-boot.sh`.
- `AGENTS.md` (157 lines, 2,399 words, and 16,869 bytes).
- The GitHub issue #6 body.

Commands and results:

- `printf '## H2\n### H3\n#### H4\n' | grep -nE '^## '` returned only `## H2`. The regex does not match `###`.
- The fence-aware audit found fenced `##` headings in `ai/policies/ai-policy-career-coaching.md:76,79,84,89`, `ai/policies/ai-policy-code-review.md:87,90,93,96,99,102`, and `ai/policies/ai-policy-common.md:761,767,772`.
- The common policy `--index` lists `## PRD Requirements`, `## HLD Components`, and `## LLD Items` as headings. They are fenced examples.
- `wc -l -w -c AGENTS.md` returned 157 lines, 2,399 words, and 16,869 bytes.
- The current counts are 18 policies, 13 procedures, 31 modules, and 39 triggers.
- `gh issue view 6` showed the issue is open with the enhancement label.

Confirmed facts:

- `ai/policies/ai-policy-common.md` A2A item 4 defines the Valid Handoff as a `## Verification` section only.
- `docs/ai-agent-collaboration.md:34` says the receiver acts as the project-root orchestrator and reconciles the state files. That conflicts with the single-writer rule.
- `docs/ai-agent-collaboration.md:74` deletes the handoff and clears the claim; line 60 says to leave a note. The order is undefined.
- The handoff creation has no procedure and no trigger.
- `AGENTS.md` already supports `"use policy <name>"` and does not list procedures or policy names.
- The `ai/artifacts/` path is boot-excluded; `ai/shared/handoffs/` is in the `ITEM HANDOFFS` proof.

Open questions:

- None. The grilling settled the design.

## Close Sequence

- Repo: this project root.
- Base ref: `master`.
- Branch: `feature/handoff-procedure`.
- Merge mode: `direct`.
- Ticket: `ai/issues/open/handoff-creation-procedure.md`, with external issue #6.
- Release: v6.5.0 (minor).

Actions:

1. Open the branch before the first file change.
2. Implement the fence-aware validator fix and its regression as its own commit.
3. Implement the handoff policy, the common policy pointer, the procedure, the review scope, the lifecycle docs, the checkpoint cleanup, the tests, the docs, the ADR, and the announcement.
4. Run the implementation peer review. Fix every Critical and Major finding and re-review until APPROVED.
5. Attach the plan to the local ticket under `## Implementation Plan`. Replace the active plan link with `Plan attached below.`. Move the local ticket to `closed/`. Delete the plan file.
6. Run the checkpoint on the branch.
7. Commit the branch, keeping the fence fix as its own commit.
8. Squash merge to `master`, delete the branch, and push.
9. Tag and publish v6.5.0.
10. Post the closing comment on GitHub #6 and close it when the merge lands. Show the exact comment and wait for approval before posting.

Evidence for the terminal gate: the validator, authoring, reference, trigger, boot, knowledge, skills, scrub, and handoff fixtures; markdownlint; shellcheck; and an APPROVED implementation review.

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-13_20-30_review-32.md`, CHANGES REQUESTED, 1 Major.
- Round 2: `ai/code-review-reports/2026-11-13_20-31_review-33.md`, APPROVED, 0 Critical, 0 Major, 2 Minor.
