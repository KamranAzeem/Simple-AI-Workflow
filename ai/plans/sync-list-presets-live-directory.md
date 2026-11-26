# Plan: Sync List-Presets Live Directory

## Goal

Make the live `docs/examples/customization-presets/` directory the single source of truth for the sync role list. Add `--list-presets` to both scripts, remove every fixed role list from the two sync scripts, derive role validation from the directory, keep one example role (`web-developer`) in the init usage, move the missing-preset integrity check to a docs and directory consistency test, and release a MINOR. No TSV manifest.

## Evidence

### Sources

- Ticket `ai/issues/open/sync-list-presets-live-directory.md` records the settled design: a live directory, no fixed list, one `web-developer` example, live validation, a consistency test, and the ADR-002 reversal.
- `support-files/sync-agents-md.sh` holds the fixed list at `INIT_ROLES` line 63, validation at lines 65-74, preset checks at lines 76-102, the role errors at lines 43, 134, 153-155, and the usage at lines 7-23.
- `support-files/sync-agents-md.ps1` holds the fixed list in `Get-InitRoles` line 31, `Test-InitRole` lines 43-48, preset checks at lines 55-87, the role errors at lines 137-139, and the help block at lines 1-15.
- `tests/test-sync-init.sh` has a fixed `roles` literal at line 41, the unknown-role full-list assertion at line 154, the missing-preset case at lines 238-248, the slug parity loop at lines 305-308, and the message loop at lines 309-311.
- The guide table is at `docs/ai-customization-guide.md:286-293`. It is the documented role list and the target of the consistency test.
- `docs/setup.md:41-59` holds the init walkthrough; its example role is `web-developer` at line 47.
- ADR-002 is at `design-docs/protocol-decisions.md:1538`.
- `tests/verify-powershell-scripts.ps1` has the init cases and the uppercase role case.
- `README.md:3` and `:220`, `tests/test-docs-audit.sh:32`, `:179-181`, and `tests/test-readme-shape.sh:85` pin v7.9.0.
- The suite has 35 scripts. The boot index is 26 policies, 16 procedures, and 59 triggers. The latest tag is v7.9.0, so the next MINOR is v7.10.0.

### Commands run and results

- `git tag --sort=-v:refname | head -3` returned v7.9.0, v7.8.2, v7.8.1.
- `ls -1 tests/test-*.sh | wc -l` returned 35.
- `grep` confirmed the fixed list and the test assertions named above.
- The guide table rows and the setup example are as cited.
- The plan path was free before this file was created.

### Confirmed facts

- The live directory is `$WORKFLOW_DIR/docs/examples/customization-presets/`, resolved from the script location, so a copied clone uses its own presets.
- The role slug regex and the preset content checks (placeholder, no Default Shell) stay.
- The init write behavior, target rules, and exit codes for existing roots stay.
- A missing or empty directory is a packaging condition, not a user typo.
- A single missing preset in a non-empty directory is an unknown role.

### Open questions

- None. The plan decides the minor points: the `--list-presets` standalone rule, the missing/empty directory exit code, the symlink preset code, and the documented-list source.

## Depth

L because the change reverses an ADR, touches both scripts, and adds a docs and directory consistency test. HLD, LLD, ADRs, test plan, risks, and close sequence. The ticket Size stays for the human to confirm.

## Context

### Problem

Both scripts carry a fixed role literal. It duplicates the preset files, needs edits in two languages for every preset change, and the CLI cannot answer "which roles exist" except through the unknown-role error. A user who types `--role` without a value sees usage but no roles. The fixed list also creates a second source of truth that can drift from the directory and the guide table.

### HLD

- The presets directory is the only runtime source of roles. Both scripts read it for `--list-presets`, for validation, and for the error lists.
- The two sync scripts keep no fixed role list. The init usage keeps one example role, `web-developer`.
- `--list-presets` is a standalone discovery command. It prints the valid live slugs, sorted ordinal, one per line, and exits 0.
- Role validation checks the live directory. A regular non-symlink `.md` file is valid. A symlink preset is invalid. No file is an unknown role.
- The missing-preset integrity check moves from runtime to a consistency test that compares the guide table, the setup example, and the directory. A missing or extra preset fails the test before release.
- A missing or empty directory stays a runtime packaging error, so a broken install is still visible.
- The behavior change is a MINOR release.

### LLD

#### CLI surface

- `sync-agents-md.sh --list-presets` and `sync-agents-md.ps1 -ListPresets`.
- The command is standalone. Combining it with any other option, including `--help`, is a usage error and exits 2.
- It does not require `--init` or `--target-path`.
- Resolve `WORKFLOW_DIR` and the presets helper before argument handling, and handle `--list-presets` before the init and required-argument paths. The Bash missing-value branch prints the live list; PowerShell's parameter binder has no equivalent missing-value path, so that assertion is Bash-only.
- The usage and help list `--list-presets`, keep the `web-developer` example role, and contain no full role list.

