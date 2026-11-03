Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Streamline work-item delivery into two procedures with merge modes and one authoritative order

Description:

## Problem

The work-item close sequence, the common policy, and the issue template disagree on the order between the checkpoint, the commit, and the merge. The original three defects:

1. No explicit commit step. The merge sequence goes from "Run the checkpoint on the branch" to "Squash-merge to trunk". The commit is implied only by the terminal gate.
2. The terminal gate is positioned before the commit. The gate condition and its stated position contradict each other.
3. The external and hybrid close is undefined. The plan-file deletion after an external merge is a post-merge repository change with no owner.

The wider investigation found six more:

- The order is written in five places: `AGENTS.md`, the common policy `### Branch and Merge` and `### Lifecycle`, the issue template `## Lifecycle`, the workflow guide, and every plan's `## Close Sequence`. They drift.
- Issue requests cascade. `"file an issue"` enters a procedure that continues into analysis, planning, and review. Filing alone is a complete action, and the user often stops there.
- "External" conflates two independent things: where the ticket lives, and whether the code merges through a PR/MR. That is why GitHub issue #2 had no defined path.
- No merge-mode support. Team users need a PR/MR; solo users need a local squash merge. The protocol describes only the local path plus an undefined external path.
- Tool assumptions. Detecting a merge mode through `gh` or `glab` excludes users who do not have them installed or configured.
- Configuration bloat. A Tracker setting in the customization file is not understandable to most users, and users are wary of editing that file.

## Decisions (2026-11-03)

- Two procedures: `MANAGE-ISSUES` for ticket work and planning, `IMPLEMENT-PLAN` for delivery. Each request ends at its own step.
- One authoritative order, in `AGENTS.md`. The common policy keeps invariants only; the template and guide point to the procedures.
- Merge mode is one optional setting, `## Merge Policy` with `**Merge Mode**: auto`. `auto` behaves as direct; a rejected direct push falls back to the PR path. `gh` and `glab` are optional, never required.
- No Tracker setting. The ticket is wherever the user put it; local by default, external by reference.
- A ticket closes with the merged change. A local ticket moves to `closed/` in the branch commit; an external issue closes when the merge lands. No post-merge repository changes.
- Several branch commits are allowed; trunk receives one squash commit.
- Release v5.6.0.
- Update the docs and the slide deck.
- Add a drift guard to the reference test.

## Scope

- `AGENTS.md`: replace `PROCEDURE MANAGE-ISSUES` with `MANAGE-ISSUES` and `IMPLEMENT-PLAN`.
- `ai/policies/ai-policy-common.md`: reduce `## Issue Management Protocol` to invariants and replace `### Branch and Merge` and `### Lifecycle` with `### Work-Item Invariants`.
- `ai/shared/project-knowledge/issue-template.md`: keep the fields, replace the lifecycle steps with a pointer.
- `docs/workflow-guide.md` section 16 and the close walkthrough.
- `docs/simple-ai-workflow-slides.md`.
- `docs/ai-customization-guide.md`, `docs/ai-customization.md`, and `docs/examples/full-stack-web-mobile-ai-customization.md`.
- `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1`.
- `support-files/test-protocol-references.sh`.
- `design-docs/protocol-decisions.md`: one ADR entry.
- Release v5.6.0 docs, announcement, and README banner.

## Acceptance criteria

- Filing, listing, closing, and planning are separate complete actions. None cascades into another.
- Only `AGENTS.md` states the delivery order. The common policy, the issue template, and the workflow guide contain no ordered close list.
- `direct` and `pr` both work. `auto` behaves as direct and falls back to `pr` when a direct push is rejected. No merge step requires `gh` or `glab`.
- One optional `## Merge Policy` setting exists. No tracker setting exists.
- A local ticket closes in the branch commit; an external issue closes when the merge lands. No post-merge repository change.
- Several branch commits are allowed; trunk receives one squash commit.
- The sync scripts add the section only when missing, never overwrite a value, and report the addition in a dry run.
- The docs and slides describe the two procedures and the merge modes.
- The protocol validator is 8/8, the authoring validator passes, markdownlint reports 0, and shellcheck is clean on the changed scripts.
- The drift guard fails on the old tree and passes on the new one.
- One ADR entry records the decisions. Release v5.6.0 is published.

## Notes

- Found on 2026-11-03 while planning the removal of hardcoded policy paths; expanded by the user's decisions on 2026-11-03.
- The file name keeps its original slug. Only the summary and scope change.
- The ADR store cleanup is deferred by the user.

---
2026-11-03
Plan attached below.

