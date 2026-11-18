Reported: 2026-11-18
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: L
Label:
URL:
Summary: Apply the AGENTS.md audit: move procedure detail to its owner, keep one copy per rule, and restore headroom under the thin cap

Description:

- Input: `ai/code-review-reports/2026-11-17_22-19_review-01.md`, verdict CHANGES REQUESTED. The audit is delivered; this unit applies the findings.
- `AGENTS.md` was 157 lines, 2,399 words, and 16,869 bytes; the caps are 160 lines, 2,400 words, and 24,900 bytes. Nine bullets exceeded 350 characters.
- Scope: move the boot scan list and the two index step bodies into `load-context`, move git workspace detection into `bootstrap-project`, reduce Single-Writer to one sentence plus a pointer, split the protocol developer and other long bullets, and drop the unused START marker.
- Added a shape fixture so the file cannot regress: line, word, byte, and bullet-length caps.
- Reserves headroom for the three config directives that follow: `Global User AI Directory`, `Default Shell Interpreter`, and the early settings load.
- Split out: the 13 missing policy `## Loading` declarations go to `policy-loading-declarations.md`. No behavior change in this unit.

## Acceptance Criteria

- `AGENTS.md` is at most 135 lines, 2,150 words, and 20,000 bytes.
- Every rule in the audit has one owner; no rule is lost or weakened.
- Dispatch semantics, triggers, and load order are unchanged.
- The shape fixture passes on the new file and fails on the old shape.
- Validators 8/8, authoring PASSED, all test scripts pass, markdownlint 0.
- At least 25 lines and 250 words stay free for the pending config directives.
- Peer review APPROVED for the plan and the implementation.

## Plan

Plan attached below.

Related: `ai/issues/closed/agents-md-thinness-audit.md` (input; closed with this unit), `ai/issues/open/policy-loading-declarations.md`.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/agents-md-structural-refactor.md`.
- Input: `ai/code-review-reports/2026-11-17_22-19_review-01.md`, verdict CHANGES REQUESTED.
- Goal: move procedure detail to its owner, keep one copy of each duplicated rule, split the long bullets, and restore headroom. No behavior change.

### Evidence

- `AGENTS.md`: 157 lines, 2,399 words, 16,869 bytes. Caps: 160 lines, 2,400 words, 24,900 bytes.
- Nine bullets exceed 350 characters; the longest is 1,353 characters at the old `AGENTS.md:83`.
- The old `AGENTS.md:81` restated `ai-policy-common.md:173` (`State File Ownership Protocol`).
- The maintainer exception appeared twice, at the old `AGENTS.md:69` and `:83`.
- The boot scan list at the old `AGENTS.md:89-103` duplicated ground covered by `:86-87` and `:100-101`; `load-context.md:50` pointed to it.
- The two index step bodies at the old `AGENTS.md:109-125` were called by `load-context.md:36` and `:62`, `write-checkpoint.md:63-64`, and `post-compaction-recovery.md:19` and `:22`. `load-context.md:62` said the skills step was "defined once in AGENTS.md".
- The old `AGENTS.md:85` was a bootstrap action; `bootstrap-project.md` owns bootstrap.
- `START_IMMUTABLE_PROTOCOL` at the old `AGENTS.md:1` was referenced by no script. `support-files/validate-protocol.sh` checks the END marker only.
- 13 of 23 policies lack `## Loading`; that is policy wiring, split to `policy-loading-declarations.md`.

### HLD

