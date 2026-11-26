# Plan: Land the F2 to F5 docs batch

## Goal

Land the four documentation tickets from the 2026-11-26 examination in one branch with no release, plus the `release-practices.md` amendment that lets docs-only changes land without a release.

## Evidence

- `ai/issues/open/stale-global-scope-token-in-validation-doc-and-spec.md` (F2): `docs/protocol-validation-system.md:36` says `(global or project)`, `:37` says "a project and global skill package", `:38` says "team-over-global overrides"; `design-docs/specs/policy-loading-contract.md:9` says "global policies" and `:32` says `|global|`.
- The live oracle prints `workflow`, and `tests/test-policy-load-paths.sh:202` asserts `|workflow|`.
- `ai/issues/open/refresh-codebase-skeleton-map-drift.md` (F3): `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:32` says 8 open and 148 closed, `:34` says 14 lessons, `:73` names a closed ticket under `in-progress/`, and `:90` says the snapshot is 2026-11-25.
- `ai/issues/open/documented-script-invocations-omit-bash.md` (F4): `support-files/audit-slides.sh`, `build-slide-diagrams.sh`, `build-slides-html.sh`, and `render-slides-preview.sh` are mode 100644 and their usage lines start with `./support-files/`. `ai/procedures/load-context.md:16` names `support-files/path-probe.sh` and `ai/policies/ai-policy-presentation.md:59` names `support-files/build-slide-diagrams.sh` with no `bash`. The tests use `bash support-files/...`. The 2026-11-26 ADR records `core.fileMode=false`.
- `ai/issues/open/readme-docs-index-omits-three-guides.md` (F5): `README.md:200` to `:218` is the docs index and omits `docs/ai-policy-mobile-apps-guide.md`, `docs/custom-policy-howto.md`, and `docs/post-compaction-reload-trigger-setup.md`.
- `ai/knowledge/release-practices.md:14` says a docs-only change with no behavior change ships as a PATCH. The user chose that docs-only changes may land without a release. The README restructure and the docs audit already landed without a release.
- Ticket counts before this batch: 11 open, 0 in-progress, 153 closed. After closing F2 to F5: 7 open, 0 in-progress, 157 closed. `ai/knowledge/` holds 16 lessons plus the issue template and the map.

## Depth

M. Each ticket is S. The batch is context plus acceptance criteria; no HLD or LLD is required.

## Context

The four tickets are independent and low risk, so one branch is cheaper than four. The release-practices amendment reconciles the written rule with the practice the repo already follows. The `ai/issues/` directory layout is unchanged.

Out of scope: the F6 decision-store refactor, the `repair knowledge files` scope word, and any protocol behavior change.

## Decisions (ADR)

- ADR-1, one docs branch for F2 to F5. Close all four tickets in the branch commit. Attach the plan to the lead ticket F2 and cross-reference it from F3, F4, and F5, so the plan is not copied four times.
- ADR-2, F4 uses the `bash` prefix in the usage lines and the two doc references. Do not add new executable bits. The repo runs `core.fileMode=false`, and the tests already invoke the scripts with `bash`.
- ADR-3, docs-only changes may land without a release, and the batch records its binding decisions (the workflow token, the `bash` convention, and the no-release rule) in `design-docs/protocol-decisions.md`.
- ADR-4, the map counts are a snapshot, not a pinned test. Counts drift with every ticket, so the fix updates the map and leaves the caveat; no test pins the count.
- ADR-5, no release. Do not tag, do not publish a GitHub Release, and leave the README banner at v7.11.0.

## Deltas

F2, the scope token:

- `docs/protocol-validation-system.md:36`: `(global or project)` to `(workflow or project)`.
- `docs/protocol-validation-system.md:37`: "a project and global skill package" to "a project and workflow skill package".
- `docs/protocol-validation-system.md:38`: "the project-over-team and team-over-global overrides" to "the project-over-team, team-over-user, and user-over-workflow overrides".
- `design-docs/specs/policy-loading-contract.md:9`: "global policies" to "workflow policies".
- `design-docs/specs/policy-loading-contract.md:32`: `|global|` to `|workflow|`.
- `tests/test-docs-audit.sh`: add `VALIDATION` and `SPEC` variables, then assert `present` "workflow or project", `absent` "global or project", `present` "`|workflow|`", and `absent` "`|global|`".

F3, the map:

- `ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md:32`: "7 open, 0 in-progress, and 157 closed as of 2026-11-26".
- `:34`: "16 durable project lessons".
- `:73`: delete the stale `ai/issues/in-progress/global-to-workflow-policy-terminology.md` line.
- `:90`: snapshot date 2026-11-26.

F4, the invocations:

- `support-files/audit-slides.sh:4`, `support-files/build-slide-diagrams.sh:3`, `support-files/build-slides-html.sh:3`, and `support-files/render-slides-preview.sh:3`: change the usage line from `./support-files/<script>.sh` to `bash support-files/<script>.sh`.
- `ai/procedures/load-context.md:16`: `support-files/path-probe.sh` to `bash support-files/path-probe.sh`.
- `ai/policies/ai-policy-presentation.md:59`: `support-files/build-slide-diagrams.sh` to `bash support-files/build-slide-diagrams.sh`.

F5, the index:

- `README.md` docs index: add `- [Mobile apps policy guide](docs/ai-policy-mobile-apps-guide.md).`, `- [Custom policy how-to](docs/custom-policy-howto.md).`, and `- [Post-compaction reload trigger setup](docs/post-compaction-reload-trigger-setup.md).`

Release practices:

- `ai/knowledge/release-practices.md:14`: replace "A docs-only change with no policy, procedure, trigger, or runtime behavior change ships as a PATCH." with "A docs-only change with no policy, procedure, trigger, or runtime behavior change may land without a release. Use PATCH for a small shipped fix, MINOR for behavior changes, and MAJOR for breaking changes."
- `ai/knowledge/release-practices.md` release checklist: add "For a docs-only change that lands without a release, run markdownlint, the validators, and the suite, and record the change in the merge commit and the checkpoint."
- `design-docs/protocol-decisions.md`: append a dated decision that records the docs-only no-release rule, the workflow scope token in the spec and validation doc, and the `bash` command convention, and that supersedes the PATCH sentence.

Record:

- Append the dated plan entry to each of the four tickets now.
- Close F2 to F5 in the branch commit. Attach the plan to F2 and cross-reference it from F3, F4, and F5. Delete the plan file.

## Acceptance Criteria

- AC-1 (F2): no stale scope token remains. Assertion: `rg -n 'global or project|global skill package|team-over-global' docs/protocol-validation-system.md` returns no match, `rg -n '\|global\|' design-docs/specs/policy-loading-contract.md` returns no match, and `rg -n 'workflow or project|team-over-user|user-over-workflow' docs/protocol-validation-system.md` matches. `tests/test-docs-audit.sh` passes.
- AC-2 (F3): the map matches the post-close tree. Assertion: `rg -n '8 open|148 closed|14 durable|in-progress/global-to-workflow' ai/knowledge/codebase-skeleton-map-simple-ai-workflow.md` returns no match, and `rg -n '7 open, 0 in-progress, and 157 closed|16 durable project lessons|snapshot at 2026-11-26'` matches. `tests/test-docs-audit.sh` passes.
- AC-3 (F4): every documented invocation runs as written. Assertion: `rg -n '\./support-files/(audit-slides|build-slide-diagrams|build-slides-html|render-slides-preview)\.sh'` returns no match, and `rg -n 'bash support-files/(path-probe|build-slide-diagrams)\.sh' ai/procedures/load-context.md ai/policies/ai-policy-presentation.md` matches. The slide tests and `tests/test-path-probe.sh` pass.
- AC-4 (F5): the README index lists the three guides. Assertion: `rg -n 'docs/ai-policy-mobile-apps-guide.md|docs/custom-policy-howto.md|docs/post-compaction-reload-trigger-setup.md' README.md` matches. `tests/test-docs-audit.sh` passes.
- AC-5 (release practices): the rule is recorded. Assertion: `rg -n 'may land without a release' ai/knowledge/release-practices.md` matches, and `design-docs/protocol-decisions.md` has the new dated entry.
- AC-6: the full validation is green. Assertion: `tests/run-all.sh` exits 0, `validate-protocol.sh` prints 8 of 8, authoring validation prints PASSED, `markdownlint-cli2` reports 0, and `shellcheck -S warning` reports 0.
- AC-7: no release artifact changes. Assertion: the README banner still names v7.11.0, and no new tag and no new announcement exists.
- AC-8: the four tickets are closed. Assertion: F2 to F5 are in `ai/issues/closed/`, the plan is attached to F2, F3 to F5 reference it, and `ai/plans/docs-batch-f2-to-f5.md` is deleted.

## Verification

1. `bash support-files/validate-policy-authoring.sh AGENTS.md $(find ai/policies ai/procedures -name '*.md' -print)`.
2. `bash support-files/validate-protocol.sh`.
3. `bash tests/run-all.sh`.
4. `markdownlint-cli2 'docs/**/*.md' '*.md' 'AGENTS.md' 'ai/issues/**/*.md'`.
5. `shellcheck -S warning support-files/*.sh tests/*.sh`.
6. The `rg` checks from AC-1 to AC-5.
7. `ls ai/issues/open/*.md | wc -l` and `ls ai/issues/closed/*.md | wc -l` after the closes, to confirm 7 and 157.

PowerShell fixtures remain PENDING when `pwsh` is absent, as today.

## Peer Review Log

- 2026-11-26, review-195: CHANGES REQUESTED. Two Minor: the AC-7 assertion named a specific next version, and the protocol-decisions entry did not record the batch's binding decisions. Both fixed.
- 2026-11-26, review-196: APPROVED after the fixes.

## Risks and Rollback

- Risk: the map counts are wrong because the four tickets close in the same commit. Mitigation: compute the post-close counts (7 open, 157 closed) and verify with `ls` before the commit.
- Risk: a usage line is missed. Mitigation: the `rg` sweep in AC-3.
- Risk: the release-practices change is read as allowing policy or procedure changes without a release. Mitigation: the rule names "docs-only, no policy, procedure, trigger, or runtime behavior change".
- Rollback: before the merge, delete the branch; after the merge, fix forward on a new branch. There is no release to unwind.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, origin `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- Base ref: `master`, the repository default branch.
- Merge mode: direct, per `ai-customization.md` `Merge Mode: direct`. Deliver one squash commit to `master`.
- Baseline: commit the plan, the four ticket updates, and the carried v7.11.0 checkpoint state as a chore baseline on `master` before opening the branch.
- Branch: `docs/examination-followups`.
- Tickets: close F2 to F5 in the branch commit. Attach the plan to F2 and cross-reference it from F3, F4, and F5.
- Release: none. Do not tag, do not publish a GitHub Release, and leave the README banner at v7.11.0.
- Evidence: the index, the authoring validator, `validate-protocol.sh` 8 of 8, `tests/run-all.sh`, `markdownlint-cli2` 0, `shellcheck` 0, and the `rg` checks are recorded in the checkpoint and the review.
- Terminal gate: the branch is at least one commit ahead of `master`, the tree is clean, and no post-merge repository change is made.
