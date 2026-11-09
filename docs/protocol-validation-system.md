# Protocol Validation & Maintenance System

## Objective

This document describes the permanent testing and maintenance system for the [`AGENTS.md`](../AGENTS.md) bootstrap and AI policy protocols. It serves as a reference blueprint for ongoing protocol integrity.

## Strategy

1. **Bootstrap & Compliance Verification**:
   - Verify the existence and readability of all core and common policy files (`ai/policies/`).
   - Verify the 13 procedure modules in `ai/procedures/`, the thin `AGENTS.md`, and the boot-payload size targets.
   - Confirm directory structure adherence.
2. **Context & State Integrity**:
   - Verify readability and format of tracking files (`ai/state/next-steps.md`, `ai/state/progress.md`, `ai/state/context.md`).
   - Validate checkpointing capability (create/verify/delete `CP-DRY-RUN.md`).
3. **Linting & Formatting Checks**:
   - Run `markdownlint` on all policy files to ensure structural consistency and compliance with documentation standards.

## Permanent Testing Location

- The validation suite is implemented as a script at [`support-files/validate-protocol.sh`](../support-files/validate-protocol.sh).
- This document serves as the permanent reference for the validation system.

## Implementation

The validation script [`support-files/validate-protocol.sh`](../support-files/validate-protocol.sh) implements:

- Path existence checks for all mandatory policies.
- Integration of `markdownlint` checks for policies.
- Temporary checkpoint cycle (create/verify/delete).
- Anchor checks for the shared index step, the dispatch section, the procedure modules, and the protocol index report item.
- The thin-`AGENTS.md` size check and the procedure-store anchors.
- Trigger declaration checks in `support-files/validate-policy-authoring.sh`: shape, placement, ASCII phrases, cross-module duplicates and containment, policy names, procedure-module names, the `#N` procedure trigger, and the thin-`AGENTS.md` shape.
- A `--triggers` mode that runs the namespace check over the full policy and procedure set, plus a fixture test at `support-files/test-trigger-rules.sh`.
- The reference test reads `ai/procedures/*.md` for procedure and step definitions and the order-conformance check.
- The validator's own `v6.1` label is the script's label, not the workflow release.

## Verification Criteria

Success is defined as:

- All policy files present and readable.
- All files passing `markdownlint` (or documented exceptions).
- Checkpoint cycle successfully completed.
