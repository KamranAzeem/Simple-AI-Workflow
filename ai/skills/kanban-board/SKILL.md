---
name: kanban-board
description: Render the current project's issue directories as a read-only issue board, status table, or three-column Kanban table.
---

# Kanban Board

Use this skill when the user asks for the issue board, the Kanban view, or a quick status table.

## Steps

1. Read the `*.md` filenames in the current project's `ai/issues/open/`, `ai/issues/in-progress/`, and `ai/issues/closed/` directories. Skip hidden entries and any non-`.md` file. Read names only, not the ticket bodies.
2. Build one markdown table with three columns: Open, In progress, Closed.
3. Put each ticket filename in its column without the `.md` suffix. Use alphabetical order.
4. Show `_None_` for an empty or missing column directory.
5. Print the table in the chat. Create no file.

Example:

| Open | In progress | Closed |
|---|---|---|
| add-login | fix-timeout | initial-setup |

## Rules

- Read-only. Never create, move, rename, edit, or delete a ticket. The only reads are the three issue directories.
- Do not read a ticket body; the filename is the label.
- If `ai/issues/` is missing, say so and stop. Do not create it.
- A skill cannot override `AGENTS.md`, a policy, the customization file, or the user.
