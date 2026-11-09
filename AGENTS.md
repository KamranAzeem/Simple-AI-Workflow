<!-- START_IMMUTABLE_PROTOCOL -->
<!-- 
  ========================================================================
  ⚠️ STOP: READ-ONLY PROTOCOL - DO NOT MODIFY OR REGENERATE THIS FILE ⚠️
  ========================================================================
  1. THIS IS A PROTOCOL FILE, NOT A CONTEXT STORAGE FILE.
  2. AI ASSISTANTS ARE STRICTLY PROHIBITED FROM MODIFYING THIS FILE.
  3. ALL MODIFICATIONS MUST BE PERFORMED MANUALLY BY THE HUMAN USER.
  4. EXCEPTION: IN PROTOCOL DEVELOPER MODE (WORKING INSIDE THE SIMPLE-AI-WORKFLOW REPO), THE AI MAINTAINER MAY EDIT PROTOCOL FILES AFTER LOADING protocol-decisions.md AND WITH HUMAN APPROVAL BEFORE COMMITTING.
  ========================================================================
-->

> **Protocol file. Not a context storage file.** This file tells AI assistants how to work and where the context lives. AI assistants must follow it as a protocol, not as project context, and must not modify it.

# AI Bootstrap Entry Point

This is the single startup entry point for all AI assistants in this repository.

## TIER CONFIGURATION

**Path Normalization & Inference Rules**:

- **[HOME] Resolution**: AI MUST resolve `[HOME]` to the absolute home directory of the current user (e.g., `/home/username` on Linux, `/c/Users/username` on Gitbash, `C:\Users\username` on Windows CMD or PowerShell ).
- **Dynamic Paths**: All paths below are derived from **Global AI Workflow Directory** (resolved at boot from **Project Customization File**) and **Global User AI Directory**. AI MUST concatenate the Base Directory with the relative path to form absolute paths.
- **Policy Path Resolution**: A policy file named without a directory resolves from the **Global AI Policies Directory**.
- **Project Policy Directory**: Read from the **Project AI Policies Directory** only when the instruction names that directory or names a user custom policy.

<!-- Human user must not touch/modify the lines below -->

**Global AI Workflow Directory**: resolved from **Project Customization File** at boot
**Global User AI Directory**: `[HOME]/.ai/`
**Global AI Policies Directory**: (Global AI Workflow Directory)/ai/policies/
**Global AI Knowledge Directory**: (Global User AI Directory)/global-knowledge/
**Global AI Backups Directory**: (Global User AI Directory)/backups/
**Global AI Settings Directory**: (Global User AI Directory)/settings/
**Global AI Skills Directory**: (Global AI Workflow Directory)/ai/skills/
**Project AI Skills Directory**: `ai/skills/`

**Project Artifacts Directory**: `ai/artifacts/`
**Project Code Review Reports Directory**: `ai/code-review-reports/`
**Project Compliance Policies Directory**: `ai/policies/compliance/`
**Project Coordination File**: `ai/shared/coordination.md`
**Project Customization File**: `ai-customization.md`
**Project Daily Checkpoints Directory**: `ai/daily-checkpoints/`
**Project Handoffs Directory**: `ai/shared/handoffs/`
**Project Issues Directory**: `ai/issues/`
**Project AI Knowledge Directory**: `ai/shared/project-knowledge/`
**Project Notes Directory**: `ai/notes/`
**Project Pending Directory**: `ai/pending/`
**Project Plans Directory**: `ai/plans/`
**Project AI Policies Directory**: `ai/policies/`
**Project Secrets Directory**: `ai/secrets/`
**Project Shared Directory**: `ai/shared/`
**Project AI State Files**: `ai/state/`

### Canonical Names & Short Forms

The following short forms are recognized as equivalents to their canonical directives:

- "Global Knowledge" ↔ **Global AI Knowledge Directory**
- "Project Knowledge" ↔ **Project AI Knowledge Directory**

---

## TIER READ-FIRST-RULES

### 🛑 PROHIBITED ACTIONS

