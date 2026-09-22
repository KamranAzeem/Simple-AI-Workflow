<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: v3.0.0 released on 2026-09-22 (history purge, issue management, State-File Model v2, bounded boot-time staleness heuristic, and the docs overhaul).
- **Validator**: v5.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); ticket background lives here. `ai/notes/` holds only `notes.md`, the processing preamble
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 23 open, 0 in-progress, 15 closed

## Active Working Context
- **Objective**: maintain the released protocol at `v3.0.0`; the open backlog is 23 tickets under `ai/issues/open/`.
- **Live decisions**: ticket background lives in Project Knowledge until the work is implemented; grilling and brainstorming are separate modes; agent document review is a peer-review dimension, not a separate procedure; policy instructions are concise what-focused text; external-tool dependency is Won't fix; the call-a-friend feature redacts by default and its "help a friend" intake is read-only and isolated; the workflow directory path is set in `ai-customization.md`, not `AGENTS.md`; global user settings is an OS-agnostic template; the full git history was purged of sensitive identifiers and a pre-commit name guardrail lives in the global settings file; no pre-work commits; every protocol or policy change adds an ADR entry. Durable rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: short-hash references recorded in tracked files are stale after the 2026-09-22 history rewrite; the PowerShell sync-script symlink fix is mirrored but untested (no pwsh on this machine).
- **Next actions**: verify a fresh clone on another machine; work the open backlog.