#### Live listing

- Resolve the directory as `$WORKFLOW_DIR/docs/examples/customization-presets/`.
- Include only regular `.md` files that are not symlinks. Strip the `.md` suffix.
- Sort ordinal (`LC_ALL=C sort` in Bash, `StringComparer.Ordinal` in PowerShell).
- Print one slug per line, no header, and exit 0.
- A missing directory prints `Presets directory not found: <path>` and exits 1.
- An empty valid set prints `No presets found in <path>` and exits 1.

#### Role validation

- Apply the slug regex `^[a-z0-9-]+$` first. Reject uppercase, dots, slashes, spaces, and empty values.
- Resolve the live list. If the directory is missing or has no valid preset, print the packaging error and exit 1.
- If `<slug>.md` is a regular non-symlink file, it is valid.
- If `<slug>.md` is a symlink, print `Invalid preset file for role <slug>: <path>` and exit 1.
- If the file is absent, print `Unknown role: <slug>`, then `Available presets: <live list>`, then the guide reference, and exit 2.
- The preset content checks stay: exactly one workflow placeholder, no `Default Shell` key.

#### Error messages

- Missing value: `Missing value for --role`, then the live list and the guide reference, then usage.
- Required role: `--role is required with --init.`, then the live list and the guide reference.
- Unknown role: `Unknown role: <slug>`, then `Available presets: <live list>`, then `See docs/ai-customization-guide.md#11-presets-by-role`.
- Missing or empty directory: `Presets directory not found: <path>` or `No presets found in <path>`, exit 1.
- Invalid symlink preset: `Invalid preset file for role <slug>: <path>`, exit 1.
- `--list-presets` with another option: `--list-presets cannot be combined with other options.`, exit 2.

#### Documentation

- `docs/setup.md` adds `--list-presets` to the init section, says the list is live, and keeps one example role.
- The guide table stays the documented list. The guide says the live directory is the source and the table documents it.
- The consistency test parses the first-column slugs from the guide table, parses the live directory, and asserts set equality. It also asserts that each role literal in the setup example exists in the live set.

#### Tests

- Update `tests/test-sync-init.sh`:
  - Replace the fixed `roles` literal with a live list read from the presets directory.
  - Add `--list-presets` success, standalone rejection (including `--help`), missing and empty directory, and ordinal order.
  - Add a copied-clone case that creates a temporary valid preset (one placeholder, no Default Shell), sees it in the list and can init with it, then removes a preset, sees it gone, and gets an unknown-role error listing the live set.
  - Add the symlink preset case: omitted from the list, invalid on `--role`, exit 1.
  - Replace the fixed-list assertions with a no-fixed-list check: every live slug except `web-developer` is absent from both scripts, and `web-developer` appears in the usage.
  - Assert `--list-presets` in the Bash usage, `-ListPresets` in the PowerShell help, and `web-developer` in both, with no other live slug in either.
  - Add a docs grep for `--list-presets` in `docs/setup.md` and the live-source sentence in `docs/ai-customization-guide.md`.
  - Update the unknown-role and removed-preset assertions at the current lines 154 and 246 to use the live list and the new exit codes.
  - Add the guide table, setup example, and directory consistency check.
  - Keep the existing init behavior cases, with the missing-preset case changed to a removed-preset unknown-role case.
  - Run the missing, empty, and symlink-preset cases against a copied clone or a temporary workflow directory, never against the real presets.
- Update `tests/verify-powershell-scripts.ps1`:
  - Add `-ListPresets` success and standalone rejection.
  - Add a copied-clone add and remove case.
  - Replace the fixed-list assumptions with the live list.
  - Change the existing missing-preset case to a removed-preset unknown-role case: exit 2, `Unknown role: dba`, and the live list. Replace the exit-1 and `Missing preset file for role dba` assertions.
  - Keep the uppercase role case and the other init behavior cases.
- Update `tests/test-docs-audit.sh`: derive the preset existence loop from the live directory instead of a fixed list.
- The suite stays 35 scripts. The slide appendix count is derived by `tests/test-slides.sh`, so no slide edit is needed.

#### Release

- Release v7.10.0 as MINOR. Init is a behavior change: a new discovery command and a new validation source.
- Add `docs/announcements/v7.10.0.md`, move the README banner and counts line to v7.10.0, and reword the README docs-list line that says "eight roles" to avoid a fixed count.
- Update `tests/test-docs-audit.sh` and `tests/test-readme-shape.sh` to v7.10.0. Keep the v7.9.0 announcement-file existence and release-URL assertions; change the README banner and announcement-pointer assertions to v7.10.0.
- Append all six ADR entries as dated `##` headings, matching the store convention.

