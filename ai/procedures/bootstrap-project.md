# PROCEDURE BOOTSTRAP-PROJECT: Empty repository

## Triggers

- bootstrap
- bootstrap using agents.md protocol

1. **STEP-ENSURE-DIRECTORIES**: Run PROCEDURE LOAD-CONTEXT, STEP-STRUCTURAL-AUDIT. It audits and idempotently creates the mandatory directories and the issue template.
2. **STEP-CREATE-MISSING-FILES**: Create the **Project Coordination File** if it is missing.
3. **STEP-INITIALIZE-CUSTOMIZATION**: Create `ai-customization.md` at the project root with a `## AI Workflow Configuration` section containing a `**Global AI Workflow Directory**` entry pointing to the workflow repository. See `(Global AI Workflow Directory)/docs/ai-customization.md` for the template.
4. **STEP-INITIALIZE-STATE-FILES**: Create `ai/state/next-steps.md`, `ai/state/progress.md`, and `ai/state/context.md` in the v2 shape (the canonical block for each file copied verbatim from `ai-policy-common.md` (`### Canonical State-File Headers`); progress and next-steps chronological; context a dashboard plus an `## Active Working Context` section), and an initial daily checkpoint with the canonical daily-checkpoint block and the `# Daily Checkpoint YYYY-MM-DD` heading.
5. **STEP-GIT-SETUP**: Ensure `ai/**`, `ai-customization.md`, and `AGENTS.md` are in `.gitignore`.
6. **STEP-AUTHOR-IDENTITY**: Resolve the author identity (project git identity, then global `~/.gitconfig`, then the global settings file). If no global `~/.gitconfig` exists, offer to create one from the common policy template. If the current directory is a git repository with an inadequate config, suggest creating one. If `git` is not available, use the settings fallback and skip the offer. Offer only; never write without approval.
7. **STEP-FINALIZE-BOOTSTRAP**: Proceed to PROCEDURE LOAD-CONTEXT.
