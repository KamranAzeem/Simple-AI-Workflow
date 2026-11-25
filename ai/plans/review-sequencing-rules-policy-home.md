# Plan: Give the review-sequencing rules a policy and ADR home

## Goal

Move the review-sequencing rules from the verification knowledge file into the code-review policy and a self-contained ADR, without adding a new policy, procedure, trigger, or test, and without changing the severity gate or the review dimensions.

## Evidence

- The open ticket `ai/issues/open/review-sequencing-rules-policy-home.md` records the governance gap; the user asked for this work on 2026-11-25 and required no breakage, no redundant code, and no protocol bloat.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md` is 101 lines. The `### Quality Gate` section is at lines 32-46; the sequencing rules are at lines 38-42; the final live-gate fact is at line 101.
- `ai/policies/ai-policy-code-review.md` is 144 lines. The `### Blocking Review Gate` is at lines 77-88. It owns the severity gate, the scope rules, and the read-only reviewer. It does not state hash binding, delta verification, post-approval invalidation, or the follow-up rule.
- `design-docs/protocol-decisions.md` is 1430 lines. Design documents live in `design-docs/` (line 469); genuine decisions belong in the store (line 479); knowledge files are self-standing and point at no policy or doc (lines 725-731); the uniform gate ADR is at line 1416; the plan-quality ADR is at line 1426; ADR entries are self-contained and depend on no commit, branch, plan, or report (lines 443-445).
- `ai/policies/ai-policy-issue-management.md` is 156 lines and owns the plan template (lines 96-126) and the baseline and clean-tree rules (lines 142-145).
- `ai/policies/ai-policy-design-docs.md` is 172 lines and says design documents are self-standing, hold no work logs or version-control references (lines 25-30), use context plus acceptance criteria for small and medium work (lines 57-60), and use decision, context, consequences for an ADR (lines 121-128).
- `tests/test-issue-policy.sh` is 163 lines and already asserts the code-review blocking gate at lines 84-101. `tests/test-docs-audit.sh` is 215 lines and asserts the v7.6.1 announcement, the ADR store, the verification note, the map, and the no-new-test-file rule at lines 153-192. `tests/run-all.sh` is 39 lines; the suite is 31 test scripts.
- `ai/shared/project-knowledge/codebase-skeleton-map-simple-ai-workflow.md` line 32 records 11 open, 0 in-progress, and 141 closed; line 62 names the uniform gate.
- `docs/announcements/v7.6.1.md` and the README banner are the release-doc pattern for v7.6.2.
- The current working tree holds the post-v7.6.1 checkpoint state and daily records; v7.6.1 is live, and the baseline commit must include those uncommitted records.

## Depth

S, light path. Context plus acceptance criteria only; no HLD or LLD. The ADR content is the only design decision and is written inside this plan.

## Context

The issue records that the sequencing rules are normative but live only in a project-knowledge file. The code-review policy is the operative owner and the ADR store records the decision. The knowledge standard makes a knowledge file self-standing and forbids pointers to policies or docs, so the knowledge file will drop the duplicate rules instead of linking to them; the issue carries a dated planning correction.

The uniform gate and the plan-quality rules already have owners. This change must not restate them. The code-review policy is read-only; Protocol Developer Mode requires loading the decision store and explicit human approval before the commit. The severity gate and the review dimensions are unchanged; the new rules bind the existing verdict process, so the release is a PATCH.

## Decisions (ADR)

- D1: `ai/policies/ai-policy-code-review.md` is the sole operative owner of the sequencing rules. The ADR store records the decision. The verification note keeps the commands and checks, not the normative copy.
- D2: The existing blocking gate owns the zero-open rule. The new policy subsection adds only the four rules that are missing: hash binding, one delta verification, post-approval invalidation, and follow-up unless regression. No duplicate zero-open bullet.
- D3: The verification note gets no pointer, because the self-standing knowledge rule forbids one. It removes the `### Quality Gate` section and the duplicate gate rationale; it keeps the commands, the `## Verify` check, and the final live-gate fact.
- D4: No new policy, procedure, trigger, or test script. The existing fixtures are extended. The release is v7.6.2 PATCH with an announcement and a README banner.

ADR text for `design-docs/protocol-decisions.md`:

```markdown
## 2026-11-25: Review verdicts bind to the artifact hash

A review verdict binds to the reviewed artifact's SHA-256. After fixes, one delta verification covers the changes. A post-approval edit invalidates the approval and needs a new hash and a delta verification. A new post-approval finding becomes a follow-up ticket unless it is a regression. The existing blocking gate owns the zero-open rule.

Context: a verdict could approve one revision while a later edit shipped without a matching verification, and the sequencing rules lived only in a verification note.

Consequences: the code-review policy owns the operative rules; the ADR is the decision record; the verification runbook keeps the commands and checks, not a second copy.
```

## Deltas

- Modify `ai/policies/ai-policy-code-review.md`: add `### Verdict and Delta Verification` after the blocking gate, with the four exact clauses and no rationale.
- Modify `design-docs/protocol-decisions.md`: append the ADR above, self-contained and dated at implementation.
- Modify `ai/shared/project-knowledge/protocol-verification-toolchain.md`: remove `### Quality Gate` and the duplicate gate rationale lines; keep the commands, the `## Verify` check, the header, and the final live-gate fact; add no pointer; keep it under 15 KB.
- Modify `tests/test-issue-policy.sh`: assert the new section heading and the four clauses; keep the existing gate assertions.
- Modify `tests/test-docs-audit.sh`: assert the ADR heading and clauses, the v7.6.2 announcement and README link, and the absence of `### Quality Gate`, `ai-policy-code-review.md`, and `protocol-decisions.md` in the verification note; extract the new ADR entry and assert it names no commit, branch, plan, or report; keep the v7.6.1 announcement assertions.
- Add `docs/announcements/v7.6.2.md`; update the README banner; update the map line 32 count to 11 open, 0 in-progress, and 142 closed, and line 62 to name the sequencing rules.
- Update the open ticket with the plan entry and the planning correction; at close, attach the plan, delete the plan file, and move the ticket to `closed/`.
- No new policy, procedure, trigger, or `tests/test-*.sh`; the suite stays 31 test scripts.

## Acceptance Criteria

- AC-1: `ai/policies/ai-policy-code-review.md` contains `### Verdict and Delta Verification` and the four exact clauses; the existing blocking gate still owns zero-open. Assertion: `tests/test-issue-policy.sh` checks the heading, the four clauses, and the existing gate text; it fails before the change.
- AC-2: `design-docs/protocol-decisions.md` contains the dated ADR with the four clauses and no commit, branch, plan, or report dependency. Assertion: `tests/test-docs-audit.sh` checks the heading and the clauses, and an `awk` extraction of the new entry confirms it names no commit, branch, plan, or report.
- AC-3: `ai/shared/project-knowledge/protocol-verification-toolchain.md` no longer contains `### Quality Gate` or the normative sequencing duplicate; it remains self-standing with no policy or doc pointer, keeps its header, and is under 15 KB. Assertion: `tests/test-docs-audit.sh` asserts the absence of the section, the clauses, `ai-policy-code-review.md`, and `protocol-decisions.md`, and the presence of the commands, the final fact, and the header; `wc -c` confirms the size.
- AC-4: The uniform gate and the plan-quality rules still resolve to their existing policy and ADR owners, with no contradictory copy. Assertion: the existing gate assertions in `tests/test-issue-policy.sh` and `tests/test-docs-audit.sh` pass, and the issue and design policies are unchanged.
- AC-5: No new policy, procedure, trigger, or test script is added. Assertion: `find ai/policies -maxdepth 1 -name 'ai-policy-*.md' | wc -l` is 25; `find ai/procedures -maxdepth 1 -name '*.md' | wc -l` is 16; `find tests -maxdepth 1 -name 'test-*.sh' | wc -l` is 31; the index reports 25 policies, 16 procedures, and 54 triggers; `git diff --name-only master...HEAD` has no new policy, procedure, or test file.
- AC-6: The change does not bloat the protocol. The verification note shrinks; the policy gets one short subsection; the ADR is one short entry; the release docs are the only new file; no module, trigger, or test script is added. Assertion: `git diff --stat master...HEAD` is recorded, the verification note is smaller, and a reviewer confirms the four clauses are the only policy addition.
- AC-7: The full gate passes and v7.6.2 is published. Assertion: protocol 8/8, authoring, suite 31/31, markdownlint 0, index 25/16/54/0/0, and `gh release view v7.6.2` returns a public URL.

