<!--
Created-by: Gemini CLI
Updated-by: Gemini CLI
Last modified: 2026-04-21T12:50:00Z
Intent: Explain policy stacking and modular persona behavior.
-->
---
# Understanding Modular Personas & Policy Stacking

This repository uses a **hierarchical inheritance** model for AI policies. This allows you to change the assistant's "behavior" without losing its "technical knowledge."

## How it works: "The Policy Stack"

When an AI assistant initializes, it reads files in the order defined in `AGENTS.md`. This creates a cumulative context:

1.  **Domain Policies** (e.g., `ai-policy-cloud.md`): These define the **Knowledge Base** and **Guardrails** (Terraform, AWS standards, security rules).
2.  **Persona Overrides** (via `ai/ai-customization.md`): These define the **Operational Mode** (Mentor, Architect, Security Specialist).

### Key Concept: Stacking, not Replacing
Switching to a "Mentor" persona **does not disable** the Cloud policy. Instead, it overlays new instructions on *how* to deliver that cloud knowledge.

| Component | Example: "Mentor" Persona | Example: "Architect" Persona |
| :--- | :--- | :--- |
| **Domain Knowledge** | Loaded from `ai-policy-cloud.md` | Loaded from `ai-policy-cloud.md` |
| **Technical Rules** | Port 22 must be restricted | Port 22 must be restricted |
| **Assistant Role** | "Experienced Technical Educator" | "Senior Systems Architect" |
| **Delivery Style** | Step-by-step labs and analogies | Direct analysis and design patterns |

## How to use Personas

1.  Browse the templates in `docs/personas/`.
2.  Copy the `## Role`, `## Responsibilities`, and `## Communication Style` sections from your chosen template.
3.  Paste them into your local `ai/ai-customization.md` file.
4.  The assistant will adopt the new persona after the next context load. 

**Note on Refreshing**: If you update the override file while a chat session is already active, you must tell the assistant to refresh its instructions by using the prompt: **"load AI context"** or **"re-read policy override"**.
