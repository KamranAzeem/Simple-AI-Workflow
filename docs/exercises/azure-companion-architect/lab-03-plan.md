# Lab 3: Plan

## Scenario

Turn the design into a Bicep plan and a draft template. You review the draft statically. Nothing is deployed, and the what-if gate runs in lab 4, after the resource group exists.

This lab makes no Azure call that reads or writes a resource. The optional Bicep build is a local check.

## Prerequisites

- Lab 2 complete, with `evidence/lab-02-hld.md`.
- The Azure CLI is installed. The Bicep CLI is optional for this lab.

## What you will decide

- The parameters and their validation rules.
- Resource names and tags.
- The virtual machine size.
- What the template outputs.
- Which checks must pass before lab 4.

## The prompt

```text
Use evidence/lab-02-hld.md as the input.

Draft a Bicep template at main.bicep with:
- targetScope = 'resourceGroup'
- parameters: location, nameSuffix, adminUsername, sshPublicKey
- validation on nameSuffix: 3 to 8 lowercase letters and digits
- one virtual network with one subnet and a network security group that allows 22 and 80
- one public IP, one network interface, and one Ubuntu virtual machine with a system-assigned identity
- cloud-init that installs and starts nginx on first boot
- names: vnet-<suffix>, nsg-<suffix>, pip-<suffix>, nic-<suffix>, vm-<suffix>, st<suffix>
- one storage account and a role assignment that lets the identity read blobs
- one CPU metric alert on the virtual machine
- tags purpose=exercise and lab=04 on every resource
- outputs for the resource names and the public IP address
- no secret, no key, and no subscription or tenant identifier in the file

Then write a review checklist to evidence/lab-03-plan.md with:
- the parameter validation you expect
- the resources you expect, including the nginx install
- the names match the lab 4 commands
- the outputs you expect
- the checks you will run in lab 4

Do not run az deployment, az group, or any create or delete command.
```

## Approval gate

Review the draft before lab 4:

1. Read every parameter and its validation.
2. Confirm there is no default for `sshPublicKey` and no secret in the file.
3. Confirm every resource carries the two tags.
4. If the Bicep CLI is available, run the build check.
5. Sign the checklist.

If the build check is not available, use the checklist. Record which path you took.

## Verification

Run only these optional local checks:

```bash
az bicep version
az bicep build --file main.bicep
```

- If the Bicep CLI is present, `az bicep build` exits 0.
- If it is absent, record that fact in `evidence/lab-03-plan.md` and complete the written checklist.
- `evidence/lab-03-plan.md` exists with the four checklist sections.
- `main.bicep` has no `az deployment` and no `az group` command in it.
- No what-if and no deployment ran in this lab.

## Reflection

- Which parameter must never have a default, and why?
- Which resource is easiest to name badly, and what did you do about it?