## Implementation Plan

# Streamline Work-Item Delivery into Two Procedures with Merge Modes

## Ticket

- Local ticket: `ai/issues/open/plan-close-sequence-commit-and-hybrid-ticket-gaps.md`.
- The file name keeps its original slug; the summary and scope were expanded on 2026-11-03.
- Type: Improvement/Refactor. Severity: P2 (AI estimate). Size: L (AI estimate).
- Plan depth: L, so this plan carries an HLD, an LLD with acceptance criteria, and ADR content.

## Context

The delivery order is written in five places and disagrees with itself. It omits the commit, places the terminal gate before the commit, and leaves the external close undefined. The issue procedure also cascades from filing into planning, and "external" conflates ticket location with PR/MR merging.

The user wants one streamlined procedure for all plan implementation, with no documentation-versus-code distinction, support for team PR/MR workflows and solo direct merges, minimal configuration, and no dependency on `gh` or `glab`.

The meta policy also requires approval before staging, committing, pushing, merging, and releasing, and before changing an authoritative policy. That rule, not the procedure, is what stopped the documentation work at the trunk merge. The plan must reconcile it explicitly.

## Evidence

- The order appears in `AGENTS.md:275-276`, `ai/policies/ai-policy-common.md:339-381`, `ai/shared/project-knowledge/issue-template.md:49-64`, `docs/workflow-guide.md:371-377`, and every plan's `## Close Sequence`.
- `AGENTS.md:276` goes from the checkpoint to the squash merge without a commit.
- `AGENTS.md:275` and `ai-policy-common.md:347-349` place the terminal gate before the commit the gate requires.
- `ai-policy-common.md:362-366` merges an external PR/MR first, then deletes the plan file, a post-merge repository change.
- `ai-policy-common.md:274-281` says tickets live under `ai/issues/`; `:301-302` allows an external tracker. `AGENTS.md:263` describes only `ai/issues/`. The external path is undefined.
- `AGENTS.md:258-277` runs filing, analysis, planning, review, branch, and merge under one trigger, so `"file an issue"` can cascade into planning.
- `ai-policy-common.md:301-302` (external tracker) and `:362-366` (external PR/MR) use "external" for two different things.
- `support-files/sync-agents-md.sh:127-133` and `support-files/sync-agents-md.ps1:92-113` build the default customization file; neither writes a merge policy.
- `support-files/test-protocol-references.sh` checks reference resolvability and three conformance groups, not order drift.
- `support-files/validate-protocol.sh` runs 8 checks; none covers the delivery order.
- `design-docs/protocol-decisions.md:763-817` records the fragmented 2026-10-31 decisions. ADR at `:765-769` says the procedure owns the order and the plan owns the addresses, but the policy, template, guide, and plans all restate the order.
- `ai-policy-common.md:570` states the DRY rule that the current duplication violates.
- Repo state at planning time: `master` at `29ba1d6`, one uncommitted `ai/state/context.md` count correction. It joins the implementation branch.
- Tooling: `bash`, `shellcheck`, `markdownlint-cli2` available. `pwsh` availability is checked at implementation and reported if absent.
- `ai/policies/ai-policy-meta.md:35-48` requires human approval before staging, committing, pushing, creating a PR, merging, releasing, and changing an authoritative policy. This is the approval rule the new single-approval model must reconcile.
- `ai/policies/ai-policy-codebase-examination.md:63` restates the branch-gating and merge-after-approval rule.
- `ai/policies/ai-policy-code-review.md:61` checks the close sequence and the terminal gate, but not the merge mode or the ticket reference.
- ADRs superseded in part: 2026-10-06 stable names (the step set changes), 2026-10-12 issue management (the merge sequences), 2026-10-28 one branch and one squash (the one-branch-commit reading and the external close), 2026-10-31 terminal state and feature-branch approval (the order and approval scope).
- Closed tickets whose accepted behavior this plan supersedes in part: `work-item-close-sequence-and-terminal-state.md`, `issue-management-policy-improvements.md`, and `post-merge-maintenance-commits-on-master.md`.
- `README.md:373`, `docs/ai-agent-collaboration.md:30-34`, and `docs/simple-ai-workflow-slides.md:44` restate the old flow or the old merge-approval rule.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md:28,37` expects 12 procedures and 95 steps and says `shellcheck` is absent. Both facts change.
- `ai/shared/project-knowledge/protocol-routing-principle.md` says `AGENTS.md` is a router, not a catalog. The extraction is deferred; these procedures stay in the triggered-procedures tier per ADR 2026-05-21.
- `docs/protocol-name-migration-map-2026-10-06.md:78-81` lists the old MANAGE-ISSUES steps. It is a historical map and stays unchanged.

## Goals and Non-Goals

Goals:

- One authoritative delivery order, in `AGENTS.md`.
- Two procedures with explicit early exits: `MANAGE-ISSUES` and `IMPLEMENT-PLAN`.
- `direct` and `pr` merge modes with a no-CLI fallback.
- One optional setting, `**Merge Mode**`, in `ai-customization.md`.
- Ticket close with the merged change, with no post-merge repository changes.
- Docs, slides, templates, sync scripts, and a drift guard updated together.
- v5.6.0 release.

Non-goals:

- Cleaning the ADR store. The user will handle that later.
- The thin-`AGENTS.md` extraction. The two procedures stay in the triggered-procedures tier, and the extraction remains a separate work item.
- Rewriting state-file, knowledge, or review procedures.
- Adding a tracker setting.
- Automating a forge API. The PR path hands the URL to the user when no CLI is present.
- Changing the `.gitignore` or the protocol's file layout.

## HLD

**Two procedures, one lifecycle.**

`MANAGE-ISSUES` handles ticket actions and planning, and ends at the step the user asked for. `IMPLEMENT-PLAN` handles delivery from an approved plan to a merged and released change. The lifecycle `open` → `in-progress` → `closed` is defined once. The delivery order appears only in `IMPLEMENT-PLAN`.

**One order, one owner.** `AGENTS.md` owns the order. The common policy keeps invariants and points to the procedures. The issue template keeps fields and a pointer. The workflow guide summarizes for humans and must not restate the order. A reference-test guard fails if the old ordered phrases return to the common policy, template, or guide.

**Merge mode as data.** One optional project setting:

```markdown
## Merge Policy
**Merge Mode**: auto
```

`auto` and a missing section behave as `direct`. `direct` squashes locally, deletes the branch, and pushes the trunk. `pr` pushes the branch, opens the PR/MR when a CLI is available, otherwise prints the create or compare URL, waits for the user's merge confirmation, pulls the trunk, and deletes the branch. A rejected direct push switches to the `pr` path with a reported fallback. Tags follow the merge in both modes.

**Tickets by reference.** The ticket is a local file by default, or an external issue when the user supplies one or asks for one. The plan records the reference. A local ticket moves to `closed/` in the branch commit, so it lands with the merge. An external issue closes when the merge lands. No post-merge repo change exists.

**Branch commits.** Several branch commits are allowed. Trunk receives one squash commit.

## LLD and Acceptance Criteria

### LLD-001: Replace `PROCEDURE MANAGE-ISSUES` in `AGENTS.md`

New procedure, four steps:

1. `STEP-TICKET`: create, list, close, or reopen. Local by default; external when the user supplies or requests it. A ticket-only request ends here. Reopen a local ticket in `open/` on a new branch; reopen an external ticket in its tracker.
2. `STEP-PLAN`: on a plan request, analyze gaps, write the plan with `## Evidence` and a `## Close Sequence` block, and append or post the dated plan entry. No branch.
3. `STEP-REVIEW-PLAN`: automatic peer review until `APPROVED`; fix every Critical and Major finding; record each round.
4. `STEP-STOP`: return control; the ticket stays in `open/`; no cascade.

