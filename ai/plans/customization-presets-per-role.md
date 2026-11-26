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
- `docs/personas/architect-reviewer.md`, `docs/personas/mentor-trainer.md`, and `docs/personas/security-specialist.md` were read for tone only. They cover Architect and Reviewer, Mentor and Trainer, and Security Specialist, not the three new roles. The new trait text is original. The Software Developer scope wording follows `ai/policies/ai-policy-coding-baseline.md` lines 30-41; the TDD wording follows lines 150-151 and the common policy's `Universal Testing Standards`.
- `README.md` line 3 is the release banner, lines 198-217 are the docs index, and line 219 states the protocol counts and version.
- `tests/test-readme-shape.sh` line 85 pins `v7.8.1`; `tests/test-docs-audit.sh` lines 169-171 pin the v7.8.1 announcement and the README pointer; `tests/run-all.sh` line 13 auto-discovers every `test-*.sh`.
- `ai/policies/ai-policy-meta.md` lines 30-42 list the required checks, and `ai/knowledge/release-practices.md` lists the announcement, banner, tag, and release steps.
- `design-docs/protocol-decisions.md` uses dated `## YYYY-MM-DD: Title` headings and contains zero `ADR-NNN` tokens. The plan follows that store convention.
- The decision at `design-docs/protocol-decisions.md:1190` says "The delivery ledger is deferred because the repo has no ledger; this change follows the existing convention." The ledger stays deferred, so appending ADR entries does not create one.

### Commands run and results

- `git branch -a` and `git symbolic-ref refs/remotes/origin/HEAD`: the default branch is `master` and `origin/HEAD -> origin/master`. The close sequence uses `master`.
- `git tag --sort=-v:refname | head -1`: the latest tag is `v7.8.1`, so the next PATCH is `v7.8.2`. The user directed this docs-only change to ship as a PATCH to slow version growth.
- `bash support-files/index-protocol.sh` or the boot index count: 26 policies, 16 procedures, and 59 triggers. This change adds none, so the counts claim holds.
- `ls ai/policies/ai-policy-*.md` plus a per-token check: all ten expertise tokens resolve to policy files (cloud, api-backend, data, dba, web-frontend, observability, mobile-apps, coding-baseline, `linux-system-admin`, windows-system-admin).
- `ls docs/examples`: the directory exists; `docs/examples/customization-presets/` does not exist yet.
- `sed -n '735,748p' docs/simple-ai-workflow-slides.md` and `grep -nE 'trait|teacher' tests/test-slides.sh`: the appendix lists all seven traits, and the slide fixture pins the appendix group name but not the trait line, so a one-line deck edit plus a rebuild is enough.

### Open questions

- None block this plan. The init switch name remains with `sync-script-init-scaffolding.md` line 69; this plan freezes the eight slug values only.

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

**Preset files (create):** `docs/examples/customization-presets/<role>.md` for the eight slugs below.

- `cloud-architect.md`: expertise cloud, api-backend, data, dba, web-frontend, observability; trait System Architect; compliance soc2, iso-27001.
- `solution-architect.md`: expertise cloud, api-backend, data, dba, web-frontend, mobile-apps; trait System Integrator; compliance soc2, iso-27001.
- `web-developer.md`: expertise web-frontend, api-backend, coding-baseline; trait Software Developer; compliance empty.
- `mobile-developer.md`: expertise mobile-apps, api-backend, coding-baseline; trait Software Developer; compliance empty.
- `platform-engineer.md`: expertise cloud, `linux-system-admin`, windows-system-admin, observability; trait Platform Engineer; compliance soc2, iso-27001. The file carries `<!-- markdownlint-disable MD044 -->` at the top because its real `- linux-system-admin` bullet would otherwise trip the Linux proper-name rule; the token stays plain so the loader reads it.
- `dba.md`: expertise dba, data; trait Senior DBA; compliance empty.
- `data-engineer.md`: expertise data, dba, cloud; trait Data Engineer; compliance soc2, iso-27001.
- `security-engineer.md`: expertise coding-baseline, observability, cloud; trait Security Specialist; compliance soc2, iso-27001.

Each preset uses this section order and literal anchors:

