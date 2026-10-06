# Implementation Plan: Descriptive Names for Procedures, Steps, and Tiers

## Metadata

- **Issue**: `ai/issues/open/descriptive-names-for-procedures-steps-and-tiers.md`
- **ADR store**: `ai/shared/project-knowledge/protocol-decisions.md`
- **Branch (planned)**: `feature/descriptive-names-for-procedures-steps-and-tiers`
- **Author**: Kilo
- **Date**: 2026-10-06
- **Status**: Draft, pending peer review

## Goal

Replace letter-numbered procedures, numbered steps, and numbered tiers with stable ALL-CAPS kebab names across the whole protocol. Names do not renumber, so references survive reordering. Provide a complete occurrence map, a mapping table for old records, updated validator anchors, a reference-integrity test, and a README banner.

## Non-goals

- No behavior change. Every procedure, step, and tier keeps its current function, order, and content.
- No rewrite of daily checkpoints or closed tickets (they are the archive).
- No rename of non-protocol "Step N" usage in the sync scripts or in the runbook/setup guides that have their own steps.

## Confirmed decisions

- Names are ALL-CAPS kebab, action-indicating, and globally unique.
- Protocol files reference names; users use plain phrases; each procedure header carries an Aliases line.
- Letters and numbers are dropped entirely; a mapping table is the fallback for old records.
- ADR references in `protocol-decisions.md` are renamed; daily checkpoints and closed tickets are left as-is.
- Steps and tiers are named too.
- One issue, phased delivery.

## Procedure registry

| Old | New name | Aliases |
|---|---|---|
| A | LOAD-CONTEXT | load context; load context using AGENTS.md protocol |
| B | BOOTSTRAP-PROJECT | bootstrap; bootstrap using AGENTS.md protocol |
| C | WRITE-CHECKPOINT | checkpoint; save checkpoint |
| D | RUN-PEER-REVIEW | peer review; code review; PR review |
| E | POST-COMPACTION-RECOVERY | post-compaction recovery; run post-compaction recovery procedure |
| F | CREATE-BACKUP | backup ai; backup ai state |
| G | EXAMINE-CODEBASE | examine this codebase; codebase examination |
| H | MANAGE-ISSUES | manage issues; file an issue; new issue; close issue; reopen issue; list issues |
| I | REPAIR-STATE-FILES | repair state files; tidy state files; heal state files |

## Tier registry

| Old | New name |
|---|---|
| 1 | TIER CONFIGURATION |
| 2 | TIER READ-FIRST-RULES |
| 3 | TIER TRIGGERED-PROCEDURES |
| 4 | TIER APPENDIX |

## Step registry

Top-level steps and referenced sub-steps, all ALL-CAPS kebab and globally unique. Leading numbers stay only as a visual cue, never referenced.

**LOAD-CONTEXT**
- CUSTOMIZATION-DISCOVERY
- WORKFLOW-ACCESS
- STRUCTURAL-AUDIT
- DISCOVERY
- LOADING
- STATE-FILE-PROOF-OF-READ (sub-step of LOADING)
- KNOWLEDGE-INDEXING
- POLICY-LOADING
- PROOF-OF-LOAD
- Proof-of-Load items (referenced, so named): CUSTOMIZATION-SECTIONS, SETTINGS-AND-POLICIES, HANDOFFS, STATE-FILE-HEALTH, KNOWLEDGE-INDEX, STATE-FILE-COUNTS, ISSUES-INDEX, STALE-KNOWLEDGE

**BOOTSTRAP-PROJECT**
- ENSURE-DIRECTORIES
- CREATE-MISSING-FILES
- INITIALIZE-CUSTOMIZATION
- INITIALIZE-STATE-FILES
- GIT-SETUP
- FINALIZE-BOOTSTRAP

