Reported: 2026-11-22
Reporter: Kamran Azeem
IssueType: Documentation
Severity: P2
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Restructure the README as a findable landing page with what, why, and how for every feature

Description:

Origin.

- The README has grown very large, and finding information in it has been reported as difficult.
- The features, why they exist, and how to use them are not fully covered.
- Deep reference material and the workflow guide duplicate each other.
- The current opening and the "one assistant" paragraph contradict the new positioning.

Evidence.

- `README.md` is 474 lines, with 18 top-level sections and no table of contents.
- The policy list says 12 domain policies plus 11 protocol policies, which is 23, while the repository has 24.
- The knowledge standards section is about 45 lines and duplicates the workflow guide's section 23.
- The setup and quick start come before the problem and the value.
- `README.md` line 81 says "If you only ever use one AI assistant, you probably don't need this." The main audience is exactly that user.
- The multi-driver story appears in "Why I built it" and in the comparison section, not as a secondary capability.

Scope.

- Make the README a landing page, not a manual.
- New order: one-sentence promise, the gap, a 60-second example, quick start, what it is and is not, a navigation map.
- Add a table of contents near the top.
- Cover each feature group with what it does, why it exists, and the command or path. Group them by job: setup, daily loop, memory, quality, delivery, maintenance.
- Move deep reference to the workflow guide or focused docs, and leave a short summary with a link.
- Fix the stale counts and the policy list.
- Rewrite "Why I built it" to remove the "you probably don't need this" line and to demote the multi-driver story.
- Present VS Code as the recommended home, with editor-agnostic support as a capability.
- Apply the narrative brief in `ai/issues/open/slide-deck-refresh.md`.
- Fix every broken link.

Target.

- At most 250 lines.
- Setup, the daily loop, and any feature's why and how reachable in under a minute.

Acceptance criteria.

- A new user can find setup, the daily commands, and a feature's why and how in under a minute.
- No deep reference is duplicated between the README and the workflow guide.
- No stale policy or procedure count remains.
- Every link resolves.
- The README and the slide deck share the same top-level narrative.

---

2026-11-22

Filed from the documentation discussion. Blocked on the narrative brief in `ai/issues/open/slide-deck-refresh.md`; the restructure can start once the brief is agreed.

---

2026-11-22 (protocol update)

- The protocol now includes the optional team knowledge store (v7.1.0) and the optional team skills root (v7.2.0). The README must cover both: the two team keys, team lessons, the team skills root, the review trust boundary, and the manual contribution path. Counts are 25 policies, 16 procedures, 53 triggers, and 28 test scripts; the README is 476 lines.
- The main narrative is fixed: plain chat leaves the AI at the mercy of its mood; the protocol gives every session the same predictable, reproducible, auditable shape. The multi-assistant/changing-drivers story is a secondary capability, not the opening. The gap examples: skipped tickets, inconsistent checkpoint and knowledge writes, skipped HLD/LLD/acceptance tests/verification, and output-format drift.
- Order: the README is the first issue. It is no longer blocked on the slide deck; the deck will follow the README's agreed narrative. Keep the target of at most 250 lines, a table of contents, grouped what/why/command sections, deep reference in the workflow guide, and the team features.

---

2026-11-22

Plan written: `ai/plans/readme-restructure.md`. Grilling settled the single-assistant audience, the promise, the three-failure opening, the six job groups plus Team, the 250-line target, the README-first order, and the three boundaries. APPROVED after review-82; implemented on `feature/readme-restructure`; review-83 APPROVED.

---

2026-11-22

Closed. Implemented on `feature/readme-restructure`; review-83 APPROVED. Plan attached below.

## Implementation Plan: README Restructure

Ticket: `ai/issues/closed/readme-restructure.md`
Date: 2026-11-22
Status: Implemented; review-83 APPROVED; merge pending

## Evidence

Sources read in full this session, with line counts:

- `README.md`: 476 lines.
- `docs/workflow-guide.md`: 517 lines.
- `docs/ai-customization-guide.md`: 270 lines.
- `docs/setup.md`: 14 lines.
- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`: 204 lines.
- `docs/simple-ai-workflow-slides.md`: 495 lines (reviewed in the documentation planning; the skills slide read here).
- `ai/policies/ai-policy-common.md`: 693 lines.
- `ai/policies/ai-policy-issue-management.md`: 119 lines.
- `ai/policies/ai-policy-design-docs.md`: 171 lines.
- `ai/policies/ai-policy-code-review.md`: 131 lines.
- `ai/policies/ai-policy-team-knowledge.md`: 131 lines.
- `docs/announcements/v7.1.0.md`: 13 lines.
- `docs/announcements/v7.2.0.md`: 11 lines.
- `tests/test-skills-index.sh`: 173 lines.
- `tests/test-team-knowledge.sh`: 183 lines.
- `tests/run-all.sh`: 39 lines.
- `ai/shared/project-knowledge/protocol-verification-toolchain.md`: 71 lines.
- `ai/shared/project-knowledge/release-practices.md`: 202 lines.
- `ai/issues/open/readme-restructure.md`: 66 lines.
- `ai/issues/open/slide-deck-refresh.md`: 96 lines.
- `ai/issues/open/docs-guide-audit.md`: 60 lines.

Confirmed facts:

- The README is 476 lines with 18 top-level sections and no table of contents. It opens with "stop chatting", then Setup, then the road-trip "Why I built it" story at lines 77-96. Line 81 says "If you only ever use one AI assistant, you probably don't need this."
- The README already documents the optional team knowledge store (line 450) and the team skills root (line 254). The counts are 25 policies, 16 procedures, and 53 triggers. The banner points at v7.2.0.
- The workflow guide is the reference manual (517 lines). It duplicates the README's knowledge standards (Section 23), skills (Section 24), design docs (Sections 15 and 22), customization (Section 11), and issue and delivery material (Section 16).
- The "What's included" list is 27 bullets. The new page replaces it with six job groups plus a Team group.
- The `docs/` directory holds 20 files. The docs-guide-audit ticket owns the keep, merge, retire, or rewrite decisions, so the README index must not preempt that audit.
- The new README shape test adds a 29th test script. The toolchain note and the validation docs fixture list need the count update.
- The v7.1.0 and v7.2.0 announcements exist, and the team features are documented in the guide, the customization guide, the README, and the slides.
- The three issues now record the protocol updates and the README-first order.

Grilling decisions, 2026-11-22:

- Primary audience: the single-assistant developer, likely in VS Code. Multi-assistant is a secondary capability.
- Promise: "Stop improvising with AI. Work the same predictable way every time."
- Opening gap: three concrete failures plus output-format drift.
- Multi-assistant story: one section after the core, with the changing-drivers metaphor.
- Features: six job groups plus a separate Team group.
- Length: at most 250 lines, a table of contents, and one 60-second flow.
- Order: the README leads; the slide deck follows the README narrative.
- "What it is not": three boundaries.

## HLD

### Page structure

1. Announcement banner.
2. Title and one-sentence promise.
3. Table of contents.
4. The gap.
5. The fix.
6. The 60-second flow.
7. Quick start.
8. What you get: six job groups plus Team.
9. What it is not.
10. Works with any assistant.
11. Docs and slides.

### Line budget

- Banner and title: 6 lines.
- Promise and TOC: 16 lines.
- The gap: 16 lines.
- The fix: 16 lines.
- The 60-second flow: 20 lines.
- Quick start: 24 lines.
- What you get: 92 lines, about 13 per group.
- What it is not: 12 lines.
- Works with any assistant: 14 lines.
- Docs and slides: 24 lines.
- Target: 235 to 250 lines, leaving margin under the cap.

### The gap

- Show three concrete failures, then output-format drift:
  - Load context may skip the project tickets.
  - Checkpoint may write the diary and update knowledge one time and skip them the next.
  - App work may skip the HLD, the LLD, the acceptance tests, or verification.
  - Output format may flip between bullets and tables.
- State the cause: a plain prompt leaves the AI to decide, so the result depends on its mood.
- State the cost: a long initialization prompt is still not a guarantee.

### The fix

- The protocol gives the AI procedures and policies it must follow.
- Bootstrap loads the background policies and procedures, so the AI is ready without a long prompt.
- The same shape runs every session: load, plan, implement, review, checkpoint.
- The result is predictable, reproducible in the same format, and auditable.
- Name the fixed points: the state files, the ticket workflow, the design gate, the review gate, and the checkpoint.

### The 60-second flow

```text
You: "load context using AGENTS.md protocol"
AI:  proof-of-load, active policies, pending tickets.

