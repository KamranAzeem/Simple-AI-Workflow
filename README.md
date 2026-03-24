# Centralized Policy Management System for smarter AI workflow

- The user will copy the `AGENTS.md` from this repo in the project root of desired directory on local computer.
- Update the policy URL in the `AGENTS.md` to point to the full web URL of the relevant policy that the user wants to use - found under the `ai/` directory in this repo. e.g. `https://raw.githubusercontent.com/KamranAzeem/Smart-AI-Workflow/refs/heads/master/ai/ai-policy-cloud.md`
- The user (or the AI agent) will create a local directory named `ai/` inside the project root, where the policy files (if any), policy-override files (if any), context files, and session tracking files will be created.
- If the user wants to modify certain aspects of the policy, then the user can use a local override file for local adjustments - on the local computer. (e.g `ai/ai-policy-override.md`)
- The `ai/` directory **must** be set to be ignored by `git` in the `.gitignore` file in the project root.

## How to initialize / bootstrap?
* After you have copied the `AGENTS.md` into your project root, Simply run a `/init` in your AI Assistant shell.
* The AI assistant will notice the missing `ai` directory, and the missing files inside it, and will create them automatically.
* Optionally, you can override aspects of policy by adding a `ai/ai-policy-override` file with the policies you want to override. Ask your AI to do this for you, so the AI assistant can correctly write the override policies itself. 
* Set the `ai` directory to be ignored in `gitignore`.

## Why should the `ai/` directory be set to git-ignored? 

* When you are interacting with AI, exchanging ideas, reasoning, etc, that is your personal thought process, and is private to you. The world does not need to see how you think, and may judge you based on it. The world is interested in the program code, or simply the work that you produce.
* Also, when multiple people are working/collaborating on a project, each one of them would have their own ideas reasoning, todo lists, session tracking, etc. If that is committed to the repo, then it would be stepping on each other's toes.
* Also, the AI support files should be isolated in a directory for example `ai` , so there are no unnecessary files mixed in with the actual project files (work) that you are producing.




