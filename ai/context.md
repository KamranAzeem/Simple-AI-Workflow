<!--
Created-by: Cline
Updated-by: Cline
Last modified: 2026-05-02T19:42:00+02:00
Intent: Checkpoint CP-2026-05-02-04.
-->
---
# Project Context: Simple-AI-Workflow

## What This Repository Is

This is a **personal starter kit** for individual developers who want to turn their AI assistant from a chat buddy into a structured, reliable teammate. It provides:

- A **centralized policy system** (AGENTS.md + ai/ policies) that works across any AI tool (ChatGPT, Claude, Copilot, Gemini, etc.)
- **State tracking** (checkpoints, progress, next-steps) so AI never forgets where you left off
- **Multi-agent coordination** (handoffs, knowledge base, task claiming) for working across sessions or AI tools
- **Security guardrails** (secrets scanning before commits, boundary control via .aiignore)

## Key Design Decisions

1. **Individual-first, not team-first**: Built for one developer. Team collaboration would need a different approach.
2. **Text prompts over /init commands**: The built-in `/init` command behaves differently across AI tools. Text prompts like `"bootstrap using AGENTS.md protocol"` work the same everywhere.
3. **Central policy directory**: Policies live in a central location (referenced in AGENTS.md) and are not copied per-project. Only AGENTS.md and local overrides go into each project.
4. **ai/ is git-ignored**: All AI workflow artifacts (checkpoints, notes) stay local and private.

## Repository Structure

```
Simple-AI-Workflow/
├── AGENTS.md                    # Bootstrap entry point for AI assistants
├── README.md                    # Main documentation
├── ai/                          # AI workflow artifacts (git-ignored)
│   ├── about-human.md           # User profile (Kamran, Platform Engineer)
│   ├── policies/                # AI policy + compliance documents
│   │   ├── ai-policy-meta.md
│   │   ├── ai-policy-common.md
│   │   ├── ai-policy-cloud.md
│   │   ├── ai-policy-web-frontend.md
│   │   ├── ai-policy-api-backend.md
│   │   ├── ai-policy-data.md
│   │   ├── ai-policy-linux-system-admin.md
│   │   ├── ai-policy-mobile-apps.md
│   │   ├── ai-policy-override.example.md
│   │   └── compliance/
│   │       ├── ccpa.md
│   │       └── ...
│   ├── daily-checkpoints/       # Daily snapshots
│   ├── next-steps.md            # Current resume point
│   ├── progress.md              # Chronological history
│   ├── context.md               # This file — project briefing
│   ├── shared/
│   │   ├── coordination.md      # Task claiming board
│   │   ├── handoffs/            # Async task transfers
│   │   └── knowledge-base/      # Local AI workflow notes
│   ├── artifacts/               # Draft outputs from sessions
│   └── notes/                   # Raw unpolished notes
│   ├── workflow-guide.md
│   ├── ai-agent-collaboration.md
│   ├── ai-policy-mobile-apps-guide.md  # Mobile policy usage guide
│   ├── example-learning-session-runbook.md
│   ├── MCP-and-its-benefits.md
│   ├── vscode-init-instructions.md
│   ├── about-human.md
│   ├── personas/
│   └── examples/
├── support-files/               # Sync scripts (Bash + PowerShell)
└── .gitignore
```

## Current State

- **Checkpoint**: CP-2026-05-02-04
- **Last activity**: Promoted slide deck to docs/, added "Talk to AI Like a Person" slide, created 5 handoffs (reorganize-ai-directory, auto-lint, project-manager-role, multi-agent-runbook-slides, marketable-product-packaging), closed review-slide-deck and cross-project-shared-knowledge handoffs.

- **Coordination**: Active claim by Cline on reorganize-ai-directory.md
- **Handoffs**: 5 pending (reorganize-ai-directory, auto-lint, project-manager-role, multi-agent-runbook-slides, marketable-product-packaging)
- **Knowledge Base**: Empty

## Project Evolution & Git History
- **Summary**: This repository evolved from a set of basic AI policy files into a comprehensive multi-agent coordination framework.
- **Last Summarized Hash**: 02679aed0596f5fbe1aa815e47ce4898d7882ea0 (2026-05-02: Streamlined bootstrap protocol)
