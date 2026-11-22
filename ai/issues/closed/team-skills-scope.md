Reported: 2026-11-22
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Add an optional team skills scope served from the configured team knowledge store

Description:

Origin.

- A team member develops a skill, the team finds it useful, and everyone wants it without maintaining a local copy.
- The team knowledge store already provides a shared, access-gated Git repository with review as the control.

Scope.

- When the team knowledge store is configured, scan its `skills/` directory as a third skills root.
- Index name, description, path, and scope at boot; read no skill body at boot.
- Activate by `use skill <name>` or a single best description match, the same as today.
- Precedence: project skill, then team skill, then global workflow skill.
- Report a team override and a cross-type collision.

Constraints.

- Reuse the team knowledge store repository and its two configuration keys; add no transport.
- The scope is optional and never blocks the load.
- No new runtime dependency; the boot uses built-in tools.
- A skill cannot override `AGENTS.md`, a policy, the user, or the customization file.
- A helper never runs without explicit approval and stays inside the package.
- The user is responsible for the source of a team skill.

Open questions.

- Trust and review: does a team skill need the same one-reviewer PR gate as a lesson, especially when it ships helper scripts?
- Boot cost: how much does a third skills index add, and what is its bound?
- Collision: confirm the default precedence project, team, global.
- Versioning: how is a team skill updated or retired, and is there a tombstone?
- Helpers: may a team skill ship scripts, and what is the execution rule?
- Matching: does description-based auto-match apply to team skills?
- User scope: if a personal skills root ever lands, where does it sit in precedence?

Dependency.

- Resolved: the team knowledge store shipped in v7.1.0 and its ticket is closed.
- The store's ADR-008 reserved `skills/` for this work.

Next step.

- Grill the open questions, then write a plan.

---

2026-11-22

Filed from the team knowledge store grilling. Grilling complete over two rounds; the plan is APPROVED after review-80 and implemented on `feature/team-skills-scope`; review-81 APPROVED. Plan attached below.

---

2026-11-22

Implemented on `feature/team-skills-scope`; review-81 APPROVED; plan attached below.

---

2026-11-22

Closed. Implemented on `feature/team-skills-scope`; review-81 APPROVED; merge, tag, and release await approval.

## Implementation Plan: Team Skills Scope

Ticket: `ai/issues/closed/team-skills-scope.md`
Date: 2026-11-22
Status: Implemented; review-81 APPROVED; merge pending

## Evidence

Sources read in full this session, with line counts:

- `ai/issues/open/team-skills-scope.md`: 57 lines.
- `ai/policies/ai-policy-common.md`: 693 lines.
- `ai/procedures/load-context.md`: 111 lines.
- `ai/policies/ai-policy-team-knowledge.md`: 130 lines.
- `ai/policies/ai-policy-thinking-modes.md`: 51 lines.
- `ai/policies/ai-policy-outbound-content-scrub.md`: 94 lines.
- `ai/policies/ai-policy-issue-management.md`: 119 lines.
- `ai/policies/ai-policy-design-docs.md`: 171 lines.
- `ai/policies/ai-policy-meta.md`: 208 lines.
- `ai/policies/ai-policy-knowledge.md`: 170 lines.
- `ai/policies/ai-policy-code-review.md`: 131 lines.
- `ai/procedures/manage-issues.md`: 17 lines.
- `ai/procedures/post-compaction-recovery.md`: 25 lines.
- `ai/procedures/repair-knowledge-files.md`: 25 lines.
- `ai/procedures/write-checkpoint.md`: 75 lines.
- `AGENTS.md`: 149 lines.
- `ai-customization.md`: 40 lines.
- `docs/workflow-guide.md`: 512 lines.
- `docs/ai-customization-guide.md`: 268 lines.
- `docs/ai-customization.md`: 89 lines.
- `docs/simple-ai-workflow-slides.md`: 495 lines.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`: 204 lines.
- `README.md`: 476 lines.
- `tests/test-skills-index.sh`: 122 lines.
- `tests/test-team-knowledge.sh`: 185 lines.
- `tests/test-policy-load-paths.sh`: 228 lines.
- `tests/test-protocol-references.sh`: 160 lines.
- `tests/test-global-settings-repair-fixture.sh`: 141 lines.
- `tests/test-agents-md-shape.sh`: 40 lines.
- `tests/test-trigger-rules.sh`: 313 lines.
- `tests/test-load-context-boot.sh`: 88 lines.
- `tests/run-all.sh`: 39 lines.
- `support-files/validate-protocol.sh`: 449 lines.
- `support-files/validate-policy-authoring.sh`: 750 lines.
- `design-docs/protocol-decisions.md`: 1290 lines.
- `ai/shared/project-knowledge/release-practices.md`: 192 lines.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: 71 lines.
- `ai/shared/project-knowledge/trigger-phrase-naming.md`: 23 lines.
- `ai/shared/project-knowledge/global-vocabulary-and-storage-roots.md`: 26 lines.

Confirmed facts:

- The skills model has two roots, one package shape, a 200-character description, a 16 KB index, no body at boot, project over global, and cross-type collision reporting (`ai-policy-common.md` `## Skills`; `load-context.md` `STEP-SKILLS-INDEX`).
- The team store shipped in v7.1.0 with **Team AI Knowledge Directory** and **Team AI Knowledge Repository**. Its ADR-008 reserved `skills/` for this work.
- The team knowledge policy is lessons-only. Its `## Store Shape` says one lesson per file under `lessons/`.
- `STEP-SKILLS-INDEX` runs inside load-context step 7, before `STEP-TEAM-KNOWLEDGE-INDEX` in step 8. Step 0 reads the team keys.
- `ITEM SKILLS-INDEX` reports the skills count and any override or collision.
- The protocol cannot verify the team repository's review at boot without network and authentication.
- The current counts are 25 policies, 16 procedures, 53 triggers, 28 test scripts, and policy floor 25.
- The latest tag is v7.1.0; the next minor is v7.2.0.
- The ticket's dependency line still points at the closed team store ticket (`team-skills-scope.md` lines 46-47); this plan corrects it.
- The skills fixture is a temp-directory simulation with `discover` and `build_index`; a team root extends the same pattern.
- The docs sweep locations are `AGENTS.md:106`, `README.md:254`, `README.md:428`, `docs/ai-customization-guide.md:203`, `docs/workflow-guide.md:468`, `docs/simple-ai-workflow-slides.md:308`, `ai/procedures/post-compaction-recovery.md:19`, `ai/procedures/write-checkpoint.md:72`, `ai/procedures/repair-knowledge-files.md:9`, `ai/shared/project-knowledge/global-vocabulary-and-storage-roots.md:19`, and the skills-fixture line in `protocol-verification-toolchain.md`.
- The existing "two roots" wording would become false; the docs sweep must remove it.

Grilling decisions, 2026-11-22:

- Rules home: the common policy `## Skills` section owns the rules; the team policy gains one `skills/` pointer.
- Contribution: read-only consumption; a short manual copy-and-PR note; no publish trigger.
- Trust: one-reviewer PR and repository access are the boundary, documented as an assumption; no boot verification.
- Precedence: project, then team, then global; report the override.
- Activation: the same `use skill <name>` or single best description match; announce the team source; load the body only; a helper needs explicit approval.
- Boot bound: one combined three-root index at 16 KB; over-bound prints per-root counts and queries on demand.
- Retirement: remove the package in a reviewed PR; Git history is the record; no tombstone.
- Personal root: deferred; the current order stays project, team, global.
- Release: minor v7.2.0.

No open questions remain for this ticket.

## HLD

### Components

1. **Common policy Skills clause** in `ai/policies/ai-policy-common.md`.
   - Add the configured team root to the resolution rule: `<Team AI Knowledge Directory>/skills/`.
   - Replace the project-over-global rule with the three-level precedence: a project skill, then a team skill, then a global skill; report the override.
   - Name the anchor, not a policy file.
