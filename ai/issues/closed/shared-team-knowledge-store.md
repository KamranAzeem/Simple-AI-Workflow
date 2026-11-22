Reported: 2026-11-20
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Add an optional shared team knowledge store that members publish to and the boot indexes

Description:

Origin.

- A customer asked whether team members can pool their accumulated AI knowledge at a central network location.
- The proposal is a uniform way to publish local global and project knowledge to a shared store, and to use that store as another just-in-time knowledge source when it is configured.

Scope.

- Publish side: select lessons from the global and project stores, scrub them, dedupe them, and contribute them in one uniform way.
- Consumption side: index the shared store at boot, read a file only when a task needs it, and report its source and age.
- Configuration: an opt-in setting, so an unconfigured machine behaves exactly as today.

Open questions.

- Store shape: one lesson per file with frontmatter, mirrored `global/` and `projects/` trees, or flat topic files.
- Identity and ownership: who authored a lesson, who may change it, and how a retired lesson is marked.
- Contribution protocol: direct write, inbox plus curation, pull request, or a publish CLI.
- Dedupe and conflict: content hash, normalized title, provenance, or review.
- Read precedence: project, then team, then personal global, or another order.
- Security: secrets, identifying names, access groups, and encryption at rest.
- Offline behaviour: cache, queue, and a clean degrade when the store is unreachable.
- Size and count limits at boot, and whether the store obeys the knowledge file standards.

Constraints.

- No new runtime dependency at boot; the AI does the indexing with built-in tools.
- The store is optional and never blocks the load.
- The existing global and project stores keep their meaning; the shared store is a third scope with its own precedence.

Full brainstorm, 2026-11-20.

Transport.

- Internal Git repo, one per team or one per company.
- NFS mount, read-only for consumers.
- SMB or Windows file share.
- Synced folder: OneDrive, Nextcloud, or Syncthing.
- Object storage plus a small CLI.
- Read-only mirror served by an MCP or search service.
- Existing wiki or Confluence as the source of truth, exported to markdown.

Store shape.

- Mirror the current model: `global/` plus `projects/<name>/`.
- Flat topic files, six-segment names, no folders.
- Domain folders with an index per domain.
- Inbox plus curated area, two zones.
- One lesson per file with frontmatter: id, owner, source, date, tags, confidence.
- Manifest with checksums and a generated index.
- Markdown only, attachments by link.

Contribution.

- A `knowledge publish` procedure: classify, scrub, dedupe, contribute.
- Pull request with a checklist and one reviewer.
- A small CLI that validates frontmatter and opens a pull request.
- Copy into a synced inbox, curation later.
- Auto-export new local lessons at checkpoint, queued for review.
- Branch per contributor, squash on approval.
- Direct write with a lock file, for a small trusted team.

Consumption.

- One config key in `ai-customization.md` naming the store path or URL.
- Clone or mount under a configured path, read-only.
- Boot builds a JIT index from filenames and headers only.
- Search on demand with the built-in search, load one file at a time.
- Precedence: project, then team, then personal global.
- Tag filter so only relevant domains are indexed.
- Staleness flag by commit date, as the current knowledge layers do.
- Graceful degrade when the store is unreachable.

Governance.

- Scrub secrets and identifying names before publish.
- Provenance: author, source project, date, supersession link.
- Content-hash and normalized-title dedupe at publish.
- Owner per lesson, retire with a tombstone, never delete silently.
- Access groups per team, read-only for most consumers.
- Retention and license review for exported material.

Shortlist.

- Git-backed team repo with a `knowledge publish` procedure: review, history, provenance, and conflict handling with no new service. The clone is read-only at boot.
- Network share with inbox and curated zones: no Git skill needed, weakest conflict handling, best for mixed teams.
- Synced folder with a strict layout and manifest: simplest across operating systems, sync conflicts are the risk.
- Read-only mirror plus MCP or search service: scales to a large organization, heaviest to build and operate.

What shapes the choice.

- Whether the team already uses Git.
- Whether contribution needs review before it is visible.
- Whether the store must work offline.
- Who owns a shared lesson after the author leaves.
- Whether project names may appear in shared lessons.

