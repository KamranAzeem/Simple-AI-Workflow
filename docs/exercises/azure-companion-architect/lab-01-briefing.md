# Lab 1: Briefing

## Scenario

A team needs a small internal status page. It runs on one Linux virtual machine and answers HTTP on port 80. You are the owner. Before any design exists, you brief the AI and it writes the requirements with you.

This lab makes no Azure call and creates no Azure resource.

## Prerequisites

- The workflow clone and the exercise project from [prerequisites](prerequisites.md).
- The AI has answered `load context using AGENTS.md protocol`.
- An `evidence/` folder.

## What you will decide

- Who uses the page and from where.
- How available it must be.
- What data it holds and what must not leave the workload.
- How it is exposed to the network.
- Which region you use and why.
- What "done" means for the first version.

## The prompt

Send this to the AI in your exercise project:

```text
You are my companion architect. Interview me about a small internal status page that runs on one Linux virtual machine and answers HTTP on port 80.

Rules:
- Ask one question at a time.
- For each question, give your recommended answer first, then wait for mine.
- Challenge an answer that is vague or that hides a constraint.
- Do not design anything yet.

When the interview is complete, write requirements with these sections:
Users, Workload, Availability, Security, Data, Operations, Constraints, Success measure.

Save the result as evidence/lab-01-requirements.md.
```

## Approval gate

Read the requirements file and change anything that is wrong. The file is yours, not the AI's. Sign the bottom with your name and the date before you continue.

## Verification

- The requirements file exists at `evidence/lab-01-requirements.md`.
- It has all eight sections from the prompt.
- Every section has at least one concrete statement, not a placeholder.
- The success measure is testable.
- No Azure command ran in this lab.

## Reflection

- Which question made you change an assumption?
- Which requirement would you drop first if the workload had to be simpler?