2. **Team policy pointer** in `ai/policies/ai-policy-team-knowledge.md`.
   - Add one `## Store Shape` bullet: the repository may host `skills/`; the common Skills section owns the package rules.
3. **Boot wiring**.
   - `load-context.md` `STEP-SKILLS-INDEX`: index both local roots and the configured team root; read no body; read the team key from the customization; skip an unconfigured root; report `[PENDING]` when the configured team store is missing or unreadable; keep the combined index at 16 KB.
   - `ITEM SKILLS-INDEX`: report the project, team, and global counts and any override or collision; `[PENDING]` with the reason for an unreadable configured team root.
   - `AGENTS.md` shared step line 106: change "from both skill roots" to "from both local roots and the configured team root".
   - `post-compaction-recovery.md` step 4 and `write-checkpoint.md` step 9: change "the two skills roots" to the three-root wording.
   - `repair-knowledge-files.md` boundary: change "under `ai/skills/`" to "under any skills root".
4. **Docs and knowledge**.
   - `docs/workflow-guide.md` Section 24: rename "The two directories" to "The roots", add the team root, and add the team skills paragraph: trust, precedence, activation, contribution, retirement.
   - `docs/ai-customization-guide.md` skills section: add the team root and the manual contribution note.
   - `README.md` lines 254 and 428: add the team root and the three-level precedence.
   - `docs/simple-ai-workflow-slides.md` line 308: add the team root to the skills slide.
   - `global-vocabulary-and-storage-roots.md`: replace the two-root statement with the three-root model and the deferred personal root.
   - `protocol-verification-toolchain.md`: change the skills-fixture line from two roots to three and add the team override.
5. **Tests and validator**.
   - Extend `tests/test-skills-index.sh` with a team root, the three-level override, the team source, the no-body canary, and the 16 KB bound.
   - Add `require_in` checks for the common clause, the team pointer, the load-context team root, the AGENTS step line, the post-compaction and checkpoint wording, and the repair boundary.
   - Add `support-files/validate-protocol.sh` anchors for the common clause, the team pointer, and the load-context team root.
   - No new policy, procedure, or trigger; counts stay 25 policies, 16 procedures, 53 triggers, 28 test scripts.
6. **Release v7.2.0**.
   - `docs/announcements/v7.2.0.md`, the README banner, the `### v7.2.0 (date)` release-practices entry, and the docs sweep.

### Boundaries

- Read-only consumption. Contribution uses the team repository's normal Git and PR flow.
- No new configuration key, anchor, policy, procedure, or trigger.
- No network, clone, pull, write, or authentication at boot.
- The team repository's one-reviewer PR gate and access control are the trust boundary; the protocol does not verify review.
- No personal skills root. The current order stays project, team, global.
- Team lessons and team skills are separate indexes.
- No team skills file-count threshold; the combined 16 KB index bound is the boot cost control.
- Team skills cannot override `AGENTS.md`, a policy, the user, or the customization file.

### Data flow

- **Boot**: step 0 reads the team keys; step 7 indexes `<team>/skills/` when the key is present and readable; no body; `[PENDING]` when the configured path is missing or unreadable; `ITEM SKILLS-INDEX` reports the counts.
- **Activation**: match the description or `use skill <name>`; apply project, then team, then global; announce the source; load the body only; a helper needs explicit approval.
- **Contribution**: copy the package into `skills/`, open a PR, one reviewer merges.
- **Retirement**: delete the package in a reviewed PR; Git history is the record.

## LLD with Acceptance Criteria

### Configuration and root

