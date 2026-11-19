Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: A `repair global settings` procedure to consolidate the global settings files, normalize the important key names, trim bloat, and verify the tools list

Description:

**Goal**: add a user-triggered repair procedure for the **Global AI Settings Directory**, modeled on `repair knowledge files`. It consolidates each settings file into compact, effective bullets, normalizes the important keys, trims bloat, and verifies the tools list.

**Scope**:

- Every file in the **Global AI Settings Directory**, starting with `global-user-settings.md`.
- A new procedure module `repair-global-settings.md` with the trigger `repair global settings`, plus straight variants (`tidy global settings`, `heal global settings`) if they do not collide with an existing module.
- A dry run, a conservation manifest, a backup, an independent review, and a preserve-rather-than-corrupt failure rule, like the knowledge repair.

**Consolidation**:

- The user voice and writing-style block has too many sections: Voice, Structure, Greetings and Salutations, Language Habits, Words and Phrases to Avoid, Style Sources. Collapse them into one compact bullet set under an effective heading. Keep every personal rule. Drop the prose, the repetition, and the rationale.
- The settings keep personal overrides only. A rule owned by the common policy stays there and is not restated.
- Merge a tiny section into its nearest topic. Keep the identity fields and the words-to-avoid list, which are short and used directly.

**Key names**:

- Define the canonical names for the most important keys and rename the settings to match.
- Normalize `Default Shell Path` when it exists, and keep it with the preferred shell and tools.
- The rename is a contract: update the reader in `load-context.md` and the validator in lockstep. Never rename a key that the protocol reads without that update.
- Normalize the identity keys (`Name`, `Email`, `Role`, `Base`) the same way.

**Tools list**:

- Verify every entry: the path exists and the command runs on this OS, using `command -v` on Linux and macOS and `Get-Command` on Windows.
- Remove a dead entry. Report an unverified entry, and never install a tool.
- Keep one compact line per tool, with no prose, no versions unless useful, and no verbosity. The list is a tool inventory, not a paragraph.

**Similar functionality to `repair knowledge files`**:

- Index the settings files, audit them read-only, build an in-memory manifest with one row per old item and a disposition, support `dry run`, back up before a write, write a candidate, verify no item is lost, run the independent review, replace only approved files, and report.
- Leave an ambiguous item unchanged and report it.

**Decisions (2026-11-19)**:

- **Canonical keys**: `Name`, `Email`, `Role`, `Base`, `Certs`, `Expertise`, `Communication` (`Voice`, `Structure`, `Greetings`, `Language Habits`, `Words to Avoid`), `Default Shell Path`, `Tools`, `Operating Instructions`, `Sensitive Names`. A key means both the bold field label and its section heading; one canonical name for both.
- **Most important keys**: `Name`, `Email`, `Default Shell Path`, `Tools`, `Sensitive Names`. `Name` and `Email` stay exactly as they are, because the author-identity resolver reads `## Identity` fields `Name` and `Email`.
- **Rules owner**: a new `ai-policy-global-settings.md` with `Mode: procedure`, loaded by the new procedure. The policy floor moves from 23 to 24 and the validator and tests follow.
- **Backup and manifest**: the manifest and project copies go to `ai/artifacts/settings-repair-<date>/`; the global backup goes to `<Global User AI Directory>/settings-repair-backups/<date>/`. The manifest may sit in the current project when the procedure runs outside the workflow clone.
- **File layout and size**: keep one `global-user-settings.md`; merge a file under 3 KB into the nearest topic; split only over 8 KB, by topic; create no new file unprompted.
- **Dead tools**: remove the entry with a manifest disposition and a report line; never install a tool.
- **Sensitive names**: never copy the `Sensitive Names To Never Commit` entries into the manifest, the report, or a commit; record only "sensitive list present, N entries".
- **Template and readers in lockstep**: a canonical key change updates `docs/global-user-settings.md`, `load-context.md`, and the validator in the same unit.
- **Review gate**: every write gets the independent review.
- **Voice block**: drop the `Style Sources` line. Keep the personal rules and the words-to-avoid list.
- **Identity and certs**: `Identity` holds only `Name` and `Email`, formatted as the essentials for a basic `.gitconfig`. `Role`, `Base`, and `Certs` move to a compact `Profile` list; `Certs` is a compact list with no prose.
- **Secrets**: redact every secret from the report and the manifest, and never print one.

**Constraints**:

- User-triggered only, never at boot or checkpoint.
- Touch the **Global AI Settings Directory** only. Never touch the knowledge stores, the state files, or the project.
- No secrets and no identifying names in the report or the backup manifest.
- Keep the default behavior for a settings file that is already compact.

**Acceptance criteria**:

- The trigger exists and runs only on request.
- Each settings file is consolidated into compact bullets under effective headings, with no duplicated universal rules and no prose.
- The important keys, including `Default Shell Path`, use the canonical names, and the readers are updated in lockstep.
- The tools list is verified, compact, and free of dead entries and prose.
- A bloated file is trimmed; a manifest and a backup exist; a dry run writes nothing; an ambiguous item is preserved.
- A fixture with a bloated settings file yields the compact output, keeps the identity, renames the keys, and verifies the tools; the suite and the validators pass.
- No other global store changes.

---
2026-11-19
Decisions supplied by the user. The ticket is workable. Plan depth is HLD plus LLD with acceptance criteria.

---
2026-11-19
Plan attached below.

## Implementation Plan

# Plan: Repair Global Settings Procedure

## Evidence

- Ticket: `ai/issues/open/repair-global-settings-procedure-consolidation-key-names-and-tool-verification.md`; the user supplied every decision on 2026-11-19, so no open question remains.
- The current settings file, `~/.ai/settings/global-user-settings.md` (6,703 bytes), read in full. It has 9 sections, the voice block holds 6 subsections, `Default Shell Path` sits under `### Preferred shell and tools`, and the tools list mixes prose with paths.
- The knowledge repair model: `ai/procedures/repair-knowledge-files.md` (13 steps), `ai-policy-knowledge.md` (`### Knowledge Repair Conservation Contract`, lines 124-161), and `tests/test-knowledge-repair-fixture.sh`.
- The author-identity contract: `ai-policy-common.md` (`## Author Identity and Attribution`) reads the settings `## Identity` fields `Name` and `Email`. That contract pins the two names.
- The canonical loading contract: `ai-policy-meta.md` (`### Loading Declarations`, `### Trigger Declarations`, `### Procedure Headers`).
- The counts: `support-files/validate-protocol.sh:357` (`POLICY_FLOOR=23`); `tests/test-policy-shape.sh` counts files dynamically; `ai/shared/project-knowledge/protocol-verification-toolchain.md:59` records 23 policies (12 domain and 11 protocol), 14 procedures, 22 test scripts, 47 triggers, floor 23. `README.md:418` and `docs/simple-ai-workflow-slides.md:297` say 14 procedures; `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:83` and `:196`, and `docs/simple-ai-workflow-slides.md:112`, say 23 policies.
- The trigger namespace: 47 phrases in 14 procedures; `repair global settings`, `tidy global settings`, and `heal global settings` collide with none.
- The global settings template: `docs/global-user-settings.md` (the current template, 57 lines).
- The load-context read of the settings: `ai/procedures/load-context.md:11` (the shell path) and `STEP-LOADING` (the author identity).
- The test suite: 23 scripts; `tests/run-all.sh` runs every `test-*.sh`.

## HLD

### Layers

- `ai/procedures/repair-global-settings.md`: the new procedure, triggers `repair global settings`, `tidy global settings`, `heal global settings`.
- `ai-policy-global-settings.md`: the new policy, `Mode: procedure`, `Load in: repair-global-settings`. It owns the canonical keys, the identity contract, the tool verification, the redaction, the conservation rules, the review gate, and the backup.
- The **Global AI Settings Directory**: the target. One consolidated file by default; a file under 3 KB merges into its nearest topic; a file over 8 KB splits by topic only.
- The author-identity resolver: unchanged. It reads `## Identity` fields `Name` and `Email`.

### Canonical structure

```markdown
# User Settings

## Identity
- **Name**: ...
- **Email**: ...

## Profile
- **Role**: ...
- **Base**: ...
- **Certs**: ...

## Expertise
- **Expert**: ...
- **Familiar**: ...

## Communication
- **Voice**: ...
- **Structure**: ...
- **Greetings**: ...
- **Language Habits**: ...
- **Words to Avoid**: ...

## Default Shell Path
- **Default Shell Path**: ...

## Tools
- **`<tool>`**: `<path or command>`
...

## Operating Instructions
- ...

## Sensitive Names
- ...
```

- Drop `Style Sources`, the `Git Conventions` pointer sentence, and every duplicated universal rule. Keep the user's git override ("Always use the user's own name and email...") as one compact bullet under `Operating Instructions`; only the pointer goes.
- One compact line per tool; no prose and no version unless it helps.
- `Certs` is one compact list line; `Base` keeps the location and the OS.

### Counts

- Policies 23 to 24, procedures 14 to 15, steps 109 to 121 (the new procedure adds 12), triggers 47 to 50, test scripts 23 to 24.
- The policy floor 23 to 24.
- The protocol policy split 11 to 12; the domain split stays 12.

### No breaking changes

