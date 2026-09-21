Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: L
URL:
Summary: General documentation cleanup and overhaul against inaccuracies and staleness

Description:

Sweep all user-facing documentation for inaccuracies and stale content, and fix it. Scope: README, `docs/` (workflow guide, guides, slides, examples), and the AGENTS.md-facing explanations.

Known issues to address:
- The README has confusing areas.
- The examples need improvement.

What to look for:
- Inaccuracies: statements that no longer match the protocol (renamed paths, changed behavior, removed features, wrong counts).
- Staleness: outdated examples, version numbers, feature lists, and references.
- Broken or drifting cross-references and links.

Do it in reviewable batches, not one mass edit. Split out work that needs its own ticket.

Acceptance criteria:
- Every user-facing doc file is reviewed against the current protocol.
- Inaccuracies and stale content are fixed, or split into their own tickets.
- Links and cross-references resolve.
- markdownlint clean and validator green.

---

## 2026-09-22: Batch 1 on docs/readme-overhaul

- README: dropped the obsolete customization-move banner, corrected the policy count to 16, filled in the Developer Workflow item, polished "Why I built it", added the progressive-disclosure note, and fixed typos and lint.
- Runbook: replaced the AGENTS.md path step with the ai-customization.md step, fixed the policy paths to `ai/policies/`, and corrected the clone URL.
- Docs: fixed stale `ai/ai-policy-*` paths and counts in the mobile guide, customization guide, personas README, and comparison doc; rewrote `support-files/README.md` against the current sync scripts; fixed the multi-agent runbook prerequisite; normalized "post-compaction recovery" wording.
- Verified: markdownlint clean across 30 files; validator 8/8; all relative links resolve.
- Still to deep-review: `workflow-guide.md`, `codebase-examination-guide.md`, `ai-provider-selection-guide.md`, `compliance-guide.md`, `protocol-validation-system.md`, `tools-preferences.md`, `vscode-cline-provider-setup-for-beginners.md`, `policy-influence-on-ai-work.md`, `global-user-settings.md`, the remaining personas, and the examples.

## 2026-09-22: Batch 2 (deep review complete)

- `workflow-guide`: replaced the obsolete "Git Context Enrichment" section. It claimed a commit hash is stored in `context.md`, which the no-git-metadata rule forbids. Now an accurate "Working with Git" section. Normalized "post-compaction recovery" wording.
- `policy-influence` and `how-policies-work`: policies are the ones `ai-customization.md` names plus the common policy; compliance comes from built-in knowledge, not `iso-27001.md`/`soc2.md` files; policy paths corrected.
- `ai-agent-collaboration`: removed a hardcoded `/home/kamran` path and a heading typo.
- `ai-customization.md` (template): completed the available-expertise list.
- `codebase-examination-guide`: dropped the reference to the removed `ai/artifacts/` file.
- `ai-provider-selection-guide`: removed the stale `/init` doc reference.
- Examples: fixed the full-stack typo and policy paths, added a Verification section to both handoffs, and fixed the knowledge path.
- Slides and the comparison doc were pattern-scanned for stale paths, counts, and prompts; the two wrong policy counts were fixed.
- Result: markdownlint clean across 30 files, all relative links resolve, validator 8/8.
- Pending: close this ticket when the branch merges.

---

2026-09-22

Closed as part of the `docs/readme-overhaul` squash merge into `master`. Batches 1 and 2 are complete: every user-facing doc was reviewed, the slide deck and the workflow guide carry the post-`v2.3.0` features, markdownlint is clean across all tracked markdown, all relative links resolve, and the validator passes 8/8.
