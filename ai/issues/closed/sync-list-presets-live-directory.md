Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Read the sync init role list live from the presets directory and add --list-presets

Description:

## Problem

The sync scripts keep the role slugs in a fixed literal. That duplicates the presets directory, drifts when a preset is added or removed, and gives the CLI no way to show the roles. A user who types `--role` without a value sees the usage but no role list, and every new preset needs a matching script edit in both languages.

## Scope

- Add `--list-presets` to `support-files/sync-agents-md.sh` and `-ListPresets` to `support-files/sync-agents-md.ps1`. The command prints the live regular, non-symlink `.md` basenames from `docs/examples/customization-presets/` under the workflow clone, sorted, one per line, and exits 0.
- Derive role validation from the live directory. A slug is valid only when the matching `.md` file exists as a regular file and is not a symlink. An absent file is an unknown role.
- Remove every fixed role list from both scripts. Keep one example slug in the usage, `web-developer`, and no full list.
- The unknown-role, missing-role-value, and missing-required-role messages name the live presets and point to `docs/ai-customization-guide.md#11-presets-by-role`.
- Keep the slug regex `^[a-z0-9-]+$` so path traversal and uppercase are rejected before the file lookup.
- A missing or empty presets directory is a clear error with a non-zero exit, not an empty success.
- Keep Bash and PowerShell parity, the dry run, workflow substitution, the target and root rules, the write safety, and the exit codes.
- Add a consistency test that the guide table, the setup docs, and the live presets directory agree.

## Semantics change

- This supersedes ADR-002. The fixed whitelist separated an unknown role (exit 2) from a known role with a missing preset (exit 1). With a live list, a removed preset is an unknown role and exits 2, and the runtime missing-preset packaging error is gone.
- Move the packaging check to the test suite. A consistency test asserts that every role in the guide table and `docs/setup.md` has a live preset file, and every preset file is documented. A missing or extra preset fails the test before release.
- The init fixture and the static parity checks that pin the fixed slugs must change. The tests must not assert a fixed list.

## Acceptance criteria

- `--list-presets` and `-ListPresets` print the live sorted list and exit 0.
- In a copied clone, adding a temporary `.md` preset makes it appear in the list and makes `--role <new>` succeed; removing a preset makes `--role <removed>` fail as an unknown role and the error lists the live set.
- A grep of both scripts finds no fixed list of the published slugs; only the `web-developer` example remains.
- A missing or empty presets directory exits non-zero with a clear message.
- The usage shows `--list-presets` and one example role.
- The docs (`docs/setup.md` init section) mention `--list-presets`.
- The init fixture covers the live list, the add and remove cases in a copied clone, the no-fixed-list check, and the error messages; the suite stays green.
- A consistency test reads the live presets directory and compares it with the roles in the guide table and the setup docs; a missing or extra preset fails the test.
- The boot index stays 26/16/59; no policy or procedure change.

## Notes

- No TSV manifest. It remains deferred.
- This is a behavior change, so the release is MINOR under the current docs-only PATCH rule.
- The runtime exit code for a removed preset is 2; the integrity check lives in the test suite.

## Plan (2026-11-26)

Plan attached below.

- Scope: live role list in both scripts, `--list-presets` and `-ListPresets`, no fixed list in the two sync scripts, live validation, the consistency test, docs, and a MINOR v7.10.0 release.
- No TSV manifest; it stays deferred.
- The plan stops before implementation; the approval and close sequence are in the plan.

## Implementation Plan

# Plan: Sync List-Presets Live Directory

## Goal

Make the live presets directory the only role source, add `--list-presets`, remove the fixed list, keep one `web-developer` example, move the integrity check to a consistency test, and release v7.10.0.

## Evidence

- The ticket, the two sync scripts, the init fixture, the PowerShell verification, the guide table, setup, ADR-002, and the v7.9.0 pins were read.
- The live directory is `$WORKFLOW_DIR/docs/examples/customization-presets/`; the guide table is the documented list.
- Suite 35; index 26/16/59; latest tag v7.9.0.

## Depth

L. The change reverses ADR-002, touches both scripts, and adds a consistency test.

## Context

### HLD

- The presets directory is the runtime source for listing, validation, and error hints.
- No fixed role list in the two sync scripts; one `web-developer` example.
- `--list-presets` is standalone and prints the live regular non-symlink `.md` basenames, ordinal, one per line.
- A removed preset is an unknown role (2); a symlink preset is invalid (1); a missing or empty directory is a packaging error (1).
- The docs/directory consistency test replaces the runtime missing-preset check.

