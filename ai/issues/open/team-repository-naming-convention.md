Reported: 2026-11-24
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Document the team repository naming convention and add a report-only name check

Description:

Follow-up split from `team-knowledge-directory-and-repo-naming.md`. The directory rename ships first. This ticket covers the repository naming convention and an optional report-only check.

Decisions from the 2026-11-24 grilling:

- Name the team repository and its local clone for the team in lowercase kebab case.
- Ignore the org prefix; the repository URL's last segment is the team name.
- One repository per team. A monorepo with several teams is out of scope.
- `team-knowledge/` and `skills/` are siblings at the repository root. `Team AI Knowledge Directory` stays at the root.
- Document the convention. Add a report-only check only when both keys are present and the directory and repository values are non-empty. Never block the boot.
- Normalize the repository value in this order: strip trailing slashes, strip a trailing `.git`, take the last segment after `/` or `:`.
- A helper is optional. Prefer documentation first; add a helper only when the check earns it.
- Migration is a clean rename. No fallback.

Out of scope:

- The `lessons/` to `team-knowledge/` rename, which ships separately.
- Changing the two configuration keys or the precedence.
- Cloning, pulling, or authenticating at boot.

Open questions:

- Does the convention ship alone, or with the report-only check?
- Is the check a pure bash helper, or a rule the AI applies from the boot text?
- Is the release minor or patch?

Acceptance criteria (draft):

- The policy states the naming convention.
- The boot, policy, and docs agree on the match, mismatch, and skip cases.
- A test covers the reported text and the skip behavior.
- The validator, suite, markdownlint, and shellcheck pass.

Source: split from the 2026-11-24 team knowledge directory ticket after the plan review showed the combined scope was too large.
