# Plan: Retire the verification runbook and the verdict-hash rules

## Goal

Retire `ai/knowledge/protocol-verification-toolchain.md` and the `### Verdict and Delta Verification` section in the code-review policy. Keep every surviving rule in a protocol surface. Ship a PATCH.

## Evidence

- Ticket `ai/issues/open/retire-protocol-verification-toolchain.md` records the combined scope and the grilling decisions.
- `ai/knowledge/protocol-verification-toolchain.md`: 95 lines, 9,439 bytes.
- The verdict-hash rule is at `ai/policies/ai-policy-code-review.md:90-95`; the report template at `:105-130` has no hash field; no script checks a review hash.
- There are 442 review files under `ai/code-review-reports/`; 0 contain "hash" (`rg -in "hash" ai/code-review-reports/`). Hashes appear only in daily checkpoint prose for review-157, review-160, and review-162; no review record carries one.
- Knowledge-file dependencies: `tests/test-docs-audit.sh:26`, `:167-168`, `:200-205`, `:213`; `tests/test-user-settings-repair-fixture.sh:72-76`; `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:61`.
- Verdict-hash test pins: `tests/test-issue-policy.sh:102-106`; `tests/test-docs-audit.sh:196-199`, `:207-212`.
- Counts today: 25 policies, 16 procedures, 33 test scripts, 58 triggers, index 25/16/58, validator floor 25 (`support-files/validate-protocol.sh:377`).
- Existing command homes: `ai/policies/ai-policy-meta.md:36-38` owns the validator, authoring, and trigger commands; `tests/run-all.sh:13` runs every `test-*.sh`; each fixture has a usage header.
- The ADR store: `design-docs/protocol-decisions.md:1432` is the old hash ADR; the ADR shape is decision, context, consequences (`ai/policies/ai-policy-design-docs.md:121-128`).
- The docs boundary: `docs/` is user-facing only. The only documentation delta is the release announcement and the README banner.
- Release practice: `ai/knowledge/release-practices.md` requires an announcement, a README banner, a tag, and a GitHub Release.

## Depth

M, light path. Context plus acceptance criteria. No HLD or LLD. Two ADR entries are written in this plan.

## Context

The knowledge file is a runbook, not a policy. Its useful content is already owned (validator commands, migration rules, plan-quality rules, the uniform gate) or redundant with the scripts and the full-suite runner. The per-fixture command list has no protocol home and does not need one: `tests/run-all.sh` runs every fixture, and each fixture carries its own usage line.

The verdict-hash rule was introduced on 2026-11-25. It asks for a record the review template cannot hold, no script enforces it, and none of the 442 review files record a hash. The blocking gate and the iteration protocol already carry the review contract. Removing the section removes a claim without a working guard. The residual risk is a post-approval edit; the human asks for another review when that matters.

The combined change keeps the docs boundary: no command list moves into `docs/`, and the protocol gains no docs dependency.

## Decisions (ADR)

````markdown
## 2026-11-26: The verification runbook and the verdict-hash rules are retired

The per-fixture verification runbook is retired. The full-dev-suite rule lives in `ai-policy-meta.md`; the per-fixture commands stay in the scripts and `tests/run-all.sh`, and the per-fixture list is not copied. No command list moves into `docs/`, and the protocol gains no docs dependency. The verdict-hash rules are retired: the code-review policy keeps the blocking gate and the iteration protocol, and no hash or post-approval invalidation rule remains.

Context: the runbook duplicated commands and counts already owned by policies, procedures, ADRs, and tests. The hash rule was one day old, no script or record field enforced it, and none of the 442 review files recorded a hash.

Consequences: `ai/knowledge/protocol-verification-toolchain.md` is deleted; the map no longer names it; `### Verdict and Delta Verification` is removed; the blocking gate and the iteration protocol remain the review contract; the user-space lesson is retired separately. The old hash ADR remains as history, and this entry supersedes its runbook consequence.

## 2026-11-26: The repository records executable bits explicitly

The repository runs with `core.fileMode=false`. A maintainer records an executable bit with `git update-index --chmod=+x <file>`.

Context: the fact had no home outside the retired verification runbook.

Consequences: a new executable script needs the explicit index update; the sync and backup scripts are unchanged.
````

## Deltas

1. `ai/policies/ai-policy-meta.md`
   - Add to `## Required Pre-action Checks`: run the full dev suite with `bash tests/run-all.sh` before a merge or release.
   - Add to `### Enforcement`: `Derive a fixture's repository count from the live tree.` and re-run `support-files/validate-protocol.sh` after an operation that can remove untracked directories, such as a stash round-trip.
