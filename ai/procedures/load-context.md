# PROCEDURE LOAD-CONTEXT: When the user says "load context"

## Triggers

- load context
- load context using agents.md protocol

**Safety Barrier**: This procedure is read-only with one narrow, deterministic exception. AI must not modify the content of any existing file during this phase. The only permitted writes are the idempotent creation of missing mandatory directories and the missing issue template described in STEP-STRUCTURAL-AUDIT. Every other action is read-only.

0. **STEP-CUSTOMIZATION-DISCOVERY**: Check for **Project Customization File** at project root (`ai-customization.md`):
    - If found → load the `## AI Workflow Configuration` section and extract `**Global AI Workflow Directory**`, `**Global User AI Directory**` (default `[HOME]/.ai/`), `**Default Shell**`, and, when present, `**Team AI Knowledge Directory**` and `**Team AI Knowledge Repository**`. If the section is missing, inform the user and stop.
    - Then read every settings file in the **Global AI Settings Directory** with the built-in reader (from the resolved Global User AI Directory). Resolve the **Default Shell Path** from the settings. An absent `Default Shell` key keeps the current or default shell and does not suppress the helper. A named shell that is not found, or a configured `Default Shell Path` that does not exist, is reported, and the boot continues with built-ins. An absent path resolves the named shell from `PATH`; for `git-bash`, resolve a Git for Windows `bash.exe` or `bash`. The optional index helper uses its bash shebang regardless of `Default Shell`. The first named command runs after this step.
    - If the old `ai/ai-customization.md` exists instead → inform the user: "Your customization file is in the old `ai/` directory. Add a `## AI Workflow Configuration` section with a `**Global AI Workflow Directory**` entry, then move it to the project root as `ai-customization.md`." Then **stop**, do not proceed with context loading.
    - If neither exists → inform the user that the customization file is missing, show a template, explain what to configure, and optionally suggest cloning the Simple-AI-Workflow repo to `[HOME]/Projects/Simple-AI-Workflow` or another location the user chooses, from its GitHub URL. Then **stop**, do not proceed with context loading.
1. **STEP-WORKFLOW-VERSION-CHECK (read-only)**: Check whether the workflow clone is older than its remote.
    - Use the **Global AI Workflow Directory** resolved in STEP-CUSTOMIZATION-DISCOVERY in a transient variable `GLOBAL_AI_WORKFLOW_DIRECTORY`.
    - Confirm `git` is available, the path is the repository top level, and the clone is not shallow; otherwise take the skip path below.
    - Compare the clone's resolved `git -C "$GLOBAL_AI_WORKFLOW_DIRECTORY" rev-parse --show-toplevel` with the anchor after stripping one trailing slash.
    - Read the local head with `git -C "$GLOBAL_AI_WORKFLOW_DIRECTORY" rev-parse HEAD`.
    - Read the remote head with `git -C "$GLOBAL_AI_WORKFLOW_DIRECTORY" -c credential.helper= ls-remote origin HEAD`.
    - Set `GIT_TERMINAL_PROMPT=0` and `GIT_NO_LAZY_FETCH=1` for the remote call and the local checks.
    - Cap the remote call at about three seconds with the OS-native mechanism.
    - Capture stderr only to choose one fixed reason string; never emit it.
    - Permit only read operations in the clone: `rev-parse`, `ls-remote`, `cat-file -e`, `merge-base --is-ancestor`, and `log -1 --format=%ct` for the age source; write nothing.
    - Never print the remote URL, a credential, or captured output.
    - Compare the full 40-character SHAs and shorten them to seven characters only for display.
    - Classify in this order:
        - Equal SHAs: `up to date (<short local sha>)`.
        - Remote SHA absent from the local object store (`git cat-file -e` fails): `updates available (local <short>, remote <short>). Run: git -C "<path>" pull`.
        - Remote SHA is an ancestor of local `HEAD` (`git merge-base --is-ancestor <remote-sha> HEAD` exits 0): `local is ahead of remote (local <short>, remote <short>). The workflow clone must not be modified.`
        - Local `HEAD` is an ancestor of the remote SHA (`git merge-base --is-ancestor HEAD <remote-sha>` exits 0): `updates available (local <short>, remote <short>). Run: git -C "<path>" pull`.
        - Both ancestry checks exit 1: `local and remote have diverged (local <short>, remote <short>). The workflow clone must not be modified.`
    - A `merge-base` exit above 1 takes the skip path below.
    - Take the skip path on any of these conditions: no `git`; not a git work tree; the path is not the repository top level; a shallow clone; no `origin`; an empty remote head; a failed or timed-out call; required authentication; an unreadable revision.
    - Report `version check skipped: <reason>` with exactly one of these reason strings: `git unavailable`, `path is not a git work tree`, `path is not the repository root`, `clone is shallow`, `no origin remote`, `remote HEAD is empty`, `remote unreachable or timed out`, `authentication required`, `revision unreadable`.
    - Record the outcome for STEP-PROOF-OF-LOAD.
