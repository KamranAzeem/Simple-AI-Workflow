Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: S
URL:
Summary: Clarify in README that protocol upgrade commands must run from the Simple-AI-Workflow directory

Description:

The README "Keeping AGENTS.md up to date" section does not state clearly that both the `git pull` and the sync script must be run from inside the cloned Simple-AI-Workflow directory. New users run them from their own project, so they pull the wrong repo or run the sync script against the wrong source.

Fix: add an explicit instruction and a copy-paste example that starts by entering the Simple-AI-Workflow clone, for both the pull step and the sync step.

Acceptance criteria:
- README states the working-directory requirement before the commands.
- Both Linux/Git Bash and Windows PowerShell examples show the directory context.
- No change to the scripts themselves.

---
2026-09-19
Implemented. Step 2 now sends the user to the clone directory before `git pull`, and both the Linux/Git Bash and Windows PowerShell blocks start with `cd` into the clone, so each is self-contained. Scripts unchanged. Peer-reviewed: review-12 CHANGES REQUESTED (Linux block missing the directory), fix applied, review-13 APPROVED. Validator v5.0 8/8; markdownlint 0 issues. Committed and pushed on 2026-09-19. Ticket closed.