Recommended first shape.

- The Git-backed repository, because it gives review, provenance, history, and conflict handling with no new service.
- Use the network-share variant when the team does not use Git.

Next step.

- Grill the open questions, then write a plan.

---

2026-11-20

Recorded the full brainstorm set from the design discussion, including all transport, shape, contribution, consumption, and governance options. No decisions are final; the open questions and a grilling round come next.

---

2026-11-22

Grilling complete. Plan written: `ai/plans/team-knowledge-store.md`. Decisions: Git with a publish PR and one reviewer; flat `lessons/` with the filename as id; frontmatter; Class A names with secrets removed; filename-only boot index that degrades; owner plus tombstones; hash plus title plus review dedupe; 10 KB soft, 15 KB split review, 100-file threshold; precedence project, team, global; procedure-loaded policy. Peer review pending. Team skills deferred to a separate ticket.

---

2026-11-22

Closed. Implemented on `feature/team-knowledge-store` and released as v7.1.0. The full suite, protocol validator, authoring validator, markdownlint, and shellcheck pass. Review-79 APPROVED.

## Implementation Plan: Team Knowledge Store

Ticket: `ai/issues/closed/shared-team-knowledge-store.md`
Date: 2026-11-22
Status: Implemented and closed

## Evidence

Sources read in full this session, with line counts:

- `ai/issues/open/shared-team-knowledge-store.md`: 120 lines.
- `ai/policies/ai-policy-common.md`: 692 lines.
- `ai/policies/ai-policy-knowledge.md`: 168 lines.
- `ai/policies/ai-policy-outbound-content-scrub.md`: 94 lines.
- `ai/policies/ai-policy-issue-management.md`: 119 lines.
- `ai/policies/ai-policy-design-docs.md`: 171 lines.
- `ai/policies/ai-policy-thinking-modes.md`: 51 lines.
- `ai/policies/ai-policy-meta.md`: 208 lines.
- `ai/procedures/load-context.md`: 104 lines.
- `ai-customization.md`: 40 lines.
- `/home/kamran/.ai/settings/global-user-settings.md`: 106 lines.
- `design-docs/protocol-decisions.md`: 1218 lines.
- `docs/ai-customization-guide.md`: 255 lines.
- `support-files/validate-protocol.sh`: 443 lines.
- `tests/run-all.sh`: 39 lines.
- `ai/shared/project-knowledge/local-first-knowledge-retrieval-proposal.md`: 34 lines.
- `ai/shared/project-knowledge/global-vocabulary-and-storage-roots.md`: 26 lines.

Confirmed facts:

- The scrub contract defines Class A as internal or same-audience and keeps customer names; secrets are removed in every class (`ai-policy-outbound-content-scrub.md` lines 31-39).
- The global settings names list is user-space configuration. It is never copied into a repository (settings lines 91-106).
- The knowledge policy treats person, client, employer, and customer names as identifying, and it exempts neither team nor global (knowledge policy lines 62-98).
- The skills model has two roots, global and project (protocol decision 2026-11-09). A third scope is a new change.
- The scrub policy is procedure-loaded. The publish procedure can load it explicitly.
- The `AGENTS.md` Policy Loading Set allows only the common policy, Active Expertise, and project policies at context loading. The plan amends it for the configured team index.
- The common policy `## Knowledge Invariant` names the global and project stores. The plan adds a clause for the configured team store.
- The release practices require an announcement, a README banner, a docs sweep, and a release-practices entry.
- `ai-customization.md` has no `## Merge Policy`, so the default is `auto`, which behaves as `direct`.
- The current branch is `master`; the remote is `git@github.com:KamranAzeem/Simple-AI-Workflow.git`.
- The current counts are 24 policies, 15 procedures, 50 triggers, and 27 test scripts.
- The policy floor is 24 (`validate-protocol.sh` line 362).
- `AGENTS.md` is 146 lines, below the 160-line target.

Grilling decisions, 2026-11-22:

