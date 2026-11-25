> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Global Vocabulary and Storage Roots

## Context

The protocol uses "global" for two different owners. The owners, the trap, and the decision not to add a third global root belong together.

## Rule or Fix

### The owners

- Workflow-owned: the clone. The workflow directory, policy directory, skills directory, and procedure store. These travel with `git pull`.
- User-owned: the global user directory, default `~/.ai`. Settings, global knowledge, and backups. These are not in the clone.
- Project-owned: the project root and its `ai/` tree. The customization, project policies and skills, knowledge, state, and checkpoints.
- Team-owned: the configured team knowledge directory. Team lessons and team skills, shared with the team and reviewed through the team repository.

### The trap

"Global" means "not project-local" in both workflow-owned and user-owned names, but the owner and the update path differ. A new user-global root next to the clone's global skills would make the word carry a third storage meaning.

### The decision

- Do not add a user-skills root under the global user directory as "user-global skills". The skills model has three roots when the team store is configured: project, team, and global; the team root is shared, not personal.
- If personal cross-project skills are needed, name them "user skills" and decide their precedence separately; the current order is project, team, global.

## Why

- The owner and the update path differ even when both names say "global".
- A third storage meaning makes the word ambiguous in policies and docs.
- A separate personal skills root needs its own precedence decision.

## Verify

- When a feature uses "global", name the owner and the root.
- When a skill root is outside the clone and the project, name the team scope.
- A name that needs "user-global" is a sign that the vocabulary is being stretched.

## Caveats

- A broad rename to workflow, user, and project is a separate unit; do not bundle it into a feature.
- The current skill order is project, team, global; a personal root would need a new decision.