## Verification

- Before the change, add the new assertions and run `bash tests/test-issue-policy.sh` and `bash tests/test-docs-audit.sh`; expect failures on the missing heading, clauses, ADR, and v7.6.2 announcement.
- After the change, run both fixtures and expect PASSED; run `bash tests/run-all.sh` and expect `PASSED: 31 test scripts.`
- Run `bash support-files/validate-protocol.sh` for 8/8; run the authoring validator on `ai/policies/ai-policy-code-review.md` and the trigger validator; run `bash support-files/index-protocol.sh` for 25 policies, 16 procedures, 54 triggers, 0 conflicts, and 0 errors.
- Run markdownlint on every changed markdown file and expect 0 issues.
- Run `git diff --name-only master...HEAD` and confirm no new policy, procedure, or `tests/test-*.sh`; run the count commands in AC-5; run `wc -c` on the verification note and confirm it is under 15 KB and smaller than before; record `git diff --stat master...HEAD`.
- Run the no-pointer checks: `tests/test-docs-audit.sh` asserts that the verification note does not name `ai-policy-code-review.md` or `protocol-decisions.md`; the file stays self-standing. The same fixture extracts the new ADR entry and confirms it names no commit, branch, plan, or report.
- Run the implementation peer review; fix every blocking finding; re-review. Then run the terminal gate, merge, tag v7.6.2, publish the Class B release from `docs/announcements/v7.6.2.md` after confirming no secrets or non-public names, and verify the URL.

## Peer Review Log

- review-150 on 2026-11-25: APPROVED. See `ai/code-review-reports/2026-11-25_20-19_review-150.md`. No findings.

## Risks and Rollback

- The code-review policy is loaded by every review. Keep the addition to four bullets and no rationale; the behavioral gate is unchanged, and the extended fixture pins it. Roll back by reverting the squash commit.
- The knowledge file must stay self-standing. The plan removes the duplicate and adds no pointer; if a reviewer asks for a pointer, the ADR and policy remain the authoritative homes and the knowledge standard wins.
- Updating `tests/test-docs-audit.sh` for v7.6.2 must keep the v7.6.1 announcement assertions; the README banner moves to v7.6.2. No docs count changes.
- The change is a PATCH with no migration. The policy and ADR are versioned; a defect is fixed in a later patch, not by editing history.
- The baseline commit includes the post-v7.6.1 checkpoint state and daily records; commit them with the plan and ticket so the implementation branch starts from a clean tree.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base `master` at v7.6.1; merge mode direct.
- Approval: the implementation request plus this Close Sequence is the approval for the protected-branch baseline, the branch commits and push, the direct merge, the v7.6.2 tag and GitHub Release, and the local ticket close.
- Baseline: on `master`, commit the plan, the updated open ticket, the post-v7.6.1 `ai/state/context.md`, `ai/state/next-steps.md`, `ai/state/progress.md`, and `ai/daily-checkpoints/2026-11-25.md` as `chore: record the review-sequencing plan and checkpoint`. Evidence is `git status --short` showing only those paths.
- Branch: `fix/review-sequencing-policy-home` from the baseline; implementation commit `docs: bind review verdicts to the artifact hash`; branch only.
- Implementation: test-first, then the files in Deltas; fix every review finding; close the ticket with the plan attached; delete the plan file; write the checkpoint on the branch; evidence in the daily checkpoint.
- Terminal gate: branch at least one commit ahead, clean tree, protocol 8/8, authoring, suite 31/31, index 25/16/54, markdownlint 0, no new policy, procedure, trigger, or test script.
- Merge: squash to `master`, delete the branch, push; evidence is the merge commit and `git log --oneline -1`.
- Release: tag `v7.6.2`, push the tag, publish the GitHub Release from the scrubbed Class B `docs/announcements/v7.6.2.md`, and verify the public URL.
- Checkpoint: after the release; ticket at `ai/issues/closed/review-sequencing-rules-policy-home.md`; counts 11 open, 0 in-progress, and 142 closed; map line 32 updated; no post-merge commits.