- Transport: Git, because the team already uses it.
- Contribution: a publish procedure that opens a PR; one reviewer required; the reviewer merges.
- Layout: flat `lessons/` with one file per lesson; the filename is the id.
- Frontmatter: title, owner, source_project, created, updated, tags, status, superseded_by.
- Body: the knowledge sections, with no local header literal.
- Precedence: project, then team, then personal global.
- Access: Class A. Names and infrastructure detail stay; secrets never. The local sensitive-names list stays local.
- Offline: index the cached clone; report `[PENDING]` and continue when it is unreachable.
- Ownership: owner plus tombstones.
- Dedupe: content hash plus normalized title plus review.
- Limits: 10 KB soft, 15 KB split review, 100-file review threshold per team store.
- Protocol home: a new team policy plus a publish procedure.
- Policy loading: procedure-loaded, only when the store is configured.

No open questions remain for this ticket. Team skills are deferred to a separate ticket.

## HLD

### Components

1. **Configuration keys** under `## AI Workflow Configuration` in `ai-customization.md`.
   - `**Team AI Knowledge Directory**`: the read-only local clone or mount path. Optional.
   - `**Team AI Knowledge Repository**`: the publish remote URL or path. Optional; publish falls back to the clone's origin.
2. **New policy** `ai-policy-team-knowledge.md`.
   - Owns the third scope, the store shape, the frontmatter, the precedence, the Class A rule, the ownership and retirement, the limits, and the no-block behavior.
   - Declares `Mode: procedure` with `Load in: knowledge-publish`.
   - References the knowledge standard for the body sections. It does not restate the standards.
3. **New procedure** `ai/procedures/knowledge-publish.md`.
   - Triggers: `update team knowledge`, `publish team knowledge`, `publish to team knowledge`.
   - Steps: load the policy, resolve the scope, classify and scrub, dedupe, write the lesson, open the PR, report.
   - It never merges.
4. **Load-context changes** in `ai/procedures/load-context.md`.
   - Add `STEP-TEAM-KNOWLEDGE-INDEX` after `STEP-KNOWLEDGE-INDEXING`.
   - Add the configured team store to the discovery roots.
   - Add `ITEM TEAM-KNOWLEDGE-INDEX` to the proof.
   - Load the team policy only when the key is present and readable, under the amended Policy Loading Set.
5. **`AGENTS.md` anchors and loading amendment**.
   - Add `**Team AI Knowledge Directory**` and `**Team AI Knowledge Repository**` to TIER CONFIGURATION.
   - Both resolve from the **Project Customization File** at boot when present.
   - Amend the Policy Loading Set in TIER READ-FIRST-RULES to allow the configured team index step to load the team policy.
   - Update the `CONFIG_KEYS` list in `support-files/validate-protocol.sh` with both keys.
6. **Knowledge policy cross-reference and common invariant**.
   - Add one pointer in `ai-policy-knowledge.md` that the team store is a third scope owned by the team policy.
   - Do not restate the team rules.
   - Add one clause to the common policy `## Knowledge Invariant` that a configured team store is indexed at boot. Name the anchor, not a policy file.
7. **Docs, ADR, tests, release**.
   - `docs/ai-customization-guide.md` documents the keys, the Class A rule, and the local sensitive-names boundary.
   - `docs/announcements/v7.1.0.md`, the README banner, and the `docs/` sweep ship the release.
   - `design-docs/protocol-decisions.md` gains the ADR entries.
   - `ai/shared/project-knowledge/release-practices.md` gains the `### v7.1.0 (date)` section.
   - Tests pin the behavior.

### Boundaries

- The team store is a separate Git repository or mount outside the project.
- The boot reads it read-only and never clones, pulls, writes, or authenticates.
- The store is optional. An unconfigured project behaves exactly as today.
- The existing global and project stores keep their meaning.
- The local sensitive-names list is never applied to team lessons by the protocol.
- Team skills are out of scope. The same repository may host `skills/` later.

### Data flow

- **Publish**: user names a local lesson, the procedure classifies it as Class A, removes secrets, writes the frontmatter, computes the hash, checks the team store for duplicates, creates a branch, and opens a PR.
- **Boot**: read the key, test the path, load the policy, index the filenames only, report the count. A missing or unreadable path reports `[PENDING]` and the load continues.
- **Task start**: match the task keywords to the team index; read a matching lesson in full; apply precedence project, then team, then global.

