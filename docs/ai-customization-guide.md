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
**How it works**: The AI assistant will look for a matching file in the global directory using two patterns — `ai-policy-<name>.md` first, then `<name>.md` — and load all matched files as additive layers.

---

## 2. Activating Traits (Functional Personas)

Use the `## Active Traits` section to define *how* the AI should behave. These are not external files; they are behavioral directives adopted for the session.

**Note:** Only select **one** trait that best matches your role.

**Available traits:**

- **System Architect:** Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines; ensure cohesion across all system components. **Engagement style: Pressure-test architectural ideas with honest critique — identify risks, trade-offs, and blind spots. Do not be a "yes man."**
- **System Integrator** — Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile). Flags breaking changes in shared schemas or DTOs.
- **Senior DBA** — Prioritize HA/DR, performance tuning (Explain First), and strict security guardrails.
- **Observability Architect** — Prioritize Four Golden Signals, log correlation, distributed tracing, and actionable alerting.
- **Code Reviewer** — Look for security vulnerabilities, performance bottlenecks, and coding standard violations.
- **Security Specialist** — Minimize attack surface. Enforce least privilege, check for exposed secrets, align with OWASP/CIS benchmarks.
- **Teacher/Trainer** — Explain the 'why' behind every 'how'. Break down complex tasks into teachable steps.

**Example:**
```markdown
## Active Traits
- System Architect: Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines; ensure cohesion across all system components. **Engagement style: Pressure-test architectural ideas with honest critique — identify risks, trade-offs, and blind spots. Do not be a "yes man."**
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

**How it works**: The AI uses its built-in knowledge to apply the relevant requirements for each listed standard. No on-disk compliance files are needed.

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
- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile).
- System Architect: Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines.
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
| **Expertise** | `accounting` | `ai-policy-accounting.md` |
| **Expertise** | `academic-researcher` | `ai-policy-academic-researcher.md` |
| **Expertise** | `career-coaching` | `ai-policy-career-coaching.md` |
| **Compliance**| `gdpr` | (AI built-in knowledge) |
| **Compliance**| `hipaa` | (AI built-in knowledge) |

> **Note — Peer Review (`code-review`)**: You do not need to add `code-review` to `ai-customization.md`. The peer review policy is loaded automatically when you say `"peer review"`, `"code review"`, or `"PR review"` in your AI chat. It is an on-demand mode, not a persistent expertise module.
>
> **Note — Codebase Examination (`codebase-examination`)**: Same behavior as peer review — say `"codebase examination"` or `"examine this codebase"` to activate it. Not an Active Expertise entry; not loaded or indexed at boot.

---

## Best Practices
1.  **Start Small**: Don't load every policy at once. Only activate what you need for the current focus.
2.  **Explicit Traits**: Be specific with your traits. Instead of just "Teacher," say "Teacher: Focus on explaining Bicep syntax."
3.  **No Project Copies**: Never copy the `ai-policy-*.md` files into your project. Referencing them by name keeps your project clean and ensures you always use the latest global standards.
