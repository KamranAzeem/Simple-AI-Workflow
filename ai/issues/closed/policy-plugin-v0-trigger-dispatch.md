Reported: 2026-10-21
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Implement the minimal policy plugin v0 (trigger declaration, indexing, dispatch)

Description:

The coding baseline policy is complete, but the plugin mechanism that lets a policy declare its own trigger phrases is still missing. This ticket carries that remaining work, split out of `code-authoring-policy-and-policy-plugin.md` so the policy deliverable can close.

Scope:

- A policy declares its own trigger phrases in a `## Triggers` section.
- Boot, post-compaction recovery, and checkpoint re-affirmation index only policy filenames and trigger lines, never the body.
- A declared phrase loads that policy in full for the session.
- A policy without `## Triggers` keeps today's behavior.
- The authoring validator currently rejects `## Triggers`; the plugin lands with the validator update and the `AGENTS.md` dispatch.
- The broad ticket `self-contained-policy-triggers-and-heading-jit-index.md` remains the later architectural change.

Related: `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md`, `ai/issues/closed/code-authoring-policy-and-policy-plugin.md`, `design-docs/protocol-decisions.md`.

Plan attached below.

Implemented 2026-11-09; implementation reviews APPROVED; local merge and tag pending.

## Implementation Plan

# Plan: Stage 1 policy trigger plugin

**Ticket**: `ai/issues/in-progress/policy-plugin-v0-trigger-dispatch.md` (P3 by AI estimate, L by AI estimate, Feature)
**Related ticket**: `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md` stays open for Stage 2
**Design record**: `design-docs/protocol-decisions.md`, entries dated 2026-11-08, INV-001 to INV-016
**Size**: L
**Branch to create at implementation**: `feature/policy-plugin-v0-trigger-dispatch`
**Base ref**: `origin/master`
**Merge mode**: `direct` (no `## Merge Policy` section in `ai-customization.md`)
**Release**: v5.8.0 (minor), tagged locally after the local merge; not pushed or published until explicit approval

## Context

Stage 1 adds the policy trigger plugin. A policy may declare `## Triggers`, the AI builds an ephemeral module index at boot, and a phrase such as `cloud standards` loads the cloud policy for the session. Procedures stay in `AGENTS.md` with their aliases. No procedure moves, no thinning happens, and no runtime script is added.

The problem: a global policy can only be loaded through `## Active Expertise` or by a procedure that names it. A user cannot reach a domain policy by phrase without editing the customization file. The plugin closes that gap and proves the declaration, index, dispatch, and failure model before Stage 2 moves the procedure bodies.

Three corrections surfaced while gathering evidence:

- `ai-policy-design-docs.md` fixes the allowed document types to vision, PRD, HLD, LLD, risk-and-gap-analysis, delivery-ledger, and ADR, and it prohibits invented types. A standalone `trigger-plugin-model.md` would be an invented type. The design record lives as dated ADR entries in the existing store, `design-docs/protocol-decisions.md`.
- The parameterized aliases `plan issue #N` and `implement issue #N` cannot survive plain normalized whole-word matching because `#N` becomes a token and a user writes a digit. Stage 1 keeps the aliases and defines `#N` as the only placeholder form: it matches an optional `#` and one or more digits. No alias line changes, so the meta policy's three-alias rule for a touched procedure is not triggered.
- The authoring validator already fails on five shipped policies for missing `# AI Policy:` titles or `## References`. That is pre-existing and out of scope. Stage 1 adds a trigger-only mode so the namespace check can scan the full policy set without being blocked by unrelated shape failures. A separate ticket records the pre-existing gaps at implementation.

Scope boundaries:

- Stage 1 changes policy loading and the placeholder matching. No procedure body moves.
- The index is ephemeral and exists only in the AI's working context.
- The runtime is prose. No script, binary, cache, or index file is introduced.
- Skills are out of scope.
- Stage 2, the procedure modules and thinning, is out of scope and stays open in the broad ticket.

## Evidence

Files read in full for this plan:

- `AGENTS.md` (404 lines, 8,804 words, 62,263 bytes).
- `ai/policies/ai-policy-common.md` (779 lines).
- `ai/policies/ai-policy-meta.md` (170 lines).
- `ai/policies/ai-policy-design-docs.md` (118 lines).
- `ai/policies/ai-policy-cloud.md` (71 lines), `ai-policy-data.md` (77), `ai-policy-dba.md` (111), `ai-policy-api-backend.md` (83).
- `support-files/validate-policy-authoring.sh` (236 lines).
- `support-files/validate-protocol.sh` (450 lines).
- `support-files/test-protocol-references.sh` (130 lines).
- `support-files/sync-agents-md.sh` (402 lines) and `support-files/sync-agents-md.ps1` (335 lines).
- `ai/shared/project-knowledge/issue-template.md` (56 lines).
- `ai/issues/in-progress/policy-plugin-v0-trigger-dispatch.md` (23 lines).
- `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md` (47 lines).
- `docs/workflow-guide.md` (443 lines), `README.md` (414), `docs/simple-ai-workflow-slides.md` (440).
- `docs/ai-customization-guide.md` (159), `docs/ai-customization.md` (77), `docs/how-policies-work-in-this-workflow.md` (48), `docs/protocol-validation-system.md` (37).
- `docs/announcements/v5.7.0.md` and `ai/shared/project-knowledge/release-practices.md` (109 lines).
- `.gitignore` (61 lines).
- `design-docs/protocol-decisions.md` (the 2026-11-08 entries and the ADR house style).

