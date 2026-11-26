Reported: 2026-11-23
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: L
Label:
URL:
Summary: Add a sync-script --init mode that scaffolds a project from a policy and trait selection

Description:
Extend the sync scripts with an `--init` mode that treats a target directory as a new project root.

Proposed behavior:

- Accept a target directory, a list of policies or expertise domains, and an active trait or traits.
- Copy `AGENTS.md` into the target and copy a matching `ai-customization.md` preset from the docs or examples tree.
- Set the selected Active Expertise and Traits, and leave the rest ready for the user to adjust.
- Do not run bootstrap or load context; the user starts an AI session in the target and bootstraps there.
- Work in both `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1`, with parity, dry-run behavior, idempotence, and clear failure messages.

Preset dependency:

- The preconfigured customization variants are tracked in `ai/issues/closed/customization-presets-per-role.md`; this ticket consumes them and does not duplicate the role content.
- Add the preset mapping only after that ticket settles the role list and contents.

Open questions:

- CLI shape: `--init <target> --policy cloud --trait ...`, or a named preset?
- Must the target be empty? What happens on an existing non-empty directory?
- Copy or symlink the two root files?
- Is `AGENTS.md` copied from the workflow clone root?
- Does `--init` select a preset, or build a customization from policy and trait flags?
- Which docs page explains the new path?

Acceptance criteria:

- `--init` on a temporary target creates `AGENTS.md` and `ai-customization.md` with the selected Active Expertise and Traits.
- A dry run writes nothing and lists the planned actions.
- Bash and PowerShell parity; tests cover success, an existing target, a dry run, a missing preset, and an invalid policy.
- The docs explain how to pick a preset and adjust it.
- No new policy or procedure is required unless the implementation proves one is needed.

---

2026-11-25

## Sync and init behavior

The sync and init split is confirmed. Sync reconciles an initialized project and runs any needed migration. Init creates a new project from a preset.

Decisions:

- Sync has no `--migrate` flag. It performs the migration automatically when it detects an old layout. Report every move, keep the operation idempotent, support `--dry-run`, and back up a store before moving it.
- Sync is for initialized projects. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required.
- A project with only one of the two root files is uninitialized. Sync reports it and does not modify it. Init does not fill the missing file.
- Target semantics: process the initialized projects, report the uninitialized ones, and refuse only when the tree contains none. A single uninitialized target gets the `--init` hint.
- `--init` takes a role switch and selects a preset from `customization-presets-per-role.md`. Proposed CLI: `--init --target-path <dir> --role <preset>`.
- Init target: a directory with neither `AGENTS.md` nor `ai-customization.md`. It may contain other files and subdirectories. Init writes only the two root files and ignores every subdirectory.
- `--init` copies `AGENTS.md` from the workflow clone root and writes `ai-customization.md` from the preset. It creates no symlinks and does not create `ai/`.
- If either root file exists, init refuses and does not fill the missing one.
- An unknown role lists the available presets and exits non-zero.
- Remove the legacy root `ai-customization.md` symlink handling from both sync scripts. Do not preserve or write through a symlink.
- Presets are not ready. Init waits for `customization-presets-per-role.md` to settle the role list and contents. Sequence: scope naming, presets, init.
- Job manifest: use a sibling TSV under `support-files/` with a fixed verb set (`copy`, `move`, `ensure-section`, `replace-key`) and rows `verb|when|from|to`. Both scripts parse the same file. It carries the migration path map, key renames, and preset names. No arbitrary shell commands. Validate it as a protocol artifact.

Open points:

- Exit codes and the exact refusal message.
- The role switch name (`--role` or `--expertise`) and the preset names.
- The docs page that explains the init path.

Answers to the original open questions:

- CLI shape: a named preset selected by the role switch, not separate policy and trait flags.
- Copy or symlink: copy.
- `AGENTS.md` source: the workflow clone root.
- Preset selection: yes, one preset per role.
- Target emptiness: not required. Init requires that neither root file exists, allows other files and subdirectories, and writes only the two root files.
- Docs page: still open.

Updated acceptance criteria:

- Sync performs migrations automatically and has no `--migrate`.
- Sync processes the initialized projects, reports the uninitialized ones, and refuses only when the tree contains none. A project is initialized when it has `AGENTS.md` and `ai-customization.md`; `ai/` is not required.
- `--init --role <preset>` creates `AGENTS.md` and `ai-customization.md` only when neither root file exists, with no symlinks. It ignores subdirectories, does not create `ai/`, and refuses when either root file exists.
- Both scripts read the same `support-files/` TSV job manifest with the fixed verb set; the schema is validated and no arbitrary shell command is allowed.
- An unknown role lists the presets and fails.
- Bash and PowerShell parity, dry-run, idempotence, and tests for success, partial targets, uninitialized refusal, missing preset, and invalid role.
- The sync scripts no longer preserve or write through a root `ai-customization.md` symlink.
- The docs explain sync, init, and preset selection.

---

## Settled decisions (2026-11-26)

These decisions supersede the open points above. The presets shipped in v7.8.2.

- **No TSV job manifest in this task.** The preset map, migration paths, and key renames stay in the scripts for now. The shared TSV manifest is deferred to a separate issue.
- **CLI:** `--init --target-path <dir> --role <slug> [--dry-run]`. Use `--role`. Reject `--source` in init mode; init takes `AGENTS.md` from the workflow clone root and the preset from `docs/examples/customization-presets/`.
- **Preset lookup:** whitelist the slug against the preset files in the clone; reject path traversal. A missing preset file is a packaging error that lists the available presets and exits non-zero.
- **Workflow path:** replace `**Workflow AI Directory**: /path/to/Simple-AI-Workflow` in the copied preset with the resolved clone path. Leave `**User AI Directory**: [HOME]/.ai/` for the loader.
- **Default Shell:** do not include it. Remove `**Default Shell**: bash` from the eight presets and from `docs/ai-customization.md`, and remove the template comment sentence that advertises it. Keep the optional key documented in the customization guide for manual use.
- **Target:** a single directory, not a search root. Refuse when the target is the workflow clone or inside it. Refuse when either root file exists (regular or symlink), and name the existing file. Allow other files and subdirectories; write only the two root files; create no `ai/`.
- **Write safety:** preflight both paths, write through temp files, then rename. If the second write fails, remove the first and report.
- **Exit codes:** 0 success or dry run; 2 usage and validation (unknown role, target not a directory, missing args, symlink, `--source` with `--init`); 1 refusal or write failure (root file exists, preset missing, write error).
- **Messages:** an unknown role names the role and lists the available presets. A refusal names the existing file.
- **Next-step hint:** after a successful init, print the bootstrap command to run in the new project.
- **Docs:** put the init walkthrough and target rules in `docs/setup.md`; link from section 11 of `docs/ai-customization-guide.md`.
- **Idempotence:** a second init refuses without writing; it does not re-create.
- **Symlinks:** the current scripts already refuse root-file symlinks. Keep the refusal and test it; there is no write-through path to remove.
- **Acceptance cleanup:** replace "invalid policy" with "unknown role" and "missing preset file"; keep the Bash and PowerShell parity, dry-run, and the target cases.

### Deferred

- The shared TSV job manifest is a separate issue: preset map, migration path pairs, key renames, a fixed verb set, schema validation, and a Bash and PowerShell parity test.

---

2026-11-26

## Plan

Plan attached below.

- Scope: add `--init --target-path <dir> --role <slug> [--dry-run]` to both sync scripts, with a fixed eight-slug whitelist, workflow path substitution, Default Shell removal from the presets and the template, target and write-safety rules, docs, tests, and a MINOR v7.9.0 release.
- No TSV manifest; it stays deferred.
- The plan stops before implementation; the approval and close sequence are in the plan.

## Implementation Plan

# Plan: Sync Init Role Presets

## Goal

Add an `--init` mode to `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1` that scaffolds a new project root from a named role preset. It writes only `AGENTS.md` and `ai-customization.md`, creates no `ai/`, removes the `Default Shell` key from the presets and the template, documents the path in `docs/setup.md`, keeps Bash and PowerShell parity, and releases v7.9.0 as a MINOR. No TSV manifest in this task.

## Evidence

