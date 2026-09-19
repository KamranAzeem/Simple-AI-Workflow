<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: Agent-facing documentation dimension added to peer review on 2026-09-19; the full backlog moved into issue tickets the same day
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); ticket background lives here. `ai/notes/` holds only `notes.md`, the processing preamble
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 18 open, 0 in-progress, 10 closed

## Active Working Context
- **Objective**: none active. The backlog is the open issues; take the next item from `ai/issues/open/`.
- **Live decisions**: ticket background lives in Project Knowledge until the work is implemented; grilling and brainstorming are separate modes; agent document review is a peer-review dimension, not a separate procedure; policy instructions are concise what-focused text; external-tool dependency is Won't fix. Durable rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: none pending.
- **Next actions**: none required; review the open tickets when ready.
