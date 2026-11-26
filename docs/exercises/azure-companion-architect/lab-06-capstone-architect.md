# Lab 6: Capstone B, architect design

## Scenario

Extend the workload into a hub-spoke topology with a second workload. You decide the address spaces, the peering, and the second workload. You write the design decision record and review the result like a peer architect would.

## Prerequisites

- Labs 1-5 complete.
- The lab 4 template and the lab 5 fault notes.
- The same region, suffix, admin user, and SSH key.

## What you will decide

- The hub and spoke address spaces.
- Which side hosts the existing workload and which hosts the second one.
- The peering direction and the traffic you allow.
- The second workload and how it is secured.
- Which trade-offs you accept and which you reject.

## The prompt

```text
I am the architect for this workload. Extend it to a hub-spoke topology in one resource group:
- keep the existing Linux virtual machine as the spoke workload
- add a hub virtual network
- add a peering pair between the hub and the spoke
- add a second small workload in the hub
- keep the managed identity pattern
- tag every new resource purpose=exercise and lab=06
- no secret and no subscription or tenant identifier in any file

Give me three things:
1. an HLD delta with Components, Boundaries, Network flow, and Failure modes
2. an ADR with Decision, Context, Alternatives rejected, and Consequences
3. the Bicep changes, one block at a time, with a what-if command for each block

Save the HLD delta and the ADR under evidence/lab-06-design.md. Never run a command yourself.
```

## Build and gate

Set your values once per shell:

```bash
RG="rg-azure-lab-06-k7m2"
LOCATION="westeurope"
SUFFIX="k7m2"
ADMIN_USER="azureuser"
```

Create the resource group, then run the what-if gate exactly as in lab 4, with `--name lab06-what-if`. Read the output before you deploy. Deploy with `--name lab06-deploy`.

Verify the topology:

```bash
az network vnet list --resource-group "$RG" --output table > evidence/lab-06-vnets.txt
az network vnet peering list --resource-group "$RG" --vnet-name "vnet-$SUFFIX" --output table > evidence/lab-06-peering.txt
az resource list --resource-group "$RG" --output table > evidence/lab-06-resources.txt
```

The evidence must show two virtual networks and a peering on each side.

## Peer review

Ask the AI to review your design and template as a strict reviewer:

```text
Review evidence/lab-06-design.md and main.bicep as a strict peer reviewer. Report findings only, with severity Critical, Major, Minor, or Suggestion. Do not rewrite the files. End with APPROVED or CHANGES REQUESTED.
```

Fix every Critical, Major, and Minor finding in your own files, then ask for one more review. Save the final report under `evidence/lab-06-review.md`.

## Teardown

```bash
az group delete --name "$RG" --yes --no-wait
az group show --name "$RG" > evidence/lab-06-teardown.txt 2>&1
az group exists --name "$RG" > evidence/lab-06-teardown-exists.txt 2>&1
```

Repeat until the group is not found; `az group exists` must print `false`.

## Verification

- `evidence/lab-06-design.md` has the HLD delta and the ADR.
- The ADR lists at least two rejected alternatives with a reason each.
- `evidence/lab-06-vnets.txt` shows two virtual networks.
- `evidence/lab-06-peering.txt` shows the peering.
- `evidence/lab-06-review.md` ends with APPROVED.
- `evidence/lab-06-teardown-exists.txt` contains `false`.

## Reflection

- Which design choice would you defend hardest in a review?
- What would you change if a second team owned the hub?
