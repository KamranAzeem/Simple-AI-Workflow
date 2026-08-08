# Protocol Validation & Maintenance System

## Objective
This document describes the permanent testing and maintenance system for the [`AGENTS.md`](../AGENTS.md) bootstrap and AI policy protocols. It serves as a reference blueprint for ongoing protocol integrity.

## Strategy
1. **Bootstrap & Compliance Verification**:
   - Verify the existence and readability of all core and common policy files (`ai/policies/`).
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

## Verification Criteria
Success is defined as:
- All policy files present and readable.
- All files passing `markdownlint` (or documented exceptions).
- Checkpoint cycle successfully completed.