**WRITE-CHECKPOINT**
- ATOMIC-WRITE
- WRITE-DIRECTION (sub-step)
- FRESH-READ-BEFORE-WRITE (sub-step)
- INBOUND-RECONCILE (sub-step)
- SEQUENTIAL-WRITE-ORDER (sub-step)
- TRANSACTION-LOG (sub-step)
- ABORT-ON-MISSING-DATA (sub-step)
- DAILY-CHECKPOINT-FILE
- STATE-FILE-TRIMMING
- PROJECT-KNOWLEDGE-UPDATE
- CONTEXT-RE-AFFIRMATION

**RUN-PEER-REVIEW**
- ADOPT-REVIEWER-ROLE
- RESOLVE-PR
- SCAN-SCOPE
- WRITE-REVIEW-REPORT
- ITERATE-REVIEW
- EXIT-REVIEW-ROLE

**POST-COMPACTION-RECOVERY**
- READ-AGENTS
- READ-CUSTOMIZATION
- READ-SETTINGS
- INDEX-KNOWLEDGE
- LOAD-POLICIES
- READ-COORDINATION
- RELOAD-REPORT

**CREATE-BACKUP**
- BACKUP-MANDATE
- REPORT-BACKUP-PATH

**EXAMINE-CODEBASE**
- LOAD-EXAMINATION-POLICY
- RUN-EXAMINATION-WORKFLOW
- EXIT-EXAMINATION

**MANAGE-ISSUES**
- LOAD-ISSUE-MECHANISM
- LOCATE-TICKET
- ACT-ON-ISSUE-REQUEST
- EXIT-ISSUE-MODE

**REPAIR-STATE-FILES**
- LOAD-STATE-RULES
- DIAGNOSE-STATE
- REPAIR-STATE
- REPORT-REPAIR
- EXIT-REPAIR-MODE

## Reference format

- Procedures: `PROCEDURE <NAME>`.
- Steps: `STEP <NAME>`.
- Tiers: `TIER <NAME>`.
- Report items: `ITEM <NAME>`, used only inside PROOF-OF-LOAD and the STATE-FILE-PROOF-OF-READ reference to it.
- Procedure headers: `### PROCEDURE <NAME>: <trigger phrase>` followed by a `**Aliases**: <phrase list>` line. Two procedures have no phrase trigger:
  - `### PROCEDURE BOOTSTRAP-PROJECT: Empty repository` with aliases "bootstrap; bootstrap using AGENTS.md protocol".
  - `### PROCEDURE POST-COMPACTION-RECOVERY: Automatic after conversation compaction` with aliases "post-compaction recovery; run post-compaction recovery procedure".
- Step headers: `N. **STEP-<NAME>**: ...` for top-level steps; sub-steps keep their bold name.
- The PROOF-OF-LOAD report lists its items with bold names, for example `- **ITEM STATE-FILE-HEALTH**: ...`. The reference in STATE-FILE-PROOF-OF-READ to "bullet (d)" becomes "the STATE-FILE-HEALTH item".

## Historical and non-protocol classification

Every occurrence of an old reference is classified before editing:

- **protocol-live**: `AGENTS.md`, `ai/policies/*.md`, `ai/shared/coordination.md`, current Project Knowledge except ADR-history, `docs/*`, `README.md`, `support-files/validate-protocol.sh`, `ai-customization.md`, and open tickets. Rewrite to the new names.
- **protocol-historical**: daily checkpoints and closed tickets. Leave unchanged; covered by the mapping table.
- **ADR-history**: `ai/shared/project-knowledge/protocol-decisions.md`. Rewrite references to the new names (user decision), with a header note that names were retrofitted, so the record stays navigable.
- **non-protocol**: ordinary "Step N" usage in the sync scripts' internal comments and in `docs/multi-agent-runbook.md`, `docs/example-learning-session-runbook.md`, `docs/vscode-cline-provider-setup-for-beginners.md`, `docs/ai-policy-mobile-apps-guide.md`. Leave unchanged.
- **user-side (out of scope)**: `ai-customization.md` files in other projects are not rewritten by the sync script. Old letters there are covered by the mapping table; the user updates theirs on the next edit. This repo's own `ai-customization.md` is protocol-live and is updated.

## Occurrence map

