Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: L
URL:
Summary: Add ready-made ai-customization.md presets for common roles

Description:

Add variants of `ai-customization.md` for common roles, covering expertise (policies), active traits, compliance, project constraints, and developer workflow. Roles to start with:
- Cloud architect (full infrastructure and the software stack).
- Product or solution architect (multiple microservices, modules, databases, data design, data flow).
- Web developer (several web components under one project).
- Mobile app developer (several product components under one project).
- More roles later.

This is broader than the Active Traits work in `active-traits-persona-customization-files.md`. Keep the two consistent, since the traits are a subset of each preset.

Needs discussion before implementation: confirm the role list and what each preset contains.

Acceptance criteria:
- One preset per role under `docs/examples/` or a presets directory.
- The customization guide explains how to pick and adapt a preset.
- Cross-referenced with the Active Traits persona ticket.
