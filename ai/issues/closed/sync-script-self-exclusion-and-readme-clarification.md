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

---

2026-10-28
Plan attached below under the work-item lifecycle rule.

## Implementation Plan: Sync Script Self-Exclusion and README Clarification

Ticket: `ai/issues/in-progress/sync-script-self-exclusion-and-readme-clarification.md`
Date: 2026-10-28
Status: Approved after peer review round 3; ready to implement

## Context

On macOS, running `sync-agents-md.sh` from a workflow clone that sits under the target path (`~/Projects`) finds the clone's own `AGENTS.md`. The clone path is `/Users/<user>/projects/Simple-AI-Workflow`, while discovery returns `/Users/<user>/Projects/Simple-AI-Workflow/AGENTS.md`. The filesystem is case-insensitive; the shell comparison is not. The source is not excluded, `cp -f` reports the files are identical, `set -e` aborts, and the remaining projects are never processed.

The PowerShell script excludes the exact source path, but it does not exclude the whole workflow directory. Both scripts should use the same discovery-first, workflow-tree-excluded, identical-file-safe, per-target-continue behavior.

The README also needs a clearer distinction: a manual `AGENTS.md` copy gets the latest protocol file, but the sync script also performs maintenance such as `ai-customization.md` checks and state-file migration. Manual copying is only half the work.

## Goal

Fix both sync scripts so the workflow's own `AGENTS.md` is never a target, identical targets are skipped without error, and one bad target does not stop the rest. Clarify the manual-copy limitation in the README and the docs that repeat the claim, and recommend the sync script for updates.

## Design

### Shared invariants

- Discover all `AGENTS.md` files under the resolved target path first, into a list.
- Exclude the workflow clone and everything under it, not only the source file.
- Derive the workflow clone from the script location, not from the source directory.
- Treat path identity with device and inode comparisons, so macOS and Windows case differences and symlinks do not break the exclusion.
- Skip a target whose content is already identical to the source, but still run the maintenance steps for that target.
- Process each target independently. Record a failed target, continue to the next, print a summary, and exit non-zero only when there were real failures.
- Keep `--dry-run` and `-WhatIf` free of writes while still previewing the maintenance steps.
- Add no new scripts and no release.

### Bash changes

Keep `set -euo pipefail` for setup and discovery. Do not rely on `set -e` inside `process_target`: a function called in an `if` condition runs with `errexit` disabled for its whole body. Check every command explicitly and end the function with `return 0`.

1. Derive the clone root from the script, not the source:

    ```bash
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
    WORKFLOW_DIR=$(dirname "$SCRIPT_DIR")
    ```

    `SRC_ABS` remains the resolved source file. The `Global AI Workflow Directory` and the tree exclusion use `WORKFLOW_DIR`, the clone root.

2. Add an inode-based ancestor walk:

    ```bash
    is_under_workflow() {
      local dir="$1"
      while :; do
        [ "$dir" -ef "$WORKFLOW_DIR" ] && return 0
        [ "$dir" = "/" ] && return 1
        dir=$(dirname "$dir")
      done
    }
    ```

    This avoids a Darwin-only branch, handles case-insensitive filesystems, and follows resolved symlinks because both paths come from `pwd -P`.

    Warn when the source is outside the clone:

    ```bash
    if ! is_under_workflow "$(dirname "$SRC_ABS")"; then
      echo "Warning: source $SRC_ABS is outside the workflow clone $WORKFLOW_DIR; the clone root still drives the config and exclusion." >&2
    fi
    ```

3. Discover into a temp file and keep the `find` status:

    ```bash
    list_file=$(mktemp) || { echo "Error: cannot create a temp file" >&2; exit 2; }
    err_file=$(mktemp) || { echo "Error: cannot create a temp file" >&2; rm -f "$list_file"; exit 2; }
    discovery_failed=0
    if ! find "$TARGET_ABS" -type f -name 'AGENTS.md' -print0 > "$list_file" 2>"$err_file"; then
      echo "Warning: some directories under $TARGET_ABS could not be read; processing the matches that were found." >&2
      cat "$err_file" >&2
      discovery_failed=1
    fi
    rm -f "$err_file"
    ```

    Use `$TARGET_ABS`, not `$TARGET_PATH`, so a symlinked target directory is traversed.

