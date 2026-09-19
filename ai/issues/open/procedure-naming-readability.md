Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P3
Size: L
URL:
Summary: Replace letter-based procedure names with descriptive kebab-style names

Description:

Current procedures are lettered A through I. The ask is descriptive kebab-style names for readability, for example: load-context, checkpoint, peer-review, post-compaction-recovery, repair-state-files, issue-management, codebase-examination.

Key constraint: some procedure titles are maintained external contracts. "Post-Compaction Recovery" is the stable identifier referenced by the validator anchor, the setup guide, and external hook configurations; a rename must be applied atomically or external triggers stop resolving. The letter must stay free to renumber.

Blast radius: AGENTS.md procedure headers, validator anchors in support-files/validate-protocol.sh, docs (workflow-guide, slides, setup guide), and policy references. protocol-decisions.md and ai/daily-checkpoints/* are historical records and must stay byte-identical.

Note: the 2026-08-05 decision forbids procedure letters and step numbers inside policy files, so a rename also affects how procedures are referenced in prose.

Origin: an unprocessed idea in `ai/notes/notes.md` (removed, captured here).

Acceptance criteria:
- Descriptive names applied consistently in AGENTS.md and validator anchors.
- External stable identifiers (at minimum Post-Compaction Recovery) preserved or migrated atomically across every external reference.
- Docs and guides updated; historical records untouched.
- Validator green.
