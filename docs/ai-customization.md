<!-- Copy this file to `ai-customization.md` in your project root (sibling of AGENTS.md). -->

# AI Customization

## AI Workflow Configuration

<!-- Set this to the absolute path of your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: /path/to/Simple-AI-Workflow

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.

---

## Active Expertise
<!-- List technical domains to load from the global policies directory. -->
<!-- Available: cloud, api-backend, web-frontend, data, linux-system-admin, mobile-apps, meta, dba, observability -->

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
