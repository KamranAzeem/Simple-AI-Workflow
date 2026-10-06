<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->
# Project Context

## Current Status
- **Milestone**: v4.0.0 released on 2026-10-06 (stable kebab names for procedures/steps/tiers, Global Knowledge JIT indexing, pre-work-commit ban, mandatory ADRs).
- **Validator**: v6.0, 8/8 checks
- **Policy count**: 16 modular policies
- **State files**: `ai/state/` in v2 shape; daily checkpoints under `ai/daily-checkpoints/` are the only archive
- **Project knowledge**: `ai/shared/project-knowledge/` (JIT-indexed; `protocol-decisions.md` is the ADR store); ticket background lives here. `ai/notes/` holds only `notes.md`, the processing preamble
- **Project issues**: `ai/issues/{open,in-progress,closed}/`; 24 open, 0 in-progress, 19 closed

## Active Working Context
- **Objective**: maintain the released protocol at `v4.0.0`; the open backlog is 24 tickets under `ai/issues/open/`.
- **Live decisions**: ticket background lives in Project Knowledge until the work is implemented; grilling and brainstorming are separate modes; agent document review is a peer-review dimension, not a separate procedure; policy instructions are concise what-focused text; external-tool dependency is Won't fix; the call-a-friend feature redacts by default and its "help a friend" intake is read-only and isolated; the workflow directory path is set in `ai-customization.md`, not `AGENTS.md`; global user settings is an OS-agnostic template; the full git history was purged of sensitive identifiers and a pre-commit name guardrail lives in the global settings file; no pre-work commits; every protocol or policy change adds an ADR entry; Global Knowledge is JIT-indexed like Project Knowledge while Global Settings and active policies stay full-load; procedures, steps, and tiers are referenced by stable ALL-CAPS kebab names, never letters or numbers; friendly per-release announcements live in `docs/announcements/` while GitHub Releases stay the authoritative changelog; the writing voice guide lives in the global settings file (always loaded), not global knowledge. Durable rationale in `ai/shared/project-knowledge/protocol-decisions.md`.
- **Findings**: short-hash references recorded in tracked files are stale after the 2026-09-22 history rewrite; the PowerShell sync-script symlink fix is mirrored but untested (no pwsh on this machine).
- **Next actions**: verify a fresh clone on another machine; work the open backlog.