4. Initialize `matches=()` and build the matches list. For each candidate:
   - Resolve the directory with `f_dir=$(cd "$(dirname "$f")" && pwd -P)`; on failure, print an error and count it as a discovery failure.
   - Rebuild `f_abs="$f_dir/$(basename "$f")"`.
   - Skip the source with `[ "$f_abs" -ef "$SRC_ABS" ]` and print `Skipping source file: $f_abs`.
   - Skip the clone tree with `is_under_workflow "$f_dir"` and print `Skipping workflow file: $f_abs`.
   - Append the remaining files to `matches`.
   - Remove the temp list after discovery.
   - If `matches` is empty and `discovery_failed` is 0, print `No AGENTS.md files found under $TARGET_ABS` and exit 0 after the skip logs.
   - If `matches` is empty and `discovery_failed` is 1, report the discovery failure and exit 2.
   - If `matches` is not empty, process the matches; after the loop, report a discovery failure and exit 2 if `discovery_failed` is 1.

5. Add `process_target` with explicit checks:

    ```bash
    process_target() {
      local f_abs="$1"
      local target_root cmp_rc
      target_root=$(dirname "$f_abs") || return 1
      echo "Target: $f_abs"

      if cmp -s "$SRC_ABS" "$f_abs"; then
        echo "  AGENTS.md already up to date"
      else
        cmp_rc=$?
        if [ "$cmp_rc" -gt 1 ]; then
          echo "  ERROR: cannot compare $f_abs"
          return 1
        fi
        if [ "$DRY_RUN" -eq 1 ]; then
          echo "  DRY-RUN: would update $f_abs from source"
        else
          cp -f "$SRC_ABS" "$f_abs" || return 1
          echo "  AGENTS.md synced"
        fi
      fi
      if [ "$DRY_RUN" -eq 1 ]; then
        echo "  (AGENTS.md sync)"
      fi

      ensure_state_files_migration "$target_root" || return 1
      ensure_customization_file "$target_root" || return 1
      return 0
    }
    ```

    In dry-run, the helpers still run and preview their actions; they already guard writes.

6. Extract `ensure_state_files_migration` with explicit checks:
   - `mkdir -p "$state_dir" || return 1`
   - `mv "$old_path" "$new_path" || return 1`
   - `migration_date=$(date +%Y-%m-%d) || return 1`
   - `printf '\n[MIGRATION-%s] State files relocated from ai/ to ai/state/ per AGENTS.md TIER CONFIGURATION (resolve **Project AI State Files** to ai/state/)\n' "$migration_date" >> "$new_path" || return 1`
   - Keep the existing `if [ "$DRY_RUN" -eq 0 ]` guard around `mkdir`, `mv`, and the append; the `|| return 1` checks wrap the guarded block.

7. In `ensure_customization_file`, add explicit checks to every write and every pipeline:
   - `tmp=$(mktemp) || return 1`
   - `head -1 "$customization_file" > "$tmp" || { rm -f "$tmp"; return 1; }`
   - `make_config_section >> "$tmp" || { rm -f "$tmp"; return 1; }`
   - `tail -n +2 "$customization_file" >> "$tmp" || { rm -f "$tmp"; return 1; }`
   - `mv "$tmp" "$customization_file" || return 1`
   - `current_dir=$(grep '^\*\*Global AI Workflow Directory\*\*:' "$customization_file" | head -1 | sed 's/...//') || return 1`
   - `escaped_dir=$(printf '%s' "$WORKFLOW_DIR" | sed 's/[&\]/\\&/g') || return 1`
   - `sed ... > "$tmp" || { rm -f "$tmp"; return 1; }`
   - `replace_file "$tmp" "$customization_file" || return 1`
   - `cat > "$customization_file" <<CUSTEOF ... CUSTEOF || return 1`
   - In `replace_file`, check `cat`, `rm`, and `mv`; return 1 on failure.
   - Verify the replacement changed the expected line; if not, return 1.
   - Keep the existing `if [ "$DRY_RUN" -eq 0 ]` guard around each write; the `|| return 1` checks wrap the guarded block.

