<!--
Created-by: Cline
Updated-by: Cline
Last modified: 2026-04-24T20:35:00+02:00
Intent: Extract VSCode /init instructions from README into a separate doc.
-->
---
# VSCode `/init` Instructions

This document is for users who prefer using the built-in `/init` command in VS Code despite the recommendation to use text prompts instead.

> **Recommendation:** Use `"bootstrap using AGENTS.md protocol"` or `"init using AGENTS.md protocol"` instead of `/init`. Text prompts work the same way across all AI tools, while `/init` behaves differently depending on the extension.

## Setup

To make `/init` honor `AGENTS.md` by default, add the following section to the VS Code file: `{{VSCODE_USER_PROMPTS_FOLDER}}/init.instructions.md`

### File Location by OS

| OS | Path |
|----|------|
| Linux | `~/.config/Code/User/prompts/init.instructions.md` |
| macOS | `~/Library/Application Support/Code/User/prompts/init.instructions.md` |
| Windows | `%USERPROFILE%\AppData\Roaming\Code\User\prompts\init.instructions.md` |

### Content

```markdown
---
description: Use when bootstrapping a new repository with /init. Always read AGENTS.md first as the single source of truth.
applyTo: "**"
---

# /init Bootstrap Guide

When running `/init`, always:
1. Read AGENTS.md first — it is the single source of truth for AI file locations and policy hierarchy
2. GitHub Copilot files must go under `ai/github-copilot/`, never workspace root
3. If policy conflicts with init task, STOP and ask for clarification

Do not create copilot-instructions.md, *.prompt.md, or other GitHub Copilot customizations in workspace root.
```
