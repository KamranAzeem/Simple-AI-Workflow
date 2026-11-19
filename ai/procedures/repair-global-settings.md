# PROCEDURE REPAIR-GLOBAL-SETTINGS: Repair the global settings files

## Triggers

- repair global settings
- tidy global settings
- heal global settings

**Boundaries**: repairs the **Global AI Settings Directory** only. It never touches the knowledge stores, the state files, or the project tree; the artifacts and the report are the only project writes.

**Failure rule**: preserve rather than corrupt. When the manifest is incomplete or an item has no disposition, leave that file unchanged, report the conflict, and continue with the other files.

1. **STEP-LOAD-SETTINGS-RULES**: Load `ai-policy-global-settings.md` in full.
2. **STEP-RESOLVE-SETTINGS-SCOPE**: Read `dry run` after the trigger. If it is absent, target every file in the **Global AI Settings Directory**.
3. **STEP-INDEX-SETTINGS-CORPUS**: Index the settings files and read each selected file in full.
4. **STEP-AUDIT-SETTINGS**: Audit the sections, keys, prose, duplicates, secrets, size, tools, sensitive names, and identity fields. Write nothing.
5. **STEP-BUILD-SETTINGS-MANIFEST**: Build one row per item with the section and line as the old ID, the old location, the new location, the disposition, and a one-line reason. Leave a file with an item that has no disposition unchanged and report it.
6. **STEP-DRY-RUN-SETTINGS-REPAIR**: On `dry run`, report the dispositions and stop; write and replace nothing.
7. **STEP-BACKUP-SETTINGS**: Write the manifest and the project copies to `ai/artifacts/settings-repair-<date>/`, and copy the global files to `<Global User AI Directory>/settings-repair-backups/<date>/`.
8. **STEP-WRITE-SETTINGS-CANDIDATE**: Write the candidate: consolidate, apply the canonical keys, split `Identity` from `Profile`, verify the tools, trim, redact, and drop the garbage.
9. **STEP-VERIFY-SETTINGS-CANDIDATE**: Verify every item, the identity keys, the canonical keys, the verified tools, the redaction, the size, and that no other store changed.
10. **STEP-REVIEW-SETTINGS-REPAIR**: Run the independent review and require an `APPROVED` verdict. On `CHANGES REQUESTED`, fix and re-review.
11. **STEP-REPLACE-SETTINGS-REPAIR**: Replace only the files with a complete manifest and an `APPROVED` review. Leave the other files unchanged, and restore the backup on failure.
12. **STEP-REPORT-SETTINGS-REPAIR**: Report the files, the merges, the trims, the tool changes, the preserved items, the manifest and backup paths, the counts, and any overage. Delete the temporary candidate.
