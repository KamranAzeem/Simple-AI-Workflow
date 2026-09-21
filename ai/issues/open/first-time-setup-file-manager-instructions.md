Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: S
URL:
Summary: Add first-time setup instructions using a file manager, not only the command line

Description:

Many users struggle with the command line, and with the sync script on Windows Git Bash, CMD, and PowerShell. Add clear first-time setup steps that use a file manager:
- Copy `AGENTS.md` from the Simple-AI-Workflow clone into the project root.
- Copy `docs/ai-customization.md` to the project root as `ai-customization.md`.
- Edit the workflow directory path inside it.

Place these near the quick start and keep them parallel to the command-line steps.

Acceptance criteria:
- A file-manager path is documented for the first-time copy of `AGENTS.md` and `ai-customization.md`.
- The steps name the exact source and destination.
- The command-line path remains available.