Confirmed facts:

- `AGENTS.md:19`, `:63`, `:89`, and `:389` hold the four tiers. The procedures occupy lines 89 to 388.
- The load-context procedure is at `AGENTS.md:91-161`, with steps 0 to 8 and items at `:152-161`. Post-Compaction Recovery is at `:242-262`. The checkpoint re-affirmation is inside `PROCEDURE WRITE-CHECKPOINT` at `:175-229`.
- Procedure aliases are at `AGENTS.md:93`, `:165`, `:177`, `:233`, `:244`, `:266`, `:275`, `:283`, `:292`, `:303`, `:334`, `:356`, and `:377`.
- `ai-policy-meta.md:84-96` defines the Policy Structure. Line 93 reserves `## Triggers`; line 94 forbids it until the plugin lands. `### Literal Artifacts` is at `:102-115` and defines a normative literal artifact as a fenced block designated by the owning policy. `### Procedure Headers` is at `:117-131` and requires `### PROCEDURE`, one `**Aliases**` line, and `**Aliases**: none` when empty.
- `ai-policy-meta.md:33` and `:142` tell the developer to run the authoring validator on each changed file. That instruction cannot catch a collision between two files; Stage 1 updates it to require the aggregate namespace check.
- `validate-policy-authoring.sh:133-135` rejects any `## Triggers` section. `check_agents_file` at `:138-177` requires one `**Aliases**` line per procedure. `collect_triggers` at `:179-196` reads only `AGENTS.md`, lowercases, and strips quotes. The duplicate check at `:218-229` prints the phrase but not both declarations. There is no punctuation normalization and no containment check.
- The current authoring validator passes `AGENTS.md` and the five changed policy files. It fails on `ai-policy-academic-researcher.md`, `ai-policy-accounting.md`, `ai-policy-career-coaching.md`, `ai-policy-linux-system-admin.md`, and `ai-policy-windows-system-admin.md` for a missing `# AI Policy:` title or a missing `## References`. These five are pre-existing and out of scope.
- `validate-protocol.sh:13-134` holds the procedure and step anchors. The policy baseline at `:384-419` checks 18 policy files exist and carry the read-only markers. It does not call the authoring validator.
- `test-protocol-references.sh:28-32` limits live files to `AGENTS.md`, `ai/shared/coordination.md`, and `ai/policies/*.md`. Lines 35-39 take definitions only from `AGENTS.md`, with a step regex that counts every bold `**STEP-` occurrence, not only definitions. Line 55 prints 13 procedures, 97 steps, 4 tiers, and 10 items today.
- The four target policies share one structure: guard on line 1, READ-ONLY START on line 5, title on line 7, purpose on line 9, `## Scope` on line 11, READ-ONLY END at the end. The trigger section goes after line 9 and before line 11.
- The four phrases are `cloud standards`, `data standards`, `database standards`, and `backend standards`. Under the cross-module rule, none duplicates or contains another module's phrase, and none collides with an existing alias. `data standards` is not a whole-word substring of `database standards` because `database` is one token.
- Existing alias pairs are same-module variants: `load context` and `load context using AGENTS.md protocol`; `bootstrap` and `bootstrap using AGENTS.md protocol`; `post-compaction recovery` and `run post-compaction recovery procedure`; `backup ai` and `backup ai state`. `update design-docs` and `update design docs` are the same normalized phrase inside one procedure. The namespace rule allows all of these and rejects only cross-module duplicates or containment.
- `plan issue #N` normalizes to `plan issue n`, while `plan issue #5` normalizes to `plan issue 5`. Stage 1 keeps the aliases and treats a trailing `#N` as the only placeholder form. The meta policy at `:126` limits a touched procedure to three aliases, so changing the alias lines would force an unrelated alias reduction; the placeholder avoids that.
- `sync-agents-md.sh` and `.ps1` copy `AGENTS.md` and maintain `ai-customization.md`. Stage 1 changes `AGENTS.md`, so users must run the sync script. The scripts themselves need no change.
- `.gitignore` does not ignore `design-docs/` or `ai/policies/`. A future `ai/procedures/` would be tracked in the protocol repository. No ignore change is needed in Stage 1.
- `test-protocol-references.sh` treats a bold `**STEP-...` reference as a definition. The shared step is defined once in bold and referenced in plain text or backticks.
- Baseline checks: protocol validator 8/8, reference test 13/97/4/10, markdownlint 0, and shellcheck `-S warning` clean. The authoring validator passes `AGENTS.md` and the changed set but fails the five pre-existing policies above.

