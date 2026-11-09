Reported: 2026-10-18
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Make policies self-contained trigger plugins and index their headings for JIT discovery

Description:

## Problem

Triggers are registered in `AGENTS.md`, so every new policy or procedure needs a matching edit there. The policy is not self-sustained, and the trigger list lives in two places. The AI also indexes policy filenames only, not the headings inside them, so it can miss the right policy or trigger.

## Required behavior

- A policy declares its own trigger phrases, scope, and loading rules.
- Adding a policy requires no edit to `AGENTS.md`.
- A generic dispatcher discovers the declarations and loads the right policy.
- Boot, recovery, and load context index policy headings (for example `grep '^#' <policy-file>`) next to the filename, so the AI can match a user phrase to a trigger and a policy.
- Always-on rules and the read-first-rules tier stay unchanged.
- Stable all-caps procedure names, validator anchors, and the reference-integrity test keep working.

## Open decisions

- What is the declaration shape: a fixed `## Triggers` block, a metadata block, or a heading convention?
- Is the heading index built for every policy at boot, or only for the active expertise and the project policy directory?
- How does discovery interact with the Protocol Developer Mode exception that skips the recursive policy scan?
- Does this replace the triggered-procedure tier in `AGENTS.md`, or coexist with it during a migration?
- How do validator anchors work when a procedure definition moves out of `AGENTS.md`?
- How is the heading index bounded for a large policy set?
- Is this sequenced before or after `policies-to-skills-rename.md`?

## Acceptance criteria

- Adding a new policy needs no `AGENTS.md` edit.
- The AI resolves a trigger phrase to the correct policy from the policy's own declaration.
- Load context, recovery, and checkpoint re-affirmation report a policy heading index.
- Existing procedures still work; validator and reference-integrity test stay green.
- Docs describe the plugin model and the migration path.

## Notes

- This is a later-stage architectural change. The authoring standard ticket is a prerequisite for a consistent declaration shape.
- Related: `policies-to-skills-rename.md` (naming and directory change), `procedure-e-precedence-rework.md`, `protocol-design-docs.md`.
- Existing decisions to reconcile: the 2026-08-31 router model, the 2026-10-06 stable procedure names, and the 2026-08-22 Protocol Developer Mode scan exception.

Plan attached below.

Implemented 2026-11-09; implementation reviews APPROVED; merged and tagged v6.0.0; released at <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v6.0.0>.

## Implementation Plan

# Plan: Stage 2 procedure modules and thin AGENTS.md

**Ticket**: `ai/issues/in-progress/self-contained-policy-triggers-and-heading-jit-index.md` (P3 by AI estimate, XL by AI estimate, Improvement/Refactor)
**Design record**: `design-docs/protocol-decisions.md`, entries dated 2026-11-08, INV-001 to INV-016. INV-016 was amended on 2026-11-09 so the `#N` placeholder persists in procedure triggers after the alias form is removed.
**Size**: XL
**Branch**: `feature/procedure-modules-and-thinning`
**Base ref**: local `master` (3729123, `v5.8.0` local tag)
**Merge mode**: `direct`, local only; no push
**Release**: v6.0.0 (major), local tag; published with the final approval

## Context

Stage 1 added policy triggers, the shared index step, and dispatch. Stage 2 completes the model: the 13 procedure bodies leave `AGENTS.md`, become self-standing modules with H1 titles and `## Triggers`, and load on demand. `AGENTS.md` becomes a thin router of always-on rules plus the shared step and dispatch. This is the user's thinning objective and the broad ticket's remaining work.

The delivery model is local-only, agreed on 2026-11-09. Stage 1 is merged into local `master` and tagged `v5.8.0`, with nothing pushed. Stage 2 merges into local `master`, tags `v6.0.0`, and the final push after explicit approval publishes both releases. A local `git bundle` is the safety net.

Two design-level changes are part of this stage, not quiet edits:

- INV-016 was amended so `#N` persists in procedure triggers after the alias form is removed.
- The meta policy must describe H1 procedure modules, `## Triggers`, and the procedure store; its current `### PROCEDURE` and `**Aliases**` shape would reject the modules.

Scope boundaries:

- Move the 13 procedure bodies; do not change their behavior.
- Do not change the declaration format, namespace, normalization, dispatch, or failure rules from the design record.
- Do not touch skills; they remain a separate work item.
- The procedure store exists only in the protocol clone. No project procedure directory, and the store is flat.
- The runtime remains prose. No new runtime script.

## Evidence

Files read in full for this plan:

- `AGENTS.md` (444 lines, 9,494 words, 66,667 bytes).
- The 13 procedure bodies at `AGENTS.md:125-428` (304 lines; the procedure titles start at 127, 201, 213, 270, 281, 304, 313, 321, 330, 341, 372, 394, and 415) and `TIER APPENDIX` at `:429-443`, with the `END_IMMUTABLE_PROTOCOL` marker at `:444`.
- `ai/policies/ai-policy-meta.md` (189 lines; `### Trigger Declarations` at 120, `### Procedure Headers` at 135, `### Enforcement` at 157, the procedure-alias bullet at 126, the H3 header at 137, the `**Aliases**` rules at 139-140).
- `ai/policies/ai-policy-common.md`, `ai-policy-code-review.md`, `ai-policy-codebase-examination.md`, `ai-policy-design-docs.md`.
- `support-files/validate-protocol.sh` (479 lines; procedure and step anchors at 13-150, including the LOAD-CONTEXT steps at 79-94, `ITEM PROTOCOL-INDEX` at 107-108, and the state-file anchors at 33-44, 61-64, and 115-134; the policy trigger guard at 436-448).
- `support-files/validate-policy-authoring.sh` (431 lines; `check_trigger_block` at 83, `check_policy_file` at 140, `check_agents_file` at 221, `collect_raw_triggers` at 289).
- `support-files/test-protocol-references.sh` (130 lines; live files at 28-32, definitions at 36-40, the order-conformance block at 101-108).
- `support-files/test-trigger-rules.sh` (28 cases; `make_agents` at 38-47 writes procedures and aliases, so it must be reworked).
- `support-files/sync-agents-md.sh` (402 lines) and `.ps1` (335 lines).
- `design-docs/protocol-decisions.md` (the 2026-11-08 entries and the 2026-11-09 INV-016 amendment).
- `ai/issues/in-progress/self-contained-policy-triggers-and-heading-jit-index.md` (47 lines).
- `README.md`, `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, `docs/ai-customization-guide.md`, `docs/how-policies-work-in-this-workflow.md`, `docs/protocol-validation-system.md`, `docs/post-compaction-reload-trigger-setup.md`, `docs/announcements/v5.8.0.md`, `ai/shared/project-knowledge/release-practices.md`.

Confirmed facts:

- The current `AGENTS.md` is 444 lines, 9,494 words, 66,667 bytes; the procedure bodies are 76.8 percent of the words. Removing them and the appendix comfortably meets the thin targets.
- The reference test reports 13 procedures, 98 steps, 4 tiers, and 11 items. Its definitions come only from `AGENTS.md`; its live files are `AGENTS.md`, the coordination file, and `ai/policies/*.md`.
- The reference test's order-conformance block greps `^### PROCEDURE MANAGE-ISSUES:` and `^### PROCEDURE IMPLEMENT-PLAN:` in `AGENTS.md`.
- `validate-protocol.sh` anchors procedure titles, LOAD-CONTEXT steps, `ITEM PROTOCOL-INDEX`, and the state-file guarantees inside `AGENTS.md`. The state guarantees are inside LOAD-CONTEXT, WRITE-CHECKPOINT, and REPAIR-STATE-FILES, not in the always-on tiers.
- The authoring validator's `check_agents_file` requires one `**Aliases**` line per `### PROCEDURE`; `collect_raw_triggers` reads only those aliases.
- The fixture's `make_agents` helper writes `### PROCEDURE` and `**Aliases**`, so the Stage 2 thin check would fail those cases until the helper is reworked.
- The sync scripts copy `AGENTS.md` verbatim and do not copy procedures. `.gitignore` does not blanket-ignore `ai/`, so `ai/procedures/` is tracked in the protocol clone.
- The design record already commits to the H1 module title, the thin targets, the `**Aliases**` removal, and the validator/test migration. INV-016 now covers the procedure-trigger `#N`.

## High-Level Design

HLD-001: Create a flat `(Global AI Workflow Directory)/ai/procedures/` with 13 files, one per procedure, named in lowercase kebab case.

HLD-002: Each module starts with `# PROCEDURE <NAME>: <description>`, then `## Triggers` with one phrase per bullet, then the unchanged procedure body.

HLD-003: `AGENTS.md` keeps the protocol wrapper (including the END marker), `TIER CONFIGURATION`, `TIER READ-FIRST-RULES`, `## Shared Protocol Steps`, `## Protocol Dispatch`, a short `TIER TRIGGERED-PROCEDURES` router, and a short `TIER APPENDIX` pointer. All procedure bodies, `**Aliases**` lines, and the appendix content leave.

HLD-004: `docs/setup.md` receives the appendix content. The pointer uses `(Global AI Workflow Directory)/docs/setup.md` because `AGENTS.md` is copied into projects while the setup doc lives in the clone.

HLD-005: The shared step's procedure source becomes the flat procedure store. The dispatch rules, namespace, normalization, and failure behavior are unchanged.

HLD-006: `validate-protocol.sh` and `test-protocol-references.sh` read the procedure store; `validate-policy-authoring.sh` replaces the `AGENTS.md` procedure-aliases check with a thin-`AGENTS.md` check and a procedure-module shape check. The meta policy is updated to match. The fixture is reworked to use procedure modules.

HLD-007: The docs and release set describe the thin `AGENTS.md`, the procedure store, and v6.0.0.

Flow:

1. The 13 procedure bodies move, with only the title level, the trigger declaration, and the single recovery STEP-READ-AGENTS sentence changed.
2. `AGENTS.md` becomes the router; the END marker stays.
3. The index scans the flat procedure store.
4. The validators and the reference test resolve procedure, step, and item names from the modules.
5. Load context, recovery, and checkpoint behave as before.

## Low-Level Design and Acceptance Criteria

LLD-001: Move the 13 procedures.

- Files: `load-context.md`, `bootstrap-project.md`, `write-checkpoint.md`, `run-peer-review.md`, `post-compaction-recovery.md`, `create-backup.md`, `examine-codebase.md`, `manage-issues.md`, `implement-plan.md`, `repair-state-files.md`, `repair-knowledge-files.md`, `update-design-docs.md`, `migrate-design-docs.md`.
- The store is flat: `ai/procedures/*.md` only; no subdirectories.
- Move the body without editing any step text, except the recovery STEP-READ-AGENTS sentence, which must name the store.
- The file stem is the lowercase kebab form of the ALL-CAPS name.
- The module has no policy `DO NOT MODIFY` guard.

LLD-002: Convert the module header.

- Replace `### PROCEDURE <NAME>: <description>` with `# PROCEDURE <NAME>: <description>`.
- Replace the `**Aliases**` line with `## Triggers`, a blank line, and one `- <phrase>` bullet per phrase.
- Preserve the existing phrases, including the trailing `#N` on `plan issue #N` and `implement issue #N`.
- The module body starts after the trigger block and is unchanged.

LLD-003: Thin `AGENTS.md`.

- Replace the 13 procedure bodies with a short router at `TIER TRIGGERED-PROCEDURES`:

  ```markdown
  ## TIER TRIGGERED-PROCEDURES

  Procedure modules live in `(Global AI Workflow Directory)/ai/procedures/`, one file per procedure. Run `STEP-PROTOCOL-INDEX` to list them. `AGENTS.md` carries no procedure body and no static procedure list.
  ```

- Replace the appendix content at `:431-443` with a pointer, keep the `TIER APPENDIX` heading at `:429-430` and the `END_IMMUTABLE_PROTOCOL` marker at `:444`:

  ```markdown
  ## TIER APPENDIX

  See `(Global AI Workflow Directory)/docs/setup.md` for Windows path formats and the manual setup, including the bootstrap wedge.
  ```

- Keep the 4 tier headings. Remove every `### PROCEDURE` and `**Aliases**` line.

LLD-004: Update the shared step.

- Replace the Stage 1 sentence about `**Aliases**` with: the procedure source is every module file under the flat `(Global AI Workflow Directory)/ai/procedures/` store.
- Change the placeholder line from "in an alias" to "in a procedure trigger"; INV-016 now covers it.
- Keep the rest of the index rules unchanged.

LLD-005: Migrate `validate-protocol.sh`.

- Replace the procedure, step, item, and state-file anchors at 13-150 with a helper that greps the correct procedure module. The procedure titles, LOAD-CONTEXT steps, `ITEM PROTOCOL-INDEX`, and the state guarantees move with their modules.
- Keep only the shared-step, dispatch, tier, configuration, `Single-Writer`, `Full File Reads`, and letter/numeric-ban anchors in `AGENTS.md`; the ban at 143-150 stays.
- Keep the four policy trigger guard.
- Add the thin-`AGENTS.md` size check: at most 160 lines, 2,400 words, and 24,900 bytes. Fail with a clear message.
- Update the anchor error messages to name the module file.

LLD-006: Migrate the authoring validator and the meta policy.

- Replace `check_agents_file` with `check_thin_agents`:
  - reject `^### PROCEDURE`, `^# PROCEDURE`, and `^\*\*Aliases\*\*:`;
  - allow only `**STEP-PROTOCOL-INDEX**` as a bold `**STEP-` definition outside the procedure store;
  - require `## Shared Protocol Steps`, `## Protocol Dispatch`, and the 4 `## TIER` headings.
- Add `check_procedure_module`:
  - require an H1 `# PROCEDURE <NAME>: ...`;
  - require exactly one `## Triggers` with at least one bullet;
  - allow the trailing `#N` and no other placeholder;
  - forbid `**Aliases**`;
  - require the file stem to match the lowercase kebab name.
- Extend `collect_raw_triggers` for the flat procedure store; the module identity is `procedure:<NAME>` so a policy stem cannot collide with a procedure name.
- Update the per-file dispatch so `ai/procedures/*` routes to `check_procedure_module`, not `check_policy_file`.
- Update `--triggers` and the aggregate command to include `ai/procedures/*.md`.
- Update `ai-policy-meta.md`:
  - the section description and `Applies To` say the trigger, procedure-header, and enforcement rules cover `ai/procedures/*.md`, while `### Policy Structure` and `### Policy Filenames` stay policy-only;
  - `### Trigger Declarations` describes procedure `## Triggers` and the trailing `#N` in a procedure trigger;
  - the procedure `## Triggers` bullet list is a normative literal artifact and is exempt from `### Rule Structure`, like a policy trigger;
  - `### Procedure Headers` requires the H1 module title, `## Triggers`, and no `**Aliases**`, and the alias-count rules at 143-145 are removed;
  - `### Enforcement` includes the procedure store.
- Rework the fixture: add `make_procedure`; re-author the alias cases as procedure modules; keep a thin-`AGENTS.md` fixture only for the thin check, containing `## Shared Protocol Steps` with `**STEP-PROTOCOL-INDEX**`, `## Protocol Dispatch`, and the four `## TIER` headings; keep the policy cases. Add: a valid module, a module without triggers, a module with aliases, a bad stem, a policy-style placeholder in a module, and a policy/procedure duplicate.

LLD-007: Migrate `test-protocol-references.sh`.

- Add `ai/procedures/*.md` to `LIVE_FILES`.
- Build procedure definitions from `^# PROCEDURE [A-Z][A-Z0-9-]*:` in the modules.
- Build step and item definitions from `AGENTS.md` plus the procedure modules; policies and coordination stay reference-only.
- Keep the tier definitions from `AGENTS.md`.
- Change the order-conformance block to grep `^# PROCEDURE ${proc}:` in the procedure store and count one.
- Update the header comment.
- Expect 13 procedures, 98 steps, 4 tiers, and 11 items.

LLD-008: Move the appendix and update the docs.

- Create `docs/setup.md` with `# Setup`, `## Windows path formats`, and `## Manual setup`, converting the two appendix H3 headings to H2 and keeping the content.
- README: a note and the quick-start diagram show the procedure store; the sync script copies the thin `AGENTS.md`.
- Workflow guide: update the procedure-location statements, the post-compaction section, and the procedure references.
- Slides: the thin `AGENTS.md` and the procedure store.
- `docs/protocol-validation-system.md`: the procedure-module checks, the migrated anchors, and the `#N` procedure-trigger wording.
- `docs/post-compaction-reload-trigger-setup.md`: the procedure now lives in the store, not `AGENTS.md`.
- Update the stale "procedure in `AGENTS.md`" statements in `ai-policy-common.md` (10, 71, 81, 92, 93, 166, 169, 363), `ai-policy-code-review.md:18`, `ai-policy-codebase-examination.md:15`, `ai-policy-design-docs.md:115`, and `docs/workflow-guide.md:175`. Keep references to the always-on read-first rules in `AGENTS.md`.
- Release: `docs/announcements/v6.0.0.md`, a v6.0.0 release-practices section, and the README banner. The banner is edited on the branch but not published until approval.

LLD-009: Release v6.0.0 locally.

- Local annotated tag after the local merge; no push, no GitHub Release, and no banner publication until the final approval.
- The final push publishes `v5.8.0` and `v6.0.0`.
- The validator's "v6.1" print is its own label, not the workflow release; leave it and note it.

LLD-010: Migration manifest.

- Record every moved procedure with its old body range and new file.
- Record the appendix move (431-443) and the preserved END marker (444).
- Record the meta policy update, the anchor migrations, the order-conformance change, and the fixture rework with old and new locations.
- Confirm no rule or step is lost.

LLD-011: Update the recovery step and the related docs.

- Change the recovery STEP-READ-AGENTS sentence from "AGENTS.md ... plus all procedures" to "the thin AGENTS.md plus the flat procedure store."
- Update `docs/workflow-guide.md:136` and `:144` to name the store.
- No other procedure step text changes.

Acceptance criteria:

- AC-01 (modules): 13 flat procedure modules exist, one per procedure, each with an H1 title, a `## Triggers` block with at least one phrase, and a body. Protects INV-010.
- AC-02 (thin AGENTS.md): no `### PROCEDURE`, no `# PROCEDURE`, no `**Aliases**`, no procedure body, and no static procedure list remain. Protects INV-014.
- AC-03 (size): `AGENTS.md` is at most 160 lines, 2,400 words, and 24,900 bytes, which is at least 60 percent smaller than 66,667 bytes. Protects INV-014.
- AC-04 (appendix): `docs/setup.md` contains 431-443 under `# Setup`, with `## Windows path formats` and `## Manual setup`; the `TIER APPENDIX` heading and pointer stay, the END marker stays in `AGENTS.md`, and the pointer resolves from the clone. Protects INV-014.
- AC-05 (index source): the shared step names the flat procedure store; the dispatch rules are unchanged. Protects INV-005.
- AC-06 (validators): the protocol validator, the authoring validator in both modes, the reference test, and the reworked fixture pass. Protects INV-008.
- AC-07 (triggers): every old alias still resolves; `plan issue #5` and `implement issue #5` still work; the four policy triggers still work. Protects INV-002, INV-016.
- AC-08 (behavior): every procedure's steps are identical to the old body except the title level, the trigger declaration, and the single recovery STEP-READ-AGENTS sentence. Protects INV-010.
- AC-09 (sync): the sync scripts still update a project's `AGENTS.md` and need no code change. Protects INV-011.
- AC-10 (docs): the docs and the touched policies describe the store and the thin `AGENTS.md`; user docs carry no internal labels. Protects INV-014.
- AC-11 (manifest): the migration manifest is complete and reviewed. Protects INV-014.
- AC-12 (delivery): Stage 2 merges into local `master` and tags `v6.0.0`; nothing is pushed until explicit approval. Protects INV-015.
- AC-13 (scope): skills and the policy declaration format are unchanged. Protects INV-001, INV-015.
- AC-14 (no project store): no project `ai/procedures/` is created or scanned. Protects INV-010.
- AC-15 (index count): the load report shows 18 policies and 13 procedures. Protects INV-009.
- AC-16 (size guard): the validator fails on an over-target `AGENTS.md`. Protects INV-014.
- AC-17 (identity): the module identity includes the type, so a policy stem and a procedure name cannot collide. Protects INV-009.

## Decisions

ADR-P1: Keep the 4 tier headings in `AGENTS.md` as routers and pointers.

- Context: the reference test counts tiers and the validator anchors tier headings.
- Consequence: the tier count stays 4 and no tier anchor moves.

ADR-P2: Procedure modules have no policy guard.

- Context: they are executable protocol steps, not policy rules.
- Consequence: the authoring validator checks their header and trigger shape but not a DO NOT MODIFY line.

ADR-P3: Procedure `## Triggers` allow the trailing `#N`.

- Context: the parameterized commands move from aliases to module triggers, and INV-016 now covers it.
- Consequence: the procedure trigger shape allows one trailing `#N`; policy triggers still forbid placeholders.

ADR-P4: Move the appendix content to `docs/setup.md` and keep a clone-anchored pointer.

- Context: the appendix is human setup content and `AGENTS.md` is copied into projects.
- Consequence: the tier heading stays; the content leaves; the pointer resolves from the clone.

ADR-P5: v6.0.0 is a major release.

- Context: the definition home and `AGENTS.md` shape change for every user.
- Consequence: an upgrade note requires a pull, the sync script, and a restart.

## Risks and Gaps

RSK-201: A step or rule is lost in the move. Mitigation: the migration manifest and the body-diff check.

RSK-202: An anchor still greps `AGENTS.md` and fails. Mitigation: the anchor inventory and the validator migration.

RSK-203: The reference test still expects definitions from `AGENTS.md`. Mitigation: the H1 module definitions, the live-file list, and the order block.

RSK-204: A user project runs an old `AGENTS.md` and an old procedure set. Mitigation: the upgrade note; the clone ships the modules.

RSK-205: A procedure module trigger collides with a policy trigger. Mitigation: the aggregate namespace check with typed identities.

RSK-206: The thin `AGENTS.md` misses the size target. Mitigation: the validator size check and the measured baseline.

RSK-207: The local-only window grows. Mitigation: the user is doing both stages back to back; a local bundle at `ai/artifacts/local-bundles/Simple-AI-Workflow-v6.0.0.bundle`.

RSK-208: The fixture's old `make_agents` cases fail the thin check. Mitigation: the reworked `make_procedure` and thin-`AGENTS.md` helpers.

RSK-209: The meta policy still describes the old procedure header and rejects the modules. Mitigation: the meta policy update in LLD-006.

RSK-210: The validator's v6.1 label is confused with the release. Mitigation: note that it is a pre-existing label.

## Implementation Steps

1. Preflight: confirm local `master` at 3729123, the `v5.8.0` tag, and the Stage 2 ticket in `in-progress/`. The planning artifacts (the ticket rename, the plan, and the amended design record) are carried onto the branch.
2. Create `ai/procedures/` and the 13 flat modules; convert the titles and triggers, and change the STEP-READ-AGENTS sentence in `post-compaction-recovery.md` to name the store.
3. Replace the procedure bodies in `AGENTS.md` with the router; replace the appendix content with the pointer and keep the END marker.
4. Create `docs/setup.md` from 431-443.
5. Update the shared step's procedure source and the `#N` wording.
6. Update `ai-policy-meta.md` and its enforcement commands.
7. Migrate `validate-protocol.sh`, `validate-policy-authoring.sh`, and `test-protocol-references.sh`; rework the fixture.
8. Update the docs, the stale procedure-location references, and the release set.
9. Run the full verification set and the body-diff manifest check.
10. Run the implementation peer review until APPROVED.
11. Attach the plan, close the ticket, run the checkpoint on the branch, and commit.
12. Squash merge to local `master`, delete the branch, create the local annotated tag `v6.0.0`, and create the bundle. Do not push.
13. Run the final combined review of local `master` at `v5.8.0` plus `v6.0.0`, then stop for explicit approval to push and publish.

## Verification

Automated:

- `bash support-files/validate-protocol.sh` prints 8/8.
- `bash support-files/test-protocol-references.sh` prints PASS at 13 procedures, 98 steps, 4 tiers, and 11 items.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/procedures/*.md ai/policies/ai-policy-meta.md ai/policies/ai-policy-common.md ai/policies/ai-policy-code-review.md ai/policies/ai-policy-codebase-examination.md ai/policies/ai-policy-design-docs.md ai/policies/ai-policy-cloud.md ai/policies/ai-policy-data.md ai/policies/ai-policy-dba.md ai/policies/ai-policy-api-backend.md` prints PASSED on the changed set.
- `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` prints PASSED on the aggregate set; the five pre-existing policy shape failures are skipped by the mode.
- `bash support-files/test-trigger-rules.sh` passes every reworked case.
- `markdownlint-cli2` on the changed files reports 0.
- `shellcheck -S warning` on the changed scripts is clean.
- `wc -l -w -c AGENTS.md` meets the three thresholds.

Body diff:

- For each procedure, extract the old body from `git show 3729123:AGENTS.md` at the manifest range, strip the `### PROCEDURE` title and the `**Aliases**` line and their blank lines, and compare it with the new module after stripping the `# PROCEDURE` title, the `## Triggers` heading, the trigger bullets, and their blank lines.
- Normalize trailing blank lines to one on both sides.
- The only expected difference is the single recovery STEP-READ-AGENTS sentence in `post-compaction-recovery.md`; every other body is identical, and any other difference fails the manifest check.

Manual:

- Each old alias still dispatches its procedure, including `plan issue #5` and `implement issue #5`.
- The four policy triggers still load their policies.
- The load report shows 18 policies and 13 procedures.
- The sync script dry run still succeeds.
- The recovery and checkpoint references still resolve.
- No project `ai/procedures/` directory exists.

## Documentation and Release

- `docs/setup.md` new.
- README, workflow guide, slides, validation-system doc, and the stale procedure references updated.
- `docs/announcements/v6.0.0.md`, release practices, and the README banner.
- Local tag `v6.0.0`; publish `v5.8.0` and `v6.0.0` after approval.

## Close Sequence

- **Repository**: `origin`, `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- **Base ref**: local `master` at 3729123, the local `v5.8.0` commit.
- **Branch**: `feature/procedure-modules-and-thinning`, deleted after the local merge.
- **Ticket**: local `ai/issues/in-progress/self-contained-policy-triggers-and-heading-jit-index.md`. Attach the plan under `## Implementation Plan`, replace the dated link with `Plan attached below.`, close the ticket in the branch commit, and delete the plan file.
- **Merge mode**: `direct`, local only. Squash merge to local `master`; no push.
- **Release**: local annotated tag `v6.0.0`; no push or GitHub Release until the final approval.
- **Local safety**: create `ai/artifacts/local-bundles/Simple-AI-Workflow-v6.0.0.bundle` after the merge.
- **Final publication**: after explicit approval, push `master`, push `v5.8.0` and `v6.0.0`, and publish both releases.
- **Terminal gate**: the branch is at least one commit ahead of local `master`; the tree is clean before the merge.
- **Evidence**: the verification set, the body-diff manifest, the review verdicts, the ticket close, and the local tag.

## Migration Manifest

- `AGENTS.md:127-200` LOAD-CONTEXT to `ai/procedures/load-context.md`; the anchors at `validate-protocol.sh:13-14`, `:45-48`, `:79-94`, `:107-108`, `:111-114`, and `:115-118` follow it.
- `AGENTS.md:201-212` BOOTSTRAP-PROJECT to `ai/procedures/bootstrap-project.md`.
- `AGENTS.md:213-269` WRITE-CHECKPOINT to `ai/procedures/write-checkpoint.md`; the anchors at `validate-protocol.sh:33-44`, `:61-64`, and `:119-134` follow it.
- `AGENTS.md:270-280` RUN-PEER-REVIEW to `ai/procedures/run-peer-review.md`; the anchor at `validate-protocol.sh:17-18` follows it.
- `AGENTS.md:281-303` POST-COMPACTION-RECOVERY to `ai/procedures/post-compaction-recovery.md`; the anchor at `validate-protocol.sh:21-22` follows it.
- `AGENTS.md:304-312` CREATE-BACKUP to `ai/procedures/create-backup.md`; the anchor at `validate-protocol.sh:25-26` follows it.
- `AGENTS.md:313-320` EXAMINE-CODEBASE to `ai/procedures/examine-codebase.md`; the anchor at `validate-protocol.sh:29-30` follows it.
- `AGENTS.md:321-329` MANAGE-ISSUES to `ai/procedures/manage-issues.md`; the anchor at `validate-protocol.sh:49-50` and the order block at `test-protocol-references.sh:101-108` follow it.
- `AGENTS.md:330-340` IMPLEMENT-PLAN to `ai/procedures/implement-plan.md`; the order block at `test-protocol-references.sh:101-108` follows it.
- `AGENTS.md:341-371` REPAIR-STATE-FILES to `ai/procedures/repair-state-files.md`; the anchor at `validate-protocol.sh:53-54` follows it.
- `AGENTS.md:372-393` REPAIR-KNOWLEDGE-FILES to `ai/procedures/repair-knowledge-files.md`; the anchors at `validate-protocol.sh:57-58` and `:65-70` follow it.
- `AGENTS.md:394-414` UPDATE-DESIGN-DOCS to `ai/procedures/update-design-docs.md`; the anchor at `validate-protocol.sh:71-72` follows it.
- `AGENTS.md:415-425` MIGRATE-DESIGN-DOCS to `ai/procedures/migrate-design-docs.md`; the anchor at `validate-protocol.sh:75-76` follows it. The separator at 427-428 is not body content.
- `AGENTS.md:431-443` TIER APPENDIX content to `docs/setup.md`, converted to `# Setup`, `## Windows path formats`, and `## Manual setup`; `AGENTS.md:429-430` plus the pointer stay, and the END marker at 444 stays.
- The recovery STEP-READ-AGENTS text changes to the thin `AGENTS.md` plus the store; `docs/workflow-guide.md:136` and `:144` follow it.
- `ai-policy-meta.md` `### Trigger Declarations`, `### Procedure Headers`, `### Enforcement`, the section description, and `Applies To` update to the H1 module, `## Triggers`, and the procedure store; `### Policy Structure` and `### Policy Filenames` stay policy-only.
- `validate-policy-authoring.sh` `check_agents_file` becomes `check_thin_agents`; `check_procedure_module` and the procedure-store collection are added.
- `test-protocol-references.sh` live files, definitions, order block, and header comment update.
- `test-trigger-rules.sh` reworked to use `make_procedure` and a thin `AGENTS.md`.
- The manifest anchor ranges name the `if` and message lines; the full anchor blocks move with them.
- No procedure step is deleted; the alias-count rules are superseded by the trigger model, and the only content removed from the boot payload is moved.

## Peer Review Log

- Plan review round 1 (2026-11-09): CHANGES REQUESTED. 7 Critical, 11 Major, 13 Minor. Fixed the anchor partition, the END marker, the INV-016 amendment, the meta policy work, the fixture rework, the reference order block, the recovery step, the evidence ranges, the clone-anchored pointer, the thin-check predicate, the body-diff definition, the stale references, the invariant mapping, the preflight, the flat-store rule, the manifest, and the minor wording.
- Plan review round 2 (2026-11-09): CHANGES REQUESTED. 1 Critical (the recovery STEP-READ-AGENTS text was still missing), 3 Major (the manifest anchor inventory, the meta-policy scope, the appendix heading), 7 Minor. Fixed the recovery LLD-011, the anchor rows, the meta-policy scoping, the appendix 431-443 split, the dated INV-016 amendment entry, the preflight carry, the body-diff blank normalization, the fixture content, the meta wording, the range convention, and the redundant name check.
- Plan review round 3 (2026-11-09): CHANGES REQUESTED. 1 Major (the recovery sentence exception was not reflected in the flow, AC-08, or the body diff) and 7 Minor. Fixed the exception in the flow, AC-08, the body diff, and step 2; corrected the appendix range in LLD-010, the meta policy line count, the amendment citation, the setup H1, the literal-artifact assignment, and the ITEM anchor range.
- Plan review round 4 (2026-11-09): CHANGES REQUESTED. 1 Major (the new setup doc would start at H3 under an H1 and fail heading and markdownlint checks) and 3 Minor. Fixed the setup structure with `# Setup`, `## Windows path formats`, and `## Manual setup`; added the alias-count rule update; widened the WRITE-CHECKPOINT anchor range; and corrected the state-anchor summary.
- Plan review round 5 (2026-11-09): APPROVED, no Critical or Major. Three Minor wording fixes were applied: the alias-count rules are removed, no procedure step is deleted, and the LOAD-CONTEXT proof-of-read anchor is `:115-118`.
- Implementation review 1 (2026-11-09): CHANGES REQUESTED. 4 Major, 10 Minor. Fixed the meta-policy scope, the lost `**Loads**` check, the pre-action aggregate command, the workflow-guide alias wording, the stale codebase and examples references, the reference-test message, the design-docs wording, the literal-artifact designation, the validator header comment, the missing fixture cases, the duplicate stem rule, the verification command, and the module placement checks.
- Implementation review 2 (2026-11-09): APPROVED, no Critical or Major. Four Minor refinements were applied: the immediate-H1-to-triggers placement check and fixture, the peer-review enforcement wording, the README note order, and a pre-existing filename redundancy noted as out of scope.
