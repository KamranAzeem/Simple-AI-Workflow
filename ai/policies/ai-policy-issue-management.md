# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Issue Management

Govern the work-item tracker and the ticket rules.

## Triggers

- issue standards
- ticket standards

## Loading

- Mode: trigger

## Scope

- Apply this policy to every work item in the local tracker and in the user's external tracker.
- This policy owns the ticket storage, the fields, the content, the plan, and the work-item invariants.
- The common policy keeps the issue invariant and points here.

## Issue Management Protocol

Apply these rules to every work item.

### Ticket Storage

- Store a local ticket under `ai/issues/` in `open/`, `in-progress/`, or `closed/`.
- Treat the directory as the status of a local ticket and the tracker state as the status of an external ticket.
- Keep no file directly under `ai/issues/`.
- Use a lowercase kebab-case slug only.
- Do not add a status prefix or suffix.
- Move the file to change status.
- Do not rename the ticket when moving it.
- Do not add a status field.

### Ticket Fields

- Include `Reported`, `Reporter`, `IssueType`, `Severity`, `Size`, `URL`, `Summary`, `Label`, and `Description`.
- Set `IssueType` to `Feature`, `Defect/Bugfix`, `Improvement/Refactor`, `Documentation`, `Task`, or `Idea`.
- Set `Severity` to `P1`, `P2`, `P3`, or `P4`.
- Set `Size` to `S`, `M`, `L`, or `XL`.
- Set `Label` to empty, `Insufficient Information`, or `Unworkable`.
- Record the external ticket URL in `URL`.
- Keep `URL` empty until the ticket moves to an external tracker.
- Set `Severity` and `Size` to `Human-to-decide (AI estimate: ...)` when the user has not chosen them.

### Ticket Content

- Keep the active description short: decisions, outcomes, and blockers.
- Omit long paragraphs and command transcripts.
- Do not turn the ticket into a technical diary of commands, errors, and fixes.
- Put runbooks and command detail in Project Knowledge.
- Allow a long `## Implementation Plan` appendix in a closed ticket.
- File a ticket under `ai/issues/open/` by default, or in the user's external tracker when the user supplies an issue or asks for one.
- File a ticket immediately when the AI finds work worth tracking.
- Analyze the ticket for gaps before starting work.
- Fill every gap through brainstorming or grilling.
- File an idea with `IssueType: Idea`; grill it, then continue the normal steps or close it with a dated `Won't fix` note.
- Tell the user whether the ticket is workable when an external tracker has no label mechanism.
- Set `Label: Insufficient Information` or `Label: Unworkable` when the ticket is not workable.
- Refuse to work an unworkable ticket.

### Plan

- Create the plan under `ai/plans/` while the ticket stays in `open/`.
- Do not open a feature branch for planning.
- Name the branch to be created at implementation in the close sequence.
- Append or post the plan file name to the ticket as a dated entry.
- Treat the plan as a working artifact, not a design document.
- Bind every close action to its repo, base ref, branch, merge mode, ticket reference, release, baseline, and evidence in a `## Close Sequence` block.
- Bind the procedure actions to the plan's repos and branches.
- Treat a plan whose last action is an approval request as incomplete.
- Include an `## Evidence` section in every plan.
- Record sources, commands, results, confirmed facts, and open questions in the evidence section.
- Use context plus acceptance criteria for an `S` or `M` ticket.
- Use an HLD and an LLD with acceptance criteria for an `L` or `XL` ticket.
- Keep the HLD, LLD, and ADR content inside the plan file.
- Record each design decision as an ADR.
- Keep the plan concise.
- Set the plan depth by the Pre-Work Gate.
- Write the failing test first when the project uses TDD.
- Validate design and architecture decisions with the user during planning.
- Run independent peer review on every plan automatically.
- Use the severity definitions in the code-review contract (`## Severity Classifications`).
- Apply the blocking review gate in `ai-policy-code-review.md` to the plan review.
- Re-review after each fix.
- Announce the plan ready only after an `APPROVED` verdict.
- Implement only a plan that passed the blocking review gate.
- Record each review round and verdict in the plan's Peer Review Log.

### Plan Template

Use this literal template for every plan.

```markdown
# Plan: <title>

## Goal

## Evidence

## Depth

## Context

## Decisions (ADR)

## Deltas

## Acceptance Criteria

## Verification

## Peer Review Log

## Risks and Rollback

## Close Sequence
```

Each acceptance criterion has at least one behavioral assertion. More are allowed and the number is not capped. A behavioral assertion is an executable check that fails when the rule is absent or wrong, not a snapshot of AI prose. Static policy text may assert exact clauses; AI-generated plans and reviews assert structure and decisions.

### Work-Item Invariants

- The work-item order lives in PROCEDURE MANAGE-ISSUES and PROCEDURE IMPLEMENT-PLAN; do not restate it here.
- Treat one unit of work as one feature branch.
- Keep the plan, implementation, tests, documentation, release announcement, ADRs, ticket close, plan appendix, and checkpoint on that branch from implementation onward.
- Allow several commits on the branch; deliver one squash commit to trunk.
- Run the terminal gate before any merge claim: resolve the base ref from the plan, confirm the branch is at least one commit ahead, and confirm the tree is clean.
- Report a zero-commit branch or a dirty tree as unfinished work.
- Apply the blocking review gate in `ai-policy-code-review.md` to the implementation peer review before the commit.
- Attach the plan to the ticket before deleting the plan file.
- Write the checkpoint on the branch before the commit.
- Close the ticket with the merged change: move a local ticket to `closed/` in the branch commit, and close an external ticket when the merge lands.
- Do not make post-merge commits or post-merge repository changes.
- Do not commit a plan-only, start-work, or placeholder change to trunk.
- Commit the current planning records, including the plan and ticket, as a baseline chore commit before opening the implementation branch; the plan's Close Sequence names the baseline.
- Permit only that baseline chore commit as the exception to the no-pre-work rule.
- Treat the implementation request plus the Close Sequence as the explicit approval for the protected-branch baseline commit; `ai-policy-common.md` `- **Protected Branches**` is the approval gate.
- Verify a clean tree and the baseline path list before opening the implementation branch.
- Put release documentation in the branch; tag the release commit after the merge; publish the GitHub Release after the tag.
- Treat the work item as complete only when the ticket is closed with the plan attached, the checkpoint is written, the branch is merged and deleted, the trunk is pushed, and the release is tagged and published when the work carries a release.
- Use the template at `ai/knowledge/issue-template.md`; create it when missing and never overwrite it.

## References

- `ai-policy-common.md` (`## Issue Invariant`).
- `ai-policy-common.md` (`## Universal Operational Guardrails`).
- `PROCEDURE MANAGE-ISSUES` and `PROCEDURE IMPLEMENT-PLAN`.

<!-- AI-ASSISTANT: READ-ONLY END -->