- `Name` and `Email` keep their names and their `## Identity` section.
- `Default Shell Path` keeps its name, so the load-context reader is unchanged. Only its section moves to a top-level `## Default Shell Path`.
- The default behavior of a compact file is no write.

## LLD

### Policy: `ai-policy-global-settings.md`

- Header: the read-only guard, the START marker, the title, a purpose sentence, `## Loading` (`- Mode: procedure`, `- Load in: repair-global-settings`), `## Scope`, the rule sections, `## References`, the END marker.
- Write every rule as one imperative sentence per bullet, as the authoring validator requires.
- `## Rules`:
  - Target the **Global AI Settings Directory** only.
  - Run only on the trigger; the trigger is the approval.
  - Use the canonical key set; keep `Name` and `Email` exactly for the author-identity resolver.
  - Keep one canonical name for the bold label and the section heading. The bold label is the key and the heading is the topic; the `## Default Shell Path` heading and the `- **Default Shell Path**:` label are intentionally the same name, and the reader matches the label.
  - Hold personal overrides only; never restate a common-policy rule.
  - Drop `Style Sources`, the `Git Conventions` pointer sentence, and duplicated universal rules; keep the user's git override under `Operating Instructions`.
  - Verify every tool with `command -v` on Linux and macOS, or `Get-Command` on Windows; remove a dead entry with a manifest disposition; never install.
  - Keep one compact line per tool.
  - Redact every secret from the report and the manifest; never print one.
  - Rename `Sensitive Names To Never Commit` to `Sensitive Names`; no reader keys on the old heading, because the common policy points at the global settings names list, not the heading text. Never copy an entry into the manifest, the report, or a commit; record only the count.
  - Use the dispositions `kept`, `merged`, `trimmed`, `removed as defined garbage`, `removed as a dead tool`, `preserved ambiguous`, and `aborted unchanged`.
  - Define garbage as prose that restates a rule, duplicated universal rules, provenance lines, style sources, dead tools, and duplicate entries.
  - Preserve every identity value, rule, preference, caveat, identifier, and tool path that is not garbage.
  - Preserve an ambiguous item and report it.
  - Merge a file under 3,000 bytes into its nearest topic; split only over 8,000 bytes and by topic.
  - Back up before the first write: the manifest and project copies in `ai/artifacts/settings-repair-<date>/`, the global copy in `<Global User AI Directory>/settings-repair-backups/<date>/`.
  - Stop a dry run after the manifest report.
  - Verify no item is lost, the secrets are redacted, the identity keys are intact, and the tools are verified.
  - Run the independent review and require `APPROVED`; fix and re-review; leave a file unchanged if it cannot pass without loss.
  - Replace only an approved file; restore the backup on failure.
  - Report the manifest and backup paths, the counts, and any unresolved item.
  - Leave a compact file byte-for-byte unchanged, so a second run is a no-op.
  - Never touch the knowledge stores, the state files, or the project.
- `## References`: `ai-policy-common.md`, `ai-policy-knowledge.md` (for the model, not the rules), `ai/procedures/repair-global-settings.md`, `docs/global-user-settings.md`.

### Procedure: `ai/procedures/repair-global-settings.md`

1. **STEP-LOAD-SETTINGS-RULES**: Load the policy in full.
2. **STEP-RESOLVE-SETTINGS-SCOPE**: Default to the whole settings directory; read `dry run` after the trigger.
3. **STEP-INDEX-SETTINGS-CORPUS**: Index every settings file and read each in full.
4. **STEP-AUDIT-SETTINGS**: Audit read-only: sections, keys, prose, duplicates, secrets, size, tools, sensitive names, and the identity fields. Write nothing.
5. **STEP-BUILD-SETTINGS-MANIFEST**: One row per item: old ID, old location, new location, disposition, one-line reason. Stop a file with an item that has no disposition.
6. **STEP-DRY-RUN-SETTINGS-REPAIR**: On `dry run`, report the dispositions and stop.
7. **STEP-BACKUP-SETTINGS**: Write the manifest and the project copies; copy the global files to the settings backup.
8. **STEP-WRITE-SETTINGS-CANDIDATE**: Consolidate, rename the keys, split Identity from Profile, verify the tools, trim, and redact. Drop the garbage.
9. **STEP-VERIFY-SETTINGS-CANDIDATE**: Check every item, the identity contract, the canonical keys, the verified tools, the redaction, the size, and that no other store changed.
10. **STEP-REVIEW-SETTINGS-REPAIR**: Run the independent review; require `APPROVED`; fix and re-review.
11. **STEP-REPLACE-SETTINGS-REPAIR**: Replace only an approved file; restore on failure.
12. **STEP-REPORT-SETTINGS-REPAIR**: Report the files, the merges, the trims, the tool changes, the preserved items, the paths, the counts, and the overage.

