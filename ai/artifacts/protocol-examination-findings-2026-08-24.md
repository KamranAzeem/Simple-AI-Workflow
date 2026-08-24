# Protocol Examination Findings — 2026-08-24

Codebase examination (Procedure G) of the Simple-AI-Workflow protocol repo, run to surface weaknesses and gaps. Every finding below was verified directly against the source (file and line), not taken on trust from the exploration pass. Severity reflects impact on a real user of the protocol.

## Verified findings, by severity

### CRITICAL
- **PowerShell sync script is non-functional.** `support-files/sync-agents-md.ps1:210` calls `[System.IO.File]::WriteAllText($target, $srcContent, ...)`, but `$srcContent` is never assigned anywhere in the file (it is the only occurrence). The script sets `Set-StrictMode -Version Latest` (line 22), so referencing the undefined variable throws at runtime. Windows users who run the PowerShell sync cannot distribute AGENTS.md to their projects. The Bash script reads the source correctly; only the PS1 regressed (likely during the 2026-07-04 sync-script rewrite).
  - Fix: assign `$srcContent = [System.IO.File]::ReadAllText($srcPath)` before the target loop, or replace the write with `Copy-Item -Path $srcPath -Destination $target -Force`.

### HIGH
- **`docs/compliance-guide.md` is stale and contradicts the protocol.** It describes compliance as opt-in on-disk modules stored in `ai/compliance/` (wrong path; the audited directory is `ai/policies/compliance/`), tells users to add an `## Active Compliance Modules` section with markdown-linked files, and lists `gdpr.md`, `pci-dss.md`, etc. This directly contradicts `ai-policy-common.md` "Compliance Intelligence" (No On-Disk Compliance Files, built-in knowledge only) and the `## Required Compliance` section used in `ai-customization.md`.
  - Fix: rewrite the guide to the built-in-knowledge model and the `## Required Compliance` section name.

### MEDIUM
- **Handoff template in `docs/workflow-guide.md` (section 3, ~lines 26-42) is invalid per the protocol.** It has no `## Verification` / `## Validation` section, yet `ai-policy-common.md` mandates one and carries a Refusal Mandate (AI must refuse handoffs that lack it). The template also still includes the `Created-by / Updated-by / Last modified / Intent` metadata header that was banned repo-wide (protocol-decisions 2026-06-18) and by user preference.
  - Fix: add a `## Verification` section with executable steps, and drop the metadata header block.
- **`docs/example-learning-session-runbook.md` uses a non-protocol directory.** Step 4 (~lines 73-78) instructs creating `ai/tasks/todo.md`. `ai/tasks/` is not a protocol directory. Should be `ai/state/next-steps.md` or `ai/pending/`.
- **AGENTS.md immutability banner contradicts Protocol Developer Mode.** The top banner and TIER 2 PROHIBITED say "AI ASSISTANTS ARE STRICTLY PROHIBITED FROM MODIFYING THIS FILE" and "ALL MODIFICATIONS MUST BE PERFORMED MANUALLY BY THE HUMAN USER," but TIER 2 Protocol Developer Mode assumes the AI does change `AGENTS.md` (gated by loading protocol-decisions.md), and most past sessions edited it directly. The rule is ambiguous about which wins.
  - Fix: reconcile the two, for example scope the "manual only" banner to user projects and state explicitly that in Protocol Developer Mode the AI may edit AGENTS.md with protocol-decisions loaded and human approval.

### LOW / MINOR
- **Stale next-steps item.** `ai/state/next-steps.md` deferred item says "Review `ai/sessions/` directory: exists but not referenced." `ai/sessions/` does not exist in the tree and is referenced nowhere else. The item can be dropped.
- **`ai/pending/` and `ai/secrets/` purpose undocumented.** Both are created and validated but their intended use is not described in any doc.
- **README post-compaction wording.** `README.md` (~line 97) frames the post-compaction reload as a user action; the mechanism is automatic detection of "Post-Compaction Recovery." Minor wording alignment.

## Validator coverage gaps (real, but note automatability limits)
`support-files/validate-protocol.sh` checks structure and AGENTS.md anchors well. It does NOT guard:
- Procedure G (Codebase Examination) has no anchor check, unlike Procedures A, D, E, F.
- `ai-customization.md` required sections (`## Active Expertise`, etc.) are not checked; an empty file passes.
- Handoff `## Verification` presence is not checked.
- State-file behavior (no ticked entries in next-steps, append-only progress, Current Status present) is not checked. Behavioral checks are hard to automate; treat as best-effort.
- Note: the subagent claimed READ-ONLY markers are unchecked. That is wrong. Step 6 does grep every policy for both markers. The only gap there is that the requirement is not stated in user-facing docs.

## Corrections to the exploration pass (kept for honesty)
- Handoff-template finding: real, but at ~lines 26-42, not 75-95 as first reported.
- PowerShell `$srcContent` bug: confirmed real and critical after direct check (StrictMode + single unassigned occurrence).

## Suggested fix order
1. `sync-agents-md.ps1` `$srcContent` fix (broken tool, quick).
2. `compliance-guide.md` rewrite to the built-in-knowledge model.
3. Handoff template: add `## Verification`, drop metadata header.
4. Runbook: `ai/tasks/` to `ai/state/next-steps.md`.
5. Reconcile the AGENTS.md immutability-vs-Protocol-Developer-Mode wording.
6. Optional validator additions (Procedure G anchor, customization-section check, handoff Verification check).
