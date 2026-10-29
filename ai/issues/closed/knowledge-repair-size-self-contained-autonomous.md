Reported: 2026-10-29
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P1)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Replace the line-based, split-heavy, question-asking knowledge repair with size-based limits, self-standing files, and autonomous cleanup.

Description:

The v5.4.0 knowledge repair failed in a live project. A 59-file knowledge base became 233 files. The 100-line target and the one-lesson-per-file rule forced splits. The repair also asked approval questions, and it left or created cross-file references to artifacts, backups, docs, policies, and state files.

Live evidence:

- The live project's old files average 13 KB; the largest is 66 KB.
- The v5.4.0 run expanded 59 files to 233.

Decisions made 2026-10-29:

- Use size, not lines. Soft target 10 KB; review trigger 15 KB. Measure bytes.
- Never split a knowledge file. Trim and merge only. The repair must not increase the file count.
- A checklist file stays one file. The 15 KB review applies, but the repair never splits it.
- At 15 KB, the review is automatic cleanup. No user question.
- The repair asks no user question. It removes defined garbage and duplicates, preserves ambiguous content, and reports at the end.
- A knowledge file is self-standing. It contains the facts, rules, reasons, and checks that belong to it. It does not point at another knowledge file, code file, doc, policy, artifact, backup, or state file. A domain command or system path that is the subject of the lesson is content, not a cross-file reference.
- The canonical header is self-contained. It does not name another file.
- Project knowledge may keep identifying names. Global knowledge must remove them. Raw secrets stay banned in both stores.
- Remove the one-lesson-per-file rule. That rule caused the 59-to-233 split.

Blast radius:

- `ai/policies/ai-policy-common.md`: the knowledge standards, header, size, self-standing rule, sensitive scope, and repair-trigger approval exception.
- `ai/policies/ai-policy-design-docs.md`: remove the one-line source pointer.
- `AGENTS.md`: the checkpoint size flag and the repair procedure, including the no-question and no-split rules.
- `support-files/validate-protocol.sh`: anchors for the new or renamed steps.
- `support-files/test-knowledge-repair-fixture.sh`: an isolated fixture generator and verifier; the fixture lives in a temporary directory.
- `ai/shared/project-knowledge/`: the repo's project knowledge files made self-standing; no split; project names may stay.
- `~/.ai/global-knowledge/`: self-standing; sensitive names removed; secrets removed.
- `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `docs/example-learning-session-runbook.md`, `docs/examples/knowledge-base/`, `docs/announcements/v5.4.0.md`, `docs/announcements/v5.4.1.md`, and `ai/shared/project-knowledge/release-practices.md`.
- `design-docs/protocol-decisions.md`.
- `ai/issues/in-progress/knowledge-repair-size-self-contained-autonomous.md` and the plan.

Acceptance criteria:

- AC-1: The standard uses a 10 KB soft target and a 15 KB automatic review trigger, measured in bytes; no line target.
- AC-2: The repair never splits a file and never increases the file count; it trims and merges.
- AC-3: A checklist file stays one file; the 15 KB review applies; no split.
- AC-4: The 15 KB review runs automatic cleanup without a user question.
- AC-5: The repair asks no user question; it removes defined garbage and duplicates, preserves ambiguous content, and reports. An incomplete manifest leaves the file unchanged and reports.
- AC-6: Every knowledge file is self-standing; no cross-file pointers; the header is self-contained; domain commands, system paths, and checklist output paths are allowed as lesson content.
- AC-7: Project knowledge may keep identifying names; global knowledge removes them; raw secrets are banned in both. An identifying name means a person, client, employer, or customer; technology vendor and product names stay.
- AC-8: The one-lesson rule is removed; the split and move-to-artifact path is removed; every split instruction and decision is replaced or marked superseded.
- AC-9: The repo's project and global knowledge corpora comply; an isolated, repeatable fixture test proves the 59-to-233 failure cannot recur and does not touch the real stores.
- AC-10: The docs, announcement, release practices, ADRs, and v5.4.1 release are updated.
- AC-11: Validators, lint, independent plan review, and implementation review pass.
- AC-12: The common policy's side-effect, restructure, and content-integrity rules carry the repair-trigger exception.
- AC-13: `dry run` stops after the manifest and writes nothing.
- AC-14: Replacement is per file and requires a complete manifest and an `APPROVED` review; aborted and review-failed files stay unchanged.

Open questions:

- None. The decisions are fixed. The release is v5.4.1.

---
2026-10-29
Plan attached below.

---
2026-10-29
The plan is the detailed contract. The blast radius and acceptance criteria are aligned with it. The fixture is generated in a temporary directory and does not touch the real stores.

## Implementation Plan

# Knowledge Repair Size, Self-Containment, and Autonomy Plan

## Summary

Replace the v5.4.0 knowledge repair behavior with size-based limits, self-standing files, no splitting, and autonomous cleanup. The new standard uses a 10 KB soft target and a 15 KB automatic review trigger, measured in bytes. The repair never splits a file, never increases the file count, asks no user questions, preserves ambiguous content, and reports at the end. Project knowledge may keep identifying names; global knowledge removes them; raw secrets stay banned in both. Ship the correction as v5.4.1 on one branch.

## Scope

### In scope

- `ai/policies/ai-policy-common.md`: the size limits, self-standing rule, new header, checklist rule, no-split rule, sensitive-name scope, repair conservation contract, and the repair-trigger approval exception.
- `ai/policies/ai-policy-design-docs.md`: remove the one-line source pointer from the extracted design document flow.
- `AGENTS.md`: the checkpoint size flag and the autonomous repair procedure.
- `support-files/validate-protocol.sh`: anchors for the new or renamed repair steps.
- `support-files/test-knowledge-repair-fixture.sh`: an isolated fixture generator and verifier; it creates the fixture in a temporary directory outside the linted tree.
- `ai/shared/project-knowledge/`: the repo's 9 lesson files plus the exempt template, made self-standing and header-compliant; no split.
- `~/.ai/global-knowledge/`: the 23 global files, made self-standing; identifying names and secrets removed; no split.
- `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `docs/example-learning-session-runbook.md`, `docs/examples/knowledge-base/`, `docs/announcements/v5.4.0.md`, `docs/announcements/v5.4.1.md`, and `ai/shared/project-knowledge/release-practices.md`.
- `design-docs/protocol-decisions.md`.
- `ai/issues/in-progress/knowledge-repair-size-self-contained-autonomous.md` and the plan.

