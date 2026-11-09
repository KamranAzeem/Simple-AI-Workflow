# PROCEDURE MIGRATE-DESIGN-DOCS: When the user says "migrate design docs"

## Triggers

- migrate design docs
- migrate design documents

**Boundaries**: moves existing design documents only, from the fallback location into `design-docs/` beside the code. It never edits content and never updates project knowledge. It is the only cross-location mover.

1. **STEP-LOAD-MIGRATION-POLICY**: Load `ai-policy-design-docs.md` from the **Global AI Policies Directory** in full.
2. **STEP-FIND-UNMIGRATED-DOCS**: Search `ai/shared/project-knowledge/`, including subdirectories, for the doc-type vocabulary.
3. **STEP-CONFIRM-MIGRATION**: List every file to move, its target `design-docs/` path, and the git impact (the files become tracked). Get approval before writing.
4. **STEP-MOVE-FILES**: Move each approved file to `design-docs/`, renaming it to the simple lowercase doc name. Move, never copy.
5. **STEP-REPORT-MIGRATION**: Report the files moved, the target location, and any file left behind.
