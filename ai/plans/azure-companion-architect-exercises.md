# Plan: Azure companion-architect exercise pack

## Goal

Ship a public, docs-only six-lab Azure and Bicep exercise pack under `docs/exercises/azure-companion-architect/` that teaches a sysadmin or cloud architect to use the AI as a companion architect to brief, design, plan, build, verify, repair, and tear down one small workload. The learner owns every decision and runs every `az` command. No protocol policy or procedure depends on the pack.

## Evidence

Sources read in full this session, with line counts:

- `ai/issues/open/azure-companion-architect-exercises.md`: 92 lines (after the grilling fold and the plan entry).
- `ai/policies/ai-policy-issue-management.md`: 156 lines.
- `ai/policies/ai-policy-design-docs.md`: 172 lines.
- `ai/policies/ai-policy-code-review.md`: 144 lines.
- `ai/policies/ai-policy-thinking-modes.md`: 53 lines.
- `ai/policies/ai-policy-knowledge.md`: 172 lines.
- `ai/policies/ai-policy-meta.md`: 212 lines.
- `ai/policies/ai-policy-common.md`: 698 lines.
- `ai/procedures/load-context.md`: 123 lines.
- `ai/knowledge/issue-template.md`: 56 lines.
- `ai/knowledge/release-practices.md`: 61 lines.
- `docs/example-learning-session-runbook.md`: 223 lines.
- `README.md`: 223 lines.
- `tests/run-all.sh`: 39 lines.
- `tests/test-docs-audit.sh`: 319 lines.
- `tests/test-readme-shape.sh`: 114 lines.
- `ai/issues/closed/team-skills-scope.md`: 414 lines (plan house style).

Confirmed facts:

- `docs/exercises/` does not exist. `docs/` holds flat guides plus topic subfolders (`announcements/`, `examples/`, `personas/`, `slides/`).
- The README docs index is `README.md` lines 200-221; the README is 223 lines and `tests/test-readme-shape.sh:45-50` caps it at 250 lines, so one added line is safe.
- `tests/test-readme-shape.sh:96-107` resolves every local README link, so the new pack link must point at a real file.
- The docs-only release rule: a docs-only change with no policy, procedure, trigger, or runtime behavior change may land without a release, and still runs markdownlint, the validators, and the suite (`ai/knowledge/release-practices.md:14,40`).
- `docs/example-learning-session-runbook.md` is prompt-first and teaches the workflow, not Azure. The pack must not repeat it.
- `az` is available at `/usr/bin/az`; `az bicep version` returns "Bicep CLI not found". The protocol forbids installing tools (`AGENTS.md` "No Tool Installation"), so `az bicep build` cannot be a passing gate. The reference templates get static checks, and the Bicep build is `[PENDING]` unless the CLI is already present.
- `az deployment group what-if --help` marks `--resource-group` as Required, and a resource-group-scoped what-if needs an existing group. Labs 1-3 create no resources, so the gate moves to lab 4 after the group is created; lab 3 does a static Bicep review.
- No `.bicep` file exists in the repo today.
- The default branch is `master`; the highest existing review number is 205, so the plan review is review-206.
- Current counts: 26 policies, 16 procedures, 55 triggers, 35 test scripts.
- `ai-customization.md` sets `**Merge Mode**: direct`, so the close sequence is a direct squash merge after approval.
- The ticket's draft AC said the reference templates must "pass `az bicep build`"; that is corrected in this plan and in the ticket to "static checks; `az bicep build` when the CLI is present, otherwise reported `[PENDING]`".

Grilling decisions, 2026-11-26 (folded into the ticket):

