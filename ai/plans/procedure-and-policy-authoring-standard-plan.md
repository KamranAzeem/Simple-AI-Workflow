# Procedure and Policy Authoring Standard Plan

Reported: 2026-10-18
Ticket: `ai/issues/in-progress/procedure-and-policy-authoring-standard.md`
Branch: `feature/procedure-and-policy-authoring-standard`

## Context

The protocol has no single authoring standard. The rules are spread across the common policy, the customization file, and the decision store. This plan implements the standard approved in grilling, applies it to `ai-policy-meta.md`, and adds a structure validator.

## Scope

In scope:

- Add `## Procedure and Policy Authoring` to `ai-policy-meta.md`.
- Rewrite `ai-policy-meta.md` to the standard.
- Add `support-files/validate-policy-authoring.sh`.
- Add the ADR entry.
- Replace the customization authoring rule with the approved pointer.
- Verify with markdownlint, shellcheck, both validators, and peer review.

Out of scope:

- Rename `ai-policy-meta.md` (separate ticket).
- Banned-modal and table validator checks (separate ticket).
- Trigger plugin model and heading JIT index (separate ticket).
- Bulk rewrite of the other 16 policies.
- Commit and merge (separate approval).

## HLD

### HLD-001: Authoring standard home

The standard lives in `ai-policy-meta.md` under `## Procedure and Policy Authoring`. The common policy gets no pointer. The meta policy is loaded through Active Expertise `meta` in Protocol Developer Mode.

### HLD-002: Normative vocabulary

The standard uses hard rules with the approved modal vocabulary. The common policy remains the owner of markdown mechanics and writing style. The standard points to it and does not repeat it.

### HLD-003: Meta policy structure

The rewritten policy uses `# AI Policy: Meta`, one purpose sentence, `## Scope`, `## Role`, `## Required Pre-action Checks`, `## Forbidden Actions`, `## Approval and Escalation`, `## Reporting and Logging`, `## Procedure and Policy Authoring`, and `## References`.

### HLD-004: Structure validator

`support-files/validate-policy-authoring.sh` takes file paths, checks required headings and procedure metadata, and exits non-zero on violations. It is separate from `validate-protocol.sh`, so the main 8/8 validator stays green before the corpus is migrated.

## LLD with AC

### LLD-001: Authoring standard section

- Add the approved section to `ai-policy-meta.md`.
- AC: The section contains the approved rules and no soft modals.

### LLD-002: Meta policy rewrite

- Preserve scope, role, pre-action checks, forbidden actions, approval, and references.
- Remove `## Purpose` and `## Suggested Assistant Prompt`.
- Replace the state-file update rule with reporting on the coordination board and writing state files only through PROCEDURE WRITE-CHECKPOINT.
- Replace the automatic pre-update backup with the explicit `"backup ai"` trigger.
- AC: Every normative bullet is one sentence in the imperative mood; the two stale rules are corrected; no current function is lost.

### LLD-003: Validator

- Create the script with these checks:
  - Policy title uses `# AI Policy:`; only `ai-policy-common.md` may use `# AI Assistant Policy:`.
  - A non-empty purpose line follows the title.
  - `## Scope` and `## References` exist.
  - At least one `##` section exists besides Scope, References, Purpose, and Notes.
  - `## Purpose` and `## Notes` do not exist.
  - For `AGENTS.md`, every `### PROCEDURE` header has an `**Aliases**` line.
  - `AGENTS.md` contains no `**Loads**` line.
  - Trigger phrases are unique across the passed files.
  - The validator rejects a `## Triggers` section until the plugin model lands.
- AC: The script passes on the changed files and fails on a fixture with a missing heading.

### LLD-004: ADR entry

- Append the approved entry to `design-docs/protocol-decisions.md`.
- AC: The entry is self-contained, has no commit hash or branch name, and records the two corrections.

### LLD-005: Customization pointer

- Replace the current `### Rule: Proactive removal of prose and rationale` block with the approved pointer.
- AC: The customization file contains only the pointer for this rule.

## Acceptance criteria mapping

- One ADR records the authoring decision and is self-contained. Maps to LLD-004.
- One authoritative standard exists and other rule homes point to it. Maps to LLD-001 and LLD-005.
- The standard defines the required heading and trigger shape. Maps to LLD-001.
- The next new procedure or policy follows it. Maps to LLD-002, with the meta policy as the first application.
- Validator and markdownlint stay green. Maps to LLD-003 and the verification step.

## Verification

- `markdownlint-cli2 ai/policies/ai-policy-meta.md design-docs/protocol-decisions.md ai/issues/in-progress/procedure-and-policy-authoring-standard.md ai/plans/procedure-and-policy-authoring-standard-plan.md`
- `bash -n support-files/validate-policy-authoring.sh` when `shellcheck` is unavailable.
- `./support-files/validate-policy-authoring.sh ai/policies/ai-policy-meta.md AGENTS.md`
- `./support-files/validate-policy-authoring.sh <malformed-fixture>` to confirm a non-zero exit.
- `./support-files/validate-protocol.sh`
- `bash support-files/test-protocol-references.sh`
- Peer review report with an APPROVED verdict.

## Risks

- The rewrite may drop a current rule. Mitigate by mapping each current section to the new structure and by peer review.
- The validator may be too strict for a policy passed later. Mitigate by scoping it to changed files and by allowing the common-policy title variant.
- The standard may duplicate common-policy rules. Mitigate by pointing to the common policy and by peer review.
- The ADR entry may grow beyond a decision. Mitigate by keeping it decision-only and self-contained.

## Rollback

- Revert the branch.
- Restore the customization rule from the approved replacement.
