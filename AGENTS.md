# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

Read in this order:

1. [ai/ai-policy.md](ai/ai-policy.md) - operating rules and guardrails.
2. [ai/next-steps.md](ai/next-steps.md) - current resume point and live queue.
3. Latest file in [ai/daily-checkpoints/](ai/daily-checkpoints/) - daily recovery snapshot.
4. [ai/progress.md](ai/progress.md) - chronological execution history.
5. [ai/context.md](ai/context.md) - repository briefing and decisions.

[ai/README.md](ai/README.md) is for human understanding only. Do not use it as operational authority.

Conventions:

- Keep this file minimal. Do not store project context or policy details here.
- Keep AI workflow/context artifacts under the [ai/](ai/) directory.
- Keep [ai/](ai/) git-ignored so personal AI state is not committed to git.