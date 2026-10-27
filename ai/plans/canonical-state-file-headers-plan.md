# Implementation Plan: Canonical State-File Headers

Ticket: `ai/issues/closed/canonical-state-file-headers.md`
Date: 2026-10-27
Status: Released as v5.3.0.

## Context

A live project's `ai/state/context.md` header drifted from the sanctioned shape and the file accumulated checkpoint history. The protocol checked only that a comment line existed, so the drift passed every session.

The header is the only rule set guaranteed to be in context whenever the state file is read. It must carry the rules, not a pointer. The policy remains the single authority, and the file copy is a runtime snapshot that must be verified.

This plan makes the headers canonical, visible, exact-checked at boot, and repairable. It also clarifies the KB figures as soft targets that never cap working ability.

## Goal

Every state file and every checkpoint written from adoption onward starts with a visible, self-contained rules block copied verbatim from `ai-policy-common.md`. Load context compares it exactly and warns on drift. `repair state files` restores it. The validator enforces the same rule mechanically. The KB figures are soft targets, not hard limits.

## Scope

### In scope

- A new `### Canonical State-File Headers` subsection in `ai-policy-common.md` under `## State File Ownership Protocol`, holding the four designated blocks verbatim.
- A `### Literal Artifacts` clause in `ai-policy-meta.md` for blocks that the owning policy designates as normative literal artifacts.
- Exact-header verification in `STEP-STATE-FILE-PROOF-OF-READ`, covering the three state files and today's checkpoint.
- Header restoration in `PROCEDURE REPAIR-STATE-FILES`, with a full-file backup and a body checksum.
- Verbatim header creation in `STEP-INITIALIZE-STATE-FILES` and `STEP-DAILY-CHECKPOINT-FILE`.
- Pre-write header checks in `STEP-ATOMIC-WRITE`, the same-day append branch, and `STEP-STATE-FILE-TRIMMING`.
- An exact-header check inside `validate-protocol.sh`, with no new script.
- This repo's three state files and today's checkpoint updated to the new blocks.
- Soft-target wording in the headers, the common policy, and `AGENTS.md`.
- Doc updates and three ADR entries.

### Out of scope

- Auto-repair at boot. Load context stays read-only and only warns.
- Any new script. The header check lives inside `validate-protocol.sh`; repair stays prompt-driven and is verified by a documented manual test.
- Backfilling historical daily checkpoints. The rule applies to checkpoints written from adoption onward.
- Shipping a new header-check script to user projects. The sync script does not copy support files, so user projects rely on the boot check and the prose repair procedure.
- Changing the state-file content model, the archive model, or the diary section format.
- Reading state files during Post-Compaction Recovery.

## Design (HLD)

### Pieces

1. Authority: the common policy holds the only canonical text and designates the four blocks as normative literal artifacts.
2. Runtime copy: each state file and each post-adoption checkpoint starts with its block.
3. Boot check: the AI reads the policy and the files, compares exactly, and reports.
4. Repair: the only writer of an existing block, replacing an inclusive range with a full-file backup and a body checksum.
5. Validator: the mechanical guard for this repo, using the same policy text inside the existing `validate-protocol.sh`.
6. Soft targets: sizes are advisory, and exceeding one is allowed only when the file is still over target after completed entries move to the diary.

### Adoption boundary

- The rule applies to the three state files immediately.
- The rule applies to daily checkpoints written on or after adoption.
- Load context and the validator inspect today's checkpoint at `ai/daily-checkpoints/YYYY-MM-DD.md`, not the latest historical file.
- If today's file does not exist, report `[PENDING]` with "no checkpoint for today; run a checkpoint" and do not block.
- Historical checkpoints are never checked or repaired. No backfill.
- If today's file was created before adoption on the adoption day, it is the current day's file and may receive the block through repair. It is not treated as historical.
- This resolves the conflict between "no backfill" and "the latest checkpoint must pass": there is no requirement on a historical latest file.

### Flow

- Bootstrap writes the blocks from the policy.
- A checkpoint creates today's file with the diary block.
- Load context compares the blocks and reports, and never writes.
- `repair state files` loads the policy, replaces the block, and verifies the body.
- The validator checks the headers directly and exits non-zero on a mismatch, a missing marker, or a duplicate marker.

## Detailed Design (LLD)

### Canonical block format

Each block has:

- A START HTML comment marker with the type token, for example `<!-- STATE-FILE-HEADER: context.md START -->`.
- A visible bold label naming the policy, the section, and the subsection.
- Visible rule bullets: write only, never write or never do, brevity where applicable, size or archive, writer, and repair.
- An END HTML comment marker.
- A blank line after the label and before the END marker, required by markdownlint.

The markers are the machine boundary. The label and bullets are the rules the agent reads. The block is copied verbatim, including blank lines.

The type tokens are `context.md`, `progress.md`, `next-steps.md`, and `daily-checkpoint`. The diary token is fixed because the filename changes daily.

The blocks below are designated normative literal artifacts. The label form and the multi-sentence bullets are intentional. The exception in `ai-policy-meta.md` exempts a designated artifact from the whole `### Rule Structure` shape and requires precision instead.

### Exact blocks

`ai/state/context.md`:

```markdown
<!-- STATE-FILE-HEADER: context.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** the present, in `## Current Status` and `## Active Working Context`, edited in place.
- **Never write:** history, completed work, plans, runbooks, ledgers, commands, implementation steps, investigation notes, transcripts, or git metadata. Completed work goes to `progress.md`, pending work to `next-steps.md`, and durable detail to Project Knowledge.
- **Brevity:** at most three short bullets per item, with a pointer to Project Knowledge for detail.
- **Size:** 8 KB soft target. Move resolved items to the diary first; if live items still exceed the target, keep them and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: context.md END -->
```

`ai/state/progress.md`:

```markdown
<!-- STATE-FILE-HEADER: progress.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** completed work, one entry per line, newest at the bottom.
- **Never write:** transcripts, rationale, plans, commands, implementation steps, investigation notes, or git metadata. Detail goes to the daily checkpoints or Project Knowledge.
- **Brevity:** at most three short bullets per item.
- **Size and archive:** 7 KB soft target; move the oldest completed entries to the daily checkpoints when the file is over the target or holds entries older than 14 days. If the file is still over target, let it exceed and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: progress.md END -->
```

`ai/state/next-steps.md`:

```markdown
<!-- STATE-FILE-HEADER: next-steps.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** open items only, oldest first, one item per line; no commands, implementation steps, investigation notes, or rationale.
- **Delete on done:** remove each item when it is finished; never keep completed items or history.
- **Never drop:** an unfinished item stays until it is done.
- **Brevity:** at most three short bullets per item.
- **Size:** 5 KB soft target. Delete completed items; if open items still exceed the target, keep them and report the overage. Never drop an unfinished item.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: next-steps.md END -->
```

`ai/daily-checkpoints/YYYY-MM-DD.md`:

```markdown
<!-- STATE-FILE-HEADER: daily-checkpoint START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** one file per calendar day; append a new dated section at the bottom; the H1 date matches the filename.
- **Never do:** edit, reorder, or delete an earlier section. This file is the only archive.
- **Move here:** completed `progress.md` entries and resolved `context.md` items when the source file is over its soft target or holds entries older than 14 days.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: daily-checkpoint END -->
```

### Placement

- The block is the first content in the file, starting at line 1.
- The block ends at the END marker. Exactly one blank line follows END as a file-layout rule, not as part of the block.
- The separator is required. A file with zero or multiple blank lines after END fails the header check, and repair normalizes it to one without consuming body content.
- In `context.md`, the existing `# Project Context` follows the blank line.
- In `progress.md`, entries follow the blank line.
- In `next-steps.md`, the existing `## Pending` heading follows the blank line.
- In a daily checkpoint, the existing `# Daily Checkpoint YYYY-MM-DD` heading follows the blank line.
- The existing headings and body are not removed or reordered.

### Policy placement and authoring model

Insert the subsection after the State File Ownership Protocol bullets and before `## Operational Standards`:

- Heading: `### Canonical State-File Headers`.
- Five imperative bullets:
  - Designate the four blocks below as normative literal artifacts.
  - Copy the block for the file type exactly as the first lines of the file.
  - Add one blank line after the block.
  - Use `repair state files` to replace an existing block.
  - Copy the canonical block in bootstrap and checkpoint creation.
- Four labelled fenced `markdown` blocks, exactly the text above.
- No table, no second copy in `AGENTS.md`.

Add a `### Literal Artifacts` subsection to `ai-policy-meta.md`:

- Treat a fenced block as a normative literal artifact only when the owning policy designates it as one.
- Exempt a designated normative literal artifact from the `### Rule Structure` shape.
- Keep a designated normative literal artifact precise and free of vague terms.
- Do not mark a designated normative literal artifact as an example or non-normative.

The common policy designates the four header blocks. The Git config block and the delivery-ledger example are not designated, so the exception does not reclassify them. Add an ADR entry for the exception.

### Boot check

Modify `STEP-LOADING` and `STEP-STATE-FILE-PROOF-OF-READ`:

1. `STEP-LOADING` already reads the latest checkpoint for context. If the latest checkpoint is today's file, the proof-of-read reuses that full read. If it is not, the proof-of-read reads today's file fresh. Do not read the same file twice.
2. Read the three state files fresh.
3. Normalize a UTF-8 BOM, CRLF, and trailing whitespace on read before any marker detection.
4. For each file, locate the block for its type from the common policy subsection.
5. Verify the policy contains exactly one START line and one END line for each type by exact string equality. A missing or duplicate line is a failure, never a skip.
6. Verify the file's block starts at line 1, contains exactly one START line and one END line for its type, and has exactly one blank line after the END line.
7. Compare the block line by line. Any difference other than BOM, CRLF, or trailing whitespace is a mismatch.
8. Report `[PASSED]`, `[FAILED]`, or `[PENDING]` per file under ITEM STATE-FILE-HEALTH.
9. Outcomes:
   - Missing state file: `[FAILED]`, stop and report. State files are mandatory. Do not give the repair instruction.
   - Header mismatch: `[FAILED]`, warn that state-file health is degraded and work quality is at risk, and instruct the user to run `repair state files` now. Do not write during load context.
   - Today's checkpoint missing or the directory empty: `[PENDING]`, advise running a checkpoint, and do not block.
   - Today's checkpoint H1 missing, multiple, or not in the form `# Daily Checkpoint YYYY-MM-DD` outside fenced code blocks, or its date differing from the filename: `[FAILED]` with the warning.
   - Today's checkpoint header mismatch: `[FAILED]` with the warning.
10. Replace the old stop sentence with: "If a state file cannot be read, stop and report it before continuing. A missing today's checkpoint is not a missing state file; report `[PENDING]` and continue."
11. Keep the diary-mirror check as a separate check against the newest checkpoint file. If no checkpoint exists, report `[PENDING]` and skip it.
12. Report each file's size against its soft target. Overage is advisory and never fails the load.

The validator prints these exact lines for the header check:

- `[PASSED] <path> header`
- `[FAILED] <path> header: block not first`
- `[FAILED] <path> header: legacy header at line <n>`
- `[FAILED] <path> header: mismatch at line <n>`
- `[FAILED] <path> header: missing START marker`
- `[FAILED] <path> header: missing END marker`
- `[FAILED] <path> header: duplicate START marker`
- `[FAILED] <path> header: duplicate END marker`
- `[FAILED] <path> header: END before START`
- `[FAILED] <path> header: expected exactly one blank line after END`
- `[FAILED] <path>: missing state file; restore it before continuing`
- `[FAILED] <path> title: expected exactly one "# Daily Checkpoint YYYY-MM-DD"`
- `[PENDING] <path>: no checkpoint for today; run a checkpoint`
- `[FAILED] ai/policies/ai-policy-common.md: policy file missing`
- `[FAILED] ai/policies/ai-policy-common.md: canonical header blocks missing or duplicated`
- `[WARNING] State-file health is degraded and work quality is at risk. Run "repair state files" now.`

The warning prints only for a header or title mismatch, never for a missing state file. The AI's load report reproduces the per-file lines and the warning. The validator is the deterministic reference for this repo; the AI's compliance is verified by the manual checklist in the test plan.

### Repair

Modify `PROCEDURE REPAIR-STATE-FILES`:

1. `STEP-LOAD-STATE-RULES`: load `ai-policy-common.md` and read `### Canonical State-File Headers`. Verify exactly one block for each type. If the policy or subsection is unavailable, stop and ask. Do not write a header without the policy text present.
2. `STEP-DIAGNOSE-STATE`: run the read-only checks, including the header comparison, today's checkpoint, and today's H1 form and date.
3. `STEP-REPAIR-STATE`:
   - Check that the state file exists before reading it. If it is missing, stop and report; do not create it.
   - Read the file. Strip a UTF-8 BOM, convert CRLF to LF, and trim trailing whitespace before marker detection. Write UTF-8 without a BOM and with LF endings.
   - Detect the marker state immediately after normalization. Count exact START and END lines.
   - If there is no START and no END, use the insertion path:
     - If line 1 is a recognized legacy header, remove that line and any leading blank lines. The remaining content is the body.
     - Otherwise, the existing content with its leading blank lines removed is the body.
     - For the diary, apply the same H1 rule to the body: exactly one H1 outside fenced code blocks of the form `# Daily Checkpoint YYYY-MM-DD`, with only the date token corrected if needed. Stop on any other shape.
     - Save the full original file and the body as the expected body.
     - Write the canonical block, exactly one blank line, and the body.
     - Compare the new body with the expected body and restore on failure.
   - If exactly one START and one END exist and START precedes END, use the replacement path:
     - If START is not line 1, and every preceding line is a recognized legacy header or a blank line, remove those lines so the block starts at line 1. Stop and ask on any other preceding content.
     - Define the body as the content after END with all leading blank lines removed.
     - If the first body line is a recognized legacy header, remove it and any following leading blank lines. This is an allowed correction.
     - For the diary, require exactly one H1 outside fenced code blocks of the form `# Daily Checkpoint YYYY-MM-DD`. Replace only the date token if it differs from the filename. Stop on zero or multiple H1 headings, or on any other H1 shape. This is an allowed correction.
     - Save the full original file and the expected body, after the allowed legacy-line and H1 date corrections.
     - Replace the inclusive START-to-END range with the canonical block, exactly one blank line, and the expected body.
     - Compare the new body with the expected body and restore on failure.
   - If the markers are partial (START without END, END without START, duplicates, or out of order), stop and ask. Do not guess at the boundary.
   - Recognized legacy headers: the actual HTML-comment forms `<!-- State file (present). ... -->`, `<!-- State file (past). ... -->`, `<!-- State file (future). ... -->`, and `<!-- Daily checkpoint (diary). ... -->`, plus the bare forms that start with `State file (` or `Daily checkpoint (`. Match only the known prefixes; never remove arbitrary content.
   - The existing reorder, trim, and diary-mirror repairs still run.
4. `STEP-REPORT-REPAIR`: list each header replaced or inserted, each title date fixed, the body checksum result, and confirm the body was unchanged.

The procedure is prompt-driven and applies in user projects. No script performs the repair. The manual repair test exercises this procedure on a scratch copy.

### Validator

Modify `support-files/validate-protocol.sh` in place. Do not add a new script.

Add a shell function, `check_header`, used for the three state files and today's checkpoint. The function:

- Reads the policy at `ai/policies/ai-policy-common.md`.
- Normalizes a UTF-8 BOM, CRLF, and trailing whitespace on read before marker detection.
- Matches marker lines by exact string equality, for example `[ "$line" = "<!-- STATE-FILE-HEADER: context.md START -->" ]`. It does not use an unescaped regex.
- Fails when the policy file is missing, when `### Canonical State-File Headers` is missing, or when the policy has zero or more than one block for a type.
- Fails when a state-file block is missing, duplicated, not first, or lacks exactly one blank line after END.
- Compares the file block with the policy block line by line and fails on the first difference.
- Detects a recognized legacy header at the block position and reports it. `block not first` takes precedence over `legacy header at line <n>`.
- Checks today's checkpoint at `ai/daily-checkpoints/<today>.md`. It uses `date +%F` and validates the date as a real calendar date. It never selects `VALIDATION_TEST.md` or another name.
- Checks that today's checkpoint has exactly one H1 outside fenced code blocks of the form `# Daily Checkpoint YYYY-MM-DD` and that the date matches the filename. A missing, multiple, or wrongly shaped H1 fails.
- Prints the exact lines defined in the boot-check section: the per-file `[PASSED]`, `[FAILED]`, `[PENDING]` lines, and the `[WARNING]` line. It does not print a usage line because it has no CLI.
- Returns 0 for pass or `[PENDING]` no-checkpoint, and 1 for a failure.

Wire the function into section 4 of `validate-protocol.sh` so the validator remains 8/8. Remove the old `grep -q 'State file ('` loop. Add the two anchor greps for `## State File Ownership Protocol` and `### Canonical State-File Headers` to the policy-baseline section, against `ai/policies/ai-policy-common.md`. Keep the 20 KB check non-fatal and label it a soft target.

The validator is the only mechanical check. There is no separate test script. The negative cases run in a scratch copy by editing one file and running the validator:

- Exact block passes for all three state files and today's checkpoint.
- One changed word fails with the exact mismatch line.
- Missing START, missing END, duplicate START, duplicate END, and out-of-order markers fail with the defined lines.
- Block not first fails.
- Zero or two blank lines after END fail with the separator line.
- Legacy HTML-comment and bare legacy forms are reported.
- BOM, CRLF, and a trailing space on a marker line pass.
- Missing state file fails without the repair warning.
- No today's checkpoint, including an empty directory, reports `[PENDING]`.
- A wrong H1 date fails with the date line; a wrong prefix, no date, or multiple H1 headings fail with the shape line.
- Missing policy file, zero or duplicate policy blocks, and a missing policy subsection fail.
- `VALIDATION_TEST.md` is never selected.
- `AGENTS.md` contains the three exact pre-write anchors:
  - "Before writing, verify each state-file header." in `STEP-ATOMIC-WRITE`.
  - "Before appending, verify today's header." in `STEP-DAILY-CHECKPOINT-FILE`.
  - "Preserve each header verbatim." in `STEP-STATE-FILE-TRIMMING`.
- `wc -c ai/state/progress.md` is at or under 7,168 bytes, or the checkpoint records the overage as advisory.

### Bootstrap and checkpoint writes

- `STEP-INITIALIZE-STATE-FILES`: create the three files with the canonical block for each copied verbatim, then the v2 shape, and the initial daily checkpoint with its canonical block.
- `STEP-DAILY-CHECKPOINT-FILE`: when today's file does not exist, create it with the canonical diary block, one blank line, and the `# Daily Checkpoint YYYY-MM-DD` heading.
- Same-day append: add "Before appending, verify today's header." If it does not match, stop and run `repair state files` first.
- `STEP-ATOMIC-WRITE`: add "Before writing, verify each state-file header." If one does not match, stop and run `repair state files` first. Preserve each header verbatim when writing the body.
- `STEP-STATE-FILE-TRIMMING`: add "Preserve each header verbatim." Verify each header before and after trimming.
- The header gate runs before any write starts. A gate failure aborts the checkpoint intentionally. The checkpoint failure rule, that the state files and diary run first and always, applies after the gate passes and the write starts.
- No step invents or edits header text. Every writer copies the policy block.

