Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: L
URL:
Summary: Add ready-made ai-customization.md presets for common roles

Description:

Add variants of `ai-customization.md` for common roles, covering expertise (policies), active traits, compliance, project constraints, and developer workflow. Roles to start with:

- Cloud architect (full infrastructure and the software stack).
- Product or solution architect (multiple microservices, modules, databases, data design, data flow).
- Web developer (several web components under one project).
- Mobile app developer (several product components under one project).
- More roles later.

This is broader than the Active Traits work in `active-traits-persona-customization-files.md`. Keep the two consistent, since the traits are a subset of each preset.

Needs discussion before implementation: confirm the role list and what each preset contains.

Acceptance criteria:

- One preset per role under `docs/examples/` or a presets directory.
- The customization guide explains how to pick and adapt a preset.
- Cross-referenced with the Active Traits persona ticket.

## Merged scope (2026-11-19)

Absorbed `active-traits-persona-customization-files.md`. The presets also cover the personas the trait catalog does not: system administrator, cloud administrator, infrastructure engineer, and software developer. The existing seven traits already cover System Architect, System Integrator, Senior DBA, Observability Architect, Code Reviewer, Security Specialist, and Teacher/Trainer (`docs/ai-customization-guide.md:64-73`).

The role list and each preset's contents still need the user decision noted above.

## Init consumer (2026-11-25)

- `--init --role <preset>` in `sync-script-init-scaffolding.md` consumes these presets. The preset name is the role switch value.
- The role list and contents must settle before init is implemented.

---
2026-11-26

## Grilling decisions

- Eight presets: cloud-architect, solution-architect, web-developer, mobile-developer, platform-engineer, dba, data-engineer, security-engineer.
- Active Expertise: cloud-architect (cloud, api-backend, data, dba, web-frontend, observability); solution-architect (cloud, api-backend, data, dba, web-frontend, mobile-apps); web-developer (web-frontend, api-backend, coding-baseline); mobile-developer (mobile-apps, api-backend, coding-baseline); platform-engineer (cloud, `linux-system-admin`, windows-system-admin, observability); dba (dba, data); data-engineer (data, dba, cloud); security-engineer (coding-baseline, observability, cloud).
- Traits: add Platform Engineer, Software Developer, and Data Engineer to the guide's catalog. Mapping: cloud-architect=System Architect, solution-architect=System Integrator, web-developer and mobile-developer=Software Developer, platform-engineer=Platform Engineer, dba=Senior DBA, data-engineer=Data Engineer, security-engineer=Security Specialist.
- Contents: full `ai-customization.md` variants under `docs/examples/customization-presets/<role>.md` with the workflow placeholders, one trait, `design-docs/`, and `auto` merge. soc2 and iso-27001 are pre-filled for cloud-architect, solution-architect, platform-engineer, data-engineer, and security-engineer; web-developer, mobile-developer, and dba leave compliance empty with the comment.
- The slugs are the `--role` values for the later `--init` ticket. Scope is the presets and the guide; the release is a conservative PATCH (user direction, 2026-11-26). The role list and contents are settled; the next step is the plan.

## Plan (2026-11-26)

Plan attached below.

## Implementation Plan

# Plan: Customization Presets by Role

## Goal

Ship eight ready-to-copy `ai-customization.md` presets under `docs/examples/customization-presets/`, add the three supporting traits and a presets section to the customization guide, keep the workflow guide, slide appendix, base template, README, and announcements consistent, and release the conservative PATCH v7.8.2. No policy, procedure, or trigger changes.

## Evidence

### Sources

