# PROCEDURE IMPLEMENT-PLAN: When the user says "implement the plan" or "implement issue #N"

## Triggers

- implement the plan
- implement issue #N

1. **STEP-PREFLIGHT**: Require an `APPROVED` plan and its ticket. Read the plan's close block. Resolve the merge mode from `## Merge Policy` in `ai-customization.md`; a missing section or `auto` behaves as `direct`. Open the feature branch. Move a local ticket to `in-progress/`. Carry any planning state changes.
2. **STEP-BUILD**: Implement on the branch. Write the failing test first when the project uses TDD. Include the documentation, release notes, and ADRs the plan names.
3. **STEP-REVIEW**: Run the implementation peer review. Fix every Critical and Major finding and re-review until none remains.
4. **STEP-RECORD**: Attach the plan to the ticket under `## Implementation Plan`. Replace the active plan link with `Plan attached below.`. Close a local ticket and update related project knowledge. Leave an external ticket open for `STEP-SHIP`. Delete the plan file. Run the checkpoint on the branch.
5. **STEP-COMMIT**: Commit the branch. The commit carries the work, the closed ticket, the checkpoint, and the carried state.
6. **STEP-SHIP**: Run the terminal gate: resolve the base ref from the plan, confirm the branch is at least one commit ahead, and confirm the tree is clean. Before opening or updating a PR/MR title or body, and before publishing release notes, run `STEP-SCRUB-OUTBOUND` on the text. For `direct`, squash merge to trunk, delete the branch, and push. For `pr`, push the branch, open the PR/MR with `gh` or `glab` when available or give the create or compare URL, wait for the user's merge confirmation, pull the trunk, and delete the branch. A rejected direct push switches to `pr` and reports the fallback. Tag and publish the release when the plan names one. Close an external ticket when the merge lands. Report the definition of done.
