Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: User-facing docs still name project-relative policy paths that only exist in the clone

Description:

## Problem

The v5.5.2 work removed hardcoded policy paths from `AGENTS.md` and the policies. The docs verification pass found four places where a user-facing doc names `ai/policies/ai-policy-<name>.md` in a context where the reader is in their own project, not the workflow clone. The clone holds those files; a user project does not.

Findings:

- `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md:110`: the "Open your project and you will find" tree shows `ai/policies/` as project content holding domain rules.
- `docs/examples/full-stack-web-mobile-ai-customization.md:35, 40, 41, 42, 46`: a user-project `ai-customization.md` example points at `ai/policies/...` files that do not exist in that project.
- `docs/personas/README.md:9`: the domain-policy example names `ai/policies/ai-policy-cloud.md` in a user-project context.
- `docs/workflow-guide.md:220`: states that the AI reads `ai/policies/ai-policy-code-review.md`, which is inaccurate after v5.5.2.

Other docs hits were verified as correct for the clone layout and need no change.

## Scope

- The four findings above.
- No change to the protocol files. This is documentation drift only.

## Acceptance criteria

- Each finding is corrected to name the policy file and the Global AI Policies Directory, or the clone layout, as the surrounding context requires.
- The project tree in the compared doc shows `ai/policies/` only where it belongs.
- A reader in a user project can follow every policy reference without a dead path.
- No protocol file changes.
- Markdown lint passes on the changed docs.

## Notes

- Found during the v5.5.2 docs verification pass on 2026-11-03.
- The same class of defect was fixed in the protocol files by resolving policy references from the Global AI Policies Directory.
