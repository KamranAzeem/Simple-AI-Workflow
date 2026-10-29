Reported: 2026-10-29
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Align the project and global knowledge update procedures, enforce an AI-first knowledge file structure with a canonical authority header, and add a repair procedure.

Description:

**Problem**

- `AGENTS.md` treats `update project knowledge` and `update global knowledge` as single-step checkpoint aliases, but the two steps run separate evaluations.
- The global step does not consume the project step's finding list, so the two can reach different conclusions.
- The common policy defines knowledge purpose, precedence, and JIT indexing, but no shared content structure.
- The `Markdown Output` table ban does not include the knowledge directories.
- No rule bans commit hashes, branch names, checkpoint or diary references, or context-file references in knowledge files.
- No rule limits essays or defines a size target.
- A model that edits a knowledge file has no in-file authority header telling it which policy governs the format.
- The corpus is not compliant: long analyses, tables, hashes, and checkpoint references.
- No repair procedure exists for knowledge files. The checkpoint flags stale files only.

**Evidence**

- `AGENTS.md:152` lists the knowledge triggers as checkpoint aliases.
- `AGENTS.md:154` runs only the matching step and skips the rest.
- `AGENTS.md:188` is the project knowledge step.
- `AGENTS.md:195` is the global knowledge step.
- `ai-policy-common.md:148-155` is the Global Knowledge Protocol.
- `ai-policy-common.md:157-163` is the Project Knowledge Protocol.
- `ai-policy-common.md:88` is the checkpoint mandate.
- `ai-policy-common.md:162` is the content integrity rule.
- Project knowledge: 16 files, 2,246 lines.
- Global knowledge: 21 files, 538 lines.
- The three `mattpocock-*` analysis files are 379, 395, and 482 lines, with 19, 34, and 45 table lines, plus hashes and checkpoint references.
- `protocol-name-migration-map-2026-10-06.md` has 82 table lines.
- `multi-agent-state-ownership-and-checkpoint-model.md` has 6 tables and 15 checkpoint or commit references.
- `multi-assistant-workflow-design.md` has a commit hash and 8 references.
- `refactoring-and-upgrading-best-practices-2026-08-25.md` has 6 tables.
- `release-practices.md` has 4 checkpoint or commit references.
- Global knowledge is mostly 35 to 69 lines; `azure-private-dns-zone-group-record-ownership.md` has 4 table lines.

**Requirements**

1. Use one shared knowledge pass: capture findings and classify them as project, global, or both.
2. `update project knowledge` runs capture and the project store.
3. `update global knowledge` runs the same capture and project store, then the global promotion.
4. A full checkpoint runs both stores in that order.
5. Define one AI-first file structure for both knowledge directories:
   - Descriptive H1.
   - Short H2 sections: Context, Rule or Fix, Why, Verify, Caveats.
   - Short sentences and flat bullets or numbered steps.
   - No tables.
   - No nested bullets beyond one level.
   - One lesson per file.
   - No commit hashes, branch names, checkpoint or diary references, or context-file references.
   - No secrets or identifying names.
   - What first; Why short; no essays.
   - Soft size target: about 100 lines. Split or move the long analysis when it grows past that.
6. Add a canonical visible header to every knowledge file.
   - The header names `ai-policy-common.md` and the exact governing section.
   - The header is copied verbatim.
   - The header tells a model to follow that section.
   - The repair procedure restores the header.
7. Add a `repair knowledge files` procedure:
   - Index both directories.
   - Audit structure, tables, hashes, checkpoint or diary references, secrets, size, one-lesson-per-file, duplicates, and headers.
   - Report findings and propose rewrite, split, merge, move, or delete.
   - Apply only with approval.
   - Preserve the useful Why.
   - Move long analyses to `ai/artifacts/` or `design-docs/`.
   - Never auto-run at checkpoint.
8. Add a report-only knowledge-hygiene flag to checkpoint housekeeping.
9. Check the knowledge file header before the knowledge update writes.
10. Optional: a knowledge validator script.
11. Apply the Knowledge Conservation Contract below to every repair.
12. Update the documentation with a new banner about `repair knowledge files` and the knowledge standards. Cover the README, the workflow guide, the slides, and the setup or customization docs that describe knowledge updates.

## Knowledge Conservation Contract

Yes, but as a process guarantee, not as a mathematical proof. An LLM rewrite can always miss a nuance. The repair can be designed so that information loss is explicit, reviewable, and reversible.

### The conservation model

Treat every knowledge file as a set of atomic items, not as prose.

Each item has a type:

- fact
- rule or decision
- why or rationale
- caveat or limitation
- verification step
- identifier, value, command, or version
- example

The repair must produce a manifest with one row per old item:

- old item ID
- old location
- new location, or one of `merged`, `moved`, `obsolete`, `deleted with approval`
- one-line reason

Every old item must have a disposition. An item without a disposition blocks the repair. That is the core guarantee.

### Non-destructive workflow

The repair runs in four phases:

1. **Audit**: read the old file, build the item manifest, and propose the new structure. Write nothing.
2. **Backup**: copy the full old project file to `ai/artifacts/knowledge-repair-<date>/project/` and the full old global file to `~/.ai/knowledge-repair-backups/<date>/global/` before any change. The global backup stays outside git and outside the **Global AI Backups Directory**. The backup is an artifact, not a knowledge file.
3. **Candidate**: write the new file to a temporary path. Do not overwrite the old file.
4. **Verify and approve**: run the checks, get peer review and human approval, then replace the old file.

The old file remains authoritative until the new file passes verification. If anything fails, restore it.

### Verification checks

Before replacement:

- Every old item is mapped to a new location or an approved disposition.
- Every number, identifier, command, version, path, and error message still appears in the new file, unless it was explicitly marked obsolete.
- Every `why` and `caveat` item has a home. The format may shorten it, but it must not disappear.
- The new file adds no new claim that was not in the old file. If the repair finds a correction, it flags it for separate approval.
- Tables are converted row by row. No row is dropped.
- Duplicate items are merged with a pointer to the surviving item.
- The new file follows the structure standard.
- An independent reviewer compares the old and new files and reports missing or changed meaning.
- A human approves deletions, merges, and moves.

The size target never overrides completeness. If a file is too long, split it by domain or move the full analysis to `ai/artifacts/`. Do not delete nuance to hit a line count.

### What happens to hashes and checkpoint references

Removing a commit hash, branch name, checkpoint reference, or diary reference is allowed because it is workflow bookkeeping, not knowledge.

The repair must preserve the substantive evidence. If a claim depends only on a hash, the repair keeps a non-hash reference or moves the supporting evidence to an artifact. It does not silently drop the claim.

### What about long analyses

For a long analysis file:

- Move the full original to `ai/artifacts/` or `design-docs/`.
- Create a short knowledge file with the distilled rules, why, caveats, and verification.
- Record the move in the manifest.

The analysis is not lost. It is relocated. The knowledge file becomes usable for AI lookup.

### What cannot be guaranteed

An LLM may still miss a subtle meaning even with a manifest. That is why the process needs:

- a full backup
- an explicit disposition for every item
- an independent review
- human approval for lossy actions
- reversibility

With those, loss is detectable and recoverable. Without them, a tightening pass can quietly destroy knowledge.

**Open questions**

- Exact governing section name: `### Knowledge File Structure` under `## Project Knowledge Protocol`, or a shared `## Knowledge File Standards` section?
- Header shape: a visible blockquote before the H1, a bold line, or an HTML comment? Recommend a visible blockquote with a bold lead.
- Does the header apply to `issue-template.md`, which is a canonical template rather than a lesson?
- Size target: 100 lines (decided 2026-10-29).
- Where should long analyses move: `ai/artifacts/` or `design-docs/`; the protocol-name migration map moves to `docs/` as a shipped upgrade reference.
- Should `update global knowledge` write project findings too, or only promote? Recommend yes, so no finding is lost.
- Repair trigger name and aliases.
- Validator script or checklist?

**Acceptance criteria**

- The two update procedures share one capture and classification pass.
- The common policy defines the structure and the canonical header.
- Every knowledge file carries the header; a pre-write check and repair enforce it.
- The corpus has no tables, commit hashes, branch names, checkpoint or diary references, or context-file references.
- Long analyses are moved or distilled; knowledge files are tight and AI-first.
- The repair procedure audits and fixes with approval; no auto-rewrite; no data loss.
- The repair manifest maps every old item to a new location or an approved disposition; the backup is restorable; the new file adds no new claim.
- The README and the live docs carry the new banner and describe `repair knowledge files`.
- The checkpoint reports violations but does not rewrite knowledge.
- The knowledge update triggers and the repair procedure are documented and validated.
- The work follows the one-branch and one-squash process.

**Blast radius**

- `AGENTS.md`: checkpoint knowledge steps, housekeeping, and a repair procedure.
- `ai-policy-common.md`: knowledge protocols, structure, header, and table ban.
- `ai/shared/project-knowledge/*`: headers, distillation, and moves.
- `~/.ai/global-knowledge/*`: headers and table conversion.
- `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, and the setup or customization docs: the new banner and the `repair knowledge files` description.
- `support-files/` only if a validator is added.
- Release v5.4.0 with the sync fix and the lifecycle policy.

---
2026-10-29
Plan attached below.

## Implementation Plan

# Knowledge File Standards and Repair Plan

## Summary

Implement one shared knowledge pass, one AI-first knowledge file standard with a canonical visible header, a conservation-gated `repair knowledge files` procedure, a report-only checkpoint hygiene flag, and the project and global corpus repair. Ship the governance, the corpus repair, and the release documentation as one v5.4.0 release on one feature branch. The release covers the post-v5.3.0 changes: the visible protocol banner, the Matt Pocock backlog cleanup, the sync-script fix, the work-item lifecycle, and the knowledge work.

## Scope

### In scope

- `AGENTS.md`: the capture step, the project and global store steps, the pre-write header gate, the checkpoint hygiene flag, and the repair procedure.
- `ai/policies/ai-policy-common.md`: the shared knowledge file standards, the canonical header, and the repair conservation contract.
- `ai/shared/project-knowledge/`: the project corpus repair, with the final 9 lesson files plus the exempt template.
- `~/.ai/global-knowledge/`: the 21 old files repaired into 23 final files after the approved three-way split, outside git and not part of the commit.
- `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `docs/example-learning-session-runbook.md`, and `docs/examples/knowledge-base/`: the banner, the trigger, the standards, the upgrade action, and the examples.
- `docs/announcements/v5.4.0.md` and the v5.4.0 section in `ai/shared/project-knowledge/release-practices.md`.
- `design-docs/protocol-decisions.md`: the new decisions.
- `support-files/validate-protocol.sh`: the new procedure and step anchors.
- `ai/issues/in-progress/knowledge-file-standards-and-repair.md`, `ai/plans/knowledge-file-standards-and-repair-plan.md`, `ai/state/`, and `ai/daily-checkpoints/2026-10-29.md`.

### Out of scope

- No new validator script. The existing checklist and reviewers are the enforcement.
- No automatic knowledge rewrite at checkpoint. The checkpoint flags only.
- No change to `ai/shared/project-knowledge/issue-template.md`.
- No change to the design-docs location or the design-docs procedure.
- No release tag, push, or GitHub Release before the branch is merged and approved.
- No commit of `~/.ai/global-knowledge/` or the repair backups.
- No commit of the user's `ai/notes/notes.md` edits or the `ai/daily-checkpoints/2026-10-21.md` edits.