## High-Level Design

HLD-001: `AGENTS.md` gains an always-on `## Shared Protocol Steps` section with one definition, `STEP-PROTOCOL-INDEX`, placed after `TIER READ-FIRST-RULES` and before `TIER TRIGGERED-PROCEDURES`.

HLD-002: `AGENTS.md` gains an always-on `## Protocol Dispatch` section that resolves a user message to a policy or procedure. It states the normalization, the Directive versus Inquiry gate, the message order, the already-active rule, the `"use policy <name>"` command, and the collision behavior.

HLD-003: The load-context, post-compaction recovery, and checkpoint re-affirmation paths reference the shared step. Load context reports `ITEM PROTOCOL-INDEX`. The dispatcher handles the `#N` placeholder.

HLD-004: The meta policy replaces its `## Triggers` reservation with the declaration shape, designates the bullet list as a normative literal artifact, defines the trigger rules, and requires the aggregate namespace check.

HLD-005: The authoring validator replaces the hard rejection with shape, normalization, uniqueness, containment, and name checks. It gains a trigger-only mode for the full policy set. The protocol validator gains anchors. The reference test needs no code change.

HLD-006: The docs and release set describe the behavior and ship v5.8.0.

Flow:

1. Load context resolves the anchors and runs `STEP-PROTOCOL-INDEX`.
2. The index reads procedure aliases from `AGENTS.md` and trigger bullets from the global and project policy directories. It records module metadata only.
3. `STEP-PROOF-OF-LOAD` reports the index summary as `ITEM PROTOCOL-INDEX`.
4. A user message is matched against the index. The Directive versus Inquiry gate decides whether to act. A policy trigger loads the policy for the session; a procedure trigger runs the procedure.
5. Post-compaction recovery and checkpoint re-affirmation rebuild the index from the live files. A dispatch after a module change rebuilds it first.

Boundaries:

- No procedure body moves. Only the shared-step references and the renumbering change in `AGENTS.md`.
- The index never reads a policy body or a procedure step.
- The index writes no file.
- Stage 1 does not apply the thin-`AGENTS.md` size targets; they belong to Stage 2.

## Low-Level Design and Acceptance Criteria

LLD-001: Add `## Shared Protocol Steps` to `AGENTS.md`.

- Place it after `TIER READ-FIRST-RULES` and before `TIER TRIGGERED-PROCEDURES`.
- Define `**STEP-PROTOCOL-INDEX**` exactly once, in bold.
- The definition covers:
  - the global policy directory, the project policy directory, and the procedure source;
  - recursive policy discovery, including the compliance subdirectory;
  - same-path deduplication first, then same-name project replacement;
  - the procedure source is the `**Aliases**` lines in `AGENTS.md` in Stage 1;
  - skip hidden entries, `tmp`, archives, and escaping symlinks;
  - a policy without triggers appears with an empty trigger set;
  - the index creates no directory;
  - normalization, fields, summary, failure handling, the no-body rule, and the no-file rule;
  - rebuild before dispatch when a module file changed in the session.
- References in load context, recovery, and checkpoint re-affirmation are plain text or backticked, never bold.

LLD-002: Add `## Protocol Dispatch` to `AGENTS.md`.

- State the one namespace and the cross-module duplicate and containment rule.
- State the same-module variant exemption.
- State normalization: lowercase, every character outside `[a-z0-9]` becomes a space, whitespace collapses, matching is whole-word.
- State that a phrase ending in `#N` matches its literal prefix plus an optional `#` and one or more digits, and that no other pattern is allowed.
- Reference `ai-policy-common.md` for the general Directive versus Inquiry rule and the design record for the exact signals:
  - Directive: a bare trigger, an imperative, or a polite action question.
  - Inquiry: a concept question, a statement, a past-tense mention, a hypothetical, or a negation.
  - Ambiguity: ask before acting.
- State the message order for multiple matches and the no-module-twice rule.
- State that a policy trigger loads for the session, a procedure runs once, and an active policy is reported rather than reloaded.
- State that `"use policy <name>"` is an explicit instruction; `<name>` is the Active Expertise token; it needs no trigger and bypasses the gate but not the always-on rules.
- State that a runtime collision lists the candidates and dispatches nothing.
- State that a project policy with triggers is still loaded at boot by the existing rule and is reported as active.
- State the static and runtime split and the fixed vocabulary: `invalid trigger block`, `empty trigger block`, `duplicate trigger`, `trigger overlap`, `missing triggers`, `name mismatch`, `invalid policy shape`, `unreadable module`, `trigger collision`, and `unknown policy`.
- Keep the section concise; the rationale stays in the design record.

LLD-003: Wire the index into the three procedures.

