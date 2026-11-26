# Lab 4: Build, verify, and tear down

## Scenario

Create one resource group, run the what-if gate, deploy the core, verify it from saved output, then delete the resource group and prove it is gone. This is the first lab that makes Azure changes.

## Prerequisites

- Labs 1-3 complete, with `main.bicep` and `evidence/lab-03-plan.md`.
- `az login` works.
- The SSH key pair exists at `~/.ssh/azure-exercises`.
- You chose a region, a suffix, and an admin user name.
- The AI is running in the exercise project.

## What you will decide

- Whether the what-if output is safe to apply.
- Whether to stop or proceed.
- Whether the teardown proof is complete.

## The prompt

```text
Prepare the exact commands for lab 4: create the resource group, run az deployment group what-if, deploy only after I approve the what-if, save every output under evidence/, verify the resources, then delete the resource group and prove it is gone.

Rules:
- Give me one command block at a time.
- Wait for me to paste or save the output before the next block.
- Never run a command yourself.
- Treat the what-if output as the only gate.
```

## Commands

Set your values once per shell:

```bash
RG="rg-azure-lab-04-k7m2"
LOCATION="westeurope"
SUFFIX="k7m2"
ADMIN_USER="azureuser"
```

Create the resource group:

```bash
az group create --name "$RG" --location "$LOCATION" --tags purpose=exercise lab=04
```

Run the gate and save the output:

```bash
az deployment group what-if \
  --resource-group "$RG" \
  --template-file main.bicep \
  --parameters location="$LOCATION" nameSuffix="$SUFFIX" adminUsername="$ADMIN_USER" sshPublicKey="$(cat ~/.ssh/azure-exercises.pub)" \
  --name lab04-what-if > evidence/lab-04-what-if.txt 2>&1
```

Open `evidence/lab-04-what-if.txt` and read it. Proceed only when it shows the resources you expect and no delete or replacement.

Deploy:

```bash
az deployment group create \
  --resource-group "$RG" \
  --template-file main.bicep \
  --parameters location="$LOCATION" nameSuffix="$SUFFIX" adminUsername="$ADMIN_USER" sshPublicKey="$(cat ~/.ssh/azure-exercises.pub)" \
  --name lab04-deploy > evidence/lab-04-deploy.txt 2>&1
```

Verify the resources and the service:

```bash
IP="$(az deployment group show --resource-group "$RG" --name lab04-deploy --query properties.outputs.publicIp.value --output tsv)"
curl -s -o /dev/null -w "%{http_code}\n" "http://$IP/"
az vm show --resource-group "$RG" --name "vm-$SUFFIX" --output table > evidence/lab-04-vm.txt
az storage account show --resource-group "$RG" --name "st$SUFFIX" --output table > evidence/lab-04-storage.txt
az resource list --resource-group "$RG" --output table > evidence/lab-04-resources.txt
```

The HTTP check must print `200`. Cloud-init may need a minute; if it is not `200` yet, wait and run the `curl` line again.

## Teardown

Delete the group and prove it is gone:

```bash
az group delete --name "$RG" --yes --no-wait
az group show --name "$RG" > evidence/lab-04-teardown.txt 2>&1
az group exists --name "$RG" > evidence/lab-04-teardown-exists.txt 2>&1
```

Repeat `az group show` until it reports that the group is not found. `az group exists` must print `false`. The error in `lab-04-teardown.txt` is the evidence.

## If the role assignment fails

A Contributor-only account cannot create the storage role assignment. If the deployment returns `AuthorizationFailed`, ask the subscription owner for Owner, or Contributor plus User Access Administrator on the resource group. Do not delete the identity step.

## Verification

- `evidence/lab-04-what-if.txt` exists and shows the expected resources.
- `evidence/lab-04-deploy.txt` shows a successful deployment.
- The HTTP check printed `200`.
- `evidence/lab-04-vm.txt`, `lab-04-storage.txt`, and `lab-04-resources.txt` exist.
- `evidence/lab-04-teardown.txt` shows the group not found.
- `evidence/lab-04-teardown-exists.txt` contains `false`.

## Reflection

- What in the what-if output made you pause, if anything?
- Which check would you keep if you had time for only one?
