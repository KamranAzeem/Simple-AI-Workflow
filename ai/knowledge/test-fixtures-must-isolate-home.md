> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Test Fixtures Must Isolate HOME

## Context

The sync script and the settings scripts default to the user directory under the real home when a fixture does not set one. A fixture that copies a customization without `User AI Directory` therefore resolves `$HOME/.ai` on the test host.

## Rule or Fix

- Set `HOME` to a temporary directory before any fixture that invokes a script which can resolve the user directory.
- Set `USERPROFILE` too when the fixture may run PowerShell on Windows.
- Create the fake `settings/`, `knowledge/`, `skills/`, and `backups/` subdirectories so the probe succeeds instead of returning `PENDING`.
- Give the fixture an explicit `User AI Directory` when the test is not about the default path.
- Check after the run that the real user store is unchanged when the test host can expose it.

## Why

- The v7.7.0 migration is destructive by design when the old and new stores coexist: it moves the user knowledge, moves the settings file, and creates `skills/`.
- A default-path test on a developer host can migrate the developer's live store even though the repository change is correct.
- An isolated HOME makes the test deterministic and keeps the real backup directory out of the test path.

## Verify

- Read the fixture and confirm it assigns and exports `HOME` before the first script call.
- Confirm the fake home has the four user subdirectories the probe and migration expect.
- Run the fixture and confirm it does not touch the real `~/.ai` paths.
- Confirm the test asserts the migration output, not the host's real settings.

## Caveats

- The path-probe timeout is separate; a fake home that does not exist returns `PENDING`, not a migration.
- The backup directory exclusion still applies to the real user store; a test must never read or list it.
- This rule applies to any future script that defaults to a home-relative directory, not only the sync script.
