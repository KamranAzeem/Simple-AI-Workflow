> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Release Practices

## Context

The workflow uses semantic versioning. GitHub Releases is the authoritative changelog. Each release also gets a short friendly announcement under `docs/announcements/`, and the README banner links to it.

## Rule or Fix

### Versioning and announcement

- Use `MAJOR.MINOR.PATCH`.
- Create an annotated tag after the merge: `git tag -a vX.Y.Z -m "summary"`.
- Push the default branch and the tag: `git push origin <default-branch> && git push origin vX.Y.Z`.
- Write the release notes on GitHub Releases.
- Write a short announcement at `docs/announcements/vX.Y.Z.md`.
- Point the README banner at the announcement.
- Do not keep a version history in the README or a `RELEASE_NOTES.md` file.

### Release checklist

1. Add a `### vX.Y.Z (date)` section under `## Rule or Fix` with the release highlights.
2. Run markdownlint on the linted set and confirm 0 issues; lint every new markdown file.
3. Finish the docs sweep: slides, workflow guide, README docs list.
4. Write the announcement and point the README banner at it.
5. Keep all release documentation on the feature branch.
6. Squash merge the branch and confirm the validator passes 8/8.
7. Create the annotated tag on the default branch.
8. Push the default branch and the tag.
9. Publish the GitHub Release.

### v6.3.0 (2026-11-09)

- Add the skills layer: the global and project `ai/skills/` roots, package-only `SKILL.md` with `name` and a one-line description, a boot index, explicit and description activation, a project override, and cross-type collision reporting.
- Add the helper-approval and path-containment rule; no trust scan (the user is responsible for the source).
- Add `ITEM SKILLS-INDEX`, the checkpoint count and package names, the repair exclusion, the lint coverage, and the docs examples.
- Add the validator anchors and the skills fixture; the reference counts become 13 procedures, 99 steps, 4 tiers, and 12 items.
- Upgrade action: pull, run the sync script, restart the session; put global skills in the clone and project skills in the project.
- Published 2026-11-09.

### v6.2.0 (2026-11-09)

- Name knowledge files for the task with six or fewer hyphenated segments; split only by topic; merge files under 3 KB.
- Replace the no-split rule with topic splits, evidence deletion (`removed as incident evidence`), one lesson in one place, per-PR findings folded into topic files, and inventories kept out of the knowledge stores.
- Use a 50-file review threshold per store; the checkpoint reports the count and recommends a repair; the repair reports a remaining overage.
- Add the task-to-filename lookup rule and the retirement report for closed ticket files, executed plans, and finished artifacts.
- Rebuild the knowledge fixture and add the validator anchors and legacy-phrase guard.
- The protocol's own knowledge names migrate on touch or repair.
- Upgrade action: pull, run the sync script, restart, and run `repair knowledge files` once (add `global`).
- Published 2026-11-09.

### v6.1.0 (2026-11-09)

- Scope the boot discovery to the boot roots, add the Boot Scan Exclusions, and bound the output at 16 KB.
- Read the latest checkpoint once and compact the proof to counts only.
- Add the developer `--index` oracle to the authoring validator and a boot fixture.
- State the OS- and terminal-agnostic instruction; Windows requires `pwsh` 7 or higher.
- Upgrade action: pull, run the sync script, restart the session.
- Published 2026-11-09.

### v6.0.0 (2026-11-09)

- Move the 13 procedure bodies to `ai/procedures/`, one self-standing module each with H1 titles and `## Triggers`.
- `AGENTS.md` becomes a thin router: always-on rules, the shared index step, and dispatch.
- Migrate the validators and the reference test to the procedure store; add the thin-AGENTS and procedure-module checks.
- Move the setup appendix to `docs/setup.md`.
- The `#N` procedure trigger persists for `plan issue #N` and `implement issue #N`.
- Upgrade action: pull the clone, run the sync script, and restart the session.
- Published 2026-11-09 with the final approval.

### v5.8.0 (2026-11-09)