- The procedure aliases are unchanged; the dispatcher supports the `#N` placeholder.
- Load context: insert `STEP-PROTOCOL-INDEX` as step 2, after `STEP-WORKFLOW-VERSION-CHECK`; renumber the following steps. The step does not read policy bodies.
- Proof-of-load: add `ITEM PROTOCOL-INDEX` after `ITEM WORKFLOW-VERSION`, reporting module counts by type and scope, the trigger count, the conflict count, and error counts by class.
- Post-compaction recovery: add one step after the policy load that references `STEP-PROTOCOL-INDEX`. Do not restate the scan.
- Checkpoint re-affirmation: add one bullet that references `STEP-PROTOCOL-INDEX`. Do not restate the scan.
- Recovery and checkpoint rebuild silently; only load context reports the item.

LLD-004: Update the meta policy.

- Replace the reservation at lines 93-94 with the optional-section rule and its placement.
- Extend `### Literal Artifacts` to cover a policy's `## Triggers` bullet list, designated by the owning policy, and exempt it from `### Rule Structure`.
- Add a `### Trigger Declarations` subsection with one-sentence imperative bullets:
  - optional for policies; required for procedure modules in the end state;
  - one phrase per bullet;
  - lowercase ASCII letters, digits, spaces, and hyphens;
  - no inline markup and no placeholders in a policy trigger;
  - no empty section;
  - no cross-module duplicate or containment;
  - same-module variants allowed and deduplicated.
- Add the name-mismatch rule: a policy file must follow `ai-policy-<name>.md`; a procedure module file stem must match its H1 name in the end state.
- Update the validation bullets at `:33` and `:142` to require the aggregate namespace check over `AGENTS.md` and all policy files, in addition to the per-changed-file shape check.
- Change only the trigger-uniqueness bullet in `### Procedure Headers`; leave the header shape and alias limit unchanged.

LLD-005: Add triggers to the four policies.

- Insert after the purpose sentence and before `## Scope` in `ai-policy-cloud.md`, `ai-policy-data.md`, `ai-policy-dba.md`, and `ai-policy-api-backend.md`.
- Use one bullet per file: `- cloud standards`, `- data standards`, `- database standards`, and `- backend standards`.
- The four files carry the DO NOT MODIFY guard. The approved plan is the explicit approval for these edits. Record that acknowledgement in the checkpoint.

LLD-006: Replace the authoring validator checks.

- Remove the rejection at lines 133-135.
- Add `Triggers` to the excluded domain-section list, so the section does not count as a domain section.
- Add a normalization function: lowercase, map every character outside `[a-z0-9]` to a space, collapse spaces, trim. Use `LC_ALL=C` or `tr 'A-Z' 'a-z'` so the result does not depend on the locale.
- Collect triggers with a module identity. For `AGENTS.md`, the module is the enclosing procedure name from `### PROCEDURE <NAME>`. For a policy file, it is the file stem after `ai-policy-` and `.md`. Record `normalized`, `file`, `line`, and `module`.
- Shape check for a policy `## Triggers`: at most one section per file; the section sits after the purpose line and before `## Scope`; every content line matches `^- [a-z0-9 -]+$`; the normalized phrase is not empty; at least one bullet; no other content. A policy trigger may not contain a placeholder.
- Alias placeholder: the existing `AGENTS.md` alias collection allows a trailing `#N` in an alias and nowhere else; it stores the literal prefix and a pattern flag; the duplicate and containment checks compare the prefix.
- Name check: a policy file must match `ai-policy-<name>.md`; a violation reports `name mismatch`.
- Duplicate check: a normalized phrase that appears under two different modules fails with `duplicate trigger` and lists every `file:line`. A repeat inside one module is deduplicated and passes.
- Containment check: a normalized phrase that is a whole-word substring of a phrase under a different module fails with `trigger overlap` and lists both `file:line`. Same-module containment passes.
- Failure strings: a non-ASCII phrase reports `invalid trigger block`; an empty section reports `empty trigger block`; an invalid policy shape reports `invalid policy shape`.
- Keep the existing `AGENTS.md` checks, including the one-aliases-line-per-procedure rule. `missing triggers` is a Stage 2 class for procedure modules.
- Add a `--triggers` mode that runs normalization, duplicate, containment, and name checks but skips the policy shape checks. It also rejects a placeholder in a policy trigger, so the placeholder remains confined to the `AGENTS.md` alias collection. It is for the full policy set, where five pre-existing files fail shape for unrelated reasons.
- The default mode keeps shape and triggers for the changed set.
- Name both declarations in every duplicate or containment error.

LLD-007: Add the protocol validator anchors.

- Add protocol-validator checks for these strings in `AGENTS.md`: `## Shared Protocol Steps`, `STEP-PROTOCOL-INDEX`, `## Protocol Dispatch`, and `ITEM PROTOCOL-INDEX`.
- Do not add a call to the authoring validator; the two validators remain separate dev-time tests.

LLD-008: Add a dev-time fixture test, `support-files/test-trigger-rules.sh`.