## Evidence

- `ai/issues/in-progress/knowledge-file-standards-and-repair.md`: 12 requirements, the knowledge conservation contract, acceptance criteria, and the blast radius.
- `AGENTS.md`: 361 lines. The checkpoint aliases are at 150-154, the project step at 188, the global step at 195, the housekeeping step at 196-199, the report at 200, state repair at 280-309, and the design-docs procedures at 311-343.
- `ai/policies/ai-policy-common.md`: 707 lines. The knowledge protocols are at 148-163, the checkpoint mandate at 88, content integrity at 162, state-file headers at 303-373, and the markdown table rule at 681-696.
- `ai/policies/ai-policy-meta.md`: 168 lines. The authoring standard is at 57-152, literal artifacts at 108-113, procedure headers at 115-129, and enforcement at 137-145.
- `design-docs/protocol-decisions.md`: 625 lines. The relevant decisions are the 2026-10-28 one-branch and plan-evidence entries, the 2026-10-27 literal-artifact and state-header entries, the 2026-10-18 authoring standard, the 2026-10-13 markdown-lint and no-em-dash entries, the 2026-10-12 table and ADR entries, and the 2026-10-06 JIT entry.
- `ai/policies/ai-policy-code-review.md`: 112 lines. Severity definitions are at 57-62 and the report format is at 66-99.
- Current project knowledge index: 16 files, 2,246 lines. The issue's 17-file count is incorrect; the current index is 16. Six files carry table lines: 19, 34, 45, 6, 82, and 6.
- Current global knowledge index: 21 old files, 538 lines; the audit split one three-lesson file into three, for 23 final files. `azure-private-dns-zone-group-record-ownership.md` carries 4 table lines. A grep found domain uses of branch and tag, not specific commit hashes, checkpoint references, or state-file paths; the global reference removal is expected to be a no-op.
- `README.md`: 381 lines. The announcement banner is line 1, the common instructions are 98-112, the context-health table is 156-174, and the file-naming guidance is 307-327.
- `docs/workflow-guide.md`: 406 lines, 22 numbered sections. Knowledge sections are 5-22, 253-273, and 275-323. Section 17 is 371-373.
- `docs/simple-ai-workflow-slides.md`: 424 lines. The feature list is 17-60 and the context-health material is 356-389.
- `docs/example-learning-session-runbook.md`: 222 lines. Step 11 is 198-210.
- `docs/examples/knowledge-base/css-architecture.md` and `style-guide.md`: 6 lines each. Both need the header and the structure.
- `docs/ai-customization-guide.md` and `docs/ai-customization.md`: 140 and 71 lines. Both describe customization and design docs, not knowledge updates; no change is planned.
- `docs/announcements/v5.3.0.md`: 23 lines. It is the format reference for the new announcement.
- `support-files/validate-protocol.sh`: 432 lines. It anchors procedures at 13-62 and has no knowledge-repair anchor.
- `support-files/test-protocol-references.sh`: 91 lines. It discovers procedures from `AGENTS.md` and checks references; a new procedure needs no test-code change.
- The v5.3.0 tag is before the visible banner, the Matt Pocock cleanup, the sync fix, the lifecycle work, and the knowledge work. The v5.4.0 release covers those post-tag changes.
- Git state: the branch is `feature/knowledge-file-standards-and-repair`. The ticket is in `in-progress/`. The state files and the 2026-10-29 diary are tracked and are part of the work-item commit. The user's notes and the 2026-10-21 diary are pre-existing edits and stay unstaged.

## HLD

### HLD-001: One knowledge pipeline

A session produces one finding list. The capture step classifies each finding as project, global, or both. The project store writes the project findings first. The global store reads the same list and promotes the global findings. A full checkpoint runs capture once, then the project store, then the global store.

### HLD-002: One standard and one visible header

The common policy owns one shared `## Knowledge File Standards` section for both knowledge directories. Every knowledge file starts with the same visible blockquote header before its H1. The standard defines the section shape, the content bans, the size target, the pre-write gate, and the exemptions.

### HLD-003: A conservation-gated repair

The repair procedure audits both stores, builds an item manifest, backs up the old file, writes a candidate to a temporary path, verifies the candidate against the manifest, gets independent review and human approval, and only then replaces the old file. A missing disposition blocks the repair.

### HLD-004: Corpus remediation

The project corpus is repaired in the branch. The global corpus is repaired in the same session but stays outside git. Long analyses move to `ai/artifacts/`, and distilled lessons stay in knowledge files. The repair procedure produces the per-file manifest and the split or move decisions.

### HLD-005: Documentation, release, and validation

The documentation explains the standard, the new trigger, and the one-time upgrade action. One v5.4.0 release covers the visible banner, the Matt Pocock cleanup, the sync fix, the work-item lifecycle, and this knowledge work. The existing validators, the authoring validator, the reference test, and markdownlint check the result.

## LLD

### LLD-001: Add `## Knowledge File Standards` to the common policy

- Place the section after `## Project Knowledge Protocol` and before `## Issue Management Protocol`.
- Apply it to every knowledge file in the **Global AI Knowledge Directory** and the **Project AI Knowledge Directory**.
- Exempt `issue-template.md`, because it is a canonical template, not a lesson.
- Exempt design documents that still live under `ai/shared/project-knowledge/`, because `ai-policy-design-docs.md` owns them.
- Require a descriptive H1.
- Require these H2 sections: `## Context`, `## Rule or Fix`, `## Why`, and `## Verify`.
- Allow an optional `## Caveats` section when a limitation exists.
- Require short sentences and flat bullets.
- Ban tables, nested bullets deeper than one level, and one file carrying multiple independent lessons.
- Ban a specific commit hash, branch name, checkpoint or diary date or title, and state-file path.
- Allow a domain term such as commit, branch, or checkpoint when the lesson needs it; the ban targets session bookkeeping.
- Ban secrets and identifying names.
- Set a 100-line soft target.
- Split a file or move a long analysis when it passes the target; never delete nuance to hit the target.
- Point at `## Knowledge Repair Conservation Contract` for repair.
- State that the checkpoint knowledge update checks the header before writing.

