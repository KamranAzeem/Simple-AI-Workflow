# Plan: Add a user-global skills root

Ticket: `ai/issues/open/user-global-skills-root.md`
Status: APPROVED by review round 2 (review-52)
Size: L
Release: minor, proposed v6.11.0

## Evidence

- The ticket asks for a third skills root at `(Global User AI Directory)/skills/`, with the package name, description, path, and scope indexed at boot, the body read only on activation, the precedence project then user-global then clone, collision reporting, docs, and tests.
- Read in full for this plan: `AGENTS.md` (the TIER CONFIGURATION roots and the shared steps), `ai/procedures/load-context.md` (the discovery, skills, structural audit, and proof), `ai/procedures/post-compaction-recovery.md`, `ai/procedures/write-checkpoint.md`, `ai/policies/ai-policy-common.md` (the skills invariant), `ai/policies/ai-policy-knowledge.md`, `docs/ai-customization-guide.md`, `docs/setup.md`, `tests/test-skills-index.sh`, `tests/test-load-context-boot.sh`, `tests/test-sync-agents-md.sh`, `support-files/sync-agents-md.sh`, and the skills ADR entry.
- Open questions from the ticket are settled: the sync checks the root and never copies; the precedence is project, then user-global, then clone; v1 adds no 50-skill threshold and reports the count in the checkpoint.

## Goals

- A third skills root at `(Global User AI Directory)/skills/`.
- The boot indexes the three roots by name, description, path, and scope; no body is read.
- A project skill overrides a user-global skill, and a user-global skill overrides a clone skill; every override and cross-root collision is reported.
- The docs, the ADR, and the tests describe the third root.
- The sync checks the root and never copies a skill.

## Non-goals

- Changing the `SKILL.md` package format, the activation rules, or the skill trust model.
- Copying skills in the sync scripts.
- A 50-skill review threshold in v1; the checkpoint reports the count, and a later change may add the threshold.
- Migrating or moving an existing skill package.

## HLD

### HLD-001: The third root and precedence

- The root is `(Global User AI Directory)/skills/`, beside the settings and knowledge directories.
- The clone's `(Global AI Workflow Directory)/ai/skills/` stays the protocol's own root; the project's `ai/skills/` stays the project root.
- Precedence: project, then user-global, then clone. A user-global package replaces a clone package with the same name; a project package replaces both; the override is reported.
- A name that appears in two or three roots is reported even when one root wins.
- The skills index holds no body and writes no file.

### HLD-002: The index and the boot

- `STEP-SKILLS-INDEX` reads the three roots one level deep, requires `SKILL.md` frontmatter `name` and a one-line `description` of at most 200 characters, and records the name, the description, the path, and the scope (`project`, `user-global`, or `clone`).
- The step skips hidden entries, symlinks, invalid packages, and an absent root; it bounds the index at 16 KB.
- `STEP-STRUCTURAL-AUDIT` creates `(Global User AI Directory)/skills/` when it is missing; it creates no package.
- The load-context, post-compaction recovery, and checkpoint re-affirmation reference the same step; the proof gains the user-global scope count.

## LLD with Acceptance Criteria

### LLD-001: `AGENTS.md`

- Add `**User-Global AI Skills Directory**: (Global User AI Directory)/skills/` to the TIER CONFIGURATION roots.
- Change the shared `STEP-SKILLS-INDEX` sentence from "both skill roots" to "the three skill roots" and name the user-global scope.
- Acceptance: the validator anchors the new root and the three-root step; `AGENTS.md` stays within 160 lines, 24,900 bytes, and 2,400 words.

### LLD-002: `load-context.md` and the procedures

- Add the user-global root to `STEP-DISCOVERY` and to the `STEP-STRUCTURAL-AUDIT` global list.
- Change `STEP-SKILLS-INDEX` in `STEP-KNOWLEDGE-INDEXING` to the three roots and the new scope; keep the 16 KB bound and the no-body rule.
- Update `ITEM SKILLS-INDEX` to the three scopes and the override and collision counts.
- The post-compaction recovery and checkpoint re-affirmation point at the same step, not a copy.
- Acceptance: the boot fixture checks the root and the three scopes; the proof text names the user-global scope.

