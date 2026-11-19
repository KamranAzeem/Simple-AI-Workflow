# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Knowledge

Govern the knowledge stores and the knowledge file standards.

## Triggers

- knowledge file standards

## Loading

- Mode: trigger

## Scope

- Apply this policy to the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory**, and to every knowledge file in either store.
- This policy owns the global and project protocols, the ticket file scope, the file standards, the lookup, the retirement, the header literal, and the repair conservation contract.
- The common policy keeps the settings full load and the boot index invariant.

## Global Knowledge Protocol

- **Bootstrapping & Load Context: Knowledge (JIT Index)**: Files in the **Global AI Knowledge Directory** are indexed at boot, not read in full. Indexing records filenames, paths, and apparent technical domains; a file is read in full only when a task needs it. The filename is the JIT lookup key; apply the naming, split, and lookup rules in `## Knowledge File Standards`; accept the one-file lookup trade-off. This mirrors the Project Knowledge Protocol; Token Rationing governs both.
- **Store size**: apply the 50-file review threshold in `## Knowledge File Standards`.
- **Content Integrity**: The agent MUST NOT modify files within the **Global User AI Directory** unless explicitly instructed by the user. The explicit `repair knowledge files` trigger is that instruction for the global repair; the repair asks no further question.
- **Normalization**: Treat Global Knowledge files as "lessons learned" to inform problem-solving, not as authoritative codebase logic.
- **What belongs here**: only genuinely cross-project, reusable lessons (a tool's behavior, a pattern that generalizes, a portable fix). Project-specific material belongs in Project Knowledge. The checkpoint's capture step collects these; the global step promotes them and confirms "nothing to add" when none qualify.
- **Format**: Apply `## Knowledge File Standards` to every global knowledge file.

## Project Knowledge Protocol

- **Bootstrapping & Load Context**: Upon session initiation or when executing "load context" commands, the agent MUST index all files in the **Project AI Knowledge Directory** as defined in the knowledge loading step of the load-context procedure module. Indexing means recording filenames, paths, and apparent technical domains: **DO NOT** read the full content of any Project Knowledge file at boot time. Full content is loaded on demand when an active task explicitly requires that specific knowledge. This indexing step is mandatory and must not be merged with the settings and state loading step.
- **Bounded staleness**: Flag a Global Knowledge or Project Knowledge file at boot when its indexed domain matches an active expertise domain and its age exceeds 90 days. Use metadata only for age: the last-commit date for tracked files, or the modified time otherwise. Report flagged files, one line each. The flag is advisory. At task start, re-check the index against the task's keywords. Verify a flagged file against current state and policies when a task loads it. Never read a Global Knowledge or Project Knowledge file at boot for staleness. The checkpoint's housekeeping step reuses this same flag, report-only.
- **Precedence**: Project Knowledge takes precedence over Global Knowledge when there is a conflict, because it is scoped to the specific project's architecture, decisions, and constraints.
- **Content Integrity**: The agent MUST update Project Knowledge files during checkpoints (see the checkpoint knowledge update steps in the write-checkpoint procedure module) to capture new decisions, resolved issues, and technical findings. The explicit `repair knowledge files` trigger is the approval for that repair's merges, trims, restructures, backups, and removals; the repair asks no further question. The agent MUST NOT delete or restructure Project Knowledge files otherwise.
- **Store size, lookup, and retirement**: apply the 50-file review threshold, the task-to-filename lookup, and the retirement rules in `## Knowledge File Standards`.
- **Normalization**: Treat Project Knowledge as **authoritative** for this project's context: it reflects actual decisions made, not general advice. This differs from Global Knowledge which is treated as "lessons learned."
- **Format**: Apply `## Knowledge File Standards` to every project knowledge file.

### Ticket File Scope

Files under a `tickets/` subdirectory of the **Project AI Knowledge Directory** represent the status exchange that flows through the customer ticket system (Jira, etc.). They contain:

- Decisions and outcomes communicated through the ticket
- Blockers raised and resolved, as visible to the customer
- References to PRs, builds, and key identifiers as they appear in ticket comments
- Closing conditions and final status

They do NOT contain:

- Technical investigation notes, CLI output, or diagnostic data
- Step-by-step runbooks or command sequences
- AI model handover notes or session diary entries
- Any content not directly shared with or by the customer through the ticket

All such content belongs in named project knowledge files. When creating or updating a ticket file, apply this boundary strictly. Existing content that violates it must be migrated to the appropriate knowledge file, not left in place.

## Knowledge File Standards

- Apply this section to every knowledge file in the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory**.
- Exempt `issue-template.md` from this section.
- Exempt a design document under `ai/shared/project-knowledge/` from this section; the design-docs contract owns it.
- Use one descriptive H1 per knowledge file.
- Include `## Context`, `## Rule or Fix`, `## Why`, and `## Verify`.
- Include `## Caveats` only when a limitation exists.
- Use `## Rule or Fix` for a checklist.
- Write short sentences and flat bullets.
- Do not use tables.
- Convert every table row to a flat bullet and preserve a row that has no home.
- Do not nest bullets deeper than one level.
- Do not write a specific commit hash, branch name, checkpoint date or title, diary date or title, or state-file path.
- Write a domain term such as commit, branch, or checkpoint only when the lesson requires it; the ban targets session bookkeeping.
- Keep the file self-standing: include the facts, rules, reasons, and checks it needs.
- Do not point at another knowledge file, code file, doc, policy, artifact, backup, or state file.
- Treat a domain command, a system path, or a path that a checklist step writes or edits as content, not a cross-file pointer.
- Do not write a raw secret.
- Do not write an identifying name in a global knowledge file.
- Keep an identifying name in a project knowledge file outside git; a tracked knowledge file follows the commit guardrail.
- Define an identifying name as a person, client, employer, or customer; a technology vendor or product name is content.
- Use 10,000 bytes as a soft target; never let it override completeness.
- Review a file at 15,000 bytes with the automatic cleanup in `PROCEDURE REPAIR-KNOWLEDGE-FILES`.
- Completeness means every reusable rule, fix, reason, check, identifier, and example; it does not mean every observation.
- Delete incident narrative, rehearsal logs, timelines, and per-ticket evidence once the reusable rule is written.
- Name a knowledge file for the task it answers: `<tool-or-domain>-<task>`, lowercase, hyphenated, six or fewer hyphen-separated segments, with no ticket ID, date, or incident name. Count each hyphen-separated segment as one word. The filename is the only index.
- Split a file only by task topic. Do not split by ticket, incident, date, phase, or environment.
- Merge a file under 3,000 bytes into its nearest topic file.
- Use 50 knowledge files per store as a review threshold. The checkpoint reports the count; at 50 or more, it recommends a repair. A new topic is never blocked.
- Split a file over 15,000 bytes after cleanup by task topic. Keep a checklist in one file and report a file that cannot be split.
- Store a cross-project lesson in the global store and its project-specific application in the project store; do not duplicate the same lesson in both. Keep the project store authoritative on a conflict.
- Put a per-PR or per-ticket review finding into one topic rules file; do not keep it as its own knowledge file.
- Keep a generated inventory or deliverable in the project artifacts area or a design document; it is not a knowledge file.
- Check the header before writing a knowledge file; see `### Knowledge File Header`.
- Stop the write and tell the user to run `repair knowledge files` when the header is missing or does not match.

### Knowledge Lookup

- At task start, match the task's tool and domain to the indexed filenames of both stores.
- Read every matching file in full before acting.
- Search the global store with shell `find` and `grep` and absolute paths; the workspace search tools cannot reach it.

### Knowledge Retirement

- Delete a ticket file when the ticket is Done in the live tracker, checked live.
- Delete an executed plan once its reusable content is in a knowledge file.
- Delete finished investigation evidence from the project artifacts area after writing its rules and findings to a knowledge file.
- The checkpoint reports these candidates; only the repair deletes.

### Knowledge File Header

- Treat the block below as a normative literal artifact.
- Copy the block verbatim as the first content before the H1.
- Add one blank line after the block.
- Replace a missing or edited block only through `repair knowledge files`.
- Do not edit the block by hand.

```markdown
> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.
```

### Knowledge Repair Conservation Contract

- Treat every old file as a set of atomic items: fact, rule or decision, why, caveat, verification step, identifier, and example.
- Build one manifest in memory before any write.
- Record one row per old item with old ID, old location, new location, disposition, and a one-line reason.
- Set the disposition to `kept`, `merged`, `trimmed`, `removed as defined garbage`, `removed as incident evidence`, `preserved ambiguous`, or `aborted unchanged`.
- Stop a file with an item that has no disposition and leave it unchanged.
- Audit the old file read-only first.
- Define garbage as recording or learned dates, commit hashes, branch names, checkpoint and diary references, state-file paths, artifact and backup pointers, cross-file pointers (except a path a checklist step writes or edits), table markup, and duplicates.
- Preserve every fact, rule, why, caveat, verification, identifier, and example that is not garbage.
- Preserve an ambiguous content item and report it.
- Treat a cross-file pointer as never ambiguous: resolve the fact into the file, or abort the file unchanged and report.
- Merge a duplicate into the survivor with no pointer.
- Do not keep evidence in an artifact or move a long analysis to an artifact.
- Convert every table row to a flat bullet; preserve a row that has no home and report it.
- Add no new claim; report a correction.
- Run an independent review of the old and new files and require an `APPROVED` verdict.
- On `CHANGES REQUESTED`, fix and re-review; if it cannot pass without content loss, leave the old file unchanged and report.
- Require no human approval beyond the trigger; the `repair knowledge files` trigger is the approval.
- Replace a file only after verification and an `APPROVED` review.
- Delete the temporary candidate after replacement or abort.
- Copy the full old project file to `ai/artifacts/knowledge-repair-<date>/project/` and the full old global file to `<Global User AI Directory>/knowledge-repair-backups/<date>/global/` before the first change.
- Write the manifest to `ai/artifacts/knowledge-repair-<date>/manifest.md` only for a non-dry run.
- Stop a dry run after the manifest report; write and replace nothing.
- Restore the backup on failure.
- Never let the 10,000-byte target override completeness.
- Keep a file over 15,000 bytes after cleanup as one file and report it.
- Remove a specific commit hash, branch name, checkpoint date or title, diary date or title, or state-file path as session bookkeeping.
- Keep the substantive evidence in the file; do not point at an artifact.
- Split a file by task topic only; never by ticket, incident, date, phase, or environment.
- Merge a file under 3,000 bytes into its nearest topic file.
- Keep each store at the 50-file review threshold; the repair reports a remaining overage.
- Delete incident evidence under the `removed as incident evidence` disposition once the reusable rule is written.
- Search the settings, issues, handoffs, and ticket files for pointers to a renamed or deleted file; update project-owned pointers and report a user-space settings pointer.
- Keep a checklist in one file.
- Remove a raw secret in both stores.
- Keep an identifying name in a project file; remove it from a global file.
- Record the manifest, project backup, and global backup paths in the checkpoint and diary.

## References

- `ai-policy-common.md` (`## Knowledge Invariant`).
- `PROCEDURE LOAD-CONTEXT`, `PROCEDURE WRITE-CHECKPOINT`, and `PROCEDURE REPAIR-KNOWLEDGE-FILES`.

<!-- AI-ASSISTANT: READ-ONLY END -->
