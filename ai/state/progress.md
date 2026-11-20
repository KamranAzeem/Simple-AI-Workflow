<!-- STATE-FILE-HEADER: progress.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** completed work, one entry per line, newest at the bottom.
- **Never write:** transcripts, rationale, plans, commands, implementation steps, investigation notes, or git metadata. Detail goes to the daily checkpoints or Project Knowledge.
- **Brevity:** at most three short bullets per item.
- **Size:** counted in the shared state-file budget in `ai-policy-common.md`.
- **Archive:** move the oldest completed entries to the daily checkpoints when they are older than 14 days; if the shared budget is still exceeded, let it exceed and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: progress.md END -->

[2026-11-19] Released v6.9.1 and published its GitHub release: the unconditional file-operation rule is live.
[2026-11-19] Recorded the enforcement lesson: the tool-selection policy states the rule, and the harness permission is the hard stop; the permission next-step is added.
[2026-11-19] Filed the built-in-first execution rewrite ticket (P1/XL) from the codebase examination, with the root causes, the user's decisions, and the evidence.
[2026-11-19] Wrote the plan `ai/plans/built-in-first-execution-rewrite.md`; ten peer-review rounds, review-37 through review-46; round 10 CHANGES REQUESTED.
[2026-11-19] Applied the round-10 fixes; round 11 is not run; the plan is not APPROVED; no branch and no implementation.
[2026-11-19] Cut the built-in-first scope after round 11; fixed the helper's effective/conflict post-process and the six Minors; review-49 APPROVED.
[2026-11-19] Implemented the built-in-first rewrite on `feature/built-in-first-execution`: AGENTS.md precedence, the nine-bullet ladder, the load-context rewrite, the read-only helper and contract, docs, tests, ADR, and v6.10.0; review-50 APPROVED. Full text in the 2026-11-20 checkpoint.
[2026-11-19] Closed the built-in-first ticket with the plan attached and removed the plan file.
[2026-11-19] Released v6.10.0 and published its GitHub release: the built-in-first boot, the read-only index helper, and the ADR entry are live; master `64b0c61`; the feature branch is deleted.
[2026-11-19] Ran the full codebase examination over `docs/`, `tests/`, and `support-files/`; the ticket `ai/issues/closed/codebase-examination-docs-tests-support.md`; F1-F7, with F5 withdrawn.
[2026-11-19] Fixed the examination findings and released v6.10.1: the settings template, the support README, the fallback/archive/skills tests, the helper archive pattern, and the ADR symlink note; master `df54e07`; the fix branch is deleted.
[2026-11-19] Planned the user-global skills root: `ai/plans/user-global-skills-root.md`; review-51 CHANGES REQUESTED, review-52 APPROVED; the implementation is next.
[2026-11-19] Set `Default Shell Path: /usr/bin/bash` and made the Kilo bash permissions `*python3 *`, `*python *`, and `*` all ask.
[2026-11-19] Fixed GitHub #11: the boot builds its index with the built-in reader, glob, and search; the optional helper is off the boot path; the proof reports `index-source=builtin`; review-57 APPROVED.
[2026-11-19] Updated the index contract, support README, common policy, project knowledge, validator anchors, four docs, README banner, v6.10.2 announcement, and the ADR supersession; fixed the helper's empty-glob and shadowed-trigger cases.
[2026-11-19] Verified the fix: suite 25/25, protocol 8/8, authoring and triggers PASSED, markdownlint 0, shellcheck 0; counts 39 modules, 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors.
[2026-11-19] Merged GitHub #11 to master as `2f3a081`, tagged `v6.10.2`, published the GitHub Release, deleted the fix branch, and closed the issue.
[2026-11-19] Post-merge verification on master: suite 25/25, protocol 8/8, counts 39 modules, 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors; the plan entry is on the issue and the plan file is removed.
[2026-11-19] Documented the opt-in report-anomalies rule in `README.md` and `docs/ai-customization-guide.md`; corrected the rule wording, numbering, and checkpoint placement; review-61 APPROVED; suite 25/25, reference test PASS, markdownlint 0.
[2026-11-19] Posted the plan to GitHub #12 and updated the comment with the final peer-review log; the plan file is removed; the docs change is prepared; merge pending approval.
[2026-11-19] Merged and closed GitHub #12 after the earlier checkpoint; the report-anomalies docs are live; no release.
[2026-11-19] Implemented GitHub #8: the out-of-band backup scripts, the 17-case test, the support README restructure, the ADR scope entry, and the v6.11.0 announcement; review-63 APPROVED; suite 26/26, protocol 8/8, shellcheck 0, markdownlint 0; merge and release pending approval.
[2026-11-19] Merged GitHub #8, tagged `v6.11.0`, published the release, and closed the issue; the backup scripts are live.
[2026-11-19] Fixed the global-settings fixture to derive the test count from `tests/test-*.sh`; the post-merge suite is green at 26/26.
[2026-11-19] Dropped the user-global skills root: the third root adds a second meaning of global; the ticket is closed with the plan attached, the plan file is removed, and the two-root model stays.
[2026-11-19] Pruned the open issue backlog: 13 closed, 2 merged, 8 kept; the open tracker is 8.
[2026-11-19] Fixed the sync-agents-md.ps1 -WhatIf migration bug; added `tests/verify-powershell-scripts.ps1`; the VM run passed every check; the host suite 26/26, the protocol validator, and markdownlint green; the issue is closed with the plan attached.
[2026-11-19] Merged the PowerShell scripts fix to trunk and removed the item from the backlog; the sync `-WhatIf` guard and the Windows verification script are live; suite 26/26, protocol 8/8, markdownlint 0.
[2026-11-19] Landed the backlog prune and the skills-root drop as their own change: 15 tickets closed, 2 merged, 8 kept, and the lesson on the global-versus-user split added.
[2026-11-19] Repaired two post-merge defects: an MD044 proper-name hit in a progress entry and three empty mandatory directories removed by a stash round-trip.
[2026-11-20] Implemented the v7.0.0 state-file total budget: 30,720 bytes shared, number-free headers, the 300-character guard, and the condense pipeline; review-70 APPROVED.
[2026-11-20] Added the condense steps to the checkpoint and repair: diary copy, stub, identifier diff, not-condensable stop, and a promotion-candidate list; knowledge writes stay with the checkpoint.
[2026-11-20] Made the load report bytes, the over-300 count, and five line pointers; raised the validator advisory to 30 KB; added tests/test-state-file-budget.sh.
[2026-11-20] Migrated this repo's headers and condensed two over-300 items into the 2026-11-20 diary; suite 27/27, protocol 8/8, authoring PASSED, markdownlint 0, shellcheck 0.
[2026-11-20] Squash-merged v7.0.0 to master as `beacc3e`, deleted the feature branch, pushed, tagged, and published the release; GitHub #13 is closed.
[2026-11-20] Post-release verification on master: release URL live, #13 closed, working tree clean at the release; the shared budget, the condense pipeline, and the number-free headers are live.
[2026-11-20] Filed the backup defect ticket: the Bash script walks 92,657 directories silently, and the Windows owner-only check deletes good archives; the Windows cause is confirmed.
[2026-11-20] Filed the shared team knowledge store ticket with the full brainstorm: transports, store shape, contribution, consumption, governance, shortlist, and open questions.
[2026-11-20] Hardened `backup-ai.sh` and `backup-ai.ps1`: streamed discovery and per-project progress, pruned heavy directories, kept archives when the Windows ACL check is unavailable, and printed tar causes; review-74 APPROVED.
[2026-11-20] Extended `tests/test-backup-ai.sh` to 22 cases and the Windows verification script with progress, summary, and prune checks; the backup test passes 57 checks.