### Out of scope

- No knowledge-file splitting.
- No move of a knowledge file to artifacts or design-docs.
- No user approval or question inside the repair procedure.
- No history rewrite.
- No state-file header change.
- No commit of the user's `ai/notes/notes.md` or `ai/daily-checkpoints/2026-10-21.md` edits.
- No mutation of the real `~/.ai/global-knowledge/` during the fixture test.

## Evidence

- The user ran the v5.4.0 repair on a live project: 59 knowledge files became 233. The old files average 13 KB; the largest is 66 KB. This is the primary failure evidence.
- `ai/policies/ai-policy-common.md`: 768 lines. `## Knowledge File Standards` is at 185-204. The current rules require one lesson, a 100-line cap, splitting or moving long analyses, and a header that points at `ai-policy-common.md`. The secret and identifying-name ban is at 199. The header literal is at 215. The conservation contract starts at 218 and still includes a merge pointer, artifact evidence, and moving a long analysis to artifacts.
- `AGENTS.md`: 378 lines. The checkpoint knowledge line is at 195 and flags more than 100 lines. `PROCEDURE REPAIR-KNOWLEDGE-FILES` starts at 308; its failure rule says stop and ask at 314; `STEP-APPROVE-KNOWLEDGE-REPAIR` asks for human approval at 325.
- The current header points at another file: it starts with `> **Knowledge file.** Follow` and names `ai-policy-common.md`. That violates the new self-standing rule.
- The split language is not confined to the knowledge standard. The Global Knowledge Protocol, the README's global-knowledge guidance, and the 2026-10-06 decision still describe splitting. The v5.4.0 announcement still describes the 100-line target, one lesson, and asking before changes. These all need a disposition.
- `ai/policies/ai-policy-design-docs.md`: the extracted-document flow requires the source knowledge file to keep a one-line pointer to the extracted design document. The self-standing rule bans that pointer.
- `README.md` is 396 lines; `docs/workflow-guide.md` 430; `docs/simple-ai-workflow-slides.md` 436; `docs/example-learning-session-runbook.md` 223; `docs/announcements/v5.4.0.md` 39; `release-practices.md` 61.
- Current project knowledge: 10 files, 9 lesson files plus the exempt template. Current global knowledge: 23 files.
- Current cross-file pointers exist in `release-practices.md`, `protocol-routing-principle.md`, `compaction-trigger-problem.md`, and `protocol-verification-toolchain.md`; the issue template is exempt. The global `naming-conventions.md` has external links; the GitLab runner and shell notes have domain paths that are lesson content.
- The reference test currently reports 12 procedures and 93 steps; the repair step changes will require a count refresh in `protocol-verification-toolchain.md`.
- The live project report is the source for the average and maximum size; the files were not copied into this repository.
- User decisions 2026-10-29: 10 KB soft, 15 KB review; never split; checklist stays one file; automatic cleanup at 15 KB; no user questions; preserve ambiguous; self-standing; project names may stay; global names removed; secrets banned everywhere.
- The v5.4.0 release is published. The new work is a v5.4.1 patch release.