- Policies can declare `## Triggers`; an approved phrase loads the policy for the session.
- One shared trigger-index step and a dispatch section; load context reports a protocol index item.
- The authoring validator gains trigger shape, namespace, name, and placeholder checks, plus a `--triggers` aggregate mode; a fixture test covers the rules.
- Initial declarations: `cloud standards`, `data standards`, `database standards`, and `backend standards`.
- Upgrade action: pull the clone, run the sync script, and restart the session.
- Published 2026-11-09 with the final approval.

### v5.7.0 (2026-11-07)

- Check the workflow clone against its remote at load context, read-only.
- Report up to date, updates available with the pull command, or an ahead or diverged warning in the load report.
- Fail soft immediately when git or the path is unusable, and cap the remote call at about three seconds.
- Keep the check at load context only; checkpoint and post-compaction recovery are unchanged.
- Upgrade action: none beyond the usual sync.

### v5.6.0 (2026-11-03)

- Deliver work items through two procedures: `MANAGE-ISSUES` for ticket work and planning, `IMPLEMENT-PLAN` for delivery.
- State the order once in `AGENTS.md`; the common policy keeps invariants and the template, guide, README, and collaboration doc point to the procedures.
- Add `## Merge Policy` with `Merge Mode: direct`, `pr`, or `auto`; no CLI is required.
- Keep tickets by reference: local by default, external when supplied. A local ticket closes in the branch commit; an external ticket closes on merge.
- Allow several branch commits; trunk receives one squash commit.
- Add the order-drift guard to the reference test.
- Upgrade action: run the sync script to add `## Merge Policy`; set `pr` for a team repository that requires a pull request.

### v5.5.2 (2026-11-03)

- Resolve policy loads from the Global AI Policies Directory; no protocol file hardcodes a policy path.
- Name the workflow, home, and settings directories from the user's project perspective in `AGENTS.md`.
- Resolve the meta policy's protocol-repository paths from the Global AI Workflow Directory.
- Add a path-conformance check to the reference test.
- Upgrade action: none beyond the usual sync.

### v5.5.1 (2026-10-31)

- File and analyze an issue with no branch.
- Write and review the plan while the ticket is in `open/`, with no branch and no commit.
- Open the feature branch and move the ticket to `in-progress/` only on the implement request.
- Narrow the branch-before-edit rule to code changes; planning artifacts are exempt.
- Update `AGENTS.md`, the common policy, the issue template, the guide, README, slides, ADRs, and the announcement.
- Upgrade action: none beyond the usual sync.

### v5.5.0 (2026-10-31)

- Add a bound `## Close Sequence` to every plan.
- Require plan review to check the close sequence and the terminal gate.
- Gate any close or merge claim on at least one commit ahead of the resolved base and a clean working tree.
- Cover local commits and pushes with feature-branch approval; keep trunk merge, tags, releases, and external writes gated.
- Require every unblocked step before an approval request.
- Record an uncommitted branch as unfinished work.
- Store AI state only under the project root `ai/`, tracked or not.
- Add the procedural-completeness review dimension and four ADRs.
- Upgrade action: none beyond the usual sync.

### v5.4.1 (2026-10-29)

- Replace the 100-line and one-lesson rule with a 10 KB soft target and a 15 KB automatic review.
- Never split; trim and merge; a checklist stays one file; the file count cannot increase.
- Make knowledge files self-standing; remove cross-file pointers; use the self-contained header.
- Make the repair autonomous; no questions; preserve ambiguous content; abort an incomplete file; require an `APPROVED` review before replacement.
- Project knowledge may keep identifying names; global knowledge removes them; raw secrets are banned in both.
- Repair the project and global corpora, the docs, the announcement, the release practices, and the ADRs.
- Upgrade action: run `repair knowledge files` once; add `global` if you keep global knowledge.

## Why

- GitHub Releases gives one authoritative changelog.
- A short announcement answers what changed and what to do.
- A checklist keeps the docs, tag, and release in sync.
- The branch carries the release documentation before the merge.

## Verify

- Confirm the release section is in this file before the merge.
- Confirm markdownlint reports 0 issues.
- Confirm the README banner links to the announcement.
- Confirm the validator passes 8/8.
- Confirm the tag and GitHub Release exist after the merge.

## Caveats

- The announcement is a summary, not a second changelog.
- The release email is optional and uses the announcement as its source.
- The historical release records are not part of the shipped corpus; Git tags and GitHub Releases are the authoritative history.