### LLD-002: Define the canonical knowledge header

- Add the header as a normative literal artifact in `## Knowledge File Standards`.
- Use this exact block:

```markdown
> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.
```

- Place the header before the H1, with one blank line after it.
- Copy it verbatim in every new or edited knowledge file.
- Replace the first blockquote line before the H1 with the canonical header during repair.
- Insert the header before the H1 when no blockquote exists.
- Check it before any knowledge update writes.
- Stop the write and direct the user to `repair knowledge files` when it is missing or mismatched.

### LLD-003: Add the shared capture step

- Add `STEP-KNOWLEDGE-CAPTURE` to `PROCEDURE WRITE-CHECKPOINT` before the project store.
- Collect decisions, root causes, investigation conclusions, constraints, identifiers, and external updates from the session.
- Classify each finding as project, global, or both.
- Record the finding, its classification, and its source once.
- Pass the list to the project step and the global step.
- Run the capture once in a full checkpoint.

### LLD-004: Rewire the project and global steps

- Keep `STEP-PROJECT-KNOWLEDGE-UPDATE` and `STEP-GLOBAL-KNOWLEDGE-UPDATE`.
- Make the project step write the project findings from the capture list.
- Make the global step read the same list and promote only the global findings.
- Remove the separate global evaluation.
- Define `STEP-KNOWLEDGE-HEADER-PRE-WRITE` once under the project store.
- Reference that step from the global store; do not define the name twice.
- Check the header before every write.
- Write new files with the header and the standard structure.
- Update the checkpoint report to say `updated`, `nothing to add`, or `failed` for each store.
- Replace the `**Single-step aliases**` paragraph at `AGENTS.md:154` with this rule: when the trigger is `update project knowledge`, run `STEP-KNOWLEDGE-CAPTURE` and `STEP-PROJECT-KNOWLEDGE-UPDATE`; when it is `update global knowledge`, run `STEP-KNOWLEDGE-CAPTURE`, `STEP-PROJECT-KNOWLEDGE-UPDATE`, and `STEP-GLOBAL-KNOWLEDGE-UPDATE`; skip the rest.
- Preserve the global step's guard: `If the Global AI Knowledge Directory does not exist, confirm and skip; do not create user-space directories unprompted.`
- Run a full checkpoint as capture, project store, global store, then the rest of the checkpoint.

### LLD-005: Add the checkpoint hygiene flag

- Extend `STEP-HOUSEKEEPING-AND-STALE-SCAN`.
- Check only the first header blockquote, the line count, and the table-line count with cheap shell reads.
- Report a missing header, a file over 100 lines, and a table line.
- Do not read file bodies at checkpoint for structure, duplicates, secrets, or one-lesson judgments.
- Defer the full content audit to `repair knowledge files`.
- State the token-cost boundary in the step.
- Keep the report-only rule: never rewrite, move, or delete a knowledge file at checkpoint.
- Keep the existing stale-knowledge flag.

### LLD-006: Add `PROCEDURE REPAIR-KNOWLEDGE-FILES`

- Add the procedure after `PROCEDURE REPAIR-STATE-FILES`.
- Use this exact header: `### PROCEDURE REPAIR-KNOWLEDGE-FILES: Audit and repair knowledge files with a conservation manifest`.
- Use this exact alias line: `**Aliases**: repair knowledge files; tidy knowledge files; heal knowledge files`.
- Treat `global`, `both`, and `dry run` as scope or option words after the trigger, not as aliases.
- Default the scope to the project store.
- Accept `repair knowledge files global`, `repair knowledge files both`, and `repair knowledge files dry run`.
- Add a `**Boundaries**` line: the procedure audits and repairs knowledge files only, never design documents or state files, and never runs at checkpoint.
- Add a `**Failure rule**`: refuse rather than corrupt; stop and ask when the manifest is incomplete, a disposition is missing, or a conflict appears.
- Load `ai-policy-common.md` and read `## Knowledge File Standards` and `## Knowledge Repair Conservation Contract` in step 1.
- Index both selected stores.
- Audit structure, tables, workflow references, secrets, size, one lesson per file, duplicates, and headers.
- Build the item manifest before any write.
- Report the proposed rewrite, split, merge, move, or delete.
- Stop after the report for a `dry run`.
- Copy the old project files to `ai/artifacts/knowledge-repair-<date>/project/` before any change.
- Copy the old global files to `~/.ai/knowledge-repair-backups/<date>/global/` before any change.
- Keep both backups outside git and outside the **Global AI Backups Directory**; the repair reads only the specific backup path it wrote.
- Keep the backups until the user confirms removal.
- Write the candidate to a temporary path; never overwrite the old file in the candidate phase.
- Verify the candidate against the manifest and the standards.
- Run independent peer review on the old and new files.
- Get human approval for every deletion, merge, move, or obsolete disposition.
- Replace the old file only after approval; restore the backup on failure.
- Move a long analysis in full to `ai/artifacts/` or `design-docs/`, then create the distilled knowledge file and record the move.
- Move the protocol-name migration map to `docs/` as a shipped upgrade reference; it is not a long analysis.
- Remove workflow bookkeeping references while preserving the substantive evidence.
- Record the project and global manifest and backup paths in the checkpoint and the diary.
- Never run automatically at checkpoint.