## LLD with Acceptance Criteria

### Configuration

- Read both keys from the `## AI Workflow Configuration` section of `ai-customization.md`.
- Read `**Team AI Knowledge Directory**` from that section.
- Read `**Team AI Knowledge Repository**` from the same section.
- Expand `~` and `[HOME]` in the directory.
- Treat an absent directory key as not configured.
- Treat an absent repository key as the local clone's `origin`.
- Do not write either key; the user sets them.

### Store shape

- The team creates the repository and its `README.md` and `CONTRIBUTING.md`. The protocol does not scaffold the store.
- Lessons: `lessons/<lesson-name>.md`, flat.
- The filename is the id. It uses lowercase kebab case with six or fewer hyphen-separated segments.
- A rename changes the id. The reviewer must reject a rename that breaks references.
- A retired lesson stays in `lessons/` with `status: retired` and `superseded_by: <filename>`.

### Frontmatter

```yaml
---
title: <one line>
owner: <git author name>
source_project: <project name or approved slug>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
tags: [<tag>, <tag>]
status: active
superseded_by:
---
```

- `status` accepts `active` or `retired`.
- `superseded_by` is empty for an active lesson.
- Omit a confidence field. The reviewer supplies judgment.

### Body

- One H1.
- `## Context`, `## Rule or Fix`, `## Why`, `## Verify`.
- Optional `## Caveats`.
- No local knowledge header literal.
- No tables. No session bookkeeping.

### Precedence

- Project knowledge, then team knowledge, then personal global knowledge.
- A task reads every matching file at task start.
- A conflict is reported, not silently resolved.

### Publish procedure steps

1. `STEP-LOAD-TEAM-POLICY`: load `ai-policy-team-knowledge.md` and report it active; stop when the directory key is absent.
2. `STEP-RESOLVE-PUBLISH-SCOPE`: read the lesson name or names; default to the session's lesson.
3. `STEP-CLASSIFY-AND-SCRUB`: load `ai-policy-outbound-content-scrub.md` and apply `### Destination Classes`; state Class A; remove secrets; keep names; do not apply the local sensitive-names list.
4. `STEP-DEDUPE`: normalize the body, compute the SHA-256 hash, compare hashes, then compare normalized titles.
5. `STEP-WRITE-LESSON`: write the frontmatter and body in `lessons/` in the configured team directory on a new branch.
6. `STEP-OPEN-PR`: push the branch to the configured repository or the clone's `origin`, open a PR with `gh` or `glab`, or give the compare URL; never merge.
7. `STEP-REPORT-PUBLISH`: report the lesson path, the branch, the PR, and the duplicate result.

### Boot behavior

- `STEP-TEAM-KNOWLEDGE-INDEX` runs after `STEP-KNOWLEDGE-INDEXING`.
- When the key is absent, `ITEM TEAM-KNOWLEDGE-INDEX` reports `[PASSED] none`.
- When the key is present and readable, index filenames, paths, and apparent domains only.
- When the key is present and missing or unreadable, report `[PENDING]` with the reason and continue.
- Bound the index at 16 KB; when over, report counts and query on demand.
- Never read lesson content at boot.

### Errors

- Malformed frontmatter: report the file, skip it, and continue.
- Unknown status: report the file, skip it, and continue.
- Duplicate hash: stop the publish and report the existing lesson.
- Near-duplicate title: stop and ask the reviewer.
- Remote unreachable or unauthenticated: stop the publish and report; never force.

### Limits

- 10 KB per lesson is a soft target.
- 15 KB triggers a split review; the lesson is never split automatically.
- 100 files per team store is the review threshold; report the count.
- The boot index is bounded at 16 KB.

### Acceptance criteria