2. `ai/policies/ai-policy-code-review.md`
   - Remove `### Verdict and Delta Verification` and its four bullets.
3. Delete `ai/knowledge/protocol-verification-toolchain.md`.
4. `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md`
   - Change `15 durable project lessons` to `14 durable project lessons`.
   - Delete the toolchain line.
   - Change the gate line to `The code-review policy owns a uniform Critical, Major, and Minor gate; the implementation is live.`
   - At close, refresh the issue counts to the live tree.
5. `tests/test-docs-audit.sh`
   - Remove the `TOOLCHAIN` variable.
   - Remove all nine TOOLCHAIN assertions.
   - Add the no-reference guard over `AGENTS.md`, `ai/policies`, `ai/procedures`, `docs`, `tests`, and `ai/knowledge`, excluding `closed`, `daily-checkpoints`, and `code-review-reports`, and excluding the guard file itself so its own pattern does not match.
   - Add the ADR assertions for the retirement title, the runbook clause, the hash clause, the file-mode title, and the exec-bit command, plus the no-`commit|branch|plan|report` extraction for the retirement entry.
6. `tests/test-user-settings-repair-fixture.sh`
   - Remove the count block at `:72-76`: four assertions and the derived test-count assignment.
   - Keep the validator floor assertion at `:71`.
7. `tests/test-issue-policy.sh`
   - Remove the five verdict-binding assertions at `:102-106`.
8. `design-docs/protocol-decisions.md`
   - Append the two ADR entries above.
9. `README.md`
   - Replace the v7.7.0 banner with the v7.7.1 banner and the announcement link.
10. `docs/announcements/v7.7.1.md`
    - Add the user-facing announcement after the exact draft is approved. Name the retirement without repeating the removed file path, so the no-reference guard stays clean.
11. `ai/issues/open/retire-protocol-verification-toolchain.md`
    - Append the dated plan entry now.
    - At close, attach the plan, delete the plan file, and move the ticket to `closed/`.
12. `ai/state/context.md`, `ai/state/progress.md`, `ai/daily-checkpoints/2026-11-26.md`
    - Checkpoint on the branch. Record the knowledge-store count at 16 and the issue counts from the live tree.

## Acceptance Criteria

- AC-1: The file is absent. Assertion: `test ! -e ai/knowledge/protocol-verification-toolchain.md` exits 0 and `bash tests/test-load-context-boot.sh` passes.
- AC-2: No protocol surface names the removed file. Assertion: the new guard in `tests/test-docs-audit.sh` fails before the deletion and passes after it.
- AC-3: The map no longer names the file or the verdict-binding rules, and it records 14 durable lessons. Assertion: `rg -n "protocol-verification-toolchain|review-verdict binding" ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md` returns no match, and `rg -n "14 durable project lessons"` matches.
- AC-4: The code-review policy has no verdict-hash section; the gate and iteration protocol remain. Assertion: `rg -n "### Verdict and Delta Verification" ai/policies/ai-policy-code-review.md` returns no match, and `rg -n "### Blocking Review Gate|## Iteration Protocol"` matches both.
- AC-5: The five hash assertions are gone; the suite passes 33/33; no new test script. Assertion: `rg -n "Bind every review verdict|delta verification|post-approval" tests/test-issue-policy.sh` returns no match, `bash tests/run-all.sh` prints `PASSED: 33 test scripts.`, and `find tests -maxdepth 1 -name 'test-*.sh' | wc -l` is 33.
- AC-6: The user-settings fixture no longer reads the knowledge file; the derived counts stay covered. Assertion: `rg -n "protocol-verification-toolchain|58 triggers" tests/test-user-settings-repair-fixture.sh` returns no match, and both `tests/test-slides.sh` and `tests/test-readme-shape.sh` pass.
- AC-7: The full-suite rule is in the meta policy; no per-fixture list is copied into a policy or `docs/`. Assertion: `rg -n "tests/run-all.sh" ai/policies/ai-policy-meta.md` matches, and `git diff --name-only master...HEAD -- docs` lists only `docs/announcements/v7.7.1.md`.
- AC-8: The ADRs are appended and self-contained; the old hash ADR remains. Assertion: `rg -n "The verification runbook and the verdict-hash rules are retired|The repository records executable bits explicitly" design-docs/protocol-decisions.md` matches, and the new `test-docs-audit.sh` extraction passes the no-`commit|branch|plan|report` check.
- AC-9: The full gate passes. Assertion: protocol 8/8, authoring PASSED, suite 33/33, markdownlint 0, shellcheck 0 on the changed shell tests, index 25/16/58 with 0 conflicts and 0 errors.
- AC-10: The release is v7.7.1, public, with the announcement and the README banner. Assertion: `gh release view v7.7.1` returns a public URL, `docs/announcements/v7.7.1.md` exists, and the README banner names v7.7.1.

