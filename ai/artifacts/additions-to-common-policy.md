# Reconciliation Plan: ai-customization.md → ai-policy-common.md

**Date**: 2026-08-24
**Author**: Kamran Azeem
**Purpose**: Working document for a protocol-developer session in the Simple-AI-Workflow repo. Reconciles the project `ai-customization.md` Development Workflow rules against the FULL `ai-policy-common.md` (318 lines, read in full 2026-08-24).

**Governing principle**: Single source of truth. Prefer `ai-policy-common.md`. Any rule that is universal must live only in common policy. Delete duplicates from the customization file. The customization file keeps only genuinely project-specific configuration.

> Correction note: an earlier version of this artifact recommended "moving" rules up. That was wrong — it was written from a partial (100 of 318 line) read of the common policy. Most of those rules already exist in common policy. This version is based on a full read.

---

## What already exists in ai-policy-common.md (verified by full read)

These sections are already present. Any matching rule in the customization file is a **duplicate** and should be deleted from the customization file.

| Common policy section | Covers |
|---|---|
| **Evidence-Based Reasoning (No-Assumption Rule)** | Never invent; verify before asserting; no evidence say so; show your source |
| **CLI Command Accuracy** | Exact flags via `--help`/docs; never guess resource IDs; flag unverifiable params |
| **State File Ownership Protocol** + **State File Append-Only Rule** + **State File Scope Rule** | Single-writer; append at tail; summaries only, no runbooks/CLI/knowledge |
| **Ticket File Scope** | Ticket files = customer-facing status only; no diagnostics/runbooks/diary |
| **Trunk-Based Development** | Short-lived branches off `main`/`master`, merge frequently |
| **Design Documentation Standards** + **Delivery Ledger** | notes→vision→PRD→HLD→LLD→ADR→delivery-ledger; ID conventions; ledger spec |
| **Directive vs. Inquiry (Analyze-Plan-Stop)** | Assume inquiry unless explicit directive; no proactive fixes |
| **Generated File Validation** | Run linters before presenting generated files |
| **Communication Standards / Humanized Output** | Writing style, no em-dashes, AI-tell words, medium-specific tone |

---

## Rule-by-rule reconciliation of ai-customization.md → Development Workflow

### 1. Evidence based thorough investigations
**Verdict**: DUPLICATE (mostly). Delete from customization after confirming the two genuine additions below are in common policy.
- "read-only, no guess/fabricate/hallucinate" → already in **Evidence-Based Reasoning**.
- "wider-scoped investigation / identify gaps" → mostly implied; optional one-line strengthening of Evidence-Based Reasoning.
- "read full files not just sections" → **GENUINE ADDITION** (see Addition A below). Not currently in common policy.
- "pull latest before PRs" → covered by Trunk-Based Development; drop the duplicate.
- "WAF/CAF principles" → cloud-specific. Belongs in `ai-policy-cloud.md`, NOT common. Do not move to common.

### 2. No truncation on investigation commands
**Verdict**: GENUINE ADDITION (see Addition B below). Not in common policy. Fold into Evidence-Based Reasoning, then delete from customization.

### 3. Pull latest git changes
**Verdict**: Mostly covered by Trunk-Based Development. The "remind to pull all repos at project startup" behaviour is a small workflow add. If wanted, add one line to Trunk-Based Development; otherwise drop. Delete from customization either way.

### 4. Proactive Peer Review
**Verdict**: Procedure D (peer review) exists in `AGENTS.md`. The only extra here is "run it proactively without being asked after each module/change set." Check whether Procedure D already implies proactive invocation. If not, add one line to the peer-review reference. Then delete from customization.

### 5. Jira / Ticket Updates Require Explicit Approval
**Verdict**: GENUINE ADDITION (generalized). "Ticket File Scope" covers ticket file *content* but not the *never-mutate-without-approval* behaviour. Add a generalized rule to common policy (see Addition C), then delete from customization.

### 6. AC Writing Guide — Update on Every Ticket
**Verdict**: SPLIT.
- The *principle* (maintain a living AC-quality guide; update as tickets close) generalizes and could sit alongside Design Documentation Standards in common policy.
- The *file path* (`<project>-acceptance-criteria-writing-guide.md`) is project-specific → stays in customization as a one-line pointer.

