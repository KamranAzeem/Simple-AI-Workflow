Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Idea
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: L)
Label:
URL:
Summary: A six-lab Azure and Bicep exercise pack under docs/exercises/ where sysadmins and cloud architects learn to use AI as a companion architect.

Description:

Goal: a hands-on lab pack where a sysadmin or cloud architect learns to use the AI as a companion architect to brief, design, plan, build, verify, and tear down a basic Azure setup. The learner owns the decisions and runs the changes; the AI proposes, reviews, and verifies.

Decisions already made:

- Provider: Azure.
- Infrastructure as code: Bicep.
- Location: `docs/exercises/`, user-facing docs. The protocol does not depend on the pack.
- Audience: a shared core plus two role capstones.
- Scope: six labs, with the first three shippable on their own.

What "shared core plus two capstones" means:

- Shared core: everyone does the same labs on one small workload.
- Capstone: the final role-specific lab that integrates the core skills in a scenario that looks like the learner's real job.
- Capstone A, sysadmin: operate the workload. Deploy, monitor, diagnose a break, repair, and tear down.
- Capstone B, architect: design the workload. Choose the topology, write the Bicep, justify the cost and security trade-offs, and present the ADR.
- Teardown is a step in the build and capstone labs, not a separate lab.

Proposed labs:

1. Briefing: the AI interviews the learner and writes the requirements. No cloud, no cost.
2. Design: the AI proposes an HLD and an ADR; the learner reviews and decides.
3. Plan: the AI drafts the Bicep; `az deployment group what-if` is the approval gate. No resources created.
4. Build and verify: the learner deploys; the AI verifies the outputs, tags, and state; the learner tears down.
5. Capstone A, sysadmin operations: deploy, monitor, diagnose a simulated break, repair, and verify the teardown.
6. Capstone B, architect design: topology, Bicep, cost and security trade-offs, the ADR, and a peer-style review.

Safety model:

- The AI never holds Azure credentials and never runs a deployment or deletion. The learner runs `az deployment` and the teardown.
- A sandbox subscription with a budget alert and a resource-group scope.
- No secrets in the repo; use the CLI profile or environment, and managed identity in the labs.
- The AI's Azure knowledge can drift; every claim is verified against the live `az`/Bicep output and the provider docs.

Open questions for grilling:

- The sandbox subscription, budget ceiling, and who pays for the labs.
- The Bicep deployment scope: resource group or subscription, and whether `what-if` alone is the gate.
- The shared workload: which small, low-cost Azure stack (for example, a web app plus a database, or a VM plus storage).
- The two capstone scenarios and their cost and time budgets.
- Learner prerequisites: Azure CLI, Bicep CLI, an Azure account, and the workflow clone.
- Identity and secrets: managed identity only, or a service principal for the automation.
- Teardown verification and the cost-stop check.
- How the AI is kept honest about provider drift.
- Docs structure: one file per lab, a shared prerequisites page, and the README docs index link.
- Whether the pack ships with a release or lands as docs-only.

Draft acceptance criteria:

- The first three labs ship as a self-contained design-only track with no cloud cost.
- Each lab has a scenario, prerequisites, the human prompt, the approval gate, verification, teardown where applicable, and a reflection.
- No secrets in the repo; the AI never holds credentials or executes create or delete.
- Markdownlint is clean and every link resolves; the README docs index links the pack.
- No protocol policy or procedure depends on the pack.

---
2026-11-26
Filed from the sysadmin and cloud-architect exercise discussion. No secret or identifying name present.
