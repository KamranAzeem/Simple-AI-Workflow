Reported: 2026-11-18
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P2)
Size: S
Label:
URL:
Summary: Write release banners and release notes in Kamran's voice, starting with a rewrite of v6.6.0

Description:

- The v6.6.0 announcement, README banner, and GitHub release body read dry and robotic: neutral protocol voice, no first person, no reason or story.
- Voice source: `~/.ai/settings/global-user-settings.md` (`### Voice`, `### Structure`, `### Greetings and Salutations`, `### Words and Phrases to Avoid`) plus `## Humanized Output` in `ai-policy-common.md`.
- Apply the voice to every user-facing release artifact: the announcement under `docs/announcements/`, the README banner, and the GitHub release body.
- First person, conversational, lead with the problem, short sentences. No em dashes, no banned words, no "we" for the user's own work.
- Record the rule in `ai/shared/project-knowledge/release-practices.md` so the next release follows it without a reminder.
- Rewrite the v6.6.0 artifacts, including the published GitHub release body.
- Amended 2026-11-18: the v6.6.1 note is also in scope. Its story about the BIOS crash and AGENTS.md is wrong and dramatized. The user was not worried about AGENTS.md when the computer crashed. Remove the invented events, feelings, and reasons.
- Amended 2026-11-18: draft every release note in a temp file and show the exact text for the user's edits before publishing it or writing the final file. The user's edits come first.

## Acceptance Criteria

- The v6.6.0 announcement reads in the user's voice and keeps every fact from the current version.
- The v6.6.1 announcement is factual, in the user's voice, and carries no invented event, feeling, or reason.
- The README banner matches the announcement in tone.
- Every GitHub release body is updated only after the exact text is approved.
- The release practices state the voice rule, the draft-first gate, and the no-invented-events rule.
- Markdownlint 0; no link or factual drift.
- Peer review APPROVED.

## Plan

Plan attached below.

## Implementation Plan

### Context

- Ticket: `ai/issues/closed/release-documentation-voice.md` (S).
- Rewrite the v6.6.0 announcement, the v6.6.1 announcement, the README banner, and both GitHub release bodies in the user's voice.
- Record the rule in `ai/shared/project-knowledge/release-practices.md` so future releases follow it.
- No version bump. This is a correction to documentation that already shipped.
- Amended 2026-11-18: the user rejected the v6.6.1 opening story as dramatized and partly wrong. Draft every note in a temp file and show it for edits before publishing.

### Evidence

- Voice source: `~/.ai/settings/global-user-settings.md`, sections `### Voice`, `### Structure`, `### Greetings and Salutations`, and `### Words and Phrases to Avoid`; plus `## Humanized Output` in `ai-policy-common.md`.
- The v6.6.0 announcement was 35 lines, neutral, third person, and named no reason for the change.
- The README banner is a single table row and carried v6.6.1.
- The v6.6.0 announcement and the v6.6.1 GitHub body were the old neutral text.
- The v6.6.1 announcement opened with an invented story: a BIOS crash, worry about the customer context, then worry about `AGENTS.md`. The user was not worried about `AGENTS.md` during the crash. The story is gone.
- Facts preserved in the v6.6.0 rewrite: the five plug-in policies; the invariants that stayed; the one-way boundary; the four loading modes; the legacy project-policy load; the validator and fixture check; the custom-policy howto link; the five legacy rewrites; 8/8, authoring PASSED, 19 test scripts; the known prose gap; the upgrade action. The 869-line figure comes from `ai/issues/closed/extract-common-policy-sections-into-standalone-plugin-policies.md`.

### Approach

- Rewrite `docs/announcements/v6.6.0.md` in the first person: why the split happened, what moved, how loading works now, your own policies, the legacy rewrites, what I checked, the one thing still to fix, and the upgrade.
- Rewrite `docs/announcements/v6.6.1.md` without the story: the facts, the moved detail, the unchanged behavior, the checks, and the upgrade.
- Rewrite the README banner in the first person, short and specific, as one row.
- Add three rules to the release practices: the voice, the draft-first gate, and no invented events, feelings, or reasons.
- Draft both notes in `ai/artifacts/release-note-drafts/`, show the exact text, and apply the user's edits before writing the final files or updating GitHub.
- Update both GitHub bodies only after the edited text is approved.
- Apply the rule to every later release artifact.

### Acceptance Criteria

- AC-001: the v6.6.0 and v6.6.1 announcements are first person, conversational, lead with the reason, and carry no invented event, feeling, or reason.
- AC-002: every fact, count, link, and the upgrade action from each current version is preserved.
- AC-003: no em dash, no banned word from the common policy's `Humanized Output`, and no personal avoid word (`folded`, `captured`, `parity`, `inertia`, `guidance`, `spin up`, `sentinel`, `coalesce`).
- AC-004: the README banner matches the announcement in tone and stays one row.
- AC-005: the release practices state the voice rule, the draft-first gate, and the no-invented-events rule, and name the settings sections.
- AC-006: markdownlint reports 0; the link check finds no broken link.
- AC-007: both GitHub bodies are shown for approval and updated only after approval, after the user's edits.
- AC-008: the user's edits are applied before the final file write and before publication.
- AC-009: peer review APPROVED.

### Close Sequence

- Repo: project root of the workflow clone.
- Base ref: `master` at the v6.6.1 release commit.
- Branch: `feature/release-docs-voice`, cut from `master`.
- Merge mode: squash to `master`, one commit.
- Ticket: `ai/issues/closed/release-documentation-voice.md`; closed in the branch commit.
- Release: none. The change corrects documentation for versions that already shipped, so no tag and no new version.
- Draft gate: the drafts in `ai/artifacts/release-note-drafts/` were shown, edited by the user, and only then written to the final files.
- External write: the v6.6.0 and v6.6.1 GitHub release bodies, with the approved text.
- Verification: markdownlint, link check, peer review.

### Peer Review Log

- Plan round 1, `2026-11-18_22-43_review-06.md`: APPROVED. Two Minors (name the program ticket path, include the personal avoid list) and one clarification (the banner row), all fixed in the same pass.
- Scope amendment, 2026-11-18 (user): add the v6.6.1 correction and the draft-first gate. The user's instruction is the authority; the plan was updated, and the drafts were shown before any final write.
- Implementation round 1, `2026-11-18_22-52_review-07.md`: APPROVED.

---

2026-11-18
Closed: the v6.6.0 and v6.6.1 notes are rewritten in the user's voice from the approved drafts, the banner is updated, and the release practices carry the voice, draft-first, and no-invented-events rules. No version bump; the GitHub bodies follow with the approved text.