## HLD

### HLD-001: Size-based standard

Replace the line target and one-lesson rule with a 10 KB soft target and a 15 KB review trigger. Measure bytes with `wc -c`. Keep the file together at every size. The checklist is one file.

### HLD-002: Self-standing knowledge

Every knowledge file contains the facts, rules, reasons, and checks it needs. It does not point at another knowledge file, code file, doc, policy, artifact, backup, or state file. A domain command, a system path, or a checklist output path that is the subject of the step is content. A pointer for more context is not content. The canonical header is self-contained.

### HLD-003: Autonomous, no-split repair

The repair audits, cleans, merges, compresses, and reports without asking the user. It never splits a file and never increases the file count. It removes defined garbage and duplicates, preserves ambiguous content, backs up the old files, verifies the result, runs an independent review, and replaces the files only after an `APPROVED` verdict. A 15 KB file gets the automatic review in the same run.

### HLD-004: Safe automation

The repair has a no-question abort: when the manifest is incomplete or an item has no disposition, it leaves that file unchanged, reports the conflict, and continues with the other files. An ambiguous item is preserved. A failed independent review blocks replacement and triggers a fix or a no-replace report.

### HLD-005: Scoped sensitive handling

Project knowledge may keep identifying names. Global knowledge removes identifying names. Raw secrets are banned in both. The project store is normally outside git; a tracked knowledge file still follows the commit guardrail.

### HLD-006: Corpus, docs, and v5.4.1

The repo's project and global corpora are made self-standing. The docs, announcement, release practices, ADRs, and release notes describe the new behavior. The correction ships as v5.4.1.

## LLD

### LLD-001: Rewrite `## Knowledge File Standards`

- Replace the 100-line target with a 10,000-byte soft target.
- Add a 15,000-byte automatic review trigger.
- Remove the one-lesson rule.
- Remove the split and move-to-artifact instructions.
- State that a file never splits and the repair never increases the file count.
- State that a checklist stays one file; the 15 KB review applies; the repair never splits it.
- Add the self-standing rule.
- Ban pointers to another knowledge file, code file, doc, policy, artifact, backup, or state file.
- Allow a domain command, system path, or a path that a checklist step writes or edits; a pointer for more context is not content.
- Keep the four H2 sections: `## Context`, `## Rule or Fix`, `## Why`, and `## Verify`; a checklist uses the same shape with the checklist under `## Rule or Fix`.
- Replace the header with the self-contained header.
- Keep the table ban, the flat-bullet rule, the no-secret rule, and the no-session-bookkeeping rule.
- Describe table cleanup as markup removal plus row preservation, not content deletion.
- Replace the identifying-name ban with the scoped rule: project may keep, global must remove.
- Define an identifying name as a person, client, employer, or customer; a technology vendor or product name is lesson content and stays.
- Clarify the git commit guardrail: a tracked knowledge file still follows the commit scan; a git-ignored project knowledge file may keep identifying names.
- Identify the `repair knowledge files` trigger as the explicit approval for the repair's merges, trims, and restructures; the repair asks no further question.
- Add that exception to the common policy's side-effect, restructure, and content-integrity rules.
- Keep the header pre-write check.
- Point to the repair procedure for cleanup.

### LLD-002: Replace the canonical header

- Use this exact block:

```markdown
> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.
```

- Place the header before the H1.
- Designate it a normative literal artifact.
- The header names no file.
- The repair restores it.
- The store pre-write check stops on a missing or mismatched header.

### LLD-003: Rewrite the repair conservation contract