- Reuse **Team AI Knowledge Directory** and **Team AI Knowledge Repository**.
- Add no key, no anchor, and no transport.
- Expand `~` and `[HOME]` in the directory.
- Treat an absent directory key as not configured.
- Read the team skills root at `<Team AI Knowledge Directory>/skills/`.
- Use one level: `skills/<name>/SKILL.md`.
- Keep the same frontmatter: `name`, a one-line `description` of at most 200 characters, and a lowercase-kebab directory name that matches `name`.
- Skip and report a hidden package, a symlink, a missing `SKILL.md`, a missing name, a missing description, a name mismatch, a bad directory name, and a description over 200 characters.
- Read no body at boot.
- Report none for a readable store with no `skills/` directory.
- Report `[PENDING]` with the reason when the configured store is missing or unreadable.

### Precedence and activation

- Apply project, then team, then global.
- Report a project override of a team skill, a team override of a global skill, and a cross-type collision with a policy or procedure name.
- Activate by `use skill <name>` or a single best description match.
- Announce the skill and the team source.
- Load the body only for the task.
- Run no helper without explicit approval; a helper stays inside the package.

### Boot and proof

- Index the team root inside `STEP-SKILLS-INDEX`.
- Keep the combined three-root index at 16 KB; when over, print per-root counts and query on demand.
- Report the project, team, and global counts in `ITEM SKILLS-INDEX`.
- Report the override and collision in `ITEM SKILLS-INDEX`.
- Report `[PENDING]` with the reason for an unreadable configured team root.
- Keep `ITEM TEAM-KNOWLEDGE-INDEX` for lessons only.

### Trust

- State that the team repository's one-reviewer PR gate and access control are the boundary.
- Treat the local clone as the user's trusted working copy; the review gate governs what enters the shared remote.
- Do not verify review at boot.
- Keep the user responsible for the source of every skill.
- Ban secrets in every skill and helper.

### Retirement and contribution

- Retire by removing the package in a reviewed PR; no tombstone and no extra field.
- Contribute by copying the package into `skills/` and opening a PR; one reviewer merges.
- Add no publish trigger.

### Docs and release

- Update the workflow guide, the customization guide, the README, the slides, and the two project knowledge notes.
- Add the v7.2.0 announcement, the README banner, and the release-practices entry.
- Run the docs sweep and remove every "two roots" or "both skill roots" phrase.

### Proposed wording

Common policy, `## Skills`:

- Replace "Resolve a skill from the **Global AI Skills Directory** or the **Project AI Skills Directory**." with "Resolve a skill from the **Global AI Skills Directory**, the **Project AI Skills Directory**, or the configured **Team AI Knowledge Directory** `skills/` root."
- Replace the project-over-global override rule with "Apply the precedence project, then team, then global." and keep "Report the override."

Team policy, `## Store Shape`:

- Add "Allow a `skills/` directory for team skill packages; the common Skills section owns the package rules."

Load context, `STEP-SKILLS-INDEX`:

- Replace "from both skill roots" with "from both local skill roots and the configured team skills root".
- Add "Read **Team AI Knowledge Directory** from the **Project Customization File**; skip the team root when the key is absent; report `[PENDING]` with the reason when the configured store is missing or unreadable; keep the combined index within 16 KB."

Load context, `ITEM SKILLS-INDEX`:

- Add the project, team, and global counts and any override or collision; report `[PENDING]` with the reason for an unreadable configured team root.

AGENTS.md shared step:

- Change "from both skill roots" to "from both local skill roots and the configured team root".

Post-compaction and checkpoint:

- Change "the two skills roots" to "both local skill roots and the configured team root".

Repair boundary:

- Change "under `ai/skills/`" to "under any skills root".

Validator anchors:

- `require_in "ai/policies/ai-policy-common.md" "Team AI Knowledge Directory"`
- `require_in "ai/policies/ai-policy-common.md" "Apply the precedence project, then team, then global"`
- `require_in "ai/policies/ai-policy-team-knowledge.md" "skills/"`
- `require_in "ai/procedures/load-context.md" "configured team skills root"`
- `require_in "AGENTS.md" "configured team root"`

### Acceptance criteria

