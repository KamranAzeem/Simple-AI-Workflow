> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Global Vocabulary and Storage Roots

The protocol uses "global" for two different owners. This file records the split and the decision not to add a third global root.

## The three owners

- Workflow-owned: the clone. `Global AI Workflow Directory`, `Global AI Policies Directory`, `Global AI Skills Directory`, and the procedure store. These travel with `git pull`.
- User-owned: `(Global User AI Directory)`, default `~/.ai`. Settings, global knowledge, and backups. These are the user's own and are not in the clone.
- Project-owned: the project root and its `ai/` tree. The customization file, project policies and skills, knowledge, state, and checkpoints.

## The trap

"Global" means "not project-local" in both workflow-owned and user-owned names, but the owner and the update path differ. A new "user-global" root next to the clone's global skills would make the word carry a third storage meaning.

## The decision

- Do not add `(Global User AI Directory)/skills/` as "user-global skills". The skills model stays at two roots: the clone's global skills and the project's skills.
- If personal cross-project skills are needed later, name them "user skills" at `~/.ai/skills/`, with the precedence project, then user, then workflow.
- A broad rename to workflow/user/project is a separate unit. Do not bundle it into a feature.

## Checks

- When a feature uses "global", name the owner and the root.
- A name that needs "user-global" is a sign that the vocabulary is being stretched.
