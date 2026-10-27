Reported: 2026-10-27
Reporter: Kamran Azeem
IssueType: Defect/Bugfix
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Canonical state-file and diary headers must be defined verbatim in the common policy, verified at boot, and restored by repair

Description:

A live project's `ai/state/context.md` carried a header that did not match the sanctioned shape, and it accumulated checkpoint history as a result. The header is the file's only in-band statement of its role, so a wrong header silently changes what the AI treats the file as. This is a protocol defect, not a one-off editing mistake.

**Why the current rules let this happen**

- The common policy (`ai-policy-common.md`, `## State File Ownership Protocol`) describes what each state file is for, but never states the literal header text.
- `AGENTS.md:110` (`STEP-STATE-FILE-PROOF-OF-READ`) checks only that "each carries its one-line rule comment", so any comment line passes.
- `AGENTS.md:143` and `AGENTS.md:172` create state files and checkpoint files with "a rule-comment line" and a "one-line diary rule comment", without a canonical string to copy.
- `AGENTS.md:284` says "Restore the one-line rule comment if missing", so a present-but-wrong header is never repaired.
- `support-files/validate-protocol.sh:183` checks only that the file contains the substring `State file (`.
- `docs/workflow-guide.md:370`, `README.md:354`, and the slides repeat the presence-only wording.

**Current state in this repo (also non-compliant with the requested rule)**

- `ai/state/context.md:1` is `<!-- State file (present). Dashboard plus active working context. Short bullets with a pointer to Project Knowledge. No history, no git metadata. -->` and names no policy or section.
- `ai/state/progress.md:1` is `<!-- State file (past). Newest at the bottom. Short bullets, max 3 lines per item. No git metadata. Completed items older than 14 days move to the daily checkpoints. -->` and names no policy or section.
- `ai/state/next-steps.md:1` is `<!-- State file (future). Open items only, oldest first, delete on done. Short bullets. Never drop an unfinished item. -->` and names no policy or section.
- `ai/daily-checkpoints/2026-10-21.md:1` is `<!-- Daily checkpoint (diary). Append-only: one file per calendar day, newest section at the bottom. Never edit or reorder earlier sections. This is the only archive. -->` and names no policy or section.

**Requested behavior**

1. The common policy shows the exact header for each file type: `context.md`, `progress.md`, `next-steps.md`, and a daily checkpoint. Each header is copied verbatim into the matching file, carries that file's operational rules inline, and names `ai-policy-common.md` plus the section so a capable assistant can trace the authority.
2. `load context` compares each loaded state-file header, and today's daily-checkpoint header, with the canonical text. A mismatch produces an immediate warning under ITEM STATE-FILE-HEALTH: state-file health is degraded and work quality is at risk, so fix it now with `repair state files`. Historical checkpoints are not checked or backfilled.
3. `repair state files` restores the exact canonical header, in addition to its current repairs.

**Immutability vs repair (proposed resolution)**

The AI never composes or edits header text. The policy is the single source of truth. Repair is the only writer of an existing block; bootstrap and checkpoint creation copy the canonical block for new files. The header is not a bare pointer: its rules are visible markdown bullets, so a weak or freshly compacted agent sees them even if it skims HTML comments. It also names the policy, section, and subsection so a capable agent can trace the authority. Stable START and END markers delimit the block; repair replaces the inclusive range and stops if the markers are malformed rather than guessing at body content.

**Implementation plan**

The detailed design, the final draft blocks, the open decisions, and the review log live in `ai/plans/canonical-state-file-headers-plan.md`. The plan supersedes the earlier draft blocks in this ticket.

**Acceptance criteria**

- AC1: The common policy shows the four canonical blocks verbatim in `### Canonical State-File Headers`, each naming the policy, section, and subsection and carrying the rules.
- AC2: This repo's three state files and every checkpoint written from adoption onward carry the exact block, and a fresh or compacted agent can follow the file's rules from the header alone.
- AC3: Boot reports a mismatch with `[FAILED]`, the health warning, and the `repair state files` instruction, and writes nothing.
- AC4: Repair restores the exact block and the diary title date, preserves the body with a checksum, reports changes, and stops on malformed markers.
- AC5: Bootstrap, checkpoint creation, atomic write, trimming, and repair all copy the same policy block.
- AC6: `validate-protocol.sh` exact-checks the blocks and anchors the subsection, fails on zero or duplicate policy blocks, keeps the 20 KB advisory as a soft target, updates the docs, and records the ADRs.
- AC7: The negative fixtures and the boot simulation pass, plus the main validator, authoring validator, `test-protocol-references.sh`, markdownlint, shellcheck, and peer review.

**Blast radius**

- `ai/policies/ai-policy-common.md` (read-only guard, explicit approval)
- `ai/policies/ai-policy-meta.md` (literal-artifact clause, explicit approval)
- `AGENTS.md`: `STEP-LOADING`, `STEP-STATE-FILE-PROOF-OF-READ`, `ITEM STATE-FILE-HEALTH`, `STEP-INITIALIZE-STATE-FILES`, `STEP-ATOMIC-WRITE`, `STEP-DAILY-CHECKPOINT-FILE`, `STEP-STATE-FILE-TRIMMING`, `PROCEDURE REPAIR-STATE-FILES`
- `support-files/validate-protocol.sh` only. No new helper or test script; the header check lives in the existing validator.
- `docs/workflow-guide.md`, `README.md`, `docs/simple-ai-workflow-slides.md`
- `design-docs/protocol-decisions.md`
- The sync scripts copy `AGENTS.md`, ensure `ai-customization.md`, and migrate state files; they do not copy support files, so no sync change is planned.

**Related**

- `ai/issues/closed/state-file-order-and-bloat-self-healing.md` delivered State-File Model v2, the presence-only check, and the one-line diary comment that this ticket tightens into an exact canonical comparison.

---

2026-10-27
Plan: `ai/plans/canonical-state-file-headers-plan.md`. Peer review rounds 1 through 5 requested changes; round 6 APPROVED with minor implementation notes. The user then chose no additional scripts at all, so the header check is folded into `validate-protocol.sh` and the helper and test scripts are dropped. The focused re-review (round 7) APPROVED with minor notes. All decisions are approved: soft-target rule, authoring exception, validator scope (no new scripts), boot behavior, and repair boundary. The plan is ready to implement. Reports: `ai/code-review-reports/2026-10-27_15-25_review-01.md`, `2026-10-27_15-40_review-02.md`, `2026-10-27_15-55_review-03.md`, `2026-10-27_16-10_review-04.md`, `2026-10-27_16-25_review-05.md`, `2026-10-27_16-40_review-06.md`, and `2026-10-27_17-00_review-07.md`.

---

2026-10-27
Closed. Implemented on the feature branch and squash-merged to master for v5.3.0. The common policy now owns four canonical header blocks; `AGENTS.md` checks them at load and repair restores them; `validate-protocol.sh` checks them; the KB figures are soft targets; the literal-artifact authoring clause is recorded. Main validator 8/8, authoring validator PASSED, reference test PASS, markdownlint 0; the header negative fixtures pass. Plan: `ai/plans/canonical-state-file-headers-plan.md`. Review rounds 1 through 7; round 7 APPROVED.

2026-10-27
Released as v5.3.0: <https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v5.3.0>.