- **AC-001**: An unconfigured project behaves exactly as today; no team scan runs and the proof reports none.
- **AC-002**: A configured readable store indexes filenames only; no lesson content is read at boot.
- **AC-003**: A configured missing or unreadable store reports `[PENDING]` and the load continues.
- **AC-004**: Precedence project, team, global is documented and applied at task start.
- **AC-005**: Publish runs only on its trigger; it states Class A, removes secrets, and keeps names.
- **AC-006**: Publish blocks an exact hash duplicate and asks on a near-duplicate title.
- **AC-007**: The filename is the id; the frontmatter fields and body sections are enforced; retirement is in place with a tombstone.
- **AC-008**: Publish opens a PR and the session never merges it.
- **AC-009**: The 10 KB, 15 KB, 100-file, and 16 KB limits are stated and tested.
- **AC-010**: The team policy loads only when configured, in the boot index step and the publish procedure.
- **AC-011**: The validators pass with policy floor 25, procedure count 16, and no trigger conflict.
- **AC-012**: The docs and the ADR record the keys, Class A, the local sensitive-names boundary, and the deferred team skills.
- **AC-013**: The common policy `## Knowledge Invariant` names the configured team store, without naming a policy file.
- **AC-014**: The Policy Loading Set permits the configured team index step to load the team policy, and the validator checks both configuration keys.
- **AC-015**: The release ships `docs/announcements/v7.1.0.md`, the README banner, the docs sweep, and the release-practices entry.

## ADRs

### ADR-001: The third scope is Team Knowledge

- **Decision**: Name the third scope `Team Knowledge`, with `Team AI Knowledge Directory` and `Team AI Knowledge Repository`.
- **Context**: "Global" already carries two owners, and a third global meaning would repeat the earlier trap.
- **Consequences**: The vocabulary stays distinct. No new global root.

### ADR-002: Git plus a publish PR with one reviewer

- **Decision**: The store is a Git repository. Publish opens a PR. One reviewer merges.
- **Context**: The team uses Git, and shared lessons need review, history, and provenance.
- **Consequences**: Review and conflict handling come from Git. A non-Git team needs the deferred share variant.

### ADR-003: Flat lessons, filename as id

- **Decision**: One file per lesson in `lessons/`; the filename is the id; frontmatter holds provenance.
- **Context**: The filename is the only boot index key, and the local knowledge standard already uses flat files.
- **Consequences**: Lookup is simple. A rename breaks references and needs review.

### ADR-004: Class A names, secrets removed

- **Decision**: Team lessons are Class A. Names and infrastructure detail stay; secrets never. The local sensitive-names list is not applied.
- **Context**: The team shares access, NDA, and company, so names are needed to identify the customer. The list is personal configuration.
- **Consequences**: Repo access is the privacy control. The publish procedure states the audience. A mixed-audience store needs a policy change.

### ADR-005: Filename-only boot index that degrades

- **Decision**: Index filenames only and report `[PENDING]` when the store is unreachable.
- **Context**: Boot must stay offline, bounded, and never blocking.
- **Consequences**: No lesson content at boot. A stale clone is reported by age, not refreshed.

### ADR-006: Precedence project, team, global

- **Decision**: Project wins, then team, then personal global.
- **Context**: Project facts are authoritative for the project; the team store is curated and shared; personal global is the fallback.
- **Consequences**: A team lesson overrides a personal global lesson. A conflict with a project lesson is reported.

### ADR-007: The team policy is procedure-loaded, with one named boot path

- **Decision**: `ai-policy-team-knowledge.md` declares `Mode: procedure` with `Load in: knowledge-publish`. The configured boot index step also loads it explicitly. The Policy Loading Set in `AGENTS.md` is amended to allow that one load.
- **Context**: Most projects will not configure a team store, so an always-on policy costs context for nothing. The Level 0 loading set would otherwise block the boot load.
- **Consequences**: The publish procedure and the configured boot index step load it. No other boot load is allowed.

### ADR-008: Team skills are deferred

- **Decision**: Do not add a team skills root in this change.
- **Context**: A team skill is a third skills scope with its own trust and collision rules. Bundling it breaks the one-unit rule.
- **Consequences**: File a separate ticket. The team repository can host `skills/` later.

### ADR-009: The common Knowledge Invariant names the third store

- **Decision**: Add one clause to `ai-policy-common.md` `## Knowledge Invariant` that a configured team store is indexed at boot.
- **Context**: The invariant is the always-on authority for the boot index. A third store outside it is invisible to a fresh reader.
- **Consequences**: The common policy names the anchor, not a policy file. The team policy keeps the store detail.

