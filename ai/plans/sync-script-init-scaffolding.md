# Plan: Sync Init Role Presets

## Goal

Add an `--init` mode to `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1` that scaffolds a new project root from a named role preset. The mode writes only `AGENTS.md` and `ai-customization.md`, creates no `ai/` directory, removes the `Default Shell` key from the presets and the template, documents the path in `docs/setup.md`, and keeps Bash and PowerShell parity. Release a MINOR version. No TSV manifest in this task.

## Evidence

### Sources

- Ticket `ai/issues/open/sync-script-init-scaffolding.md` lines 94-115 hold the settled decisions. They supersede the earlier open points and are binding. Line 98 defers the TSV manifest. Lines 99-111 fix the CLI, preset lookup, workflow substitution, Default Shell removal, target rules, write safety, exit codes, messages, bootstrap hint, docs, idempotence, symlink tests, and the acceptance cleanup.
- `docs/examples/customization-presets/` holds the eight presets: `cloud-architect`, `solution-architect`, `web-developer`, `mobile-developer`, `platform-engineer`, `dba`, `data-engineer`, `security-engineer`. Each carries `**Default Shell**: bash` at line 13, except `platform-engineer.md` at line 14.
- `docs/ai-customization.md` line 13 carries `**Default Shell**: bash`, and line 21 is the comment that advertises the key.
- `docs/ai-customization-guide.md` lines 11-12 document the optional `Default Shell` and `Default Shell Path` keys. Section 11 runs from line 274 to line 294 and lists the eight role slugs.
- `docs/setup.md` line 51 says the sync script "does not create `AGENTS.md` for a new project". The new init path contradicts that sentence, so it must change.
- `support-files/sync-agents-md.sh` is 588 lines. Argument parsing is lines 25-48. `is_under_workflow` is lines 64-71. The temp-write helper `replace_file` is lines 215-223. The source and workflow exclusions are lines 537-544. There is no init mode.
- `support-files/sync-agents-md.ps1` is 520 lines. The param block is lines 17-21. `Test-TargetInitialized` is lines 299-315. There is no init mode.
- `tests/test-sync-agents-md.sh` has 14 cases in 279 lines. `tests/verify-powershell-scripts.ps1` is 149 lines. The suite has 34 scripts and no `tests/test-sync-init.sh`.
- `design-docs/protocol-decisions.md` line 1526 records "Documentation-only additions ship as a PATCH". `ai/knowledge/release-practices.md` line 14 states the same rule. Init is a behavior change, so the release is MINOR.
- The eight slugs are frozen preset identifiers at `design-docs/protocol-decisions.md` line 1510.

### Commands run and results

- `git rev-parse HEAD` returned `5f6808b1d429b533acb3c36c7b19cefdbeb02f32`; the branch is `master`; no `feature/*` branch exists.
- `git status --short` shows the four pre-existing modified files and the untracked handoff directory. The state-file hashes are recorded in the handoff run.
- `git tag --sort=-v:refname | head -3` returned `v7.8.2`, `v7.8.1`, `v7.8.0`. The next MINOR is `v7.9.0`.
- `ls -A ai/plans` shows only `.gitkeep`.
- `ls ai/code-review-reports` shows `review-178` as the highest report. The first plan review is `review-179`.
- `grep -n 'Default Shell'` confirms the eight preset lines, the template lines 13 and 21, and the guide lines 11-12.
- The boot index is 26 policies, 16 procedures, and 59 triggers. This change adds none.

### Confirmed facts

- Init is a separate mode, not a search root. The existing sync keeps its `--source` and `--target-path` contract.
- The presets are complete customization variants. Init copies one, replaces one workflow line, and writes it to the target root.
- The loader leaves `**User AI Directory**: [HOME]/.ai/` for the user. Init does not expand it.
- The scripts already refuse root customization symlinks in sync mode. Init must refuse any existing root path, including a dangling symlink.

### Open questions

