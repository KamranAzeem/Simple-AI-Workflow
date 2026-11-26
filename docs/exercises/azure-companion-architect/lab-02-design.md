# Lab 2: Design

## Scenario

Turn the requirements into a high-level design and one architecture decision record. You decide; the AI proposes.

This lab makes no Azure call and creates no Azure resource.

## Prerequisites

- Lab 1 complete, with `evidence/lab-01-requirements.md`.
- The AI is running in the exercise project.

## What you will decide

- The topology: one virtual network, one subnet, one virtual machine, one storage account.
- How the page is exposed: public IP and network security group.
- How the virtual machine reads storage: system-assigned managed identity.
- What monitoring is in scope: CPU metric alert.
- What you deliberately leave out of the first version.

## The prompt

```text
Use evidence/lab-01-requirements.md as the input.

Produce two things and save them as evidence/lab-02-hld.md:

1. A high-level design with these sections:
   Components, Boundaries, Network flow, Identity, Operations, Failure modes.
2. One architecture decision record for the workload shape, with these sections:
   Decision, Context, Alternatives rejected, Consequences.

Argue the trade-offs in security, operations, and simplicity. Do not write Bicep yet. Do not run any Azure command.
```

## Approval gate

Read the design and the decision record. Accept the decision, or send it back with the alternative you want. Record your decision and the date at the bottom of the file.

## Verification

- The design file exists at `evidence/lab-02-hld.md`.
- The design has all six sections.
- The decision record has all four sections.
- At least two alternatives are listed with a reason each.
- The design names the identity model and the monitoring signal.
- No Azure command ran in this lab.

## Reflection

- Which trade-off did you change after reading the AI's proposal?
- What did the AI leave out that your requirements needed?