- Keep the item manifest, backup, candidate, verification, and independent review.
- Remove human approval and user questions.
- Define the dispositions: `kept`, `merged`, `trimmed`, `removed as defined garbage`, `preserved ambiguous`, and `aborted unchanged`.
- Define garbage: recording or learned dates, commit hashes, branch names, checkpoint and diary references, state-file paths, artifact and backup pointers, cross-file pointers (except a path that a checklist step writes or edits), table markup, and duplicate content.
- Convert every table row to a flat bullet; preserve a row that has no home and report it.
- Preserve every fact, rule, why, caveat, verification, identifier, and example that is not defined garbage.
- Preserve an ambiguous content item and report it.
- Treat a cross-file pointer as never ambiguous: resolve the needed fact into the file, or abort the file unchanged and report; never preserve the pointer.
- Merge a duplicate into the survivor with no pointer.
- Do not keep evidence in an artifact or move a long analysis to an artifact; keep the file together.
- Add the self-standing check.
- Add the sensitive-name check: global removes; project keeps; secrets banned in both.
- Add the no-split and file-count checks.
- Add the 10 KB soft and 15 KB review check.
- Build the manifest in memory; write it to `ai/artifacts/knowledge-repair-<date>/manifest.md` only for a non-dry run after the dry-run check.
- Keep the backup restorable; record the manifest path, the project backup path, and the global backup path in the checkpoint and diary.
- Keep the no-new-claim rule.
- Keep the abort: an incomplete manifest or an item with no disposition leaves the file unchanged and reports; it does not ask.

### LLD-004: Rewrite `PROCEDURE REPAIR-KNOWLEDGE-FILES`

- Keep the procedure name and the three aliases.
- Keep the project, global, both, and dry-run scope words.
- Remove the failure rule that stops and asks; replace it with the no-question abort: leave the affected file unchanged and report.
- Replace `STEP-APPROVE-KNOWLEDGE-REPAIR` with `STEP-REPLACE-KNOWLEDGE-REPAIR`.
- Change the steps to:
  1. Load the rules.
  2. Resolve the scope.
  3. Index and read the selected files.
  4. Audit size, header, tables, cross-file pointers, sensitive scope, duplicates, and split risk.
  5. Build the manifest in memory with no user approval; assign a disposition to every item; stop a file with no disposition unchanged.
  6. If the scope includes `dry run`, report the dispositions from memory and stop; write and replace nothing.
  7. Write the manifest to `ai/artifacts/knowledge-repair-<date>/manifest.md`, then back up the project files to `ai/artifacts/knowledge-repair-<date>/project/` and the global files to `~/.ai/knowledge-repair-backups/<date>/global/`.
  8. Write the candidate: remove defined garbage, inline needed short facts, remove every cross-file pointer except a path that a checklist step writes or edits, convert every table row, merge duplicates with no pointer, compress, replace the header, remove raw secrets, keep project names, remove global names, never split.
  9. Run the 15 KB automatic review in the same candidate: remove garbage and duplicates, compress, report the final size; if the file remains over 15 KB, keep it one file and report it.
  10. Verify: every item, no new claim, no cross-file pointers, self-standing, header, no split, file count not increased, size, project/global sensitive scope, secrets.
  11. Run the independent review; require an `APPROVED` verdict. On `CHANGES REQUESTED`, fix and re-review. If it cannot pass without content loss, leave the old file unchanged and report.
  12. Replace only the files with a complete manifest and an `APPROVED` review; leave aborted and review-failed files untouched; restore the backup on failure.
  13. Report the files, merges, trims, preserved ambiguous items, aborted files, manifest and backup paths, and sizes without asking a question.
- State that a checklist stays one file.
- State that a file over 15 KB after cleanup stays one file and is reported.
- State that the repair may merge duplicate or overlapping files but never splits one.
- State that a project file keeps identifying names and a global file removes them.
- State that raw secrets are removed in both scopes.
- Keep the `dry run` option; it is a user-chosen option, not a question.

### LLD-005: Update the checkpoint flag

- Replace the more-than-100-lines flag with more-than-15,000-bytes.
- Keep the missing-header and table-line flags.
- Use cheap header, `wc -c`, and table-line checks; do not read file bodies at checkpoint.
- The checkpoint reports and points to `repair knowledge files`; it does not edit, split, or ask.
- The 10 KB soft target is advisory; the 15 KB flag is the review trigger.
- The checkpoint flags only; the repair performs the automatic cleanup.

### LLD-006: Repair the project corpus

