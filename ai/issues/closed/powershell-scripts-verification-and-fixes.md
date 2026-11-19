Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Fix the sync-agents-md.ps1 -WhatIf migration failure and verify both protocol PowerShell scripts on Windows

Description:

**Context**: The protocol has two Windows PowerShell scripts, `support-files/sync-agents-md.ps1` and `support-files/backup-ai.ps1`. A Windows 11 VM with pwsh 7.7.0 and a minimal fixture now exists and was used for a first smoke test on 2026-11-19.

**Defect**: `sync-agents-md.ps1 -WhatIf` on a project with the old `ai/ai-customization.md` layout prints `Moving ... and adding config section` and then fails with `Cannot find path '...\ai-customization.md' because it does not exist.` The real run succeeds. `Add-MergePolicySection` reads the destination file before checking `$WhatIf`; the destination does not exist in a dry run.

**Working path**: The real sync run migrated the old file, added the Merge Policy, and synced both `AGENTS.md` files. `backup-ai.ps1` passed the `-WhatIf`, real, and `-ExcludeSecrets` runs; the archives were created and the excluded-secret archive was smaller.

**Scope**:

- Fix the `-WhatIf` path so it reports the planned migration without reading or writing a file the real run would create.
- Add a repeatable Windows verification script that exercises both scripts, and run it in the VM.
- Keep the bash scripts and the repo test suite unchanged unless shared behavior must change.

**Acceptance criteria**:

- The sync `-WhatIf` on the old-layout fixture exits 0, reports the planned move and Merge Policy, and writes nothing.
- The real sync still migrates the old file and adds the Merge Policy.
- The backup dry run, real run, and `-ExcludeSecrets` pass in the VM.
- A repeatable verification script exists and the VM output is recorded.
- The repo's suite, validators, markdownlint, and shellcheck stay green; the pwsh syntax is checked.
- `support-files/README.md` is updated only if behavior changes.

**Related**: `support-files/sync-agents-md.ps1`, `support-files/backup-ai.ps1`, the Windows test VM, and the v6.11.0 backup scripts.

## Implementation Plan

# Plan: Fix and verify the protocol PowerShell scripts

## Context

The protocol ships two Windows PowerShell scripts: `support-files/sync-agents-md.ps1` and `support-files/backup-ai.ps1`. A Windows 11 VM with pwsh 7.7.0 is now available and was used for a first smoke test. The sync `-WhatIf` path fails on the old `ai/ai-customization.md` layout; the real run and the backup paths work.

Ticket: `ai/issues/open/powershell-scripts-verification-and-fixes.md`
Size: `Human-to-decide (AI estimate: S)`. The fix is small; the verification script is the other half.

## Evidence

- The VM smoke test on 2026-11-19: `sync-agents-md.ps1 -WhatIf` exited 1 with `Cannot find path '...\ai-customization.md' because it does not exist`; the real run exited 0 and migrated both projects.
- `support-files/sync-agents-md.ps1:113-127`: `Add-MergePolicySection` calls `Get-Content -Raw` on the destination before the `$WhatIf` check. In the old-layout dry run, the destination is not created because the `Move-Item` is skipped (lines 186-197), so the read throws.
- The same VM run: `backup-ai.ps1 -WhatIf`, the real run, and `-ExcludeSecrets` all exited 0; the `proj-a` archive was 51 bytes smaller without `ai/secrets`.
- The VM test environment: the minimal workflow copy at `C:\Users\kamran\Projects\Simple-AI-Workflow`, the projects at `C:\Users\kamran\Projects\test-projects`, and pwsh 7.7.0 on PATH.

## Changes

### 1. `support-files/sync-agents-md.ps1`

Fix `Add-MergePolicySection` so it does not read a file the real run would create:

- If the file does not exist and `$WhatIf` is set, print `ai-customization.md: would add Merge Policy` and return.
- If the file does not exist and `$WhatIf` is not set, throw a clear error.
- Otherwise read the file, return when the `## Merge Policy` heading exists, and keep the existing `$WhatIf` behavior.
- No change to the migration, the AGENTS.md sync, or the default customization content.

### 2. `tests/verify-powershell-scripts.ps1`

Add a self-contained Windows verification script, run with pwsh 7:

- The parameters: `-WorkflowDir` (default the repository root) and `-TestRoot` (a temporary directory).
- The fixtures: an old-layout project with `ai/ai-customization.md`, a project with only `AGENTS.md`, and a backup directory.
- The sync `-WhatIf`: exit 0, the old file stays in `ai/`, the root customization is not created, and the planned move and Merge Policy are printed.
- The sync real run: the old file moves to the root, the Merge Policy is added, and both projects sync.
- The backup `-WhatIf`, real, and `-ExcludeSecrets`: the archives exist; the `ai/secrets` entry is absent from the excluded archive; the ACL is owner-only.
- The parser check for both scripts; a pass/fail summary; cleanup of the temporary tree.

### 3. Documentation

No README change unless the fix alters documented behavior. The README already documents `-WhatIf`; the fix makes it match its promise.

## Acceptance Criteria

- The sync `-WhatIf` on the old-layout fixture exits 0, reports the planned move and Merge Policy, and writes nothing.
- The real sync still migrates the old file and adds the Merge Policy.
- `backup-ai.ps1` passes the dry run, real run, and `-ExcludeSecrets` in the VM.
- `tests/verify-powershell-scripts.ps1` passes in the VM and its output is recorded.
- The repo suite (26/26), both validators, markdownlint, and shellcheck stay green.
- The pwsh scripts parse without errors.
- No bash script or protocol behavior changes.

## Verification

1. In the VM: `pwsh -NoProfile -ExecutionPolicy Bypass -File C:\Users\kamran\Projects\Simple-AI-Workflow\tests\verify-powershell-scripts.ps1` (after copying the updated files). The bash suite does not discover this `.ps1`; the VM run is its gate.
2. On the host: `bash tests/run-all.sh`, `bash support-files/validate-protocol.sh`, `markdownlint-cli2` on the changed docs, and `shellcheck` on the changed bash files (none expected).
3. The pwsh parser on the two scripts and the verification script.

## Out of Scope

- The bash sync and backup scripts.
- A patch release unless the human requests one.
- A new Windows CI runner; the VM is the verification host.
- Reworking the sync script beyond the `-WhatIf` fix.

## Risks

- The test script runs manually on Windows; the bash suite does not discover it. The VM evidence is the gate.
- The `icacls` ACL check depends on the local account identity; the test accepts the current user as owner.
- A future Windows path change can break the fixture; the test uses `Join-Path` and `$TestRoot`.

## Peer Review Log

- Round 1: APPROVED, `ai/code-review-reports/2026-11-19_21-05_review-65.md`. Two Minors and one Suggestion; applied.
- Implementation review: APPROVED, `ai/code-review-reports/2026-11-19_21-10_review-66.md`. The VM run passed every check; two Minors, no Critical or Major.

## Close Sequence

- Repo: `KamranAzeem/Simple-AI-Workflow`. Base: `master`. Branch: `fix/powershell-scripts-verification`.
- The fix, the test script, the VM verification, the repo suite, and the implementation review.
- The issue moves to `in-progress/` while the branch is active.
- The checkpoint runs on the branch before the commit; the plan is attached to the ticket and removed.
- Terminal gate: resolve `master`, confirm at least one commit ahead, confirm a clean tree, and record the outputs.
- The squash merge to `master` after approval; the issue closes; no release unless requested.
