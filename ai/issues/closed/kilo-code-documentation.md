Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P4
Size: S
URL:
Summary: Document Kilo Code support in the post-compaction reload trigger setup guide

Description:

Not urgent. Attend later.

Work:

- Add a Kilo Code row to the per-assistant table in `docs/post-compaction-reload-trigger-setup.md`, plus a short section below the Copilot hooks section.
- Add a Kilo Code answer block to `ai/shared/project-knowledge/compaction-trigger-problem.md`.

Key facts to document:

- AGENTS.md is always-on as system instructions in Kilo Code, so it survives compaction by architecture and needs no trigger file.
- The compaction summary is visible in chat.
- The human backstop ("run Post-Compaction Recovery") is sufficient.
- No workflow slash command and no new files.

Origin: `ai/notes/kilo-code-documentation.md` (removed, captured here).

## Closure

Closed on 2026-11-19 by the backlog evaluation sweep. Merged into `replace-cline-provider-with-kilo-code.md`; the three Kilo facts and the post-compaction guide updates are part of that ticket.
