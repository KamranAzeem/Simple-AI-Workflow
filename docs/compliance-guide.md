# Compliance & Regulatory Framework Guide

This guide explains how compliance and regulatory standards are applied in this workflow. Compliance is handled through the AI's built-in knowledge, not through on-disk policy files.

## How compliance works
There are no compliance files to download or store. When you list a recognized standard in your project `ai-customization.md`, the AI applies the relevant requirements, guardrails, and best practices for that standard from its built-in knowledge. It infers which controls matter for the task in front of it (data handling, authentication, logging, access control, and so on).

## How to require a standard
Edit `ai-customization.md` at your project root and list the standards under `## Required Compliance`:

```markdown
## Required Compliance
- soc2
- iso-27001
- gdpr
```

Then reload context with `"load context using AGENTS.md protocol"`. From then on the AI applies those standards to relevant work.

## Recognized standards
Common examples the AI recognizes:

- **Privacy**: GDPR (EU), CCPA (California)
- **Security**: ISO-27001, SOC 2
- **Industry**: PCI-DSS (payments), HIPAA (health)

## Validation
When the AI reads `## Required Compliance`, it checks each name against known frameworks. If a name is not a real compliance standard (for example `dora`, a DevOps metrics framework), the AI tells you, refuses to treat it as compliance, and offers to annotate it in `ai-customization.md` for your review.

## The compliance directory
`ai/policies/compliance/` exists as a standard project directory, but the protocol does not require or auto-load on-disk compliance files. Standard compliance handling is entirely through built-in AI knowledge.
