> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Tool Selection and Shell Resolution

## Context

- The tool ladder and the git-ignore readability rule landed in v6.7.0.
- The shell preference and the configurable global user directory landed in v6.8.0; GitHub #9 is closed as absorbed.
- The runtime file-operation rule became unconditional in v6.9.1: Python or another runtime never searches, creates, appends to, or edits a file; the built-in tool is required.
- v6.10.0 removed the load-context shell mandates: every read, search, and listing uses a built-in tool; one read-only helper and a best-effort fallback remain.
- A policy rule alone did not stop a runtime file write; the harness permission is the hard stop.

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
- The built-in-first rule and the boot shell mandates conflicted; v6.10.0 removed the mandates, kept one read-only helper, and made the fallback best-effort.

## Rule or Fix

### Tool ladder

- Use the tools the harness exposes, never a tool it does not list.
- Use a purpose-built harness tool for one operation (read, search, glob, edit, diagnostics, tests, version control, web access, external integration) before any other rung.
- Use the shell second only for a system operation on the host: git, a helper or validator, directory creation, archives, permissions, metadata reads, and a global listing or search the built-in tools cannot reach.
- Never use the shell to read, search, list, or edit a file a built-in tool can reach, except the helper launch, the global listing and search, the backup archive, the reported Git-Ignored Protocol Files Are Readable fallback, and the metadata step's byte and age reads.
- Never use Python or another runtime to read, search, create, append to, or edit a file; use the built-in tool.
- Use a runtime for computation only when neither a built-in tool nor the shell performs it.
- Run one job per shell call and report each fallback at that call, naming the tool and the reason.
- Never use a lower rung to bypass an approval, a rule, or a safety check.
- Use shell search only when the built-in search cannot reach the path.

### Git-ignored protocol files

- Use the heading `Git-Ignored Protocol Files Are Readable`.
- Rule text: "A protocol-owned file or directory is any path this protocol creates, reads, or maintains, and it is readable even when git ignores it. Read it with the built-in file-read tool first. If the harness refuses or hides a git-ignored path, use a shell tool (`cat`, `ls -la`, `find`) and report the fallback. Never refuse to read a protocol file or directory solely because git ignores it."
- Do not enumerate paths. A new protocol-owned file is covered without editing the rule.
- The heading and wording replace the earlier "Surgical Git-Ignore Exception" rule.

### No session inventory

- Do not add a session-start tool inventory.
- One ladder bullet covers the intent: use the tools the harness exposes, and never assume a tool that is not listed.

### Shell preference

- `Default Shell` in the customization names the shell; `Default Shell Path` in the global settings carries the native path.
- The boot reads the customization first, then the whole settings directory, then the first named command.
- The path wins over the name; a mismatch or a missing shell is reported, and the boot continues with built-ins. Absent keys keep the current behavior.
- The read-only index helper runs with `bash` regardless of `Default Shell`.
- GitHub #9 is closed as absorbed.

## Why

- The old boot's shell mandates were the conflict; v6.10.0 replaced them with built-in reads and the helper.
- The file-edit rule covers content edits; the helper and the named commands are the named exceptions.
- The global knowledge lookup uses the built-in search when it can reach the path; the runner form is the ladder bullet 9 exception.
- A purpose-built tool handles quoting, encoding, diffs, and approvals better than a shell command.
- The shell is a user preference, not a project rule. It must be read before the first command.
- A session inventory would add output and no guarantee. The harness already lists its tools.
- A policy rule is not enforcement. The harness permission prompt is the hard stop; the policy states the rule.

## Verify

- `tests/test-tool-selection.sh` pins the precedence section, the nine-bullet ladder, the helper path, the removed old rules, and the validator anchors.
- `tests/test-protocol-index.sh` pins the helper, the dev output, the same-name shadowing pair, the trigger conflict, the first boot, and the canaries.
- `tests/test-load-context-boot.sh` pins the procedure contract, the helper, the canaries, and the dev index.
- `tests/test-config-resolution.sh` pins the optional shell and the report-and-continue path.
- Run markdownlint, shellcheck, both validators, and the full suite.

## Caveats

- The policy states the rule; the harness permission enforces it. The permission config is user-controlled.

## Resolution (v6.10.0)

- The boot uses built-in tools for every read, search, and listing; the only commands are the version check, directory creation, the read-only index helper, the POSIX metadata step, the global listing and search, the backup archive, and the git-ignore fallback.
- The helper calls the read-only `--index` mode and sets `effective` and `conflict`; the fallback is best-effort and reports `index-source=fallback`.
- Precedence is the always-on safety rules, then the user, then `AGENTS.md` and the common policy, then the customization, then domain policies, then procedure steps.
- The `Default Shell` key is optional; a missing shell or path is reported, and the boot continues with built-ins.
