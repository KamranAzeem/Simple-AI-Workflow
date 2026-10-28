Reported: 2026-10-28
Reporter: Kamran Azeem (bug report from a macOS user)
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Sync scripts fail on their own AGENTS.md and stop; exclude the workflow directory and clarify manual-copy limits in README

Description:

**Report**

On macOS, running `./support-files/sync-agents-md.sh --source ./AGENTS.md --target-path ~/Projects` from the workflow clone under `~/Projects` finds the workflow's own `AGENTS.md` as a target. `cp` reports "source and target are identical (not copied)", `set -e` exits the script, and the remaining project directories are not processed.

Log evidence:

- Workflow directory: `/Users/<user>/projects/Simple-AI-Workflow`
- Target found: `/Users/<user>/Projects/Simple-AI-Workflow/AGENTS.md`
- Error: `cp: /Users/<user>/Projects/Simple-AI-Workflow/AGENTS.md and /Users/<user>/projects/Simple-AI-Workflow/AGENTS.md are identical (not copied)`

**Root cause**

- The bash discovery filter excludes only the exact source file path: `[ "$f_abs" = "$SRC_ABS" ]`.
- The workflow directory path and the discovered path differ in case (`projects` versus `Projects`). macOS is case-insensitive, but the shell string comparison is case-sensitive, so the self-file is not excluded.
- The loop then runs `cp -f` on the source file. `cp` returns non-zero for identical files, and `set -e` aborts before the remaining targets.
- The PowerShell script excludes the exact source path with `-ne`, which is case-insensitive, but it does not exclude the whole workflow directory. The same explicit exclusion invariant should exist in both versions.

**Desired behavior**

- Discover all `AGENTS.md` files under the target path first, into a list.
- Exclude the workflow directory and everything under it, not only the source file. The workflow directory is the clone that contains the running script and the source `AGENTS.md`.
- Compare paths in a way that works on case-insensitive filesystems. Use a resolved inode comparison such as `stat` on the two paths, or a Darwin case-insensitive comparison, not raw string equality.
- Skip a target whose content is already identical to the source with `cmp -s` or a hash, rather than letting `cp` fail.
- Process the list one by one. A failure on one target must not abort the remaining targets; print a summary and exit non-zero only if real failures occurred.
- Apply the same behavior to `sync-agents-md.sh` and `sync-agents-md.ps1`.
- Keep `--dry-run` and `-WhatIf` behavior and the existing `ai-customization.md` and state-file migration steps.

**README clarification**

The README currently says a manual copy of `AGENTS.md` is possible at lines 24-25 and 291. Clarify:

- A manual copy does deliver the latest `AGENTS.md`.
- The sync script also performs maintenance and migrations, such as checking or creating `ai-customization.md` with the correct `Global AI Workflow Directory`, and migrating state files to `ai/state/`.
- A manual copy is therefore only the `AGENTS.md` half of the work; any pending maintenance remains.
- Using the sync script is highly recommended.
- Keep the existing "sync script migrates for you" references consistent; do not add a release announcement.

Proposed README wording:

> A manual copy delivers the latest `AGENTS.md`, but it does only half the job. The sync script also performs maintenance tasks such as checking or creating `ai-customization.md` with the correct workflow directory and migrating state files to `ai/state/`. Using the sync script is highly recommended.

**Acceptance criteria**

- Running the bash script from the workflow clone with `--target-path` set to the clone's parent completes without syncing the workflow's own `AGENTS.md`, and processes every other target.
- The log names the excluded workflow directory, or states that it was skipped, and does not show a `cp: ... identical` error.
- An identical `AGENTS.md` in another project is skipped gracefully and does not abort the run.
- A failure on one target is reported, the remaining targets still run, and the final exit status is non-zero.
- The PowerShell script behaves the same under Windows PowerShell 5.1 and PowerShell 7.
- `--dry-run` and `-WhatIf` still make no changes.
- The README explains the manual-copy limitation and recommends the sync script, with the maintenance examples.
- `bash -n`, a PowerShell parse check, the sync-script dry run, and the existing validator 8/8 pass.
- The bash fix is tested on macOS, where the path case difference occurs, and on Linux.
- No release.

**Blast radius**

- `support-files/sync-agents-md.sh`
- `support-files/sync-agents-md.ps1`
- `README.md`
- `docs/ai-customization-guide.md` and any setup guide that repeats the manual-copy claim, only if they need the same clarification
- No protocol or policy change; no release.

**Open questions**

- Exclude the whole workflow tree or only the source file. Recommended: the whole tree.
- Continue after a per-target failure. Recommended: yes, with a summary and non-zero exit.
- Use inode comparison for path identity. Recommended: yes; it handles macOS case differences without a Darwin-only branch.
- Include docs manual-copy claims in the same change. Recommended: align only the places that repeat the claim.

---

2026-10-28
Plan: `ai/plans/sync-script-self-exclusion-and-readme-clarification-plan.md`. Pre-work decision: discovery-first list, workflow-tree exclusion via an inode ancestor walk, identical-file skip, per-target continuation with a failure summary, and the README manual-copy clarification.

---

2026-10-28
Plan approved after three peer review rounds; ready to implement. Report: `ai/code-review-reports/2026-10-28_18-55_review-03.md` (APPROVED). No code changes yet.

---

2026-10-28
Closed. Implemented on `fix/sync-agents-md-self-exclusion`; squash merge to master follows. The scripts discover targets first, exclude the workflow clone with an inode ancestor walk, skip identical files, and continue after a failed target. The README and live docs clarify that a manual copy is only the `AGENTS.md` half. Verification: bash regression suite all cases pass, `validate-protocol.sh` 8/8, markdownlint 0; PowerShell reviewed statically because `pwsh` is unavailable; macOS runtime not exercised on this host. No release.
