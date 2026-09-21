Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P4
Size: M
URL:
Summary: Add a bounded boot-time staleness heuristic for local-first knowledge retrieval

Description:

The local-first source-precedence part shipped in the Investigation Contract. The remaining gap is staleness: a project knowledge file may be outdated, and the AI may treat it as authoritative.

A full staleness check at boot would read knowledge files and defeat the JIT index-only design. The bounded approach:
- At boot, use cheap signals only: filename and domain match against the active task, file date, and the existing order and size check.
- Flag possibly-stale knowledge in the Proof-of-Load.
- Verify deeply only when a file is loaded for a task.

Not urgent. Background: `ai/shared/project-knowledge/local-first-knowledge-retrieval-proposal.md`.

Acceptance criteria:
- A bounded check that adds no full-file reads at boot.
- Possibly-stale knowledge is surfaced at load context.
- Deep verification happens only on demand.

---

2026-09-22

Closed as part of the `feature/bounded-staleness-heuristic` squash merge into `master`. The boot flag, the Proof-of-Load bullet, the policy rule, and the docs sync are in; validator 8/8, markdownlint 0. Ships in v3.0.0.