- HLD-001: `AGENTS.md` stays the always-on router: the warning header, TIER CONFIGURATION, the prohibited and mandatory read-first rules, the dispatch contract, the procedure pointer, and the appendix.
- HLD-002: Each rule has one owner. The common policy owns Single-Writer and Branch Gating mechanics. `load-context` owns the boot scan list and the two index step bodies. `bootstrap-project` owns git workspace detection.
- HLD-003: Boot-critical rules stay inline: self-modification, PWD scope, local-state creation, full reads, evidence, context protection, the session-resume signals, archive and backup exclusion, OS execution, and the git-ignore read rule.
- HLD-004: A pointer is one sentence plus the canonical owner name. It never restates mechanics.
- HLD-005: The result leaves at least 25 lines and 250 words for the three config directives and the shell resolver that follow.
- HLD-006: No new module. The index bodies move into `load-context`, because `Mode: boot` has no proven global loader path today.
- ADR-001: Put the index step bodies in `load-context` rather than a new boot policy. Context: no policy declares `Mode: boot`; `common` is loaded explicitly by STEP-WORKFLOW-ACCESS. Decision: one owner in the procedure that runs at boot. Consequence: recovery and checkpoint call the step by name and name the owner.

### LLD

- LLD-001 `TIER READ-FIRST-RULES` edits:
  - Replace `State File Single-Writer Ownership` with one sentence: the project-root orchestrator is the only state-file writer; the common policy owns the mechanics.
  - Split `Protocol Developer Mode` into three bullets: the maintainer exception, the end-user path perspective, and the policy-loading set.
  - Remove the maintainer exception from `Self-Modification`; point at the maintainer bullet.
  - Split `PWD-Only Scope` into three bullets: load from PWD only; no foreign assistant files; stop when `AGENTS.md` is missing.
  - Split `OS-Sensitive Execution` into two bullets: choose, state, and report the command form; never install tools.
  - Split `Full File Reads` into three bullets: full reads, no sliced evidence, auditable reads.
  - Reduce `Session Resume` to the three trigger signals plus the procedure name.
  - Add the one-line boot-scan pointer: apply the `load-context` exclusions to every boot scan.
- LLD-002 Boot scan list:
  - Move the exclusion bullets into `load-context` STEP-DISCOVERY.
  - Rewrite `load-context.md:50` so it names the local step instead of pointing back at `AGENTS.md`; remove the circular reference.
  - Keep `Archive File Exclusion` and `Backup Directory Exclusion` inline; they apply outside boot, so the boot list does not repeat them.
- LLD-003 Index steps:
  - Move the `STEP-PROTOCOL-INDEX` and `STEP-SKILLS-INDEX` bodies into `load-context` as named steps under the index step.
  - Keep the `## Shared Protocol Steps` heading in `AGENTS.md`; `validate-protocol.sh:62` requires it.
  - Keep the plain strings `STEP-PROTOCOL-INDEX`, `STEP-SKILLS-INDEX`, and `Single-Writer` in `AGENTS.md`; `validate-protocol.sh:63,64,71` requires them.
  - Define each step once, in the bold `**STEP-...**` form, in `load-context`; `tests/test-protocol-references.sh:41,59` fails on a duplicate bold definition.
  - Update `load-context.md:62` so it no longer says "defined once in AGENTS.md".
  - Update `write-checkpoint.md:63-64` and `post-compaction-recovery.md:19,22` to name the step and its owner, and to load the module when it is not in context.
  - Update `tests/test-skills-index.sh:108`: the `200 characters` cap moves to the owner, so the fixture checks `load-context`, not `AGENTS.md`.
  - Keep `TIER TRIGGERED-PROCEDURES` inline and name the step.
- LLD-004 Marker: drop the unused `START_IMMUTABLE_PROTOCOL` comment; keep the visible warning block and the checked END marker.
- LLD-005 Fixture: add `tests/test-agents-md-shape.sh` with the 160-line, 2,400-word, and 24,900-byte caps, a 600-character bullet cap, and a check that the router does not restate the Single-Writer mechanics (fail on "sub-agents and role-based team members"). The runner auto-discovers `tests/test-*.sh`, so no registration edit is needed.
- LLD-006 Budget, measured: Single-Writer 178 words, the index bodies 367, the boot scan list 100, git detection 82. Remove 727 words and about 40 net from the duplicate and split bullets; add about 100 words of pointers. Expected result: 130 to 135 lines and 1,750 to 1,900 words.

### Acceptance Criteria

