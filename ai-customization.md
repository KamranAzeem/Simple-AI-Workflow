<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-05-05T14:15:00Z
Intent: Template for the ai-customization.md file.
-->

# AI Customization Template

Copy this file to `ai/ai-customization.md` in your project to tailor the AI's expertise and behavior.

---

## Active Expertise
<!-- List technical domains to load from the global policies directory. -->
<!-- Available: cloud, api-backend, web-frontend, data, linux-system-admin, mobile-apps, meta -->

- meta

---

## Active Traits
<!-- Define functional personas or behavioral shifts for the AI. -->

- Strategic Planner: Coordinate dependencies across infra, api, and web.
- Teacher/Trainer: Explain the 'why' behind architectural decisions and suggest best practices.
- Code Reviewer: Look for security vulnerabilities and performance bottlenecks.

---

## Required Compliance
<!-- List compliance modules to load from the global compliance directory. -->
<!-- Available: gdpr, soc2, hipaa, iso-27001, pci-dss, ccpa -->

- gdpr
- iso-27001
---

<!-- 

## Example: The Architect Setup
Use this configuration at a group-level directory to manage multiple sub-projects.

## Active Expertise
- cloud
- api-backend
- web-frontend

## Active Traits
- Strategic Planner: Coordinate dependencies across infra, api, and web.
- Mentor: Provide high-signal architectural feedback.

## Required Compliance
- soc2
-->