2. **STEP-PROTOCOL-INDEX**: Rebuild the module index with the built-in reader, glob, and search, and record it in working context.
    - Scope: the **Global AI Policies Directory**, recursively and including `compliance/`; the global procedures under `(Global AI Workflow Directory)/ai/procedures/`; and the **Project AI Policies Directory**, recursively. Dedupe by canonical path. A project policy with the same name as a global policy replaces it: the global line is `effective=shadowed:<project-name>`, the project line is `effective=yes`, and the replaced global triggers stay reserved.
    - A missing project `ai/` is an empty project scope. When the built-in glob cannot reach the workflow clone, use the runner's listing and search forms for the global modules; if no form exists, index the project modules and report the global scope as `[PENDING]` in ITEM PROTOCOL-INDEX.
    - Skip hidden entries, `tmp`, archives, and symlinks. Write no file and create no cache.
    - For each module, record type, scope, name, source relative to its anchor, literal and normalized triggers, headings with levels, effective, conflict, and the index source. Hold no body text.
    - Normalize a phrase to lowercase with non-alphanumerics as spaces, collapse and trim, and drop a trailing `#N`. A duplicate is the same normalized phrase across the effective set or between an effective module and a reserved trigger of a shadowed global. An overlap is a whole-word containment across the same pairs. The pair between a shadowed global and its same-name replacement is exempt. A different-name project policy that uses a reserved trigger is a duplicate, and both lines name each other.
    - In Protocol Developer Mode, index the distribution tree metadata as usual; the mode limits body loading, not indexing.
    - Rebuild before dispatch when a module file changed in the session. Report counts by type and scope, the trigger count, the conflict count, and errors by class in ITEM PROTOCOL-INDEX; include `index-source=builtin`.
    - The optional `support-files/index-protocol.sh` helper is a maintainer and release-check tool. It is not used at boot.
3. **STEP-WORKFLOW-ACCESS**: Read `ai-policy-common.md` from the **Global AI Policies Directory** with the built-in reader.
4. **STEP-STRUCTURAL-AUDIT (Existence-First)**: Silently verify the existence of the mandatory directories:
    - **Project Artifacts Directory**, **Project Code Review Reports Directory**, **Project Compliance Policies Directory**, **Project Daily Checkpoints Directory**, **Project Handoffs Directory**, **Project Issues Directory**, **Project AI Knowledge Directory**
    - **Project Notes Directory**, **Project Pending Directory**, **Project Plans Directory**, **Project AI Policies Directory**, **Project AI Skills Directory**, **Project Secrets Directory**, **Project Shared Directory**, **Project AI State Files**
    - Global: **Global AI Settings Directory**, **Global AI Knowledge Directory**, **Global AI Skills Directory**, **Global AI Backups Directory**
    Verify **Project Coordination File** exists.
    Then ensure the mandatory directories exist. Run one idempotent `mkdir -p` over this fixed path list, and report any directory that had to be created:
    - `ai/artifacts/`, `ai/code-review-reports/`, `ai/daily-checkpoints/`, `ai/issues/`, `ai/issues/open/`, `ai/issues/in-progress/`, `ai/issues/closed/`, `ai/notes/`, `ai/pending/`, `ai/plans/`, `ai/policies/`, `ai/policies/compliance/`, `ai/secrets/`, `ai/shared/`, `ai/shared/handoffs/`, `ai/shared/project-knowledge/`, `ai/skills/`, `ai/state/`
    - Do not branch, prompt, or stall on silent output. `mkdir -p` is safe and silent when the directory already exists.
    Then ensure `ai/shared/project-knowledge/issue-template.md` exists. If and only if it is missing, load `ai-policy-issue-management.md` and create it from its `### Ticket Fields`. Never overwrite it.
    Then check `.gitignore` for `ai-customization.md`. If absent, inform the user: "ai-customization.md is not in .gitignore. Add it to prevent accidental commits of your local configuration."
