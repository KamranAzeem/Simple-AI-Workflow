Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: One ticket, one branch, one squash commit; plans carry evidence and automatic review, and attach to the ticket at close.

Description:

**Decision scope**

- Treat a local ticket as one unit of work on one feature branch.
- Keep the plan, implementation, tests, documentation, release announcement, ADRs, ticket close, plan appendix, and checkpoint on that branch.
- Require an `## Evidence` section in every plan.
- Run plan peer review automatically until no Critical or Major finding remains.
- Attach the final plan to the ticket at close and delete the plan file.
- Prohibit post-merge commits for a local work item.
- Tag the release commit after the merge; keep release documentation in the branch.

---

2026-10-28
Plan attached below.

**Original discussion**

## What was observed

After the descriptive-names feature was squash-merged, `master` showed two commits in a row:

- `f311fe7` feature(protocol): rename procedures, steps, and tiers to stable kebab names (the feature squash)
- `7d733b3` chore(ai): record the naming rename merge and remove the plan (a post-merge housekeeping commit)

The second commit did two things: appended the ADR "Merge record" to `protocol-decisions.md`, and deleted the executed plan from `ai/plans/`.

## Root cause

The protocol currently forces this second commit:

- The plan's Process step says "After merge, remove this executed plan from `ai/plans/`."
- The ADR convention appends a "Merge record" containing the squash SHA, for example "Squash-merged ... as `f311fe7`".
- Neither can happen before the merge, because the squash SHA does not exist until after the squash.

So every feature leaves one or more maintenance commits on `master`, separate from the feature itself.

## Why this may not be a problem

- The history is already consolidated: the feature is a single squash commit, and the housekeeping commit is small and rare (one per feature).
- The SHA in the ADR merge record is a useful audit trail linking a decision to the exact commit that implemented it.
- `7d733b3` is also the record that the plan was removed, which is arguably worth keeping.
- Rewriting history to remove such commits has its own cost and risk, especially once pushed.

## Why it may be a problem

- The user considers these "maintenance type small little commits" as noise on `master`.
- The branch is the natural unit of work. Everything the branch produces (plan removal, ADR completion, ticket close) arguably belongs inside the squash, not after it.
- The ticket already closes on the branch; the plan removal and merge record do not, which is inconsistent.
- The state-file model v2 already banned branch/hash/push metadata from the state files. Keeping a SHA in ADR merge records is a leftover of the same pattern.

## Options to weigh

1. **Leave as-is.** Post-merge housekeeping commits are acceptable; the audit SHA is worth it. Close this as P4 / not an issue.
2. **Fold plan removal into the branch, drop the SHA.** Remove the executed plan as part of the branch's final change, and change ADR merge records to not include a commit SHA ("Squash-merged into `master` on YYYY-MM-DD"). One commit per feature, still an audit note.
3. **Fold plan removal into the branch, drop merge records entirely.** Rely on `git log` for the date; ADR entries describe decisions, not merges.
4. **Keep the SHA, clean up at checkpoint.** Allow the post-merge commit, then squash it away at the next checkpoint. Rejected on first read, because it rewrites published history as a routine habit.

## Questions to answer before deciding

- Is the squash SHA in an ADR merge record actually used, or is it ceremony?
- Should an executed plan be removed at all, or archived somewhere (for example the daily checkpoint already records the merge)?
- If a SHA is dropped from future merge records, do we leave the existing historical merge records alone? (Presume yes; history is not rewritten.)
- Is there any external consumer (a hook, a script, a human workflow) that depends on the merge record SHA?

## Constraints

- Historical ADR entries and daily checkpoints are not rewritten.
- Any change here is a protocol change and needs its own ADR.
- Related: the 2026-09-17 "no pre-work commits on master" decision (closed ticket `pre-work-commits-on-master.md`) fixed the front end of this problem (nothing before the branch). This ticket is about the back end (nothing after the squash).