- Build temporary policy files and an `AGENTS.md`-shaped file under a temp directory.
- Assert PASS for a valid policy, same-module aliases, a same-module exact duplicate that is deduplicated, a policy without triggers, and the four initial phrases.
- Assert FAIL for a cross-module duplicate, cross-module containment, an empty section, a second `## Triggers` section, a malformed line, a non-ASCII phrase, an empty normalized phrase (`- -`), a misplaced section, a policy file name that does not match `ai-policy-<name>.md`, a policy trigger `cloud #N`, and a phrase that differs only by punctuation from another module's phrase.
- Assert PASS for the `plan issue #N` and `implement issue #N` alias declarations; the dispatch behavior for `plan issue #5`, `plan issue 5`, `implement issue #5`, and `implement issue 5` is in the manual matrix.
- Run the authoring validator against the fixtures in both default and `--triggers` modes.
- The fixture test is dev-time only. It is not part of the runtime.

LLD-009: Update the documentation set.

- `README.md`: the v5.8.0 banner, an on-demand policies subsection with the four phrases and the session and compaction behavior, a `What's included` bullet, and a sentence in the customization section. Document `"use policy <name>"` and that a project policy with triggers is still loaded at boot.
- `docs/workflow-guide.md`: section 11 on on-demand triggers; section 13 that trigger lines are indexed, not bodies, and the index is ephemeral; section 7 that recovery rebuilds the index and a triggered policy must be re-triggered after compaction.
- `docs/ai-customization-guide.md`: a subsection after Active Expertise contrasting persistent expertise with on-demand triggers, including the four phrases and `"use policy <name>"`.
- `docs/how-policies-work-in-this-workflow.md`: the trigger path.
- `docs/protocol-validation-system.md`: the new declaration checks, the aggregate mode, and the anchors.
- `docs/simple-ai-workflow-slides.md`: one feature bullet and one short slide.
- `docs/announcements/v5.8.0.md`, a v5.8.0 release-practices section, and the README banner.

LLD-010: Release v5.8.0 locally.

- A minor release because the change adds user-visible behavior.
- A local annotated tag after the local merge. The GitHub Release, the announcement publication, and the README banner publication wait for the final push.
- Stage 2 follows on a new branch from local `master`.

Acceptance criteria:

- AC-01 (declaration): a policy with a valid `## Triggers` section after the purpose and before `## Scope` passes; a misplaced section fails with `invalid policy shape`; an empty or malformed section fails with `invalid trigger block` or `empty trigger block`; a non-ASCII or empty-normalized phrase fails with `invalid trigger block`. Protects INV-001, INV-003, INV-004.
- AC-02 (namespace): a phrase declared by two different modules fails and names both declarations; a phrase contained in another module's phrase fails and names both; same-module variants pass and deduplicate. Protects INV-002.
- AC-03 (initial set): the four policies declare `cloud standards`, `data standards`, `database standards`, and `backend standards`; no phrase collides with an existing alias. Protects INV-001, INV-002.
- AC-04 (index step): load context runs `STEP-PROTOCOL-INDEX` once, reads only filenames, trigger lines, and headings, and reports `ITEM PROTOCOL-INDEX` counts. Protects INV-005, INV-009.
- AC-05 (no persistence): the index step writes no file and creates no cache, and `git status --porcelain` is unchanged by a load. Protects INV-006.
- AC-06 (consumers): post-compaction recovery and checkpoint re-affirmation reference `STEP-PROTOCOL-INDEX` and contain no restated scan text. Protects INV-005.
- AC-07 (dispatch): a Directive with `cloud standards` loads the cloud policy for the session; `CLOUD STANDARDS` and `cloud-standards` also match; `data standards` does not match `database standards`; a question, a statement, a past-tense mention, a hypothetical, and a negation do not dispatch; an ambiguous `cloud standards?` asks first; `cloud standards and data standards` loads both in message order; the same module is never dispatched twice. Protects INV-003, INV-007.
- AC-08 (existing behavior): every current alias still dispatches, including the same-module close variants; `plan issue #5` and `plan issue 5` dispatch the manage-issues procedure and target ticket 5; `implement issue #5` dispatches the implement-plan procedure and targets issue 5; `plan issue` without a number does not dispatch. Protects INV-002, INV-007, INV-016.
- AC-09 (failure): a malformed temp policy is reported and skipped; valid modules still dispatch; the load completes; an unreadable module is reported with `unreadable module` and is not treated as loaded; a runtime collision lists the candidates with `trigger collision`. Protects INV-008.
- AC-10 (static checks): the authoring validator fails with `duplicate trigger`, `trigger overlap`, `invalid trigger block`, `empty trigger block`, `name mismatch`, or `invalid policy shape` on the matching fixture and passes the changed set; `missing triggers` is the Stage 2 procedure-module class; the `--triggers` mode passes the full policy set; the protocol validator anchors the new step and item. Protects INV-008.
- AC-11 (regression): the protocol validator is 8/8, the reference test is PASS at 13 procedures, 98 steps, 4 tiers, and 11 items, markdownlint is 0, and shellcheck `-S warning` is clean. The authoring validator passes `AGENTS.md` and the changed set; the five pre-existing failures are recorded as out of scope. Protects INV-008.
- AC-12 (scope): no procedure body moves, no `ai/procedures/` directory is created, `AGENTS.md` carries no size target in this stage, and the runtime has no script. Protects INV-010, INV-014, INV-015.
- AC-13 (docs): the docs name the four phrases, a session example, the compaction re-trigger, `"use policy <name>"`, and the absence of persistence, and they contain no `STEP-` or `ITEM` labels. Protects INV-013.
- AC-14 (source safety): the four policy edits are acknowledged as user-approved despite the DO NOT MODIFY guard. Protects the meta policy guard, not an invariant.
- AC-15 (discovery): the index covers the global and project policy directories recursively, including compliance, deduplicates the same path, skips hidden/tmp/archive/escaping-symlink entries, reports a triggerless policy with an empty set, and creates no directory. Protects INV-011.
- AC-16 (override): a same-name project module replaces the global one and its triggers; the replaced global triggers stay reserved; a different-name project trigger that collides is reported and not dispatched. Protects INV-012.
- AC-17 (session): a triggered policy is active for the session and is not written to `ai/state/`, `ai-customization.md`, or a new file; after compaction the AI says it does not survive and asks for a re-trigger. Protects INV-013.
- AC-18 (optional): a policy without `## Triggers` passes and keeps its current loading path. Protects INV-004.
- AC-19 (explicit command): `"use policy <name>"` loads a policy with no trigger, using the Active Expertise token; an unknown name reports `unknown policy`. Protects INV-001, INV-007.
- AC-20 (name): a policy file whose name does not follow `ai-policy-<name>.md` fails with `name mismatch`; the five pre-existing title/References failures are not name mismatches and are out of scope. Protects INV-001, INV-008.
- AC-21 (meta validation): the meta policy requires the aggregate namespace check in addition to the per-file shape check. Protects INV-002.
- AC-22 (refresh): a dispatch after a module file changed in the session rebuilds the index first. Protects INV-005.
- AC-23 (placeholder): the only pattern syntax is a trailing `#N` in the alias transition; it matches an optional `#` and one or more digits; no other placeholder or wildcard is allowed. Protects INV-016.

