<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-05-11T11:25:00Z
Intent: Include DBA in the customization guide naming conventions.
-->

# AI Customization Guide

The `ai-customization.md` file is the **"Single Dial"** for tailoring your AI assistant to a specific project, directory, or group of projects. It uses a flexible "soft composition" model for project customization.

## Why Customization?
Different projects require different expertise (Cloud vs. Frontend), different behaviors (Mentor vs. Reviewer), and different regulatory standards (GDPR vs. SOC2). Instead of having one massive policy, we "compose" the AI's persona in the project directory using this file.

---

## 1. Composing Expertise (Technical Roles)

Use the `## Active Expertise` section to load domain-specific policies from the **Global Policies Directory**.

**Example:**
```markdown
## Active Expertise
- cloud
- api-backend
```
**How it works**: The AI assistant will look for `ai-policy-cloud.md` and `ai-policy-api-backend.md` in the global directory and load them as additive layers.

---

## 2. Activating Traits (Functional Personas)

Use the `## Active Traits` section to define *how* the AI should behave. These are not external files; they are behavioral directives adopted for the session.

**Example:**
```markdown
## Active Traits
- Teacher/Trainer: Explain the 'why' behind every code change and suggest learning resources.
- Skeptical Reviewer: Challenge my assumptions and look for edge cases in every logic block.
```

---

## 3. Enabling Compliance (Regulatory Standards)

Use the `## Required Compliance` section to load compliance modules from the global repository without copying them in the project directory.

**Example:**
```markdown
## Required Compliance
- gdpr
- iso-27001
```
**How it works**: The AI will look for `compliance/gdpr.md` and `compliance/iso-27001.md` in the global policies folder.

---

## 4. The "Architect" Setup (Group-Level View)

If you are an **Architect** managing a group-level directory that contains multiple sub-projects (e.g., a "Solutions" folder containing `/infra`, `/api`, and `/frontend`), you can use `ai-customization.md` at the root to give the AI a comprehensive cross-domain vision.

**Architect Configuration Example:**
```markdown
## Active Expertise
- cloud        # For the infrastructure sub-folder
- api-backend  # For the backend services
- web-frontend # For the UI components

## Active Traits
- Strategic Planner: Focus on cross-project dependencies and architectural consistency.
- Mentor: Help the team grow by providing high-signal architectural feedback.

## Required Compliance
- soc2
```

By placing this at the top level of the group directory, the AI is "bootstrapped" with all the necessary expertise to understand and coordinate the entire solution.

---

## 5. Summary of Naming Conventions

| Component | Example | Path Inferred |
| :--- | :--- | :--- |
| **Expertise** | `cloud` | `ai-policy-cloud.md` |
| **Expertise** | `web-frontend` | `ai-policy-web-frontend.md` |
| **Expertise** | `dba` | `ai-policy-dba.md` |
| **Expertise** | `observability` | `ai-policy-observability.md` |
| **Expertise** | `meta` | `ai-policy-meta.md` |
| **Compliance**| `gdpr` | `compliance/gdpr.md` |
| **Compliance**| `hipaa` | `compliance/hipaa.md` |

---

## Best Practices
1.  **Start Small**: Don't load every policy at once. Only activate what you need for the current focus.
2.  **Explicit Traits**: Be specific with your traits. Instead of just "Teacher," say "Teacher: Focus on explaining Bicep syntax."
3.  **No Project Copies**: Never copy the `ai-policy-*.md` or `compliance/*.md` files into your project. Referencing them by name keeps your project clean and ensures you always use the latest global standards.