- Update the header on the 9 lesson files; the template stays exempt.
- Remove cross-file pointers from `release-practices.md`, `protocol-routing-principle.md`, `compaction-trigger-problem.md`, and `protocol-verification-toolchain.md`, except the README and announcement paths that the release checklist writes or edits.
- Keep domain commands, system paths, and checklist output paths that are lesson content.
- Keep the release checklist as one file; no split.
- Keep the project identifying names; none currently.
- Keep the files self-standing; inline a short needed fact when a pointer carried it; if the fact cannot be inlined, abort the file unchanged and report; never preserve the pointer.
- Keep 10 files or fewer; the repair may merge duplicates but must not increase the count.
- Update the reference counts in `protocol-verification-toolchain.md` after the procedure change.
- Verify headers, sizes, no tables, no cross-file pointers, and the checklist.

### LLD-007: Repair the global corpus

- Update the 23 global files to the self-standing standard.
- Remove the external links in `naming-conventions.md`.
- Keep domain paths and commands that are lesson content.
- Remove identifying names.
- Remove raw secrets.
- Never split; keep the file count at 23 or lower.
- Verify headers, sizes, no tables, no cross-file pointers, no identifying names, and no secrets.

### LLD-008: Update the split language, docs, and release

- Replace every split instruction in the Global Knowledge Protocol, the README global-knowledge guidance, and the relevant procedure text with merge or trim.
- Rewrite the README paragraph that explains why a mixed global file is split: keep one file, give it a descriptive name for its dominant domain, trim at 10 KB, and state the accepted filename-index lookup trade-off.
- Leave `docs/announcements/v5.4.0.md` historical; add a top `Superseded by v5.4.1` note; point the README banner at v5.4.1.
- Update the README banner, standards section, upgrade step, context-health row, and feature bullet.
- Update the workflow guide sections 1, 2, 13, 14, 17, and 23.
- Update the slides, the runbook, and the knowledge-base examples to the new header and standard.
- Write `docs/announcements/v5.4.1.md` in the user's voice.
- Add the v5.4.1 section to `release-practices.md`; keep the checklist one file.
- State the 10 KB soft target, the 15 KB review, no split, self-standing, no questions, project/global names, and secrets.
- The release is v5.4.1; tag and GitHub Release follow the merge.

### LLD-009: Record the decisions and protocol-developer gate

- Load `protocol-decisions.md` in full before editing `AGENTS.md` or any policy.
- Record human approval before the policy edits.
- Run the authoring validator on every changed policy.
- Add an ADR for the 10 KB/15 KB size-based standard.
- Add an ADR for no split, merge/trim only, and the checklist.
- Add an ADR for self-standing files, the self-contained header, and the domain/checklist content exception.
- Add an ADR for the autonomous repair, no questions, the abort, and preserved ambiguity.
- Add an ADR for the project/global sensitive scope and the secret ban.
- Add an ADR for the v5.4.1 release.
- Add one supersession ADR that names the v5.4.0 100-line decision, the one-lesson decision, the split decision, the long-analysis move decision, the approval-gated repair decision, the header decision, the checkpoint 100-line decision, and the 2026-10-06 split decision.
- Update the design-docs policy to remove the one-line source pointer; the extracted design document is the authority.
- Use self-contained entries with no commit hash or branch name.

### LLD-010: Validate the correction

- Add anchors for the renamed repair steps.
- Run the protocol validator, authoring validator, reference test, and markdownlint.
- Build the generated fixture in a temporary directory outside the linted tree with `support-files/test-knowledge-repair-fixture.sh`: 59 project files and a temporary global store, with duplicates, cross-file pointers, a 66 KB checklist, a 15 KB-plus note, a project name, a global name, a technology vendor name, a secret, tables, dates, and hashes.
- Add `support-files/test-knowledge-repair-fixture.sh` to prepare the fixture and verify the result; the test uses a temporary HOME and temporary project root, never the real stores.
- Run the repair under the temporary HOME and project root; confirm no prompt.
- Confirm the file count is 59 or lower; no file is split; the checklist is one file.
- Confirm the 66 KB checklist is reviewed and remains one file.
- Confirm the 15 KB-plus note gets the automatic review.
- Confirm cross-file pointers are removed; a short needed fact is inlined; no new claim is added.
- Confirm the project name stays; the global name is removed; the secret is removed from both; a technology vendor name stays.
- Confirm the header is self-contained; no line target; the 10 KB soft and 15 KB review are reported.
- Confirm the manifest, backup, independent review, abort behavior, and report exist; confirm the manifest and backup paths are recorded in the checkpoint and diary; confirm the vendor name stays; confirm the checklist output path survives.
- Confirm a fixture with an incomplete manifest leaves the file unchanged and reports.
- Confirm a fixture that fails the independent review is not replaced.
- Confirm `dry run` stops after the manifest and writes nothing.
- Confirm the common policy's side-effect, restructure, and content-integrity rules carry the repair-trigger exception.
- Audit the final project corpus, 10 files or fewer, and the final global corpus, 23 files or fewer, for headers, cross-file pointers, sizes, tables, names, and secrets.
- Recompute and update the reference counts in `protocol-verification-toolchain.md`.
- Run the independent implementation review and fix every Critical and Major finding.