### LLD-007: Add the conservation contract to the common policy

- Treat every old file as a set of atomic items: fact, rule or decision, why, caveat, verification step, identifier, and example.
- Require one manifest row per old item with old ID, old location, new location, disposition, and a one-line reason.
- Allow the dispositions `new location`, `merged`, `moved`, `obsolete`, and `deleted with approval`.
- Block the repair when an old item has no disposition.
- Require the audit to be read-only.
- Require a full backup before the first change.
- Require a temporary candidate and a verification pass before replacement.
- Require every number, identifier, command, version, path, and error message to survive, unless it is explicitly obsolete.
- Require every why and caveat to have a home; the wording may shorten, the item may not disappear.
- Forbid a new claim in the repair; flag a correction for separate approval.
- Convert a table row by row; drop no row.
- Merge duplicates with a pointer to the surviving item.
- Require independent review of meaning and coverage.
- Require human approval for lossy actions.
- Keep the backup restorable.
- State that the size target never overrides completeness.
- Remove a specific hash, branch, checkpoint, diary, or state-file reference as bookkeeping; keep the evidence through a non-hash reference or an artifact.

### LLD-008: Repair the project and global corpus

#### Project corpus disposition

- `architectural-reflection-protocol-vs-plumbing.md`: keep; add the header; apply the four H2 sections; keep one lesson.
- `code-authoring-policy-design-analysis-2026-10-20.md`: move the full file to `ai/artifacts/`; create no distilled file; the shipped coding policy and the ADRs own the decisions.
- `coding-policy-cross-policy-coverage-reconciliation-2026-10-21.md`: move the full file to `ai/artifacts/`; create no distilled file; update the 2026-10-21 decision entry to point at the coding policy's committed `## References` and section-level pointers, and add a self-contained decision that the separate map is retired; no committed decision entry points into `ai/artifacts/`.
- `compaction-trigger-problem.md`: keep; add the header; apply the four H2 sections; keep one lesson.
- `local-first-knowledge-retrieval-proposal.md`: keep; add the header; apply the four H2 sections; remove the `ai/state/next-steps.md` reference; keep the issue pointer.
- `mattpocock-dictionary-of-ai-coding-analysis-2026-08-27.md`: move the full file to `ai/artifacts/`; remove it from knowledge; do not distill, because the 2026-10-27 decision drops the dictionary concepts.
- `mattpocock-sandcastle-codebase-analysis-2026-08-27.md`: move the full file to `ai/artifacts/`; remove it from knowledge; do not distill, because the 2026-10-27 decision drops Sandcastle.
- `mattpocock-skills-codebase-analysis-2026-08-27.md`: move the full file to `ai/artifacts/`; distill `agent-facing-document-hierarchy.md` and `out-of-scope-rejection-records.md` with the four H2 sections; mark the implemented or dropped items `merged` or `obsolete` in the manifest.
- `multi-agent-state-ownership-and-checkpoint-model.md`: move the full file to `ai/artifacts/`; create no distilled file; `ai-policy-common.md` and the ADRs own the rules.
- `multi-assistant-workflow-design.md`: move the full file to `ai/artifacts/`; create no distilled file; the open multi-assistant issue owns the draft.
- `protocol-name-migration-map-2026-10-06.md`: move it to `docs/protocol-name-migration-map-2026-10-06.md`, because it is a shipped upgrade reference; update the v4.0.0 announcement and the `release-practices.md` v4.0.0 entry.
- `protocol-routing-principle-and-consolidation-follow-up.md`: rename to `protocol-routing-principle.md`; apply the four H2 sections; keep the routing lesson; move the consolidation follow-up to the open consolidation issue; remove the state reference.
- `protocol-verification-toolchain.md`: keep; add the header; apply the four H2 sections; remove the state and context references; update the policy, procedure, step, and item counts to the post-change validator output.
- `refactoring-and-upgrading-best-practices-2026-08-25.md`: move the full file to `ai/artifacts/`; distill `upgrade-before-refactor.md` with the four H2 sections; mark the remaining research as `moved`.
- `release-practices.md`: keep as one release-process lesson; apply the four H2 sections; move the historical version sections to `ai/artifacts/release-history.md`; add the v5.4.0 section; keep the checklist; stay below 100 lines.
- `issue-template.md`: exempt from the header and the structure.
- Before any move or rename, grep every live file for the old filenames and update every pointer; the six open-issue pointers are in `ai/issues/open/per-agent-status-files-research.md`, `ai/issues/open/rename-meta-policy-to-protocol-developer.md`, `ai/issues/open/ai-team-runtime-dispatcher-watcher.md`, `ai/issues/open/multi-assistant-workflow-and-ai-team.md`, `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`, and `ai/issues/open/refactoring-and-upgrading-policy.md`.
- Point the six live issues at the new durable home: the policy or ADR for the state and design notes, the distilled lesson for the research notes, and the docs map for the migration map.
- Exclude closed tickets, daily checkpoints, review reports, and artifacts from the pointer sweep.

#### Final project set

- The final knowledge set is 9 lesson files plus the exempt `issue-template.md`, 10 files in the directory.
- The 9 lesson files are the 6 kept files and the 3 distilled files: the kept files are `architectural-reflection-protocol-vs-plumbing.md`, `compaction-trigger-problem.md`, `local-first-knowledge-retrieval-proposal.md`, `protocol-routing-principle.md`, `protocol-verification-toolchain.md`, and `release-practices.md`; the distilled files are `agent-facing-document-hierarchy.md`, `out-of-scope-rejection-records.md`, and `upgrade-before-refactor.md`.
- Back up the full old corpus to `ai/artifacts/knowledge-repair-2026-10-29/project/` before the first change.

#### Global corpus