```markdown
<!-- Copy this file to `ai-customization.md` in your project root (sibling of AGENTS.md). Set Workflow AI Directory to your Simple-AI-Workflow clone, then adjust the sections for your project. -->

# AI Customization

## AI Workflow Configuration

<!-- Point this at your Simple-AI-Workflow clone. -->

**Workflow AI Directory**: /path/to/Simple-AI-Workflow

**User AI Directory**: [HOME]/.ai/

**Default Shell**: bash

## Active Expertise

- <the role's tokens, one per bullet>

## Active Traits

<!-- Pick one trait. This preset suggests <Trait>. -->

- **<Trait>**: <definition>

## Required Compliance

<!-- Confirm the standards for your project. This is a starting suggestion, not a determination. Remove or add entries. -->

- soc2
- iso-27001

## Design Docs

**Location**: design-docs/

## Merge Policy

**Merge Mode**: auto
```

The three presets with empty compliance (`web-developer`, `mobile-developer`, `dba`) keep the `## Required Compliance` heading and replace the two bullets with one comment: `<!-- No standard is pre-filled. Add one when your project needs it, for example gdpr, soc2, or iso-27001. -->`.

**Trait definitions (new):** add to the customization guide catalog.

- **Platform Engineer**: Build and operate the shared platform: Kubernetes, CI/CD, infrastructure as code, and observability. Optimize for reliability, repeatability, least privilege, and self-service.
- **Software Developer**: Build and change application code across web and mobile components. Follow the project's existing stack and conventions, write the failing test first, and keep changes inside the requested scope.
- **Data Engineer**: Design and operate data pipelines, storage, and models. Prioritize correctness, idempotence, schema evolution, and cost-aware batch and streaming flows.

Reuse the existing definitions verbatim for System Architect, System Integrator, Senior DBA, and Security Specialist from `docs/ai-customization-guide.md` lines 82-87.

**Guide changes (modify `docs/ai-customization-guide.md`):**

- Add the three new trait bullets to the section 2 catalog.
- Add a one-line pointer in section 2 to the new presets section.
- Add `## 11. Presets by Role` before `## Best Practices`. It states where the files live, that a user copies one to the project root and sets `Workflow AI Directory`, that the preset is a starting point and not a policy, that the slugs are the preset identifiers for the future init, and that compliance is a suggestion. It lists the eight roles with their expertise, suggested trait, and compliance choice in the section 7 table style, with every expertise token in inline code, for example `linux-system-admin`, so the Linux proper-name rule passes. It points at the existing full-stack example as a combined multi-component scenario.

**Docs consistency:**

- `docs/workflow-guide.md`: add Platform Engineer, Software Developer, and Data Engineer to the trait summary at line 222.
- `docs/simple-ai-workflow-slides.md`: add the three traits to the appendix trait line at 741-742, then rebuild `docs/slides/simple-ai-workflow-slides.html` with `support-files/build-slides-html.sh`.
- `docs/ai-customization.md`: add `coding-baseline` to the available-expertise comment and lowercase `linux-system-admin`. Because that line is an HTML comment, backticks do not create a code span; put `<!-- markdownlint-disable-next-line MD044 -->` on the line before the comment. This is verified against the repo's MD044 config.
- `README.md`: change the banner to v7.8.2, add the presets to the docs index, and update the version in the counts line at 219.
- `docs/announcements/v7.8.2.md`: create the release announcement with the exact release URL `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.8.2`.

**Tests:**

- Create `tests/test-customization-presets.sh`. It asserts the eight files exist, each required section anchor is present with `grep -F` where brackets appear, each expertise set matches in order, each preset has exactly one trait bullet and the expected trait, compliance is present or absent per role using exact line matching (`^- soc2$`, `^- iso-27001$`), the guide names all eight slugs, the `## 11. Presets by Role` heading, the three new traits, and the `linux-system-admin` token in inline code, the workflow guide and the slide deck name the three new traits, `docs/ai-customization.md` names `coding-baseline` and lowercase `linux-system-admin` under the `markdownlint-disable-next-line MD044` directive, the five exact ADR headings are in `design-docs/protocol-decisions.md`, and every preset uses the placeholder path and never a real absolute path.
- Update `tests/test-docs-audit.sh`: assert the eight preset files exist, and move the README pointer assertion to v7.8.2. Keep the v7.8.1 announcement existence check and its release-URL assertion, and add the v7.8.2 existence and URL assertions. Do not point this fixture at the customization guide, whose `GUIDE` variable is `docs/workflow-guide.md`.
- Update `tests/test-readme-shape.sh`: pin the v7.8.2 banner and assert the README links the presets.