- AC-001: `AGENTS.md` is at most 135 lines, 2,150 words, and 20,000 bytes.
- AC-002: every audit finding has an owner; the coverage matrix has no unowned row.
- AC-003: the Single-Writer mechanics appear once, in the common policy; the router keeps one sentence and a pointer.
- AC-004: the boot scan list appears once, in `load-context`; the router keeps one pointer.
- AC-005: the index step bodies appear once, in `load-context`; every caller names the owner.
- AC-006: `bootstrap-project` owns git workspace detection.
- AC-007: dispatch, triggers, and load order are unchanged.
- AC-008: the shape fixture passes on the new file and fails on the old shape.
- AC-009: validators 8/8, authoring PASSED, the full suite passes, markdownlint 0.
- AC-010: peer review APPROVED for the plan and the implementation.
- AC-011: at least 25 lines and 250 words remain for the pending config directives.
- AC-012: no user-facing behavior or path changes; update `ai/shared/project-knowledge/protocol-verification-toolchain.md` when the fixture count changes.

### Rule Coverage Matrix

- Single-Writer: common policy owns it; router keeps one sentence and a pointer.
- Branch Gating: one inline sentence; the common policy owns the detail.
- Maintainer exception: one inline bullet; the duplicate in Self-Modification is removed.
- End-user path perspective: new inline bullet.
- Policy-loading set: new inline bullet.
- PWD-Only Scope: three inline bullets.
- OS-Sensitive Execution: two inline bullets.
- Full File Reads: three inline bullets.
- Session Resume: short trigger list plus the procedure name.
- Git Workspace Detection: moves to `bootstrap-project`.
- Boot Scan Exclusions: moves to `load-context`; one inline pointer stays.
- Archive and backup exclusion: inline, unchanged, the only owner.
- STEP-PROTOCOL-INDEX body: moves to `load-context`.
- STEP-SKILLS-INDEX body: moves to `load-context`.
- Protocol Dispatch: inline, same semantics.
- TIER CONFIGURATION: inline, unchanged.
- START marker: removed. END marker: kept.
- Policy `## Loading` declarations: out of scope, follow-up ticket.

### Risks

- A moved rule loses authority because a path does not load the owner. Mitigation: each owner is a procedure that already runs on that path; verify every caller.
- The index-step move breaks recovery or checkpoint. Mitigation: update both callers, tell them to load the module, and run the suite.
- The word target pulls a live rule out of the router. Mitigation: the coverage matrix and the peer review check for loss.
- The shape fixture blocks future work. Mitigation: the 600-character bullet cap, not 350.

### Out of Scope

- The 13 policy `## Loading` declarations.
- The common-policy prose rewrite, the config directives, the shell unit, tool selection, and GitHub #10.
- The full codebase examination of `docs/`, `tests/`, and `support-files/`.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the v6.6.0 release commit.
- Branch: `feature/agents-md-refactor`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: `ai/issues/closed/agents-md-structural-refactor.md`; closed in the branch commit. `agents-md-thinness-audit.md` closed with it.
- Release: v6.6.1 (patch) because no user-facing behavior or rule changes; a minor bump is a user decision at release time. The note is in the user's voice.
- Verification: validators, suite, markdownlint, shape fixture.
- Branch deletion: local and remote after the release.

### Peer Review Log

- Plan round 1, `2026-11-18_22-28_review-03.md`: CHANGES REQUESTED. Circular pointer, validator and reference anchors, skills fixture, and measured budget. All resolved.
- Plan round 2, `2026-11-18_22-31_review-04.md`: APPROVED.
- Implementation round 1, `2026-11-18_22-37_review-05.md`: APPROVED. Two Minors, both advisory; the plan registration note is corrected above.

---

2026-11-18
Closed: implemented and reviewed. `AGENTS.md` is 135 lines and 1,607 words; the detail moved to `load-context` and `bootstrap-project`; the shape fixture is `tests/test-agents-md-shape.sh`; the suite passes 20 of 20. The v6.6.1 release carries it.