5. **STEP-DISCOVERY**: Produce a bounded, sorted index of the boot roots, at or under 16 KB, with the built-in glob and directory listing.
    - Roots: the project root (`ai-customization.md`), the **Project AI State Files**, the **Project Coordination File**, the **Project AI Knowledge Directory**, the **Project Handoffs Directory**, the `open/` and `in-progress/` directories under the **Project Issues Directory**, the **Project Daily Checkpoints Directory**, the **Project AI Policies Directory**, the **Project AI Skills Directory**, the **Global AI Skills Directory**, every `design-docs/` directory under the project root, the **Global AI Settings Directory**, the **Global AI Knowledge Directory**, the **Global AI Policies Directory**, the procedure store under the **Global AI Workflow Directory**, and the configured **Team AI Knowledge Directory** when the key is present and readable.
    - Apply the Boot Scan Exclusions to every listing and read:
        - Exclude the **Project Secrets Directory**.
        - Exclude the **Project Artifacts Directory**.
        - Exclude the **Project Code Review Reports Directory**.
        - Exclude the **Project Notes Directory**.
        - Exclude the **Project Pending Directory**.
        - Exclude the **Project Plans Directory**.
        - Exclude `ai/issues/closed/`.
        - Exclude every `.git/` directory.
        - Treat an excluded path as out of bounds.
    - State the outcome, constraints, and expected output before a named command; a built-in step states the capability, not a shell command. The named commands are the version check, directory creation, the POSIX metadata step, the global listing and search, the backup archive, and the git-ignore fallback.
    - When the output would exceed 16 KB, print the per-root counts and query the remainder on demand.
    - STEP-DISCOVERY owns the state-file byte sizes. Measure them with `wc -c` and `stat` or `find` when the runner is POSIX; when they are unavailable, ITEM STATE-FILE-HEALTH reports `[PENDING]` with the reason. STEP-KNOWLEDGE-INDEXING owns the knowledge ages.