Procedure header: `### PROCEDURE MANAGE-ISSUES: When the user says "manage issues", "file an issue", "close issue", "list issues", "plan the issue", or "plan issue #N"`.

**Aliases**: manage issues; file an issue; close issue; list issues; plan the issue; plan issue #N.

AC-001: `test-protocol-references.sh` reports exactly one definition for `PROCEDURE MANAGE-ISSUES` and four `STEP` anchors.
AC-002: the procedure states that filing, listing, closing, and planning each end at their own step.

### LLD-002: Add `PROCEDURE IMPLEMENT-PLAN` in `AGENTS.md`

New procedure, six steps:

1. `STEP-PREFLIGHT`: require an `APPROVED` plan and its ticket; resolve the merge mode; open the branch; move the ticket to `in-progress/`; carry planning state changes.
2. `STEP-BUILD`: implement, tests first when the project uses TDD; include docs, release notes, and ADRs.
3. `STEP-REVIEW`: implementation peer review; fix every Critical and Major finding; re-review until none remains.
4. `STEP-RECORD`: attach the plan under `## Implementation Plan`; replace the active plan link with `Plan attached below.`; close the local ticket; leave an external ticket open for `STEP-SHIP`; delete the plan file; run the checkpoint.
5. `STEP-COMMIT`: commit the branch; the commit carries the work, the closed ticket, the checkpoint, and the carried state.
6. `STEP-SHIP`: terminal gate; merge by the resolved mode; delete the branch; push the trunk; tag and publish when the plan names a release; close an external ticket when the merge lands; report the definition of done.