- None. The ticket's open points are settled. The two judgment calls are recorded as ADR-003 (target-inside-clone exit code) and ADR-004 (symlink exit code and mixed existence).

## Depth

L. This plan carries an HLD, an LLD, ADRs, a test plan, risks, and a close sequence.

## Context

### Problem

A new project has no scaffolding command. The user copies `AGENTS.md` and `ai-customization.md` by hand, then edits every section. The presets exist but nothing writes one into a target. The sync script only updates initialized projects and refuses an uninitialized target.

### HLD

- Init is a mode of the existing sync script in each language. One script owns both surfaces, so the workflow directory resolution, the exclusion logic, and the message style stay shared.
- Init reads `AGENTS.md` from the workflow clone root and one preset from `docs/examples/customization-presets/`.
- Init writes only `AGENTS.md` and `ai-customization.md` at the target root. It does not create `ai/`, run bootstrap, or copy skills.
- The eight slugs are a fixed published whitelist. A known slug with a missing preset file is a packaging error, not an unknown role. This keeps the "missing preset" test meaningful.
- The target is a single directory outside the workflow clone. Any existing root path is a refusal. A symlink root path is a validation error.
- Writes go through same-directory temp files and renames. A failed second rename removes the first file and the temps.
- The default shell key is removed at the source: the presets and the template no longer carry it. The init script rejects a preset that still carries it, so a regression cannot leak it into a new project.
- The optional `Default Shell` documentation stays in the guide for manual use.

### LLD

#### CLI surface

Sync mode is unchanged:

- `sync-agents-md.sh --source PATH --target-path PATH [--dry-run]`
- `sync-agents-md.ps1 -Source PATH -TargetPath PATH [-WhatIf]`

Init mode is added:

- `sync-agents-md.sh --init --target-path DIR --role SLUG [--dry-run]`
- `sync-agents-md.ps1 -Init -TargetPath DIR -Role SLUG [-WhatIf]`

Argument rules:

- `--init` and `-Init` select init mode.
- Init rejects `--source` and an explicit `-Source`. Bash sets a separate `SOURCE_SET=1` in the `--source` case and exits 2 when `SOURCE_SET` is set, so `--source ""` is still rejected. The check runs before the sync source validation. PowerShell uses `$PSBoundParameters.ContainsKey('Source')` and exits 2.
- Init requires `--target-path` and `-TargetPath`. PowerShell requires the parameter to be explicitly bound, because the sync default is `.`.
- Init requires `--role` and `-Role` with a non-empty value.
- Sync mode rejects `--role` and `-Role` as invalid for that mode.
- `--dry-run` and `-WhatIf` work in both modes.
- `--help` and `-h` print both modes and exit 0.

#### Role lookup and preset transform

- The published whitelist is the eight frozen slugs. Each script holds the list in one ordered literal.
- The slug must match `^[a-z0-9-]+$`. This rejects path traversal, `.`, `..`, slashes, spaces, uppercase, and empty values.
- A slug outside the published whitelist is an unknown role and exits 2.
- A slug inside the published whitelist whose file is absent from the preset directory is a missing preset and exits 1. This is the packaging error.
- The preset must be a regular file and must not be a symlink in the preset directory. A symlink preset is a packaging error. Its content must contain exactly one line `**Workflow AI Directory**: /path/to/Simple-AI-Workflow`.
- The transform replaces that exact line with `**Workflow AI Directory**: <resolved workflow directory>`. It leaves `**User AI Directory**: [HOME]/.ai/` unchanged.
- The preset must not contain a `**Default Shell**:` line. If it does, init exits 1 with a packaging error.
- The generated `ai-customization.md` is the transformed preset, byte for byte after the one line change.

#### Target and root-file rules