## Decisions (ADR)

Append these as dated `##` headings in the store; the `###` headings below are plan subheadings.

### 2026-11-26: The presets directory is the single source of truth for roles

- Decision: both scripts derive the role list and validation from the live `docs/examples/customization-presets/` directory. No fixed role list remains.
- Context: the fixed list duplicated the directory and required edits in both scripts for every preset change.
- Consequences: `--list-presets` is accurate by construction; ADR-002 is superseded; the scripts carry only the `web-developer` usage example.

### 2026-11-26: The missing-preset integrity check moves to a consistency test

- Decision: a removed preset is an unknown role at runtime, and a docs and directory consistency test fails when the guide table, the setup example, and the directory disagree.
- Context: a live list has no independent promise to compare against, so a single missing preset cannot be a runtime packaging error.
- Consequences: a missing or extra preset is caught before release, which is stronger than a runtime check; the runtime exit code for a removed preset is 2.

### 2026-11-26: A missing or empty presets directory is a packaging error

- Decision: a missing directory, or a directory with no valid preset, prints a packaging error and exits 1.
- Context: a broken install is still distinguishable from a user typo even without a fixed list.
- Consequences: `--list-presets` and `--role` both fail clearly on a broken install; a symlink preset is also a packaging error (exit 1) and is omitted from the live list.

### 2026-11-26: --list-presets is a standalone command

- Decision: `--list-presets` and `-ListPresets` print the live list and exit 0, and combining them with any other option is a usage error (exit 2).
- Context: a discovery command should not silently ignore a half-written init command.
- Consequences: the behavior is easy to document and test in both languages.

### 2026-11-26: The guide table is the documented list

- Decision: the guide table and the setup example are the documented roles, and a consistency test compares them with the live directory.
- Context: the directory is the runtime source, and the docs must not promise a file that is absent or omit a shipped file.
- Consequences: a preset addition or removal requires a matching docs change; the test enforces it.

### 2026-11-26: Release v7.10.0 as MINOR

- Decision: the release is v7.10.0.
- Context: this adds a CLI command and changes role validation, so it is a behavior change under the docs-only PATCH rule.
- Consequences: a new announcement and README banner; no policy, procedure, or trigger change.

## Deltas

- Modify `support-files/sync-agents-md.sh`: remove `INIT_ROLES`, add the live list helper, `--list-presets`, live validation, the new messages, and the usage.
- Modify `support-files/sync-agents-md.ps1`: remove `Get-InitRoles`, add the live list helper, `-ListPresets`, live validation, the new messages, and the help.
- Modify `tests/test-sync-init.sh`: live-list cases, add and remove cases, no-fixed-list check, consistency check, and the changed missing-preset case.
- Modify `tests/verify-powershell-scripts.ps1`: `-ListPresets`, add and remove cases, the changed missing-preset case, and the live list.
- Modify `docs/setup.md`: the live list command and the source statement.
- Modify `docs/ai-customization-guide.md`: state that the live directory is the source and the table documents it.
- Create `docs/announcements/v7.10.0.md`.
- Modify `README.md`: v7.10.0 banner and counts line, and reword the "eight roles" docs-list line.
- Modify `tests/test-docs-audit.sh`: derive the preset existence loop from the live directory and pin v7.10.0.
- Modify `tests/test-readme-shape.sh`: pin v7.10.0.
- Append the ADR entries to `design-docs/protocol-decisions.md`.
- Append the dated plan entry to `ai/issues/open/sync-list-presets-live-directory.md`.
- No policy, procedure, or trigger change. The suite stays 35 scripts. No TSV file.

## Acceptance Criteria