- Ticket `ai/issues/open/customization-presets-per-role.md` lines 43-49 record the settled scope: eight roles, each Active Expertise set, the trait mapping, the compliance split, the slug contract, presets plus guide scope, and a release. The user directed a conservative PATCH for a docs-only change.
- `ai/issues/open/sync-script-init-scaffolding.md` lines 57, 63, 74, and 77 show that init consumes a preset by a role switch and waits for this ticket. Line 69 still lists the switch name (`--role` or `--expertise`) as open, so the switch name stays with the init ticket. This ticket freezes only the eight slug values.
- `docs/ai-customization.md` lines 1-89 give the base template shape: workflow configuration, Active Expertise, Active Traits, Required Compliance, Design Docs, and Merge Policy. Line 29 lists available expertise and omits `coding-baseline` and spells `Linux-system-admin` with a capital L.
- `docs/examples/full-stack-web-mobile-ai-customization.md` lines 1-50 is an existing combined web and mobile example. It stays as a multi-component scenario, not one of the eight role presets.
- `docs/ai-customization-guide.md` lines 80-95 hold the seven-trait catalog, lines 158-173 describe the merge modes, and lines 177-198 hold the naming notes.
- `docs/workflow-guide.md` line 222 repeats the trait catalog and must stay consistent.
- `docs/simple-ai-workflow-slides.md` lines 741-742 list the same seven traits in the appendix. `tests/test-slides.sh` line 349 compares the committed HTML with a fresh build, so the deck and the rebuilt `docs/slides/simple-ai-workflow-slides.html` must change together.
- `README.md` line 3 is the release banner, lines 198-217 are the docs index, and line 219 states the protocol counts and version.
- `design-docs/protocol-decisions.md` uses dated `## YYYY-MM-DD: Title` headings and contains zero `ADR-NNN` tokens. The plan follows that store convention.
- The decision at `design-docs/protocol-decisions.md:1190` defers the delivery ledger because the repo has no ledger.

### Commands run and results

- `git branch -a` and `git symbolic-ref refs/remotes/origin/HEAD`: the default branch is `master` and `origin/HEAD -> origin/master`.
- `git tag --sort=-v:refname | head -1`: the latest tag is `v7.8.1`, so the next PATCH is `v7.8.2`.
- The boot index count: 26 policies, 16 procedures, and 59 triggers. This change adds none.

## Depth

L. This plan carries an HLD, an LLD with acceptance criteria, ADRs, a test plan, risks, and a close sequence.

## Context

### Problem

A new project copies `docs/ai-customization.md` and then edits every section by hand. The ticket settled eight common roles and their expertise, trait, and compliance choices. Nothing ships those choices as ready-made files, so the future init mode has no preset to consume.

### HLD

- Presets are documentation artifacts, not policy files. They live under `docs/examples/customization-presets/` and copy into a project root as `ai-customization.md`.
- Each preset is a full customization variant with the same section order as the base template. A user copies one file and changes the workflow path and any project-specific entries.
- Each preset carries exactly one suggested trait. The ticket mapping is the source of truth.
- Compliance is a starting suggestion, never a compliance determination. The AI still applies its built-in knowledge of every listed standard.
- The preset slug is the preset identifier the future init consumes. The init ticket keeps the switch name.
- The protocol modules remain authoritative. A preset cannot override `AGENTS.md`, a policy, a procedure, or the user.

### LLD

**Preset files:** `docs/examples/customization-presets/<role>.md` for the eight slugs.

- `cloud-architect.md`: cloud, api-backend, data, dba, web-frontend, observability; System Architect; soc2, iso-27001.
- `solution-architect.md`: cloud, api-backend, data, dba, web-frontend, mobile-apps; System Integrator; soc2, iso-27001.
- `web-developer.md`: web-frontend, api-backend, coding-baseline; Software Developer; compliance empty.
- `mobile-developer.md`: mobile-apps, api-backend, coding-baseline; Software Developer; compliance empty.
- `platform-engineer.md`: cloud, `linux-system-admin`, windows-system-admin, observability; Platform Engineer; soc2, iso-27001.
- `dba.md`: dba, data; Senior DBA; compliance empty.
- `data-engineer.md`: data, dba, cloud; Data Engineer; soc2, iso-27001.
- `security-engineer.md`: coding-baseline, observability, cloud; Security Specialist; soc2, iso-27001.

Each preset carries the workflow placeholders, one trait, `design-docs/`, and `auto` merge. The `platform-engineer` preset carries a file-level `markdownlint-disable MD044` so its real lowercase `linux-system-admin` bullet stays plain.

**New traits:** Platform Engineer, Software Developer, and Data Engineer join the guide catalog.