**ADRs (append to `design-docs/protocol-decisions.md`):** five dated entries, mirrored under Decisions below. The plan uses `###` subheadings; append each to the store as a top-level `## 2026-11-26: <title>` heading, matching the store convention. The 2026-11-19 delivery-ledger deferral at `design-docs/protocol-decisions.md:1190` still applies, so this change appends ADRs without creating a ledger.

## Decisions (ADR)

### 2026-11-26: Customization presets are full variants under docs/examples/customization-presets/

- Decision: ship eight full `ai-customization.md` variants, one per role, under `docs/examples/customization-presets/`.
- Context: the base template requires hand-editing, and the init ticket needs named presets.
- Consequences: presets are copy-paste starting points, not policy files; the protocol modules stay authoritative; the existing combined example stays as a separate scenario.

### 2026-11-26: Three traits join the catalog for the presets

- Decision: add Platform Engineer, Software Developer, and Data Engineer to the customization guide trait catalog.
- Context: the eight roles map to four existing and three new traits; web and mobile share Software Developer.
- Consequences: the guide, the workflow guide summary, the slide appendix, and the presets use the same trait names; no policy change is needed because traits are customization text.

### 2026-11-26: The preset slugs are the init preset identifiers

- Decision: freeze the eight lowercase kebab slugs as the preset identifiers: cloud-architect, solution-architect, web-developer, mobile-developer, platform-engineer, dba, data-engineer, security-engineer.
- Context: the init ticket consumes a preset by a role switch and must not rename the values; the switch name itself stays open in that ticket.
- Consequences: a later slug rename is a breaking change for init; init stays out of scope for this ticket.

### 2026-11-26: Preset compliance is a suggestion, not a determination

- Decision: pre-fill soc2 and iso-27001 for cloud-architect, solution-architect, platform-engineer, data-engineer, and security-engineer; leave compliance empty with a comment for web-developer, mobile-developer, and dba.
- Context: compliance depends on the project and the data it handles; the AI applies its built-in knowledge either way.
- Consequences: a preset never claims a project is compliant; the section comment tells the user to confirm or change it.

### 2026-11-26: Documentation-only additions ship as a PATCH

- Decision: a change that adds documentation, examples, or fixtures without a policy, procedure, trigger, or runtime behavior change ships as a PATCH.
- Context: successive MINOR releases for docs-only work inflate the version number and add no SemVer value.
- Consequences: this presets change ships as v7.8.2; behavior changes still take MINOR, and breaking changes still take MAJOR.

## Deltas

- Create `docs/examples/customization-presets/cloud-architect.md`.
- Create `docs/examples/customization-presets/solution-architect.md`.
- Create `docs/examples/customization-presets/web-developer.md`.
- Create `docs/examples/customization-presets/mobile-developer.md`.
- Create `docs/examples/customization-presets/platform-engineer.md`.
- Create `docs/examples/customization-presets/dba.md`.
- Create `docs/examples/customization-presets/data-engineer.md`.
- Create `docs/examples/customization-presets/security-engineer.md`.
- Modify `docs/ai-customization-guide.md`: three trait bullets, a section 2 pointer, and the new section 11.
- Modify `docs/workflow-guide.md`: add the three traits to the trait summary.
- Modify `docs/simple-ai-workflow-slides.md`: add the three traits to the appendix trait line.
- Rebuild `docs/slides/simple-ai-workflow-slides.html` from the slide Markdown.
- Modify `docs/ai-customization.md`: add `coding-baseline` to the available-expertise comment, lowercase `linux-system-admin`, and put `<!-- markdownlint-disable-next-line MD044 -->` before that comment.
- Modify `README.md`: v7.8.2 banner, presets docs link, and the counts-line version.
- Modify `ai/issues/open/customization-presets-per-role.md`: append the dated plan entry and wrap the existing `linux-system-admin` token in inline code so the ticket passes markdownlint.
- Create `docs/announcements/v7.8.2.md`.
- Create `tests/test-customization-presets.sh`.
- Modify `tests/test-docs-audit.sh`.
- Modify `tests/test-readme-shape.sh`.
- Append five dated ADR entries to `design-docs/protocol-decisions.md`.
- No policy, procedure, or trigger change. The counts stay 26 policies, 16 procedures, and 59 triggers. The delivery ledger stays deferred per the store's existing convention.