Filed as a discussion. No decision yet; evaluate whether this is worth solving before proposing a fix.

---

2026-10-28
Closed. Implemented on the branch. Policy rewritten; validators pass; squash merge follows. No release.

## Implementation Plan: Work-Item Branch and Plan Lifecycle

Ticket: `ai/issues/in-progress/post-merge-maintenance-commits-on-master.md`
Date: 2026-10-28
Status: Implementation review APPROVED (round 3); ready to close

## Evidence

- `ai-policy-common.md` `## Issue Management Protocol` (lines 183-198) already says "implement on a feature branch", "close the ticket, squash-merge to trunk, then delete the branch", and "implement only a bullet-proof plan".
- The same section contains a contradiction: "A ticket reaches `closed/` only when its fix is merged" and "close the ticket, squash-merge".
- `ai-policy-common.md` `## Feature Development and Branch-Gating` (lines 41-51) already bans pre-work commits and requires the branch before any file change. A plan-only commit on `master` violates this existing rule.
- `AGENTS.md` `PROCEDURE MANAGE-ISSUES` (lines 259-276) repeats the plan, review, branch, close, squash, delete sequence but does not define the one-squash-commit rule, the plan evidence section, automatic review, the plan appendix, or the checkpoint-on-branch step.
- `ai-policy-meta.md` `## Procedure and Policy Authoring` (lines 57-151) already defines the tightening rules: one sentence per bullet, one action per sentence, imperative mood, no rationale or narrative, and migrate a non-compliant section only when touched.
- `ai-policy-meta.md` `### Enforcement` (lines 137-144) says "Migrate a non-compliant policy only when the policy is touched" and "Do not rewrite the whole policy corpus in one pass."
- `ai-policy-code-review.md` `## Severity Classifications` (lines 57-62) defines Critical, Major, Minor, and Suggestion. The plan references those definitions.
- `ai/shared/project-knowledge/issue-template.md` currently says "When the fix is merged, move it to `ai/issues/closed/`" and describes the plan as a dated comment.
- `ai/shared/project-knowledge/release-practices.md` `## Release Checklist` currently places the release documentation after the squash merge.
- The vehicle ticket is `post-merge-maintenance-commits-on-master`, which documented the post-merge housekeeping problem: plan removal and ADR merge records forced commits after the squash.
- The recent sync fix demonstrated the gap: the plan was pushed to `master` before the fix, and the state context was left for a later checkpoint.
- `support-files/validate-policy-authoring.sh` and `support-files/validate-protocol.sh` enforce structure and references.

## Goal

Write the local one-ticket, one-branch, one-squash-commit rule into the policy, preserve the external PR/MR sequence, make plan evidence and automatic review mandatory, attach the final plan to the ticket at close, delete the plan file, align the issue template and release checklist, and bring the touched policy sections to the authoring standard.

## Scope

### In scope

- Rewrite `ai-policy-common.md` `## Issue Management Protocol` to the authoring standard.
- Add the local one-branch, one-squash, no-post-merge rule.
- Preserve the external PR/MR merge-then-close sequence.
- Add the required `## Evidence` plan section and automatic review rounds.
- Add the plan appendix at close and the plan-file deletion.
- Add the checkpoint-on-branch step.
- Add the release documentation and tag sequence.
- Update `AGENTS.md` `PROCEDURE MANAGE-ISSUES`, including step 3 and steps 5-8.
- Add the touched-section rule to `ai-policy-meta.md` `### Enforcement`.
- Add two ADRs to `design-docs/protocol-decisions.md`.
- Update `ai/shared/project-knowledge/issue-template.md`.
- Update `ai/shared/project-knowledge/release-practices.md`.
- Update live docs that describe the issue or plan workflow.
- Close this ticket by applying the new rule to itself: append this plan to the ticket, replace the plan link, delete the plan file, close the ticket, and run the checkpoint on the branch.

### Out of scope

- A release or tag.
- Rewriting policies outside the touched sections.
- Changing historical ADR entries or daily checkpoints.
- A new plan template file.

