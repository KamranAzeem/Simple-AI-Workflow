Reported: 2026-11-17
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M, or L with the shell preference)
Label:
URL:
Summary: Define a tool-selection ladder, make git-ignored protocol files readable, and resolve the shell before the first command

Description:

- The bootstrap router mandates shell reads for git-ignored protocol files, which conflicts with a built-in-first rule.
- The common policy has no rule for choosing a purpose-built tool, the shell, or Python.
- The shell preference is read after the first boot commands, so a Windows session can run every command in the wrong shell.
- Full design record: `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md`.
- Related: GitHub #9 for the shell preference and #10 for the VS Code approvals.

## Open Decisions

- Whether the shell preference config belongs in this unit or its own unit.
- Whether the work stays on the current program branch or moves to a new branch cut from it.

---
2026-11-17
Design discussion recorded in Project Knowledge. Awaiting the scope and branch decisions before planning.
