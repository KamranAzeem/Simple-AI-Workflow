Reported: 2026-11-20
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: P2
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: backup-ai.sh walks the whole target silently, hangs on large trees, and fails every project on Windows Git Bash

Description:

Observed behaviour.

- `./support-files/backup-ai.sh --target-path ~/Projects/` printed nothing and appeared hung in a terminal.
- A bounded dry run, `timeout 8 ./support-files/backup-ai.sh --target-path "$HOME/Projects" --dry-run`, exited 124 with zero lines of output.
- On a customer Windows machine under Git Bash, the run failed for every project directory and no archive was kept. The exact error text was not captured.

Evidence.

- `$HOME/Projects` holds 92,657 directories, measured with `find "$HOME/Projects" -name .git -prune -o -type d -print | wc -l`.
- `support-files/backup-ai.sh:193` runs `find "$TARGET_ABS" -name .git -prune -o -type d -print0` over the entire tree. There is no depth bound and no prune for `node_modules`, `vendor`, caches, or the workflow clone.
- The discovery loop at lines 203-222 scans every directory and calls `is_under_workflow` per directory. That helper calls `dirname` in a loop, so process creation grows with the tree. Process creation is slow on Windows Git Bash, which matches the long silent run.
- Nothing is printed until discovery and the project loop finish, so the terminal looks dead during a large scan.

Confirmed Windows failure, 2026-11-20.

- The owner-only check at line 175 runs `find "$out" -perm 600`. On Windows Git Bash, the created archive does not report POSIX mode 600, so every good archive is rejected and deleted as `archive is not owner-only`.
- The reporter confirmed this is the failing check on the customer machine.
- The `--dry-run` path skips the permission check, so a dry run looks healthy while the real run fails.

Expected behaviour.

- Stream progress: the target, the discovery phase, each project found, each archive written, and a final summary.
- Bound the scan: a depth limit, a prune list for heavy directories, and a skip of the workflow clone before its subtree is walked.
- Replace the per-directory `dirname` walk with a prefix or ancestor test that does not spawn a process per directory.
- Make the ownership check platform-aware, and treat it as advisory when the filesystem has no POSIX modes.
- Print one clear line per failure, keep the exit codes, and never fail silently.
- Validate on Windows Git Bash, or direct Windows users to `backup-ai.ps1`.

Workaround until fixed.

- Use a narrower target path, for example one project directory at a time.
- On Windows, try `backup-ai.ps1` with `pwsh` 7.
- Capture stderr for diagnosis: `./backup-ai.sh --target-path PATH --dry-run 2>&1 | tee /tmp/backup.log`.

Not verified.

- The exact Windows error text was not captured, but the failing check is confirmed as the owner-only test at line 175.

---

2026-11-20

Confirmed the Windows failure is the owner-only check at `backup-ai.sh:175`. The archive is created, then deleted because `find -perm 600` does not see a POSIX mode under Git Bash. Fix direction: detect whether the filesystem reports POSIX modes, keep the forced 0600 where it does, and on Windows accept the archive and report that ACL verification is unavailable instead of deleting it.

---

## Implementation Plan

- **Repo**: Simple-AI-Workflow
- **Base ref**: master
- **Branch**: fix/backup-scripts-hardening
- **Release**: v7.0.1, patch

### Evidence

- `$HOME/Projects` holds 92,657 directories.
- `timeout 8 ./support-files/backup-ai.sh --target-path "$HOME/Projects" --dry-run` exited 124 with zero lines of output.
- The walk had no prune list and no bound, and `is_under_workflow` spawned `dirname` per directory.
- The tar stderr was discarded, so failures printed no cause.
- The owner-only check treated a missing POSIX mode as a fatal archive error.
- The reporter confirmed the Windows failure is that check under Git Bash.
- `pwsh` is absent on this host, so the PowerShell script is reviewed statically here.

### Goals

- Stream progress in both scripts.
- Bound the walk with a prune list and an early clone skip.
- Verify the archive permission in a platform-aware way and never delete a good archive because a proxy check cannot run.
- Print the real cause when tar or a copy fails.
- Keep the exit-code contract: 0 success, 1 project failures, 2 configuration or discovery failure.

### Output contract

- `Scanning <target> for workflow projects` before discovery.
- `Found project: <path>` when discovery matches a project.
- `Discovery complete: <n> project(s) found` after the walk.
- `Backing up: <path>` before the tar for each project.
- `Backed up: <path> -> <archive>` on success.
- `FAILED: <project>: <reason>` on a project failure.
- `Summary: <n> archived, <m> failed, <w> warnings; archives in <dir>` at the end.

The summary prints when zero projects are found. Discovery warnings keep the existing wording and set exit 2.

### Prune list

Skip `.git`, `node_modules`, `.venv`, `venv`, `vendor`, `target`, `build`, `dist`, `.next`, `.cache`, `__pycache__`, and `.terraform` before descent. Skip the workflow clone in the walk itself. There is no depth cap.

### Bash changes

- One `find` expression holds the prune names, the clone prune, and `-type d -print0`.
- Discovery streams into the loop with `exec 3< <(find ...)`, so `Found project` prints during the walk.
- `is_under_workflow` uses a shell pattern on the clone path, with no process per directory.
- POSIX mode support is resolved once at startup, with the test-only `BACKUP_AI_POSIX_MODES` override.
- POSIX: force and verify mode 600. Git Bash and MSYS: keep the archive and print that ACL verification is unavailable.
- Tar and `cp -L` stderr are printed on failure.
- The summary counts archived, failed, and warnings.

### PowerShell changes

- An explicit stack replaces the recursion, so deep trees cannot exhaust the call stack.
- The prune list, clone skip, and reparse-point skip apply before a child is pushed.
- A matched project is not descended into.
- Progress and summary lines mirror the Bash contract.
- `icacls` stays the control. On failure, keep the archive, print a warning, and exit 1.

### Tests

- Case 18: a `node_modules` subtree that looks like a project is not archived.
- Case 19: `Scanning`, `Found project`, `Discovery complete`, `Backing up`, and `Summary` appear.
- Case 20: `BACKUP_AI_POSIX_MODES=0` keeps the archive and prints the unavailable notice.
- Case 21: a fake `tar` first on `PATH` proves its message is printed and the exit is 1.
- Case 22: the mixed fixture reports one archived and one failed.
- `tests/verify-powershell-scripts.ps1` gains progress, summary, and prune checks for the Windows host.

### ADRs

- Prune heavy directories by name. A project inside one is not found; those directories never hold workflow projects.
- A POSIX mode check is a proxy. Gate it by platform and keep the archive when the check cannot run.
- Stream progress. A silent run looks hung.

### Close sequence

- Direct squash merge, because `ai-customization.md` has no `## Merge Policy` section.
- Close this ticket with the plan attached, delete the plan file, checkpoint on the branch, then commit, merge, tag v7.0.1, publish the release, and delete the branch.

### Peer Review Log

- Review-71: CHANGES REQUESTED. Five Majors, four Minors.
- Review-72: APPROVED.
- Review-73: CHANGES REQUESTED. Two Majors, four Minors.
- Review-74: APPROVED. Gates: backup test 57 checks, shellcheck 0, suite 27/27, protocol 8/8, markdownlint 0.
