# Centralized Policy Management System for smarter AI workflow

- Copy the `AGENTS.md` file from this repository to the project root of your desired directory
- The `AGENTS.md` file contains a reference to the central policy file at `~/Projects/Personal/Smart-AI-Workflow/ai/ai-policy-cloud.md`
- When an AI assistant reads `AGENTS.md`, it will access the central policy directly from this path
- The AI assistant will create a local `ai/` directory for state tracking files (checkpoints, progress, context)
- For repository-specific policy adjustments, create `ai/ai-policy-override.md` (optional)
- Both `AGENTS.md` and the `ai/` directory should be added to `.gitignore` to keep personal AI state private
- Any AI-related files (e.g., `CONTEXT.md`, `CLAUDE.md`, etc.) should also be gitignored

## How to initialize / bootstrap?
* After copying `AGENTS.md` to your project root, run `/init` in your AI Assistant shell
* The AI assistant will follow the bootstrap procedure in `AGENTS.md`:
  - Create `ai/` directory with `daily-checkpoints/` subdirectory
  - Initialize state tracking files (`next-steps.md`, daily checkpoint, `progress.md`)
  - Add `ai/` and `AGENTS.md` to `.gitignore`
* The central policy is accessed directly - no local copying of policy files
* For custom policy adjustments, create `ai/ai-policy-override.md`

## Why should the `ai/` directory be set to be ignored in the `.gitignore` file? 

* When you are interacting with AI, exchanging ideas, reasoning, etc, that is your personal thought process, and is private to you. The world does not need to see how you think, and may judge you based on it. The world is interested in the program code, or simply the work that you produce.
* Also, when multiple people are working/collaborating on a project, each one of them would have their own ideas reasoning, todo lists, session tracking, etc. If that is committed to the repo, then it would be stepping on each other's toes.
* Also, the AI support files should be isolated in a directory for example `ai/` , so there are no unnecessary files mixed in with the actual project files (work) that you are producing.




