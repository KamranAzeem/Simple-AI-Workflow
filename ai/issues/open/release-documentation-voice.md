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

## Acceptance Criteria

- The v6.6.0 announcement reads in the user's voice and keeps every fact from the current version.
- The README banner matches the announcement in tone.
- The GitHub release body is updated after the exact text is approved.
- The release practices state the voice rule and point at the settings sections.
- Markdownlint 0; no link or factual drift.
- Peer review APPROVED.