- Public pack under `docs/exercises/azure-companion-architect/`; learner-owned subscription; no tenant IDs, org names, or prices.
- No money language in the pack; no budget alert, no cost-stop check, no cost criterion in Capstone B.
- Workflow clone with `AGENTS.md` and `ai-customization.md` is the supported path; a plain chat is a reduced-safety note, not a second track.
- Workload: one small Linux VM, VNet, NSG, storage account, Azure Monitor metric alerts; one resource group; resource-group scope.
- `az deployment group what-if` alone is the deployment gate.
- Learner `az login` plus a system-assigned managed identity for VM-to-storage; no service principal, no keys, no stored secrets.
- Documented fault-injection commands with an expected symptom and an objective restored check.
- Evidence files under `evidence/`; a Verification block in every lab; pinned Bicep API versions; no CLI version minimums.
- Learner-chosen region; short random suffix plus lab number; tags `purpose=exercise` and `lab=<n>`.
- No stated Azure role; a troubleshooting box covers `AuthorizationFailed`.
- Time targets: labs 1-3 at 30 minutes, lab 4 at 45, each capstone at 60.
- Layout: `index.md`, `prerequisites.md`, `safety-and-teardown.md`, one file per lab, and a `reference/` answer key.
- Docs-only, no release; one README docs index line.

No open questions remain for this ticket.

## Depth

XL, so the plan carries an HLD, an LLD, acceptance criteria with a behavioral assertion each, plan-local ADRs, and a test plan. No new design-documents chain is created because this change touches no `AGENTS.md`, policy, or procedure; the ADRs stay plan-local. No entry is added to `design-docs/protocol-decisions.md`.

## Context

### HLD

Components:

1. **Pack index** `docs/exercises/azure-companion-architect/index.md`.
   - Audience, outcomes, the six-lab map, the two capstones, the time targets, and the order.
   - Entry and exit criteria for the whole pack.
2. **Prerequisites** `prerequisites.md`.
   - Workflow clone, `AGENTS.md` copy, `ai-customization.md`, an AI chat, an Azure account, Azure CLI, Bicep CLI (optional but recommended), a learner-chosen region, and an SSH key pair. The learner supplies the public key path; the private key stays on the learner's machine and is never committed.
   - The reduced-safety note for a plain chat.
   - The `az login` and `az account show` check.
3. **Safety and teardown** `safety-and-teardown.md`.
   - AI never holds credentials and never runs create or delete.
   - One resource group per lab; delete the group; verify it is empty.
   - The RBAC troubleshooting box for a Contributor-only learner.
   - The no-secrets rule and the evidence-file rule.
4. **Labs 1-3** `lab-01-briefing.md`, `lab-02-design.md`, `lab-03-plan.md`.
   - Design-only, zero cloud resources.
   - Lab 3 produces the Bicep draft and a static review only; no `what-if`, no deployment.
5. **Lab 4** `lab-04-build-verify-teardown.md`.
   - Deploy the core, save evidence, verify tags and state, delete the group, confirm it is empty.
6. **Capstone A** `lab-05-capstone-sysadmin.md`.
   - Deploy, monitor, inject the layered fault, diagnose two findings from symptoms, repair, verify, tear down.
7. **Capstone B** `lab-06-capstone-architect.md`.
   - Extend to hub-spoke with a second workload, write the Bicep, argue the security and operations trade-offs in an ADR, peer-style review, tear down.
8. **Reference answer key** `reference/core.bicep` and `reference/hub-spoke.bicep`.
   - Parameterized, API versions pinned, `targetScope = 'resourceGroup'`, no secrets, no names.
   - Used only after the learner's attempt.

Boundaries:

- The pack is user-facing docs and Bicep. It adds no policy, procedure, trigger, script, or skill.
- It does not modify `AGENTS.md`, `ai/policies/`, or `ai/procedures/`. The state files change only through the checkpoint at implementation.
- The AI reads pasted or saved evidence; it never authenticates to Azure.
- The pack ships with no release, announcement, banner change beyond the docs index line, tag, or GitHub Release.
- No money language anywhere in the pack, including headings, examples, and troubleshooting.

Data flow:

- The learner clones the workflow, creates an exercise project with `AGENTS.md` and `ai-customization.md`, and runs the labs with the AI.
- The AI interviews and drafts; the learner reviews and runs `az`; the learner saves output under `evidence/`; the AI verifies against the files and says "not verified" when evidence is missing.
- The learner deletes the resource group; the empty-group check is the teardown proof.

### LLD

File layout under `docs/exercises/azure-companion-architect/`:

- `index.md`
- `prerequisites.md`
- `safety-and-teardown.md`
- `lab-01-briefing.md`
- `lab-02-design.md`
- `lab-03-plan.md`
- `lab-04-build-verify-teardown.md`
- `lab-05-capstone-sysadmin.md`
- `lab-06-capstone-architect.md`
- `reference/core.bicep`
- `reference/hub-spoke.bicep`