### LLD-003: Sync

- `support-files/sync-agents-md.sh` and `support-files/sync-agents-md.ps1` check the user-global skills root: a dry-run reports the package count and any invalid package; the real run reports the count and never copies or edits a skill.
- Acceptance: `tests/test-sync-agents-md.sh` covers the check-only path, the absent root, and the invalid package.

### LLD-004: Tests and fixtures

- `tests/test-skills-index.sh`: a user-global package; a clone package with the same name; a project package with the same name; the precedence; the override report; the cross-root collision; the hidden, symlink, invalid, and overlong-description cases; the 16 KB bound.
- `tests/test-load-context-boot.sh`: the user-global root and the three-scope text.
- `tests/test-sync-agents-md.sh`: the check-only behavior.
- Acceptance: the full suite, both validators, markdownlint, and shellcheck are green.

### LLD-005: Docs and ADR

- `docs/ai-customization-guide.md`: describe the user-global skills root under the Global User AI Directory; the precedence and the no-copy sync.
- `docs/setup.md` and `docs/how-policies-work-in-this-workflow.md`: the third root and the activation boundary.
- `design-docs/protocol-decisions.md`: one dated entry for the third root, the precedence, the check-only sync, and the no-threshold v1.
- `docs/announcements/v6.11.0.md` and the README banner.
- Acceptance: markdownlint is clean; the ADR entry is self-contained; the release note is in the user's voice.

## ADRs

### ADR-001: Three roots, one index, one precedence

Decision: add the user-global root and index the three roots with the existing step; the precedence is project, user-global, clone.
Context: the user wants cross-project skills without putting them in the clone or every project.
Consequences: one more root in the index; the override and collision reports grow; the package format and activation do not change.

### ADR-002: The sync checks, never copies

Decision: the sync reports the user-global skills count and invalid packages; it never copies or edits a skill.
Context: the user-global root is the user's own; the sync already owns `AGENTS.md` and `ai-customization.md`.
Consequences: the root stays user-owned; the check catches an invalid package early; the sync output grows by one line.

### ADR-003: No 50-skill threshold in v1

Decision: report the count at the checkpoint; add no threshold.
Context: the skills index is small and bounded at 16 KB; a threshold without evidence would be a new rule.
Consequences: the checkpoint reports the count; a later change can add the threshold.

## Risks and Gaps

- RSK-001: the user-global root may contain a secret or a stale package. Mitigation: the index reads only the frontmatter; activation is explicit; the user owns the root.
- RSK-002: a same-name package can hide another. Mitigation: the override and the cross-root collision are reported.
- RSK-003: the sync check may drift from the index. Mitigation: one fixture for both.

## Test Plan

- `tests/test-skills-index.sh`: the three roots, precedence, override, collision, invalid packages, the 16 KB bound, and no body read.
- `tests/test-load-context-boot.sh`: the user-global root and the three-scope proof.
- `tests/test-sync-agents-md.sh`: the check-only path.
- `tests/test-agents-md-shape.sh` and `tests/test-common-boundary.sh`: the shape and the one-way boundary.
- Host checks: the suite, both validators, markdownlint, shellcheck.

## Close Sequence

- Branch `feature/user-global-skills-root` from `master`.
- Implementation review APPROVED before the commit.
- The ticket moves to `in-progress/`, the plan is attached, the ticket moves to `closed/`, and the plan file is deleted.
- The checkpoint runs on the branch before the commit.
- The squash merge to `master`, the push, the branch delete, the tag `v6.11.0`, and the GitHub Release.

## Peer Review Log

- Round 1: `2026-11-19_09-28_review-51.md`, CHANGES REQUESTED. Fixed the missing structural-audit creation, the sync dry-run/real-run split, the proof scope count, the no-threshold decision, and the two root-naming slips.
- Round 2: `2026-11-19_09-32_review-52.md`, APPROVED. No new Critical, Major, or Minor.