- The ticket's settled decisions (2026-11-26) are binding: `--init --target-path <dir> --role <slug>`, the eight-slug whitelist, workflow path substitution, target and refusal rules, exit codes, write safety, docs, idempotence, symlink tests, and the deferred TSV.
- The eight presets are in `docs/examples/customization-presets/`. The template is `docs/ai-customization.md`. The guide section 11 and `docs/setup.md` line 51 are the docs anchors.
- The scripts were 588 and 520 lines with no init mode; both refused a symlinked root `ai-customization.md` but neither checked a symlinked `AGENTS.md`.
- The suite had 34 scripts; the boot index was 26 policies, 16 procedures, 59 triggers.
- `design-docs/protocol-decisions.md:1526` and `ai/knowledge/release-practices.md:14` say docs-only changes take a PATCH. Init is a behavior change, so the release is MINOR.

## Depth

L. HLD, LLD, ADRs, test plan, risks, and close sequence.

## Context

### HLD

- Init is a mode of the existing sync script in each language, so workflow resolution, exclusion logic, and message style stay shared.
- Init reads `AGENTS.md` from the clone root and one preset from `docs/examples/customization-presets/`.
- The eight slugs are a fixed published whitelist. A known slug with a missing preset is a packaging error (exit 1); a slug outside the eight is an unknown role (exit 2).
- The target is a single directory outside the clone. Any existing root path is a refusal; a symlink root path is validation.
- Writes use same-directory temp files and renames. A failed second rename removes the first file and the temps.
- The Default Shell key is removed at the source; init rejects a preset that still carries it. The guide keeps the optional key for manual use.

### LLD

- CLI: `--init --target-path DIR --role SLUG [--dry-run]` and `-Init -TargetPath DIR -Role SLUG [-WhatIf]`.
- Init rejects `--source` and an explicit `-Source`. It requires `--role` and an explicitly bound `--target-path`.
- Role: regex `^[a-z0-9-]+$`, exact case, then the eight-slug whitelist.
- Preset: regular file, not a symlink, exactly one workflow placeholder, no `Default Shell` key.
- Transform: replace `**Workflow AI Directory**: /path/to/Simple-AI-Workflow` with the resolved clone path. Leave `[HOME]/.ai/` unchanged.
- Target: physical path, a directory, not the clone or inside it. Root paths: symlink exits 2, regular exits 1, name every existing path, symlink wins the code.
- Write: validate, dry run, two temp files, mode 0644, re-check roots, rename AGENTS, rename customization, rollback on failure, print the bootstrap hint.
- Exit codes: 0 success or dry run; 2 validation; 1 refusal or packaging or write failure.
- Docs: add `## Initialize a new project` to `docs/setup.md`, replace the line 51 sentence, link from guide section 11, remove the Default Shell key from the template and the eight presets.
- Tests: add `tests/test-sync-init.sh` as the 35th suite script; extend `tests/verify-powershell-scripts.ps1`; update `tests/test-config-resolution.sh` for the template change; move the slide appendix and HTML to 35.

## Decisions (ADR)

- ADR-001: Init is a mode of the existing sync script.
- ADR-002: The eight slugs are a fixed published whitelist.
- ADR-003: A target inside the clone is validation, exit 2.
- ADR-004: A symlink root path is validation, exit 2.
- ADR-005: Init always sources AGENTS.md from the clone root.
- ADR-006: The workflow path is the resolved clone path.
- ADR-007: Same-directory temp files, rename, and rollback.
- ADR-008: The preset contract forbids the Default Shell key.
- ADR-009: This task ships no TSV manifest.
- ADR-010: Release v7.9.0 as MINOR.
- ADR-011: Tests use a new init fixture; the slide appendix count moves to 35.

## Deltas

- `support-files/sync-agents-md.sh`: add `--init`, `--role`, validation, transform, write sequence, messages, and help.
- `support-files/sync-agents-md.ps1`: add `-Init`, `-Role`, the same behavior, and help.
- Remove `**Default Shell**: bash` from the eight presets and from `docs/ai-customization.md`, and drop the template's advertising sentence.
- `docs/setup.md`: add the init section, commands, target rules, exit codes, and hint; replace the line 51 sentence.
- `docs/ai-customization-guide.md`: link the setup init section; change "future `--init`" to the real mode.
- `tests/test-sync-init.sh`: new fixture.
- `tests/verify-powershell-scripts.ps1`: init cases.
- `tests/test-config-resolution.sh`: template now omits the key; the guide keeps the shells.
- `tests/test-docs-audit.sh`, `tests/test-readme-shape.sh`: v7.9.0 pins.
- `docs/announcements/v7.9.0.md`, `README.md`, slide deck and HTML, and the 11 dated ADR entries.
- No policy, procedure, or trigger change. Counts stay 26/16/59. No TSV.

