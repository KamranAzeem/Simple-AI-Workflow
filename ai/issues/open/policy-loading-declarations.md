Reported: 2026-11-18
Reporter: Kamran Azeem
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P3)
Size: S
Label:
URL:
Summary: Declare the load path on the 13 policies that lack a Loading section, or record the exemption

Description:

- The audit found 13 of 23 policies with no `## Loading` declaration. The index reports their mode as `legacy`, which hides the intended path.
- Add `Mode: trigger` to `api-backend`, `cloud`, `data`, and `dba`; they already declare triggers.
- Add `Mode: procedure` with `Load in:` to `code-review`, `codebase-examination`, and `handoff`; their procedures load them by name.
- Add `Mode: expertise` to `coding-baseline`, `mobile-apps`, `observability`, and `web-frontend`, or record why they stay legacy.
- Record the intended path for `common` (explicit boot load) and `meta` (Active Expertise); do not add a wrong mode just to fill the field.
- No rule text changes. Validate with `--index` and the full suite.

## Acceptance Criteria

- Every policy either declares a mode consistent with its real load path or carries a recorded exemption.
- `--index` reports the declared mode for each touched policy.
- The load-path fixture and the full suite pass.
- No policy rule changes.
- Peer review APPROVED.
