<!-- Copy this file to `ai-customization.md` in your project root (sibling of AGENTS.md). -->

# AI Customization

## AI Workflow Configuration

<!-- Set this to the absolute path of your Simple-AI-Workflow clone. -->

**Workflow AI Directory**: /path/to/Simple-AI-Workflow

**User AI Directory**: [HOME]/.ai/

**Default Shell**: bash

<!-- Optional team knowledge store. The directory is a read-only local clone or mount; the repository is the publish remote. -->
<!--
**Team AI Directory**: /path/to/team-alpha
**Team AI Knowledge Repository**: git@example.com:team/team-alpha.git
-->

<!-- User AI Directory defaults to [HOME]/.ai/. Default Shell is optional; use bash, zsh, pwsh, or git-bash. The matching native path goes in the user settings file as Default Shell Path. -->

See <https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md> for help.

---

## Active Expertise
<!-- List technical domains to load from the global policies directory. -->
<!-- markdownlint-disable-next-line MD044 -->
<!-- Available: cloud, api-backend, web-frontend, data, dba, observability, linux-system-admin, windows-system-admin, mobile-apps, coding-baseline, accounting, academic-researcher, career-coaching, meta -->

- web-frontend

---

## Active Traits
<!-- Define functional personas or behavioral shifts for the AI. Pick one. -->
<!-- See docs/ai-customization-guide.md for the full list of available traits. -->

- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile); flag breaking changes in shared schemas or DTOs.

---

## Required Compliance

<!-- 
List compliance standards to activate. The AI will use its built-in knowledge to apply relevant requirements.
If you do not want any compliance, this section can remain empty.
Examples: gdpr, soc2, hipaa, iso-27001, pci-dss, ccpa
-->

- gdpr
- iso-27001

---

## Design Docs

<!-- Optional. Record where your design documents live:
     - design-docs/ : the documents live beside your code (recommended)
     - ai/knowledge/ : the fallback location, under ai/
     Leave this section out and the AI detects the location from your project. -->

**Location**: design-docs/

## Merge Policy

**Merge Mode**: auto

<!-- Use pr for team repositories that require a pull request; direct for solo work. -->

---

<!-- 

## Example: The Solution Architect Setup
Use this configuration at a group-level directory to manage multiple sub-projects.

## Active Expertise
- cloud
- api-backend
- web-frontend

## Active Traits
- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile).

## Required Compliance
- soc2

-->