## Design

### Ticket Storage

- Store tickets under `ai/issues/` in `open/`, `in-progress/`, or `closed/`.
- Treat the ticket's directory as its status.
- Keep no file directly under `ai/issues/`.
- Use a lowercase kebab-case slug only.
- Do not add a status prefix or suffix.
- Move the ticket file to change status.
- Do not add a status field.
- Reopen a closed ticket by moving it to `open/`.

### Ticket Fields

- Include `Reported`, `Reporter`, `IssueType`, `Severity`, `Size`, `URL`, `Summary`, `Label`, and `Description`.
- Set `IssueType` to `Feature`, `Defect/Bugfix`, `Improvement/Refactor`, `Documentation`, or `Task`.
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
- File the ticket under `ai/issues/open/` or in the user's external tracker.
- File a ticket immediately when the AI finds work worth tracking.
- Analyze the ticket for gaps before starting work.
- Fill every gap through brainstorming or grilling.
- Tell the user whether the ticket is workable when an external tracker has no label mechanism.
- Set `Label: Insufficient Information` or `Label: Unworkable` when the ticket is not workable.
- Refuse to work an unworkable ticket.

### Plan

- Open the feature branch before creating the plan.
- Create the plan under `ai/plans/`.
- Append the plan file name to the ticket as a dated comment.
- Treat the plan as a working artifact, not a design document.
- Include an `## Evidence` section in every plan.
- Record sources, commands, results, confirmed facts, and open questions in the evidence section.
- Use context plus acceptance criteria for an `S` ticket.
- Use an HLD and an LLD with acceptance criteria for an `M`, `L`, or `XL` ticket.
- Record each design decision as an ADR.
- Keep the HLD, LLD, and ADR content inside the plan file.
- Write the failing test first when the project uses TDD.
- Run independent peer review on every plan automatically.
- Use the severity definitions in `ai-policy-code-review.md` `## Severity Classifications`.
- Fix every Critical or Major finding.
- Re-review after each fix.
- Announce the plan ready only after an `APPROVED` verdict.
- Record each review round and verdict in the plan's Peer Review Log.

### Branch and Merge

- Treat a local ticket as one unit of work on one feature branch.
- Keep the plan, implementation, tests, documentation, release announcement, ADRs, ticket close, plan appendix, and checkpoint on that branch.
- Run the implementation peer review on the branch.
- Fix every Critical or Major finding and re-review until none remains.
- Attach the final plan to the ticket under `## Implementation Plan`.
- Replace the active plan link with `Plan attached below.` at close.
- Delete the plan file from `ai/plans/` at close.
- Close a local ticket on the branch before the squash merge.
- Run the checkpoint that records the completed work on the branch before the merge.
- Squash merge the branch to trunk.
- Delete the branch after the merge.
- Do not commit a plan-only, start-work, or placeholder change to trunk.
- Do not make post-merge commits for a local work item.
- Open a new branch when local work is missing after the merge.
- Reopen the ticket on the new branch.
- Merge an external PR/MR first.
- Close the external ticket after the merge.
- Attach the plan as part of the external close.
- Delete the plan file as part of the external close.
- Treat the external close, plan appendix, and plan-file deletion as the only post-merge changes for that work item.
- Put local release documentation in the branch.
- Tag the release commit after the merge.
- Publish the GitHub Release after the tag.

### Lifecycle

- Move a ticket from `open/` to `in-progress/` when work starts.
- Close a local ticket on the branch before the squash merge.
- Close an external ticket after the PR/MR merges.
- Reopen a local ticket by moving it to `open/`.
- Reopen an external ticket in its tracker.
- Use the template at `ai/shared/project-knowledge/issue-template.md`.
- Create the template during bootstrap or load context when it is missing.
- Do not overwrite the template.

### Current rules preserved

