<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: 2026-05-01T14:30:00Z
Intent: Guide for opting into compliance and regulatory modules.
-->

# Compliance & Regulatory Framework Guide

This guide explains how to integrate regulatory and industry-standard compliance policies into your project using the modular Compliance Registry.

## Overview
Compliance modules are decoupled, opt-in policies stored in `ai/compliance/`. They are not automatically applied to projects, ensuring your workflow remains lean and relevant.

## How to Activate Compliance Modules
To enable a compliance policy for a project, update your project `ai/ai-customization.md` file:

1. Open `ai/ai-customization.md` (create it if it doesn't exist).
2. Add the **Active Compliance Modules** section:

```markdown
## Active Compliance Modules
- [GDPR](ai/compliance/gdpr.md)
- [PCI-DSS](ai/compliance/pci-dss.md)
```

3. Reload your context by asking: `"load context using AGENTS.md protocol"`

## Available Modules
The current registry includes the following standard modules:

- **Regional Privacy**: `gdpr.md` (EU), `ccpa.md` (California)
- **International Security**: `iso-27001.md`, `soc2.md`
- **Industry Standards**: `pci-dss.md` (Payment), `hipaa.md` (Health)

## Customization
If you need a new regulatory module, simply create a new Markdown file in the `ai/compliance/` directory following the template of existing files.