- Resolve the target with the physical path (`pwd -P` in Bash, `Resolve-Path` plus the full name in PowerShell).
- The target must be a directory. A non-directory exits 2.
- The target must not be the workflow clone or a directory inside it. Bash reuses `is_under_workflow` from lines 64-71. PowerShell adds `Test-UnderWorkflow`: it resolves the target and the workflow directory to full names, compares them with `OrdinalIgnoreCase`, then walks the target's parent chain to the root. A match exits 2.
- The target may contain other files and subdirectories. Init never touches them.
- Check both root paths: `<target>/AGENTS.md` and `<target>/ai-customization.md`.
- A root path that is a symlink, including a dangling symlink, is a validation error and exits 2. The message names the path.
- A root path that exists and is not a symlink is a refusal and exits 1. The message names the path.
- When both root paths exist, every existing path is named. If any is a symlink, the exit code is 2; otherwise it is 1.
- Init never overwrites, follows, or writes through an existing root path.

#### Write sequence

1. Validate the CLI, the target, the role, the preset, and both root paths. Write nothing.
2. In dry-run mode, print the planned writes and the bootstrap hint, then exit 0. A dry run performs the same validation first; a would-be refusal exits with the same non-zero code and writes nothing.
3. Create two temp files in the target directory. Copy `AGENTS.md` bytes into one. Write the transformed preset into the other. Set POSIX mode 0644 on both.
4. Re-check both root paths. If either appeared, remove the temps and refuse with the same code as step 1.
5. Rename the AGENTS temp to `<target>/AGENTS.md`.
6. Rename the customization temp to `<target>/ai-customization.md`.
7. If step 6 fails, remove the file created in step 5, remove both temps, report the failure, and exit 1.
8. Print `Initialized <target>` and the bootstrap hint, then exit 0.

#### Messages

- Missing value: `Missing value for --role`, `Missing value for --target-path`, `Missing value for --source`.
- Required init arg: `--role is required with --init.`, `--target-path is required with --init.`
- Wrong mode arg: `--source is not allowed with --init.`, `--role is only valid with --init.`
- Target not a directory: `Target path is not a directory: <path>`
- Target inside clone: `Target is the workflow clone or inside it: <path>`
- Existing regular root path: `Refusing to initialize: <path> already exists.`
- Existing symlink root path: `Refusing to initialize: <path> is a symlink.`
- Unknown role: `Unknown role: <slug>` then `Available presets: <space-separated list>`
- Missing preset: `Missing preset file for role <slug>: <path>` then `Available presets: <space-separated list>`
- Missing canonical source: `Missing canonical AGENTS.md: <path>`
- Missing placeholder: `Preset is missing the workflow placeholder: <path>`
- Forbidden key: `Preset contains a forbidden Default Shell key: <path>`
- Write failure: `Initialization failed: <detail>`
- Success: `Initialized <target>` then `Next: run "bootstrap using AGENTS.md protocol" in <target>.`
- Dry run: `Dry run: would initialize <target>`, one `Would write: <path>` line per file, then the same bootstrap hint.

#### Exit-code matrix

- 0: success; dry run after validation.
- 2: unknown role; target not a directory; missing required init arg; `--source` with `--init`; `--role` without `--init`; target is the clone or inside it; a root path is a symlink.
- 1: a regular root path exists; a preset file is missing; the preset lacks the placeholder; the preset carries the forbidden key; the canonical `AGENTS.md` is missing; a write or rename fails.

#### Documentation

- Add `## Initialize a new project` to `docs/setup.md` before `## Updating an Existing Project`. It states the target rules, the two commands, the dry-run flags, the exit codes, and the bootstrap hint.
- Replace the line 51 sentence with: "The sync script updates `AGENTS.md`, checks or creates `ai-customization.md`, adds `## Merge Policy` when it is missing, and migrates the state layout. Sync does not create `AGENTS.md` for a new project; use `--init` for that. The sync script does not copy skills."
- Add one sentence to `docs/ai-customization-guide.md` section 11: "To scaffold a new project from one of these presets, see [Initialize a new project](setup.md#initialize-a-new-project)."
- Keep `docs/ai-customization-guide.md` lines 11-12 unchanged. The optional key stays documented for manual use.
- Remove line 13 from `docs/ai-customization.md` and reduce line 21 to: `<!-- User AI Directory defaults to [HOME]/.ai/. -->`. The Default Shell advertising sentence is gone and the User AI Directory default stays.
- Remove the `**Default Shell**: bash` line from all eight presets.