- AC-1: `--list-presets` and `-ListPresets` print the live slugs, sorted ordinal, one per line, and exit 0. Asserted by the init fixture and the PowerShell verification.
- AC-2: The list is live. In a copied clone, a temporary `.md` preset appears and can be used, and a removed preset disappears and is an unknown role. Asserted by the fixture.
- AC-3: No fixed role list remains in the two sync scripts. Every live slug except `web-developer` is absent from both scripts, and `web-developer` appears in the usage. Asserted by the no-fixed-list check. The role content fixtures in `tests/test-customization-presets.sh` stay as test data, not runtime sources.
- AC-4: Role validation uses the live directory. A valid live preset is accepted; an absent one is an unknown role (exit 2) and the error lists the live set. Asserted by the unknown-role and removed-preset cases in `tests/test-sync-init.sh`.
- AC-5: A missing directory and an empty directory each exit 1 with the named message, for `--list-presets` and `--role`. Asserted in a copied clone or a temporary workflow directory, never against the real presets.
- AC-6: A symlink preset is omitted from the list and rejected as an invalid preset (exit 1) on `--role`. Asserted by the symlink-preset case in `tests/test-sync-init.sh`, run in a copied clone.
- AC-7: The unknown-role and required-role messages list the live presets and the guide reference in both scripts; the missing-role-value message is Bash-only because PowerShell's parameter binder rejects it before the script. Asserted by the error-message checks.
- AC-8: The usage shows `--list-presets` and one example role, with no full list. Asserted by the usage grep in `tests/test-sync-init.sh`.
- AC-9: The guide table, the setup example, and the live directory agree. A missing or extra preset fails the consistency check. Asserted by the guide-table, setup-example, and directory consistency check in `tests/test-sync-init.sh`.
- AC-10: The docs mention `--list-presets` and the live source. Asserted by a docs grep in `tests/test-sync-init.sh` for `--list-presets` and the live-source sentence.
- AC-11: Bash and PowerShell parity for the command, the messages, and the live list. Asserted by the static checks and the PowerShell cases when `pwsh` is available.
- AC-12: Existing init behavior is unchanged: dry run, target and root rules, write safety, exit codes, workflow substitution, and no Default Shell. Asserted by the retained cases.
- AC-13: Validator 8/8, suite 35/35, and index 26/16/59. Asserted by the commands.
- AC-14: The release is v7.10.0, the announcement and README are updated, the v7.9.0 announcement-file and release-URL assertions stay, and the banner and pointer move to v7.10.0. Asserted by the docs fixtures.

## Verification

- `bash support-files/validate-protocol.sh` returns 8/8.
- `bash tests/run-all.sh` passes 35/35.
- `bash tests/test-sync-init.sh` passes, including the live-list, add and remove, no-fixed-list, and consistency checks.
- `bash tests/test-sync-agents-md.sh` still passes its 14 cases.
- `bash tests/test-config-resolution.sh`, `test-docs-audit.sh`, `test-readme-shape.sh`, and `test-slides.sh` pass.
- `markdownlint-cli2` on the changed markdown reports 0.
- `shellcheck` on the changed shell reports 0.
- PowerShell runtime and parse are PENDING when `pwsh` is absent.
- The boot index stays 26 policies, 16 procedures, and 59 triggers.

## Peer Review Log

- Round 1: review-184, CHANGES REQUESTED. Fixed the PowerShell removed-preset case, the release pins, the baseline wording, the evidence ranges, the per-criterion assertions, the fixed-list scope, the copied-clone packaging cases, the ADR heading level, and the missing-value ordering.
- Round 2: review-185, CHANGES REQUESTED. Fixed the AC-8 and AC-10 assertions, the Deltas PS1 line, and the risk line.
- Round 3: review-186, CHANGES REQUESTED. Fixed the usage and help token spelling.
- Round 4: review-187, CHANGES REQUESTED. Fixed the Round 3 log entry and removed the stale pending line.
- Round 5: review-188, APPROVED.

## Risks and Rollback

- The live list can drift from the guide table. The consistency test fails on a missing or extra preset.
- A missing or empty directory now exits 1; the tests cover both messages.
- The symlink preset path can be inconsistent with the list; the list omits it and `--role` reports the packaging error.
- Bash and PowerShell can sort differently. Both use ordinal sort, and the cases compare the live set.
- The remove cases can mutate the real repo. All add, remove, missing, empty, and symlink cases run in a copied clone or a temporary workflow directory.
- Rollback: revert the squash commit, delete the `v7.10.0` tag and GitHub Release, and restore the README banner. No data migration is involved.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base ref: `master`.
- Baseline: a chore commit on `master` of the plan, the ticket, and the pre-existing planning state (the state files and the daily checkpoint from the last checkpoint). The implementation checkpoint is written on `feature/sync-list-presets` before the commit.
- Branch: `feature/sync-list-presets`.
- Ticket: `ai/issues/open/sync-list-presets-live-directory.md`, plan attached, closed with the merge.
- Merge mode: `direct`.
- Release: `v7.10.0`, MINOR, annotated tag and GitHub Release, with `docs/announcements/v7.10.0.md` and the README banner.
- Evidence: validator 8/8, suite 35/35, init fixture pass, sync fixture 14/14, markdownlint 0, shellcheck 0, PowerShell parity run or PENDING, review APPROVED, clean tree, branch at least one commit ahead.
- Order: checkpoint on the branch before the commit; squash merge; tag and publish after the merge; no post-merge commits.
