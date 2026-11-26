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

## Merged scope (2026-11-19)

Absorbed `active-traits-persona-customization-files.md`. The presets also cover the personas the trait catalog does not: system administrator, cloud administrator, infrastructure engineer, and software developer. The existing seven traits already cover System Architect, System Integrator, Senior DBA, Observability Architect, Code Reviewer, Security Specialist, and Teacher/Trainer (`docs/ai-customization-guide.md:64-73`).

The role list and each preset's contents still need the user decision noted above.

## Init consumer (2026-11-25)

- `--init --role <preset>` in `sync-script-init-scaffolding.md` consumes these presets. The preset name is the role switch value.
- The role list and contents must settle before init is implemented.

---
2026-11-26

## Grilling decisions

- Eight presets: cloud-architect, solution-architect, web-developer, mobile-developer, platform-engineer, dba, data-engineer, security-engineer.
- Active Expertise: cloud-architect (cloud, api-backend, data, dba, web-frontend, observability); solution-architect (cloud, api-backend, data, dba, web-frontend, mobile-apps); web-developer (web-frontend, api-backend, coding-baseline); mobile-developer (mobile-apps, api-backend, coding-baseline); platform-engineer (cloud, linux-system-admin, windows-system-admin, observability); dba (dba, data); data-engineer (data, dba, cloud); security-engineer (coding-baseline, observability, cloud).
- Traits: add Platform Engineer, Software Developer, and Data Engineer to the guide's catalog. Mapping: cloud-architect=System Architect, solution-architect=System Integrator, web-developer and mobile-developer=Software Developer, platform-engineer=Platform Engineer, dba=Senior DBA, data-engineer=Data Engineer, security-engineer=Security Specialist.
- Contents: full `ai-customization.md` variants under `docs/examples/customization-presets/<role>.md` with the workflow placeholders, one trait, `design-docs/`, and `auto` merge. soc2 and iso-27001 are pre-filled for cloud-architect, solution-architect, platform-engineer, data-engineer, and security-engineer; web-developer, mobile-developer, and dba leave compliance empty with the comment.
- The slugs are the `--role` values for the later `--init` ticket. Scope is the presets and the guide; the release is MINOR. The role list and contents are settled; the next step is the plan.
