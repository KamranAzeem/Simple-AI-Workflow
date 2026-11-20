> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Portable Permission Checks

## Context

A script creates an artifact and verifies that only the owner can read it. A POSIX mode check is the usual proxy. It is not portable to Git Bash and MSYS, where Windows ACLs do not map to a POSIX mode.

## Rule or Fix

- Gate a POSIX mode check by platform: skip or downgrade it under MINGW, MSYS, and CYGWIN.
- Force the owner-only mode with `umask` and `chmod` where the filesystem supports POSIX modes.
- On Windows, verify the ACL with the platform tool, or report that ACL verification is unavailable.
- Never delete a good artifact because a portable check cannot run.
- Print the platform decision and the check result, so a skipped check is visible.

## Why

- `find -perm 600` returns no match under Git Bash even when the archive is protected by an ACL.
- Deleting the artifact on a failed proxy check loses data and hides the real cause.
- A silent skip is as bad as a false failure; the operator must know which control applied.

## Verify

- On POSIX, the artifact reports mode 600 and the check passes.
- Under Git Bash, the artifact is kept and the script prints that ACL verification is unavailable.
- The exit code reflects real failures only, not an unavailable platform check.

## Caveats

- Windows ACLs are the real control. A POSIX mode check is only a proxy.
- A forced 0600 on a network share can be ignored by the server; verify on the target filesystem, not the mount point.