- Add the header to all 23 final global files; the original 21 include one three-lesson file that splits into three.
- Restructure all 23 into `## Context`, `## Rule or Fix`, `## Why`, and `## Verify`; add `## Caveats` only when a limitation exists.
- Convert the table in `azure-private-dns-zone-group-record-ownership.md` row by row.
- Remove specific workflow references; the audit expects a no-op because the grep found domain uses only.
- Keep one lesson per file and stay below 100 lines; split a file only if the audit finds a real second lesson.
- Back up the full old global corpus to `~/.ai/knowledge-repair-backups/2026-10-29/global/` before the first change.
- Leave the global changes outside git and record the local repair in the checkpoint and diary.

### LLD-009: Update the documentation and the examples

- Add a `"repair knowledge files"` row to the README common instructions.
- Add a knowledge file standards section to the README, or extend the file-naming section, with the header, structure, 100-line target, bans, repair scope, and conservation contract.
- Update the README context-health table and the one-checkpoint explanation.
- Add the one-time upgrade action to the README update steps and the announcement: run `"repair knowledge files"` after upgrading, and run `"repair knowledge files global"` if the user keeps global knowledge.
- Write the v5.4.0 README banner with the release name, the knowledge standards, and the `repair knowledge files` trigger, and link it to the announcement.
- Append `## 23. Knowledge File Standards and Repair` to `docs/workflow-guide.md`; do not renumber the existing sections.
- Update the workflow guide sections on project knowledge, global knowledge, token rationing, the checkpoint, and state repair with cross-references to the new section.
- Add the new trigger, the header, the standards, and the conservation contract to the slides.
- Update the example learning session Step 11 prompt and expected outcome to create knowledge files with the header and structure.
- Update the two `docs/examples/knowledge-base/` files to demonstrate the header and the structure.
- Leave `docs/ai-customization-guide.md` and `docs/ai-customization.md` unchanged; they do not describe knowledge updates.
- Write `docs/announcements/v5.4.0.md` in the v5.3.0 announcement style.
- Point the README banner at the v5.4.0 announcement.

### LLD-010: Prepare one v5.4.0 release

- Add a `## v5.4.0 (2026-10-29)` section to `release-practices.md`.
- Cover the visible protocol banner, the Matt Pocock backlog cleanup, the sync-script self-exclusion fix, the work-item branch and plan lifecycle, and the knowledge file standards and repair.
- Note that the banner and the cleanup landed after the v5.3.0 tag and are included in this release.
- Keep the release documentation on the feature branch.
- Tag the release commit after the squash merge.
- Publish the GitHub Release after the tag.
- Keep the announcement friendly and short; the GitHub Release is the exhaustive changelog.

### LLD-011: Validate the change

- Add the `PROCEDURE REPAIR-KNOWLEDGE-FILES` anchor and the `STEP-KNOWLEDGE-HEADER-PRE-WRITE` anchor to `support-files/validate-protocol.sh`.
- Run `support-files/validate-protocol.sh` and keep 8/8.
- Run `support-files/validate-policy-authoring.sh` on `AGENTS.md` and `ai-policy-common.md`.
- Run `support-files/test-protocol-references.sh`.
- Run markdownlint on the linted set, including the new announcement, the project knowledge corpus, and the docs.
- Audit both knowledge corpora for headers, the four H2 sections, tables, workflow references, size, and one lesson per file.
- Grep every live file for the old filenames and confirm no unresolved pointer remains outside the historical and local-only directories.
- Run a fixture-based repair dry run with a table, a hash, and a missing header; confirm the manifest, the no-write path, the candidate, and the restore.
- Simulate a headerless knowledge file in the store path; confirm the pre-write gate stops.
- Simulate a table and a long file in the checkpoint; confirm the flag reports and does not rewrite.
- Run the implementation peer review and fix every Critical and Major finding.

### LLD-012: Keep the work on one branch and one ticket

- Keep the branch `feature/knowledge-file-standards-and-repair`.
- Keep the ticket in `ai/issues/in-progress/`.
- Append the plan file name to the ticket as a dated comment.
- Run the plan peer review before implementation.
- Keep the implementation, tests, documentation, release announcement, ADRs, ticket close, plan appendix, and checkpoint on the branch.
- Attach the plan under `## Implementation Plan`, replace the plan link with `Plan attached below.`, and delete the plan file.
- Close the ticket on the branch.
- Run the checkpoint after the ticket close and the plan appendix, immediately before the squash merge.
- Commit the work-item files, the state files, and the 2026-10-29 diary with the squash commit.
- Leave the user's `ai/notes/notes.md` and `ai/daily-checkpoints/2026-10-21.md` edits unstaged.
- Do not commit `~/.ai/global-knowledge/`, `~/.ai/knowledge-repair-backups/`, or `ai/artifacts/knowledge-repair-2026-10-29/`.
- Squash merge, delete the branch, push, tag v5.4.0, and publish the release after approval.

### LLD-013: Record the decisions

- Add a decision entry for the shared standards section and the canonical header.
- Add a decision entry for the shared capture pass and the global promotion.
- Add a decision entry for the conservation contract and the approval-gated repair.
- Add a decision entry for the 100-line soft target.
- Add a decision entry for the no-new-script choice.
- Add a decision entry for the same-branch corpus repair, the user-space global boundary, and the user-space global backup.
- Add a decision entry for the single v5.4.0 release.
- Add a decision entry for the `issue-template.md` and design-document exemptions.
- Update the 2026-10-21 coverage-map entry to point at the coding policy's committed `## References` and section-level pointers.
- Add a self-contained decision that the separate coverage map is retired from the shipped corpus; the coding policy's `## References` and section-level pointers are the durable home.
- Apply the self-contained ADR standard; use no commit hash, branch name, or non-committed artifact pointer.

