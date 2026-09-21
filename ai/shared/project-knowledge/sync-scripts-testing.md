# Sync Scripts — Testing Results

## Test Date
2026-05-29

## Test Scenario
Propagated the updated canonical `AGENTS.md` (with metadata header mandate removed) to an external project directory using `sync-agents-md.sh`.

## Target
`/home/kamran/Projects/MurtazaSb/gitlab/AGENTS.md`

## Script Used
[`support-files/sync-agents-md.sh`](support-files/sync-agents-md.sh)

## Results
- **Config preservation**: Both `Global AI Workflow Directory` and `Global User AI Directory` values were correctly extracted from the target and injected into the new canonical file.
- **Metadata header removal**: The old `TIER 4: OPERATIONAL STANDARDS (Metadata & Timestamps)` section was correctly replaced with the new `TIER 4: APPENDIX`.
- **Procedure D update**: The scan scope exclusion list was updated to include `git-ignored` directories.
- **All other protocol content**: Synced to latest canonical version.

## Key Finding
The `sed` alternation pattern `(Framework|Workflow)` in the Bash script was previously broken due to a delimiter conflict with `|` inside the alternation group. Fixed by switching from `/` to `#` as the `sed` delimiter. The PowerShell script had a corresponding capture group index bug (used `$Matches[2]` instead of `$Matches[1]` for the User AI Dir extraction), which was also fixed.

## Status
Sync scripts are functional and tested. Ready for production use.

## 2026-08-22 — macOS BSD sed compatibility fix

### Problem
On macOS, `sed -i -E 's#...(\...)#\1...#'` fails with `\1 not defined in the RE` when updating the workflow directory path in a target `ai-customization.md`. BSD `sed` treats the argument after `-i` as the backup-suffix, so `-E` is consumed as that suffix and the regex runs in basic mode, where `(...)` is not a capture group and `\1` is undefined. GNU sed tolerates this; BSD does not.

### Fix (sync-agents-md.sh)
Replaced `sed -i -E` with a portable basic-regex temp-file write, dropping the backreference:

```sh
tmp=$(mktemp)
sed 's#^\*\*Global AI Workflow Directory\*\*:.*#**Global AI Workflow Directory**: '"$escaped_dir"'#' "$customization_file" > "$tmp"
mv "$tmp" "$customization_file"
```

### Lesson
`sed -i` semantics differ between GNU and BSD. For cross-platform shell scripts, avoid `-E` with backreferences and in-place editing; use basic regex + temp file + `mv` (matches the pattern the script already used for config-section insertion). Verified on Linux; not executed on real macOS in this session.

## 2026-09-19: symlinked ai-customization.md fix + regression test

### Problem
A root `ai-customization.md` that is a symlink to `ai/ai-customization.md` was read as a duplicate. The script renamed the real file to `.bak` and left the root link dangling, so the next load context found no customization.

### Fix (both scripts)
Detect the symlinked layout and edit the real target in place. A symlink-preserving write replaces the plain `mv` so a linked root is never replaced by a regular file. A genuine old-plus-root conflict on a regular root file still renames the old file to `.bak`.

### Test
`support-files/test-sync-agents-md.sh` builds temp projects and covers the symlink layout, a normal regular root, the legacy move, and the genuine conflict. Run it with `bash support-files/test-sync-agents-md.sh`; all 13 checks pass on Linux.

### Caveat
The PowerShell change is mirrored but not executed (no `pwsh` on the machine used). Verify on Windows when one is available.