8. Run the loop with explicit status handling:

    ```bash
    set +e
    failed_targets=()
    for f_abs in "${matches[@]}"; do
      if process_target "$f_abs"; then
        :
      else
        failed_targets+=("$f_abs")
        echo "  FAILED: $f_abs"
      fi
      echo "----------------------------------------------------------------------------"
    done
    set -e
    ```

9. Print `Processed ${#matches[@]} target(s); ${#failed_targets[@]} failed.` If `failed_targets` is non-empty, list the targets with a guarded loop and exit 1. If `discovery_failed` is 1, print the discovery failure and exit 2. Otherwise print `Done.` and exit 0. Keep the failed-target loop guarded so bash 3.2 does not expand an empty array under `set -u`.

### PowerShell changes

1. Derive the clone root from the script, not the source:

    ```powershell
    $scriptDir = $PSScriptRoot
    $workflowDir = Split-Path -Parent $scriptDir
    $workflowDirFull = (Get-Item -LiteralPath $workflowDir -Force).FullName.TrimEnd(
      [System.IO.Path]::DirectorySeparatorChar,
      [System.IO.Path]::AltDirectorySeparatorChar
    )
    ```

    Update the `.DESCRIPTION` help text: the workflow directory is derived from the script location, not the source path.

    Warn when the source is outside the clone:

    ```powershell
    if (-not $srcPath.StartsWith($workflowDirFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
      Write-Warning "Source $srcPath is outside the workflow clone $workflowDirFull; the clone root still drives the config and exclusion."
    }
    ```

    Symlinked workflow roots are documented as out of scope; use the real clone path.

2. Build the list explicitly and filter it:

    ```powershell
    $discoveryErrors = @()
    $foundFiles = @(
      Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue -ErrorVariable +discoveryErrors |
        Where-Object {
          $full = $_.FullName
          -not $full.Equals($srcPath, [System.StringComparison]::OrdinalIgnoreCase) -and
          -not $full.StartsWith(
            $workflowDirFull + [System.IO.Path]::DirectorySeparatorChar,
            [System.StringComparison]::OrdinalIgnoreCase
          )
        }
    )
    if ($discoveryErrors.Count -gt 0) {
      Write-Warning "Some directories under $targetAbs could not be read; processing the matches that were found."
      $discoveryErrors | ForEach-Object { Write-Warning $_.Exception.Message }
    }
    if ($foundFiles.Count -eq 0 -and $discoveryErrors.Count -eq 0) {
      Write-Host "No AGENTS.md files found under $targetAbs"
      exit 0
    }
    if ($foundFiles.Count -eq 0 -and $discoveryErrors.Count -gt 0) { exit 2 }
    ```

    Suppress the console error but capture it with `-ErrorVariable`; the warning makes the discovery failure visible. Process the readable matches, then exit 2 after the loop.

3. Process the list with a per-target `try`/`catch` and an explicit `-WhatIf` guard:

    ```powershell
    $failedTargets = @()
    foreach ($m in $foundFiles) {
      $target = $m.FullName
      $targetRoot = Split-Path -Parent $target
      Write-Host "Target: $target"
      try {
        if ($WhatIf) {
          Write-Host "  DRY-RUN: would update $target from source"
          Write-Host "  (AGENTS.md sync)"
        } else {
          $srcBytes = [System.Text.UTF8Encoding]::new($false).GetBytes($srcContent)
          $targetBytes = [System.IO.File]::ReadAllBytes($target)
          $sha = [System.Security.Cryptography.SHA256]::Create()
          $srcHash = [Convert]::ToBase64String($sha.ComputeHash($srcBytes))
          $targetHash = [Convert]::ToBase64String($sha.ComputeHash($targetBytes))
          if ($srcHash -eq $targetHash) {
            Write-Host "  AGENTS.md already up to date"
          } else {
            [System.IO.File]::WriteAllText($target, $srcContent, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  AGENTS.md synced"
          }
        }
        Ensure-StateFilesMigration -ProjectRoot $targetRoot
        Ensure-CustomizationFile -ProjectRoot $targetRoot -WorkflowDir $workflowDir
      } catch {
        Write-Host "  ERROR: $($_.Exception.Message)"
        $failedTargets += $target
      }
      Write-Host "------------------------------------------------------------"
    }
    ```

