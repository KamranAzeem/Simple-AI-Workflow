# Optimize load-context boot discovery and round trips

**Ticket**: GitHub issue #4, <https://github.com/KamranAzeem/Simple-AI-Workflow/issues/4>
**Date**: 2026-11-09
**Size**: L
**Merge mode**: `direct` (no `## Merge Policy` in `ai-customization.md`; `auto` behaves as `direct`)
**Base ref**: `master`
**Branch**: `feature/optimize-load-context-boot`

## Evidence

- v5.7.0 `AGENTS.md`: 404 lines, 62,263 bytes, with 13 procedure bodies inline. v6.0.0: 133 lines, 15,104 bytes. Source: `git show <tag>:AGENTS.md | wc -lc`.
- v6.0.0 load context does not read procedure bodies; `ai/procedures/load-context.md` (76 lines) has no such step. The 13 modules total 51,208 bytes and are indexed as metadata.
- `ai/policies/ai-policy-common.md`: 779 lines, 68,862 bytes. Largest sections: State File Ownership 9,142; Operational Standards 6,224; Knowledge File Standards 5,569; Issue Management 5,203; Guardrails 4,993; Design Documentation 6,237; Communication 4,587; Engineering 3,444.
- Boot full-read set in this repo: customization 1,336; settings 6,703; state 9,286; coordination 1,882; checkpoint 7,980; common 68,862; meta 9,144. About 105 KB without `AGENTS.md`; about 120 KB with the 15,104-byte thin `AGENTS.md`. Common dominates.
- `load-context.md:48` runs one `ls -R`/`find` over `~/.ai/` and the whole `ai/`. It is the only unbounded scan and the spill source.
- `load-context.md:49-50` loads and then re-reads state and today's checkpoint for the proof; `load-context.md:52-54` indexes knowledge, open issues, and design docs; `load-context.md:56-62` loads common plus Active Expertise; `load-context.md:65-76` prints the proof.
- Issue #4: a discovery output over about 20 KB spills to disk and forces an extra read turn; sequential turns add latency.
- User decisions, 2026-11-09:
  - Keep the full latest checkpoint read. The latest file by date is today's when it exists, otherwise the newest earlier file, which may be older than yesterday.
  - Canonical exclusion list: `ai/secrets/`, `ai/artifacts/`, `ai/code-review-reports/`, `ai/notes/`, `ai/pending/`, `ai/plans/`, `ai/issues/closed/`, any `.git/`, archives, `~/.ai/backups/`.
  - Add a read-only `--index` mode to `support-files/validate-policy-authoring.sh`.
  - This plan covers issue #4 only. No split of common. The checkpoint full read stays.
  - There is no wall-time baseline and no customer timing test. The acceptance is structural.
  - There is no Windows or macOS test environment. The release claims Linux verification only. The instruction is OS- and terminal-agnostic, with a standard Linux Bash reference example, so another AI uses equivalent tools and completes the task.
  - The validator and `--index` are Protocol Developer Mode tools on Linux; there is no Windows validator port. `--index` is a test oracle, not a runtime dependency. The end-user AI builds the module index inline with standard tools on any OS, in the same format. Windows PowerShell 5.x is banned; `pwsh` 7+ is the only Windows shell if Windows is used. macOS uses the POSIX/BSD equivalent.
  - The discovery output is bounded at 16 KB per boot phase; the reported spill threshold is about 20 KB, so 16 KB leaves headroom.
  - The instruction must be clear whatever the OS, shell, or default terminal: state the outcome, constraints, and expected output first; give the forms as examples; the AI adapts to the active environment with equivalent standard tools and reports the command used and any deviation. The hard constraints stay: read-only, no installs, `pwsh` 7+ on Windows, never Windows PowerShell 5.x.

## Problem

Boot cost is not dominated by `ls -R` itself. It is dominated by the number and size of full reads, the number of serial tool turns, and an unbounded discovery output that can spill. The current procedure scans the whole `ai/` tree even though every later step targets an anchored path. It has no canonical exclusion list, so `ai/secrets/` filenames appear in discovery output even though no step reads them.

## Scope

In scope: the issue #4 fix, the canonical exclusion list, the `--index` mode, the compact proof, the parallel-read guidance, targeted discovery, the Linux Bash reference example, the OS- and terminal-agnostic instruction, the duplicate checkpoint read, tests, docs, ADR entries, and the release.