- Keep ticket storage under `ai/issues/` with status by directory.
- Keep the lowercase kebab-case filename and the no-status-field rule.
- Keep the no-rename rule when moving a ticket.
- Keep the nine fields and their allowed values.
- Keep the short active description and the no-transcript rule.
- Keep AI-initiated creation, external tracker creation, URL recording, and unworkable handling.
- Keep the pre-work analysis and gap-filling rule.
- Keep the plan dated comment, plan-not-design-doc, HLD, LLD with AC, ADR, and TDD rules.
- Keep the local and external branch and merge sequences.
- Keep the lifecycle and template rules.
- Keep the template creation and no-overwrite rules.

### ADR content

**ADR 1: Local work uses one branch and one squash commit**

Treat a local ticket as one unit of work on one feature branch. Keep the plan, implementation, tests, documentation, release announcement, ADRs, ticket close, plan appendix, and checkpoint on the branch. Close the ticket on the branch before the squash merge. Do not make post-merge commits for a local work item. For an external PR/MR, merge first, then close the ticket, attach the plan, and delete the plan file. Put release documentation in the branch. Tag the release commit after the merge. This supersedes the 2026-09-17 close-only-when-merged wording for local work.

Context: post-merge maintenance commits and plan-only pushes created noise and inconsistent records.
Consequences: the plan file is transient; the closed ticket carries the plan; the external close, plan appendix, and plan-file deletion are the only post-merge changes.

**ADR 2: Plans carry evidence and automatic peer review**

Require an `## Evidence` section in every plan. Run independent peer review automatically. Use the severity definitions in `ai-policy-code-review.md`. Fix every Critical or Major finding. Re-review after each fix. Announce the plan ready only after an `APPROVED` verdict. Record each round and verdict in the plan's Peer Review Log.

Context: plans were reviewed only when asked, and evidence was not explicit.
Consequences: plan creation is slower and more reliable; a focused review is enough for an `S` ticket.

## Files to Change

- `ai-policy-common.md`: rewrite `## Issue Management Protocol`; add the new rules; resolve the lifecycle contradiction.
- `AGENTS.md`: update `PROCEDURE MANAGE-ISSUES` step 3 and steps 5-8.
- `ai-policy-meta.md`: add the touched-section rule to `### Enforcement`.
- `design-docs/protocol-decisions.md`: add the two ADRs.
- `ai/shared/project-knowledge/issue-template.md`: update the lifecycle and the plan appendix form.
- `ai/shared/project-knowledge/release-practices.md`: move release documentation before the merge; update the checklist.
- `docs/workflow-guide.md` and `README.md`: update only the issue or plan workflow descriptions that contradict the new rules.
- `ai/issues/in-progress/post-merge-maintenance-commits-on-master.md`: plan link, then close with the plan appendix.
- `ai/state/context.md`, `ai/state/progress.md`, `ai/daily-checkpoints/2026-10-28.md`: checkpoint on the branch.

## Implementation Steps

1. Keep the branch `feature/work-item-branch-and-plan-lifecycle` open.
2. Write this plan and run its automatic peer review rounds.
3. Rewrite `## Issue Management Protocol` to the authoring standard.
4. Update `PROCEDURE MANAGE-ISSUES` step 3 and steps 5-8.
5. Add the meta-policy enforcement bullet.
6. Add the two ADRs.
7. Update the issue template and the release checklist.
8. Update the live docs that contradict the new rules.
9. Run the verification set.
10. Run the implementation peer review on the branch.
11. Attach this plan to the ticket under `## Implementation Plan`.
12. Replace the active plan link with `Plan attached below.`.
13. Delete `ai/plans/work-item-branch-and-plan-lifecycle-plan.md`.
14. Close the ticket on the branch.
15. Run the checkpoint on the branch.
16. Commit everything on the branch.
17. Squash merge to `master`, delete the branch, and push. Do not release.

## Verification