### LLD

- Bash and PowerShell resolve the presets directory from the clone root.
- The live list filters regular non-symlink `.md` files and sorts ordinal.
- The slug regex runs before the directory availability check.
- The errors use the live list and `docs/ai-customization-guide.md#11-presets-by-role`.
- `--list-presets` with any other option, including `--help`, exits 2.
- Setup documents `--list-presets`; the guide states the live directory is the source.
- Tests cover the list, option matrix, add/remove in a copied clone, missing/empty directory, symlink preset, no-fixed-list, consistency, docs, and PowerShell parity.

## Decisions (ADR)

1. The presets directory is the single source of truth for roles; ADR-002 is superseded.
2. The missing-preset integrity check moves to a consistency test.
3. A missing or empty presets directory is a packaging error (1).
4. `--list-presets` is standalone; any other option is a usage error (2).
5. The guide table is the documented list; the setup example must exist.
6. Release v7.10.0 as MINOR.

## Deltas

- `support-files/sync-agents-md.sh` and `.ps1`: live list, `--list-presets`, live validation, messages, usage and help.
- `tests/test-sync-init.sh`: live list, option matrix, add/remove, missing/empty, symlink, no-fixed-list, consistency, docs.
- `tests/verify-powershell-scripts.ps1`: `-ListPresets`, add/remove, removed preset, required role, guide reference.
- `tests/test-docs-audit.sh` and `tests/test-readme-shape.sh`: v7.10.0 pins.
- `docs/setup.md`, `docs/ai-customization-guide.md`, `README.md`, `docs/announcements/v7.10.0.md`, and six ADRs.
- No policy, procedure, or trigger change; suite 35; no TSV.

## Acceptance Criteria

- AC-1: `--list-presets` and `-ListPresets` print the live sorted slugs and exit 0. Asserted.
- AC-2: The list is live; add/remove in a copied clone. Asserted.
- AC-3: No fixed list in the two sync scripts; only `web-developer` in the usage. Asserted.
- AC-4: Live validation; a removed preset is unknown (2) with the live set. Asserted.
- AC-5: Missing/empty directory exits 1 with the named message. Asserted in a copied clone.
- AC-6: A symlink preset is omitted and invalid (1). Asserted.
- AC-7: The error messages list the live presets and the guide reference; the missing-value message is Bash-only. Asserted.
- AC-8: The usage and help show `--list-presets` and one example. Asserted with extracted blocks.
- AC-9: The guide table, setup example, and directory agree. Asserted.
- AC-10: The docs mention `--list-presets` and the live source. Asserted.
- AC-11: Bash and PowerShell parity. Static and runtime when `pwsh` is available.
- AC-12: Existing init behavior unchanged. Asserted by the retained cases.
- AC-13: Validator 8/8, suite 35/35, index 26/16/59.
- AC-14: v7.10.0 release surfaces; the v7.9.0 announcement and URL assertions stay. Asserted.

## Verification

- Validator 8/8; suite 35/35; init fixture pass; sync fixture 14/14; config, docs, readme, and slides pass.
- Markdownlint 0; shellcheck 0.
- PowerShell runtime and parse PENDING because `pwsh` is absent.
- Index 26/16/59.

## Peer Review Log

- Plan: review-184, review-185, review-186, review-187 CHANGES REQUESTED; review-188 APPROVED.
- Implementation: review-189 CHANGES REQUESTED; review-190 APPROVED.

## Risks and Rollback

- The live list can drift from the guide; the consistency test catches it.
- The packaging cases run in a copied clone.
- Bash and PowerShell use ordinal sort.
- Rollback: revert the squash commit, delete the `v7.10.0` tag and release, restore the README banner.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base ref: `master`; baseline is the chore commit of the plan, the ticket, and the pre-existing planning state.
- Branch: `feature/sync-list-presets`.
- Ticket: `ai/issues/closed/sync-list-presets-live-directory.md`, plan attached.
- Merge mode: `direct`.
- Release: `v7.10.0`, MINOR, annotated tag and GitHub Release.
- Evidence: validator 8/8, suite 35/35, init fixture pass, markdownlint 0, shellcheck 0, review-190 APPROVED.
- Order: checkpoint on the branch before the commit; squash merge; tag and release after the merge; no post-merge commits.
