# PROCEDURE REPAIR-KNOWLEDGE-FILES: Audit and repair knowledge files with a conservation manifest

## Triggers

- repair knowledge files
- tidy knowledge files
- heal knowledge files

**Boundaries**: This procedure audits and repairs knowledge files only. It never edits a design document or a state file, and it never edits a skill package under `ai/skills/`. It never runs at checkpoint.

**Failure rule**: Preserve rather than corrupt. When the manifest is incomplete or an item has no disposition, leave that file unchanged, report the conflict, and continue with the other files; do not ask.

1. **STEP-LOAD-KNOWLEDGE-RULES**: Load `ai-policy-common.md` and read `## Knowledge File Standards` and `### Knowledge Repair Conservation Contract`.
2. **STEP-RESOLVE-KNOWLEDGE-SCOPE**: Default to the project store. Read `global`, `both`, or `dry run` after the trigger. Treat those words as scope or option words, not aliases. The scope includes the store's ticket files, executed plans, finished artifact evidence, and pointers to its files.
3. **STEP-INDEX-KNOWLEDGE-CORPUS**: Index the selected stores and read every selected file in full.
4. **STEP-AUDIT-KNOWLEDGE**: Audit structure, tables, cross-file pointers, sensitive scope, secrets, size, duplicates, headers, the 50-file count, the six-segment names, the under-3 KB files, incident evidence, and dangling pointers in the settings, issues, handoffs, and ticket files. Write nothing.
5. **STEP-BUILD-KNOWLEDGE-MANIFEST**: Build one row per old item in memory with old ID, old location, new location, disposition, and a one-line reason. Mark incident-only items `removed as incident evidence`; record a rename or a retirement. Leave a file with an item that has no disposition unchanged and report it.
6. **STEP-DRY-RUN-KNOWLEDGE-REPAIR**: If the scope includes `dry run`, report the dispositions from memory and stop; write and replace nothing.
7. **STEP-BACKUP-KNOWLEDGE**: Write the manifest to `ai/artifacts/knowledge-repair-<date>/manifest.md`. Copy the old project files to `ai/artifacts/knowledge-repair-<date>/project/` and the old global files to `~/.ai/knowledge-repair-backups/<date>/global/`.
8. **STEP-WRITE-KNOWLEDGE-CANDIDATE**: Write the candidate to a temporary path. Remove defined garbage, inline needed short facts, remove every cross-file pointer except a path that a checklist step writes or edits, convert every table row, merge duplicates with no pointer, compress, replace the header, remove raw secrets, keep project names, remove global names, split only by task topic, and never split by ticket, incident, date, phase, or environment. Merge a file under 3,000 bytes into its nearest topic file. Keep the store at the 50-file review threshold. Delete incident evidence under the `removed as incident evidence` disposition. Rename to the task-based convention.
9. **STEP-REVIEW-KNOWLEDGE-SIZE**: Run the 15,000-byte automatic review in the candidate. Remove garbage and duplicates and compress. Split a file that remains over 15,000 bytes by task topic. Keep a checklist in one file and report a file that cannot be split.
10. **STEP-VERIFY-KNOWLEDGE-CANDIDATE**: Verify every item, no new claim, no cross-file pointer, self-standing content, the header, do not split except by topic, the store count and the 50-file report, every item dispositioned, the naming rule, the dangling-reference scan, the size, the project and global sensitive scope, and the secret removal.
11. **STEP-REVIEW-KNOWLEDGE-REPAIR**: Run the independent review and require an `APPROVED` verdict. On `CHANGES REQUESTED`, fix and re-review. If it cannot pass without content loss, leave the old file unchanged and report.
12. **STEP-REPLACE-KNOWLEDGE-REPAIR**: Replace only the files with a complete manifest and an `APPROVED` review. Leave aborted and review-failed files untouched. Restore the backup on failure.
13. **STEP-REPORT-KNOWLEDGE-REPAIR**: Report the files, merges, trims, preserved ambiguous items, aborted files, manifest and backup paths, and sizes without asking a question. Report the store count and any overage, the retirements, and the pointer report. Record the manifest and backup paths in the checkpoint and diary. Delete the temporary candidate after replacement or abort.
