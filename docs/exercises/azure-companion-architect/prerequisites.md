# Prerequisites

Complete this page before lab 1.

## The workflow clone

You run the labs inside an exercise project that uses the Simple-AI-Workflow protocol.

1. Clone the workflow repository to a stable location, for example `~/Projects/Simple-AI-Workflow`.
2. Copy `AGENTS.md` from the clone to your exercise project root.
3. Copy `docs/ai-customization.md` from the clone to the project root as `ai-customization.md`.
4. Set `**Workflow AI Directory**` in `ai-customization.md` to the absolute path of your clone.
5. Open the exercise project in your AI chat and send:

```text
load context using AGENTS.md protocol
```

If the AI loads the protocol, the project is ready. See [../../setup.md](../../setup.md) and [../../ai-customization-guide.md](../../ai-customization-guide.md) for the full setup.

## Azure account and CLI

You need an Azure account with a subscription you can use for practice.

Check the login and the CLI:

```bash
az login
az account show --output table
az version
```

`az account show` must print one subscription. If it prints several, pick one with `az account set --subscription "<name-or-id>"`.

## Bicep CLI

Check the Bicep CLI:

```bash
az bicep version
```

If the command reports that the Bicep CLI is not found, continue. Lab 3 uses a written review checklist instead of the build check. You can install the Bicep CLI later if you want the extra check.

## SSH key pair

The workload uses an SSH key, never a password.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/azure-exercises -C "azure-exercises"
```

- The public key is `~/.ssh/azure-exercises.pub`.
- The private key stays on your machine.
- Never commit either file.
- Never paste the private key into the AI chat.

## Region and name suffix

- Pick one Azure region and use it for the whole pack.
- Pick a `nameSuffix` of 3 to 8 lowercase letters and digits, for example `k7m2`.
- The suffix makes your resource names unique and easy to find.

Names follow this pattern:

- Resource group: `rg-azure-lab-04-<suffix>`
- Storage account: `st<suffix>`
- Virtual machine: `vm-<suffix>`

## Evidence folder

Create a folder for the output you save:

```bash
mkdir -p evidence
```

The AI reads files from `evidence/`. Save only read-only command output there, and remove anything sensitive before you share it.

## Plain chat note

A plain chat assistant can follow the prompts with reduced safety, because it does not load `AGENTS.md`. If you use one, apply the rules on the [safety and teardown](safety-and-teardown.md) page yourself.

## Readiness checklist

- [ ] The workflow clone exists and `ai-customization.md` points at it.
- [ ] The AI answered the `load context` prompt.
- [ ] `az login` and `az account show` work.
- [ ] The SSH key pair exists and the private key is not in the project.
- [ ] You chose a region and a name suffix.
- [ ] The `evidence/` folder exists.
