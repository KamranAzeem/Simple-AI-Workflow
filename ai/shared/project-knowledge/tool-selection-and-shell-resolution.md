> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Tool Selection and Shell Resolution

## Context

- The change is proposed. No protocol file has changed yet.
- The always-on bootstrap router tells the assistant to use shell tools to read protocol files that git ignores.
- The always-loaded common policy has no general rule for choosing a purpose-built tool, the shell, or Python.
- The shell preference in the user settings is read after the first boot commands, so a Windows session can run every command in the wrong shell.
- This unit implements the tool ladder and the git-ignore rewrite. The shell preference is deferred to GitHub #9 and the `Default Shell Interpreter` config work.
- The change is a new unit of work, so the one-unit-per-branch rule applies.

## Built-in Capability Inventory

- File access: read text, images, and PDFs, list directories, stat, open in the editor, show a diff.
- Search: filename glob, content regex with context, symbol search, workspace index, ignore-file aware.
- Edit: exact string replace, full write, multi-file edit, patch apply, notebook cell edit.
- Execution: terminal command, background process, task runner, test runner, build.
- Diagnostics: language server errors and warnings, lint, type check, failed test details.
- Version control: status, diff, log, branch, commit, and pull request in some harnesses.
- Web: fetch a URL, web search, crawl, download.
- External systems: MCP servers for databases, cloud, issue trackers, and ticketing.
- Interaction: ask the user, request approval, present a plan, maintain a todo list.
- Orchestration: subagents, parallel calls, background tasks.
- Memory: recall past sessions and project memory in some harnesses.
- UI and notebooks: open a file, show a diff, open a terminal, run editor commands, view screenshots, edit and run cells.
- Names differ per harness. Map to capability classes, not names.

## What Built-ins Do Better

- They are approval-aware and return structured output.
- They avoid shell quoting, encoding, and space-in-filename bugs.
- They work across platforms and when no shell is exposed.
- They return line numbers and diffs and keep edits reviewable.
- They search fast and respect ignore files.

## Where Built-ins Stop

- They do not run git, validators, directory creation, archives, checksums, or permission changes.
- They cannot handle symlinks, long-running daemons, sandboxed paths outside the workspace, bulk operations, pipelines, or environment control.
- They cannot call a tool the harness does not expose.

## Options Considered

- Rule shapes: a three-rung ladder, an operation map, a session inventory, named exceptions, and a do-no-harm clause. Chosen: the ladder plus the do-no-harm clause; dropped the inventory step.
- Placement: the common policy, a new policy, the bootstrap router, or the customization file. Chosen: the common policy, because the rule applies to every task.
- Git-ignore rule: keep the shell mandate, add an exception clause, or rewrite with a role-based heading. Chosen: rewrite, with no path list.
- Shell preference: customization only, global settings only, or both with a project override. Chosen: customization first, global settings fallback, project override.
- Session inventory: keep or drop. Chosen: drop, because the harness already lists the tools.
- The built-in-first rule and the procedure shell commands are not a conflict. They cover different operations: file content edits versus commands.

## Rule or Fix

### Tool ladder

- Add `## Tool Selection` to the always-loaded common policy, after `## Universal Operational Guardrails`.
- Remove the `Built-in Tools First (File Edits)` bullet. Keep its file-content guard as one ladder bullet.
- Use the tools the harness exposes, and never assume a tool that is not listed.
- Define a purpose-built tool as a harness tool for one operation: read, search, edit, diagnostics, tests, version control, web access, or an external integration.
- Use a purpose-built tool first when it directly performs the operation.
- Use the shell second for a command or a file operation that no purpose-built tool covers, including git, validators, directory creation, archives, permissions, and paths outside the tool's reach.
- Use Python or another runtime third, only when neither can perform the operation, and report why.
- Report every fallback and name the tool used.
- Never use a lower rung to bypass an approval, a protocol rule, or a safety check.
- Never use the shell, Python, or another runtime to write or edit file content when a purpose-built edit tool exists.
- Use shell search when the purpose-built search cannot reach the path.

### Git-ignored protocol files

- Use the heading `Git-Ignored Protocol Files Are Readable`.
- Rule text: "A protocol-owned file or directory is any path this protocol creates, reads, or maintains, and it is readable even when git ignores it. Read it with the built-in file-read tool first. If the harness refuses or hides a git-ignored path, use a shell tool (`cat`, `ls -la`, `find`) and report the fallback. Never refuse to read a protocol file or directory solely because git ignores it."
- Do not enumerate paths. A new protocol-owned file is covered without editing the rule.
- The heading and wording replace the earlier "Surgical Git-Ignore Exception" rule.

### No session inventory

- Do not add a session-start tool inventory.
- One ladder bullet covers the intent: use the tools the harness exposes, and never assume a tool that is not listed.

### Shell preference (deferred)

- Deferred to GitHub #9 and the `Default Shell Interpreter` config work; this unit does not implement it.
- Add `## Runtime Configuration` to the project customization file with `Shell` and `Shell Fallback`.
- Widen the load-context customization step to read the section before the first command.
- Resolve the project value first, then the global settings value, then the default. A project value overrides a global value.
- Use the preferred shell for every command. If the harness started in another shell, invoke the preferred shell explicitly.
- If the preferred shell is unavailable, use the declared fallback and report it. If neither is available, stop and ask before the first command.
- Keep the shell value out of the ladder. The ladder says when to use a tool; the preference says which shell.

## Why

- The git-ignore rule is the only true conflict. It mandates shell reads and blocks a built-in-first rule.
- The file-edit rule is not a conflict. It covers content edits, while procedures call commands.
- The global knowledge lookup is not a conflict. It uses shell search because the built-in search cannot reach the path.
- A purpose-built tool handles quoting, encoding, diffs, and approvals better than a shell command.
- The shell is a user preference, not a project rule. It must be read before the first command.
- A session inventory would add output and no guarantee. The harness already lists its tools.

## Verify

- Add `tests/test-tool-selection.sh`; `tests/run-all.sh` discovers it.
- Assert the bootstrap file contains the new heading, "built-in file-read tool first", "use a shell tool", and "report the fallback".
- Assert the bootstrap file does not contain the old mandatory-shell sentence and does not enumerate the state directory as an exception path.
- Assert the common policy contains `## Tool Selection` and each ladder bullet's anchor.
- Assert the old `Built-in Tools First (File Edits)` bullet is absent.
- Add positive anchors to `support-files/validate-protocol.sh` for the new heading, the first-rung rule, the no-bypass rule, and the shell-search exception.
- Add negative checks to the validator so the old mandatory-shell sentence and the old file-edit bullet fail validation if they return.
- Run markdownlint, shellcheck, both validators, and the full test suite.
- Run the bootstrap-file sync script with a dry run.
- Run peer review and require APPROVED.
- Record the change in the decision store.
- The shell early-read fixture belongs with GitHub #9; this unit adds no shell fixture.

## Caveats

- The shell preference is deferred to GitHub #9 and the config work; this unit is M.
- The branch is new, cut from master.