Phase 0 produces `ai/shared/project-knowledge/protocol-name-migration-map-2026-10-06.md`:

- One row per occurrence: file, line, matched token, class (live / historical / ADR-history / non-protocol), replacement.
- Generated by a throwaway script under `/tmp/kilo/`, then reviewed by hand. The script is not committed.
- The map doubles as the executable checklist and the proof that nothing was missed.
- It also records the old-letter to new-name table for procedures, tiers, and steps, reachable from the README banner.
- Open the map with a one-line "What this is" header so a reader landing on it knows its purpose.

## Phases

- **Phase 0, Map and baseline (no edits).** Generate the occurrence map. Run `validate-protocol.sh` and the new `test-protocol-references.sh` on the current tree and save the outputs as the pre-change baseline.
- **Phase 1, Procedures and tiers.** Rename the nine procedure headers and four tier headers in `AGENTS.md`; add Aliases lines. Update all procedure and tier references in `AGENTS.md`. Update `validate-protocol.sh` anchors and error strings; add the no-letter guard. Add the naming rule to `ai-policy-common.md`. Run validator and test.
- **Phase 2, Steps.** Rename top-level steps and referenced sub-steps in `AGENTS.md`; convert every numeric step reference to `STEP <NAME>`; name the PROOF-OF-LOAD items and remove the "bullet (x)" reference. Run validator and test.
- **Phase 3, Live non-AGENTS files.** Rewrite references in `ai/policies/*.md`, `ai/shared/coordination.md`, current Project Knowledge, `docs/*`, `README.md` (plus banner), `support-files/validate-protocol.sh`, `ai-customization.md`, and the two open tickets. Fix the pre-existing policy and doc drift. Run validator and test.
- **Phase 4, ADRs.** Rename references in `protocol-decisions.md`, add the retrofit header note, and add the new dated ADR entry documenting the rename and the mapping. Run validator and test.
- **Phase 5, Verify and review.** Run the full verification suite, compare against the baseline, peer-review the implementation to APPROVED, close the ticket on the branch, and merge.

## Validator changes

- Update step 1 anchors to the new headers: `### PROCEDURE LOAD-CONTEXT:`, `### PROCEDURE RUN-PEER-REVIEW:`, `### PROCEDURE CREATE-BACKUP:`, `### PROCEDURE EXAMINE-CODEBASE:`, `### PROCEDURE MANAGE-ISSUES:`, `### PROCEDURE REPAIR-STATE-FILES:`, and keep the `POST-COMPACTION-RECOVERY` title anchor.
- Update step-string anchors: `STEP KNOWLEDGE-INDEXING`, `STEP POLICY-LOADING`, `STEP PROOF-OF-LOAD`, `STEP STATE-FILE-PROOF-OF-READ`, `STEP FRESH-READ-BEFORE-WRITE`, `STEP ATOMIC-WRITE`, `STEP DAILY-CHECKPOINT-FILE`, `STEP STATE-FILE-TRIMMING`.
- Update error strings that name procedures or steps.
- Add a guard: fail if `PROCEDURE [A-I][:]` or `### PROCEDURE [A-I]` appears in `AGENTS.md`.
- Bump every version string: the `--- Starting Protocol Validation vX.Y ---` header, the `--- Protocol Validation vX.Y Completed Successfully ---` footer, and any other occurrence.
- The validator has no tier anchors today, so only the renamed tier references in `AGENTS.md` change, not an anchor.

## New test: support-files/test-protocol-references.sh

Two check groups:

1. **Resolvability (scheme-agnostic).** Every `PROCEDURE <token>`, `STEP <token>`, and `TIER <token>` reference in live protocol files resolves to exactly one defined header; every defined header name is unique. Passes under both the old and the new scheme, so it records the baseline and proves no dangling references were introduced.
2. **Conformance (new scheme).** No `PROCEDURE [A-I]`, no protocol `Step [0-9]`, and no `TIER [0-9]` in the live protocol files. Fails before the change (documents the old scheme) and passes after.