## Acceptance Criteria

- AC-001: `update project knowledge` and `update global knowledge` consume one capture and classification list, in project-then-global order; a full checkpoint runs both stores in that order. Traces to LLD-003 and LLD-004.
- AC-002: The common policy defines the shared structure, the canonical header, the 100-line target, the bans, the pre-write gate, and the exemptions. Traces to LLD-001 and LLD-002.
- AC-003: Every final knowledge file carries the header; the store checks it before writing; a missing or mismatched header stops the write; the repair restores it. Traces to LLD-002, LLD-004, and LLD-006.
- AC-004: The final project corpus is the 9 lesson files plus the exempt template; every lesson file carries the four H2 sections; no table, workflow reference, secret, or multiple-lesson file remains; long analyses are moved or distilled. Traces to LLD-008.
- AC-005: All 23 final global files carry the header and the four required sections; the table and any specific workflow references are removed. Traces to LLD-008.
- AC-006: The repair produces a manifest with a disposition for every old item, backs up the old file, writes a candidate, verifies that every number, identifier, command, version, path, error, why, and caveat survives, adds no new claim, converts tables row by row, gets independent review and human approval, and leaves a restorable backup. Traces to LLD-006 and LLD-007.
- AC-007: The checkpoint reports a missing header, a table line, and a file over 100 lines with cheap checks and never rewrites a knowledge file; the content audit is repair-only. Traces to LLD-005.
- AC-008: The README, workflow guide, slides, runbook, examples, and announcement describe the standard, the trigger, and the one-time upgrade action. Traces to LLD-009.
- AC-009: The release is one v5.4.0 covering the visible banner, the Matt Pocock cleanup, the sync fix, the lifecycle work, and the knowledge work. Traces to LLD-010.
- AC-010: The validator, the authoring validator, the reference test, and markdownlint pass; no new validator script is added. Traces to LLD-011.
- AC-011: The work uses one branch, one squash commit, one closed ticket with the attached plan, and one checkpoint after the ticket close on the branch. Traces to LLD-012.
- AC-012: The new decisions are in the decision store and are self-contained; no committed decision entry points into `ai/artifacts/`. Traces to LLD-013.
- AC-013: A fixture dry run proves the manifest, the no-write path, the candidate, the restore, the pre-write stop, and the report-only checkpoint flag. Traces to LLD-011.
- AC-014: The global backup lives outside the project and outside the **Global AI Backups Directory**, and its restore is tested. Traces to LLD-006, LLD-008, and LLD-011.

## ADRs

### ADR-001: Shared standards section and canonical visible header

Decision: The common policy owns one `## Knowledge File Standards` section for both knowledge stores, and every knowledge file carries the same visible blockquote header before its H1.

Context: The two stores had no shared structure, and a model editing a file had no in-file authority pointer.

Consequence: Both stores follow one structure, and the header is the rule pointer that travels with the file. The `issue-template.md` and design documents are exempt.

### ADR-002: One capture pass, one finding list

Decision: The checkpoint captures and classifies findings once, the project store writes first, and the global store promotes from the project list.

Context: The two stores evaluated separately and could reach different conclusions.

Consequence: No finding is lost between stores, and the global store never invents a separate list.

### ADR-003: Conservation-gated repair

Decision: The repair procedure uses an item manifest, a full backup, a temporary candidate, verification, independent review, and human approval before replacement.

Context: A rewrite can silently drop a number, a why, or a caveat.

Consequence: Loss becomes explicit, reviewable, and reversible. An item without a disposition blocks the repair.

### ADR-004: 100-line soft target

Decision: Knowledge files use a 100-line soft target.

Context: The ticket's draft said about 120 lines; the approved target is 100, recorded in the ticket update.

Consequence: A long analysis splits or moves, and the target never overrides completeness.

### ADR-005: No new validator script

Decision: The enforcement is the existing checklist plus review, not a new script.

Context: The issue left the validator open; the existing toolchain already covers the protocol and authoring shape.

Consequence: The operating surface stays small, and the knowledge audit is procedural and reviewed.

### ADR-006: Repair the corpus on the same branch, keep global knowledge local

Decision: The project corpus is repaired and committed on the feature branch; the global corpus is repaired in the same session but stays in user space and out of the commit. Project backups live in `ai/artifacts/`; global backups live in `~/.ai/knowledge-repair-backups/`. Long analyses move to `ai/artifacts/` or `design-docs/`; the protocol-name migration map moves to `docs/` as a shipped upgrade reference.

Context: The issue requires both corpora to comply, but global knowledge is not repository content and the project artifacts directory is purgeable. The migration map is a live upgrade reference, not a lesson.

Consequence: The branch carries the shipped corpus; the user's global store is repaired locally with a durable backup and recorded in the checkpoint.

### ADR-007: One v5.4.0 release

Decision: Ship the visible banner, the Matt Pocock cleanup, the sync fix, the lifecycle work, and the knowledge standards and repair as one v5.4.0 minor release.

Context: The user chose one release over several small ones.

Consequence: The announcement and the release-practices entry cover all five changes; the tag and GitHub Release follow the merge.

### ADR-008: Exempt non-lesson artifacts

Decision: `issue-template.md` and design documents in the fallback location are exempt from the knowledge header and structure.

Context: Both are canonical or owned by another policy, not lessons.

Consequence: The standard applies to knowledge files, and the design-docs policy keeps ownership of design documents.

## Test Plan

