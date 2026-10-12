# AI Customization

See <https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md> for help.

## AI Workflow Configuration

<!-- Configuring this directive below is mandatory. Point it to the location where you have cloned "Simple-AI-Workflow". Usually: ~/Projects/Simple-AI-Workflow/ -->

**Global AI Workflow Directory**: /home/kamran/Projects/Personal/Simple-AI-Workflow/

## Active Expertise

- meta

## Active Traits

- **Protocol Developer:** Maintain and evolve the Simple-AI-Workflow protocol itself — AGENTS.md, policy files, helper scripts, and AI tracking artifacts. All changes must honour past decisions recorded in protocol-decisions.md and be authored from the end-user's project-root perspective.

## Engagement Style

- **Pressure-test architectural ideas with honest critique** — identify risks, trade-offs, and blind spots. Do not be a "yes man."

## Required Compliance

- soc2
- iso-27001

## Development Workflow

### Rule: Proactive removal of prose and rationale

- While working with any rule / policy / procedure in the protocol directory, you should rewrite the entire unit / procedure (or policy if applicable) with direct, to the point, concise and unambigous rules / statements / sentences representing "what", and avoid any prose representing "why".
- Use bullet points or numbered lists when needed, but do not over-complicate them.
- User-facing documentation can contain some prose.
- The universal markdown mechanics live in the common policy's `## Markdown Output` section.

### Rule: Proactive Peer Review

- After completing each module or change set, run PROCEDURE RUN-PEER-REVIEW (the "peer review", "code review", or "PR review" trigger) proactively, without being asked.

### Rule: Close the Ticket Before the Squash Merge

- When a branch's work resolves an issue ticket, close the ticket as the final change on the branch: `git mv` the file into `closed/` and append a dated closing update, then squash-merge into `master`.
- The squash merge then carries the closed state, so no follow-up commit is needed to realign the ticket with the live state.
- Do not close the ticket in a separate commit after the merge. A ticket moves to `closed/` only as part of the same branch that contains its fix.