#### Tests

- Add `tests/test-sync-init.sh` as the 35th suite script. It covers success for all eight roles, byte-identical `AGENTS.md`, exact transformed customization, no `ai/`, dry run, existing regular root paths, symlink root paths, unknown role, path traversal, target inside the clone, non-directory target, missing args, wrong-mode args, idempotence, rollback on a failed second rename, docs assertions, and static Bash/PowerShell parity.
- The copied-clone cases run from a directory whose name contains a space. They cover the missing preset, a symlink preset, a missing placeholder, a duplicate placeholder, a forbidden `Default Shell` key, a missing canonical `AGENTS.md`, and the inside-clone targets. The space path also exercises the literal workflow substitution.
- Extend `tests/verify-powershell-scripts.ps1` with init success, dry run, existing target, idempotence, unknown role, missing preset in a copied clone, target inside the clone, and a symlink refusal guarded by platform capability.
- The suite runner needs no change. It discovers `tests/test-*.sh` automatically.

## Decisions (ADR)

### ADR-001: Init is a mode of the existing sync script

Init shares the workflow resolution, the exclusion logic, and the user-facing style with sync. A separate script would duplicate them and risk drift. One script per language keeps parity and one help surface.

### ADR-002: The eight slugs are a fixed published whitelist

A slug outside the eight is an unknown role and exits 2. A known slug whose preset file is absent is a packaging error and exits 1. Deriving the whitelist only from the files would collapse the missing-preset case into unknown role and lose the required packaging test. The fixture pins the whitelist against the files.

### ADR-003: A target inside the workflow clone is validation, exit 2

The check runs before any write and rejects an invalid target location, like a non-directory target. It is not a state conflict. This keeps exit 1 for a target that is otherwise valid but already initialized.

### ADR-004: A symlink root path is validation, exit 2

The settled exit-code line lists `symlink` under validation. A regular existing root path is a state conflict and exits 1. When both root paths exist, a symlink wins the exit code and every existing path is named.

### ADR-005: Init always sources AGENTS.md from the clone root

`--source` is rejected in init mode. The workflow clone root is the only source, so a user cannot scaffold from an arbitrary file and blur the trust boundary.

### ADR-006: The workflow path is the resolved clone path

The transform replaces the preset placeholder with the physical clone path. It does not add a trailing slash and does not expand `[HOME]`. The loader owns the user directory expansion.

### ADR-007: Same-directory temp files, rename, and rollback

Temp files in the target directory keep the rename on one filesystem. The first rename lands `AGENTS.md`. If the second rename fails, the first file and both temps are removed. The root paths are re-checked just before the renames to narrow the race window.

### ADR-008: The preset contract forbids the Default Shell key

The key is removed from the eight presets and the template. Init also rejects a preset that still carries it, so a packaging regression cannot reach a new project. The guide keeps the optional key for manual use.

### ADR-009: This task ships no TSV manifest

The preset map, migration paths, and key renames stay in the scripts. The shared TSV manifest, its schema, and its parity test are deferred to a separate issue. No TSV file is created here.

### ADR-010: Release v7.9.0 as MINOR

Init adds a new CLI mode and changes script behavior, so it is a behavior change. The docs-only PATCH rule does not apply. The release is `v7.9.0`.

### ADR-011: Tests use a new init fixture

The init scenarios are large enough to justify their own fixture. The existing sync fixture keeps its 14 cases and stays focused. The suite grows from 34 to 35 scripts. No doc asserts the script count, so no count sweep is needed.

## Deltas

