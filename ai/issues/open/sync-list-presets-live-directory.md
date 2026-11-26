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

Plan: `ai/plans/sync-list-presets-live-directory.md` (review-188 APPROVED).

- Scope: live role list in both scripts, `--list-presets` and `-ListPresets`, no fixed list in the two sync scripts, live validation, the consistency test, docs, and a MINOR v7.10.0 release.
- No TSV manifest; it stays deferred.
- The plan stops before implementation; the approval and close sequence are in the plan.
