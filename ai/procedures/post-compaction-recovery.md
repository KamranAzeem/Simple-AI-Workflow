# PROCEDURE POST-COMPACTION-RECOVERY: Automatic after conversation compaction

## Triggers

- post-compaction recovery
- run post-compaction recovery procedure

**Stable identifier**: The title "Post-Compaction Recovery" is the maintained contract referenced by the `validate-protocol.sh` anchor, the setup guide, and any hook configurations. Never rename this procedure without updating those in lockstep.

**Trigger**: Run this whenever the conversation is compacted, that is, whenever the harness replaces the live history with a summary. Concrete signals: the literal text "Compacted conversation" in the transcript; a `<conversation-summary>` XML block in the active context; or the session opening with a machine-generated multi-section summary you did not write. It is also safe to run on explicit user request. This procedure only re-reads standing rule and config files and re-indexes the knowledge bases; it never deletes or overwrites the working context, so running it when in doubt is safe.

**The one hard rule**: Do NOT read the three **Project AI State Files** (`ai/state/progress.md`, `ai/state/context.md`, `ai/state/next-steps.md`) or any daily checkpoint during this procedure. The compaction summary already in context is the source of truth for task state; the on-disk state files may be older than the summary and would inject stale state. This procedure reloads rules, not state. It therefore never runs the state-file health check and never runs `repair state files`.

**Steps**: Announce **[Reloading key files into context...]** as the literal first line of your reply, then re-read, in this order:

1. **STEP-READ-AGENTS**: The thin `AGENTS.md` from the current working directory (the **TIER CONFIGURATION** and **TIER READ-FIRST-RULES** sections) plus every module under `(Global AI Workflow Directory)/ai/procedures/`.
2. **STEP-READ-CUSTOMIZATION**: The **Project Customization File**: active Expertise, Traits, and Development Workflow rules.
3. **STEP-READ-SETTINGS**: Every file in the **Global AI Settings Directory** (full text).
4. **STEP-INDEX-KNOWLEDGE**: Index, filenames only (JIT, never reading file contents), the **Global AI Knowledge Directory**, the **Project AI Knowledge Directory**, every `design-docs/` directory under the project root (scan at most five levels deep, prune heavy trees, skip archives), and the two skills roots with `STEP-SKILLS-INDEX`. This is the same knowledge and design-docs index that STEP-KNOWLEDGE-INDEXING of PROCEDURE LOAD-CONTEXT builds; the skills index is STEP-SKILLS-INDEX.
5. **STEP-LOAD-POLICIES**: `ai-policy-common.md` from the **Global AI Policies Directory**, every policy referenced in the **Project Customization File**, and every `.md` found by a recursive scan of the **Project AI Policies Directory** (full text).
   **Exception: Protocol Developer Mode**: If the current working directory matches the **Global AI Workflow Directory**, skip the recursive scan. Load ONLY `ai-policy-common.md` and the policies explicitly listed under `## Active Expertise` in the **Project Customization File**. The **Project AI Policies Directory** is the protocol's full distribution tree: most files in it do not apply to protocol development work.
6. **Index**: Rebuild the module index with `STEP-PROTOCOL-INDEX`. After the rebuild, state that policies loaded only by a trigger do not survive compaction and ask for a re-trigger; never claim one survived.
7. **STEP-READ-COORDINATION**: Read the **Project Coordination File** in full (multi-agent awareness). Then build a filename-only index (no file contents) of everything else under the **Project Shared Directory**, recursively, including the **Project AI Knowledge Directory** and **Project Handoffs Directory**. Load those contents later, on demand, only when a task needs them.

**STEP-RELOAD-REPORT**: Then confirm in one or two lines: the Active Expertise and Traits reloaded, the count of settings and policy files loaded, the count of Global Knowledge files indexed, the count of project knowledge files indexed, the count of design docs indexed, the count of skills indexed, and the count of shared-directory files indexed. Do not quote or summarise any state file. If any file failed to load, say so and stop.