## Acceptance Criteria

- AC-1: The eight preset files exist with the exact slugs.
  - Assertion: `tests/test-customization-presets.sh` checks each of the eight paths with `[ -f ]`.
- AC-2: Every preset carries the required section anchors: `## AI Workflow Configuration`, `**Workflow AI Directory**: /path/to/Simple-AI-Workflow`, `**User AI Directory**: [HOME]/.ai/`, `## Active Expertise`, `## Active Traits`, `## Required Compliance`, `## Design Docs`, `**Location**: design-docs/`, `## Merge Policy`, and `**Merge Mode**: auto`.
  - Assertion: the fixture greps every anchor in every preset, using `grep -F` for the bracket-containing anchor, and asserts `platform-engineer.md` has the plain `- linux-system-admin` bullet plus the MD044 disable comment.
- AC-3: Every preset's Active Expertise set matches the LLD mapping in the stated order.
  - Assertion: the fixture extracts each Active Expertise section and compares it to the expected bullet list.
- AC-4: Every preset has exactly one Active Traits bullet and it matches the mapped trait.
  - Assertion: the fixture counts the section bullets (one) and greps the trait name.
- AC-5: Compliance is pre-filled with soc2 and iso-27001 for the five named roles and is empty for web-developer, mobile-developer, and dba.
  - Assertion: the fixture asserts exact `^- soc2$` and `^- iso-27001$` lines for the five and neither line for the three.
- AC-6: The customization guide gains the three new trait definitions and a `## 11. Presets by Role` section naming all eight slugs, with the `linux-system-admin` token in inline code.
  - Assertion: the fixture greps the guide for each slug, the section heading, each new trait bullet, and the inline-code `linux-system-admin` token.
- AC-7: The workflow guide and the slide appendix name all three new traits, and the base template comment lists `coding-baseline` and lowercase `linux-system-admin` under a scoped MD044 disable.
  - Assertion: the fixture greps `docs/workflow-guide.md`, `docs/simple-ai-workflow-slides.md`, and `docs/ai-customization.md` for each expected string and the `markdownlint-disable-next-line MD044` directive.
- AC-8: The README names v7.8.2, links the presets, and the v7.8.2 announcement exists with the exact release URL.
  - Assertion: `tests/test-readme-shape.sh` and `tests/test-docs-audit.sh` assert the banner, the link, the announcement file, and the URL; the v7.8.1 existence and URL assertions stay.
- AC-9: Every new or changed markdown file passes markdownlint, and every new or changed shell file passes shellcheck.
  - Assertion: `markdownlint-cli2` on the changed markdown files, including `design-docs/protocol-decisions.md`, reports 0 issues, and `shellcheck` on `tests/test-customization-presets.sh`, `tests/test-docs-audit.sh`, and `tests/test-readme-shape.sh` reports 0.
- AC-10: The ADR store records the five decisions under exact dated headings.
  - Assertion: the fixture greps `design-docs/protocol-decisions.md` for `## 2026-11-26: Customization presets are full variants under docs/examples/customization-presets/`, `## 2026-11-26: Three traits join the catalog for the presets`, `## 2026-11-26: The preset slugs are the init preset identifiers`, `## 2026-11-26: Preset compliance is a suggestion, not a determination`, and `## 2026-11-26: Documentation-only additions ship as a PATCH`.
- AC-11: The protocol validator passes, the slide fixture passes after the rebuild, and the full suite passes with the new fixture.
  - Assertion: `bash support-files/validate-protocol.sh` reports 8/8, `bash tests/test-slides.sh` passes, and `bash tests/run-all.sh` reports every script passing (34 after this change).

## Verification