4. Set `$ErrorActionPreference = 'Stop'` inside the try block, and add `-ErrorAction Stop` to `Move-Item`, `Add-Content`, `New-Item`, and `Get-Content` in the helpers. The .NET file calls throw.
5. After the loop, print `Processed $($foundFiles.Count) target(s); $($failedTargets.Count) failed.` If `$failedTargets.Count -gt 0`, list the targets and `exit 1`. If `$discoveryErrors.Count -gt 0`, exit 2. Otherwise print `Done.` and exit 0.
6. Keep `-WhatIf` write-free. The helpers already guard their writes; the preview still runs.

### README and docs changes

1. Quick start after steps 5 and 6:
   - Do not say the sync script does steps 5 and 6 wholesale.
   - Say: the sync script updates projects that already have `AGENTS.md` and checks or creates `ai-customization.md` with defaults. It does not create `AGENTS.md` for a new project; use the manual steps for the first copy. After that, the sync script is the recommended update path.
2. Replace the note at `README.md:291` with:

    > **Note:** You *can* copy `AGENTS.md` manually. That gives you the latest protocol file, but it is only half the work. The sync script also checks or creates `ai-customization.md` with the correct `Global AI Workflow Directory` and migrates state files to `ai/state/`. If you copy manually, you must do those maintenance steps yourself. Using the sync script is highly recommended.

3. Clarify the feature bullet at `README.md:344`: the script updates existing `AGENTS.md` files and checks the customization file; it does not create a new project's `AGENTS.md`.
4. Update the live manual-copy claims:
   - `README.md:44`: the sentence "You copy `AGENTS.md` and `ai-customization.md` into your project" reads as a supported install path; add the manual-copy maintenance caveat and the sync-script recommendation for updates.
   - `support-files/README.md:8`: add the maintenance caveat.
   - `support-files/README.md:33`: remove the false claim that `--source` must appear before `--target-path`; the parser accepts either order.
   - `support-files/README.md`: add the workflow-clone exclusion to the Behavior list, and update the behavior and dry-run example for the skip and up-to-date messages.
   - `docs/example-learning-session-runbook.md:32`: add the sync-script recommendation.
   - `docs/ai-policy-mobile-apps-guide.md:88`: add the sync-script recommendation.
   - Do not edit `docs/announcements/v5.3.0.md`; it is a historical announcement.
   - `docs/ai-customization-guide.md` has no manual-copy claim; leave it unchanged.
5. No release announcement.

## Files to Change

- `support-files/sync-agents-md.sh`
- `support-files/sync-agents-md.ps1`
- `support-files/test-sync-agents-md.sh` (extend the existing regression test)
- `README.md`
- `support-files/README.md`
- `docs/example-learning-session-runbook.md`
- `docs/ai-policy-mobile-apps-guide.md`

No protocol or policy change. No ADR is needed for a support-script and documentation fix.

## Implementation Steps

1. Open `fix/sync-agents-md-self-exclusion` before any edit.
2. Apply the bash changes: clone-root derivation, inode ancestor walk, discovery status handling, skip logs, `process_target`, explicit helper checks, summary and exit status.
3. Apply the PowerShell changes: clone-root derivation, list filter, hash comparison, explicit `-WhatIf` guard, per-target try/catch, failure list, summary and exit status.
4. Update the README, `support-files/README.md`, and the two live docs claims.
5. Extend `support-files/test-sync-agents-md.sh` with the new cases and update its expected workflow path to the clone root.
6. Run the test plan.
7. Run a focused implementation peer review on the branch diff. Fix any Critical or Major finding and re-review.
8. Present the diff, verification summary, and proposed commit message: `fix(sync): exclude the workflow tree and keep syncing after failures`. Get explicit human approval before staging or committing. Get explicit human approval before closing the ticket, squash-merging to `master`, deleting the branch, or pushing. Run any acceptance check against real multi-project paths only with prior approval; use a temp tree by default. Do not create a release.

## Test Plan

### Existing regression test