6. **STEP-LOADING**: Read the **Project AI State Files**, the latest checkpoint file (from **Project Daily Checkpoints Directory**), and the **Project Coordination File** with the built-in reader; and **load their full contents into the active context**. The customization and the global settings were read in STEP-CUSTOMIZATION-DISCOVERY. Read the latest checkpoint once; the proof reuses that read. When the latest file is not today's, today's checkpoint is absent and the proof reports `[PENDING]`. **Global Knowledge files** (from the **Global AI Knowledge Directory**) and **Project Knowledge files** are NOT loaded here; they are indexed in STEP-KNOWLEDGE-INDEXING. **Author identity**: resolve the author identity (project git identity, then global `~/.gitconfig`, then the global settings file) and offer the git config setup if it is missing or inadequate; offer only, do not write (the read-only safety barrier still applies). If design documents exist under the old `ai/shared/project-knowledge/` location and no `design-docs/` exists, offer to migrate; offer only, do not move files without approval. Design documents are written or updated only through the `"update design documents"` trigger, never at load context; `"migrate design docs"` is the only cross-location mover.
    - Batch the fixed reads in one turn where the client supports multi-tool dispatch; otherwise read sequentially. Never truncate an operational full read.
    - **STEP-STATE-FILE-PROOF-OF-READ**: After loading **Project AI State Files**, read them fresh and check them without writing: each state file carries the canonical header block for its type from `ai-policy-common.md` (`### Canonical State-File Headers`), and today's checkpoint carries the daily-checkpoint block and one `# Daily Checkpoint YYYY-MM-DD` H1 outside fenced code blocks whose date matches the filename; entries are in chronological order with no duplicates; items are at most three short bullets; and the newest `ai/state/progress.md` entry date matches the newest daily-checkpoint file date. Compare the block after normalizing a UTF-8 BOM, CRLF, and trailing whitespace; any other difference is a mismatch. Verify exactly one START and END marker per type, the block starts at line 1, and exactly one blank line follows END. Do not use filesystem metadata. Do not summarise from memory. A missing state file is `[FAILED]`; stop and report it before continuing. A missing today's checkpoint is `[PENDING]`; advise running a checkpoint and continue. A header or title mismatch is `[FAILED]`; warn that state-file health is degraded and work quality is at risk, and instruct the user to run `repair state files` now. The load remains read-only. Report the findings under ITEM STATE-FILE-HEALTH of STEP-PROOF-OF-LOAD, and repair only via `repair state files`. For each state file, report its byte size, the count of item lines over 300 characters, and the five longest item lines as a line number and a character count; never quote the line text. An item line is a non-empty line after the header END marker that is not an ATX heading. Report the total against the 30,720-byte shared budget; overage is advisory and never fails the load.
7. **STEP-KNOWLEDGE-INDEXING (JIT Index)**: This is a dedicated required step; do NOT merge it with STEP-LOADING. Load `ai-policy-knowledge.md` and apply its `## Global Knowledge Protocol` and `## Project Knowledge Protocol` before indexing. Both knowledge sets are indexed, never fully loaded at boot.
    - **Global Knowledge** (from **Global AI Knowledge Directory**) and **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories) are both subject to **Token Rationing**. Index both in this one step with the built-in glob and directory listing, and record paths, filenames, and apparent technical domains as a reference index. Record each file's age from metadata only: the commit date for tracked files when `git` is available, or the modified time otherwise, and report `age-source=commit|mtime`. **DO NOT** load the full text of any Global Knowledge or Project Knowledge file at boot time; load a file in full on demand when an active task requires it. The filename is the lookup key, so a vague or bundled name is invisible to the index. Bound the combined index output at 16 KB; when over, print the per-root counts and query the remainder on demand.
    - **Project Issues** (from **Project Issues Directory**): Index `open/` and `in-progress/` by filename + line count only. Files under `closed/` are not indexed at boot.
    - **Design Docs** (every `design-docs/` directory under the project root): Index by filename and a short domain, read-only and never loaded in full. Scan at most 5 levels deep, prune `.git`, `node_modules`, `vendor`, and `target`, and skip archives. Scanning `design-docs` by name is permitted.
    - **STEP-SKILLS-INDEX**: Build an ephemeral name, description, path, and scope index from both skill roots; read no body and write no file.
        - One level: a `SKILL.md` package; `name` and a one-line `description` of at most 200 characters; lowercase-kebab directory matches `name`; skip and report a hidden entry, symlink, invalid package, or empty root.
        - A project skill replaces a global skill; report the override and a cross-type name collision; keep the index within 16 KB.
    If a directory is completely empty, explicitly note it in your state tracking.
    - The global store search uses the built-in search when it can reach the path; otherwise use the runner's listing and search forms with absolute paths (ladder bullet 9), skipping hidden, `tmp`, and archive entries. If neither form exists, ITEM KNOWLEDGE-INDEX reports the global store as `[PENDING]`.
