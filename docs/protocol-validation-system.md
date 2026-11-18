# Protocol Validation & Maintenance System

## Objective

This document describes the permanent testing and maintenance system for the [`AGENTS.md`](../AGENTS.md) bootstrap and AI policy protocols. It serves as a reference blueprint for ongoing protocol integrity.

## Strategy

1. **Bootstrap & Compliance Verification**:
   - Verify the existence and readability of all core and common policy files (`ai/policies/`).
   - Verify the 14 procedure modules in `ai/procedures/`, the thin `AGENTS.md`, and the boot-payload size targets.
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

- A directory scan of `ai/policies/ai-policy-*.md` with a floor of 23; every file must carry the guard markers.
- Integration of `markdownlint` checks for policies.
- Temporary checkpoint cycle (create/verify/delete).
- Anchor checks for the shared index step, the dispatch section, the procedure modules, and the protocol index report item.
- The thin-`AGENTS.md` size check and the procedure-store anchors.
- Trigger declaration checks in `support-files/validate-policy-authoring.sh`: shape, placement, ASCII phrases, cross-module duplicates and containment, policy names, procedure-module names, the `#N` procedure trigger, and the thin-`AGENTS.md` shape.
- Loading declaration checks in the same validator: one optional `## Loading` section, its placement, the four modes, the trigger and `Load in` relations, and named errors for every invalid form.
- A `--triggers` mode that runs the namespace check over the full policy and procedure set, plus a fixture test at `tests/test-trigger-rules.sh`. The fixture includes a fence-aware regression that a fenced example heading is not indexed as a policy heading.
- A developer `--index` oracle: `support-files/validate-policy-authoring.sh --index` prints one read-only module line per policy and procedure, including the declared loading mode (`mode=legacy` when absent) and the scope (`global` or `project`), then a summary with module counts, trigger count, conflict count, error count, and error classes. It exits 0 when the index is produced, even with existing shape gaps; it exits non-zero only for an unreadable module, an invalid trigger block, an invalid loading block, or a name mismatch. It is a Protocol Developer Mode tool; the end-user AI builds the index inline and never runs it. On the current distribution, `--index` reports 0 errors and exits 0.
- A boot-discovery fixture at `tests/test-load-context-boot.sh`: canaries in every excluded path, 1,000 artifact and knowledge files, a project and global skill package, the 16 KB bound, the single checkpoint read, and the index oracle.
- A skills fixture at `tests/test-skills-index.sh`: the two roots, the package shape and frontmatter, the one-level rule, hidden and symlink skip, the project override, the cross-type collision report, the 200-character description, the no-body rule, and the 16 KB bound.
- Knowledge-rule anchors and a legacy-phrase guard across the knowledge policy, the repair module, the workflow guide, the README, and the slides, plus a rebuilt knowledge-repair fixture at `tests/test-knowledge-repair-fixture.sh`: the topic split, the 3,000-byte merge, the 49/50/51-file reviews, the template and ticket exclusions, evidence deletion, deduplication, the pointer report, and retirement.
- The reference test at `tests/test-protocol-references.sh` reads `ai/procedures/*.md` for procedure and step definitions and the order-conformance check.
- A sync-script fixture at `tests/test-sync-agents-md.sh` covers the customization, exclusion, and failure paths.
- An outbound content scrub fixture at `tests/test-outbound-content-scrub.sh` covers the Class A and Class B fixtures, the placeholders, the private-IP exception, the common invariant, the plug-in rules, the trigger and trigger mode, and the three procedure loads.
- A handoff fixture at `tests/test-create-handoff.sh` covers the policy template, the procedure triggers and steps, the valid draft, the incomplete draft, and the final handoff.
- A load-path fixture at `tests/test-policy-load-paths.sh` covers the four modes, every named loading error, placement, duplicate sections, absent declarations, `Load in` resolution, policy names inside procedures, and the index mode and scope.
- A shape wrapper at `tests/test-policy-shape.sh` runs the authoring validator over every policy, procedure, and `AGENTS.md`, and proves a broken fixture fails. `tests/run-all.sh` runs every test script.
- A boundary fixture at `tests/test-common-boundary.sh` pins the common title, the two-bullet Reference whitelist, the no-policy-name rule outside the canonical header blocks, the handoff pointer removal, and the old-title rejection.
- An issue-policy fixture at `tests/test-issue-policy.sh` pins the common issue invariant, both triggers, the trigger mode, the template rule and its conditional load, and the two procedure loads.
- A design-docs fixture at `tests/test-design-docs-policy.sh` pins the common design invariant, the procedure loading, the merged chain and depth rules, the ID and ledger rules, the plan-location rule, and the planning and pre-work loads.
- A thinking-modes fixture at `tests/test-thinking-modes-policy.sh` pins the common invariant, both triggers, the trigger mode, the moved modes, the Pre-Work Gate pointer, and the two procedure loads.
- A Linux-policy fixture at `tests/test-linux-policy.sh` pins the expertise loading and the key Linux rule anchors; the rewrite itself is checked by the prose and coverage review.
- An accounting-policy fixture at `tests/test-accounting-policy.sh` pins the expertise loading, the key accounting rule anchors, and the non-normative example rule; the rewrite itself is checked by the prose and coverage review.
- A career-policy fixture at `tests/test-career-policy.sh` pins the expertise loading, the hybrid role, the key coaching anchors, and the non-normative examples; the rewrite itself is checked by the prose and coverage review.
- A Windows-policy fixture at `tests/test-windows-policy.sh` pins the expertise loading and the key framework, PowerShell, identity, hardening, and testing anchors; the rewrite itself is checked by the prose and coverage review.
- An academic-policy fixture at `tests/test-academic-policy.sh` pins the expertise loading, the section map, the framework and integrity anchors, the nine process stages, the three supervision checkpoints, and the removed changelog appendix; the rewrite itself is checked by the prose and coverage review.
- The validator's own `v6.3` label is the script's label, not the workflow release.

## Verification Criteria

Success is defined as:

- All policy files present and readable.
- All files passing `markdownlint` (or documented exceptions).
- Checkpoint cycle successfully completed.
