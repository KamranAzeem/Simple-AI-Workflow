Reported: 2026-11-18
Reporter: Kamran Azeem
IssueType: Bug
Severity: Human-to-decide (AI estimate: P2)
Size: S
Label:
URL:
Summary: Fix the three defects the AGENTS.md refactor left in a pointer, a rule scope, and a loading sentence

Description:

- The v6.6.1 refactor renamed the Single-Writer bullet and moved procedure detail. A wide sweep of every artifact that references `AGENTS.md` found these defects.
- `ai/procedures/write-checkpoint.md:18` cited `TIER READ-FIRST-RULES "State File Single-Writer Ownership"`. The bullet is now `State File Single-Writer`. The reference test does not check quoted bullet text, so the suite stayed green.
- `AGENTS.md:87` (Protocol Developer Mode) covered `AGENTS.md`, a policy, a procedure, and a validator script. The pre-refactor rule also covered any file under `ai/`. That scope was lost.
- `AGENTS.md:89` (Policy Loading Set) said "Do not scan the **Project AI Policies Directory**". The index step scans that directory for metadata, so the sentence contradicted the index.
- `support-files/validate-protocol.sh:71` still named `State File Single-Writer Ownership` in its error message.
- Root cause: no test checked quoted `TIER READ-FIRST-RULES` labels. `tests/test-protocol-references.sh` now checks every quoted label against a bold bullet in `AGENTS.md`; the old label fails it.
- No behavior change beyond restoring the pre-refactor scope of the maintainer rule.

## Acceptance Criteria

- The `write-checkpoint.md` pointer names the current bullet `State File Single-Writer`.
- The Protocol Developer Mode rule covers every file under `ai/`.
- The Policy Loading Set forbids body loading, not the metadata index, and does not contradict `load-context` step 2.
- The validator message names the current bullet.
- The reference test checks quoted TIER labels and would have caught the old pointer.
- `AGENTS.md` stays under 160 lines, 2,400 words, and 24,900 bytes; the shape fixture passes.
- The reference test, protocol validator 8/8, full suite, and markdownlint pass.
- Peer review APPROVED.
- The v6.6.3 note is drafted, edited by the user, and only then published.
- The common-policy rewrite plan moves to v6.6.4.

## Plan

Plan attached below.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/agents-md-refactor-followups.md` (S).
- The v6.6.1 refactor left three defects in references and rule scope, plus one stale validator message.
- Fixes only. No new rule and no behavior change beyond restoring the pre-refactor scope.

### Evidence

- `ai/procedures/write-checkpoint.md:18` quoted `"State File Single-Writer Ownership"`. `AGENTS.md:85` is `**State File Single-Writer**`. The reference test checks that references resolve, not the quoted text.
- The pre-refactor Protocol Developer Mode rule covered `AGENTS.md`, policy files, `validate-protocol.sh`, and any file under `ai/`. `design-docs/protocol-decisions.md:81` records the unconditional rule. The refactored `AGENTS.md:87` listed only `AGENTS.md`, a policy, a procedure, and a validator script, so every other file under `ai/` fell out.
- `AGENTS.md:89` said "Do not scan the **Project AI Policies Directory**". `ai/procedures/load-context.md` step 2 indexes that directory, including in Protocol Developer Mode. The sentence forbade the metadata scan too.
- `support-files/validate-protocol.sh:71` printed `State File Single-Writer Ownership rule missing...`.
- No test asserted the quoted bullet text, so the suite passed. `tests/test-protocol-references.sh` now checks every quoted `TIER READ-FIRST-RULES` label against a bold bullet in `AGENTS.md`; the old label fails it.

### Approach

- Changed `write-checkpoint.md:18` to `TIER READ-FIRST-RULES "State File Single-Writer"`.
- Added `or any file under \`ai/\`` to the Protocol Developer Mode file list in `AGENTS.md`.
- Changed the Policy Loading Set to "Do not load every file from the **Project AI Policies Directory** as body text; it is the distribution tree, not your working set."
- Changed the validator message to `State File Single-Writer rule missing from TIER READ-FIRST-RULES in AGENTS.md.`
- Added the quoted-label check to `tests/test-protocol-references.sh`: every `TIER READ-FIRST-RULES "<label>"` must name a bold bullet in `AGENTS.md`.
- Updated the common-policy rewrite plan's release from v6.6.3 to v6.6.4 in all three spots: Context, AC-011, Close Sequence.
- No other changes.

### Acceptance Criteria

- AC-001: the write-checkpoint pointer names `State File Single-Writer`.
- AC-002: the maintainer rule covers every file under `ai/`.
- AC-003: the loading-set rule forbids body loading, not the metadata index; it names the directory and the body text.
- AC-004: the validator message names the current bullet.
- AC-005: `AGENTS.md` stays under the shape caps and the shape fixture passes.
- AC-006: the reference test, protocol validator 8/8, full suite, and markdownlint pass.
- AC-007: the common-policy rewrite plan says v6.6.4.
- AC-008: peer review APPROVED.
- AC-009: the v6.6.3 note is drafted, edited by the user, and only then published.
- AC-010: the reference test checks every quoted `TIER READ-FIRST-RULES` label and fails on the old one.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the v6.6.2 release commit.
- Branch: `fix/agents-md-refactor-followups`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: closed in the branch commit with this plan attached.
- Release: v6.6.3, patch. The note was drafted in `ai/artifacts/release-note-drafts/`, approved by the user, and only then published.
- Verification: shape fixture, reference test, protocol validator, full suite, markdownlint.
- Branch deletion: local and remote after the release.

### Peer Review Log

- Plan round 1, `2026-11-18_23-20_review-15.md`: APPROVED. One Minor: confirm no third v6.6.3 remains in the rewrite plan. There were three spots; all updated.
- Implementation round 1, `2026-11-18_23-22_review-16.md`: APPROVED.
- Final round, `2026-11-18_23-25_review-17.md`: APPROVED with the quoted-label test check. One pre-existing shellcheck style warning recorded, not gating.

---

2026-11-18
Closed: the pointer, the maintainer scope, and the loading sentence are fixed; the validator message is updated; the reference test now checks quoted TIER labels and fails on the old one. `AGENTS.md` is 135 lines and 1,617 words. The v6.6.3 release carries it.