8. **STEP-TEAM-KNOWLEDGE-INDEX**: This is a dedicated required step; do NOT merge it with the knowledge index.
    - Read **Team AI Knowledge Directory** from the **Project Customization File** and expand `~` and `[HOME]`.
    - When the key is absent, report `[PASSED] none` and skip the policy load.
    - When the key is present and readable, load `ai-policy-team-knowledge.md` in full from the **Global AI Policies Directory**, report it active, and index `lessons/` filenames, paths, and apparent domains only.
    - When the key is present and missing or unreadable, report `[PENDING]` with the reason and continue; do not load the policy.
    - Never read lesson content at boot. Bound the index at 16 KB; when over, print the counts and query the remainder on demand.
9. **STEP-POLICY-LOADING**: Scan the **Project Customization File** for the `## Active Expertise` section.
    - For each listed expertise name, try `ai-policy-<name>.md` first, then `<name>.md` as fallback.
    - Locate matching files in the **Global AI Policies Directory** with the built-in glob.
    - Load the FULL TEXT of every matched file with the built-in reader, reusing the STEP-WORKFLOW-ACCESS common read.
    Do NOT defer policy loading to "on demand": the AI cannot follow a rule it has not read.
    **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip the project-policy scan. Load ONLY `ai-policy-common.md` and the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. The **Project AI Policies Directory** is the protocol's full distribution tree: all domain policies live there, but most do not apply to protocol development work. Otherwise, use the built-in glob on the **Project AI Policies Directory** to discover all `.md` files the user placed there. Load the FULL TEXT of every discovered file. These are user-created custom policies that must be loaded at boot even though they are not listed in the Project Customization File.

    > **Design note (deliberate exception to Token Rationing)**: Loading referenced policy files in full at boot is an intentional exception to the Token-Rationing principle. The cost of a few hundred lines of policy text is far lower than the cost of the AI applying wrong or missing rules because it guessed at policy content. Token Rationing still applies to large Project Knowledge files (repo-scan snapshots, historical archives), never to the operational policy files that govern AI behaviour.
10. **STEP-PROOF-OF-LOAD**: Submit a compact Markdown summary, one line per item, counts only. Expand an item only when it is `[FAILED]` or `[PENDING]`, except that ITEM PROTOCOL-INDEX prints `index-source`, and ITEM STALE-KNOWLEDGE prints `age-source`; those expansion lines print for a `[PASSED]` item when the fields are present.
    - **ITEM CUSTOMIZATION-SECTIONS**: `[PASSED]` with the section count and the file line count.
    - **ITEM SETTINGS-AND-POLICIES**: `[PASSED]` with the settings file count and the fully loaded policy file count.
    - **ITEM HANDOFFS**: `[PASSED]` with the pending handoff count, or `[PASSED] none`.
    - **ITEM STATE-FILE-HEALTH**: `[PASSED]` with the three state-file byte sizes, the shared budget, and the over-300 line count.
    - **ITEM KNOWLEDGE-INDEX**: `[PASSED]` with the Global and Project Knowledge file counts.
    - **ITEM TEAM-KNOWLEDGE-INDEX**: `[PASSED] none` when unconfigured; `[PASSED]` with the lesson count when indexed; `[PENDING]` with the reason when the store is missing or unreadable.
    - **ITEM SKILLS-INDEX**: `[PASSED]` with the skills count and any override or collision.
    - **ITEM DESIGN-DOCS-INDEX**: `[PASSED]` with the design-document count, or `none`.
    - **ITEM STATE-FILE-COUNTS**: `[PASSED]` with the three line counts and the newest progress date.
    - **ITEM ISSUES-INDEX**: `[PASSED]` with the open and in-progress counts.
    - **ITEM STALE-KNOWLEDGE**: `[PASSED]` with the flagged count, or `none`; print `age-source=commit|mtime`.
    - **ITEM WORKFLOW-VERSION**: `[PASSED]` with the version-check outcome line.
    - **ITEM PROTOCOL-INDEX**: `[PASSED]` with the module counts by type and scope, the trigger count, the conflict count, the error count, and `index-source=builtin`.
