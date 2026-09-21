<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: README overhaul merged to `master` on 2026-09-22 (`ac516b3`); release `v2.4.0` is on hold pending the bounded boot-time staleness heuristic (the local-first leftover).
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); ticket background lives here. `ai/notes/` holds only `notes.md`, the processing preamble
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 13 closed

## Active Working Context
- **Objective**: implement the bounded boot-time staleness heuristic (`ai/issues/open/bounded-boot-time-staleness-heuristic.md`), then release `v2.4.0` (tag plus GitHub release). The README overhaul branch is merged and deleted.
- **Live decisions**: ticket background lives in Project Knowledge until the work is implemented; grilling and brainstorming are separate modes; agent document review is a peer-review dimension, not a separate procedure; policy instructions are concise what-focused text; external-tool dependency is Won't fix; the call-a-friend feature redacts by default and its "help a friend" intake is read-only and isolated; the workflow directory path is set in `ai-customization.md`, not `AGENTS.md`; global user settings is an OS-agnostic template; the full git history was purged of sensitive identifiers and a pre-commit name guardrail lives in the global settings file. Durable rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: short-hash references recorded in tracked files are stale after the 2026-09-22 history rewrite; the PowerShell sync-script symlink fix is mirrored but untested (no pwsh on this machine).
- **Next actions**: implement the staleness heuristic; then tag `v2.4.0` and write the GitHub release notes; verify a fresh clone on another machine.
