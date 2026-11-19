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
**Global User AI Directory**: resolved from **Project Customization File** at boot; default `[HOME]/.ai/`
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

- **Self-Modification**: **STRICTLY PROHIBITED** in ordinary projects. Do not rewrite, regenerate, or edit this file. The maintainer exception is in **Protocol Developer Mode** below.
- **Unprompted Exploration**: **STRICTLY PROHIBITED** from scanning or ingesting directories outside the `ai/` folder (e.g., `src/`, `logs/`, `tmp/`) unless explicitly directed by a specific task. Indexing directories named `design-docs` by name is the one standing exception.
- **Local State Creation**: **STRICTLY PROHIBITED** from creating tool-specific dot-directories (e.g., `.cursor/`, `.copilot`, `.gemini/`, `.claude/`, etc.). All AI state must live in `ai/`.
- **PWD-Only Scope**: Load `AGENTS.md` and scan `ai/` from the current working directory only. Honor `AGENTS.md` and `ai-customization.md` only from the project root; do not scan subdirectories for more.
- **Foreign Assistant Files**: Do not read another assistant's files such as `CLAUDE.md`.
- **Missing Protocol File**: If `AGENTS.md` is not in PWD, report it missing and stop.

### ✅ MANDATORY ACTIONS

- **OS-Sensitive Execution**: Before a named shell command, identify the active OS, shell, and terminal. State the outcome, constraints, and expected output before choosing its form. Use the reference form or an equivalent standard tool, and report the command used and any deviation. A built-in step states the capability, not a shell command.
- **No Tool Installation**: Never install tools. When a named tool is missing and the built-in path can continue, report `[PENDING]` and continue; stop and report only when the task cannot proceed without the tool.
- **Git-Ignored Protocol Files Are Readable**: A protocol-owned file or directory is any path this protocol creates, reads, or maintains, and it is readable even when git ignores it. Read it with the built-in file-read tool first. If the harness refuses or hides a git-ignored path, use a shell tool (`cat`, `ls -la`, `find`) and report the fallback. Never refuse to read a protocol file or directory solely because git ignores it.
- **Full File Reads**: Read every file you reason about in full, line 1 to EOF. Re-read from disk when a task needs it again. This holds at boot, at load context, at recovery, and mid-work.
- **No Sliced Evidence**: The only exception is log-like bulk data you search rather than read: logs, dumps, large JSON, or CSV. Never truncate investigation output with `head`, `tail`, or `-N`; truncated output is fabricated evidence.
- **Auditable Reads**: When a read drives a decision or change, state the file and its line count.
- **Evidence-Based Investigation**: Investigate before you assert. No claim without a source; no assumptions or guesses. If you cannot verify, write "not verified" and ask. Wide-scope the subject read-only over its cone of influence. See the Investigation Contract in `ai-policy-common.md`.
- **Context Protection**: Treat **Project AI State Files** as read-only during bootstrap and context loading. During **PROCEDURE POST-COMPACTION-RECOVERY**, these files must not be read at all.
- **State File Single-Writer**: The project-root orchestrator is the only writer of the state files. The common policy owns the mechanics.
- **Branch Gating**: Obtain explicit human approval before any state-changing Git operation on `master` or `main`.
- **Protocol Developer Mode**: When PWD matches the **Global AI Workflow Directory**, you are the protocol maintainer. This is the sanctioned exception to Self-Modification: you maintain these files, not merely read them. Before changing a protocol file (`AGENTS.md`, a policy, a procedure, a validator script, or any file under `ai/`), fully load `protocol-decisions.md` from `(Global AI Workflow Directory)/design-docs/`, and get explicit human approval before committing.
- **End-User Perspective**: Write every path and file reference in a policy file from the end-user's project root, not from this repository's internal tree. See the "No markdown hyperlinks in policy files" entry in `protocol-decisions.md`.
- **Policy Loading Set**: During context loading and post-compaction recovery, load only `ai-policy-common.md` plus the policies named under `## Active Expertise`, except that STEP-POLICY-LOADING also loads every project policy from the **Project AI Policies Directory**. Do not load every global policy as body text; the global policy directory is the distribution tree.
- **Session Resume (Compacted Context)**: When a session starts from a compacted summary or is compacted mid-session, run **PROCEDURE POST-COMPACTION-RECOVERY** before answering. Signals: "Compacted conversation", a `<conversation-summary>` block, or a machine-generated multi-section summary you did not write.
- **Archive File Exclusion**: Every shell listing in this protocol excludes compressed and archive files. With `find`, use `! -name '*.tar*' ! -name '*.zip'`; with `ls`, filter with `grep -v '\.tar\|\.zip'`; with `Get-ChildItem`, filter the same names.
- **Backup Directory Exclusion**: Never scan, list, read, or reference files inside the **Global AI Backups Directory** (`~/.ai/backups/`). Backups are user-space artifacts and are not part of the active project state.

### Boot Scan Exclusions

- **Boot Scan Exclusions**: Apply the exclusions in STEP-DISCOVERY of PROCEDURE LOAD-CONTEXT to every boot scan, index, and proof.

---

## Shared Protocol Steps

- STEP-PROTOCOL-INDEX: Rebuild the module index from the live files and record it in working context. Defined in PROCEDURE LOAD-CONTEXT.
- STEP-SKILLS-INDEX: Build the ephemeral skills index from both skill roots; read no body and write no file. Defined in PROCEDURE LOAD-CONTEXT.

## Protocol Dispatch

- Resolve a user message against the module index.
- A phrase maps to one module. A phrase declared by two different modules is invalid; a phrase contained in another module's phrase is invalid. Close variants within one module are allowed and deduplicated.
- Match whole words after normalization; case, whitespace, hyphens, and punctuation do not matter.
- A bare trigger, an imperative, or a polite action question is a Directive and dispatches.
- A concept question, a statement, a past-tense mention, a hypothetical, or a negation is an Inquiry and does not dispatch; on ambiguity ask before acting.
- Run multiple distinct matches once each, in the order they appear in the user's message; never run the same module twice.
- Load a triggered policy for the session and report it active instead of reloading it.
- Run a procedure once per invocation.
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

## Precedence

- Level 0: the always-on safety rules in `AGENTS.md` and the common policy. They bind every level, including the user instruction.
- Level 1: the user's explicit instruction.
- Level 2: the rest of `AGENTS.md` and the common policy.
- Level 3: the project customization.
- Level 4: domain policies.
- Level 5: procedure steps.
- A lower level may narrow a higher level; it never contradicts it.
- An exception is valid only when the level that owns the rule authorizes it; the step states the exception, its reason, and the authorizing level.
- A policy trigger never overrides the always-on rules, `AGENTS.md`, the customization file, or an explicit user instruction.

## TIER TRIGGERED-PROCEDURES

Procedure modules live in `(Global AI Workflow Directory)/ai/procedures/`, one file per procedure. Run `STEP-PROTOCOL-INDEX` to list them. `AGENTS.md` carries no procedure body and no static procedure list.

## TIER APPENDIX

See `(Global AI Workflow Directory)/docs/setup.md` for Windows path formats and the manual setup.

<!-- END_IMMUTABLE_PROTOCOL -->
