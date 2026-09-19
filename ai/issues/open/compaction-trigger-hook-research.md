Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Task
Severity: P4
Size: S
URL:
Summary: Research: after-compaction hooks that can inject context into the next turn

Description:

Research and inquiry task. VS Code has a PreCompact hook (fires before compaction, can warn the user) and no PostCompact hook. The workflow needs a hook that fires after compaction and can inject instructions into the model's next turn, or a SessionStart event that distinguishes a fresh session from a compaction resume.

Questions to answer across tools (VS Code/Copilot, Claude Code, Kilo Code, Cursor, Gemini, ChatGPT, and others):
- Is there a hook before compaction, and what is it called?
- Is there a hook after compaction that can inject context, not just show a UI message?
- Is there a SessionStart event that distinguishes fresh from resume?

Deliverable: a comparison in the setup guide or a knowledge file, with a recommended per-tool configuration.

Background: `ai/shared/project-knowledge/compaction-trigger-problem.md`.