Procedure header: `### PROCEDURE IMPLEMENT-PLAN: When the user says "implement the plan" or "implement issue #N"`.

**Aliases**: implement the plan; implement issue #N.

The merge-mode text belongs inside `STEP-PREFLIGHT` and `STEP-SHIP`:

- Read `## Merge Policy` `**Merge Mode**` from the customization file. A missing section or `auto` behaves as `direct`.
- `auto` or `direct`: squash merge, delete the branch, push the trunk.
- `pr`: push the branch; open the PR/MR with `gh` or `glab` when available; otherwise print the create or compare URL. Wait for the user's merge confirmation; pull the trunk; delete the branch.
- A rejected direct push: switch to `pr`, report the fallback.
- Tag after the merge in both modes.

AC-003: the reference test reports exactly one definition for `PROCEDURE IMPLEMENT-PLAN` and six `STEP` anchors.
AC-004: the procedure states all three merge values, the fallback, and the no-CLI path.

### LLD-003: Reduce the common policy to invariants

In `ai/policies/ai-policy-common.md`:

- Keep `### Ticket Storage`, `### Ticket Fields`, `### Ticket Content`, and `### Plan`.
- Fix `### Ticket Storage` and the ticket-filing bullets: local by default; external when the user supplies or requests it; the directory is the status for a local ticket and the tracker state is the status for an external one.
- Update the `### Plan` close-binding bullet to the new block: repo, base ref, branch, merge mode, ticket reference, release, and evidence.
- Replace `### Branch and Merge` and `### Lifecycle` with `### Work-Item Invariants`. The invariants:
  - The order lives in the two procedures; do not restate it here.
  - One unit of work, one branch, one squash commit on trunk.
  - The branch may hold several commits.
  - Keep the plan, implementation, tests, docs, release notes, ADRs, ticket close, plan appendix, and checkpoint on the branch.
  - Implementation review fixes every Critical and Major finding.
  - Terminal gate: base from the plan, at least one commit ahead, clean tree; otherwise unfinished.
  - Attach the plan before deleting it.
  - Close the ticket with the merged change: local ticket in the branch commit; external issue when the merge lands.
  - No post-merge commits or repository changes.
  - Release docs on the branch; tag after the merge; publish after the tag.
  - Done conditions: ticket closed with the plan, checkpoint written, branch merged and deleted, trunk pushed, release published when planned.
- Move the reopen rules into `MANAGE-ISSUES` `STEP-TICKET`; do not keep a separate `### Lifecycle` section.

AC-005: the common policy contains no ordered close list and no `### Branch and Merge` heading.
AC-006: the authoring validator passes on the common policy.
AC-007: every unique rule from the old sections is preserved, moved, or explicitly replaced per the Rule Conservation section.

### LLD-004: Point the issue template at the procedures

In `ai/shared/project-knowledge/issue-template.md`, replace `## Lifecycle` with a short pointer:

```markdown
## Lifecycle

Follow `PROCEDURE MANAGE-ISSUES` to file, list, close, or reopen, and `PROCEDURE IMPLEMENT-PLAN` to deliver an approved plan. A local ticket's directory is its status; an external ticket's state is its status.

Append the plan file name as a dated comment while active. At close, attach the final plan under `## Implementation Plan`, replace the dated link with `Plan attached below.`, and delete the plan file.
```

Keep every field definition unchanged.

AC-008: the template contains no numbered lifecycle steps and keeps all fields.
AC-009: markdownlint reports 0.

### LLD-005: Rewrite the workflow guide section

In `docs/workflow-guide.md` section 16 and the close walkthrough at line 376:

- Describe the two procedures and their triggers.
- State that filing, listing, closing, and planning are separate complete actions.
- Describe `direct` and `pr`, the `auto` default, the fallback, and the no-CLI URL path.
- State the ticket close rule.
- Remove the ordered close list and the duplicated external path.
- Replace the approval sentence at `docs/workflow-guide.md:371` with: "The approved plan covers the close sequence, including the merge, the push, and the release it names."

In `README.md:373`, rewrite the issue-management overview to name the two procedures, the separate actions, and the two merge modes. It must not restate the ordered close list.

AC-010: the guide names both procedures and both merge modes.
AC-011: the guide contains none of the forbidden ordered phrases listed in LLD-008.

### LLD-006: Update the slides

In `docs/simple-ai-workflow-slides.md`, update the issue-management and branch slides to show the two procedures and the two merge modes.

AC-012: the slides describe both procedures and both merge modes.
AC-013: markdownlint reports 0.

### LLD-007: Add the Merge Policy setting to the user-facing configuration

- `docs/ai-customization.md`: add the section with `**Merge Mode**: auto` and a one-line comment.
- `docs/ai-customization-guide.md`: add a "Merge Policy" subsection after the design-docs location section. Explain `auto`, `direct`, and `pr`, the fallback, and that no CLI is required.
- `docs/examples/full-stack-web-mobile-ai-customization.md`: add the section with `**Merge Mode**: pr` as the team example.

The exact block:

```markdown
## Merge Policy
**Merge Mode**: auto
```

The one-line comment above or below it: `Use pr for team repositories that require a pull request; direct for solo work.`

AC-014: all three files contain the section.
AC-015: the guide explains the three values and the fallback.
AC-016: markdownlint reports 0.

### LLD-008: Add the drift guard to the reference test

In `support-files/test-protocol-references.sh`:

- Fail if `AGENTS.md` does not define `PROCEDURE MANAGE-ISSUES` and `PROCEDURE IMPLEMENT-PLAN` exactly once.
- Fail if any of these ordered phrases appears, case-insensitive, in `ai/policies/ai-policy-common.md`, `ai/shared/project-knowledge/issue-template.md`, `docs/workflow-guide.md`, `README.md`, or `docs/ai-agent-collaboration.md`:
  - `Squash-merge to trunk`
  - `Run the checkpoint on the branch`
  - `Attach the final plan`
  - `Replace the active plan link`
  - `replace its link with`
- Fail if `## Merge Policy` is missing from `docs/ai-customization.md`, `support-files/sync-agents-md.sh`, or `support-files/sync-agents-md.ps1`.

The guard is a backstop. The primary defense is that only `AGENTS.md` states the order; the guard catches the phrases that have reappeared so far.

AC-017: the guard fails on the pre-change tree and lists the offending files. The failure is recorded in the checkpoint.
AC-018: the guard passes on the post-change tree.
AC-019: `bash -n` and `shellcheck` are clean on the test script.

### LLD-009: Update the sync scripts

In `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1`:

- Add the `## Merge Policy` section to the default customization content.
- For an existing customization file, append the section only when it is missing.
- Never modify an existing `**Merge Mode**` value.
- Report "would add Merge Policy" in a dry run and "added Merge Policy" in a real run.
- Preserve the existing migration, symlink, and path-update behavior.

AC-020: a fixture without the section gains it exactly once.
AC-021: a fixture with `**Merge Mode**: pr` is unchanged.
AC-022: a second run changes nothing.
AC-023: the dry run reports the addition without writing.
AC-024: `bash -n` and `shellcheck` are clean on the shell script; the PowerShell script is checked with `pwsh` when available, otherwise by static review and a reported limitation.

### LLD-010: Record the decision

Add one entry to `design-docs/protocol-decisions.md`, dated 2026-11-03, covering:

- Two procedures and one lifecycle.
- One authoritative order.
- Merge modes and the no-CLI fallback.
- Tickets by reference and close with the merge.
- Several branch commits, one squash commit.
- The drift guard.

State that it supersedes the order and tracker parts of the 2026-10-31 entries, the merge-sequence parts of the 2026-10-12 issue-management entry, the one-branch-commit and external-close parts of the 2026-10-28 entry, and the step-name set of the 2026-10-06 entry. Do not delete those entries. Name the closed tickets whose accepted behavior changes: `work-item-close-sequence-and-terminal-state.md`, `issue-management-policy-improvements.md`, and `post-merge-maintenance-commits-on-master.md`.

AC-025: the entry is self-contained, has no table, and follows the existing store format.

### LLD-011: Release v5.6.0

- Add `### v5.6.0 (2026-11-03)` to `ai/shared/project-knowledge/release-practices.md`.
- Write `docs/announcements/v5.6.0.md`. It states the plan-scoped approval model, both merge modes, and that team users set `**Merge Mode**: pr` with no CLI required.
- Point the README banner at the announcement.
- Do the docs sweep, including the slides.

AC-026: the release-practices section, announcement, and banner are present.
AC-027: markdownlint reports 0 on the changed set.

### LLD-012: Checkpoint