- `bash support-files/validate-protocol.sh` passes 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md` passes.
- `bash support-files/test-protocol-references.sh` passes.
- Markdownlint reports 0 issues on changed markdown.
- New policy text contains no `should`, `prefer`, `consider`, or `try`.
- New policy bullets use one sentence and one action per sentence.
- The issue template matches the close-on-branch and plan appendix rules.
- The release checklist places documentation before the merge and the tag after it.
- The ticket is closed on the branch with the plan appendix.
- `ai/plans/` contains no plan file for this ticket.
- The external PR/MR sequence remains in the policy.
- No post-merge commit is needed for this local work item.
- No release is created.

## Acceptance Criteria

- The common policy states the local one-ticket, one-branch, one-squash rule.
- The common policy preserves the external merge-then-close sequence.
- The common policy states that all local work item artifacts stay on the branch.
- The common policy states that no post-merge commits are made for a local work item.
- The common policy resolves the close-before-merge contradiction.
- The common policy states the release documentation and tag sequence.
- Every plan requires an `## Evidence` section.
- Every plan requires automatic review until no Critical or Major finding remains.
- The plan is announced ready only after an `APPROVED` verdict.
- The final plan is attached to the ticket at close and the plan file is deleted.
- The plan link is replaced with an appendix pointer.
- `AGENTS.md` `PROCEDURE MANAGE-ISSUES` step 3 and steps 5-8 match the common policy.
- `ai-policy-meta.md` requires touched policy sections to meet the authoring standard.
- The issue template matches the new lifecycle and appendix.
- The release checklist places documentation before the merge and the tag after it.
- Two ADRs are recorded.
- Live docs that contradict the new rules are updated.
- This ticket is closed using the new rule.
- All verification commands pass.
- No release.

## Risks

- The rewrite can lose an existing issue-management rule. Mitigation: use the preserved list and review the diff.
- The new section can become long prose. Mitigation: one-sentence imperative bullets and the authoring validator.
- The plan appendix makes the closed ticket large. Mitigation: closed tickets are not indexed at boot; allow the appendix.
- The policy change is a protocol change. Mitigation: ADR, plan review, implementation review, and human approval before merge.
- A tag cannot live in the branch. Mitigation: state that the tag follows the merge; the external close and plan deletion are the only other post-merge changes.
- External PR/MR work cannot close before the merge. Mitigation: keep the external exception explicit.

## Peer Review Log

- Round 1: CHANGES REQUESTED. Report: `ai/code-review-reports/2026-10-28_19-20_review-05.md`. 0 Critical, 5 Major, 6 Notes. Applied: external PR/MR sequence, plan mandate preservation, AGENTS step 3, issue template, release checklist, severity definitions, appendix exception, plan link replacement, naming and reopen details, external tracker and no-label path, plan depth by Size.
- Round 2: APPROVED. Report: `ai/code-review-reports/2026-10-28_19-30_review-06.md`. 0 Critical, 0 Major, 7 Notes.
- Implementation review round 1: CHANGES REQUESTED. Report: `ai/code-review-reports/2026-10-28_20-20_review-07.md`. 0 Critical, 2 Major, 7 Notes. Applied: live-doc local scope, AGENTS reopen and external plan deletion, plan status, ticket local scope, template naming and creation, concise and depth split, release-commit wording, ADR supersession and plan deletion.
- Implementation review round 2: CHANGES REQUESTED. Report: `ai/code-review-reports/2026-10-28_20-30_review-08.md`. 0 Critical, 1 Major, 6 Notes. Applied: restored the original ticket slug; added external plan deletion to the plan and docs; scoped the ticket decision to local work; opened the branch before the ticket move; reduced the procedure aliases; updated the plan status and log.
- Implementation review round 3: APPROVED. Report: `ai/code-review-reports/2026-10-28_20-40_review-09.md`. 0 Critical, 0 Major, 6 Notes. Applied: branch-before-start order in the guide and template, plan-branch wording, ADR rule restored, technical-diary rule restored, ticket Label field, and tag-risk wording.