Out of scope: checkpoint slicing, splitting `ai-policy-common.md`, the recovery 13-body read, version-check caching, the TDD and spec-driven harness (issue #6), any external tracker automation beyond the named ticket actions, a Windows validator port, and Windows and macOS runtime verification.

## Acceptance Criteria

- AC-01: No load-context step runs a recursive listing of the whole project `ai/` or the whole `~/.ai/`. Discovery lists only the boot roots.
- AC-02: The canonical exclusion list is applied everywhere. A canary fixture proves no excluded filename or content appears in any boot output.
- AC-03: Discovery output is bounded at 16 KB per boot phase. A fixture with 1,000 artifact files and 1,000 knowledge files produces a summary under 16 KB. When a root would exceed the bound, the procedure prints the counts and queries the remainder on demand. The fixture asserts the byte bound.
- AC-04: The latest daily checkpoint is read in full, defined as today's file when it exists, otherwise the newest earlier file by date. The proof reuses that read and does not read the file twice.
- AC-05: The fixed read set is listed for one batched turn where the client supports multi-tool dispatch, with a sequential fallback. No operational read is truncated.
- AC-06: `validate-policy-authoring.sh --index` is read-only, Linux-only, emits the index and a summary, and is covered by fixture cases. It reports pre-existing structural gaps by class and exits 0 when the index is produced; it exits non-zero only for an unreadable module or an invalid trigger block. It is a Protocol Developer Mode test oracle, not a runtime dependency; the load-context module index is inline. No Windows port is built.
- AC-07: The knowledge, open-issue, and design-doc indexes are produced in one bounded shell call; no per-file subprocess loop.
- AC-08: The proof-of-load is one line per item, counts only; a failing item expands.
- AC-09: All checks pass: `validate-protocol.sh` (update the documented count when a check is added), the reference test, authoring `--triggers`, the trigger fixture, markdownlint, and shellcheck.
- AC-10: The acceptance is structural: no whole-tree scan, the exclusion canary passes, the discovery is under 16 KB, the checkpoint is read once, the proof is compact, and the indexes are one call. No wall-time baseline is required.
- AC-11: The release does not claim a measured wall-time improvement. The plan removes the identified causes, and the benefit is inferred from the removed work.
- AC-12: If Windows is used, the instruction requires `pwsh` 7+ and never Windows PowerShell 5.x. No Windows runtime verification is claimed in this release.
- AC-13: The reference example uses standard Linux Bash tools (`find`, `sort`, `wc`, `grep`); no optional or fancy tool is required. Output is sorted and normalized (forward slashes displayed, UTF-8 without BOM), and no per-file subprocess loop is used. The AI on another OS or terminal uses equivalent standard tools.
- AC-14: macOS guidance uses the same POSIX/BSD `find` intent as the Linux example. No macOS runtime verification is claimed in this release.
- AC-15: The load-context discovery instruction states the required outcome, constraints, and output shape before any command form, and presents the standard Linux Bash example and the other forms as examples. It enables an AI on any OS, shell, or default terminal to use equivalent standard tools, report the command used and any deviation, and stop and report only when no compliant tool exists. The runtime module index is inline with standard tools and the same format as `--index`. The hard constraints stay: read-only, no installs, `pwsh` 7+ on Windows, never Windows PowerShell 5.x.

## High-Level Design

- HLD-001 Boot runs in five phases: A discovery (one call), B fixed reads (parallel), C rule reads (parallel), D indexes (one call), E compact proof.
- HLD-002 One canonical exclusion list lives in `AGENTS.md` under TIER READ-FIRST-RULES, next to Archive and Backup exclusion. Every scan, index, and proof references it.
- HLD-003 Targeted discovery replaces the whole-tree scan. Roots: the project root (`ai-customization.md`), `ai/state/`, `ai/shared/` (coordination, project knowledge, handoffs), `ai/issues/open/`, `ai/issues/in-progress/`, `ai/daily-checkpoints/`, the project's `ai/policies/`, and `design-docs/`; the global roots `~/.ai/settings/` and `~/.ai/global-knowledge/`; and the Global AI Policies Directory and the procedure store under the **Global AI Workflow Directory**, resolved from `ai-customization.md`. The global policies and procedure store are not project paths.
- HLD-004 The full checkpoint read stays. Read the latest file once: today's when it exists, otherwise the newest earlier file by date. The proof reuses the read.
- HLD-005 `--index` is a read-only Protocol Developer Mode test oracle, not a runtime dependency. It uses the same parser as the trigger checks and emits a stable line format plus a summary. The load-context module index is inline with the same format.
- HLD-006 The proof is a fixed set of compact lines with counts and `[PASSED]`/`[FAILED]`; a failing item expands.
- HLD-007 Parallel reads: one turn for the fixed set, one for the rule set, with a documented sequential fallback.
- HLD-008 OS and terminal matrix: the reference example is standard Linux Bash with POSIX `find`. The AI on any OS, shell, or default terminal uses equivalent standard tools, reports the command used and any deviation, and stops only when no compliant tool exists. If Windows is used, `pwsh` 7+ only; Windows PowerShell 5.x is never used. macOS uses the POSIX/BSD equivalent. The forms are examples. No Windows or macOS runtime verification is claimed. No probe commands.
- HLD-009 Release v6.1.0 (minor): scoped boot discovery and proof changes with no breaking contract.

## Low-Level Design

- LLD-001 `AGENTS.md`: add `### Boot Scan Exclusions` with one path or path class per bullet. State that the exclusions apply to listing and reading. `ai/secrets/` and `~/.ai/backups/` are never listed. Add a `validate-protocol.sh` check that `load-context.md` references the `### Boot Scan Exclusions` heading, so the canonical list cannot be bypassed silently. Update any validator anchor that checks rule sections.
- LLD-002 `ai/procedures/load-context.md`:
  - Replace `STEP-DISCOVERY` with the targeted roots and a bounded output contract. State the normative goal, constraints, and output shape first: a bounded, sorted index of the boot roots with the exclusions, in the same shape, at or under 16 KB per boot phase. Present the forms as examples: the standard Linux Bash form (`find`, `sort`, `wc`, `grep`; no optional tools), the POSIX/BSD `find` equivalent for macOS (`-prune`, `-print`, `-exec ... +`; no `-printf` or GNU-only flags; age via BSD `stat -f '%m'`), and the `pwsh` 7+ form for Windows: per-root `Get-ChildItem -File` with recursion bounded to that root; use `-Include '*.tar*','*.zip'` or a `Where-Object` extension check for archives; no unbounded `-Recurse`. Instruct the AI to adapt to the active OS, shell, and default terminal with equivalent standard tools, report the command used and any deviation, and stop and report if none exists. When the output would exceed 16 KB, print the counts and query the remainder on demand. Normalize separators, sorting (`LC_ALL=C`), and encoding; use one command block per phase; run no per-file subprocess.
  - In the module index step, build the index inline with standard tools and the same line format as `--index`; do not run the validator at load context.
  - In `STEP-LOADING`, read the latest checkpoint once and feed the proof from that read.
  - In `STEP-KNOWLEDGE-INDEXING`, use one bounded command for knowledge, open issues, and design docs.
  - In `STEP-PROOF-OF-LOAD`, print the compact lines and expand only failures.
  - Add the batched-read instruction and the sequential fallback.
- LLD-003 `support-files/validate-policy-authoring.sh`: add `--index`. Parse type, scope, name, source, triggers, headings, effective, and conflicts. Output one line per module with `|` separators and `;` between list items, then a summary block. No writes, no cache. Exit 0 when the index is produced, even when pre-existing shape gaps are reported; exit non-zero only for an unreadable module or an invalid trigger block. Align the behavior with `--triggers`. Linux-only; no Windows port. Test oracle only; not a runtime dependency. A golden output fixture fixes the line grammar; the equivalent Windows and macOS inline forms must match it.
- LLD-004 Fixtures:
  - New dev-time script `support-files/test-load-context-boot.sh` builds a temporary fixture project with a canary in every excluded path, 1,000 artifact files, 1,000 knowledge files, and a large checkpoint. It runs the discovery and index commands and asserts that no excluded name appears, that the output stays under 16 KB, and that the checkpoint is read once.
  - Authoring fixture cases for `--index`: valid tree, duplicate trigger, trigger containment, invalid shape, empty triggers, and the golden line grammar.
  - Golden fixture strategy: a fixed fixture project with deterministic counts; run the formatter or proof once; review the output; commit it as the golden; later runs diff against it, and a deliberate format change updates the golden. The `--index` oracle and the inline runtime module index must both match the module-index golden; the proof has its own golden. The goldens are dev-time artifacts, not runtime files.
  - No Windows or macOS runtime fixture. Their forms are examples and are reviewed with the instruction; the release notes state that those paths were not runtime-verified.
- LLD-005 Docs: `docs/workflow-guide.md` for the boot phases, the standard Linux Bash example, the OS- and terminal-agnostic adaptation rule, the 16 KB bound, and the exclusions; `docs/protocol-validation-system.md` for the Linux-only `--index`; `docs/announcements/v6.1.0.md`; and `README.md` only if it claims scan behavior. The announcement states that Windows and macOS runtime verification were not performed.
- LLD-006 ADR entries in `design-docs/protocol-decisions.md`: canonical exclusions, targeted discovery, full checkpoint read (explicit non-change), `--index` as a dev-only test oracle, inline runtime index, compact proof, parallel reads with fallback, the 16 KB bound, structural acceptance without a baseline, no Windows or macOS runtime verification, release v6.1.0, and the no-split and no-recovery-scope boundary.
- LLD-007 Verification: run the full check set, the new fixture, and the implementation review. Record the results in the Evidence section and the review report. Run the secrets and identifying-name scan before each commit. There is no manual timing test.
- LLD-008 `AGENTS.md`: extend OS-Sensitive Execution. Identify the OS, shell, and default terminal. State the intent and the expected output, use the reference form or an equivalent standard tool, report the command used and any deviation, and stop and report if no compliant tool exists. Never install tools to satisfy a boot step.

## Decisions

- ADR-001: The canonical exclusion list lives in `AGENTS.md`. Rationale: it is always loaded, protocol-level, and one source; procedures reference it.
- ADR-002: Targeted discovery replaces the whole-tree scan. Rationale: every later step targets an anchored path, so the whole-tree scan is redundant and unbounded.
- ADR-003: The full checkpoint read stays. Rationale: the checkpoint is the detailed resume narrative; the user chose full context.
- ADR-004: `--index` is a Protocol Developer Mode test oracle in the authoring validator; the runtime index is inline. Rationale: it already parses modules; the oracle tests the inline format; the end-user AI does not run the validator.
- ADR-005: The proof prints counts only. Rationale: it is a gate, not an archive.
- ADR-006: Parallel reads are advisory with a sequential fallback. Rationale: multi-tool dispatch is client-dependent.
- ADR-007: Release v6.1.0 is minor. Rationale: optimization with no breaking contract.
- ADR-008: No split of common, no recovery-path change, no version-check change. Rationale: second-order; each is a separate decision.
- ADR-009: macOS is supported by instruction and a POSIX/BSD form, without a runtime test in this change. Rationale: end users run macOS; the stated intent lets the AI adapt; no macOS machine is available.
- ADR-010: The protocol instruction is OS- and terminal-agnostic in intent; the forms are examples. Rationale: end users run different OSes and default terminals; the AI adapts with equivalent standard tools and reports any deviation; the hard constraints remain.
- ADR-011: No wall-time baseline is measured; acceptance is structural. Rationale: no baseline is available; the plan removes the identified causes and records the inferred benefit.
- ADR-012: The discovery output is bounded at 16 KB per boot phase. Rationale: the reported spill threshold is about 20 KB; 16 KB leaves headroom, and the remainder is queried on demand.
- ADR-013: No Windows or macOS runtime verification is claimed in this release. Rationale: no environments are available; the instruction is OS-agnostic; the release notes state the limitation.

## Risks and Gaps

- RSK-001: No wall-time baseline. The benefit is inferred from the removed work, not measured. The structural acceptance is the gate.
- RSK-002: No Windows environment. The Windows instruction is untested; the release claims Linux verification only. PowerShell 5.x is never used.
- RSK-003: A 16 KB cap could hide index files. Mitigate with the count plus on-demand query and the byte-bound fixture.
- RSK-004: `--index` is a dev-only test oracle; the runtime index is inline with standard tools, so there is no runtime dependency and no validator port.
- RSK-005: A future scanner could bypass the exclusion list. Mitigate with the single canonical list, the canary fixture, and the proof check.
- RSK-006: The full checkpoint read remains the largest unbounded input. Accepted by user decision; revisit only with new evidence.
- RSK-007: The ticket comment and close are external writes. They are named in the Close Sequence and covered by the plan and implement approval; if declined, keep the plan and leave the ticket open.
- RSK-008: No macOS machine. The POSIX/BSD form is reviewed, not run; the release claims Linux verification only.
- RSK-009: An unknown terminal or a missing standard tool could block discovery. Mitigate with the normative intent, the equivalent-tool rule, and the report-the-gap behavior; never install tools.
- RSK-010: The parallel-read benefit is not measured. The guidance reduces the number of reads structurally; the wall time is not claimed.
- RSK-011: The `--index` line grammar could drift. A golden fixture pins it.

## Tests and Verification

- Existing: `support-files/validate-protocol.sh` (all checks; update the documented count when a check is added); `support-files/test-protocol-references.sh`; `support-files/validate-policy-authoring.sh`; `support-files/test-trigger-rules.sh`; markdownlint; `shellcheck -S warning`.
- New: the boot fixture with canaries, 1,000 files, and the 16 KB byte bound; the `--index` cases and golden grammar; the adaptation under bash and sh.
- No manual timing test; no Windows or macOS runtime test. The release notes state that those paths were not runtime-verified.
- OS: Linux Bash and Git Bash are verified locally. Windows and macOS are covered by the OS- and terminal-agnostic instruction only, with no runtime verification in this change.
- Adaptation: run the discovery under bash and sh on Linux, record the command used, and check the output shape and exclusions. Windows and macOS have no runtime check.

## Close Sequence

- Repo: this repository. Base ref: `master`. Branch: `feature/optimize-load-context-boot`. Merge mode: `direct` (squash). Ticket: GitHub issue #4. Release: v6.1.0.
- Implement on the branch, run the implementation peer review, fix every Critical and Major finding, and write the checkpoint on the branch.
- The implementation review covers the OS- and terminal-agnostic instruction. No Windows or macOS runtime gate exists; the release notes state that those paths were not runtime-verified.
- Run the terminal gate: the branch is at least one commit ahead of `master` and the tree is clean.
- Squash merge to `master`, delete the branch, and push the trunk.
- Tag v6.1.0 and publish the GitHub Release with the announcement. The plan and implement approval cover this named release.
- Post the final plan to issue #4 as a dated comment, then close it when the merge lands. The plan and implement approval cover these named external writes.
- Delete the plan file after the ticket carries it.
- Evidence: this Evidence section, the fixture output, and the implementation review report.
- Definition of done: every AC met, all checks pass, the ticket is closed with the plan attached, the checkpoint is written, the branch is merged and deleted, the trunk is pushed, and the release is tagged and published.

## Peer Review Log

- Round 1: CHANGES REQUESTED (4 Major, 3 Minor), `ai/code-review-reports/2026-11-09_18-35_review-08.md`. Fixed the arithmetic, the workflow-anchor roots, the latest-file checkpoint rule, and the `--index` exit behavior; added the target, the 500-line cap, and the drift guard.
- Round 2: APPROVED, `ai/code-review-reports/2026-11-09_18-40_review-09.md`. Restored the global settings and knowledge roots after the root rewrite.
- Round 3: CHANGES REQUESTED (1 Major, 1 Minor), `ai/code-review-reports/2026-11-09_19-05_review-10.md`. Moved the Windows gate before the merge; specified the PowerShell archive filter and bounded recursion.
- Round 4: APPROVED, `ai/code-review-reports/2026-11-09_19-08_review-11.md`. OS amendment verified.
- Round 5: APPROVED, `ai/code-review-reports/2026-11-09_19-12_review-12.md`. macOS is in scope with the BSD form, the intent, and the no-runtime-test risk; the BSD `stat -f '%m'` form is fixed.
- Round 6: APPROVED, `ai/code-review-reports/2026-11-09_19-22_review-13.md`. The OS- and terminal-agnostic intent, the adaptation rule, and the hard constraints are recorded; the LLD order is fixed.
- Round 7: APPROVED, `ai/code-review-reports/2026-11-09_19-32_review-14.md`. Fixed the 20 KB byte bound and the all-checks wording; removed the baseline and the Windows/macOS runtime gates; the standard Linux Bash reference and the structural acceptance are recorded.
- Round 8: APPROVED, `ai/code-review-reports/2026-11-09_19-38_review-15.md`. Set the 16 KB bound; `--index` is a dev-only test oracle with an inline runtime index; the golden strategy is defined for the module index and the proof.
