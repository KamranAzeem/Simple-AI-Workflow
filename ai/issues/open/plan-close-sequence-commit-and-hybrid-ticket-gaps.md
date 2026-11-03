Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: The plan close sequence omits the commit step and leaves the external and hybrid ticket close undefined

Description:

## Problem

The work-item close sequence, the common policy, and the issue template disagree on the order between the checkpoint, the commit, and the merge. Three defects surfaced while planning GitHub issue #2.

1. No explicit commit step. `AGENTS.md` STEP-MERGE-SEQUENCE goes from "Run the checkpoint on the branch" to "Squash-merge to trunk". The commit is implied only by the terminal gate, which requires the branch to be at least one commit ahead. An AI following the list literally can run the gate with a dirty tree and zero commits, or assume the squash-merge creates the commit.
2. The terminal gate is positioned before the commit. STEP-BRANCH-REVIEW lists the checkpoint and then the gate, but at that point nothing is committed. The gate condition and its stated position contradict each other.
3. The external and hybrid close is undefined. The external branch says merge first, then attach the plan, delete the plan file, and close the ticket. The plan-file deletion is a repository change after the merge. The protocol calls it a permitted post-merge change but never says whether it is committed. A committed deletion becomes a second trunk commit and leaves the tag on an earlier commit. An uncommitted deletion leaves a dirty tree. There is no defined path for an external ticket with a local trunk merge and no PR or MR.

## Scope

- `AGENTS.md` PROCEDURE MANAGE-ISSUES, STEP-BRANCH-REVIEW and STEP-MERGE-SEQUENCE.
- `ai/policies/ai-policy-common.md` `## Issue Management Protocol`, `### Branch and Merge`.
- `ai/shared/project-knowledge/issue-template.md` `## Lifecycle`.
- `design-docs/protocol-decisions.md`: one entry recording the corrected order and the hybrid close.
- A validator or reference-test guard if the corrected order can be checked mechanically.

## Acceptance criteria

- The close sequence names the single commit explicitly, after the checkpoint and before the terminal gate.
- The terminal gate states that it runs after that commit.
- One order exists for local work, with the checkpoint inside the single squash commit.
- The external close never changes the repository after the merge, or the permitted post-merge commit is named and owned.
- The hybrid case is defined: an external ticket, a local trunk merge, no PR or MR.
- The three files describe the same order with no contradiction.
- One ADR entry records the decision.
- The protocol validator and the reference test pass.

## Notes

- Found on 2026-11-03 while planning the removal of hardcoded policy paths.
- Deferred by the user to a separate work item; the path fix uses the local-code interpretation in the meantime.
- The user reported repeated drift between the plan, branch, and close procedures. The fix must make the order single-source and checkable, not just reworded.