## Decisions

ADR-P1: The shared step goes in a new `## Shared Protocol Steps` section, and dispatch in `## Protocol Dispatch`, both before `TIER TRIGGERED-PROCEDURES`.

- Context: both must be available after `AGENTS.md` is read and through recovery.
- Consequence: one definition and one dispatch rule, not three copies.

ADR-P2: The authoring validator's module identity for a procedure alias is the enclosing procedure name, not the file.

- Context: the existing alias pairs are deliberate same-module variants, and the meta policy permits them.
- Consequence: the cross-module rule catches real ambiguity without breaking current aliases.

ADR-P3: The fixture test is dev-time only and lives in `support-files/test-trigger-rules.sh`.

- Context: the runtime is prose; the validator needs a repeatable check.
- Consequence: one small test script, no runtime dependency.

ADR-P4: The four policy edits are made under the approved plan, which is the explicit user approval required by the DO NOT MODIFY guard.

- Context: the user approved the four phrases and asked for planning.
- Consequence: the checkpoint records the acknowledgement; the policies change only by the trigger block.

ADR-P5: Stage 1 is v5.8.0.

- Context: the change adds user-visible behavior.
- Consequence: announcement, banner, and release-practices entry.

ADR-P6: The aliases keep `#N`; the dispatcher supports the single placeholder form.

- Context: plain normalization turns `#N` into a token and loses the digit match, and changing the aliases would trip the meta policy's three-alias limit for a touched procedure.
- Consequence: the two aliases stay, the dispatcher and validator handle the suffix, and the number is parsed by the procedure.

ADR-P7: The authoring validator gains a `--triggers` mode.

- Context: five shipped policies fail shape checks for pre-existing reasons, and the namespace check needs the full set.
- Consequence: the default mode keeps shape for the changed set; `--triggers` runs the namespace checks over all policies.

ADR-P8: The name-mismatch check compares file names, not human titles.

- Context: five shipped policies use `# AI Assistant Policy:` or omit References, and a title comparison would fail them.
- Consequence: the name check is confined to the `ai-policy-<name>.md` pattern; the pre-existing title gaps are a separate ticket.

## Risks and Gaps

RSK-101: A naive duplicate check would fail the existing close-variant aliases. Mitigation: module identity per procedure and the same-module exemption; the fixture covers the four existing pairs.

RSK-102: The literal-artifact rule currently covers only fenced blocks. Mitigation: the meta policy extension names the `## Triggers` bullet list explicitly, and the validator checks the shape.

RSK-103: A bold `STEP-PROTOCOL-INDEX` reference would be counted as a second definition by the reference test. Mitigation: one bold definition, plain or backticked references.