- **AC-001**: An unconfigured project behaves exactly as today; `ITEM SKILLS-INDEX` reports team none.
- **AC-002**: A configured readable store indexes team skill names, descriptions, paths, and scopes only; no body is read.
- **AC-003**: A configured missing or unreadable store reports `[PENDING]` and the load continues.
- **AC-004**: Precedence is project, team, global; a project override, a team override, and a cross-type collision are reported.
- **AC-005**: The package shape is unchanged; hidden, symlink, nested, and invalid packages are skipped and reported.
- **AC-006**: Activation is `use skill` or the single best description match; the team source is announced; a helper needs explicit approval.
- **AC-007**: The combined three-root index stays at 16 KB; over-bound prints counts and queries on demand.
- **AC-008**: The trust boundary is documented; the protocol does not verify review at boot.
- **AC-009**: Removal is retirement; Git history is the record; no tombstone.
- **AC-010**: Contribution is a manual copy plus PR; no publish trigger.
- **AC-011**: No new policy, procedure, trigger, or anchor; counts stay 25/16/53; the suite 28/28 passes.
- **AC-012**: The docs, announcement v7.2.0, README banner, release practices, and docs sweep ship.
- **AC-013**: The personal skills root is recorded as deferred.
- **AC-014**: The docs sweep finds no "two roots", "both skill roots", or "two directories" leftover.

## ADRs

### ADR-001: The team skills root reuses the team store

- **Decision**: Serve team skills from `<Team AI Knowledge Directory>/skills/` with the existing two keys.
- **Context**: The team store already provides a reviewed, access-gated Git repository.
- **Consequences**: No new key or transport. The team repo can host `skills/` as ADR-008 reserved.

### ADR-002: The common Skills section owns the rules

- **Decision**: Put the team root, the precedence, and the conditional load in the common policy `## Skills`; add only a pointer to the team policy.
- **Context**: The skills model is an always-on invariant, and the team policy loads only when the store is configured or publish runs.
- **Consequences**: No new policy or loading exception. The team policy keeps the store shape.

### ADR-003: Consumption only, manual contribution

- **Decision**: The protocol indexes and activates team skills; contribution is a manual copy into `skills/` plus a PR.
- **Context**: The team repo already has review and history; a publish trigger would duplicate the knowledge-publish path for a different artifact.
- **Consequences**: No new trigger or procedure. A publish path can be a later ticket.

### ADR-004: The team repository is the trust boundary

- **Decision**: Document the one-reviewer PR gate and access control as the trust boundary; do not verify review at boot.
- **Context**: The boot is offline and cannot read PR review state without network and authentication. The local clone is the user's trusted working copy.
- **Consequences**: The shared remote's review governs what enters the clone; the user remains responsible for the source; a helper still needs explicit approval.

### ADR-005: Precedence project, team, global

- **Decision**: Apply the precedence project, then team, then global; report the override.
- **Context**: Project facts are authoritative for the project; the team store is curated and shared; global is the fallback.
- **Consequences**: The precedence mirrors the knowledge order.

### ADR-006: Index in the skills step with one combined bound

- **Decision**: Index the team root inside `STEP-SKILLS-INDEX`; keep one combined 16 KB bound; report `[PENDING]` for an unreadable configured store.
- **Context**: The skills index owns the package shape, and the 16 KB bound already covers the local roots.
- **Consequences**: `ITEM SKILLS-INDEX` reports the team count and status; the team knowledge item stays lessons-only.

### ADR-007: Same auto-match, body only, gated helpers

- **Decision**: Keep the same `use skill` and description auto-match; announce the team source; load the body only; gate every helper.
- **Context**: Review is at contribution time, and a body is instructions, not execution.
- **Consequences**: A description match never runs a helper.

### ADR-008: Removal is retirement

- **Decision**: Retire a team skill by removing its package in a reviewed PR.
- **Context**: The boot index is rebuilt from live files, and Git history records the removal.
- **Consequences**: No tombstone or new frontmatter field. The team repo's PR is the record.

