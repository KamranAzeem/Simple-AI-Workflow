Reported: 2026-10-18
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: M)
Label:
URL:
Summary: Rename the meta policy to protocol-developer and update live references

Description:

## Problem

The meta policy name does not say what it governs. The name `meta` is also the Active Expertise keyword, and `support-files/validate-protocol.sh` hardcodes it in the 17-policy baseline. A rename touches the policy file, the customization file, the validator, and live docs.

## Scope

- Rename `ai/policies/ai-policy-meta.md` to `ai/policies/ai-policy-protocol-developer.md`.
- Change `## Active Expertise` in `ai-customization.md` from `meta` to `protocol-developer`.
- Update the policy baseline and error messages in `support-files/validate-protocol.sh`.
- Update live references in `docs/example-learning-session-runbook.md` and `docs/ai-customization-guide.md`.
- Update the open multi-assistant issue in `ai/issues/open/multi-assistant-workflow-and-ai-team.md`; the old design draft is in the local repair artifact.
- Leave historical ADR entries unchanged. Add one short ADR entry for the rename.
- Check the dependency on `policies-to-skills-rename.md`, which would drop the `ai-policy-` prefix entirely.

## Acceptance criteria

- The new policy filename exists and the old one is gone.
- Active Expertise resolves the policy at load context.
- The validator passes with the new baseline.
- Live docs name the new file.
- One ADR entry records the rename.
- No historical ADR text is rewritten.

## Notes

- Deferred from the authoring-standard grilling on 2026-10-18.
- The validator hardcoded baseline is intentional. This ticket updates it and records the coupling.
