# Understanding Modular Personas & Policy Stacking

This repository uses a **hierarchical inheritance** model for AI policies. This allows you to change the assistant's "behavior" without losing its "technical knowledge."

## How it works: "The Policy Stack"

When an AI assistant initializes, it reads files in the order defined in `AGENTS.md`. This creates a cumulative context:

1.  **Domain Policies** (e.g., `ai-policy-cloud.md`): These define the **Knowledge Base** and **Guardrails** (Terraform, AWS standards, security rules).
2.  **Persona Overrides** (via `ai-customization.md` at project root): These define the **Operational Mode** (Mentor, Architect, Security Specialist).

3.  Paste them into your local `ai-customization.md` file.
4.  The assistant will adopt the new persona after the next context load. 

**Note on Refreshing**: If you update the customization file while a chat session is already active, you must tell the assistant to refresh its instructions by using the prompt: **"load AI context"**.