### ADR-009: A personal skills root is deferred

- **Decision**: Do not reserve a personal skills root now.
- **Context**: The earlier user-global skills root was dropped because "global" already had multiple owners, and the team root is a different scope.
- **Consequences**: The current order is project, team, global. A future ticket decides a personal root.

### ADR-010: Minor v7.2.0

- **Decision**: Ship the team skills scope as v7.2.0.
- **Context**: The change adds behavior and docs but no new policy, procedure, or trigger.
- **Consequences**: The release carries an announcement, a README banner, and a release-practices entry.

## Risks and Gaps

- **RSK-001**: A reviewed team skill can still be malicious. Mitigation: access and review, the helper approval gate, and the user responsibility.
- **RSK-002**: A third root grows the boot index. Mitigation: the combined 16 KB bound and on-demand queries.
- **RSK-003**: A team override surprises the user. Mitigation: report the source and the override.
- **RSK-004**: A stale clone serves a stale skill. Mitigation: a manual pull; the skills index does not record age, which is reported as a gap.
- **RSK-005**: A team skill name collides with a policy or procedure. Mitigation: report the cross-type collision.
- **RSK-006**: An invalid package breaks the index. Mitigation: skip and report.
- **RSK-007**: The team repository's review assumption fails. Mitigation: the documented boundary and the user responsibility.
- **RSK-008**: The "two roots" wording remains. Mitigation: the docs sweep; AC-014.

## Test Plan

Write the failing test first: extend `tests/test-skills-index.sh` with a team root.

- Create a temp team root at `$WORK/team` with `alpha` (overridden by the project), `team-only`, `team-global` (overrides global), `team-bad` (missing description), a nested package, a hidden package, and a symlink.
- Extend `discover` and `build_index` to the three roots.
- Assert the project alpha override, the team-only package, and the team-global team-over-global override.
- Assert the team-only package is indexed and the cross-type collision is reported.
- Assert the invalid, hidden, nested, and symlink entries are skipped and reported.
- Refute every body canary and assert the index is at most 16 KB.
- Add `require_in` checks for the common team clause, the team policy `skills/` pointer, the load-context team root and `ITEM SKILLS-INDEX` status, the AGENTS step line, the post-compaction and checkpoint wording, and the repair boundary.
- Keep `tests/run-all.sh` unchanged; it discovers the script, so the test count stays 28.
- Manual check with a configured readable team root and with an unreadable path; the proof reports the count and `[PENDING]`.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/team-skills-scope`, created at implementation.
- **Merge mode**: direct, because `ai-customization.md` has no `## Merge Policy`; squash merge, delete the branch, push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Ticket**: move from `open/` to `in-progress/` at implementation, then to `closed/` in the branch commit.
- **Plan attachment**: attach this plan under `## Implementation Plan` before deleting the plan file.
- **Checkpoint**: run on the branch before the commit.
- **Release**: minor v7.2.0; ship `docs/announcements/v7.2.0.md`, the README banner, the docs sweep, and the `### v7.2.0 (date)` release-practices entry; tag after the merge and publish the GitHub Release.
- **Evidence**: `tests/run-all.sh`, `support-files/validate-protocol.sh`, `support-files/validate-policy-authoring.sh`, markdownlint, and shellcheck.
- **Post-merge**: no commits and no repository changes.

## Peer Review Log

- Round 1: APPROVED, `ai/code-review-reports/2026-11-22_19-45_review-80.md`; no Critical, Major, or Minor; two suggestions: grep the docs-sweep phrases instead of the evidence line numbers, and record the manual live-store and `[PENDING]` checks in the close evidence.
- Implementation round 1: APPROVED, `ai/code-review-reports/2026-11-22_20-08_review-81.md`; no Critical, Major, or Minor; two suggestions: keep the manual hidden/symlink report proof, and record the live-store and `[PENDING]` checks in the close evidence.
