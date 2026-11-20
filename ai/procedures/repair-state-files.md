# PROCEDURE REPAIR-STATE-FILES: When the user says "repair state files", "tidy state files", or "heal state files"

## Triggers

- repair state files
- tidy state files
- heal state files

1. **STEP-LOAD-STATE-RULES**: Load `ai-policy-common.md` and read `### Canonical State-File Headers`. Verify exactly one block for each type. If the policy or subsection is unavailable, stop and ask. Do not write a header without the policy text present.
2. **STEP-DIAGNOSE-STATE**: Run the same read-only checks as the STEP-STATE-FILE-PROOF-OF-READ of PROCEDURE LOAD-CONTEXT: canonical header match, chronological order, duplicates, shared-budget size, brevity, the diary mirror, and today's H1 form and date.
3. **STEP-REPAIR-STATE**:
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
    - **Condense**: when the three files exceed the 30,720-byte shared budget, or any item line exceeds 300 characters, condense items longest first. An item line is a non-empty line after the header END marker that is not an ATX heading.
        - Move completed progress entries and resolved context items to the latest checkpoint first.
        - Append the full original item to today's checkpoint. When today's file is absent, create it with the canonical block and H1 and apply the same H1 date check as the checkpoint.
        - Write a stub of one fact per line, at most three lines, each at most 300 characters, with a long pointer on its own line.
        - Run the identifier diff: ISO dates, ticket references, code and file paths, URLs, version strings, owners, and named decisions must appear in the stub, unless the stub's pointer names a Project Knowledge file that contains them. Test counts, byte figures, and similar measurements may stay in the diary only.
        - When a stub cannot meet the 300-character cap and the diff, keep the original, write no stub, and report `not condensable` with the blocking identifier.
        - Remove the original only after the diary append and the diff succeed. Never drop an unfinished next-steps item.
        - When the diary append fails, keep the original and report the failure.
        - Print one promotion-candidate line per condensed item whose original holds reusable knowledge. Write no Project Knowledge; the checkpoint owns that write.
        - Report any remaining overage and the live-item count, then continue.
4. **STEP-REPORT-REPAIR**: List each header replaced or inserted, each title date fixed, the body checksum result, and every other change, then confirm the state files are in order.
5. **STEP-EXIT-REPAIR-MODE**: Return to normal role when the repair is complete.
