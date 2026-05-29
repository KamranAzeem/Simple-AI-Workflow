<!--
Created-by: Cline
Updated-by: GitHub Copilot
Last modified: 2026-05-21T00:00:00+02:00
Intent: Fix stale 'final step' checkpoint reference; add Project Knowledge Sync feature.
-->
---
# Simple AI Workflow
## From Chatting with AI, to Working with AI

Your trusted pair-programmer / co-driver / co-pilot

A no-fluff, simple & secure workflow for reliable AI-assisted work

by Muhammad Kamran Azeem (kamran@wbitt.com)

[github.com/KamranAzeem/Simple-AI-Workflow](https://github.com/KamranAzeem/Simple-AI-Workflow) — Creative Commons Attribution 4.0 International
... (rest of slides until feature list) ...
---

# More Features

- **Safe Git Operations** — Secrets scanning before every commit
- **No Tooling Lock-in** — Purely protocol-based; no brittle scripts or "song and dance"
- **Git Enrichment** — Automatic distillation of Git history
- **Handoff Protocol** — Seamlessly switch between IDE, CLI, and Web Chat
- **Notes (`ai/notes/`)** — Unpolished thoughts, meeting notes, random ideas
- **Artifacts (`ai/artifacts/`)** — Draft outputs, review before promoting to docs/code
- **About Human (`ai/about-human.md`)** — AI learns your skills and preferences
- **Modular Persona** — Quickly shift AI focus (Architect, Mentor) without losing guardrails
- **Project Customization** — `ai/ai-customization.md` for project-specific tailoring with curated traits catalog
- **Compliance Intelligence** — AI-native compliance using built-in knowledge; no on-disk compliance files needed
- **Idiot-Proof Protocol** — Structural guardrails for safe use with lower-capability "lite" models
- **Native Backups** — Automatic cross-platform state archiving during every checkpoint
- **Project Knowledge Sync** — Key findings, decisions, and discoveries are written to `project-knowledge/` at every checkpoint
- **Universal Engineering Standards** — SOLID, DRY, YAGNI, Twelve-Factor App, Trunk-Based Development, SemVer, Conventional Commits
- **Intellectual Rigor** — Architect persona pressure-tests ideas with honest critique; no "yes man" engagement
- **Daily Snapshots** — Automated history of work and decisions
- **Peer Review Mode** — On-demand full-file-set code review with structured, severity-classified reports

---

# Idiot-Proof Protocol (Low-IQ Compatibility)

## The Problem: Instruction Drift
- Lower-capability "lite" models often treat protocols as suggestions
- Can lead to accidental re-initialization or overwriting context files
- "Instruction drift" occurs during complex bootstrap processes

## The Solution: Structural Guardrails
- **Immortality Headers**: High-visibility `⚠️ STOP` header prevents AI from modifying the protocol
- **Immutable Loading**: The context-loading sequence is explicitly flagged as **READ-ONLY**
- **No-Overwrite Mandates**: The context-loading sequence forbids overwriting existing files
- **Recursive Discovery**: AI must `ls -R` the **Global User AI Directory** to find all intelligence
- **Proof-of-Load**: AI must explicitly list every global file read before acknowledgement

> **Safe execution across any IQ tier.** Use lower-cost models without risking project state.

---

# Native Checkpoint Backups

## The Problem: Fragile State
- AI "hallucinations" can sometimes lead to accidental context destruction
- Relying on manual backups is unreliable and slow
- "Dumb" models need a forced safety net

## The Solution: Built-in Archiving
- **Native CLI One-Liners**: Bash (`tar`) and PowerShell (`Compress-Archive`)
- **Automatic Execution**: Runs at every checkpoint; project knowledge is reviewed and updated first
- **Global Storage**: Saved to `~/.ai/backups/` for easy recovery
- **Unique Naming**: `{parent}_{project}_{timestamp}`

> **Zero-Script Reliability.** Your project history is always protected.

---

# On-Demand Peer Review

## How it works
- Say `"peer review"` — the AI switches to an objective reviewer role
- Scans the full file set (not just a diff); saves a structured report to `ai/code-review-reports/`
- Each report is severity-classified: **Critical / Major / Minor / Suggestions**
- Ends with a clear verdict: **APPROVED** or **CHANGES REQUESTED**
- Previous reports are never overwritten; each round gets a new numbered file

## Why multiple rounds are normal
- The AI reviews the **full file set** on every pass — not just the latest diff
- Fixing one issue can make a different pattern visible in the next pass
- Diff-based tools (e.g. GitHub Copilot PR review) see only the new diff on each push, requiring many more rounds to converge
- Expect 2–4 rounds for a thorough review; this is by design

## vs. GitHub Copilot PR Reviewer
- Push branch → wait for review → copy comments out of GitHub → paste into local AI → fix → push again → repeat
- Each push triggers a diff-only review — issues outside the changed lines are invisible
- After 15+ rounds you may still not have a full-codebase verdict
- With this workflow: everything stays in your local chat — no push, no copy-paste, full file set every time

> **Full-file-set review. Every round. No blind spots.**

---
... (rest of slides) ...