Common lab shape (every lab file):

- One H1 with the lab number and a short title.
- `## Scenario`
- `## Prerequisites`
- `## What you will decide`
- `## The prompt`
- `## Approval gate`
- `## Verification`
- `## Teardown` (labs 4-6 only)
- `## Reflection`

Content rules:

- Lab 1: the AI interviews the learner and writes requirements. No `az` command, no cloud resource.
- Lab 2: the AI proposes an HLD and an ADR; the learner decides. No `az` command that creates a resource.
- Lab 3: the AI drafts Bicep; the learner reviews it and runs `az bicep build` or `bicep lint` when the CLI is present, otherwise a written review checklist. No `what-if` and no deployment; the gate runs in lab 4. The lab names the evidence file.
- Lab 4: `az group create`, then the `az deployment group what-if` gate, then `az deployment group create`, read-only `az` verification, `az group delete`, and `az group show` to prove the group is gone or empty. The learner supplies the SSH public key and keeps the private key local. The VM uses a system-assigned managed identity; a role assignment grants it storage read; a troubleshooting box covers `AuthorizationFailed`.
- Lab 5: the same core, then documented inject commands (an NSG rule change and a stopped service), the expected symptom, two required findings, a repair, and the restored check. Teardown follows.
- Lab 6: a second VNet, a peering, and a second workload; a design ADR; a peer-style review; teardown covers both VNets and the group.
- Labs 4-6 list the exact read-only `az` commands and the expected evidence file. Labs 1-3 verify the design artifacts (requirements, HLD, ADR, Bicep draft) against the lab's checklist. No "check the portal" step.
- Every lab ends with a short reflection prompt.

Reference Bicep rules:

- `targetScope = 'resourceGroup'`.
- Parameters: `location`, `nameSuffix`, `adminUsername`, `sshPublicKey`. No defaults for secrets; the learner supplies an SSH public key path and never commits the private key.
- The storage account name is `st` plus the lowercase alphanumeric `nameSuffix`, 3-24 characters total; validate the suffix and fail the deployment with a clear message when it is invalid or already taken.
- Resources: VNet, subnet, NSG with 22 and 80, public IP, NIC, Ubuntu VM with a system-assigned identity, storage account, role assignment for the identity, and metric alerts.
- Every `apiVersion` is a pinned literal.
- `hub-spoke.bicep` adds a second VNet, a peering pair, and a second small workload.
- No output prints a key or a secret.
- No tenant ID, subscription ID, price, or identifying name in either file.

README delta:

- Add one line to the "Docs and slides" list: the pack index link.

Test delta:

- Add `tests/test-azure-exercises.sh`; `tests/run-all.sh` discovers it, so the suite count goes from 35 to 36.

Build order:

1. Prerequisites and safety pages.
2. Labs 1-3.
3. Reference core Bicep.
4. Lab 4.
5. Capstone A and the fault commands.
6. Reference hub-spoke Bicep.
7. Capstone B.
8. Index and the README line.
9. The test script.

## Decisions (ADR)

### ADR-001: A public, user-facing pack under docs/

- **Decision**: Ship the pack in `docs/exercises/azure-companion-architect/`, public, with no tenant IDs, org names, or prices.
- **Context**: The repo is public and the learner brings their own subscription.
- **Consequences**: Every example uses placeholders; the test bans identifying and cost language.

### ADR-002: No money language in the pack

- **Decision**: Remove cost, pricing, budget, and cost-trade-off content entirely; no budget alert and no cost-stop check. Teardown is verified by an empty resource group.
- **Context**: The user chose "drop cost entirely" and "remove all money talk" during grilling.
- **Consequences**: The empty-group teardown is the only spend guardrail; the test greps for cost terms. Capstone B argues security and operations only.

### ADR-003: `what-if` alone is the deployment gate

- **Decision**: `az deployment group what-if` is the only gate before a deployment; no human checklist.
- **Context**: The user chose the fastest gate during grilling.
- **Consequences**: The pack does not check cost or policy drift before apply; the Verification block and teardown proof carry the safety.

### ADR-004: Workflow clone is the supported path