- `bash support-files/test-sync-agents-md.sh` passes.
- Update the expected `Global AI Workflow Directory` from `$WORK/src` to the clone root: `EXPECTED_WORKFLOW_DIR=$(cd "$DIR/.." && pwd -P)`.
- Extend the test with the cases below.

### Self-exclusion and siblings

Create a temp target tree with a copied workflow clone and a sibling:

```text
$WORK/target/
  Simple-AI-Workflow/          copied clone with AGENTS.md, support-files, and sub/AGENTS.md
  Simple-AI-Workflow-Other/    sibling with AGENTS.md
  project-a/                   AGENTS.md with different content
  project-identical/           AGENTS.md identical to the source
  project-missing-custom/      AGENTS.md, no ai-customization.md
```

Run the copied clone's script with `--source "$clone/AGENTS.md" --target-path "$WORK/target"`.

Expect:

- The clone's own `AGENTS.md` is not modified, and the log contains `Skipping source file`.
- The nested `$clone/sub/AGENTS.md` is not modified, and the log contains `Skipping workflow file`. This exercises the tree walk, not only the source skip.
- `Simple-AI-Workflow-Other` is processed; the trailing-separator/sibling exclusion is not overbroad.
- `project-a` and `project-missing-custom` are synced and get the correct `ai-customization.md`.
- `project-identical` reports `AGENTS.md already up to date` and still gets the customization check.
- Exit status 0.

### Discovery, symlinks, and source location

- Unreadable subtree, non-root: create a target with `chmod 000` on one subdirectory and a readable target elsewhere. Run the script. Expect the readable target to be processed, the discovery failure to be reported, and exit 2. Skip this case under root.
- Symlinked target: make `--target-path` a symlink to a directory containing `AGENTS.md`; expect the target to be processed.
- Source in a subdirectory of the clone: run with `--source "$clone/sub/AGENTS.md"`; expect the clone root as the config path, the source skipped, and the clone tree excluded.
- Source outside the clone: run with a temp source; expect the outside-source warning, the clone root as the config path, and no source-tree exclusion.

### macOS case test

Repeat with the workflow clone under `/Users/.../projects/Simple-AI-Workflow` and the target `/Users/.../Projects`, so the path case differs. Expect the workflow tree excluded and every other target processed.

### Failure isolation

Make one target's parent directory read-only. Run as a non-root user. A read-only file alone is not enough, because `cp -f` can replace it when the directory is writable. Expect:

- The failing target is reported.
- The remaining targets are still processed.
- The final exit status is 1.
- If the test runs as root, skip this case with a clear message; root can write read-only files.

### Dry run

Run each case with `--dry-run` before the real run, or rebuild the tree. Expect no file changes and the maintenance preview. An identical target prints `AGENTS.md already up to date` in dry-run too. Record a hash before and after.

### PowerShell

On Windows PowerShell 5.1 and PowerShell 7:

- Run `-WhatIf` and confirm no changes with a hash before and after.
- Run against a temp tree with the workflow clone under the target path, a sibling, a different target, an identical target, and a missing customization file.
- Confirm the workflow tree is excluded, the sibling is processed, identical targets are skipped, and the other targets are processed.
- Make one target's parent directory read-only and confirm the failure is reported, the remaining targets run, and the exit status is 1.
- A BOM-prefixed target with identical text is rewritten BOM-less on the first run and is up to date on the second.
- A source outside the clone produces the warning and still uses the clone root for the config path.
- Parser check:

    ```powershell
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
      (Resolve-Path .\support-files\sync-agents-md.ps1).Path,
      [ref]$null,
      [ref]$parseErrors
    ) | Out-Null
    if ($parseErrors) { $parseErrors.Count } else { 0 }
    ```

### Static and repo checks

- `bash -n support-files/sync-agents-md.sh`
- `shellcheck support-files/sync-agents-md.sh` if available.
- Run the bash test under macOS `/bin/bash` 3.2 as well as the Linux host; keep empty-array loops guarded.
- `markdownlint-cli2` on the changed docs only.
- `bash support-files/validate-protocol.sh` remains 8/8.
- `git diff --check`.

## Acceptance Criteria

