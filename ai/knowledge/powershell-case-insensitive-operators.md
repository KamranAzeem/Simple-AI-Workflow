> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# PowerShell Case-Insensitive Operators

## Context

- `-match`, `-notmatch`, `-contains`, `-eq`, and `-replace` are case-insensitive by default in PowerShell.
- Bash `case` and POSIX regex are case-sensitive.

## Rule or Fix

- Use `-cmatch`, `-cnotmatch`, `-ccontains`, `-ceq`, and `-creplace` for case-sensitive validation.
- When a validator must reject uppercase, pin the behavior in both scripts and test a mixed-case value.

## Why

- A mixed-case role slug passed the PowerShell whitelist while Bash rejected it, so the two scripts diverged on exit code and file lookup.

## Verify

- Run the uppercase role case in `tests/test-sync-init.sh` and `tests/verify-powershell-scripts.ps1`.
- Confirm both exit 2 with `Unknown role`.
