Reported: 2026-10-10
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: M)
URL:
Summary: Consolidate communication and writing-style content, and move the universal rules into the common policy

Description:

Goal: make the user's global settings file thin by moving the universal communication, tone, and writing-style rules into `ai/policies/ai-policy-common.md`, while keeping only user-specific preferences in `~/.ai/settings/global-user-settings.md`.

Step 0: Analysis (done, read-only)

Sources reviewed in full: `~/.ai/settings/global-user-settings.md` (118 lines) and all six files in `~/.ai/global-knowledge/`.

Relevant content in the global settings file:

- `## Communication Style`, which contains `Writing Voice`, `Writing Structure`, `Language Habits`, and `Style Sources`.
- `## Words and Phrases to Avoid` (a mix of universal AI-tell words and personal preferences).
- `## Git Conventions` (mostly universal; see the identity/git ticket).
- `## Sensitive Names To Never Commit` (rule is universal, list is personal).
- `## Identity`, `## Expertise`, `## CLI tools`, `## Operating Instructions` (all personal, stay in settings).

Findings:

1. `ai-policy-common.md` already has a `Humanized Output` section (Sentence Structure, Words to Use and Avoid, Tone, Patterns to Kill, Writing Style by Medium). It already bans most AI-tell words and patterns. The settings' `Words and Phrases to Avoid` partly duplicates it, so part of the work is de-duplication, not addition.
2. Global knowledge contains no communication-style content. All six files are technical (Azure CLI, Private DNS, RG locks, sed portability) except `naming-conventions.md`, whose section 1 duplicates the common policy's `Verbose File Naming` rule. So "consolidate into one section in global settings" concerns almost entirely the settings file itself.
3. Important constraint: the common policy is universal and ships to every user of the framework. Personal voice (the user's sign-offs, personal word choices, personal anecdotes) must NOT be moved into it. Only the general writing rules and AI-tell bans are universal.

Proposed split:

Universal, move to `ai-policy-common.md` (consolidate with the existing `Humanized Output` section, do not duplicate it):

- The general writing baseline: conversational, direct, active voice, short sentences, lead with the point.
- The AI-tell word ban and the "patterns to kill" (no em dashes, no negative parallelisms, no rule of three, no promotional language, no hedging stacks).
- The generic sensitive-names rule and the generic git conventions (cross-reference the identity/git ticket).

User-specific, consolidate into one section in `~/.ai/settings/global-user-settings.md`:

- Personal voice, tone, structure quirks, sign-off style, and `Style Sources`.
- The personal `Words and Phrases to Avoid` entries that are not already covered by the policy.
- An optional sensitive-names list. It is optional only: the AI must never depend on one (see the identity/git ticket).

Recommended approach:

- First consolidate the user-specific style content into a single section in the global settings file, so there is one home for it.
- Then move the universal rules into `ai-policy-common.md`, replacing the duplicated `Humanized Output` content rather than adding next to it.
- Keep the global settings template (`docs/global-user-settings.md`) thin and aligned with the same split.

Acceptance criteria:

- One consolidated communication and writing-style section exists in `~/.ai/settings/global-user-settings.md`, holding only user-specific content.
- The universal rules live once, in `ai-policy-common.md`; no rule is duplicated between the policy and the settings.
- No personal voice or personal list is moved into the universal common policy.
- The global settings template reflects the same thin shape.
- Validator passes; an ADR entry is added to `protocol-decisions.md`; peer review APPROVED.
