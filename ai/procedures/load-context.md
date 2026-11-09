# PROCEDURE LOAD-CONTEXT: When the user says "load context"

## Triggers

- load context
- load context using agents.md protocol

**Safety Barrier**: This procedure is read-only with one narrow, deterministic exception. AI must not modify the content of any existing file during this phase. The only permitted writes are the idempotent creation of missing mandatory directories and the missing issue template described in STEP-STRUCTURAL-AUDIT. Every other action is read-only.

0. **STEP-CUSTOMIZATION-DISCOVERY**: Check for **Project Customization File** at project root (`ai-customization.md`):
    - If found → load the `## AI Workflow Configuration` section and extract `**Global AI Workflow Directory`**. If the section is missing, inform the user and stop.
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
    - Permit only read operations in the clone: `rev-parse`, `ls-remote`, `cat-file -e`, and `merge-base --is-ancestor`; write nothing.
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
2. **Index**: Rebuild the module index with `STEP-PROTOCOL-INDEX`. Build it inline with standard tools and the same line format as the developer `--index` oracle; do not run the validator at load context.
3. **STEP-WORKFLOW-ACCESS**: Read `ai-policy-common.md` from the **Global AI Policies Directory**.
4. **STEP-STRUCTURAL-AUDIT (Existence-First)**: Silently verify the existence of the mandatory directories:
    - **Project Artifacts Directory**, **Project Code Review Reports Directory**, **Project Compliance Policies Directory**, **Project Daily Checkpoints Directory**, **Project Handoffs Directory**, **Project Issues Directory**, **Project AI Knowledge Directory**
    - **Project Notes Directory**, **Project Pending Directory**, **Project Plans Directory**, **Project AI Policies Directory**, **Project AI Skills Directory**, **Project Secrets Directory**, **Project Shared Directory**, **Project AI State Files**
    - Global: **Global AI Settings Directory**, **Global AI Knowledge Directory**, **Global AI Skills Directory**, **Global AI Backups Directory**
    Verify **Project Coordination File** exists.
    Then ensure the mandatory directories exist. Run one idempotent `mkdir -p` over this fixed path list, and report any directory that had to be created:
    - `ai/artifacts/`, `ai/code-review-reports/`, `ai/daily-checkpoints/`, `ai/issues/`, `ai/issues/open/`, `ai/issues/in-progress/`, `ai/issues/closed/`, `ai/notes/`, `ai/pending/`, `ai/plans/`, `ai/policies/`, `ai/policies/compliance/`, `ai/secrets/`, `ai/shared/`, `ai/shared/handoffs/`, `ai/shared/project-knowledge/`, `ai/skills/`, `ai/state/`
    - Do not branch, prompt, or stall on silent output. `mkdir -p` is safe and silent when the directory already exists.
    Then ensure `ai/shared/project-knowledge/issue-template.md` exists. If and only if it is missing, create it from the compact field list in `ai-policy-common.md`. Never overwrite it.
    Then check `.gitignore` for `ai-customization.md`. If absent, inform the user: "ai-customization.md is not in .gitignore. Add it to prevent accidental commits of your local configuration."
5. **STEP-DISCOVERY**: Produce a bounded, sorted index of the boot roots, at or under 16 KB.
    - Roots: the project root (`ai-customization.md`), the **Project AI State Files**, the **Project Coordination File**, the **Project AI Knowledge Directory**, the **Project Handoffs Directory**, the `open/` and `in-progress/` directories under the **Project Issues Directory**, the **Project Daily Checkpoints Directory**, the **Project AI Policies Directory**, the **Project AI Skills Directory**, the **Global AI Skills Directory**, every `design-docs/` directory under the project root, the **Global AI Settings Directory**, the **Global AI Knowledge Directory**, the **Global AI Policies Directory**, and the procedure store under the **Global AI Workflow Directory**.
    - Apply the **Boot Scan Exclusions** rule from TIER READ-FIRST-RULES in listing and reading.
    - State the outcome, constraints, and expected output before choosing a command form. The reference form is standard Linux Bash (`find`, `sort`, `wc`, `grep`; no optional tools). The POSIX/BSD `find` equivalent and the `pwsh` 7+ form are examples. Any OS, shell, or default terminal uses equivalent standard tools, reports the command used and any deviation, and stops and reports when no compliant tool exists. Never install tools.
    - Use one command block. Sort with `LC_ALL=C`. Display forward slashes. Emit UTF-8 without a BOM. Run no per-file subprocess.
    - When the output would exceed 16 KB, print the per-root counts and query the remainder on demand.
    - `ai/` is git-ignored: list it with shell commands, not by treating it as unreadable.
