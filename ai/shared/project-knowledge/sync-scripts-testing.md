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
