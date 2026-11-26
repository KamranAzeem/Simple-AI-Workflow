# Lab 5: Capstone A, sysadmin operations

## Scenario

Deploy the workload, prove it works, then diagnose a layered fault from symptoms only. One network rule blocks the service port and the service itself is stopped. Find both, repair both, prove the restore, and tear down.

## Prerequisites

- Lab 4 complete.
- The same region, suffix, admin user, and SSH key.
- `main.bicep` from lab 3.

## What you will decide

- What evidence to collect before you touch anything.
- Which hypothesis to test first.
- When the workload is truly restored.

## The prompt

```text
I am the sysadmin for this workload. Give me the commands to deploy it into rg-azure-lab-05, prove the page works, and then inject a fault: one network security group rule that blocks port 80, and nginx stopped on the virtual machine.

Rules:
- Tell me the expected symptom, not the fix.
- Wait for my evidence before you suggest a cause.
- Ask for the exact output you need.
- Never run a command yourself.
```

Ask the AI to change the tag in `main.bicep` from `lab=04` to `lab=05` before you deploy.

## Deploy and capture a baseline

Set your values once per shell:

```bash
RG="rg-azure-lab-05-k7m2"
LOCATION="westeurope"
SUFFIX="k7m2"
ADMIN_USER="azureuser"
```

Use the lab 4 deploy commands with these values and `--name lab05-deploy`. Then:

```bash
IP="$(az deployment group show --resource-group "$RG" --name lab05-deploy --query properties.outputs.publicIp.value --output tsv)"
curl -s -o /dev/null -w "%{http_code}\n" "http://$IP/" > evidence/lab-05-baseline.txt 2>&1
ssh -i ~/.ssh/azure-exercises "$ADMIN_USER@$IP" "systemctl is-active nginx" >> evidence/lab-05-baseline.txt 2>&1
```

The baseline must show `200` and `active`.

## Inject the fault

```bash
az network nsg rule update --resource-group "$RG" --nsg-name "nsg-$SUFFIX" --name AllowHTTP --access Deny
ssh -i ~/.ssh/azure-exercises "$ADMIN_USER@$IP" "sudo systemctl stop nginx"
curl -m 5 -s -o /dev/null -w "%{http_code}\n" "http://$IP/" > evidence/lab-05-symptom.txt 2>&1
```

The symptom is a failed or timed-out HTTP check. The page is unreachable.

## Diagnose

Collect evidence, then reason from it:

```bash
az network nsg rule list --resource-group "$RG" --nsg-name "nsg-$SUFFIX" --output table > evidence/lab-05-nsg.txt
ssh -i ~/.ssh/azure-exercises "$ADMIN_USER@$IP" "systemctl status nginx --no-pager" > evidence/lab-05-service.txt 2>&1
```

You need two findings:

1. The `AllowHTTP` rule denies port 80.
2. `nginx` is not running.

## Repair and prove the restore

```bash
az network nsg rule update --resource-group "$RG" --nsg-name "nsg-$SUFFIX" --name AllowHTTP --access Allow
ssh -i ~/.ssh/azure-exercises "$ADMIN_USER@$IP" "sudo systemctl start nginx"
curl -s -o /dev/null -w "%{http_code}\n" "http://$IP/" > evidence/lab-05-restored.txt 2>&1
ssh -i ~/.ssh/azure-exercises "$ADMIN_USER@$IP" "systemctl is-active nginx" >> evidence/lab-05-restored.txt 2>&1
```

The restored file must show `200` and `active`.

## Teardown

```bash
az group delete --name "$RG" --yes --no-wait
az group show --name "$RG" > evidence/lab-05-teardown.txt 2>&1
az group exists --name "$RG" > evidence/lab-05-teardown-exists.txt 2>&1
```

Repeat until the group is not found; `az group exists` must print `false`.

## Restored check

- `evidence/lab-05-restored.txt` contains `200`.
- The same file contains `active`.
- `evidence/lab-05-teardown-exists.txt` contains `false`.

## Verification

- The baseline shows `200` and `active`.
- The symptom evidence shows the failure.
- The NSG evidence shows the deny rule.
- The service evidence shows the stopped service.
- The restored evidence shows `200` and `active`.
- The teardown evidence proves the group is gone.

## Reflection

- Which finding took longer, and why?
- What single piece of evidence would have shortened the diagnosis?