## Acceptance Criteria

- AC-001: The policy uses a 10,000-byte soft target and a 15,000-byte automatic review trigger; no line target. Traces to LLD-001.
- AC-002: The repair never splits a file and never increases the file count; it merges and trims. Traces to LLD-004 and LLD-006.
- AC-003: A checklist stays one file; the 15 KB review applies; no split. Traces to LLD-001, LLD-004, and LLD-006.
- AC-004: The 15 KB review runs automatic cleanup without a user question. Traces to LLD-003 and LLD-004.
- AC-005: The repair asks no user question; it removes defined garbage and duplicates, preserves ambiguous content, and reports. An incomplete manifest leaves the file unchanged and reports. Traces to LLD-003 and LLD-004.
- AC-006: Every knowledge file is self-standing; no cross-file pointers; the header is self-contained; domain commands, system paths, and checklist output paths are allowed as content. Traces to LLD-001, LLD-002, LLD-006, and LLD-007.
- AC-007: Project knowledge may keep identifying names; global knowledge removes them; raw secrets are banned in both. Traces to LLD-001, LLD-004, LLD-006, and LLD-007.
- AC-008: The one-lesson rule and the split/move-to-artifact path are removed; every split instruction and decision is replaced or marked superseded. Traces to LLD-001, LLD-008, and LLD-009.
- AC-009: The repo's project and global corpora comply; the repeatable fixture test proves the 59-to-233 failure cannot recur. Traces to LLD-006, LLD-007, and LLD-010.
- AC-010: The docs, announcement, release practices, ADRs, and v5.4.1 release are updated. Traces to LLD-008 and LLD-009.
- AC-011: Validators, lint, independent plan review, and implementation review pass. Traces to LLD-010.
- AC-012: The independent review must return `APPROVED` before replacement; a failed review leaves the old file unchanged and reports. Traces to LLD-004.
- AC-013: The backup and manifest paths are recorded in the checkpoint and diary. Traces to LLD-003 and LLD-004.
- AC-014: The design-docs one-line source pointer is removed or explicitly allowed; the self-standing rule has no hidden exception. Traces to LLD-009.
- AC-015: The fixture test uses temporary project and global stores; the real stores are untouched. Traces to LLD-010.
- AC-016: The common policy's side-effect, restructure, and content-integrity rules carry the repair-trigger exception; the authoring review checks the text. Traces to LLD-001 and LLD-009.
- AC-017: `dry run` stops after the manifest and writes nothing. Traces to LLD-004.
- AC-018: An identifying name means a person, client, employer, or customer; technology vendor and product names are not identifying names and stay. A fixture vendor name proves it. Traces to LLD-001, LLD-005, and LLD-010.
- AC-019: Replacement is per file and requires a complete manifest and an `APPROVED` review; aborted and review-failed files stay unchanged. Traces to LLD-003 and LLD-004.

## ADRs

### ADR-001: Size-based limits

Decision: A knowledge file uses a 10,000-byte soft target and a 15,000-byte automatic review trigger. No line target applies.

Context: The 100-line target forced 59 files into 233 in a live project.

Consequence: Size reflects actual content; the repair aims for 10 KB and reviews at 15 KB without splitting.

### ADR-002: No splitting

Decision: The repair never splits a file. It trims and merges; a checklist stays one file; the file count cannot increase.

Context: Splitting produced 233 files from 59.

Consequence: File boundaries stay stable; a long file stays together and is reported if it remains over 15 KB.

### ADR-003: Self-standing files

Decision: A knowledge file contains the context it needs and points at no other knowledge, code, doc, policy, artifact, backup, or state file. The header is self-contained. A domain command, system path, or checklist output path is content when it is the subject.