## Risks and Gaps

- **RSK-001**: A misconfigured access group leaks names. Mitigation: the reviewer gate, repo permissions, and a stated audience before publish.
- **RSK-002**: A stale clone serves stale lessons. Mitigation: commit-date age, a manual pull, and a proof warning.
- **RSK-003**: A 100-file store stretches the boot index. Mitigation: the 16 KB bound and on-demand queries.
- **RSK-004**: A paraphrase evades the hash. Mitigation: normalized-title comparison plus the reviewer.
- **RSK-005**: A team lesson conflicts with a project lesson. Mitigation: precedence and a task-start conflict report.
- **RSK-006**: No `gh` or `glab` is installed. Mitigation: the compare URL fallback used by `IMPLEMENT-PLAN`.
- **RSK-007**: The store becomes a dumping ground. Mitigation: the 100-file review threshold and the publish checklist.

## Test Plan

Write the failing test first: `tests/test-team-knowledge.sh`.

The boot index is AI-driven and ephemeral, so a shell test cannot observe it. The test pins the instructions, the module shapes, and the fixture layout. AC-002 and AC-003 are verified by a manual load with a fixture store.

- Policy shape: title, guard, markers, purpose, Scope, References, `Mode: procedure`, `Load in: knowledge-publish`.
- Procedure shape: H1, three triggers, every step name.
- Trigger uniqueness: no duplicate or containment; the expected total is 53.
- `AGENTS.md`: both keys present; the Policy Loading Set amendment present; the file stays under 160 lines.
- Common policy: the `## Knowledge Invariant` names the configured team store.
- `load-context.md`: `STEP-TEAM-KNOWLEDGE-INDEX` and `ITEM TEAM-KNOWLEDGE-INDEX` present; the step text says filenames only and names the `[PENDING]` behavior.
- Fixture store: two lessons with valid frontmatter and a missing-path case. The test checks the fixture layout only, not the AI proof.
- Docs: both keys under `## AI Workflow Configuration`, the Class A note, the announcement, and the README banner.
- Validator: `POLICY_FLOOR=25`, and `CONFIG_KEYS` contains both keys.

Extend existing tests:

- `tests/test-policy-load-paths.sh`: the new policy's mode and load-in.
- The reference test: the new anchors and the new procedure link.
- `tests/run-all.sh` is unchanged; it discovers the new script.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/team-knowledge-store`, created at implementation.
- **Merge mode**: direct, because `ai-customization.md` has no `## Merge Policy`; squash merge, delete the branch, push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Ticket**: `ai/issues/open/shared-team-knowledge-store.md` moves to `ai/issues/closed/` in the branch commit.
- **Plan attachment**: attach this plan under `## Implementation Plan` before deleting the plan file.
- **Checkpoint**: run on the branch before the commit.
- **Release**: proposed minor `v7.1.0`, confirmed against the latest tag at implementation. Ship `docs/announcements/v7.1.0.md`, the README banner, the `docs/` sweep, and the `### v7.1.0 (date)` entry in `ai/shared/project-knowledge/release-practices.md`. Tag after the merge and publish the GitHub Release.
- **Evidence**: `tests/run-all.sh`, `support-files/validate-protocol.sh`, `support-files/validate-policy-authoring.sh`, markdownlint on the new docs, and shellcheck.
- **Post-merge**: no commits and no repository changes.

## Peer Review Log

- Round 1: CHANGES REQUESTED, `ai/code-review-reports/2026-11-22_02-07_review-75.md`; 6 Majors and 5 Minors fixed.
- Round 2: APPROVED, `ai/code-review-reports/2026-11-22_02-08_review-76.md`; no Critical, Major, or Minor; one optional validator-anchor suggestion.
- Implementation review round 1: CHANGES REQUESTED, `ai/code-review-reports/2026-11-22_18-56_review-77.md`; 2 Majors and 3 Minors fixed.
- Implementation review round 2: APPROVED, `ai/code-review-reports/2026-11-22_18-58_review-78.md`.
- Trigger rename review: APPROVED, `ai/code-review-reports/2026-11-22_19-03_review-79.md`.