## Acceptance Criteria

- AC-1: Success writes exactly two root files; unrelated files, subdirectories, and the object hashes are unchanged; no `ai/`. Asserted by `tests/test-sync-init.sh`.
- AC-2: All eight roles scaffold; exact transformed preset; mode 0644; the platform-engineer MD044 comment stays. Asserted.
- AC-3: Workflow path substituted; `[HOME]` preserved; no placeholder. Asserted.
- AC-4: No Default Shell in the generated file or the eight presets. Asserted.
- AC-5: Dry run writes nothing and lists both writes and the hint. Asserted.
- AC-6: Existing regular root path exits 1, names it, and writes nothing. Asserted.
- AC-7: Symlink root path exits 2, names it, and leaves the link and target unchanged. Asserted.
- AC-8: Unknown role and path traversal exit 2, name the role, list all eight presets, and write nothing. Asserted.
- AC-9: Missing preset exits 1 in a copied clone with a space, lists the presets, and leaves the clone unchanged. Asserted.
- AC-10: Targets inside a copied clone exit 2 with no writes; a non-directory target exits 2. Asserted.
- AC-11: Missing and wrong-mode args exit 2. Asserted.
- AC-12: Second init exits 1 with unchanged hashes; a failed second rename rolls back. Asserted.
- AC-13: Docs describe the heading, commands, dry-run flags, exit codes, refusals, hint, guide link, and optional-key retention. Asserted.
- AC-14: Bash and PowerShell parity in slugs and messages; PowerShell cases are present. Static and runtime when `pwsh` is available.
- AC-15: Validator 8/8; index 26/16/59.
- AC-16: Suite 35/35; sync fixture 14/14.
- AC-17: Packaging errors (symlink preset, missing/duplicate placeholder, forbidden key, missing canonical AGENTS) exit 1 and write nothing. Asserted.

## Verification

- `bash support-files/validate-protocol.sh` returns 8/8.
- `bash tests/run-all.sh` passes 35/35.
- `bash tests/test-sync-init.sh` passes.
- `bash tests/test-sync-agents-md.sh` passes 14/14.
- `bash tests/test-config-resolution.sh`, `test-docs-audit.sh`, `test-readme-shape.sh`, and `test-slides.sh` pass.
- `markdownlint-cli2` reports 0 on the changed markdown.
- `shellcheck` reports 0 on the changed shell.
- PowerShell runtime and parse are PENDING because `pwsh` is absent.

## Peer Review Log

- 2026-11-26: review-179 CHANGES REQUESTED (2 Major, 3 Minor).
- 2026-11-26: review-180 CHANGES REQUESTED (1 Major, 2 Minor).
- 2026-11-26: review-181 APPROVED.
- 2026-11-26: review-182 CHANGES REQUESTED (1 Major, 7 Minor). Fixed the PowerShell case-sensitive role check, strengthened the tests, and reconciled ADR-011.
- 2026-11-26: review-183 APPROVED.

## Risks and Rollback

- The fixed whitelist can drift from the preset files; the fixture loops all eight roles.
- The target checks can miss a symlink or a race; the scripts resolve the physical target, re-check the roots, and roll back.
- Bash and PowerShell can diverge; the messages and slugs are identical, and the parity checks cover them.
- Removing the Default Shell key can surprise a user; the guide keeps the optional key, and the release notes explain it.
- Rollback: revert the squash commit, delete the `v7.9.0` tag and GitHub Release, and restore the README banner.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base ref: `master`.
- Baseline: the chore commit of this plan and the ticket.
- Branch: `feature/sync-init-role-presets`.
- Ticket: `ai/issues/closed/sync-script-init-scaffolding.md`, plan attached.
- Merge mode: `direct`.
- Release: `v7.9.0`, MINOR, annotated tag and GitHub Release, with `docs/announcements/v7.9.0.md` and the README banner.
- Evidence: validator 8/8, suite 35/35, init fixture pass, sync fixture 14/14, markdownlint 0, shellcheck 0, PowerShell PENDING, review-183 APPROVED.
- Order: checkpoint on the branch before the commit; squash merge; tag and publish after the merge; no post-merge commits.