Context: The v5.4.0 repair left pointers to artifacts, backups, docs, policies, and state.

Consequence: A file is readable on its own; a pointer for more context is removed or replaced with the short fact.

### ADR-004: Autonomous repair with a safety abort

Decision: The repair asks no question. It removes defined garbage and duplicates, preserves ambiguous content, backs up, verifies, runs an independent review, replaces only after `APPROVED`, and reports. An incomplete manifest leaves the file unchanged. A `dry run` stops after the manifest.

Context: The approval questions made a live repair slow and intrusive.

Consequence: The repair is deterministic and reportable; an ambiguous item is preserved; an unsafe or unapproved file is not replaced.

### ADR-005: Scoped sensitive handling

Decision: Project knowledge may keep identifying names; global knowledge removes them; raw secrets are banned in both. An identifying name means a person, client, employer, or customer; a technology vendor or product name is lesson content, not an identifying name.

Context: The earlier ban treated both stores the same, but the user needs project names in project knowledge.

Consequence: The global store stays portable; the project store keeps its context; a tracked project file still follows the commit guardrail; vendor names such as Azure, GitLab, Docker, and Kubernetes stay.

### ADR-006: v5.4.1 patch

Decision: Ship the correction as v5.4.1.

Context: v5.4.0 shipped the bad repair behavior; the correction is urgent.

Consequence: The release notes, banner, announcement, and release practices describe the new behavior; the tag follows the merge.

### ADR-007: Supersede the line-based and split decisions

Decision: The v5.4.1 standard supersedes the v5.4.0 100-line decision, the one-lesson decision, the split decision, the long-analysis move decision, the approval-gated repair decision, the header decision, the checkpoint 100-line decision, and the 2026-10-06 split decision.

Context: The old decisions conflict with the new size, self-standing, and no-split rules.

Consequence: The decision store has one self-contained supersession entry; the old entries stay as history.

### ADR-008: The repair trigger is the approval

Decision: The explicit `repair knowledge files` trigger authorizes the repair's merges, trims, and restructures. The repair asks no further question.

Context: The common policy requires approval for side effects and restructures; the user wants no questions inside the repair.

Consequence: The trigger is the consent; the repair documents the result; a tracked file still follows the commit guardrail.

## Test Plan

- Run `bash support-files/validate-protocol.sh` and keep 8/8.
- Run `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-design-docs.md` and confirm PASSED.
- Run `bash support-files/test-protocol-references.sh` and confirm PASS.
- Run markdownlint on the linted set and confirm 0 issues.
- Build the fixture with `bash support-files/test-knowledge-repair-fixture.sh --prepare`; it creates a temporary project and temporary global store with 59 files.
- Run the repair under the temporary HOME and project root; confirm no prompt.
- Run `bash support-files/test-knowledge-repair-fixture.sh --verify`; it asserts no split, the file count is 59 or lower, the checklist is one file, the 15 KB review ran, cross-file pointers are gone, project names stay, global names are removed, secrets are removed, headers are self-contained, the manifest and backup exist, the manifest and backup paths are recorded in the checkpoint and diary, the vendor name stays, and the checklist output path survives.
- Confirm the real `~/.ai/global-knowledge/` and the repo's knowledge stores are unchanged by the fixture test.
- Confirm the abort fixture leaves the file unchanged and reports.
- Confirm the review-gate fixture is not replaced.
- Audit the final project corpus, 10 files or fewer, and the final global corpus, 23 files or fewer, for headers, cross-file pointers, sizes, tables, names, and secrets.
- Recompute the reference counts in `protocol-verification-toolchain.md`.
- Run the independent implementation review and fix every Critical and Major finding.

## Release Plan

- Version: v5.4.1.
- Theme: a fast correction to the v5.4.0 knowledge repair.
- Release contents: size limits, no split, self-standing files, autonomous repair, sensitive scope, corpus updates, docs, ADRs, and tests.
- Release documentation on the branch: README banner, announcement, release-practices section, workflow guide, slides, runbook, and examples.
- After the merge: tag the release commit, push the tag, and publish the GitHub Release.
- The global knowledge repair on this machine is local; users run the repair on their own stores.

## Risks and Mitigations