6. **STEP-LOADING**: Read the **Project Customization File**, all discovered **Global Settings** files (from the **Global AI Settings Directory**), **Project AI State Files**, the latest checkpoint file (from **Project Daily Checkpoints Directory**), and the **Project Coordination File**; and **load their full contents into the active context**. Read the latest checkpoint once; the proof reuses that read. When the latest file is not today's, today's checkpoint is absent and the proof reports `[PENDING]`. **Global Knowledge files** (from the **Global AI Knowledge Directory**) and **Project Knowledge files** are NOT loaded here; they are indexed in STEP-KNOWLEDGE-INDEXING. **Author identity**: resolve the author identity (project git identity, then global `~/.gitconfig`, then the global settings file) and offer the git config setup if it is missing or inadequate; offer only, do not write (the read-only safety barrier still applies). If design documents exist under the old `ai/shared/project-knowledge/` location and no `design-docs/` exists, offer to migrate; offer only, do not move files without approval. Design documents are written or updated only through the `"update design documents"` trigger, never at load context; `"migrate design docs"` is the only cross-location mover.
    - Batch the fixed reads in one turn where the client supports multi-tool dispatch; otherwise read sequentially. Never truncate an operational full read.
    - **STEP-STATE-FILE-PROOF-OF-READ**: After loading **Project AI State Files**, read them fresh and check them without writing: each state file carries the canonical header block for its type from `ai-policy-common.md` (`### Canonical State-File Headers`), and today's checkpoint carries the daily-checkpoint block and one `# Daily Checkpoint YYYY-MM-DD` H1 outside fenced code blocks whose date matches the filename; entries are in chronological order with no duplicates; items are at most three short bullets; and the newest `ai/state/progress.md` entry date matches the newest daily-checkpoint file date. Compare the block after normalizing a UTF-8 BOM, CRLF, and trailing whitespace; any other difference is a mismatch. Verify exactly one START and END marker per type, the block starts at line 1, and exactly one blank line follows END. Do not use filesystem metadata. Do not summarise from memory. A missing state file is `[FAILED]`; stop and report it before continuing. A missing today's checkpoint is `[PENDING]`; advise running a checkpoint and continue. A header or title mismatch is `[FAILED]`; warn that state-file health is degraded and work quality is at risk, and instruct the user to run `repair state files` now. The load remains read-only. Report the findings under ITEM STATE-FILE-HEALTH of STEP-PROOF-OF-LOAD, and repair only via `repair state files`. Report each file's size and the total against the soft targets; overage is advisory and never fails the load.
