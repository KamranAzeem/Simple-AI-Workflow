Reported: 2026-11-23
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Rename Global policies to workflow policies to remove the scoping confusion

Description:
The terms project, global, workflow, and team overlap. "Global policies" means the policy tree in the workflow clone, while "global settings" and "global knowledge" live in the user directory. The name creates confusion.

Proposed direction:

- Use "workflow policies" for the policies shipped in the workflow clone.
- Use "project policies" for the project-local tree.
- Keep "global settings" and "global knowledge" for the user-space stores.
- Keep "team knowledge" and "team skills" for the team store.
- Decide whether the path anchor becomes "Workflow AI Policies Directory" or keeps "Global AI Policies Directory" with a documented alias.
- Update `AGENTS.md`, the common and meta policies, every procedure, docs, tests, validator anchors, index output, knowledge, and the ADR.
- Keep behavior unchanged; this is a terminology and naming migration, not a loader redesign.
- Provide a migration table for old and new terms, plus a compatibility note for existing projects.
- Decide the release and whether any deprecated aliases are allowed.

Open questions:

- Exact canonical term: "workflow policies" or "workflow policy layer"?
- Does "workflow policy" include the common policy and procedures, or only the distribution policy tree?
- Does the path key change, or only the prose?
- Is a major or minor release required?
- How long do the old names remain valid in docs and tests?

Acceptance criteria:

- One canonical term is defined and used consistently.
- No reader can confuse workflow policies with global settings or global knowledge.
- `AGENTS.md`, policies, procedures, docs, tests, validator, index, and knowledge are updated.
- An ADR records the decision; the old terms have a migration note.
- No behavior change; the suite and validator pass.
