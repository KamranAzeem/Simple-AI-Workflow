Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
URL:
Summary: Replace letter-numbered procedures, numbered steps, and numbered tiers with stable ALL-CAPS kebab names across the whole protocol, with a complete occurrence map, a mapping table for old records, updated validator anchors, a reference-integrity test, and a README banner.

Description:

## Problem

Procedures are labeled by single letters (PROCEDURE A through PROCEDURE I), steps are referenced by number (Step 4, Step 5, Step 7), and tiers are numbered (TIER 1 through TIER 4). Letters and numbers are positional. Any reordering, insertion, or removal silently breaks every reference that points at them, and policies or docs can end up referring to a procedure that has moved. This has already bitten production sessions.

The fix is to name every procedure, every top-level step, and every tier with a stable ALL-CAPS kebab name. Names never renumber, so references stay correct under reordering.

## Confirmed decisions

1. Names are ALL-CAPS kebab-case, no spaces, action-indicating (function-style), for example LOAD-CONTEXT, REPAIR-STATE-FILES.
2. Protocol files refer to these entities by their canonical name. Users keep typing plain phrases; each procedure definition carries an "Aliases" line listing the phrases that resolve to it.
3. Letters are dropped entirely. A mapping table is the fallback for old records only.
4. ADR entries in `protocol-decisions.md` get their references renamed to the new names. Daily checkpoints and closed tickets stay unchanged and are covered by the mapping table.
5. Steps and tiers are named as well.
6. Delivery is one issue with a phased plan.

## Procedure registry

| Old | New name | Aliases (user phrases) |
|---|---|---|
| A | LOAD-CONTEXT | "load context", "load context using AGENTS.md protocol" |
| B | BOOTSTRAP-PROJECT | "bootstrap", "bootstrap using AGENTS.md protocol" |
| C | WRITE-CHECKPOINT | "checkpoint", "save checkpoint" |
| D | RUN-PEER-REVIEW | "peer review", "code review", "PR review" |
| E | POST-COMPACTION-RECOVERY | "post-compaction recovery", "run post-compaction recovery procedure" |
| F | CREATE-BACKUP | "backup ai", "backup ai state" |
| G | EXAMINE-CODEBASE | "examine this codebase", "codebase examination" |
| H | MANAGE-ISSUES | "manage issues", "file an issue", "new issue", "close issue", "reopen issue", "list issues" |
| I | REPAIR-STATE-FILES | "repair state files", "tidy state files", "heal state files" |

## Tier registry

| Old | New name |
|---|---|
| 1 | TIER CONFIGURATION |
| 2 | TIER READ-FIRST-RULES |
| 3 | TIER TRIGGERED-PROCEDURES |
| 4 | TIER APPENDIX |

## Step registry

Every top-level step is named, plus the referenced sub-steps. The full step registry is enumerated in the plan. Example for LOAD-CONTEXT: CUSTOMIZATION-DISCOVERY, WORKFLOW-ACCESS, STRUCTURAL-AUDIT, DISCOVERY, LOADING, STATE-FILE-PROOF-OF-READ, KNOWLEDGE-INDEXING, POLICY-LOADING, PROOF-OF-LOAD. Step names must be globally unique so `STEP <NAME>` is unambiguous. Leading step numbers stay as a visual cue only and must never be referenced.

## Reference format

- `PROCEDURE <NAME>`, for example `PROCEDURE WRITE-CHECKPOINT`.
- `STEP <NAME>`, for example `STEP PROOF-OF-LOAD`.
- `TIER <NAME>`, for example `TIER TRIGGERED-PROCEDURES`.

## Scope

Live files (rename): `AGENTS.md`, `ai/policies/*.md`, `ai/shared/coordination.md`, `ai/shared/project-knowledge/protocol-decisions.md` (ADRs), other current Project Knowledge files, `docs/*`, `README.md`, `support-files/validate-protocol.sh`, `ai-customization.md`, and the two open tickets that reference procedures.

Historical files (leave as-is, covered by the mapping table): `ai/daily-checkpoints/*`, `ai/issues/closed/*`.

Non-protocol occurrences (leave as-is): the sync scripts' internal steps, and the ordinary numbered setup steps in `docs/multi-agent-runbook.md`, `docs/example-learning-session-runbook.md`, `docs/vscode-cline-provider-setup-for-beginners.md`, and `docs/ai-policy-mobile-apps-guide.md`. These must be classified and excluded, not blindly replaced.

## Pre-existing drift to fix

- `ai/policies/ai-policy-code-review.md` uses "Procedure D"; `ai-policies/ai-policy-codebase-examination.md` uses "Procedure G" and "Procedure D". These violate the 2026-08-05 rule that policy files must not use procedure letters or step numbers.
- `docs/workflow-guide.md`, `docs/codebase-examination-guide.md`, and `docs/examples/full-stack-web-mobile-ai-customization.md` use letters, against the 2026-05-21-03 delabel rule.

## Guarding against drift

Future sessions must not reintroduce letters or numbers. The plan adds three durable guards: a rule in `ai-policy-common.md` that references use canonical names only, a validator anchor that fails on any letter-based procedure reference, and the reference-integrity test.

## Acceptance criteria

- Every procedure header is `### PROCEDURE <NAME>:` with an Aliases line; no `PROCEDURE <letter>` remains in any live file.
- Every top-level step and referenced sub-step has a unique name; no protocol `Step <n>` reference remains in live files.
- Tiers use the four names; no `TIER <n>` reference remains in live files.
- Named references resolve: every `PROCEDURE`/`STEP`/`TIER` reference points at exactly one definition.
- ADR references in `protocol-decisions.md` use the new names, with a header note that names were retrofitted.
- A mapping table (old to new) exists and is reachable from the README banner.
- `validate-protocol.sh` passes 8/8 before and after, with new anchors, and fails if a letter-based reference reappears.
- The reference-integrity test passes before and after; the before-run is captured as the baseline.
- README carries a top banner about the change.
- markdownlint is clean on changed markdown.

## Notes

- Supersedes `ai/issues/open/procedure-naming-readability.md` (the narrower earlier ticket for procedures only).
- This is an XL change. The plan splits it into phases and uses the occurrence map plus the reference-integrity test as the safety net.

---

2026-10-06
Implemented on branch `feature/descriptive-names-for-procedures-steps-and-tiers`. Nine procedures, 53 steps and sub-steps, four tiers, and eight Proof-of-Load items now use stable ALL-CAPS kebab names; per-procedure Aliases lines added; letters and step numbers dropped from live files; ADR references retrofitted. Canonical-name rule added to `ai-policy-common.md`; validator v6.0 with new anchors and a no-letter/no-number guard; new `support-files/test-protocol-references.sh`; migration map at `ai/shared/project-knowledge/protocol-name-migration-map-2026-10-06.md`; README banner added. Historical ADR step numbers were intentionally left, because step positions changed over time. Validator 8/8, reference test PASS, markdownlint 0. Peer review review-07 CHANGES REQUESTED, review-08 APPROVED. Closed by the squash merge into `master`.