- **Decision**: Require the workflow clone with `AGENTS.md` and `ai-customization.md`; a plain chat is a reduced-safety note, not a second track.
- **Context**: The gates and the "AI proposes, learner runs" split are the teaching content.
- **Consequences**: One prerequisites path to maintain; one warning paragraph for other assistants.

### ADR-005: One Linux VM stack in one resource group

- **Decision**: A VM, VNet, NSG, storage account, and metric alerts in one resource group at resource-group scope.
- **Context**: The sysadmin capstone needs a real service to break and repair; the architect capstone needs topology to extend.
- **Consequences**: Teardown is one group delete; the hub-spoke capstone still fits one group.

### ADR-006: Managed identity, no service principal

- **Decision**: Learner `az login` plus a system-assigned managed identity for VM-to-storage; no service principal, no keys.
- **Context**: The AI never holds credentials, so automation credentials add risk without teaching value.
- **Consequences**: One role assignment step; the RBAC troubleshooting box handles a Contributor-only learner.

### ADR-007: Documented fault injection

- **Decision**: The capstone gives the exact `az` and VM commands for the fault, the expected symptom, and the objective restored check.
- **Context**: The AI cannot run commands, and the fault must be reproducible.
- **Consequences**: The inject commands are static text; the learner runs them; the AI reads the evidence.

### ADR-008: Evidence files and a Verification block

- **Decision**: The learner saves read-only output under `evidence/`; every lab has a Verification block; the AI says "not verified" until evidence arrives; Bicep API versions are pinned.
- **Context**: The AI has no credentials and can drift on provider behavior.
- **Consequences**: A durable learner trail; the test checks that every lab has the block.

### ADR-009: Reference answer key

- **Decision**: Ship `reference/core.bicep` and `reference/hub-spoke.bicep` as an answer key used after the learner's attempt.
- **Context**: A public pack needs a known-good template for maintenance and checking; the AI still drafts in the flow.
- **Consequences**: Two more files to maintain; the test checks their static shape.

### ADR-010: Docs-only, no release

- **Decision**: Land the pack as a docs-only change with no release, announcement, tag, or banner beyond the docs index line.
- **Context**: The user chose docs-only; the release-practices rule permits it.
- **Consequences**: No version bump; the suite, validators, and markdownlint still run before the merge.

### ADR-011: No stated Azure role

- **Decision**: State no required role; on `AuthorizationFailed`, a troubleshooting box explains the cause and points to Owner or User Access Administrator.
- **Context**: The user chose no stated role.
- **Consequences**: Some Contributor-only learners stop at the role assignment; the box is the only help.

### ADR-012: Short time targets

- **Decision**: Labs 1-3 at 30 minutes, lab 4 at 45, each capstone at 60, stated as targets.
- **Context**: The user chose short budgets.
- **Consequences**: Capstone B is tight; the plan allows cutting it to one peer VNet and one peering.

### ADR-013: No CLI version minimums

- **Decision**: Do not state Azure CLI or Bicep CLI version minimums; the Verification block catches behavior drift.
- **Context**: The user chose no version detail.
- **Consequences**: Weaker reproducibility; the exact read-only commands in the Verification block are mandatory.

### ADR-014: The what-if gate runs in lab 4

- **Decision**: Lab 3 does a static Bicep review; `az deployment group what-if` runs in lab 4 after `az group create` and before the deployment.
- **Context**: A resource-group-scoped what-if needs an existing resource group, and labs 1-3 create no resources.
- **Consequences**: Labs 1-3 stay cloud-free; the gate moves one lab later but is unchanged in substance.

## Deltas

New files:

- `docs/exercises/azure-companion-architect/index.md`
- `docs/exercises/azure-companion-architect/prerequisites.md`
- `docs/exercises/azure-companion-architect/safety-and-teardown.md`
- `docs/exercises/azure-companion-architect/lab-01-briefing.md`
- `docs/exercises/azure-companion-architect/lab-02-design.md`
- `docs/exercises/azure-companion-architect/lab-03-plan.md`
- `docs/exercises/azure-companion-architect/lab-04-build-verify-teardown.md`
- `docs/exercises/azure-companion-architect/lab-05-capstone-sysadmin.md`
- `docs/exercises/azure-companion-architect/lab-06-capstone-architect.md`
- `docs/exercises/azure-companion-architect/reference/core.bicep`
- `docs/exercises/azure-companion-architect/reference/hub-spoke.bicep`
- `tests/test-azure-exercises.sh`

