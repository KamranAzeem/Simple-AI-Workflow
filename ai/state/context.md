<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: State-File Model v2 on branch `feature/state-file-model-v2` (uncommitted, awaiting user review)
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); `ai/notes/` holds working notes
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 2 open, 0 in-progress, 4 closed

## Active Working Context
- **Objective**: State-File Model v2 implemented on `feature/state-file-model-v2`; stopped for user review before commit.
- **Live decisions**: no git metadata in state files; daily checkpoints are the only archive; 20 KB total budget (context 8 KB, progress 7 KB, next-steps 5 KB); 14-day window; no checkpoint IDs; read-only detection at load and repair only via `repair state files`; local-first source precedence. Rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: 59 archived checkpoints migrated into the diary with no loss; validator v5.0.
- **Next actions**: run validator and markdownlint; peer review the implementation; documentation last (README, slides, workflow guide); stop for approval.
