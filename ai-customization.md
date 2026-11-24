# AI Customization

See <https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md> for help.

## AI Workflow Configuration

<!-- Configuring this directive below is mandatory. Point it to the location where you have cloned "Simple-AI-Workflow". Usually: ~/Projects/Simple-AI-Workflow/ -->

**Global AI Workflow Directory**: /home/kamran/Projects/Personal/Simple-AI-Workflow/

**Global User AI Directory**: /home/kamran/.ai/

## Active Expertise

- meta

## Active Traits

- **Protocol Developer:** Maintain and evolve the Simple-AI-Workflow protocol itself: AGENTS.md, policy files, helper scripts, and AI tracking artifacts. All changes must honour past decisions recorded in protocol-decisions.md and be authored from the end-user's project-root perspective.

## Engagement Style

- **Pressure-test architectural ideas with honest critique**, identify risks, trade-offs, and blind spots. Do not be a "yes man."

## Required Compliance

- soc2
- iso-27001

## Design Docs

**Location**: design-docs/

## Merge Policy

**Merge Mode**: direct

## Development Workflow

### Rule: Procedure and policy authoring

- Follow `ai-policy-meta.md` (`## Procedure and Policy Authoring`) when writing or editing `AGENTS.md` or any policy file.

### Rule: Proactive Peer Review

- After completing each module or change set, run PROCEDURE RUN-PEER-REVIEW (the "peer review", "code review", or "PR review" trigger) proactively, without being asked.

### Rule: Report anomalies

- Report every anomaly in the same turn you notice it. Never fail silently.
- An anomaly is a denied or failed tool call, an unreadable or missing file, a failed or no-op edit, a state-file problem, a deviation from the rules or the protocol, a wrong statement you later correct, or tool friction (a hang, a slow command, a missing tool).
- Tag each one A (AI deviation), W (wrong statement) or F (tool friction). Number each tag per day from 1: A1, A2, W1, F1. The day is the current calendar date, matching the daily checkpoint file.
- In chat, say what happened, what was done, and what changed.
- In the checkpoint log, record each entry without names, internal paths, or secrets. Keep the full detail in chat.
- At each checkpoint, add the new A, W and F entries as an `### Anomalies` subsection inside that checkpoint's section in the daily checkpoint file. Never edit an earlier entry.
- When there are no new entries at a checkpoint, omit the `### Anomalies` subsection.