7. **STEP-KNOWLEDGE-INDEXING (JIT Index)**: This is a dedicated required step; do NOT merge it with STEP-LOADING. Both knowledge sets are indexed, never fully loaded at boot.
    - **Global Knowledge** (from **Global AI Knowledge Directory**) and **Project Knowledge** (from **Project AI Knowledge Directory**, including any subdirectories) are both subject to **Token Rationing**. Index both in this one step: run a shell command (`find` or `ls -R`) over both directories, and record paths, filenames, and apparent technical domains as a reference index. Record each file's age from metadata only: the last-commit date for tracked files, or the modified time otherwise. **DO NOT** load the full text of any Global Knowledge or Project Knowledge file at boot time; load a file in full on demand when an active task requires it. The filename is the lookup key, so a vague or bundled name is invisible to the index. Bound the combined index output at 16 KB; when over, print the per-root counts and query the remainder on demand. Use one command block; run no per-file subprocess.
    - **Project Issues** (from **Project Issues Directory**): Index `open/` and `in-progress/` by filename + line count only. Files under `closed/` are not indexed at boot.
    - **Design Docs** (every `design-docs/` directory under the project root): Index by filename and a short domain, read-only and never loaded in full. Scan at most 5 levels deep, prune `.git`, `node_modules`, `vendor`, and `target`, and skip archives. Scanning `design-docs` by name is permitted.
    - **Skills**: Run `STEP-SKILLS-INDEX` over the two skills roots; the step is defined once in `AGENTS.md`; index no body.
    If a directory is completely empty, explicitly note it in your state tracking.
8. **STEP-POLICY-LOADING**: Scan the **Project Customization File** for the `## Active Expertise` section.
    - For each listed expertise name, try `ai-policy-<name>.md` first, then `<name>.md` as fallback.
    - Locate matching files in the **Global AI Policies Directory** using a recursive shell command (`find` or equivalent).
    - Load the FULL TEXT of every matched file.
    Do NOT defer policy loading to "on demand": the AI cannot follow a rule it has not read.
    Then run a recursive shell command (`find` or equivalent) on **Project AI Policies Directory** to discover all `.md` files the user placed there. Load the FULL TEXT of every discovered file. These are user-created custom policies that must be loaded at boot even though they are not listed in the Project Customization File.
    **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip this recursive scan. Load ONLY `ai-policy-common.md` and the policy files explicitly listed under `## Active Expertise` in the **Project Customization File**. The **Project AI Policies Directory** is the protocol's full distribution tree: all domain policies live there, but most do not apply to protocol development work.

    > **Design note (deliberate exception to Token Rationing)**: Loading referenced policy files in full at boot is an intentional exception to the Token-Rationing principle. The cost of a few hundred lines of policy text is far lower than the cost of the AI applying wrong or missing rules because it guessed at policy content. Token Rationing still applies to large Project Knowledge files (repo-scan snapshots, historical archives), never to the operational policy files that govern AI behaviour.
9. **STEP-PROOF-OF-LOAD**: Submit a compact Markdown summary, one line per item, counts only. Expand an item only when it is `[FAILED]` or `[PENDING]`.
    - **ITEM CUSTOMIZATION-SECTIONS**: `[PASSED]` with the section count and the file line count.
    - **ITEM SETTINGS-AND-POLICIES**: `[PASSED]` with the settings file count and the fully loaded policy file count.
    - **ITEM HANDOFFS**: `[PASSED]` with the pending handoff count, or `[PASSED] none`.
    - **ITEM STATE-FILE-HEALTH**: `[PASSED]` with the three state-file byte sizes and budgets.
    - **ITEM KNOWLEDGE-INDEX**: `[PASSED]` with the Global and Project Knowledge file counts.
    - **ITEM SKILLS-INDEX**: `[PASSED]` with the skills count and any override or collision.
    - **ITEM DESIGN-DOCS-INDEX**: `[PASSED]` with the design-document count, or `none`.
    - **ITEM STATE-FILE-COUNTS**: `[PASSED]` with the three line counts and the newest progress date.
    - **ITEM ISSUES-INDEX**: `[PASSED]` with the open and in-progress counts.
    - **ITEM STALE-KNOWLEDGE**: `[PASSED]` with the flagged count, or `none`.
    - **ITEM WORKFLOW-VERSION**: `[PASSED]` with the version-check outcome line.
    - **ITEM PROTOCOL-INDEX**: `[PASSED]` with the module counts by type and scope, the trigger count, the conflict count, and the error count.