### Soft targets

Use one precise rule everywhere:

> Move completed entries to the diary first. Exceed the soft target only when the file is still over target after that move. Report the overage.

Apply it as follows:

- Context: move resolved items to the diary first; if live items still exceed 8 KB, keep them and report the overage.
- Progress: move the oldest completed entries to the daily checkpoints first; if the file is still over 7 KB, let it exceed and report the overage.
- Next-steps: delete completed items; if open items still exceed 5 KB, keep them and report the overage. Never drop an unfinished item.
- The header bullets use this wording, as shown above.
- The common policy uses this wording for 8 KB, 7 KB, and 5 KB.
- `AGENTS.md:177` changes "These are soft caps" to "These are soft targets".
- `AGENTS.md:178` removes "The budget wins: trim even inside 14 days when over budget" and uses the precise rule.
- `AGENTS.md:179` changes "soft cap" to "soft target".
- `support-files/validate-protocol.sh:190` changes "soft budget" to "soft target".
- `docs/workflow-guide.md:282` changes "up to 7 KB" to "a 7 KB soft target".
- `STEP-STATE-FILE-PROOF-OF-READ` reports overage as advisory and never fails the load.
- The progress file is trimmed during implementation because the new header pushes it over 7 KB. Run a checkpoint; its diary step creates today's file, and its trimming step moves the oldest completed entries into today's diary until the file is at or under 7,168 bytes.

### Documentation

Update the presence-only and hard-budget wording:

- `docs/workflow-guide.md:282`: soft-target wording. `:285` and `:319`: "20 KB soft budget" to "20 KB soft target". `:370`: exact header check and header restoration in repair.
- `README.md:354`: the load checks the canonical header, and repair restores it.
- `docs/simple-ai-workflow-slides.md:42` and `:368`: both are the state-file health bullet. Add the canonical header check and repair wording to both.
- `docs/simple-ai-workflow-slides.md:35` is the daily checkpoints bullet. Add a short clause that each diary file starts with the canonical header, if it reads naturally.
- `docs/simple-ai-workflow-slides.md:41`, `:350`, `:367`: "20 KB soft budget" to "20 KB soft target".
- Verify every line reference before editing.
- Do not change `support-files/README.md`; it does not list validators.
- Docs describe the rule and never quote the blocks, to avoid a second source.

## Files to Change

