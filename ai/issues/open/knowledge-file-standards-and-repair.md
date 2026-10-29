Reported: 2026-10-29
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: Align the project and global knowledge update procedures, enforce an AI-first knowledge file structure with a canonical authority header, and add a repair procedure.

Description:

**Problem**

- `AGENTS.md` treats `update project knowledge` and `update global knowledge` as single-step checkpoint aliases, but the two steps run separate evaluations.
- The global step does not consume the project step's finding list, so the two can reach different conclusions.
- The common policy defines knowledge purpose, precedence, and JIT indexing, but no shared content structure.
- The `Markdown Output` table ban does not include the knowledge directories.
- No rule bans commit hashes, branch names, checkpoint or diary references, or context-file references in knowledge files.
- No rule limits essays or defines a size target.
- A model that edits a knowledge file has no in-file authority header telling it which policy governs the format.
- The corpus is not compliant: long analyses, tables, hashes, and checkpoint references.
- No repair procedure exists for knowledge files. The checkpoint flags stale files only.

**Evidence**

- `AGENTS.md:152` lists the knowledge triggers as checkpoint aliases.
- `AGENTS.md:154` runs only the matching step and skips the rest.
- `AGENTS.md:188` is the project knowledge step.
- `AGENTS.md:195` is the global knowledge step.
- `ai-policy-common.md:148-155` is the Global Knowledge Protocol.
- `ai-policy-common.md:157-163` is the Project Knowledge Protocol.
- `ai-policy-common.md:88` is the checkpoint mandate.
- `ai-policy-common.md:162` is the content integrity rule.
- Project knowledge: 17 files, 2,246 lines.
- Global knowledge: 21 files, 538 lines.
- The three `mattpocock-*` analysis files are 379, 395, and 482 lines, with 19, 34, and 45 table lines, plus hashes and checkpoint references.
- `protocol-name-migration-map-2026-10-06.md` has 82 table lines.
- `multi-agent-state-ownership-and-checkpoint-model.md` has 6 tables and 15 checkpoint or commit references.
- `multi-assistant-workflow-design.md` has a commit hash and 8 references.
- `refactoring-and-upgrading-best-practices-2026-08-25.md` has 6 tables.
- `release-practices.md` has 4 checkpoint or commit references.
- Global knowledge is mostly 35 to 69 lines; `azure-private-dns-zone-group-record-ownership.md` has 4 table lines.

**Requirements**

1. Use one shared knowledge pass: capture findings and classify them as project, global, or both.
2. `update project knowledge` runs capture and the project store.
3. `update global knowledge` runs the same capture and project store, then the global promotion.
4. A full checkpoint runs both stores in that order.
5. Define one AI-first file structure for both knowledge directories:
   - Descriptive H1.
   - Short H2 sections: Context, Rule or Fix, Why, Verify, Caveats.
   - Short sentences and flat bullets or numbered steps.
   - No tables.
   - No nested bullets beyond one level.
   - One lesson per file.
   - No commit hashes, branch names, checkpoint or diary references, or context-file references.
   - No secrets or identifying names.
   - What first; Why short; no essays.
   - Soft size target: about 120 lines. Split or move the long analysis when it grows past that.
6. Add a canonical visible header to every knowledge file.
   - The header names `ai-policy-common.md` and the exact governing section.
   - The header is copied verbatim.
   - The header tells a model to follow that section.
   - The repair procedure restores the header.
7. Add a `repair knowledge files` procedure:
   - Index both directories.
   - Audit structure, tables, hashes, checkpoint or diary references, secrets, size, one-lesson-per-file, duplicates, and headers.
   - Report findings and propose rewrite, split, merge, move, or delete.
   - Apply only with approval.
   - Preserve the useful Why.
   - Move long analyses to `ai/artifacts/` or `design-docs/`.
   - Never auto-run at checkpoint.
8. Add a report-only knowledge-hygiene flag to checkpoint housekeeping.
9. Check the knowledge file header before the knowledge update writes.
10. Optional: a knowledge validator script.

**Open questions**

- Exact governing section name: `### Knowledge File Structure` under `## Project Knowledge Protocol`, or a shared `## Knowledge File Standards` section?
- Header shape: a visible blockquote before the H1, a bold line, or an HTML comment? Recommend a visible blockquote with a bold lead.
- Does the header apply to `issue-template.md`, which is a canonical template rather than a lesson?
- Size target: 120 lines, 150 lines, or a byte target?
- Where should long analyses move: `ai/artifacts/`, `design-docs/`, or delete with approval?
- Should `update global knowledge` write project findings too, or only promote? Recommend yes, so no finding is lost.
- Repair trigger name and aliases.
- Validator script or checklist?

**Acceptance criteria**

- The two update procedures share one capture and classification pass.
- The common policy defines the structure and the canonical header.
- Every knowledge file carries the header; a pre-write check and repair enforce it.
- The corpus has no tables, commit hashes, branch names, checkpoint or diary references, or context-file references.
- Long analyses are moved or distilled; knowledge files are tight and AI-first.
- The repair procedure audits and fixes with approval; no auto-rewrite; no data loss.
- The checkpoint reports violations but does not rewrite knowledge.
- The knowledge update triggers and the repair procedure are documented and validated.
- The work follows the one-branch and one-squash process.

**Blast radius**

- `AGENTS.md`: checkpoint knowledge steps, housekeeping, and a repair procedure.
- `ai-policy-common.md`: knowledge protocols, structure, header, and table ban.
- `ai/shared/project-knowledge/*`: headers, distillation, and moves.
- `~/.ai/global-knowledge/*`: headers and table conversion.
- `support-files/` only if a validator is added.
- No release.
