# Azure companion-architect exercises

This pack teaches you to use the AI as a companion architect for one small Azure workload. You make the decisions and run the commands. The AI interviews, drafts, reviews, and verifies against the evidence you save.

## Who this is for

- A sysadmin who operates Azure workloads.
- A cloud architect who designs them.
- You know the shell Git basics. No Azure experience is needed beyond the prerequisites.

## How the pack works

- The shared core is four labs on one small Linux workload.
- Two capstones follow: one for operations and one for design.
- Labs 1-3 are design-only and make no Azure call.
- Lab 4 creates the resource group and makes the first Azure call.
- Every lab ends with a Verification block and a reflection.

## Labs

1. [Briefing](lab-01-briefing.md): the AI interviews you and writes the requirements. 30 minutes.
2. [Design](lab-02-design.md): the AI proposes an HLD and an ADR; you decide. 30 minutes.
3. [Plan](lab-03-plan.md): the AI drafts the Bicep; you review it statically. 30 minutes.
4. [Build, verify, and tear down](lab-04-build-verify-teardown.md): the what-if gate, the deployment, the checks, and the empty resource group. 45 minutes.
5. [Capstone A: sysadmin](lab-05-capstone-sysadmin.md): operate the workload, diagnose a layered fault, repair it, and prove the teardown. 60 minutes.
6. [Capstone B: architect](lab-06-capstone-architect.md): extend to hub-spoke, write the design ADR, and review a peer design. 60 minutes.

The times are targets. You can take longer.

## What you need

- [Prerequisites](prerequisites.md): the workflow clone, an Azure account, the Azure CLI, an SSH key pair, a region, and an evidence folder.
- [Safety and teardown](safety-and-teardown.md): read it before lab 4.

## How to work with the AI

- Send one prompt at a time.
- Stop after each major step and review the result.
- Save read-only output under `evidence/` and ask the AI to read the file.
- The AI says "not verified" when the evidence is missing.
- The AI never runs a create or delete command.

## Reference answer key

The `reference/` folder holds one working core template and one hub-spoke template. Use them only after your own attempt, to compare. Your own `main.bicep` is the deliverable.

## New to the workflow

The [learning session runbook](../../example-learning-session-runbook.md) teaches the prompt-first workflow basics. This pack assumes that flow and adds Azure design work.

## What you will be able to do

- Brief, design, plan, deploy, verify, repair, and tear down a small workload.
- Keep the AI honest with saved evidence.
- Present a design decision as an ADR.
- Review another person's design with a clear verdict.