## Verification

- Before the change, add the no-reference guard and the ADR assertions; run `bash tests/test-docs-audit.sh`, `bash tests/test-issue-policy.sh`, and `bash tests/test-user-settings-repair-fixture.sh`. Expect the guard to fail because the map still names the file.
- Then remove the file, the hash clauses, the count block, and the map lines; run the same three fixtures and expect PASSED.
- Run `bash tests/run-all.sh` and expect `PASSED: 33 test scripts.`
- Run `bash support-files/validate-protocol.sh` and expect 8/8.
- Run `bash support-files/validate-policy-authoring.sh ai/policies/ai-policy-meta.md ai/policies/ai-policy-code-review.md` and expect PASSED.
- Run `bash support-files/validate-policy-authoring.sh --triggers AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)` and expect PASSED.
- Run `bash support-files/index-protocol.sh` and expect 25 policies, 16 procedures, 58 triggers, 0 conflicts, and 0 errors.
- Run `markdownlint-cli2 "**/*.md" "#node_modules"` and expect 0 issues.
- Run `shellcheck tests/test-docs-audit.sh tests/test-issue-policy.sh tests/test-user-settings-repair-fixture.sh` and expect 0.
- Run the guard: `rg -n --glob '!tests/test-docs-audit.sh' "protocol-verification-toolchain|Verdict and Delta Verification" AGENTS.md ai/policies ai/procedures docs tests ai/knowledge` and expect no match. `design-docs/` keeps the old hash ADR as history.
- Run `git diff --name-only master...HEAD` and confirm no new policy, procedure, or `tests/test-*.sh`; the only documentation files are `docs/announcements/v7.7.1.md` and `README.md`.
- Run `wc -c ai/state/context.md ai/state/next-steps.md ai/state/progress.md` and confirm the shared budget.
- Run the release verification: `gh release view v7.7.1`.

## Peer Review Log

- review-163 on 2026-11-26: APPROVED. See `ai/code-review-reports/2026-11-26_10-42_review-163.md`. 0 Critical, 0 Major, 0 Minor, 1 Suggestion on the file-mode ADR placement.

## Risks and Rollback

- Risk: losing the per-fixture command list. Mitigation: each fixture has a usage header; `tests/run-all.sh` runs every fixture; the meta policy names the full suite.
- Risk: a post-approval edit goes unreviewed after the hash rule is removed. Mitigation: the blocking gate and the iteration protocol remain; the human requests another review. The risk is accepted, not hidden.
- Risk: the map counts drift. Mitigation: refresh the knowledge and issue counts at close.
- Risk: the ADR date or the no-version-control check. Mitigation: date the entries at implementation; avoid commit, branch, plan, and report in the entries.
- Rollback: revert the squash commit; the knowledge file and the policy section return from history. Add a superseding ADR only if the retirement is reversed after the release.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`; base `master`; merge mode `direct`.
- Approval: the implementation request plus this Close Sequence is the approval for the protected-branch baseline, the branch commits and push, the direct squash merge, the v7.7.1 tag and GitHub Release, and the local ticket close.
- Baseline: on `master`, commit the updated ticket, this plan, `ai/state/context.md`, `ai/state/progress.md`, and `ai/daily-checkpoints/2026-11-26.md` as `chore: record the verification-retirement plan and checkpoint`. Evidence: `git status --short` lists only those paths.
- Branch: `feature/retire-verification-runbook` from the baseline; implementation commit `docs: retire the verification runbook and the verdict-hash rules`.
- Implementation: test-first; fix every review finding; attach the plan to the ticket; delete the plan file; write the checkpoint on the branch; update the map counts; move the ticket to `closed/`.
- Terminal gate: branch at least one commit ahead; clean tree; protocol 8/8; authoring; suite 33/33; index 25/16/58 with 0 conflicts and 0 errors; markdownlint 0; shellcheck 0; no new policy, procedure, or test script.
- Merge: squash to `master`, delete the branch, push; evidence is the merge commit.
- Release: tag `v7.7.1`, push the tag, publish the GitHub Release from the scrubbed announcement, and verify the public URL.
- Checkpoint: after the release; ticket at `ai/issues/closed/retire-protocol-verification-toolchain.md`; the map and state counts updated; no post-merge commits.
- Evidence: the commands and results in the daily checkpoint.