The script prints a pass/fail summary and exits non-zero on failure, like the existing `test-sync-agents-md.sh`. It is written first, in Phase 0, before any rename. The resolvability group treats letter headers (`### PROCEDURE A:`) as valid defined names, so it passes on the current tree; the conformance group is the only part that moves from fail to pass.

## Other required changes

- **Policy rule**: add to `ai-policy-common.md` (always loaded) a short rule, worded exactly: "Refer to procedures, steps, and tiers by their canonical ALL-CAPS kebab names (for example PROCEDURE WRITE-CHECKPOINT, STEP PROOF-OF-LOAD, TIER TRIGGERED-PROCEDURES). Never reference them by letter or number." This is the durable guard against future drift, backed by the validator guard and the test. Recorded as an ADR.
- **README banner**: a top-of-file notice about the naming change, mirroring the history-rewrite banner, pointing to the mapping table.
- **docs**: `workflow-guide.md`, `codebase-examination-guide.md`, and `docs/examples/full-stack-web-mobile-ai-customization.md` updated to the new names. Note: the 2026-05-21-03 delabel rule kept internal labels out of docs; using the stable names is a deliberate, recorded relaxation. Record it in the ADR.
- **Policies**: `ai-policy-code-review.md` and `ai-policy-codebase-examination.md` updated, fixing the 2026-08-05 violation.
- **ADR entry**: a dated entry in `protocol-decisions.md` recording the rename, the decisions, the guard, and the mapping table location; plus a one-line header note that names were retrofitted.

## Acceptance criteria

- Every procedure header is `### PROCEDURE <NAME>:` with an Aliases line; no `PROCEDURE <letter>` remains in any live file.
- Every top-level step and referenced sub-step has a unique name; no protocol `Step <n>` reference remains in live files.
- Tiers use the four names; no `TIER <n>` reference remains in live files.
- Every `PROCEDURE`/`STEP`/`TIER` reference resolves to exactly one definition, and all names are unique.
- ADR references use the new names, with the retrofit header note.
- The mapping table exists and is reachable from the README banner.
- `validate-protocol.sh` passes 8/8 before and after, with new anchors and the no-letter guard.
- `test-protocol-references.sh` resolvability check passes before and after; conformance check fails before and passes after; both runs captured.
- README banner present. markdownlint 0 on changed markdown.

## Verification steps

1. `bash support-files/validate-protocol.sh` to 8/8.
2. `bash support-files/test-protocol-references.sh` to pass, before and after.
3. `git grep -inE "PROCEDURE [A-I]|TIER [0-9]"` over live files to zero (case-insensitive).
4. `git grep -inE "Step [0-9]"` over live protocol files only (exclude the runbook/setup docs and scripts) to zero.
5. markdownlint on changed markdown to 0.
6. Confirm each name appears exactly once as a header and every reference resolves.

## Risks and mitigations

- **Blind replace corrupts non-protocol "Step N"**: mitigated by the occurrence map classification and by scoping the checks to live protocol files.
- **ADR rewrite damages the historical record**: mitigated by renaming reference tokens only, adding a retrofit header note, and keeping the mapping table; recorded as a deliberate exception.
- **Validator anchor breakage**: anchors and error strings updated in the same commit; validator run before and after.
- **External POST-COMPACTION-RECOVERY trigger stops resolving**: the alias list keeps "post-compaction recovery" matching; the setup guide is updated; the external user-memory trigger and PreCompact hook are user-side and unchanged in behavior.
- **Large diff hides a missed reference**: the map plus the resolvability test is the safety net; each phase is reviewed before the next.
- **Future sessions reintroduce numbers**: the policy rule, the validator guard, and the test all fail on regression.

## Process

1. Open branch `feature/descriptive-names-for-procedures-steps-and-tiers` before the first commit.
2. Execute Phases 0 to 4.
3. Run verification; capture before/after outputs.
4. Peer-review the implementation; iterate to APPROVED.
5. Move the ticket to `ai/issues/in-progress/` when work starts; close it on the branch before the squash merge.
6. Append the merge record to the ADR and remove this plan after merge.