You: "plan the issue ai/issues/open/foo.md"
AI:  evidence, questions, plan, close sequence.

You: "implement the plan"
AI:  branch, failing test first, code, review, checkpoint, commit.

You: "checkpoint"
AI:  state, diary, knowledge, grouped summary.
```

The flow shows the fixed shape without a feature dump.

### What you get

- Setup: bootstrap, sync, customization, and the git identity. What, why, and the command.
- Daily loop: load context, plan, implement, checkpoint.
- Memory: state files, project knowledge, global knowledge, handoffs, and the diary.
- Quality: peer review, codebase examination, design documents, shared understanding, thinking modes, and the coding baseline.
- Delivery: issue management, the PR/MR path, the merge policy, and the outbound scrub.
- Maintenance: repair state files, repair knowledge files, backup, post-compaction recovery, the validator, and lint.
- Team: the optional team knowledge store, the optional team skills root, the two keys, the trust boundary, and the manual contribution path.
- Keep the core commands in a short table or list; move the full command list to the workflow guide.

### Content moves

- Knowledge file standards move to the workflow guide Section 23. The README keeps a three-line summary and a link.
- Skills move to the workflow guide Section 24. The README keeps the group bullet and the team root line.
- Design documents move to the workflow guide Sections 15 and 22. The README keeps a group bullet.
- Customization moves to the customization guide. The README keeps a quick-start bullet.
- Issue and delivery detail moves to the workflow guide Section 16. The README keeps the group bullets.
- The long "Keeping this workflow up to date" section becomes a short "Updating" note with the sync command and a setup link.
- The "Why ... using AGENTS.md protocol" explanation becomes two sentences; the full explanation moves to the guide.
- The review and maintenance phrase list moves to the guide.
- The post-compaction, repair, backup, validator, and lint material becomes maintenance group bullets.
- The knowledge standards and file-naming section moves to the guide Section 23; the README keeps a short link.
- The comparison section becomes the secondary "Works with any assistant" section and keeps the comparison link.
- The "How it works" tree stays as a short diagram in the fix or quick start, or moves to the workflow guide; the README keeps one small diagram.
- The "Keeping context healthy" table moves to the workflow guide Sections 14 and 17; the README keeps the "checkpoint often" habit in the daily loop.
- The full "Common instructions" table moves to the workflow guide; the README keeps the core commands.
- The "Examples" and "Docs" sections merge into one docs index.

### Team features

- Team knowledge store: the two configuration keys, team lessons, the publish triggers, the pull request, and the no-merge rule.
- Team skills: the `skills/` root, project/team/global precedence, the combined 16 KB index, the review trust boundary, and the manual copy-and-PR contribution.
- Keep the Team group short and link to the workflow guide and the v7.1.0 and v7.2.0 announcements.

### README leads

- The README narrative is canonical for this unit.
- The slide deck follows the README in its own ticket.
- The deck source-of-truth decision waits.

## LLD with Acceptance Criteria

### Page shape

- At most 250 lines.
- A table of contents near the top.
- The structure above, with H1, H2, and H3 only.
- Keep the announcement banner at the top.

### Opening

- The promise is the agreed sentence.
- The gap shows the three failures and the output-format drift.
- The fix names the procedures, the bootstrap readiness, and the predictable, reproducible, auditable result.
- The single-assistant developer is the main audience.
- Remove the "you probably don't need this" line.

### Daily flow and quick start

- The 60-second flow uses the load, plan, implement, and checkpoint commands.
- Quick start: clone, create the global directories, copy `AGENTS.md` and the customization file, set the workflow path, then bootstrap.
- Link to `docs/setup.md` for platform details.

### What you get

- Six job groups plus Team, each with what it does, why it exists, and the command or path.
- Keep the core commands; the full command list lives in the workflow guide.
- The team features are in the Team group, with the keys, the root, the trust boundary, and the contribution path.

### Boundaries and secondary capability

- "What it is not" has three boundaries: not a platform or driver lock-in, not a replacement for judgment or autonomy, and not a heavy install.
- "Works with any assistant" comes after the core value, with the changing-drivers metaphor and a link to the comparison doc.
- VS Code is the recommended home; editor-agnostic support is a capability, not the pitch.

### Counts and links

- 25 policies, 16 procedures, and 53 triggers.
- The new README test makes 29 test scripts; update the toolchain note and the validation docs fixture list.
- Every local link resolves.
- No stale 23 or 24 policy count remains.

### Acceptance criteria

- **AC-001**: The README is at most 250 lines with a table of contents.
- **AC-002**: The opening promise is the agreed sentence.
- **AC-003**: The gap shows the three failures and the output-format drift.
- **AC-004**: The fix states the procedures, the bootstrap readiness, and the predictable, reproducible, auditable result.
- **AC-005**: The 60-second flow shows load, plan, implement, and checkpoint.
- **AC-006**: Six job groups plus Team, each with what, why, and the command or path.
- **AC-007**: The Team group covers the two keys, team lessons, team skills, the trust boundary, and the manual contribution path.
- **AC-008**: The multi-assistant story is a secondary section after the core, not the opening.
- **AC-009**: "What it is not" has the three boundaries.
- **AC-010**: The single-assistant developer is the main audience; the "you probably don't need this" line is gone.
- **AC-011**: Deep reference moves to the workflow guide; no topic has two full copies; the links resolve.
- **AC-012**: Counts are 25 policies, 16 procedures, and 53 triggers; no stale 23 or 24 remains.
- **AC-013**: The docs index matches the current canonical docs and every local link resolves.
- **AC-014**: The README and the deck share the narrative; the deck follows in its own ticket.
- **AC-015**: The README test passes; the toolchain note and the validation docs list the 29 test scripts; the suite passes 29/29.
- **AC-016**: No release; merge and close. A docs release is a separate decision.

## ADRs

### ADR-001: The thesis is predictability, reproducibility, and auditability

- **Decision**: The README leads with the fixed shape and the repeatable result, not tool portability.
- **Context**: Plain chat leaves the AI to decide what to load, save, and skip; the result varies by mood and session.
- **Consequences**: The opening names the inconsistency and the protocol as the fix. Portability moves to a secondary section.

### ADR-002: The single-assistant developer is the main audience

- **Decision**: The main path speaks to one developer using one assistant, likely in VS Code.
- **Context**: That reader gets the most value from the fixed shape, and the current "you probably don't need this" line contradicts the position.
- **Consequences**: Multi-assistant remains a capability and a comparison link, not the opening.

### ADR-003: The README is a landing page, not a manual

- **Decision**: Cap the README at 250 lines and move deep reference to the workflow guide.
- **Context**: The README is 476 lines and duplicates the guide; finding information is hard.
- **Consequences**: Each topic has one full home. The README keeps the what, why, and command.

### ADR-004: Six job groups plus a separate Team group

- **Decision**: Group the features by job and give the team features their own short group.
- **Context**: The flat 27-bullet list hides the new optional team features and the daily workflow.
- **Consequences**: A reader finds the feature by the job they are doing, and the team features are visible without a second page.

### ADR-005: The README leads the docs narrative

- **Decision**: The README narrative is canonical; the deck and the other docs follow it.
- **Context**: The deck and the README currently tell different stories, and the deck's source of truth is unresolved.
- **Consequences**: The deck refresh follows the README. The source-of-truth decision waits.

### ADR-006: The multi-assistant story is secondary

- **Decision**: Keep the changing-drivers metaphor in one section after the core value.
- **Context**: Multi-assistant portability is a real design feature but not the main problem.
- **Consequences**: The story stays available without becoming the pitch.

### ADR-007: No release for this docs-only change

- **Decision**: Merge the README restructure and close the ticket without a version bump.
- **Context**: The change updates user documentation and one test; it adds no protocol behavior.
- **Consequences**: The release history stays at v7.2.0. A docs release is a separate decision.

## Risks and Gaps

- **RSK-001**: Cutting too much detail. Mitigation: the workflow guide and the setup docs keep the full reference; the README links.
- **RSK-002**: The Team group grows past its budget. Mitigation: 13 lines, with links to the guide and the announcements.
- **RSK-003**: The README narrative conflicts with the deck. Mitigation: the README leads; the deck follows in its own ticket.
- **RSK-004**: The 250-line cap is missed. Mitigation: the line budget and the shape test.
- **RSK-005**: The counts or links drift. Mitigation: the shape test checks the counts and the local links.
- **RSK-006**: The new test breaks the toolchain fixture. Mitigation: update the toolchain note to 29 test scripts.
- **RSK-007**: The failure examples sound negative. Mitigation: keep them concrete and brief, then pivot to the fix.

## Test Plan

Write the failing test first: add `tests/test-readme-shape.sh`.

- Check the line count is at most 250 and a table of contents exists.
- Check the promise, the three failures, and the output-format drift.
- Check the fix and the 60-second flow commands.
- Check the six job groups plus Team.
- Check the two team keys, the team skills root, and the trust boundary.
- Check the three "what it is not" boundaries and the multi-assistant section.
- Check the core commands and the counts 25, 16, and 53.
- Check the "you probably don't need this" line is absent.
- Resolve every local link; skip external URLs and strip anchors.
- Update `protocol-verification-toolchain.md` to 29 test scripts and add the fixture to the validation docs list.
- Run markdownlint on the README and shellcheck on the new test.
- The suite must pass 29/29; the protocol validator must pass 8/8.
- Manual read: a new reader finds setup, the daily commands, and a feature's why and how in under a minute.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/readme-restructure`, created at implementation.
- **Merge mode**: direct, because `ai-customization.md` has no `## Merge Policy`; squash merge, delete the branch, push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Ticket**: move from `open/` to `in-progress/` at implementation, then to `closed/` in the branch commit.
- **Plan attachment**: attach this plan under `## Implementation Plan` before deleting the plan file.
- **Checkpoint**: run on the branch before the commit.
- **Release**: none planned; merge and close. A docs release is a separate decision.
- **Evidence**: `tests/run-all.sh` (29/29), `support-files/validate-protocol.sh` (8/8), markdownlint, shellcheck, and the local link check.
- **Post-merge**: no commits and no repository changes.

## Peer Review Log

- Round 1: APPROVED, `ai/code-review-reports/2026-11-22_20-45_review-82.md`; no Critical, Major, or Minor; four suggestions: keep the Team group within its 13-line budget, make the link check strip anchors and skip external URLs, leave the docs keep/merge/retire decisions to the docs-guide-audit ticket, and record the manual read test and the 29/29 suite in the close evidence.
- Implementation round 1: APPROVED, `ai/code-review-reports/2026-11-22_20-52_review-83.md`; no Critical, Major, or Minor; four suggestions: the README is 163 lines and needs no padding, leave the docs-index pruning to the audit, record the manual new-reader check, and merge only with explicit approval.