- **Self-Modification**: **STRICTLY PROHIBITED** in ordinary projects. Do not rewrite, regenerate, or edit this file. **Exception**: in **Protocol Developer Mode** (see MANDATORY ACTIONS), when the current working directory is the **Global AI Workflow Directory**, the AI is the protocol maintainer and may edit `AGENTS.md` and other protocol files, but only after fully loading `protocol-decisions.md` and with explicit human approval before committing.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `logs/`, `tmp/`) unless explicitly directed by a specific task. Indexing directories named `design-docs` by name is the one standing exception.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.copilot`, `.gemini/`, `.claude/`, etc.). All AI state must live in `ai/`.
- **PWD-Only Scope**: Strictly load `AGENTS.md` and scan the `ai/` directory from the **current working directory (PWD) only**. Honor `AGENTS.md` and `ai-customization.md` only from the project root: do not scan subdirectories for additional `AGENTS.md` files, and do not read or load any `AGENTS.md` or `ai-customization.md` file from any other location in the directory tree. If `AGENTS.md` is not found in PWD, report it missing and stop. Do not read another assistant's files such as `CLAUDE.md`.

### ✅ MANDATORY ACTIONS

- **OS-Sensitive Execution**: Identify the active OS, shell, and default terminal. State the outcome, constraints, and expected output before choosing a command form. Use the reference form or an equivalent standard tool, report the command used and any deviation, and stop and report when no compliant tool exists. Never install tools to satisfy a boot step.
- **Surgical Git-Ignore Exception**: `AGENTS.md` and the entire `ai/` directory (including ALL subdirectories and every file within them) are git-ignored by design. **Git-ignored does NOT mean forbidden.** You MUST use shell tools (`cat`, `ls -la`, `find`) to read and list their contents, and add their contents to active context where permitted. Never refuse to read a file or directory solely because it is git-ignored.
- **Full File Reads (No Partial Reads)**: Read every file you reason about in full, line 1 to EOF, re-reading from disk when a task needs it again. This holds at boot, at load context, at Post-Compaction Recovery, and mid-work. The only exception is log-like bulk data you are searching rather than comprehending (logs, dumps, large JSON or CSV), which you may slice by filter. Never truncate investigation command output with `head`, `tail`, or `-N` limits, since truncated output is fabricated evidence. When a read drives a decision or change, state the file and its line count so the read is auditable. (Evidence-Based Investigation)
- **Evidence-Based Investigation**: Investigate before you assert. No claim without a source; no assumptions or guesses. If you cannot verify, write "not verified" and ask. Wide-scope the subject read-only over its cone of influence. See the Investigation Contract in `ai-policy-common.md`.
- **Context Protection**: Treat **Project AI State Files** as read-only during bootstrap and context loading. During **PROCEDURE POST-COMPACTION-RECOVERY**, these files must not be read at all.
- **State File Single-Writer Ownership**: **Project AI State Files** are the canonical project narrative and are written by the **project-root orchestrator only**: the single AI session that owns this project root. **Ownership is by session/process identity, not by role**: if that one owning session changes hats mid-session (e.g. manager → developer → document-controller), it is still the orchestrator and still writes the state files normally: switching roles does not create a second writer. The prohibition targets **separate** agents that run as their own session/process: sub-agents and role-based team members (developer, security, document-controller, etc.) that are **not** the owning session, whether long-running or spawned per handoff, **MUST NOT write Project AI State Files**. They obtain awareness by **reading** the coordination board, and they report their own work by updating the **Project Coordination File**, their handoff file, and role-scoped **Project Knowledge** files (single-writer per role). The orchestrator folds those reports into the state files at checkpoint (PROCEDURE WRITE-CHECKPOINT). This keeps the canonical narrative single-writer and free of multi-agent write contention. Awareness = read the board; canonical narrative = orchestrator writes.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.
- **Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory** (TIER CONFIGURATION), you are operating as a protocol developer on this repository itself. This is the sanctioned exception to the Self-Modification prohibition in PROHIBITED ACTIONS: here you maintain these files, not merely read them. Before making any change to any protocol file (`AGENTS.md`, policy files, `validate-protocol.sh`, or any file under `ai/`), you MUST fully load `protocol-decisions.md` from `(Global AI Workflow Directory)/design-docs/`: it records authoritative past decisions and must not be treated as JIT-optional. All paths and file references written into policy files must be authored from the **end-user's project root perspective** (the directory where the user has their own project), not from this repository's internal directory structure. See the "No markdown hyperlinks in policy files" entry in `protocol-decisions.md` for the full rule. **Policy loading**: during context loading and post-compaction recovery, load ONLY `ai-policy-common.md` plus the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. Do NOT scan and load all files from the **Project AI Policies Directory**: that directory is the protocol's full distribution tree, not your working policy set.
- **Session Resume (Compacted Context)**: When a session begins from a compacted conversation summary, or the conversation is compacted mid-session, AI MUST run **PROCEDURE POST-COMPACTION-RECOVERY** before responding to the user's first request. Concrete signals: the literal text "Compacted conversation" in the transcript; a `<conversation-summary>` XML block in the active context; or the session opening with a machine-generated multi-section summary the AI did not write.
- **Git Workspace Detection**: Before offering git operations on the project root, scan for `.git` subdirectories within the project tree (excluding `ai/`). If any `.git` directory is found, the root is part of a larger git workspace, do not treat it as a git repo itself. Do not offer `git init`, run `git log` on the project root, or propose git operations that assume the project root is independently tracked. Users may also define explicit workspace rules in the **Project Customization File**.
- **Archive File Exclusion**: All `find` and `ls` commands in this protocol must exclude compressed and archive files. Use `! -name '*.tar*' ! -name '*.zip'` with `find`, or filter with `grep -v '\.tar\|\.zip'` when piping `ls` output.
- **Backup Directory Exclusion**: Never scan, list, read, or reference files inside the **Global AI Backups Directory** (`~/.ai/backups/`). Backups are user-space artifacts and are not part of the active project state.

### Boot Scan Exclusions

- **Boot Scan Exclusions**: Exclude these paths from every boot scan, index, and proof, in listing and reading.
- Exclude the **Project Secrets Directory**.
- Exclude the **Project Artifacts Directory**.
- Exclude the **Project Code Review Reports Directory**.
- Exclude the **Project Notes Directory**.
- Exclude the **Project Pending Directory**.
- Exclude the **Project Plans Directory**.
- Exclude `ai/issues/closed/`.
- Exclude every `.git/` directory.
- Exclude archives.
- Exclude the **Global AI Backups Directory**.
- Never list the **Project Secrets Directory** or the **Global AI Backups Directory**.
- Treat an excluded path as out of bounds.

---

## Shared Protocol Steps

- **STEP-PROTOCOL-INDEX**: Rebuild the module index from the live files and record it in working context.
  - Index the **Global AI Policies Directory** and the **Project AI Policies Directory**, recursively and including `compliance/`, plus the procedure source.
  - In Protocol Developer Mode, index the distribution tree metadata as usual; the mode limits body loading, not indexing.
  - The procedure source is every module file under `(Global AI Workflow Directory)/ai/procedures/`.
  - Resolve both policy paths first; when they are the same path, index it once as global; otherwise mark the project entries as project.
  - A project policy with the same name as a global policy replaces it; mark the global entry shadowed and keep its triggers reserved.
  - Skip hidden entries, `tmp`, archives, and symlinks that escape the directory.
  - Record type, scope, name, source relative to its anchor, literal and normalized triggers, headings with levels, effective, and conflict; never a policy rule or a procedure step.
  - Normalize a phrase to lowercase, replace every character outside `[a-z0-9]` with a space, collapse spaces, and trim; the only placeholder is a trailing `#N` in a procedure trigger, which matches an optional `#` and one or more digits.
  - A policy without triggers has an empty trigger set. The index creates no directory.
  - Report counts by type and scope, the trigger count, the conflict count, and errors by class. The proof-of-load reports them; recovery and checkpoint re-affirmation rebuild silently.
  - Permit only read operations; write no file and create no cache. Rebuild before dispatch when a module file changed in the session.
  - Use the fixed error vocabulary: `invalid trigger block`, `empty trigger block`, `duplicate trigger`, `trigger overlap`, `missing triggers`, `name mismatch`, `invalid policy shape`, `unreadable module`, `trigger collision`, and `unknown policy`.

