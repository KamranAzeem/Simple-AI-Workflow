# Plan: Protocol Validation & Maintenance System

## Objective
Establish a permanent testing and maintenance system for the AGENTS.md bootstrap and AI policy protocols. This plan serves as both an initial dry run and a blueprint for ongoing protocol integrity.

## Proposed Strategy
1. **Bootstrap & Compliance Verification**:
   - Verify the existence and readability of all core and common policy files (`ai/policies/`).
   - Confirm directory structure adherence.
2. **Context & State Integrity**:
   - Verify readability and format of tracking files (`next-steps.md`, `progress.md`, `context.md`).
   - Validate checkpointing capability (create/delete `CP-DRY-RUN.md`).
3. **Linting & Formatting Checks**:
   - Run `markdownlint` on all policy files to ensure structural consistency and compliance with documentation standards.

## Permanent Testing Location
- This protocol validation suite will be implemented as a script and stored in `support-files/validate-protocol.sh`.
- The plan file itself will be moved to `docs/protocol-validation-system.md` for permanent reference.

## Implementation Steps
- **Step 1**: Create `docs/protocol-validation-system.md` from this plan.
- **Step 2**: Create `support-files/validate-protocol.sh` that implements:
    - Path existence checks for all mandatory policies.
    - Integration of `markdownlint` checks for policies.
    - Temporary checkpoint cycle (create/verify/delete).
- **Step 3**: Execute the new validation script and report results.

## Verification
- Success will be defined as:
  - All policy files present and readable.
  - All files passing `markdownlint` (or documented exceptions).
  - Checkpoint cycle successfully completed.
