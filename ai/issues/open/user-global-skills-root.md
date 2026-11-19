Reported: 2026-11-19
Reporter: Kamran Azeem
IssueType: Feature
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Add a user-global skills root under the Global User AI Directory

Description:

**Goal**: A third skills root for the user's own cross-project skills.

**Scope**:

- Root: `(Global User AI Directory)/skills/`.
- Index the package name, description, path, and scope at boot; read no body until activation.
- Precedence: project, then user-global, then the clone's skills.
- Collision reporting: a name in two roots.
- Docs and tests.

**Related**: the config ticket; `ai-policy-common.md` skills rules; the `AGENTS.md` Global AI Skills Directory.

**Open questions for the plan**:

- Does the sync check the user-global skills? My default: check only, no copy.
- Does the user-global root override the clone or sit between the project and clone roots?
- The count and the 50-skill review threshold?
