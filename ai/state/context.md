<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: State-File Model v2 shipped to master on 2026-09-19 (state files describe work only, daily checkpoints are the archive, Procedure I ships)
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); `ai/notes/` holds working notes
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 2 open, 0 in-progress, 4 closed

## Active Working Context
- **Objective**: none active. State-File Model v2 is shipped; take the next item from `ai/state/next-steps.md`.
- **Live decisions**: none open beyond the shipped state-file model; durable rationale is in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: none pending.
- **Next actions**: none.