- Modify `support-files/sync-agents-md.sh`: add `--init` and `--role`, the init validation, the preset transform, the write sequence, the messages, and the help text.
- Modify `support-files/sync-agents-md.ps1`: add `-Init` and `-Role`, the same validation, transform, write sequence, messages, and help text.
- Modify the eight `docs/examples/customization-presets/<role>.md` files: remove the `**Default Shell**: bash` line.
- Modify `docs/ai-customization.md`: remove the `**Default Shell**: bash` line and the Default Shell advertising sentence.
- Modify `docs/setup.md`: add the init section, the commands, the target rules, the exit codes, and the bootstrap hint; replace the line 51 sentence.
- Modify `docs/ai-customization-guide.md`: add the section 11 link to the setup init section. Keep lines 11-12.
- Create `tests/test-sync-init.sh`.
- Modify `tests/verify-powershell-scripts.ps1`.
- Create `docs/announcements/v7.9.0.md`.
- Modify `README.md`: move the banner to v7.9.0 and link the announcement.
- Append the ADR entries above to `design-docs/protocol-decisions.md`.
- No policy, procedure, or trigger change. Counts stay 26 policies, 16 procedures, and 59 triggers.
- No TSV file.

## Acceptance Criteria

- AC-1: Init success writes exactly two root files. Asserted by `tests/test-sync-init.sh` with a target that contains unrelated files and a subdirectory; assert exit 0, both files exist, `cmp` confirms `AGENTS.md` is byte-identical to the clone copy, the unrelated file hash is unchanged, the subdirectory is unchanged, and `<target>/ai` does not exist.
- AC-2: All eight roles scaffold. Asserted by a loop over the eight slugs; for each role, assert exit 0 and `diff` against the transformed preset. The POSIX success case also asserts mode 0644 on both files, and the `platform-engineer` case asserts that the `markdownlint-disable MD044` comment is present.
- AC-3: The workflow path is substituted and the user path is preserved. Asserted by grepping the generated file for `**Workflow AI Directory**: <clone>`, `**User AI Directory**: [HOME]/.ai/`, and the absence of `/path/to/Simple-AI-Workflow`.
- AC-4: The generated customization has no `Default Shell` key. Asserted by grepping the generated file and each of the eight presets for the absence of `**Default Shell**:`.
- AC-5: Dry run writes nothing and lists the planned writes. Asserted by an empty target, exit 0, no files, and the log containing `Would write:` for both paths and the bootstrap hint.
- AC-6: A regular existing root path refuses with exit 1 and names the path. Asserted for `AGENTS.md` only and for `ai-customization.md` only; assert the other file is not written.
- AC-7: A symlink root path refuses with exit 2 and names the path. Asserted for a dangling symlink at `AGENTS.md` and a symlink at `ai-customization.md`; assert the link is unchanged and the other file is not written.
- AC-8: Unknown role and path traversal exit 2. Asserted with `not-a-role`, `../cloud-architect`, and `cloud/architect`; assert the role is named, the eight presets are listed, and no file is written.
- AC-9: A missing preset file exits 1 and lists the available presets. Asserted in a copied clone under a path containing a space, with `dba.md` removed; assert the copied clone is unchanged outside the removal and the exact `**Workflow AI Directory**` line for the copied clone path.
- AC-10: The target rules hold. Asserted in a copied clone for the copied clone root and a subdirectory of it, and in a temp path for a non-directory target; assert exit 2, no writes, and the real workflow tree untouched.
- AC-11: Missing and wrong-mode args exit 2. Asserted for `--init` without `--role`, `--init` without `--target-path`, `--source` with `--init`, and `--role` without `--init`.
- AC-12: Idempotence and rollback. Asserted by a second init that exits 1 with both file hashes unchanged; and by an injected second-rename failure that exits 1, removes the first file, and leaves no temp files.
- AC-13: The docs describe the path. Asserted by grepping `docs/setup.md` for the init heading, both commands, the dry-run flags, the exit codes, the refusal rules, and the bootstrap hint; grep the guide section 11 for the setup link; grep the template and presets for the absence of the Default Shell key; grep the guide for the retained optional-key documentation.
- AC-14: Bash and PowerShell parity. Asserted by static checks that both scripts contain the eight slugs and the key messages, and by the init cases added to `tests/verify-powershell-scripts.ps1` when `pwsh` is available.
- AC-15: No policy, procedure, or trigger change. Asserted by `support-files/validate-protocol.sh` reporting 8/8 and the boot index staying at 26 policies, 16 procedures, and 59 triggers.
- AC-16: The suite passes with the new fixture. Asserted by `bash tests/run-all.sh` reporting 35 scripts passed, and by `bash tests/test-sync-agents-md.sh` still passing its 14 cases.
- AC-17: Every packaging error exits 1 with its named message. Asserted in a copied clone for a symlink preset, a missing placeholder, a duplicate placeholder, a forbidden `Default Shell` key, and a missing canonical `AGENTS.md`; each case writes nothing.

