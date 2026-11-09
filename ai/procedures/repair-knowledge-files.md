# PROCEDURE REPAIR-KNOWLEDGE-FILES: Audit and repair knowledge files with a conservation manifest

## Triggers

- repair knowledge files
- tidy knowledge files
- heal knowledge files

**Boundaries**: This procedure audits and repairs knowledge files only. It never edits a design document or a state file, and it never runs at checkpoint.

**Failure rule**: Preserve rather than corrupt. When the manifest is incomplete or an item has no disposition, leave that file unchanged, report the conflict, and continue with the other files; do not ask.

1. **STEP-LOAD-KNOWLEDGE-RULES**: Load `ai-policy-common.md` and read `## Knowledge File Standards` and `### Knowledge Repair Conservation Contract`.
2. **STEP-RESOLVE-KNOWLEDGE-SCOPE**: Default to the project store. Read `global`, `both`, or `dry run` after the trigger. Treat those words as scope or option words, not aliases.
3. **STEP-INDEX-KNOWLEDGE-CORPUS**: Index the selected stores and read every selected file in full.
4. **STEP-AUDIT-KNOWLEDGE**: Audit structure, tables, cross-file pointers, sensitive scope, secrets, size, duplicates, and headers. Write nothing.
5. **STEP-BUILD-KNOWLEDGE-MANIFEST**: Build one row per old item in memory with old ID, old location, new location, disposition, and a one-line reason. Leave a file with an item that has no disposition unchanged and report it.
6. **STEP-DRY-RUN-KNOWLEDGE-REPAIR**: If the scope includes `dry run`, report the dispositions from memory and stop; write and replace nothing.
7. **STEP-BACKUP-KNOWLEDGE**: Write the manifest to `ai/artifacts/knowledge-repair-<date>/manifest.md`. Copy the old project files to `ai/artifacts/knowledge-repair-<date>/project/` and the old global files to `~/.ai/knowledge-repair-backups/<date>/global/`.
8. **STEP-WRITE-KNOWLEDGE-CANDIDATE**: Write the candidate to a temporary path. Remove defined garbage, inline needed short facts, remove every cross-file pointer except a path that a checklist step writes or edits, convert every table row, merge duplicates with no pointer, compress, replace the header, remove raw secrets, keep project names, remove global names, and never split.
9. **STEP-REVIEW-KNOWLEDGE-SIZE**: Run the 15,000-byte automatic review in the candidate. Remove garbage and duplicates and compress. Keep a file that remains over 15,000 bytes as one file and report it.
10. **STEP-VERIFY-KNOWLEDGE-CANDIDATE**: Verify every item, no new claim, no cross-file pointer, self-standing content, the header, no split, the file count not increased, the size, the project and global sensitive scope, and the secret removal.
11. **STEP-REVIEW-KNOWLEDGE-REPAIR**: Run the independent review and require an `APPROVED` verdict. On `CHANGES REQUESTED`, fix and re-review. If it cannot pass without content loss, leave the old file unchanged and report.
12. **STEP-REPLACE-KNOWLEDGE-REPAIR**: Replace only the files with a complete manifest and an `APPROVED` review. Leave aborted and review-failed files untouched. Restore the backup on failure.
13. **STEP-REPORT-KNOWLEDGE-REPAIR**: Report the files, merges, trims, preserved ambiguous items, aborted files, manifest and backup paths, and sizes without asking a question. Record the manifest and backup paths in the checkpoint and diary. Delete the temporary candidate after replacement or abort.
