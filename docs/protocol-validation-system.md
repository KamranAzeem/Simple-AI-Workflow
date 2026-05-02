# Plan: Protocol Validation & Maintenance System

## Objective
Establish a permanent testing and maintenance system for the AGENTS.md bootstrap and AI policy protocols. This plan serves as both an initial dry run and a blueprint for ongoing protocol integrity.

## Proposed Strategy
1. **Bootstrap & Compliance Verification**:
   - Verify the existence and readability of all core, common, and compliance policy files (`ai/policies/` and `ai/policies/compliance/`).
   - Confirm directory structure adherence.
2. **Context & State Integrity**:
   - Verify readability and format of tracking files (`next-steps.md`, `progress.md`, `context.md`).
   - Validate checkpointing capability (create/delete `CP-DRY-RUN.md`).
3. **Linting & Formatting Checks**:
   - Run `markdownlint` on all policy files to ensure structural consistency and compliance with documentation standards.
   - Validate policy header metadata (Created-by, Updated-by, Last modified, Intent).

## Permanent Testing Location
- This protocol validation suite will be implemented as a script and stored in `support-files/validate-protocol.sh`.
- The plan file itself will be moved to `docs/protocol-validation-system.md` for permanent reference.

## Implementation Steps
- **Step 1**: Create `docs/protocol-validation-system.md` from this plan.
- **Step 2**: Create `support-files/validate-protocol.sh` that implements:
    - Path existence checks for all mandatory policies and compliance files.
    - Readability checks using `cat`.
    - Metadata header parsing to verify existence of required fields.
    - Integration of `markdownlint` checks for policies.
    - Temporary checkpoint cycle (create/verify/delete).
- **Step 3**: Execute the new validation script and report results.

## Verification
- Success will be defined as:
  - All policy/compliance files present and readable.
  - All files passing `markdownlint` (or documented exceptions).
  - All metadata headers confirmed present and valid.
  - Checkpoint cycle successfully completed.