- Run `bash support-files/validate-protocol.sh` and confirm 8/8.
- Run `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md` and confirm PASSED.
- Run `bash support-files/test-protocol-references.sh` and confirm PASS.
- Run markdownlint on the linted set, including `README.md`, `docs/`, `ai/shared/project-knowledge/`, `ai/issues/`, and `ai/state/`.
- Confirm the knowledge header and the four H2 sections in all 9 project lesson files and all 23 final global files, excluding the exempt template.
- Confirm no table line remains in either knowledge store.
- Confirm no specific workflow reference remains in either knowledge store.
- Confirm every final knowledge file is at or below 100 lines.
- Grep every live file for the old filenames and confirm no unresolved pointer remains outside the historical and local-only directories.
- Grep `design-docs/protocol-decisions.md` for `ai/artifacts/`; confirm the only match is the lint-exemption rule, not a decision pointer.
- Run the repair audit and confirm the manifest covers every old item.
- Confirm the project and global backups exist and restore.
- Confirm the candidate adds no new claim.
- Run the fixture dry run for the manifest, the no-write path, the candidate, and the restore.
- Simulate a headerless file in the store path and confirm the pre-write gate stops.
- Simulate a table and a long file in the checkpoint and confirm the report-only flag.
- Run the independent meaning review and the implementation peer review.
- Confirm no secret or identifying name enters the commit.

## Release Plan

- Release version: v5.4.0.
- Release theme: one knowledge standard, one repair path, and the accumulated changes since v5.3.0.
- Release contents: the visible protocol banner, the Matt Pocock backlog cleanup, the sync-script self-exclusion fix, the work-item branch and plan lifecycle, the knowledge file standards and repair, the project corpus repair, and the documentation.
- Upgrade action in the announcement and README: run `"repair knowledge files"` once after upgrading; run `"repair knowledge files global"` if the user keeps global knowledge.
- Release documentation on the branch: README banner, announcement, release-practices section, workflow guide, slides, runbook, and examples.
- After the merge: tag the release commit, push the tag, and publish the GitHub Release.
- The global knowledge repair and its backup are local to this user and are not part of the release artifact.

## Risks and Mitigations

- Data loss during corpus repair: manifest, backup, candidate, verification, independent review, and approval.
- A purgeable global backup: store it in user space, outside the project artifacts and the backups directory, and test the restore.
- A wrong one-lesson split: audit the file, propose the split, and get approval before writing.
- A global repair that surprises the user: default the scope to project, and require an explicit `global` or `both` scope.
- A header mismatch during a checkpoint: stop the write and direct the user to the repair procedure.
- A checkpoint that reads too much: limit the flag to header, line count, and table lines; defer content judgments to repair.
- Scope creep from the corpus: repair in phases and keep the release notes to the five themes.
- Release-scope drift: use one release section and one announcement.
- A false positive on the workflow-reference ban: define the ban as specific bookkeeping references, not domain terms.
- A dirty branch: commit the state files and the 2026-10-29 diary; leave only the user's pre-existing edits unstaged.

## Work Sequence

1. Review and approve this plan.
2. Update the ticket's 100-line target, 16-file count, and backup path.
3. Add the common policy standards, the header, and the conservation contract.
4. Add the capture step, the store rewiring, the pre-write gate, the hygiene flag, and the repair procedure to `AGENTS.md`.
5. Add the validator anchors and the ADR entries.
6. Repair the project corpus with the manifest, backup, candidate, verification, review, and approval.
7. Repair the global corpus with the same gates, outside git.
8. Update the docs, the examples, the announcement, and the release-practices section.
9. Run the validators, markdownlint, and the fixture tests.
10. Run the implementation peer review; fix every Critical and Major finding; re-review.
11. Attach the plan to the ticket, replace the plan link, delete the plan file, and close the ticket.
12. Run the checkpoint on the branch.
13. Squash merge, delete the branch, push, tag v5.4.0, and publish the release after approval.

## Peer Review Log

- Round 1: 2026-10-29 13:17, independent reviewer, report `ai/code-review-reports/2026-10-29_13-17_review-10.md`, verdict CHANGES REQUESTED. Findings fixed: global backup moved to user space; migration map kept in docs; complete corpus dispositions and final set added; global structure rewrite planned; checkpoint moved after the close; commit boundary defined; single-step aliases and global guard named; aliases and scope syntax defined; conservation ACs expanded; 100-line target recorded; release covers the banner and cleanup; upgrade action added; hygiene flag bounded; capture order added; minor and suggestion items folded in.
- Round 2: 2026-10-29 13:25, independent reviewer, report `ai/code-review-reports/2026-10-29_13-25_review-11.md`, verdict CHANGES REQUESTED. Findings fixed: the four H2 sections now apply to every final lesson file; the coding reconciliation moved to artifacts; the final set is 9 lessons plus the template; the six live issue pointers and the v4.0.0 references are swept; the pre-write step is defined once; long analyses align to `ai/artifacts/` or `design-docs/`; the migration map docs destination is recorded; the four-section audit and the pointer sweep are in the Test Plan.
- Round 3: 2026-10-29 13:29, independent reviewer, report `ai/code-review-reports/2026-10-29_13-29_review-12.md`, verdict CHANGES REQUESTED. Finding fixed: the coding coverage map retirement now updates the 2026-10-21 decision entry to the coding policy's committed references, adds a self-contained retirement decision, and adds a check that no decision entry points into `ai/artifacts/`.
- Round 4: 2026-10-29 13:31, independent reviewer, report `ai/code-review-reports/2026-10-29_13-31_review-13.md`, verdict CHANGES REQUESTED. Finding fixed: the retirement decision now says the map is retired from the shipped corpus and the coding policy's references are the durable home; it no longer puts the artifact path in the decision store.
- Round 5: 2026-10-29 13:32, independent reviewer, report `ai/code-review-reports/2026-10-29_13-32_review-14.md`, verdict APPROVED. No Critical or Major findings remain. The plan is ready for implementation.
- Implementation note: the global audit found one file with three independent lessons and split it into three, so the final global set is 23; LLD-008 authorizes the split.