## Verification

- `bash support-files/validate-protocol.sh` returns 8/8.
- `bash tests/run-all.sh` passes 35/35.
- `bash tests/test-sync-init.sh` passes every check.
- `bash tests/test-sync-agents-md.sh` still passes the 14 sync cases.
- `pwsh -NoProfile -ExecutionPolicy Bypass -File tests/verify-powershell-scripts.ps1` passes every check, or is reported PENDING when `pwsh` is absent.
- `markdownlint-cli2` on the changed markdown files reports 0.
- `shellcheck` on `support-files/sync-agents-md.sh` and `tests/test-sync-init.sh` reports 0.
- `pwsh` parse check on `support-files/sync-agents-md.ps1` reports no errors when `pwsh` is available.
- The boot index stays 26 policies, 16 procedures, and 59 triggers.

## Peer Review Log

- 2026-11-26: review-179 CHANGES REQUESTED (2 Major, 3 Minor). Fixed the PowerShell target helper, the Bash flag tracking, the preset symlink rule, the dry-run validation note, and the exact docs text.
- 2026-11-26: review-180 CHANGES REQUESTED (1 Major, 2 Minor). Fixed the copied-clone safety, the space-path coverage, and the packaging-error cases.
- 2026-11-26: review-181 APPROVED (0 Critical, 0 Major, 0 Minor; 1 optional Suggestion).

## Risks and Rollback

- The fixed whitelist can drift from the preset files. The init fixture loops all eight roles and the copied-clone case pins the missing-preset behavior.
- The target checks can miss a symlinked path or a race. The scripts resolve the physical target, re-check both root paths before the renames, and roll back the first file.
- Bash and PowerShell can diverge. The messages and slugs are identical literals, a static parity test checks them, and the PowerShell verification exercises the same cases.
- The docs anchor can break. The init fixture greps the setup heading and the guide link.
- Removing the Default Shell key can surprise a user who relied on the template. The guide keeps the optional key documented, and the release notes explain the move to the user settings file.
- Rollback: revert the squash commit, delete the `v7.9.0` tag and GitHub Release, and restore the README banner. There is no data migration, so no store rollback is needed.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base ref: `master`.
- Baseline: a chore commit of this plan and the ticket, per the work-item invariants.
- Branch: `feature/sync-init-role-presets`.
- Ticket: `ai/issues/open/sync-script-init-scaffolding.md`, plan attached, closed with the merge.
- Merge mode: `direct`.
- Release: `v7.9.0`, MINOR, annotated tag and GitHub Release, with `docs/announcements/v7.9.0.md` and the README banner.
- Evidence: validator 8/8, suite 35/35, init fixture pass, sync fixture 14/14, markdownlint 0, shellcheck 0, PowerShell parity run or PENDING, review APPROVED, clean tree, branch at least one commit ahead.
- Order: checkpoint on the branch before the commit; squash merge; tag and publish the release after the merge; no post-merge commits.
