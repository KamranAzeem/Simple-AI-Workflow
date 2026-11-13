# PROCEDURE CREATE-HANDOFF: When the user says "create handoff"

## Triggers

- create handoff
- create a handoff

1. **STEP-LOAD-POLICY**: Load `ai-policy-handoff.md` and report it active.
2. **STEP-GATHER**: Gather the task, the receiver type, the author's parallel work, the destination, and the authorization.
3. **STEP-DRAFT**: Create `ai/artifacts/handoffs/<handoff-slug>/` and write `handoff-draft.md` from the `## Handoff Template` in the handoff policy.
4. **STEP-REVIEW-HANDOFF**: Run `PROCEDURE RUN-PEER-REVIEW` on the draft, fix every Critical and Major finding, and re-review until APPROVED. Do not write the final handoff before APPROVED.
5. **STEP-SCRUB-HANDOFF**: If the handoff leaves the project, apply `## Outbound Content Scrub` to the exact text, show the scrubbed text and category report, and wait for approval.
6. **STEP-FINALIZE**: Write the final `ai/shared/handoffs/<handoff-slug>.md` with the `## Review` section.
7. **STEP-REPORT-HANDOFF**: Report the path and the start phrases: `load context`, `load ai-policy-handoff.md`, `claim and execute the handoff at <path>`.
