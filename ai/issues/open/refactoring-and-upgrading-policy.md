Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: M
URL:
Summary: Add a refactoring and codebase-upgrade policy

Description:

Add an on-demand policy for refactor or upgrade requests. Research completed 2026-08-25 and stored in `ai/shared/project-knowledge/refactoring-and-upgrading-best-practices-2026-08-25.md`.

Candidate principles the research supports:
- Keep refactoring and upgrading as separate, ordered steps: upgrade first until tests pass, then refactor. Never both at once, or a failure cannot be attributed to the right change.
- Establish or find a test baseline before refactoring (Red-Green-Refactor); refactor only without behavior change.
- For legacy codebases, guard against global-state coupling and refactor in small, safe steps; apply the Boy Scout Rule for minor cleanups.
- Determine the goal first (bugs, features, or security) before choosing refactor vs upgrade vs rewrite.
- Apply Fowler's small disciplined steps and SOLID.

Decision needed in the design: on-demand policy loaded by a trigger phrase, or a section in an existing policy. Keep it lightweight and free of external-tool dependencies.

Acceptance criteria:
- A policy defines when it activates and the ordered workflow (upgrade, then refactor; test baseline; small steps).
- Validator stays green; docs updated where they enumerate policies.