RSK-104: A user project can run an older `AGENTS.md` copy. Mitigation: the release note requires a pull and the sync script; without the new dispatcher, policy triggers do not fire.

RSK-105: The four policy files are guarded. Mitigation: explicit acknowledgement, and the approved plan is the approval.

RSK-106: The four phrases could collide after a future policy change. Mitigation: the validator fails on the cross-module collision.

RSK-107: Windows and macOS have no bash guarantee. Mitigation: the runtime is prose; the AI uses OS-native commands. The validators remain dev-time and are not on the runtime path.

RSK-108: The index summary could grow. Mitigation: it reports counts, not the full list.

RSK-109: A project policy with triggers is still loaded at boot by the existing rule. Mitigation: dispatch reports it as already active; the loading rule does not change in Stage 1.

RSK-110: The design record's Stage 2 details could leak into Stage 1. Mitigation: AC-12 holds the scope line.

RSK-111: The five pre-existing policy shape failures block the aggregate authoring run. Mitigation: the `--triggers` mode; the failures are recorded as a separate ticket.

RSK-112: The placeholder adds one small syntax. Mitigation: it is the only pattern form, it is validated, it preserves the existing aliases, and the number is parsed by the procedure.

RSK-113: The `--triggers` mode could be used to skip shape checks on a changed file. Mitigation: the verification runs the default mode on the changed set and `--triggers` only for the full-set namespace pass.

## Implementation Steps

1. On the implementation request, verify the design record entries, open `feature/policy-plugin-v0-trigger-dispatch` from `origin/master`, and move the ticket to `in-progress/`. Carry the uncommitted design-record, state, diary, plan, skills-ticket note, and notes changes.
2. Write the fixture test first, with the expected FAIL and PASS cases. Run it against the current validator and confirm the new cases fail.
3. Update the meta policy.
4. Add the four `## Triggers` blocks to the four policies.
5. Add the `#N` placeholder handling to the index and dispatch; do not change the alias lines.
6. Update the authoring validator, including `--triggers`, and rerun the fixture test until all cases pass.
7. Add the shared step and dispatch section to `AGENTS.md`; wire load context, recovery, checkpoint re-affirmation, and the new item.
8. Add the protocol validator anchors.
9. Update the documentation set and the release set.
10. Run the full verification set and fix every failure.
11. Run the implementation peer review until APPROVED.
12. Attach the plan under `## Implementation Plan` (the dated plan entry is already recorded), replace the dated link with `Plan attached below.`, delete the plan file, update related Project Knowledge, run the checkpoint on the branch, close the local ticket in the branch commit, and commit.
13. Squash merge to local `master`, delete the branch, create the local annotated tag `v5.8.0`, and stop. Do not push, create the GitHub Release, or publish the announcement. Stage 2 follows on a new branch from local `master`.

## Verification

Automated:

- `bash support-files/validate-protocol.sh` prints 8/8 and exits 0.
- `bash support-files/test-protocol-references.sh` prints PASS at 13 procedures, 98 steps, 4 tiers, and 11 items.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-meta.md ai/policies/ai-policy-cloud.md ai/policies/ai-policy-data.md ai/policies/ai-policy-dba.md ai/policies/ai-policy-api-backend.md` prints PASSED. This is the changed set.
- `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies -name '*.md' -print)` prints PASSED. This is the aggregate namespace pass; it skips shape for the five pre-existing failures.
- `bash support-files/test-trigger-rules.sh` prints PASS for every fixture case.
- `markdownlint-cli2` on every changed protocol doc, policy, plan, design record, and state file reports 0 issues; `ai/notes/` is free-form and excluded.
- `shellcheck -S warning` on the changed support scripts is clean.

Manual matrix:

- Load context on this clone reports `ITEM PROTOCOL-INDEX` with the module counts, the trigger count, the conflict count, and zero errors.
- `git status --porcelain` is unchanged by a load, and no index file exists.
- `cloud standards` loads the cloud policy and reports it active; `data standards`, `database standards`, and `backend standards` load their policies.
- `CLOUD STANDARDS`, `cloud-standards`, and `cloud  standards` match.
- `how does cloud standards work?` answers and does not load.
- `cloud standards?` asks before acting.
- `I used cloud standards yesterday` does not load.
- `if I say cloud standards, will it load?` does not load.
- `do not load cloud standards` does not load.
- `cloud standards and data standards` loads both, in message order.
- `plan issue #5` and `plan issue 5` dispatch the manage-issues procedure and target ticket 5; `implement issue #5` and `implement issue 5` dispatch the implement-plan procedure and target issue 5; `plan issue` without a number does not dispatch.
- `load context`, `checkpoint`, `peer review`, `file an issue`, and the other existing aliases still dispatch.
- A temp project policy with a malformed `## Triggers` is reported and skipped; valid policies still dispatch.
- A temp project policy with the phrase `cloud standards` is reported as a collision and does not steal the shipped trigger.
- A same-name project policy replaces the global policy and reports the override; the replaced trigger stays reserved.
- A temp policy file named `random.md` under the policy directory reports `name mismatch`.
- A global policy without `## Triggers` keeps its current loading path through Active Expertise or `"use policy <name>"`; a project policy without triggers is still loaded at boot.
- The four target policies are unchanged except for the trigger block.
- `AGENTS.md` gains the new sections and references; no procedure body moves.

