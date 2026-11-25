> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Scope Vocabulary and Storage Roots

## Context

The protocol has four scopes: Workflow, User, Team, and Project. Each scope has one owner, one storage root, and one update path. The word "global" is retired as a scope label because it described the workflow clone and the user directory at the same time.

## Rule or Fix

### The four scopes

- **Workflow**: the clone. It holds `ai/policies/`, `ai/procedures/`, and `ai/skills/`. It has no knowledge store and no settings store.
- **User**: the configured user directory, default `~/.ai`. It holds `knowledge/`, `skills/`, `settings/`, and `backups/`. The user may place it under the home directory or on a network path.
- **Team**: the configured team repository. It holds `knowledge/` and `skills/`. The team owns its repository name and hosting.
- **Project**: the project root. It holds `ai/knowledge/`, `ai/policies/`, `ai/skills/`, `ai/state/`, and `ai/shared/` for coordination and handoffs.

### Keys

- Workflow keys: `Workflow AI Directory`, `Workflow AI Policies Directory`, `Workflow AI Skills Directory`.
- User keys: `User AI Directory`, `User AI Knowledge Directory`, `User AI Skills Directory`, `User AI Settings Directory`, `User AI Backups Directory`.
- Team keys: `Team AI Directory`, `Team AI Knowledge Directory`, `Team AI Skills Directory`, `Team AI Knowledge Repository`.
- Project keys: `Project AI Knowledge Directory` (`ai/knowledge/`), `Project AI Policies Directory`, `Project AI Skills Directory`.

### Precedence

- Knowledge: project, then team, then user.
- Skills: project, then team, then user, then workflow.

### Exceptions

- Git's own global configuration (`~/.gitconfig`, `git config --global`) keeps the word "global" because it is the tool's term.
- Generic English such as "global search" or "global variable" keeps the word.
- Historical records, closed tickets, old checkpoints, and old ADR entries keep their original vocabulary.
- The previous trigger phrases remain as v7.7.x aliases and are removed in v7.8.0.

### The storage boundary

- `ai/shared/` keeps `coordination.md` and `handoffs/`. It is not a knowledge store.
- `ai/knowledge/` is the project's own knowledge, not a workflow store.
- The user repair backup directories, `knowledge-repair-backups/` and `settings-repair-backups/`, stay top-level and are exceptions to the four-store rule.

## Why

- One owner per scope removes the ambiguity that made the policy tree and the settings store point at different owners.
- Unprefixed directory names make the owner and the location carry the scope.
- The precedence order follows authority: the project is authoritative for its own context, the team store is curated and shared, and the user store is the portable fallback.

## Verify

- Read a scope name and name its owner and root.
- Confirm the active knowledge root is `ai/knowledge/`, the user root is `knowledge/`, and the team root is `knowledge/`.
- Confirm the user area has `knowledge/`, `skills/`, `settings/`, and `backups/`.
- Run `bash support-files/validate-protocol.sh`; it checks the keys and the mandatory directories.

## Caveats

- A legacy layout is read-only at boot and warns; only the sync script moves files.
- The old keys and paths are removed by the sync migration. There is no key alias window.
- The two repair backup directories are intentional exceptions and are not part of the four-store layout.