Modified files:

- `README.md`: one docs index line.
- `ai/issues/open/azure-companion-architect-exercises.md`: a dated plan entry, then the plan appendix at close.
- `tests/test-docs-audit.sh`: not modified; the pack test stays separate. Only add a link assertion there if the README check does not cover it.

Unchanged: `AGENTS.md`, `ai/policies/`, `ai/procedures/`, the customization file, and every trigger and policy count. The state files change only through the checkpoint at implementation.

## Acceptance Criteria

- **AC-001**: All eleven pack files exist.
  - Assertion: `tests/test-azure-exercises.sh` fails on a missing file with `test -f` for each path.
- **AC-002**: Labs 1-3 create no Azure resources.
  - Assertion: the test fails if `lab-01`, `lab-02`, or `lab-03` contains `az deployment group create`, `az group create`, or `az deployment group what-if`.
- **AC-003**: Every lab has the common sections.
  - Assertion: the test greps each lab for `## Scenario`, `## Prerequisites`, `## The prompt`, `## Verification`, and `## Reflection`; labs 4-6 also need `## Teardown`.
- **AC-004**: No money language in the pack.
  - Assertion: `grep -riE '\b(cost|costs|pricing|price|prices|budget|usd|dollar)\b'` over the pack returns nothing; the test also rejects `$` followed by a digit, and a subscription or tenant GUID pattern.
- **AC-005**: No secrets or credentials in the pack.
  - Assertion: the test rejects `client_secret`, `accountKey`, `connectionString`, and `BEGIN OPENSSH PRIVATE KEY` case-insensitively, plus any `*.pem` file.
- **AC-006**: The README links the pack and the link resolves.
  - Assertion: `grep -F 'docs/exercises/azure-companion-architect/' README.md` matches, and `tests/test-readme-shape.sh` passes.
- **AC-007**: The reference Bicep has the required static shape.
  - Assertion: the test greps `targetScope = 'resourceGroup'`, confirms the count of `apiVersion:` lines is at least the count of resource declaration lines, and requires `Microsoft.Compute/virtualMachines`, `Microsoft.Storage/storageAccounts`, and `Microsoft.Network/networkSecurityGroups`; the hub-spoke file needs two `Microsoft.Network/virtualNetworks` and a `virtualNetworkPeerings` resource. If `az bicep build` is available the test runs it; otherwise it prints `[PENDING] Bicep CLI not installed` and does not fail.
- **AC-008**: Labs 4-6 teach teardown and prove it.
  - Assertion: each contains `az group delete` and `az group show`; the test fails when either is missing.
- **AC-009**: Capstone A has a reproducible fault and an objective restore.
  - Assertion: the test greps `nsg rule` and `systemctl stop` (or the chosen service command) in lab 5, plus `## Restored check`.
- **AC-010**: Capstone B is hub-spoke with an ADR and no cost term.
  - Assertion: lab 6 contains `hub`, `peering`, and `ADR`; AC-004 already bans cost terms.
- **AC-011**: Markdownlint is clean on the pack.
  - Assertion: `markdownlint-cli2 'docs/exercises/azure-companion-architect/**/*.md'` reports 0 issues.
- **AC-012**: The suite and validators pass, and no protocol file changed.
  - Assertion: `bash tests/run-all.sh` reports 36/36; `bash support-files/validate-protocol.sh` reports 8/8; `git diff --name-only` against the base shows no `AGENTS.md`, `ai/policies/`, or `ai/procedures/` path.
- **AC-013**: The change is docs-only.
  - Assertion: no `docs/announcements/*` entry, no tag, and no GitHub Release for this change; the close sequence records `release: none`.
- **AC-014**: The pack does not duplicate the learning runbook.
  - Assertion: the test fails if a lab file contains `bootstrap using AGENTS.md protocol` or `minimalistic CSS`, and `index.md` must contain a link whose target resolves to `docs/example-learning-session-runbook.md` (from the pack index, `../../example-learning-session-runbook.md`).

## Verification

Commands, run in this order:

1. `bash tests/test-azure-exercises.sh` (the new fixture).
2. `bash tests/run-all.sh` (expect 36/36).
3. `bash support-files/validate-protocol.sh` (expect 8/8).
4. `~/.nvm/versions/node/v24.19.0/bin/markdownlint-cli2 'docs/exercises/azure-companion-architect/**/*.md'` (expect 0 issues).
5. `shellcheck` is not needed for docs; run it only if a shell helper is added (it is not planned).
6. `az bicep build --file docs/exercises/azure-companion-architect/reference/core.bicep` and the hub-spoke file: `[PENDING]` because the Bicep CLI is not installed. Record the exact error in the close evidence; do not install it.
7. Manual read of the two capstones against the ticket's acceptance criteria.

The new fixture `tests/test-azure-exercises.sh`:

- Use the house helpers `pass`, `fail_case`, `present`, `absent`, and a `require_file` helper.
- Resolve `ROOT` from the script location, as the other fixtures do.
- Check the eleven files, the lab sections, the no-deploy rule in labs 1-3, the cost and secret bans, the README link, the teardown commands, the fault commands, the hub-spoke terms, and the runbook-duplication ban.
- Run the reference Bicep static checks and the optional `az bicep build`.
- Print `PASSED: Azure exercise pack fixture (...)` on success and exit 1 on any failure.

## Peer Review Log

- Plan round 1: CHANGES REQUESTED, `ai/code-review-reports/2026-11-26_21-45_review-206.md`; 3 Major (state-file contradiction, missing SSH-key prerequisite, Verification scope) and 5 Minor (AC-007 assertion, ticket line count, secret grep and GUID check, runbook link check, storage-name formula); all fixed.
- Plan round 2: APPROVED, `ai/code-review-reports/2026-11-26_21-46_review-207.md`; no Critical, Major, or Minor; two suggestions declined with reasons.
- Plan round 3 (delta): APPROVED, `ai/code-review-reports/2026-11-26_21-46_review-208.md`; one lint-only rewording in AC-007 after the approval; no semantic change.
- Plan round 4 (delta): APPROVED, `ai/code-review-reports/2026-11-26_21-47_review-209.md`; the what-if gate moves to lab 4 (ADR-014), and labs 1-3 stay cloud-free.

## Risks and Rollback

- **Empty-group teardown is the only spend guardrail** (ADR-002). Mitigation: lab 4, 5, and 6 require `az group show` proof; the test enforces the commands.
- **A Contributor-only learner stops at the role assignment** (ADR-011). Mitigation: the troubleshooting box.
- **`what-if` alone misses policy and cost problems** (ADR-003). Mitigation: the Verification block and the teardown proof.
- **Capstone B overruns 60 minutes** (ADR-012). Mitigation: cut to one peer VNet and one peering if needed.
- **Azure behavior drifts from the static text** (ADR-013). Mitigation: pinned API versions, exact read-only commands, "not verified" discipline.
- **Reference Bicep is unvalidated** because the CLI is absent. Mitigation: static checks now, `[PENDING]` recorded, a maintainer with the CLI runs the build later.

Rollback: revert the single docs-only commit. No runtime, policy, or state impact.

## Close Sequence

- **Repo**: `/home/kamran/Projects/Personal/Simple-AI-Workflow`.
- **Base ref**: `master`.
- **Branch**: `feature/azure-companion-architect-exercises`, created at implementation.
- **Baseline**: commit the plan and the updated ticket as the planning chore baseline before opening the branch.
- **Merge mode**: direct (from `ai-customization.md` `## Merge Policy`); squash merge, delete the branch, push.
- **Protected branch**: explicit approval before the merge to `master`.
- **Ticket**: `open/` to `in-progress/` at implementation; to `closed/` in the branch commit; attach this plan under `## Implementation Plan` before deleting the plan file.
- **Checkpoint**: run on the branch before the commit.
- **Release**: none. No announcement, no banner change beyond the docs index line, no tag, no GitHub Release.
- **Evidence**: `tests/test-azure-exercises.sh`, `tests/run-all.sh` 36/36, `validate-protocol.sh` 8/8, markdownlint 0 on the pack, and the `[PENDING]` Bicep CLI note.
- **Post-merge**: no commits and no repository changes.