Cross-platform:

- The runtime uses OS-native file and text commands; Linux is executed, and PowerShell and macOS are checked by inspection.
- The validators and the fixture test are dev-time and run under bash or Git Bash.

## Documentation and Release

- README: banner, on-demand policy section, what's included, customization note.
- Workflow guide: sections 7, 11, and 13.
- Customization guide: on-demand triggers and `"use policy <name>"`.
- How policies work: the trigger path.
- Protocol validation system: the new checks and aggregate mode.
- Slides: one feature bullet and one slide.
- Release practices: v5.8.0.
- Announcement: `docs/announcements/v5.8.0.md`.
- Release: local annotated tag `v5.8.0`; the GitHub Release and banner publication wait for the final push.

## Close Sequence

- **Repository**: `origin`, `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- **Base ref**: `origin/master`.
- **Branch**: `feature/policy-plugin-v0-trigger-dispatch`, deleted after the merge.
- **Ticket**: local `ai/issues/in-progress/policy-plugin-v0-trigger-dispatch.md`. The dated plan entry is already recorded; attach the plan under `## Implementation Plan`, replace the dated link with `Plan attached below.`, close the ticket in the branch commit, and delete the plan file.
- **Related ticket**: `self-contained-policy-triggers-and-heading-jit-index.md` stays open for Stage 2 and is not closed by this work.
- **Merge mode**: `direct`. Squash merge to local `master` and delete the branch. Do not push.
- **Release**: local annotated tag `v5.8.0` on the local merged `master`. Do not push the tag, create the GitHub Release, or publish the announcement until the final approval. The final push publishes `v5.8.0` with the Stage 2 release.
- **Local safety**: create a local `git bundle` of `master` after the merge, because nothing is on the remote yet.
- **Terminal gate**: the branch is at least one commit ahead of `origin/master` and the tree is clean before the merge claim.
- **Carry**: the uncommitted design-record, state, diary, plan, skills-ticket note, and notes changes travel with the branch and the commit.
- **Evidence**: the verification set results, the fixture results, the implementation review verdict, the ticket close, and the release URL.
- **Stage 2**: the procedure modules and thinning are explicitly out of this close. The broad ticket remains the pointer.

## Peer Review Log

- Plan review round 1 (2026-11-08): CHANGES REQUESTED. 2 Critical (the authoring validator's pre-existing failures break the verification command; parameterized aliases do not survive normalization), 7 Major (INV-011/012 missing, INV-008 vocabulary incomplete, the gate unspecified, dispatch normalization missing, per-file invocation cannot catch collisions, ticket close timing, empty normalized phrases), 15 Minor. Fixed the trigger-only mode, the discovery and override designs, the failure vocabulary, the gate, the close timing, the evidence counts, and the missing ACs.
- Plan review round 2 (2026-11-08): CHANGES REQUESTED. 2 Major (the vocabulary strings were not all literal in the plan; changing the aliases would trip the meta policy's three-alias limit for a touched procedure) and 8 Minor. Fixed the literal vocabulary, kept the aliases and added the `#N` placeholder rule, corrected the gate citation, named the item anchors, added the case and placeholder tests, added `unknown policy`, qualified the triggerless policy, named the carried changes, and added the ticket-target test.
- Plan review round 3 (2026-11-08): APPROVED, no Critical or Major. Eight Minor refinements were applied: the INV-016 scope, the `--triggers` placeholder check, AC-01 classification, the policy-trigger placeholder fixture, step 1 carry, the LLD-007 wording, the second alias test, and this log entry.
- Delivery model (2026-11-09): the user approved local-only delivery. Stage 1 merges into local `master` and gets a local annotated tag, with no push or publication. Stage 2 follows on a new branch from local `master`, and the final push after explicit approval publishes both releases. The close sequence, release step, and merge mode above reflect this; no design invariant changed.
- Implementation review 1 (2026-11-09): CHANGES REQUESTED. 9 Major, 12 Minor. Fixed the runtime failure model, session rules, meta containment wording, alias shape, fixture coverage, docs labels, project-policy boot, developer-mode indexing, and markdownlint exclusion.
- Implementation review 2 (2026-11-09): APPROVED, no Critical or Major. Nine Minor refinements were applied: the real-file trigger guard, recovery wording, the aggregate command, the legacy-gaps ticket, record counts, the alias character set, the immediate-placement check, compaction wording, and the index wording.
- Final verification (2026-11-09): APPROVED, no Critical or Major. Four Minor refinements were applied: the diary count, the section-scoped trigger guard, the heading index wording, and the containment wording.
