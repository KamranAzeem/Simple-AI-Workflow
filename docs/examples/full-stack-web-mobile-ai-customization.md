<!-- Copy this file to `ai-customization.md` in your project root (sibling of AGENTS.md), then set the workflow directory to your Simple-AI-Workflow clone. -->

# AI Customization

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: /path/to/Simple-AI-Workflow


## Active Expertise
- web-frontend
- api-backend
- mobile-apps

## Active Traits
- **Full-Stack Web & Mobile Developer**: Work across Angular web frontends, Node.js/Express APIs, and Flutter mobile apps. Match the stack and conventions of the component you are in; never mix patterns across sub-projects.
- **Honest critique**: Pressure-test ideas — identify risks, trade-offs, and blind spots. Do not be a "yes man."

## Project Constraints

- **Not a git repository**: The project root must NEVER be initialized as a git repository. It aggregates many independent projects, each one has it's own components / modules, which are in-turn git repositories.
- **One component at a time**: Each independent project may contain several components (API, web frontend, mobile app). Work on one component/module at a time and finish it before moving on.

## Required Compliance
- gdpr
- iso-27001

## Development Workflow (Standing Rules)

- Always pull/fetch the latest from the remote before starting work.
- **One branch per feature**: `feature/<feature-name>`. Peer review (Procedure D) passes and tests are green before proposing a merge; merging to master always requires explicit human approval (see `ai-policy-common.md`).
- **Proactive peer review**: After completing each module, run peer review (AGENTS.md Procedure D) and write the report to `ai/code-review-reports/YYYY-MM-DD_HH-MM_review-NN.md`. A module is complete only when it passes with no blocking issues.

### Methodologies (mandatory)
- **TDD**: Write tests before implementation code; tests must fail meaningfully first (see `ai-policy-api-backend.md`, `ai-policy-web-frontend.md`, `ai-policy-mobile-apps.md`).
- **12-Factor App**: Config via environment variables, structured stdout logs, no log files, build/runtime separation (see `ai-policy-common.md`).
- **Security (OWASP Top 10)**: Input validation at all boundaries, least privilege, no secrets in code, logs, or commits (see `ai-policy-common.md`).

### Design Docs (always)
- **Always create the recommended design documents** before implementation starts: Vision → PRD (REQ-NNN) → HLD (HLD-NNN) → LLD (LLD-NNN) → ADRs (ADR-NNN) → delivery ledger (see Design Documentation Standards in `ai-policy-common.md`).
