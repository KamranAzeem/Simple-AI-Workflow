# Safety and teardown

Read this page before lab 4.

## The split: the AI proposes, you run

- The AI interviews, drafts, reviews, and explains.
- You run every `az` command.
- The AI never holds Azure credentials.
- The AI never runs a create or delete command.

## Credentials

- Authenticate with `az login` on your own machine.
- The workload uses a system-assigned managed identity to read storage.
- Do not create a service principal for these labs.
- Do not store a key, token, or connection string in the project.

## One resource group per lab

Every build lab uses its own resource group:

- Lab 4: `rg-azure-lab-04-<suffix>`
- Lab 5: `rg-azure-lab-05-<suffix>`
- Lab 6: `rg-azure-lab-06-<suffix>`

The resource group is the teardown unit. Delete it at the end of the lab and prove it is gone:

```bash
az group delete --name "$RG" --yes --no-wait
az group show --name "$RG"
```

`az group show` must report that the group is not found. You can also run:

```bash
az group exists --name "$RG"
```

The command must print `false`.

## The what-if gate

Every build lab runs the what-if gate. Lab 4 is the first:

```bash
az deployment group what-if --resource-group "$RG" --template-file main.bicep --parameters @main.parameters.json
```

Read the output before you deploy:

- Look for a delete or a replacement of a resource.
- Look for a resource you did not expect.
- Stop if anything surprises you and ask the AI to explain it.

## If the role assignment fails

Lab 4 assigns a storage role to the VM's managed identity. A Contributor-only account cannot create role assignments. If the deployment or command returns `AuthorizationFailed`:

- The cause is missing permission to write role assignments.
- You need Owner on the subscription, or Contributor plus User Access Administrator on the resource group.
- Ask the subscription owner for the role, or use a subscription where you hold it.
- Do not remove the identity step to get past the error. It is part of the lesson.

## Secrets and evidence

- Save only read-only output under `evidence/`.
- Remove subscription IDs, tenant IDs, and public IP addresses before you share an evidence file outside your machine.
- Never commit the private SSH key.
- Never commit a file that holds a secret.

## Drift: the AI says "not verified"

Azure changes. The AI's memory of a command or a property can be out of date.

- Every lab ends with a Verification block that names the exact read-only commands.
- The AI must answer "not verified" until you save or paste the output.
- The reference templates pin their API versions, so a change shows up as a difference.

## If you get stuck

1. Save the failing command and its full output to `evidence/`.
2. Tell the AI to read the file and diagnose from the evidence only.
3. Do not paste credentials, keys, or private data into the chat.
4. If the AI proposes a destructive command, read it before you run it.