### Validator and counts

- `support-files/validate-protocol.sh`: `POLICY_FLOOR=24`; the message text follows.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: 24 policies (12 domain and 12 protocol), 15 procedures, 121 steps, 24 test scripts, 50 triggers, floor 24; fix the stale 108-step line to the test's output.
- `README.md`: 15 procedures.
- `docs/simple-ai-workflow-slides.md`: 24 policies, 15 procedures.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`: 24 policies.
- The state context and the daily checkpoint: 24 policies, 15 procedures, 50 triggers, 24 test scripts, floor 24.

### Template

- Rewrite `docs/global-user-settings.md` to the canonical structure, with the identity-only `Name` and `Email`, the `Profile` block, the `Default Shell Path` section, the compact `Tools` list, and a redaction note that names no secret.
- Keep the placeholders and the voice guidance short.

### Tests

- `tests/test-global-settings-repair-fixture.sh`: pins the triggers, the policy mode and load path, the canonical keys, the identity contract, the `Style Sources` absence, the `Git Conventions` pointer absence with the override kept, the tool line shape, the redaction rule, the backup paths, and the dispositions. It also prepares a bloated fixture and checks that a simulated consolidation keeps the identity, drops the garbage, and verifies a tool list. It is a fixture, not a runtime resolver.
- Update the counts in the toolchain note and the docs.
- Run `bash tests/run-all.sh`; the suite goes from 23 to 24 scripts.

### Release

- v6.9.0, a minor release: a new procedure and policy.
- The note is draft-first in `ai/artifacts/release-note-drafts/v6.9.0.md`; the final announcement, the README banner, the tag, and the GitHub release follow the user's approval.

## Risks

- The settings are user-space. The procedure runs from any project, so the manifest lands in the current project's `ai/artifacts/`. The backup stays in the user directory.
- The identity contract is fragile. A rename of `Name` or `Email` breaks the author-identity resolver; the plan pins both.
- The `Sensitive Names` list must never leak. The manifest records the count only.
- The policy count touches the validator floor and the docs; one missed count fails the validator or misleads the reader.
- The tools check differs by OS; the procedure states the native command and never installs.
- A compact file must not be rewritten; the procedure idempotently leaves it alone.

## Acceptance criteria

- The `repair global settings` trigger exists; the straight variants collide with no module.
- The new policy uses `Mode: procedure`, `Load in: repair-global-settings`, and passes the authoring validator.
- The procedure consolidates every settings file into compact bullets under effective headings, with no duplicated universal rules and no prose.
- The canonical keys match the decision; `Name` and `Email` stay under `## Identity`; `Default Shell Path` keeps its name.
- `Role`, `Base`, and `Certs` move to `Profile`; `Certs` is a compact list; `Style Sources` and the `Git Conventions` pointer are gone.
- The tools list is verified, compact, and free of dead entries and prose.
- A bloated file is trimmed; a manifest and a backup exist; a dry run writes nothing; an ambiguous item is preserved.
- The secrets are redacted from the report and the manifest; the sensitive names are counted, never printed.
- The policy floor, the counts, the template, and the toolchain note are consistent.
- The new fixture passes; the suite, the protocol validator, the authoring validator, markdownlint, and shellcheck pass.
- No other global store changes.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`
- Base: `master`
- Branch: `feature/repair-global-settings`, opened at implementation
- Ticket: `ai/issues/open/repair-global-settings-procedure-consolidation-key-names-and-tool-verification.md`; move to `in-progress/` at implementation; close on the branch with the plan attached
- Merge: direct (no `## Merge Policy`; default direct); one squash commit
- ADR: the design decisions are added as part of the change; no trigger
- Validation: `support-files/validate-protocol.sh`; `support-files/validate-policy-authoring.sh` on the changed policies and procedures; `support-files/validate-policy-authoring.sh --triggers`; `tests/run-all.sh`; markdownlint-cli2; shellcheck
- Review: implementation peer review; fix Critical and Major; re-review
- Checkpoint: on the branch; remove the next-steps item
- Release: v6.9.0 minor; release note draft-first for approval; tag and GitHub release
- Done: ticket closed with the plan attached; branch merged and deleted; master pushed; release published

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-19_02-38_review-31.md`; CHANGES REQUESTED; one Major (the `Git Conventions` override was dropped) and four Minor (step count, `Sensitive Names` rename, `Default Shell Path` repetition, policy rule shape). All fixed.
- Round 2: `ai/code-review-reports/2026-11-19_02-41_review-32.md`; APPROVED; no Critical or Major.