- Autonomous removal loses content: define garbage narrowly, preserve ambiguous items, back up, verify every item, abort a file with an incomplete manifest, and report.
- A cross-file pointer carries the only copy of a fact: inline a short fact; otherwise abort the file unchanged and report; never keep the pointer.
- A 66 KB checklist stays large: never split; review and compress; report if it remains over 15 KB.
- A project name is committed: the project store is normally outside git; a tracked file follows the commit guardrail.
- A technology vendor name is mistaken for an identifying name: define the scope and keep a vendor fixture.
- Global names or secrets remain: scan the global scope; remove; verify.
- The file count grows: assert the count does not increase; merge only.
- The repair asks a question: remove every approval/question step; keep the no-question abort; test the no-prompt path.
- The independent review fails: do not replace; fix and re-review; leave the old file if it cannot pass without loss.
- The fixture mutates real stores: use a temporary HOME and project root; verify the real stores are untouched.
- The split language survives in another document: sweep the policy, README, Global Knowledge Protocol, decision store, and announcement; mark superseded.
- The README's filename-index reason still implies splitting: rewrite it to describe the accepted one-file lookup trade-off.
- The design-docs pointer contradicts self-standing: update the design-docs policy.
- The docs drift: update the user-facing set in one pass; lint; review.
- The release repeats the bad behavior: the fixture test and the independent implementation review gate the release.

## Work Sequence

1. Review and approve this plan.
2. Load `protocol-decisions.md` in full; record approval for the policy edits; update the policy standards, header, approval exception, and design-docs pointer.
3. Rewrite the checkpoint flag and the repair procedure.
4. Add the validator anchors, the fixture harness, and the ADRs.
5. Repair the project corpus; keep the checklist one file; keep 10 files or fewer.
6. Repair the global corpus; remove names and secrets; keep 23 files or fewer.
7. Sweep the split language; update the docs, examples, v5.4.0 historical note, announcement, and release-practices section.
8. Run the fixture test, the corpus audit, the validators, and markdownlint.
9. Run the implementation peer review; fix every Critical and Major finding; re-review.
10. Attach the plan to the ticket, replace the plan link with `Plan attached below.`, delete the plan file, close the ticket, and run the checkpoint on the branch.
11. Squash merge, push, tag v5.4.1, and publish the release after approval.

## Peer Review Log

- Round 1: 2026-10-29 17:12, independent reviewer, report `ai/code-review-reports/2026-10-29_17-12_review-18.md`, verdict CHANGES REQUESTED. Findings fixed: no-question abort; split-language sweep; conservation contract merge pointer, artifact evidence, and long-analysis move removed; table markup vs content; independent-review gate; repair-trigger approval exception; 15 KB review definition; backup and manifest paths; secret removal; checklist output paths; protocol-developer gate; v5.4.0 historical note; isolated fixture; plan link and deletion; supersession list; reference counts; 10-or-fewer count; design-docs pointer.
- Round 2: 2026-10-29 17:19, independent reviewer, report `ai/code-review-reports/2026-10-29_17-19_review-19.md`, verdict CHANGES REQUESTED. Findings fixed: a cross-file pointer that cannot be inlined aborts the file unchanged and is never preserved; the manifest path is written and recorded with the backup paths; the checklist output path exception is in the procedure and garbage definition; a dry-run stop is added; replacement is per file and requires a complete manifest and `APPROVED` review; the fixture is generated in a temporary directory outside the linted tree; identifying names are defined as people, clients, employers, or customers, with vendor names kept; the project corpus is 10 files or fewer; the approval exception has an acceptance criterion and test; the README split paragraph is rewritten; the ticket is aligned with the plan.
- Round 3: 2026-10-29 17:24, independent reviewer, report `ai/code-review-reports/2026-10-29_17-24_review-20.md`, verdict CHANGES REQUESTED. Findings fixed: LLD-006 aborts a file when a pointer cannot be inlined; the manifest is built in memory and written only for a non-dry run; the checklist exception is broadened to a path a checklist step writes or edits; the Test Plan uses the final project corpus of 10 files or fewer and the final global corpus of 23 files or fewer; the harness asserts the checkpoint/diary path record, the vendor name, and the checklist output path.
- Round 4: 2026-10-29 17:26, independent reviewer, report `ai/code-review-reports/2026-10-29_17-26_review-21.md`, verdict CHANGES REQUESTED. Finding fixed: the Test Plan now audits the final project corpus of 10 files or fewer and the final global corpus of 23 files or fewer.
- Round 5: 2026-10-29 17:27, independent reviewer, report `ai/code-review-reports/2026-10-29_17-27_review-22.md`, verdict APPROVED. No Critical or Major findings remain. The plan is ready for implementation.