**Docs:** the guide gains section 11, the workflow guide and slide appendix name the three traits, the base template's available-expertise comment is corrected, the README banner moves to v7.8.2, and a v7.8.2 announcement is written.

**Tests:** a new `tests/test-customization-presets.sh` pins the eight presets, anchors, expertise order, one trait, compliance, guide section, trait surfaces, base template, ADR headings, and placeholders. `tests/test-docs-audit.sh` and `tests/test-readme-shape.sh` are updated for v7.8.2.

## Decisions (ADR)

- Presets are full variants under `docs/examples/customization-presets/`, not policy files.
- Three traits join the catalog; web and mobile share Software Developer.
- The eight slugs are frozen preset identifiers; the init switch name stays with the init ticket.
- Compliance is a suggestion, not a determination; five roles pre-fill soc2 and iso-27001, three leave it empty.
- Documentation-only additions ship as a PATCH; behavior changes take MINOR and breaking changes take MAJOR.

## Deltas

- Create the eight preset files under `docs/examples/customization-presets/`.
- Modify `docs/ai-customization-guide.md`.
- Modify `docs/workflow-guide.md`.
- Modify `docs/simple-ai-workflow-slides.md` and rebuild `docs/slides/simple-ai-workflow-slides.html`.
- Modify `docs/ai-customization.md`.
- Modify `README.md`.
- Create `docs/announcements/v7.8.2.md`.
- Create `tests/test-customization-presets.sh`.
- Modify `tests/test-docs-audit.sh` and `tests/test-readme-shape.sh`.
- Append five dated ADR entries to `design-docs/protocol-decisions.md`.
- No policy, procedure, or trigger change. Counts stay 26/16/59.

## Acceptance Criteria

- AC-1: The eight preset files exist. Asserted by `test-customization-presets.sh`.
- AC-2: Every preset carries the required section anchors and the platform-engineer MD044 handling. Asserted by the fixture.
- AC-3: Every preset's expertise set matches in order. Asserted by the fixture.
- AC-4: Every preset has exactly one trait bullet and the mapped trait. Asserted by the fixture.
- AC-5: Compliance is present for five roles and absent for three, using exact line matching. Asserted by the fixture.
- AC-6: The guide gains the three traits and section 11 names all eight role cells. Asserted by the fixture.
- AC-7: The workflow guide, slide appendix, and base template carry the expected strings. Asserted by the fixture.
- AC-8: The README banner, presets link, v7.8.2 announcement, and release URL are present; the v7.8.1 assertions stay. Asserted by the two docs fixtures.
- AC-9: Changed markdown passes markdownlint and changed shell passes shellcheck. Asserted by the commands.
- AC-10: The five ADR headings are in the store. Asserted by the fixture.
- AC-11: Validator 8/8, slide fixture pass, and suite 34/34. Asserted by the commands.

## Verification

- `bash support-files/validate-protocol.sh` returns 8/8.
- `bash tests/run-all.sh` passes 34/34.
- `bash tests/test-slides.sh` passes.
- `markdownlint-cli2` on the 17 changed markdown files reports 0.
- `shellcheck` on the three changed shell files reports 0.

## Peer Review Log

- Plan reviews 171-174; review-174 APPROVED then a user-directed PATCH amendment.
- Implementation review-175 CHANGES REQUESTED; review-176 APPROVED.

## Risks and Rollback

- A preset can drift from the ticket mapping; the fixture pins it.
- The banner change can break the docs tests; both fixtures are updated.
- The slide edit can drift; the build script and slide fixture compare the result.
- Rollback: revert the squash commit, delete the `v7.8.2` tag and release, restore the README banner.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base ref: `master`.
- Baseline: the chore commit of this plan and the ticket.
- Branch: `feature/customization-presets`.
- Ticket: `ai/issues/closed/customization-presets-per-role.md`, plan attached.
- Merge mode: `direct`.
- Release: v7.8.2, PATCH, annotated tag and GitHub Release.
- Evidence: validator 8/8, suite 34/34, slide fixture pass, markdownlint 0, shellcheck 0, review-176 APPROVED.
- Order: checkpoint on the branch before the commit; no post-merge commits.
