<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: Self-consistency check shipped to master on 2026-09-19; State-File Model v2 shipped earlier the same day
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); `ai/notes/` holds working notes
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 0 open, 0 in-progress, 6 closed

## Active Working Context
- **Objective**: none active. Self-consistency check is shipped; take the next item from `ai/state/next-steps.md`.
- **Live decisions**: none open; durable rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: none pending.
- **Next actions**: none.