Run PROCEDURE WRITE-CHECKPOINT on the branch. Record the implementation, the docs verdicts, the drift-guard pre-change and post-change output, the sync-script fixture paths and results, and the review rounds. Update `ai/shared/project-knowledge/protocol-verification-toolchain.md`: the reference test now reports 13 procedures and 96 steps, the drift guard exists, and `shellcheck` is installed.

AC-028: the state files carry canonical headers, today's diary has the new section, and the checkpoint output is in the commit.

### LLD-013: Reconcile the approval policies

The meta policy is the rule that stopped the documentation work at the trunk merge. It must state the plan-scoped approval model.

- `ai/policies/ai-policy-meta.md`: replace the approval bullets with:
  - "Treat the approved plan and the implement request as the explicit human approval for the branch work, the commit, the merge, the push, the pull request when the plan's merge mode is `pr`, and the release or external writes the plan names."
  - "The approved plan names every authoritative or read-only policy it changes; that approval covers those changes."
  - Keep the secrets, multi-project, and unplanned remote-write gates.
  - Keep the pre-action checks: present the summary and proposed commit message, run the validators, and run the sync dry run.
- `ai/policies/ai-policy-codebase-examination.md:63`: replace the branch-gating restatement with a pointer to the common policy and `PROCEDURE IMPLEMENT-PLAN`.
- `ai/policies/ai-policy-code-review.md:61`: add the merge mode and the ticket reference to the procedural-completeness checks.
- `docs/ai-agent-collaboration.md:30-34`: replace "Otherwise, human approval is mandatory before any merge" with "Otherwise, the approved plan and implement request are the human approval; a handoff that does not meet these conditions waits for the user." Keep the autonomy conditions unchanged.
- No other approval rule changes.

These policies are read-only. The implement request named in this plan is the manual approval required to edit them.

AC-029: the four files state the same approval model; the secrets, multi-project, and unplanned external-write gates remain.
AC-030: the authoring validator passes on the changed policies.

## Rule Conservation

Every unique rule from `### Branch and Merge` and `### Lifecycle` lands in one of these groups. The implementation review checks the mapping.

Kept as invariants: one unit of work and one branch; keep the plan, implementation, docs, release notes, ADRs, ticket close, appendix, and checkpoint on the branch; implementation review and Critical and Major fixes; the terminal gate and its clean-tree condition; attach the plan and replace the link; close a local ticket on the branch; run the checkpoint on the branch; squash merge; delete the branch; push; no placeholder commits; no post-merge commits; release docs on the branch; tag after the merge; publish after the tag; the definition of done.

Moved to `IMPLEMENT-PLAN`: open the branch; move the ticket to in-progress; implement; review; attach; close; delete the plan; checkpoint; commit; gate; merge; delete the branch; push; close an external ticket; tag; release.

Moved to `MANAGE-ISSUES`: create, list, close, reopen; analyze; plan; plan review; the early stop.

Replaced: external merge-first, attach-after-merge, delete-after-merge, and post-merge changes become the close-with-the-merged-change rule and the ticket-reference rule.

Deleted: the duplicated ordered bullets and the tracker-specific lifecycle. No unique rule is lost.

Superseded records: the new ADR names the 2026-10-06, 2026-10-12, 2026-10-28, and 2026-10-31 entries, plus `work-item-close-sequence-and-terminal-state.md`, `issue-management-policy-improvements.md`, and `post-merge-maintenance-commits-on-master.md`. Those records remain as history.

References to update after the anchors change: search for `STEP-MERGE-SEQUENCE`, `STEP-BRANCH-REVIEW`, `STEP-ANALYZE-ISSUE`, `STEP-PLAN-MANDATE`, `STEP-PLAN-REVIEW`, `STEP-EXIT-ISSUE-MODE`, `Branch and Merge`, and `Lifecycle` across `AGENTS.md`, the policies, the docs, the ADRs, and the tests.

## ADRs in This Plan

### ADR-001: Two procedures and one lifecycle

Decision: `MANAGE-ISSUES` owns ticket actions and planning; `IMPLEMENT-PLAN` owns delivery. Each request ends at its own step. The lifecycle is defined once.

Context: one procedure cascaded from filing into planning and merge, and the user often stops after filing.

Consequences: filing, planning, and delivery are separate actions. No step triggers another phase implicitly.

### ADR-002: One authoritative order

Decision: the delivery order exists only in `AGENTS.md`. The common policy keeps invariants; the template and guide point to the procedures. A drift guard fails on the old ordered phrases outside `AGENTS.md`.

Context: five restatements drifted and contradicted each other.

