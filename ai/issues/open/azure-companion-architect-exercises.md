Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Idea
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: A six-lab Azure and Bicep exercise pack under docs/exercises/ where sysadmins and cloud architects learn to use AI as a companion architect.

Description:

Goal: a hands-on lab pack where a sysadmin or cloud architect learns to use the AI as a companion architect to brief, design, plan, build, verify, and tear down a basic Azure setup. The learner owns the decisions and runs the changes; the AI proposes, reviews, and verifies.

Decisions locked in grilling (2026-11-26):

- Provider: Azure; infrastructure as code: Bicep.
- Location: `docs/exercises/azure-companion-architect/`, a self-contained subfolder. The protocol does not depend on the pack.
- Audience: a shared core plus two role capstones.
- Scope: six labs, with the first three shippable on their own as a design-only track.
- Distribution: public pack; the learner brings a sandbox subscription. No tenant IDs, org names, or prices.
- Money: no cost or pricing language in the pack; no budget alert, no cost-stop check, no cost criterion in Capstone B.
- Toolchain: the workflow clone with `AGENTS.md` and `ai-customization.md` is the supported path; a plain chat is a one-note reduced-safety fallback, not a second track.
- Workload: one small Linux VM in a VNet with an NSG, one storage account, and Azure Monitor metric alerts; one resource group.
- Deployment scope: resource-group scope; one RG per learner per lab; `az deployment group what-if` alone is the gate.
- Identity: learner `az login` plus a system-assigned managed identity for VM-to-storage; no service principal, no keys, no stored secrets.
- Fault injection: documented `az` and VM commands, the expected symptom, and an objective restored check.
- Evidence: the learner saves read-only output under `evidence/` in the exercise project; the AI reads the files, and pasting is the fallback. Every lab ends with a Verification block.
- Drift: pinned Bicep API versions; no CLI version minimums.
- Region and naming: learner-chosen region; a short random suffix plus the lab number; tags `purpose=exercise` and `lab=<n>`.
- RBAC: no stated required role; a troubleshooting box explains `AuthorizationFailed` and points to Owner or User Access Administrator.
- Time targets: labs 1-3 at 30 minutes, lab 4 at 45, each capstone at 60.
- Layout: `index.md`, `prerequisites.md`, `safety-and-teardown.md`, one file per lab, and a `reference/` answer key.
- Release: docs-only, no release; one README docs index line.

What "shared core plus two capstones" means:

- Shared core: everyone does the same labs on one small workload.
- Capstone: the final role-specific lab that integrates the core skills in a scenario that looks like the learner's real job.
- Capstone A, sysadmin: operate the workload. Deploy, monitor, diagnose a layered fault (an NSG rule plus a stopped service), repair, and verify the teardown.
- Capstone B, architect: extend the workload into a hub-spoke topology with a second workload. Choose the topology, write the Bicep, justify the security and operations trade-offs, and present the ADR. No cost argument.
- Teardown is a step in the build and capstone labs, not a separate lab; it is verified by an empty resource group.

Proposed labs:

1. Briefing: the AI interviews the learner and writes the requirements. No cloud resources.
2. Design: the AI proposes an HLD and an ADR; the learner reviews and decides.
3. Plan: the AI drafts the Bicep; the learner reviews it and runs a static build or lint when the CLI is available. No `what-if`, no resources created; the gate runs in lab 4.
4. Build and verify: the learner creates the RG, runs `az deployment group what-if` as the gate, deploys, saves the what-if, deployment, and resource output under `evidence/`, verifies tags and state, then deletes the RG and confirms it is empty.
5. Capstone A, sysadmin operations: deploy, monitor, run the documented fault commands, diagnose both faults from symptoms, repair, and verify the teardown.
6. Capstone B, architect design: hub-spoke topology with a second workload, Bicep, security and operations trade-offs, the ADR, and a peer-style review.

Safety model:

- The AI never holds Azure credentials and never runs a deployment or deletion. The learner runs `az deployment` and the teardown.
- A learner-owned sandbox subscription and a resource-group scope; no money language in the pack.
- No secrets in the repo; the learner uses `az login`, and the VM uses a system-assigned managed identity.
- The AI's Azure knowledge can drift; every lab has a Verification block, Bicep API versions are pinned, and the AI answers "not verified" until evidence is pasted or saved.

Open questions: none. Grilling on 2026-11-26 resolved every branch.

Remaining human decisions: `IssueType`, `Severity`, and `Size`; the AI estimate for `Size` is now XL.

Risks:

- The empty-resource-group teardown is the only spend guardrail, since all money language is removed; each build lab must require teardown proof.
- No stated Azure role will strand a Contributor-only learner at the managed-identity role assignment; the troubleshooting box is the only help.
- A hub-spoke Capstone B at 60 minutes is tight; cut it to one peer VNet and one peering if the lab overruns.

Draft acceptance criteria:

- The first three labs ship as a self-contained design-only track that creates no cloud resources.
- Each lab has a scenario, prerequisites, the human prompt, the approval gate, a Verification block, teardown where applicable, and a reflection.
- `az deployment group what-if` is the only deployment gate, and it runs in lab 4 after `az group create`; labs 1-3 make no deployment or what-if call.
- No secrets in the repo; no service principal; the learner uses `az login`; the VM uses a system-assigned managed identity.
- No cost or pricing language in the pack, including Capstone B.
- Capstone A's documented inject commands reproduce both faults, and the restored check is objective.
- The `reference/` core and hub-spoke templates match the labs and pass static checks; `az bicep build` runs when the CLI is present, otherwise it is reported `[PENDING]` because the protocol forbids installing tools.
- Teardown is verified by `az group show` returning not found or an empty group.
- Markdownlint is clean and every link resolves; the README docs index links the pack.
- No protocol policy or procedure depends on the pack; the change lands docs-only with no release.

---
2026-11-26
Filed from the sysadmin and cloud-architect exercise discussion. No secret or identifying name present.

---
2026-11-26
Grilled and scoped; nineteen decisions folded into the description. Changed from the draft: Capstone B is a hub-spoke extension with no cost criterion; all money language, the budget alert, and the cost-stop check are removed; a `reference/` answer key and an `evidence/` trail are added; the workflow-clone prerequisite is now a decision; an RBAC troubleshooting box replaces a stated role. AI `Size` estimate is XL; human to confirm. No plan yet.

---
2026-11-26
Plan written: `ai/plans/azure-companion-architect-exercises.md` (XL). Plan review next. The Bicep CLI is absent, so `az bicep build` is recorded as `[PENDING]`; the protocol forbids installing tools.

---
2026-11-26
Plan review-206 CHANGES REQUESTED (3 Major, 5 Minor), all fixed; review-207 APPROVED. Plan ready: `ai/plans/azure-companion-architect-exercises.md` (XL). No branch or implementation.

---
2026-11-26
Implementation preflight: a resource-group-scoped what-if needs an existing group, so the gate moves from lab 3 to lab 4; lab 3 is a static Bicep review. Plan amended (ADR-014); delta review-209 APPROVED. Labs 1-3 stay cloud-free.