### 7. AI State File Discipline
**Verdict**: DUPLICATE + **CONFLICT** (see Conflict 1 below). Common policy already has State File Ownership/Append-Only/Scope rules. Resolve the top-vs-tail conflict first, then delete the customization rule (common policy wins).

---

## CONFLICT 1 — State file entry order (MUST resolve)

- **Common policy (State File Append-Only Rule)**: "All updates MUST be appended at the tail. The most recent entry is always the last entry. Never insert, prepend, or edit content at the top."
- **Customization (AI State File Discipline)**: "Newest entries go at the top of progress.md."

**These directly contradict.** Top vs tail. During this session, `progress.md` was written newest-at-top, which violates the common policy append-only rule.

**Decision needed**: pick one convention and make both files agree. Recommendation: adopt the common-policy tail-append convention (it is the protocol-wide rule and preserves chronological order across sessions), and correct the customization file to match — then delete the customization rule entirely since common policy already states it. Existing `progress.md` may need re-ordering to match whichever convention is chosen.

---

## Genuine additions to make in common policy (not currently present)

### Addition A — Full reads for working files
Fold into **Evidence-Based Reasoning**. Reasoning about a partially-read file is asserting without full evidence.

> **Full reads for working files.** For any file you must understand or reason about — policies, `AGENTS.md`, customization, settings, project knowledge, source, config, design docs, ticket files — read it in full. Establish length first (`wc -l`), then read from line 1 to EOF, paging through large files until the whole file is covered. Never stop at an arbitrary line window; if a read returns fewer lines than the file has, continue from where it stopped. Targeted reads (`grep`/`head`/`tail`/ranged reads) are permitted only for bulk data files being searched, not comprehended (logs, dumps, large JSON/CSV). Rule of thumb: comprehend → read whole; locate → targeted read is fine.

### Addition B — No truncation on investigation output
Fold into **Evidence-Based Reasoning** (same principle as A).

> **No truncation of investigation output.** Never pipe `grep`, `find`, `az`, or any enumeration command through `head`, `tail`, or any line-limiting filter during investigation. `grep` is already a filter — every line it returns is a match, and truncating it silently drops evidence. Use `wc -l` to gauge volume, then read the full output. `head`/`tail` are for display only, never for completeness checks.

### Addition C — External system mutations require explicit approval
Place near Directive vs. Inquiry or Ticket File Scope.

> **External system mutations require explicit approval.** Never post, update, transition, comment on, or otherwise mutate any external system of record (issue trackers such as Jira/ADO/GitHub, wikis such as Confluence, chat such as Teams/Slack) without the user's explicit instruction. Always propose the exact text first and wait for approval before sending.

---

## Stays in ai-customization.md (project-specific only)

| Item | Reason |
|---|---|
| AI Workflow Configuration | Points to the workflow dir |
| Active Expertise (cloud, dba, observability) | Per-project selection |
| Active Traits | Per-project role |
| Architectural Constraints (hub-and-spoke, firewall IPs, subscription IDs) | 100% project-specific |
| Required Compliance list | Per-project regulatory scope |
| External Knowledge Directories | Per-project paths |
| AC guide file path (one-line pointer) | Project-specific filename only; the principle lives in common policy |
| WAF/CAF principles bullet | Cloud-specific → move to `ai-policy-cloud.md`, not common |

---

## Sequencing (order matters to avoid gaps)

1. **Add** Additions A, B, C to common policy first — so nothing is deleted before its replacement exists.
2. **Resolve** Conflict 1 (top vs tail) in both files; correct existing `progress.md` if needed.
3. **Delete** the now-duplicated rules from `ai-customization.md`: Evidence investigation, No-truncation, Pull-latest, Proactive Peer Review, Jira approval, AI State File Discipline.
4. **Reduce** AC Writing Guide rule to a one-line project-specific pointer.
5. **Relocate** the WAF/CAF bullet to `ai-policy-cloud.md`.
6. **Verify** end state: `ai-customization.md` contains only project-specific configuration; every universal rule exists once, in common policy.

## Protocol-developer reminders (from AGENTS.md)

- `ai-policy-common.md` is read-only from the project window; edit it only in the Simple-AI-Workflow repo.
- Before editing any protocol file, fully load `protocol-decisions.md` from that repo's project knowledge.
- Author all wording from the end-user's project-root perspective. No absolute project-specific paths in shared policy.
- Place each addition inside the relevant existing section, not as a loose new top-level section.