Consequences: one place to change. The guard catches a reintroduced duplicate.

### ADR-003: Merge mode as one optional setting

Decision: `**Merge Mode**: auto | direct | pr` in the customization file. `auto` behaves as direct; a rejected direct push falls back to `pr`. No CLI is required; the PR path can hand over a URL.

Context: team users need PR/MR, solo users need direct merges, and not everyone has `gh` or `glab`.

Consequences: one setting, one conditional in the final step, one fallback. The plan records the resolved mode.

### ADR-004: Tickets by reference and close with the merge

Decision: no tracker setting. The ticket is a local file or an external issue, recorded by reference. A local ticket closes in the branch commit; an external issue closes when the merge lands. No post-merge repo changes.

Context: "external" conflated ticket location with the PR/MR path, and external close changed the repo after the merge.

Consequences: the repo sequence is identical for every tracker. Only the close command differs.

### ADR-005: Several branch commits, one squash commit

Decision: a branch may hold several commits; trunk receives one squash commit.

Context: the strict one-branch-commit rule breaks under PR review and review fixes.

Consequences: review fixes are normal commits; the squash merge collapses them. The checkpoint remains in the final branch state.

### ADR-006: v5.6.0

Decision: ship as v5.6.0.

Context: the procedure, triggers, issue lifecycle, merge modes, sync scripts, and docs change together.

Consequences: announcement, banner, release-practices entry, tag after merge, GitHub Release.

## Test-First Sequence

1. Add the drift guard to `support-files/test-protocol-references.sh`.
2. Run it on the pre-change tree. Expect failures for the missing new anchors and the forbidden phrases. Record the output in the checkpoint.
3. Apply LLD-001 to LLD-009 and LLD-013.
4. Run the guard again. Expect a pass.
5. Run the authoring validator, the main validator, markdownlint, and shellcheck.
6. Run the sync-script fixtures.
7. Add the ADR (LLD-010) and the release docs (LLD-011).
8. Run the implementation peer review and fix every Critical and Major finding.
9. Run the checkpoint and commit.

## Verification Commands

```bash
cd /home/kamran/Projects/Personal/Simple-AI-Workflow
bash -n support-files/test-protocol-references.sh
shellcheck support-files/test-protocol-references.sh
bash support-files/test-protocol-references.sh
support-files/validate-protocol.sh
support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md ai/policies/ai-policy-code-review.md ai/policies/ai-policy-codebase-examination.md
markdownlint-cli2 AGENTS.md 'ai/policies/*.md' README.md docs/workflow-guide.md docs/simple-ai-workflow-slides.md docs/ai-customization.md docs/ai-customization-guide.md docs/examples/full-stack-web-mobile-ai-customization.md docs/announcements/v5.6.0.md ai/shared/project-knowledge/issue-template.md ai/shared/project-knowledge/release-practices.md 'ai/issues/open/*.md' design-docs/protocol-decisions.md
rg -n "Squash-merge to trunk|Run the checkpoint on the branch|Attach the final plan|Replace the active plan link" ai/policies/ai-policy-common.md ai/shared/project-knowledge/issue-template.md docs/workflow-guide.md
rg -n "STEP-MERGE-SEQUENCE|STEP-BRANCH-REVIEW|STEP-ANALYZE-ISSUE|STEP-PLAN-MANDATE|STEP-PLAN-REVIEW|STEP-EXIT-ISSUE-MODE|Branch and Merge" AGENTS.md ai/policies docs/workflow-guide.md README.md docs/ai-agent-collaboration.md
```

Expected: the guard passes, the validator is 8/8, the authoring validator passes, lint is 0, the reference test reports 13 procedures and 96 steps, both `rg` commands return nothing, and every relative link in the changed docs resolves.

AC-031: the changed docs contain no broken relative link.

## Release

v5.6.0. Highlights: two procedures, one order, merge modes, tickets by reference, the sync-script addition, the drift guard, and the docs and slides.

Upgrade steps: pull the latest workflow; run the sync script to add `## Merge Policy`; set `**Merge Mode**: pr` in team repositories; use `"plan the issue"` and `"implement the plan"` as separate requests.

## Close Sequence

