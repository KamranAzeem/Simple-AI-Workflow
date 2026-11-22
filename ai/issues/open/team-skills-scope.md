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

- Blocked by `ai/issues/open/shared-team-knowledge-store.md`.
- That plan reserves `skills/` for later work in ADR-008.

Next step.

- Grill the open questions, then write a plan.

---

2026-11-22

Filed from the team knowledge store grilling. No decisions are final; the open questions and a grilling round come next. The ticket stays blocked until the team knowledge store ships.