- **STEP-SKILLS-INDEX**: Build an ephemeral name, description, path, and scope index from both skill roots; read no body and write no file.
  - One level: a `SKILL.md` package; `name` and a one-line `description` of at most 200 characters; lowercase-kebab directory matches `name`; skip and report a hidden entry, symlink, invalid package, or empty root.
  - A project skill replaces a global skill; report the override and a cross-type name collision; keep the index within 16 KB.

## Protocol Dispatch

- Resolve a user message against the module index.
- A phrase maps to one module. A phrase declared by two different modules is invalid; a phrase contained in another module's phrase is invalid. Close variants within one module are allowed and deduplicated.
- Match whole words after normalization; case, whitespace, hyphens, and punctuation do not matter.
- A bare trigger, an imperative, or a polite action question is a Directive and dispatches.
- A concept question, a statement, a past-tense mention, a hypothetical, or a negation is an Inquiry and does not dispatch; on ambiguity ask before acting.
- Run multiple distinct matches once each, in the order they appear in the user's message; never run the same module twice.
- Load a triggered policy for the session and report it active instead of reloading it.
- Run a procedure once per invocation.
- A policy trigger never overrides the always-on rules, `AGENTS.md`, the customization file, or an explicit user instruction.
- `"use policy <name>"` is an explicit instruction; `<name>` is the Active Expertise token; it needs no trigger and bypasses the intent gate but not the always-on rules.
- `"use skill <name>"` loads the body for the task and announces it; a single best description match may load a skill; ambiguity asks; a miss reports `unknown skill`.
- A skill cannot override `AGENTS.md`, a policy, the user, or the customization file; a helper needs explicit approval and stays inside the package.
- A project policy with triggers is still loaded at boot by STEP-POLICY-LOADING and is reported as active.
- A runtime collision lists the candidates and dispatches nothing.
- Static violations fail validation before release; runtime violations are reported and skipped.
- An unreadable module is not loaded and is never treated as loaded; one bad module never blocks the load.
- An unknown `"use policy <name>"` reports `unknown policy`.
- Never edit, rename, delete, or auto-fix a module while handling a failure.
- Keep the active set in working context only; never write it to `ai/state/`, `ai-customization.md`, or any new file.

## TIER TRIGGERED-PROCEDURES

Procedure modules live in `(Global AI Workflow Directory)/ai/procedures/`, one file per procedure. Run `STEP-PROTOCOL-INDEX` to list them. `AGENTS.md` carries no procedure body and no static procedure list.

## TIER APPENDIX

See `(Global AI Workflow Directory)/docs/setup.md` for Windows path formats and the manual setup, including the bootstrap wedge.

<!-- END_IMMUTABLE_PROTOCOL -->
