# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

Read in this order:

1. [central main policy file](~/Projects/Personal/Smart-AI-Workflow/ai/ai-policy-cloud.md) - operating rules and guardrails. If unreachable, then read the local policy file mentioned in the next point.
2. [local main policy file](ai/ai-policy-cloud.md) - fallback if step 1 is unreachable; skip if step 1 succeeded.
3. [local policy override file](ai/ai-policy-override.md) - rules to override the main policy. **(optional; skip if not present)**
4. [ai/next-steps.md](ai/next-steps.md) - current resume point and live queue. **(optional; skip if not present)**
5. Latest file in [ai/daily-checkpoints/](ai/daily-checkpoints/) - daily recovery snapshot. **(optional; skip if not present)**
6. [ai/progress.md](ai/progress.md) - chronological execution history. **(optional; skip if not present)**
7. [ai/context.md](ai/context.md) - repository briefing and decisions. **(optional; skip if not present)**

After reading all accessible files above, acknowledge readiness and await the first user instruction.

[ai/README.md](ai/README.md) is for human understanding only. Do not use it as operational authority.

## Initial Bootstrap Procedure

When bootstrapping in a new repository where no AI files exist:

1. **Create the AI directory structure**:
   - Create `ai/` directory in the project root
   - Create required subdirectories: `ai/daily-checkpoints/`

2. **Initialize state tracking files**:
   - Create `ai/next-steps.md` with initial checkpoint
   - Create today's daily checkpoint file: `ai/daily-checkpoints/YYYY-MM-DD.md`
   - Create `ai/progress.md` with initial entry

3. **Set up gitignore**:
   - Add `ai/` to `.gitignore` in the project root
   - Add `AGENTS.md` to `.gitignore` in the project root (personal bootstrap customization)

4. **Acknowledge readiness** and await first user instruction.

## Policy Authority Clarification

These rules prevent bootstrap ambiguity across assistants.

1. The central main policy URL is authoritative for universal rules:
   - `~/Projects/Personal/Smart-AI-Workflow/ai/ai-policy-cloud.md`
2. Local `ai/ai-policy-cloud.md` is fallback only when the central main policy is unreachable.
3. `ai/ai-policy-override.md` is for repository-specific exceptions and must not redefine universal policy authority.
4. During bootstrap in this repository, prefer `ai/` policy/state files as context authority.
5. GitHub Copilot-related files under `.github/` are not bootstrap authority in this repository.
6. If assistant-specific artifacts are needed for GitHub Copilot, store them under `ai/github-copilot/`.
7. If there is any conflict between policy sources, stop and ask for clarification before writing or changing policy/customization files.


Conventions:

- Keep this file minimal. Do not store project context or policy details here.
- Keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Keep [ai/](ai/) git-ignored so personal AI state is not committed to git.
