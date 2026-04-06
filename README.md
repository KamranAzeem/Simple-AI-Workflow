# Centralized Policy Management System for Simple AI Workflow

- Clone this repository at a central location in your home directory, and make a note of that location.
- Copy `AGENTS.md` from this repository into the root of the target project on your local computer.
- The `AGENTS.md` file (now in your project root directory) points to the central policy file-path used by this workflow. Update that path based on where you cloned this repository. (e.g. `/home/username/Projects/Personal/Simple-AI-Workflow/ai/ai-policy-cloud.md`). Make sure to follow the OS specific way of writing the path. 
- When an AI assistant reads `AGENTS.md`, it will access the central policy directly from that path.
- Available example policy files in this repository: `ai/ai-policy-cloud.md`, `ai/ai-policy-frontend-web.md`, `ai/ai-policy-backend-api.md`, etc.
- The AI assistant will create a local `ai/` directory in your project root directory for state tracking files such as checkpoints, progress, and context.
- For repository-specific policy adjustments, create `ai/ai-policy-override.md`.
- Both `AGENTS.md` and the `ai/` directory should be ignored by Git to keep personal AI state private.
- See `gitignore-example.txt` for entries that keep local AI workflow files out of the repository. Add them to the project's `.gitignore` file.

## Which policy should you choose?

- Use `ai-policy-cloud.md` when the project is mostly infrastructure, cloud automation, deployment, platform operations, or mixed cloud workflows.
- Use `ai-policy-frontend-web.md` when the project is mainly focused on frontend web applications, UI work, accessibility, design systems, and user-facing flows.
- Use `ai-policy-backend-api.md` when the project is mainly focused on backend services, APIs, data handling, jobs, workers, and operational correctness.
- Use `ai-policy-linux-system-admin.md` when the project is mainly focused on Linux system administration and SRE tasks.
- If the project spans multiple areas, start with the policy that matches the highest-risk work, then add a local override file for project-specific rules.

## How to initialize / bootstrap?

- After copying `AGENTS.md` into your project root, run `/init` in your AI assistant shell to build the context.
- If your AI assistant does not support `/init`, use this instruction:
  - `bootstrap using AGENTS.md protocol`
- The AI assistant should follow the bootstrap procedure in `AGENTS.md`:
  - Create the `ai/` directory with the `daily-checkpoints/` subdirectory.
  - Initialize the state tracking files such as `next-steps.md`, the daily checkpoint, and `progress.md`.
  - Add `ai/` and `AGENTS.md` to `.gitignore`.
- The central policy is accessed directly from the path referenced in `AGENTS.md`, so local copying of policy files is not required.
- Optionally, you can override parts of the policy by adding `ai/ai-policy-override.md`. You can ask the AI assistant to generate this file for you.
- Ensure the `ai/` directory is ignored in `.gitignore`.
- You can use `gitignore-example.txt` as a guide when adding AI-related ignore rules.

## Why should the `ai/` directory be ignored in `.gitignore`?

- When you interact with AI, the prompts, reasoning, notes, and session state are part of your private thinking/working process. Those do not belong in the repository.
- In team environments, each person may have different notes, reasoning, task lists, and session state. Committing those files would create noise and unnecessary conflicts.
- Keeping AI support files in a dedicated `ai/` directory helps keep local workflow files separate from the real project related files and directories.
- While interacting with AI assistant, the user may accidentally leak sensitive information to the AI Assistant, such as name of the client, or any other client-related sensitive information about their infrastructure, application design, weaknesses in the system, etc. These are part of normal interaction with the AI assistant during thinking and planning sessions. These must never be part of the repository though.


## Checkpoint System

The AI workflow includes a checkpoint system (or journal system) for tracking progress and maintaining state consistency. Checkpoints are automatically created during significant workflow activities or when requested by the user using instructions such as **"perform checkpoint"** or simply **"checkpoint"**. 

Though the checkpoint system exists primarily to help AI assistant(s) keep track of progress, next-steps, open questions, etc., the user can also read these files to get an idea of what is going on. These are simple markdown files with easy-to-understand content. 

### Checkpoint Features:
- **Automatic Creation**: Checkpoints are created during significant workflow activities or when AI state tracking files change
- **Consistency Verification**: Each checkpoint verifies that all AI tracking files are synchronized
- **Daily Snapshots**: Daily checkpoint files are stored in `ai/daily-checkpoints/YYYY-MM-DD.md`
- **Progress Tracking**: The `ai/progress.md` file maintains a chronological log of all checkpoints
- **Resume Points**: The `ai/next-steps.md` file provides the current resume point for AI assistants

### Checkpoint Format:
Checkpoints follow the format `CP-YYYY-MM-DD-XX` where:
- `YYYY-MM-DD`: Date of the checkpoint
- `XX`: Sequential number for multiple checkpoints on the same day

### Usage:
- AI assistants automatically create checkpoints during significant workflow activities
- Users can request checkpoints at any time for state preservation
- Checkpoints ensure AI assistants can resume work from a known consistent state

## CLI Tools Used by AI Assistants

These OS CLI tools can be used from inside VS Code chat or directly on the command line. They are useful to have on the local computer. They do not need admin rights, and you can place them in your `~/bin/` directory.

These tools are available for Linux, macOS, and Windows. Set them up according to your OS.

- `git`
- `gh` (Github CLI)
- `rg` (ripgrep) — `15.1.0`
- `jq` — `1.8.1`
- `fd` — `10.4.2`
- `bat` — `0.26.1`
- `delta` — `0.19.2`
- `fzf` — `0.70.0`
- `tldr` — `3.5.0`

### Notes
- `tldr` may print dotenv tips; silence with:
  - `DOTENV_CONFIG_QUIET=true tldr --version`

