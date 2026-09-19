Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P2
Size: L
URL:
Summary: Rename policies to skills (ai/policies to ai/skills, drop the ai-policy- prefix, Active Expertise to Active Skills)

Description:

Motivation: "Active Expertise" lists "policies", a taxonomy mismatch. "Skills" is the industry-standard term and matches the third-party SKILL.md drop-in convention.

Change surface (measured 2026-09-04, re-measure before starting):
- ai/policies/ to ai/skills/ (this is both the Project AI Policies Directory and the Global AI Policies Directory in this repo).
- `ai-policy-<name>.md` to `<name>.md` (16 files).
- AGENTS.md: TIER 1 directory names, TIER 2 mandates, Procedure A Step 6 loader, Procedure C Step 4, Procedure E Step 5, and the four Protocol Developer Mode exception notes.
- ai-customization.md: ## Active Expertise to ## Active Skills.
- support-files/validate-protocol.sh: anchors plus a new guard against the ai-policy- prefix.
- support-files/sync-agents-md.sh and .ps1.
- User-facing docs: README, docs/workflow-guide.md, docs/ai-customization-guide.md, docs/simple-ai-workflow-slides.md, and the policy guides.
- Blast radius: 16 policy files on disk; 30 files reference the ai-policy- prefix; "Active Expertise" in about 13 active files; "Policies Directory" in 7 files; ai-policy-common referenced in 21+ files.

Constraints:
- Freeze historical records: protocol-decisions.md and ai/daily-checkpoints/* must stay byte-identical (do not rewrite).
- Decide the taxonomy before the HLD: common and meta are core guardrails, not really "skills". Options: (a) uniform skills directory including common/meta; (b) split ai/core/ and ai/skills/; (c) uniform plus document the core role.
- Sequence with the TIER 2 vs Non-Negotiables consolidation ticket to avoid a second rename pass.

Proposed process: change-request, HLD, review gate, LLD, acceptance criteria, delivery ledger plus ADR in protocol-decisions.md.

Draft acceptance criteria:
- All `ai-policy-<name>.md` renamed to `<name>.md`; no dangling references in AGENTS.md, validator, sync scripts, or docs.
- ai-customization.md uses ## Active Skills; the loader resolves `<name>.md`.
- validate-protocol.sh anchors updated and green, with a new guard forbidding the ai-policy- prefix.
- Historical records byte-identical.
- Downstream sync verified green.

Origin: `ai/notes/policies-to-skills-rename-proposal-2026-09-04.md` (removed, captured here).