- **Repo**: this repository. One repo.
- **Base ref**: `origin/master`, fetched at implement time.
- **Branch**: `feature/streamline-work-item-delivery`, opened on the implement request.
- **Merge**: `direct`. This repository does not require a PR, so no setting change is needed.
- **Ticket**: `ai/issues/open/plan-close-sequence-commit-and-hybrid-ticket-gaps.md`.
- **Release**: v5.6.0.
- **Approval**: the implement request is the explicit approval for the branch work, the commit, the merge, the push, the v5.6.0 release, and the edits to the read-only policies named in this plan (`ai/policies/ai-policy-common.md`, `ai/policies/ai-policy-meta.md`, `ai/policies/ai-policy-code-review.md`, `ai/policies/ai-policy-codebase-examination.md`), per the decisions recorded on 2026-11-03.
- **Steps**: attach the plan to the ticket; replace the link with `Plan attached below.`; close the ticket; delete the plan file; run the checkpoint; make the commit; run the terminal gate; squash merge; delete the branch; push the trunk; tag v5.6.0; publish the release; verify.
- **Commit**: one commit on the branch, subject `refactor(protocol): streamline work-item delivery with merge modes`. The squash merge carries it to trunk.
- **Evidence**: plan attachment in the ticket; closed ticket in the commit; checkpoint in `ai/daily-checkpoints/2026-11-03.md`; gate output in the session and the final report; tag and release confirmed with `git tag -n1 v5.6.0` and `gh release view v5.6.0`.
- **Post-merge verification**: validator 8/8, guard pass, lint 0 on `master`, branch gone, trunk pushed. This is the final action.

## Risks

- The procedure rewrite breaks existing anchors. Mitigation: the reference test and the `rg` sweep.
- The meta policy still requires per-action approval. Mitigation: LLD-013 aligns it, while the secrets, multi-project, and unplanned external-write gates stay.
- A read-only policy is edited without approval. Mitigation: the Close Sequence approval names each read-only policy explicitly.
- Deleting duplicated rules loses an invariant. Mitigation: the Rule Conservation mapping and the implementation review.
- The sync scripts corrupt an existing customization file. Mitigation: idempotent append, no overwrite, fixtures, dry run.
- The PR path without a CLI is unclear. Mitigation: the push output URL, a constructed compare URL, and an explicit wait-for-confirmation step.
- The drift guard is brittle. Mitigation: target exact phrases and only the three files that must not restate the order.
- The release tag lands on the wrong commit. Mitigation: tag only after the merge, after pulling.
- The uncommitted `ai/state/context.md` correction is missed. Mitigation: the branch carries it and the terminal gate requires a clean tree.

## Do Not Break

- Do not change `PROCEDURE LOAD-CONTEXT`, `PROCEDURE WRITE-CHECKPOINT`, `PROCEDURE RUN-PEER-REVIEW`, `PROCEDURE REPAIR-STATE-FILES`, `PROCEDURE REPAIR-KNOWLEDGE-FILES`, or `PROCEDURE UPDATE-DESIGN-DOCS`.
- Do not change the canonical state-file headers.
- Do not change the knowledge-file standards.
- Do not add a tracker setting.
- Do not require `gh` or `glab`.
- Do not create a new policy file.
- Do not delete the ADR entries that the new entry supersedes.
- Do not edit the historical migration map at `docs/protocol-name-migration-map-2026-10-06.md`.
- Keep the 18-policy count; the main validator checks it.

## Peer Review Log

- Round 1: CHANGES REQUESTED. 1 Major (reopen-rule ownership was undecided) and 3 Minor (two path typos, ticket list numbering, over-broad lint scope). Fixed. The exact Merge Policy block and the fixture paths were added as suggested.
- Round 2: CHANGES REQUESTED. 2 Major (the test-first sequence skipped the sync scripts, the guide approval sentence was not explicitly removed) and 1 Minor (the drift-guard phrase list was too narrow). Fixed.
- Round 3: APPROVED. No Critical, Major, or Minor finding. One suggestion: record the pre-change guard output verbatim in the checkpoint.
- Round 4: CHANGES REQUESTED after the whole-corpus audit. Missed: the meta-policy approval rules, the codebase-examination and code-review restatements, the README body, the collaboration autonomy sentence, the ADR and closed-ticket supersessions, the toolchain counts, the historical migration map, and the exact `**Aliases**` format. Added LLD-013 and updated the scope, verification, and risks.
- Round 5: CHANGES REQUESTED. 1 Major (the authoring validator command omitted the three changed read-only policies) and 2 Minor (the release note omitted the approval model, the approval line used bare policy names). Fixed.
- Round 6: APPROVED. No Critical, Major, or Minor finding. One suggestion: show the exact new meta-policy bullets to the user before writing the read-only file.
- Round 7: APPROVED. Two clarifications after round 6: the thin-`AGENTS.md` extraction is a non-goal, and the historical migration map is in the do-not-break list. No scope or risk change.