- Running the bash script from the workflow clone with `--target-path` set to the clone's parent does not sync the workflow's own `AGENTS.md`, logs the skip, and processes every other target.
- A sibling directory such as `Simple-AI-Workflow-Other` is processed.
- An identical `AGENTS.md` in another project is skipped gracefully, its maintenance still runs, and the run does not abort.
- A failure on one target is reported, the remaining targets run, and the final exit status is 1.
- The PowerShell script behaves the same under Windows PowerShell 5.1 and PowerShell 7.
- `--dry-run` and `-WhatIf` make no changes and preview the maintenance.
- The README and live docs explain the manual-copy limitation with the maintenance examples and recommend the sync script for updates.
- The existing regression test passes and is extended with the new cases.
- `bash -n`, the PowerShell parse check, the sync-script tests, markdownlint, and `validate-protocol.sh` 8/8 pass.
- The bash fix is tested on macOS, where the path case difference occurs, and on Linux.
- No release.

## Risks

- `errexit` is inert inside a function called from an `if` condition. The plan uses explicit `|| return 1` and status checks, not `set -e`, inside `process_target` and the helpers.
- `find` can fail on an unreadable subtree. The plan processes the readable matches, reports the discovery failure, and exits 2 after the run instead of reporting an empty success.
- An outside-clone `--source` is warned about; the clone root still drives the config and the tree exclusion.
- Case-insensitive filesystems and symlinks. The plan uses `pwd -P` and device/inode comparisons, not string prefixes.
- A symlinked workflow root is unsupported in PowerShell; use the real clone path. Target `AGENTS.md` symlinks keep their current `cp -f`/`WriteAllText` behavior; no new symlink handling.
- A BOM in a target would be ignored by text comparison. The plan compares the exact BOM-less bytes the PowerShell script writes to the target bytes, and uses `cmp` bytes in bash, so a BOM difference is rewritten.
- The README could overpromise. The plan says the script updates existing `AGENTS.md` files and creates default customization content; the user still supplies expertise, traits, and compliance.

## Out of Scope

- A release, version bump, or announcement.
- Protocol or policy changes.
- New scripts.
- Symlinked workflow roots in PowerShell; use the real clone path.
- Following symlinked target `AGENTS.md` files; behavior is unchanged.
- Changing the customization-file migration logic beyond making failures recoverable.

## Decisions

- Path identity: device/inode ancestor walk in bash and `OrdinalIgnoreCase` prefix in PowerShell.
- Workflow directory: the clone root derived from the script location, not the source directory.
- Per-target failures: continue, summarize, and exit 1.
- Discovery failures: both scripts process the readable matches, report the failure, and exit 2.
- Outside-clone source: warn, keep the clone root as the config and exclusion base.
- Identical content: compare bytes, so a BOM-only difference is rewritten.
- Dry-run: show the same already-up-to-date or would-update result as the real run.
- README wording: the sync script updates existing `AGENTS.md` files; a manual copy is needed for a brand-new project.
- No ADR: a support-script and documentation fix, not a protocol or policy change.

## Peer Review Log

- Round 1: CHANGES REQUESTED. Report: `ai/code-review-reports/2026-10-28_18-30_review-01.md`. 0 Critical, 6 Major, 11 Minor, 8 Nit. This revision applies the notes: skip logs, inode ancestor walk, explicit bash status checks, `-WhatIf` guard, approval gate, existing regression test, accurate README/docs claims, discovery error handling, clone-root derivation, and the additional tests.
- Round 2: CHANGES REQUESTED. Report: `ai/code-review-reports/2026-10-28_18-50_review-02.md`. 0 Critical, 1 Major, 7 Minor, 4 Nit; 2 partials. This revision adds the staging/commit approval gate and proposed commit message, process-readable discovery failures, the outside-clone warning, the nested tree-exclusion test, unreadable/symlink/source-location tests, the dry-run identical preview, the PowerShell help-text and BOM fixes, and the README/docs corrections.
- Round 3: APPROVED. Report: `ai/code-review-reports/2026-10-28_18-55_review-03.md`. 0 Critical, 0 Major, 2 Minor, 2 Nit. Applied: explicit `matches=()` initialization, PowerShell partial discovery with `-ErrorVariable` and exit 2, SHA256 byte comparison, and a parent-directory read-only failure test.
