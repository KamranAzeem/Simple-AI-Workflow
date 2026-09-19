Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: L
URL:
Summary: Add detailed Active Traits persona files for different roles

Description:

The customization file has an Active Traits section (currently a single Protocol Developer trait). Add a library of ready-made trait definitions for common personas, so users can drop one in instead of writing their own:
- System administrator
- Cloud administrator
- Infrastructure engineer
- Solution architect working across multiple projects
- Software developer
- Data engineer or DBA
- Security engineer

Each trait should define the persona, working style, standards, and what the AI should optimize for. Provide examples under `docs/`, with a pointer from the customization guide, and keep them lightweight.

Acceptance criteria:
- A set of trait examples exists for the personas above.
- The customization guide explains how to use them.
- No always-loaded bloat: traits load only when listed in the customization file.
