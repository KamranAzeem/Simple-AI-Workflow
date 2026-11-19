<!-- STATE-FILE-HEADER: progress.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** completed work, one entry per line, newest at the bottom.
- **Never write:** transcripts, rationale, plans, commands, implementation steps, investigation notes, or git metadata. Detail goes to the daily checkpoints or Project Knowledge.
- **Brevity:** at most three short bullets per item.
- **Size and archive:** 7 KB soft target; move the oldest completed entries to the daily checkpoints when the file is over the target or holds entries older than 14 days. If the file is still over target, let it exceed and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: progress.md END -->

[2026-11-19] Added the tool-selection ladder, made git-ignored protocol files readable, removed the old file-edit rules, and added the tool-selection fixture; prepared the v6.7.0 release.
[2026-11-19] Released v6.7.0 and published its GitHub release: the tool-selection ladder is live, the readable git-ignore rule is in place, and the 22nd test guards both.
[2026-11-19] Filed the config ticket for the configurable global directory, early settings load, and shell configuration; linked GitHub #9 and the bootstrap ticket; P2/XL, AI estimate.
[2026-11-19] Reviewed the idea-tracking options and chose the safe path: a discussed problem or solution becomes one next-steps line at the checkpoint; no mid-session next-steps writes.
[2026-11-19] Added the checkpoint discussed-idea rule and corrected the design-docs trigger scope; released v6.7.1.
[2026-11-19] Agreed the config design: `Default Shell` in the customization, `Default Shell Path` in the settings, the whole settings directory read early, the sync keeps Merge Policy, the bootstrap owned, the skills root separate.
[2026-11-19] Finished the configurable global user directory and default shell unit: the customization keys, the early whole-settings read, the shell path and name resolution, the validator and sync updates, the bootstrap, the quoted backup, the live docs, the ADR, and the strengthened test; review-30 APPROVED; suite 23/23, protocol 8/8, authoring, markdownlint, and shellcheck green.
[2026-11-19] Released v6.8.0 and published its GitHub release: the configurable global user directory, early whole-settings read, and default shell are live; GitHub #9 is closed as absorbed.
[2026-11-19] Added the repair global settings procedure and policy: canonical keys, the Identity and Profile split, verified tools, redaction, the manifest, the backup, the dry run, and the review gate; the suite is 24 scripts; review-34 APPROVED; v6.9.0 is prepared.
[2026-11-19] Released v6.9.0 and published its GitHub release: the repair global settings procedure and policy are live.
[2026-11-19] Ran `repair global settings` on the user's settings: consolidated 6,703 to 5,257 bytes, verified 22 tools, kept 6 sensitive names by count only, and removed Style Sources, the git pointer, and the prose; review-35 APPROVED; the manifest and backup are recorded.
[2026-11-19] Strengthened the Tool Selection rule: Python or another runtime never searches, creates, appends to, or edits a file; the conditional wording is gone; the test pins it; v6.9.1 is prepared.
[2026-11-19] Released v6.9.1 and published its GitHub release: the unconditional file-operation rule is live.
[2026-11-19] Recorded the enforcement lesson: the tool-selection policy states the rule, and the harness permission is the hard stop; the permission next-step is added.
[2026-11-19] Filed the built-in-first execution rewrite ticket (P1/XL) from the codebase examination, with the root causes, the user's decisions, and the evidence.
[2026-11-19] Wrote the plan `ai/plans/built-in-first-execution-rewrite.md`; ten peer-review rounds, review-37 through review-46; round 10 CHANGES REQUESTED.
[2026-11-19] Applied the round-10 fixes; round 11 is not run; the plan is not APPROVED; no branch and no implementation.
[2026-11-19] Cut the built-in-first scope after round 11; fixed the helper's effective/conflict post-process and the six Minors; review-49 APPROVED.
[2026-11-19] Implemented the built-in-first rewrite on `feature/built-in-first-execution`: the AGENTS.md precedence section, the nine-bullet ladder, the load-context rewrite, the read-only helper and contract, the docs, tests, ADR, and v6.10.0 announcement; review-50 APPROVED; suite 25/25, both validators, markdownlint 108 files, shellcheck green.
[2026-11-19] Closed the built-in-first ticket with the plan attached and removed the plan file.
[2026-11-19] Released v6.10.0 and published its GitHub release: the built-in-first boot, the read-only index helper, and the ADR entry are live; master `64b0c61`; the feature branch is deleted.
[2026-11-19] Ran the full codebase examination over `docs/`, `tests/`, and `support-files/`; the ticket `ai/issues/closed/codebase-examination-docs-tests-support.md`; F1-F7, with F5 withdrawn.
[2026-11-19] Fixed the examination findings and released v6.10.1: the settings template, the support README, the fallback/archive/skills tests, the helper archive pattern, and the ADR symlink note; master `df54e07`; the fix branch is deleted.
[2026-11-19] Planned the user-global skills root: `ai/plans/user-global-skills-root.md`; review-51 CHANGES REQUESTED, review-52 APPROVED; the implementation is next.
[2026-11-19] Set `Default Shell Path: /usr/bin/bash` and made the Kilo bash permissions `*python3 *`, `*python *`, and `*` all ask.
[2026-11-19] Fixed GitHub #11: the boot builds its index with the built-in reader, glob, and search; the optional helper is off the boot path; the proof reports `index-source=builtin`; review-57 APPROVED.
[2026-11-19] Updated the index contract, support README, common policy, project knowledge, validator anchors, four docs, README banner, v6.10.2 announcement, and the ADR supersession; fixed the helper's empty-glob and shadowed-trigger cases.
[2026-11-19] Verified the fix: suite 25/25, protocol 8/8, authoring and triggers PASSED, markdownlint 0, shellcheck 0; counts 39 modules, 24 policies, 15 procedures, 50 triggers, 0 conflicts, 0 errors.