- `ai/policies/ai-policy-common.md`: new subsection, designation, soft-target bullets.
- `ai/policies/ai-policy-meta.md`: `### Literal Artifacts` clause.
- `AGENTS.md`:
  - `STEP-LOADING` (checkpoint read reuse)
  - `STEP-STATE-FILE-PROOF-OF-READ` (exact header check, stop-sentence replacement, diary-mirror split, size-budget wording)
  - `STEP-PROOF-OF-LOAD` `ITEM STATE-FILE-HEALTH` ("comment" to "canonical header", today's checkpoint)
  - `STEP-INITIALIZE-STATE-FILES`
  - `STEP-ATOMIC-WRITE` (pre-write check)
  - `STEP-DAILY-CHECKPOINT-FILE` (creation and same-day append)
  - `STEP-STATE-FILE-TRIMMING` (pre-write check, soft-target wording)
  - `PROCEDURE REPAIR-STATE-FILES` (`STEP-LOAD-STATE-RULES`, `STEP-DIAGNOSE-STATE`, `STEP-REPAIR-STATE`, `STEP-REPORT-REPAIR`)
- `support-files/validate-protocol.sh`: add the in-script header check, remove the old loop, add the two anchors in the policy-baseline section, soft-target advisory.
- `ai/state/context.md`, `ai/state/progress.md`, `ai/state/next-steps.md`: new blocks.
- `ai/daily-checkpoints/<today>.md`: the canonical block, created by the checkpoint at implementation time. Use the actual date, never a hardcoded plan date.
- `docs/workflow-guide.md`, `README.md`, `docs/simple-ai-workflow-slides.md`: behavior updates.
- `design-docs/protocol-decisions.md`: three ADR entries.
- `ai/issues/open/canonical-state-file-headers.md`: plan link, corrected evidence, implementation updates, review log.

## Replacement Checklist

Remove or replace every old presence-only and hard-budget statement:

- `AGENTS.md:110`: "each carries its one-line rule comment" becomes "each state file carries the canonical header block for its type, and today's checkpoint carries the daily-checkpoint block".
- `AGENTS.md:110`: replace "If any file cannot be read, stop and report it before continuing" with the defined state-file and checkpoint outcomes.
- `AGENTS.md:110`: replace "each file is within its size budget" and "the total is within 20 KB" with the soft-target wording. Report each file and the total against the soft targets, and treat overage as advisory.
- `AGENTS.md:129`: "comment" becomes "canonical header match, including today's checkpoint"; "size-budget" becomes "soft target".
- `AGENTS.md:143`: "one rule-comment line each" becomes "the canonical block for its type copied verbatim"; "an initial daily checkpoint with its one-line rule comment" becomes "an initial daily checkpoint with the canonical daily-checkpoint block".
- `AGENTS.md:172`: "one-line diary rule comment" becomes "the canonical daily-checkpoint block".
- `AGENTS.md:177`: "soft caps" becomes "soft targets".
- `AGENTS.md:178`: remove "The budget wins: trim even inside 14 days when over budget" and use the precise soft-target rule.
- `AGENTS.md:179`: "soft cap" becomes "soft target".
- `AGENTS.md:278`: "comment presence" becomes "canonical header match"; "size budget" becomes "soft target".
- `AGENTS.md:284`: "Restore the one-line rule comment if missing." becomes "Restore the canonical header block when it is missing or mismatched."
- `ai-policy-common.md:208`: "Keep about 14 days or up to 7 KB" becomes "Keep about 14 days or a 7 KB soft target"; "When it is over budget" becomes "When it is over the soft target".
- `ai-policy-common.md:209`: "Keep it to 5 KB" becomes "Use 5 KB as a soft target".
- `ai-policy-common.md:210`: "Keep it to 8 KB" becomes "Use 8 KB as a soft target".
- `support-files/validate-protocol.sh:182-187`: remove the `State file (` loop and run the in-script header check.
- `support-files/validate-protocol.sh:190`: "soft budget" becomes "soft target".
- `docs/workflow-guide.md:282`: "up to 7 KB" becomes "a 7 KB soft target".
- `docs/workflow-guide.md:285` and `:319`: "20 KB soft budget" becomes "20 KB soft target".
- `docs/workflow-guide.md:370`: "rule comment" becomes "canonical header"; "over-budget" becomes "over the soft target"; "size budget" becomes "soft target".
- `README.md:354`: add the canonical header wording.
- `docs/simple-ai-workflow-slides.md:35`: add the diary header clause if it reads naturally.
- `docs/simple-ai-workflow-slides.md:41`, `:42`, `:350`, `:367`, `:368`: hard-budget and state-file health wording.
- After editing, run the scoped grep:

  ```bash
  grep -rn -E 'one-line rule comment|rule comment|one-line diary rule comment|comment presence|State file \(|budget wins|soft cap|soft budget|size budget|size-budget|over budget|over-budget|Keep it to|up to 7 KB' AGENTS.md ai/policies/ support-files/ docs/ README.md
  ```

  The scope excludes `ai/plans/`, `ai/issues/`, `ai/code-review-reports/`, and `ai/daily-checkpoints/`, so evidence and history are not edited. The repair procedure's recognized-legacy-prefix line is a deliberate exception: a `State file (` hit there is the new matcher, not old wording, and is excluded from the review.

## Implementation Steps

1. Get the user's answers to the Open Decisions below.
2. Open `feature/canonical-state-file-headers` before any edit.
3. Load `design-docs/protocol-decisions.md` in full. It is 583 lines and was read for this plan.
4. Edit `ai-policy-common.md`: add the subsection with the four designated blocks and change the size bullets to soft targets. The file is read-only guarded, so show the diff and get approval before writing.
5. Edit `ai-policy-meta.md`: add the literal-artifact clause. Show the diff and get approval.
6. Edit `AGENTS.md`: apply the Replacement Checklist, the pre-write checks, the stop-sentence replacement, and the soft-target rule.
7. Add the in-script header check to section 4 of `validate-protocol.sh`.
8. Update this repo's three state files to the new blocks. Run a checkpoint. Its diary step creates today's file with the diary block, and its trimming step moves the oldest completed `progress.md` entries into today's diary until the file is at or under 7,168 bytes.
9. Update the docs.
10. Add the three ADR entries.
11. Run the full verification set.
12. Run the implementation peer review per the proactive review rule, fix findings, and merge only after approval.

## Test Plan

### Positive

- `bash support-files/validate-protocol.sh` reports 8/8.
- `bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md` passes.
- `bash support-files/test-protocol-references.sh` passes.
- `markdownlint-cli2` is clean on changed markdown.
- `shellcheck support-files/validate-protocol.sh` is clean.
- The validator passes on this repo's state files and today's checkpoint.
- `wc -c ai/state/progress.md` is at or under 7,168 bytes, or the checkpoint records the overage as advisory.
- A scoped grep finds no old presence-only or hard-budget phrases in the changed text. The exact command is in the Replacement Checklist.
- Run the banned-word and vague-term check on the changed policy lines:

  ```bash
  git diff -U0 -- ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md | grep -E '^\+' | grep -E '\b(should|prefer|consider|try|appropriate|reasonable|as needed|if necessary|and similar)\b|etc\.'
  git diff -U0 -- ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md | grep -E '^\+' | grep -E '\b(small|large)\b'
  ```

  Inspect any hits. A defined term is allowed; a new normative use is not. Expected: no new normative use.
- A manual check confirms one sentence per bullet, one action per sentence, and imperative mood in the new common-policy subsection. The designated literal blocks are exempt from that shape, but they must be precise.
- A fresh agent reads only the header of each file and restates the file's rules. The reviewer records the result. This verifies the ticket's AC2 wording.

### Negative

- Corrupt one word in a scratch copy of `context.md`: the validator exits 1 with `[FAILED] <path> header: mismatch at line <n>`.
- Remove the START marker: `[FAILED] <path> header: missing START marker`.
- Remove the END marker: `[FAILED] <path> header: missing END marker`.
- Duplicate the START marker: `[FAILED] <path> header: duplicate START marker`.
- Duplicate the END marker: `[FAILED] <path> header: duplicate END marker`.
- Out-of-order markers: `[FAILED] <path> header: END before START`.
- Zero or two blank lines after END: `[FAILED] <path> header: expected exactly one blank line after END`.
- Put the block second: the validator exits 1.
- Replace a block with the actual legacy HTML comment: the validator exits 1.
- Add a BOM, CRLF, and a trailing space on a marker line: the validator passes.
- Remove a state file: `[FAILED] <path>: missing state file; restore it before continuing`, without the repair warning.
- No today's checkpoint, including an empty directory: `[PENDING] <path>: no checkpoint for today; run a checkpoint`, exit 0.
- Wrong H1 date: `[FAILED] <path> title: expected exactly one "# Daily Checkpoint YYYY-MM-DD"`.
- An H1 with the wrong prefix, no date, or multiple H1 headings: the same title line.
- Missing policy file: `[FAILED] ai/policies/ai-policy-common.md: policy file missing`.
- Zero policy blocks: exit 1.
- Duplicate policy blocks: exit 1.
- Missing policy subsection: exit 1.
- Add `VALIDATION_TEST.md` to the checkpoint directory: the validator ignores it.

### Manual repair test

The repair is prompt-driven, so this test is a documented manual procedure:

1. Copy the repository to a temp directory with `cp -a`.
2. Corrupt one word in the `context.md` header and change one body line.
3. Save the full file to `original.md`. Extract the body after the block with all leading blank lines removed and save it to `body.before`. The procedure's second temp copy is this `body.before`; it is the body the repair compares against.
4. Run the repair procedure in a session whose PWD is the temp directory.
5. Extract the body after the block with all leading blank lines removed and `cmp` it with `body.before`.
6. Extract the canonical block for `context.md` from `ai/policies/ai-policy-common.md`, from the `STATE-FILE-HEADER: context.md START` line through the `END` line, and `diff` it with the restored block in the copy.
7. Force a rollback: after the repair writes the new file but before the final comparison, append a line to `body.before`. The comparison must fail and the full original file must be restored byte-for-byte.
8. Test the separator: remove the blank line after END in one copy, add two blank lines in another, repair each, and assert exactly one blank line follows END and the first body line survives.
9. Test normalization: add a BOM, CRLF endings, and a trailing space on a marker line in a copy, repair it, and assert the output is UTF-8 without a BOM, uses LF, and has no trailing space on the marker lines.
10. Test malformed markers: START-only, END-only, duplicate START, duplicate END, and out-of-order. Each repair must stop without writing.
11. Test block-not-first: a recognized legacy line before the block is removed and the block moves to line 1; any other preceding content stops the repair.
12. Test the no-block insertion path: a legacy-only file and a headerless file. Repair inserts the block, removes a recognized legacy line, preserves the first real body line, and the comparison passes.
13. Test the block-first legacy-after-block path: a correctly placed block followed by a recognized legacy header. Repair removes the legacy line, preserves the first real body line, and the comparison passes.
14. Test a missing state file: repair stops and does not create the file.
15. Test a fenced code block containing a line that starts with a `#` heading marker: it is not counted as a second H1.
16. For the diary, test a wrong H1 date, an H1 with the wrong prefix, an H1 with no date, and a second H1. Only the correct form with a wrong date is repaired; the other shapes stop and ask.
17. Assert the repair report lists the replaced block, the title date change, and the body result.
18. Record the results in the review report.

### Boot simulation

The validator is the deterministic reference. The AI's load report is human-verified.

1. Copy the repository to a temp directory with `cp -a`. The copy contains `AGENTS.md`, `ai-customization.md`, the coordination file, the mandatory directories, and the policy.
2. Capture the checksums of all files.
3. Corrupt one header word.
4. Run `cd <copy> && bash support-files/validate-protocol.sh` and assert exit 1, the exact `[FAILED]` line, and the `[WARNING]` line with the `repair state files` instruction.
5. Assert the checksums are unchanged.
6. In a separate session whose PWD is the copy, run `load context using AGENTS.md protocol`. Confirm the ITEM STATE-FILE-HEALTH lines match the validator's lines and the warning appears.
7. Compare the checksums before and after the load and prove the load wrote nothing. This step is manual and recorded in the review report.

### Commands

```bash
bash support-files/validate-protocol.sh
bash support-files/validate-policy-authoring.sh AGENTS.md ai/policies/ai-policy-common.md ai/policies/ai-policy-meta.md
bash support-files/test-protocol-references.sh
markdownlint-cli2 README.md docs/ ai/policies/ ai/state/ ai/issues/ ai/plans/
shellcheck support-files/validate-protocol.sh
```

## Acceptance Criteria

- AC1: The common policy shows the four blocks verbatim in `### Canonical State-File Headers`, each naming the policy, section, and subsection and carrying the rules. Implementation step 4. Positive test: policy grep and the validator's header check.
- AC2: This repo's three state files and every checkpoint written from adoption onward carry the exact block, and a fresh or compacted agent can follow the file's rules from the header alone. Implementation steps 8 and 11. Tests: the validator's header check, today's checkpoint fixture, and the fresh-agent content review. The compacted case uses the same header content when the agent reopens the file.
- AC3: Load context reports a mismatch with `[FAILED]`, the health warning, and the `repair state files` instruction, and writes nothing. Implementation step 6. Tests: the validator output, checksums, and the manual load-context checklist.
- AC4: Repair restores the exact block and the diary title date, preserves the body with a full-file backup and a body checksum, reports changes, and stops on malformed markers. Implementation step 6. Tests: the manual repair test.
- AC5: Bootstrap, checkpoint creation, atomic write, trimming, and repair all copy the same policy block. Implementation step 6. Tests: the three exact pre-write anchors, the manual repair test, and the validator's header check.
- AC6: The validator exact-checks the blocks, anchors the subsection, fails on zero or duplicate policy blocks, keeps the 20 KB advisory as a soft target, updates the docs, and records the ADRs. Implementation steps 7, 9, and 10. Tests: validator run and anchor checks.
- AC7: The negative fixtures and the boot simulation pass, plus the main validator, authoring validator, reference test, markdownlint, shellcheck, and peer review. Implementation step 11. Tests: the full command set.

## ADR Entries (draft)

### 2026-10-27: Canonical state-file headers are visible, exact, and repairable

The common policy owns the literal header block for each state file and the daily checkpoint. The common policy designates the four blocks as normative literal artifacts. Each file starts with the marked block, copied verbatim. The rules are visible markdown, so a fresh agent, or any agent that reads the state file, sees them. The HTML comment markers delimit the block for repair and validation. Load context compares the block exactly and warns, without writing. Repair is the only writer of an existing block; bootstrap and checkpoint creation copy the block for new files.

This supersedes the one-line rule comment and the all-comment header parts of the State-File Model v2 decisions. The header is now a visible rules block with comment markers, and presence is no longer enough. Adoption applies to checkpoints written on or after this decision; historical checkpoints are not backfilled.

### 2026-10-27: State-file size figures are soft targets

The 8 KB, 7 KB, 5 KB, and 20 KB figures are soft targets. Move completed entries to the diary first. Exceed a target only when the file is still over target after that move. Report the overage. Never drop an unfinished item.

This clarifies the State-File Model v2 budget rule. The target still guides trimming, but it never caps working ability.

### 2026-10-27: Designated literal runtime blocks are normative artifacts

A fenced block that the owning policy explicitly designates as a normative literal artifact is copied verbatim into another file. It is exempt from the whole `### Rule Structure` shape, including the one-sentence, one-action, and imperative-mood rules, and it must be precise and free of vague terms. It is not an example and is not marked non-normative. The common policy designates the four state-file header blocks. Other fenced blocks, such as the Git config example, are not designated and keep the normal example rule.

The authoring standard gains a literal-artifact clause. This lets the headers stay visible and self-contained without forcing them into policy-prose shape.

## Risks and Mitigations

- The common policy and meta policy are read-only guarded. Show the diffs, get approval, and land the policy, `AGENTS.md`, and validator changes together.
- The visible block could be mistaken for content. The bold label, markers, and blank line make it a distinct block.
- The header adds bytes to the file. The figures are soft targets, the block is under 1.2 KB, and overage is advisory. Measure with `wc -c`.
- The progress file starts at 6,763 bytes and the header pushes it over 7 KB. Implementation step 8 trims the oldest completed entries into today's diary, as the normal rule requires.
- Historical checkpoints lack the block. No backfill; the boot check and validator inspect today's checkpoint only, and report `[PENDING]` when it does not exist.
- A malformed marker could make repair eat body content. Repair stops on partial or duplicated markers, saves the full file first, and verifies the body with `cmp`.
- The repair is prose. The manual repair test is the verification, and it is recorded in the review report.
- A user project may not run the validator. The boot check is the runtime guard; the validator protects this repo.

## Rollout and Backward Compatibility

- Existing user projects get a boot warning on the first load after the `AGENTS.md` update if today's checkpoint or a state header is non-canonical. The user runs `repair state files` when ready. Nothing is rewritten automatically.
- Historical checkpoints remain unchanged. The rule applies to checkpoints written from adoption onward.
- This repo updates its own state files and creates today's checkpoint in the same change set, so the validator passes immediately.
- The policy, `AGENTS.md`, and validator must merge together. A partial merge leaves the check pointing at a missing or stale block.

## Resolved Decisions

All decisions are approved.

1. Soft-target rule: approved. Move completed entries to the diary first; exceed the soft target only when the file is still over target after that move; report the overage.
2. Authoring exception: approved. Add the `### Literal Artifacts` clause and ADR, scoped to designated blocks.
3. Validator scope: resolved. No additional scripts; the header check lives inside `validate-protocol.sh`; no sync-script change.
4. Boot behavior: approved. Warn and continue on a header mismatch, `[PENDING]` for no checkpoint, stop only for a missing state file.
5. Repair boundary: approved. Inclusive START-to-END replacement, one blank line, full-file backup, body `cmp`, stop on partial markers, today's checkpoint only.

## Implementation Notes From Round 6

The plan is approved. Apply these notes during implementation:

- Insertion path: after removing leading blank lines, remove a recognized legacy header if it is the first body line, mirroring the replacement path. Add a manual case with a blank line before the legacy header.
- Save the full original file immediately after normalization, before body extraction, legacy removal, or H1 correction, in both paths.
- Validator function: add line-by-line block comparison, legacy-header detection, and the missing-subsection check. Define that `block not first` takes precedence over `legacy header at line <n>`.
- No new script: implement the check inside `validate-protocol.sh`; do not create a helper or test script.
- Adoption day: if today's checkpoint already exists without the canonical block, run `repair state files` before the implementation checkpoint.
- Boot check item 12: report each file and the total size against the soft targets.
- HLD item 4: say repair "replaces an inclusive range or inserts the block when none exists." Scope the placement sentence "not removed or reordered" to bootstrap and checkpoint creation; allow the repair's legacy-line removal and H1 date correction.
- Daily header: say "when the source file is over its soft target, or for `progress.md`, holds entries older than 14 days."
- Title line: add `[FAILED] <path> title: date does not match the filename` for a wrong date. Keep the shape line for a missing, multiple, or wrong-shape H1.
- ADR entries: use `##` headings in `design-docs/protocol-decisions.md`.
- Scoped grep: say "no old phrases except the documented matcher exception."
- Trimming gate: scope "before any write" to the atomic-write and same-day-append gates. A trimming gate failure stops the trim only, after the core writes.
- Scratch-copy tests: state that the copy includes `ai/policies/ai-policy-common.md`.

## Focused Review Notes (Round 7)

The validator-only scope change is approved. Apply these notes during implementation:

- Wrong-date line: add `[FAILED] <path> title: date does not match the filename` to the boot-check list, the Validator section, and the negative test. Keep the shape line for a missing, multiple, or wrongly shaped H1.
- Manual repair test: name the expected-body file in the procedure, add an explicit pause before the comparison, and give the exact body-extraction, block-extraction, `cmp`/`diff`, and rollback-injection commands.
- `AGENTS.md:281`: add "Move over-budget or older-than-14-days completed entries" to the Replacement Checklist and change "over-budget" to "over the soft target".
- Boot check item 12: report each file and the total size against the soft targets.
- Implementation step 7: name the loop removal, the two policy anchors, and the soft-target wording, not only section 4.
- HLD item 4 and Placement: include the insertion path and the repair exceptions (legacy-line removal and H1 date correction).
- Daily header: scope the 14-day condition to `progress.md`.
- Scratch-copy tests: state that the copy includes `ai/policies/ai-policy-common.md`.
- ADR drafts: use `##` headings in `design-docs/protocol-decisions.md`.
- Scoped grep: say "no old phrases except the documented matcher exception."
- Trimming gate: scope "before any write" to the atomic-write and same-day-append gates; a trimming gate failure stops the trim only.
- Boot check: add legacy-header detection, or state that the validator alone emits the legacy line.
- Procedure: name the expected-body file the repair compares against.
- Date validation: compare the filename date with `date +%F`; avoid a GNU-only `date -d` check.
- Soft-target grammar: use "Keep about 14 days and a 7 KB soft target."
- Positive tests: say "passes, or reports `[PENDING]` for a missing today's checkpoint."

## Implementation Record

- Implemented on `feature/canonical-state-file-headers`.
- Main validator 8/8; authoring validator PASSED; reference test PASS; markdownlint 0.
- Header negative fixtures: corrupt word, missing END, duplicate START, two blank separators, and a legacy header all fail with the expected lines; BOM and CRLF pass.
- State files: canonical headers in place; progress trimmed from 7,655 bytes to 6,053 bytes by moving the oldest entries to `ai/daily-checkpoints/2026-10-27.md`; the three files total 9,849 bytes.
- Release: v5.3.0 was prepared in the same squash commit; the tag and GitHub Release were published after the merge.

## Peer Review Log

### Round 1

- Report: `ai/code-review-reports/2026-10-27_15-25_review-01.md`.
- Verdict: CHANGES REQUESTED. 2 Critical, 13 Major, 12 Minor, 3 Nit.
- Response: the plan was rewritten with the adoption boundary, inclusive repair range, body checksum, legacy patterns, literal-artifact clause, precise soft targets, pre-write checks, expanded tests, and AC mapping.

### Round 2

- Report: `ai/code-review-reports/2026-10-27_15-40_review-02.md`.
- Verdict: CHANGES REQUESTED. 8 round 1 items partially or not resolved; 6 Major, 6 Minor, 2 Nit new.
- Response: added the helper repair algorithm, exact boot output, imperative policy bullets, stop-sentence replacement, precision-based artifact clause, soft-target cleanup, slides fixes, exact string matching, progress trim, pre-write anchors, and the `YYYY-MM-DD` form.

### Round 3

- Report: `ai/code-review-reports/2026-10-27_15-55_review-03.md`.
- Verdict: CHANGES REQUESTED. 5 round 2 items and 5 round 1 items still open; 6 Major, 12 Minor, 5 Nit new.
- Response:
  - Dropped the helper `repair` mode. Repair is prose with a full-file backup and a body checksum. This removes the block-not-first, blank-line boundary, checksum-restore, `--date`, and half-repair defects in one change.
  - M3: the literal-artifact exception now exempts the whole Rule Structure shape, and the blocks are explicitly designated.
  - M4: the soft-target rule is now "move completed entries first, exceed only if still over target, report the overage." The contradiction and "unmigrated entry" are gone.
  - M5: the boot simulation copies the full repository with `cp -a`, so all required files are present.
  - m1: corrected the line references and added the missing phrases to the checklist and scoped grep.
  - m2: the pre-write anchors now match the exact implementation sentences.
  - m3: the H1 form is defined as `# Daily Checkpoint YYYY-MM-DD`, only the date token changes, and other shapes stop.
  - m4: BOM, CRLF, and trailing whitespace are normalized before marker detection in both the boot step and the helper.
  - m5: the date is validated as a real calendar date; the `--date` option is gone with the repair mode.
  - m6: missing state files get a distinct message and no repair instruction.
  - m7: the exact helper output lines are defined.
  - m8: the pre-write gate is explicitly before the write, and the checkpoint failure rule applies after it.
  - m9: the two anchors go in the policy-baseline section against `ai-policy-common.md`.
  - m10: the grep is scoped to the live protocol and docs, excluding plans, issues, reports, and checkpoints.
  - m11: the ticket review log is updated.
  - m12: AC2 restores the fresh-agent wording, and the size check records the overage as the only escape.
  - n1-n5: file existence is checked before reading, temp backup is in the same directory, `print` failure is defined, the diary "Move here" names the sources, the ADR wording is corrected, the PENDING fixtures are merged, and the warning uses the ticket's phrase.

### Round 4

- Report: `ai/code-review-reports/2026-10-27_16-10_review-04.md`.
- Verdict: CHANGES REQUESTED. 1 Major, 10 Minor, 4 Nit.
- Response:
  - Major 1: the body is now the content after END with all leading blank lines removed. The separator is a required file-layout rule, the boot check and helper verify exactly one blank line after END, and repair normalizes zero or multiple blanks without consuming the first body line. Fixtures cover zero and two blanks.
  - Minor 1: repair now strips a BOM, converts CRLF to LF, and trims trailing whitespace before marker detection, and writes UTF-8 with LF endings.
  - Minor 2: the insertion path strips leading blank lines before writing the separator.
  - Minor 3: a recognized legacy header at the top of the body is removed when the block is first.
  - Minor 4: the helper counts H1 headings and fails on more than one.
  - Minor 5: the manual repair test names `body.before` as the comparison body and injects a deterministic rollback failure.
  - Minor 6: the manual repair test covers malformed markers, block-not-first, legacy replacement, and the repair report.
  - Minor 7: the checklist adds `ai-policy-common.md:209-210` and the `docs/workflow-guide.md:370` "over-budget" wording, and the grep matches `over-budget` and a bare `rule comment`.
  - Minor 8: an exact banned-word and vague-term diff grep is added.
  - Minor 9: exact marker, separator, title, missing-policy, unknown-type, and usage lines are defined.
  - Minor 10: context and progress now exclude commands, implementation steps, and investigation notes; next-steps says the same in its Write only bullet.
  - Nit 1: the repair checks file existence before reading.
  - Nit 2: missing-policy, unknown-type, and usage lines are defined.
  - Nit 3: the ticket's sync-script claim is corrected.
  - Nit 4: the PENDING fixtures are merged into one case.

### Round 5

- Report: `ai/code-review-reports/2026-10-27_16-25_review-05.md`.
- Verdict: CHANGES REQUESTED. 2 Major, 7 Minor, 4 Nit.
- Response:
  - Major 1: repair step 3 now detects the marker state immediately after normalization. The no-block insertion path runs first, defines its own body, and never touches an inclusive range. The replacement path runs only when exactly one START and one END exist and START precedes END.
  - Major 2: the expected body now includes the allowed legacy-after-block removal and the H1 date correction before it is saved. The write and the comparison use the same expected body, so the path can succeed.
  - Minor 1: the checklist adds `ai-policy-common.md:208` "up to 7 KB" and `docs/workflow-guide.md:370` "size budget".
  - Minor 2: the `AGENTS.md:110` total 20 KB clause is replaced with the soft-target and advisory wording.
  - Minor 3: the manual repair test adds the legacy-only file, the headerless file, the block-first legacy-after-block case, and the missing state file.
  - Minor 4: the procedure's second temp copy is the test's `body.before`, and the rollback step edits that copy.
  - Minor 5: H1 detection counts ATX headings outside fenced code blocks only, and a fixture covers a `#` line inside a fence.
  - Minor 6: exact `block not first` and `legacy header at line <n>` lines are defined.
  - Minor 7: the daily "Move here" bullet now says the source file is over its soft target or holds entries older than 14 days.
  - Nit 1: the status line is updated.
  - Nit 2: the `etc.` pattern no longer uses a trailing word boundary.
  - Nit 3: the scoped grep notes the repair procedure's recognized-legacy-prefix line as a deliberate exception.
  - Nit 4: `print` success output is defined as the canonical block byte for byte, with no extra text.

### Round 6

- Report: `ai/code-review-reports/2026-10-27_16-40_review-06.md`.
- Verdict: APPROVED with notes. 0 Critical, 0 Major, 8 Minor, 5 Nit.
- Response: the two round 5 Majors are fixed. The remaining Minor and Nit items are recorded in "Implementation Notes From Round 6" and will be applied during implementation.

### Scope Change After Round 6

- User decision: no additional scripts at all.
- Change: the header check is folded into `validate-protocol.sh`; the helper and separate test script are dropped. There is no sync-script change. Repair remains prompt-driven.
- Focused re-review: APPROVED with notes. Report: `ai/code-review-reports/2026-10-27_17-00_review-07.md`. 0 Critical, 0 Major, 8 Minor, 8 Nit. The notes are recorded in "Focused Review Notes (Round 7)".