- `git symbolic-ref refs/remotes/origin/HEAD` shows `origin/master` before the branch work.
- `bash support-files/validate-protocol.sh` returns 8/8.
- `bash tests/test-customization-presets.sh` passes.
- `bash tests/test-docs-audit.sh` passes.
- `bash tests/test-readme-shape.sh` passes.
- `bash support-files/build-slides-html.sh` rebuilds the HTML deck, and `bash tests/test-slides.sh` passes.
- `bash tests/run-all.sh` passes all 34 scripts.
- `markdownlint-cli2 "docs/examples/customization-presets/*.md" docs/ai-customization-guide.md docs/workflow-guide.md docs/simple-ai-workflow-slides.md docs/ai-customization.md README.md docs/announcements/v7.8.2.md design-docs/protocol-decisions.md ai/plans/customization-presets-per-role.md ai/issues/open/customization-presets-per-role.md` reports 0 issues.
- `shellcheck tests/test-customization-presets.sh tests/test-docs-audit.sh tests/test-readme-shape.sh` reports 0.
- PowerShell fixtures are reported unrun when `pwsh` is absent. No PowerShell file changes here, so parity is unaffected.

## Peer Review Log

- Round 1: review-171, CHANGES REQUESTED. Fixed the default-branch target (`master`), the ADR store heading format, the slide appendix sweep, the customization-guide test target, the lint and shellcheck scope, the deferred-ledger citation, and the minor evidence and wording findings.
- Round 2: review-172, CHANGES REQUESTED. Fixed the HTML-comment MD044 remedy in `docs/ai-customization.md`, the guide section 11 inline-code tokens, the TDD citation, the duplicate ticket Delta, and the release draft order.
- Round 3: review-173, CHANGES REQUESTED. Fixed the Peer Review Log and the fixture coverage for AC-7 and AC-10.
- Round 4: review-174, APPROVED. No findings.
- Post-approval amendment: the user directed a conservative PATCH, so the release moved from v7.9.0 to v7.8.2 and ADR-5 was added. No behavior or test scope changed.

## Risks and Rollback

- Risk: a preset drifts from the ticket mapping. Mitigation: the fixture pins each expertise set and trait in order.
- Risk: the new traits conflict with an existing trait name or a persona file. Mitigation: the names are new; the guide, workflow guide, and slide appendix are updated together; the fixture greps all three.
- Risk: the banner change breaks the pinned README and docs tests. Mitigation: update both fixtures in the same branch, keep the v7.8.1 announcement file, and keep its URL assertion.
- Risk: the slide edit and HTML rebuild drift. Mitigation: rebuild with the build script and let `tests/test-slides.sh` compare the result.
- Risk: compliance pre-fill reads as a compliance claim. Mitigation: ADR-4 and the per-file comment state that it is a suggestion.
- Rollback: revert the squash commit on `master`, delete the local and remote `v7.8.2` tag, delete the GitHub Release if it was published, and restore the README banner. No state migration or data change is involved.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin` (GitHub: KamranAzeem/Simple-AI-Workflow).
- Base ref: `master`, the repository default branch (`origin/HEAD -> origin/master`).
- Baseline: commit the planning records as one chore commit on `master` before branching. The baseline path list is `ai/plans/customization-presets-per-role.md` and `ai/issues/open/customization-presets-per-role.md`. The implementation request plus this close sequence is the approval for that protected-branch baseline commit and for the actions named below.
- Branch: `feature/customization-presets`, created from `master` after the baseline commit.
- Ticket: `ai/issues/open/customization-presets-per-role.md`. Move it to `ai/issues/closed/` in the branch commit with the plan attached under `## Implementation Plan`, then delete the plan file.
- Merge mode: `direct`, resolved from `## Merge Policy` in `ai-customization.md`. Squash merge to `master`, delete the branch, and push.
- Release: v7.8.2, PATCH. Draft the announcement, the README banner, and the release-note body in a temp file first, show the exact drafts for the user's edits, then write the final announcement and banner on the branch. After the merge, create an annotated tag `v7.8.2` on `master`, push the tag, and publish the GitHub Release at `https://github.com/KamranAzeem/Simple-AI-Workflow/releases/tag/v7.8.2`.
- Evidence: record validator 8/8, suite 34/34, slide fixture pass, markdownlint 0, shellcheck 0, and the approving review number.
- Order: checkpoint on the branch before the commit. No post-merge commits and no post-merge repository changes except the annotated tag and the GitHub Release.
- Release documentation stays on the branch. The tag and GitHub Release happen after the merge.
