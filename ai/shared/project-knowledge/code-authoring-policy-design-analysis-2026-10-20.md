# Code Authoring Policy Design Analysis

Design analysis for `ai/issues/open/code-authoring-policy-and-policy-plugin.md`. Captured on 2026-10-20 while the user could not focus, so the full reasoning survives until work resumes.

Note: superseded in part on 2026-10-21. The policy is now `ai/policies/ai-policy-coding-baseline.md` with expertise token `coding-baseline`, and telemetry defaults on for production code and off for non-production code, with a clear recommendation and an easy opt-out.

## Requirement

The user wants a policy about how to write program code in any language, with three properties:

- It is self-standing and lives as a policy file in the policies directory.
- It is detected on the next boot with its triggers, in a plugin-like way.
- It activates only when the user asks for it, so existing users and their existing code are not disturbed.
- When active, every app it writes or changes emits the telemetry the observability stack needs to capture the Four Golden Signals. Telemetry is part of coding, not an add-on.

## Current protocol gap

The requirement has two parts, and only one exists today.

**The policy text** is straightforward.

**The plugin behavior** is not implemented:

- Policies load because they are listed under `## Active Expertise` in `ai-customization.md` (full load at boot, `AGENTS.md` STEP-POLICY-LOADING) or because a procedure in `AGENTS.md` loads them.
- `## Triggers` is explicitly reserved and rejected: `ai-policy-meta.md` (`## Procedure and Policy Authoring`, Policy Structure), enforced by `support-files/validate-policy-authoring.sh` at the `## Triggers` check.
- The open ticket `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md` describes the same requirement and is marked XL with unresolved decisions.
- `design-docs/protocol-decisions.md` (`2026-10-06: Global Knowledge returns to just-in-time indexing`) says active policies remain full-loaded, because policies are operational rules and are never deferred. A plugin model is a narrow, deliberate exception to that rule.

Without a plugin mechanism, the file is inert for every user. That is safe but does not meet the requirement.

## Recommended architecture

### Part A: minimal policy plugin v0

Implement a small plugin contract, not the full XL ticket.

- A policy declares its own triggers in a `## Triggers` section with one quoted phrase per bullet.
- A policy with `## Triggers` is on-demand. A policy without it keeps today's behavior.
- Boot, post-compaction recovery, and checkpoint re-affirmation index only policy filenames and trigger lines from the global policies directory. They never read the body at boot.
- When a declared phrase appears, the AI loads that policy in full, announces activation, and keeps it active for the session.
- On-demand policies are never full-loaded at boot, including in the project's own `ai/policies/` directory. This is the one change to custom-policy discovery, and it only affects files that opt in by declaring triggers.
- The validator allows `## Triggers`, enforces the declaration shape, and checks trigger uniqueness across `AGENTS.md` aliases and all policies.

This gives the user "place the file, it is detected next boot, nothing activates until asked" without moving procedures out of `AGENTS.md`. The broader dispatcher and heading index can stay in the existing ticket.

### Part B: the policy

New file `ai/policies/ai-policy-code-authoring.md`, expertise token `code-authoring`.

It is not listed under Active Expertise. It is not always-on. Recommended trigger phrases:

- `"code authoring policy"`
- `"use the code authoring policy"`
- `"activate coding standards"`

## Critique of the Gemini draft in `ai/notes/notes.md`

Do not ship the draft as-is.

1. **It contradicts the no-disturbance requirement.** "The Boy Scout Rule" and "always leave it cleaner" invite drive-by refactors. The desired default is the opposite: new code follows the policy, existing code changes only within the requested scope, and there is no mass rewrite or unrelated reformatting without explicit approval.
2. **It duplicates rules the common policy already owns.** SOLID, DRY, YAGNI, Twelve-Factor, TDD, and secure development are already in `ai-policy-common.md`. The authoring standard forbids restating another policy's rules; reference the owning section instead.
3. **It hardcodes idioms that do not hold across languages.** "Never chain calls" breaks fluent APIs and builders. "Throw exceptions" does not fit Go or Rust error returns. "Constructor injection" is not universal. "Immutable by default" is impractical in some languages.
4. **It uses banned normative language and undefined qualifiers.** "should", "wherever possible", "strictly", "short", "cohesive", and "clean" violate the authoring rules in `ai-policy-meta.md`. Every judgment rule must name its criteria and default.
5. **It breaks policy formatting.** It uses emoji and a markdown table, and it lacks the DO NOT MODIFY guard, the READ-ONLY markers, `## Scope`, and `## References`.
6. **It misses what actually protects existing code.** Follow the surrounding code's conventions, run the project formatter and linter, never edit generated or vendored code, add no dependency without approval, do not swallow errors, remove no code outside scope, and do not present placeholder code as complete.

## On 12-Factor, Four Golden Signals, and TDD

- **TDD** is already owned by `ai-policy-common.md` (`Universal Testing Standards`). Reference it.
- **Twelve-Factor** is already owned by `ai-policy-common.md` (`Universal Engineering Standards`). It is architecture and deployment, not code construction. Reference it and do not expand it in the code policy.
- **Four Golden Signals** is owned by `ai-policy-observability.md`, but the user has decided that emitting the telemetry for it is part of coding. The code policy carries the obligation to emit; the observability policy keeps the definitions, thresholds, retention, sampling, and alerting. Do not duplicate those.

The resolution is a division of authority, not omission: the code policy says every app the AI writes or changes must produce the signals, and points to the observability policy for what the signals mean and how the stack consumes them.

## Proposed policy outline

Working title: `# AI Policy: Code Authoring`.

Purpose: govern how the AI writes and changes program code in any language when this policy is active.

Sections to include:

- `## Scope`: code the AI writes or changes in the active project, in any language. Does not apply to protocol files, docs, or config unless asked. Applies only after activation by a declared trigger.
- `## Activation`: loaded on trigger, stays active for the session, announces activation, never rewrites existing code on activation, can be deactivated.
- `## Existing Code Discipline`: read the surrounding code and follow its conventions first. New code follows this policy. Existing code changes only within the requested scope. No mass rewrite, no unrelated reformatting, no drive-by cleanup without explicit approval. Preserve public behavior unless the task asks to change it. Remove dead code only when it is in scope. Run the project formatter on changed files only.
- `## Module and Interface Design`: deep modules with narrow public interfaces and cohesive internals. One business purpose per module, not one method per class. No micro-file sprawl. Split only for a real boundary such as a public surface, a dependency cycle, ownership, or reuse. Hide implementation details. Prefer composition over inheritance unless the language idiom favors otherwise.
- `## Functions and Naming`: name by domain intent. No abbreviations except established ones. One job per function. Size by intent, not by line count. Keep related logic together. Avoid parameter lists that signal a missing abstraction. Apply the Law of Demeter as a default and allow fluent APIs, builders, and same-abstraction chains. Avoid boolean flag parameters that change behavior.
- `## Data and State`: make invalid states unrepresentable where the language allows. Immutability by default with documented exceptions for performance or language idiom. Keep side effects at the edges. Define null, empty, and optional semantics explicitly. Manage resources deterministically, including on error paths.
- `## Errors and Failure`: validate at boundaries and fail fast. Use the language's error idiom. Never swallow errors. Add context to errors. Keep secrets and personal data out of messages and logs. No silent fallback that hides a failure unless the task requires it and the default is stated. Do not log and rethrow the same error repeatedly.
- `## Telemetry`: mandatory for every app the AI writes or changes. Emit latency, traffic, errors, and saturation for each request, job, and message consumer. Use the project's instrumentation library, or OpenTelemetry where the project has no standard. Apply the correlation and cardinality rules in `ai-policy-observability.md` when emitting logs, metrics, and traces. Keep telemetry out of business logic. Never fail a request because telemetry export failed. Expose health and readiness signals where the runtime expects them. A missing signal is a defect, not a deferred task.
- `## Dependencies and Tooling`: use the standard library first. Add a dependency only with explicit approval and state why and the maintenance cost. Use the project formatter, linter, and type checker and fix findings before presenting code. Never edit generated or vendored code. Do not introduce a new package manager.
- `## Tests and Verification`: behavior changes come with tests. Follow the project's test framework and the common policy's TDD rule. Test failure modes and boundaries, not only the happy path. Make tests deterministic and mock external services at the boundary. Run the relevant suite and report the exact command and result. Do not present untested code as complete; state what was not run and why.
- `## Comments and Documentation`: comment why, not what. Delete commented-out code. Document public interfaces in the language's doc-comment idiom. Update comments with the code; a stale comment is a defect.
- `## Concurrency and Performance`: define ownership of shared mutable state. Prefer message passing or immutability. Do not optimize before measuring. State the complexity or resource cost when it matters.
- `## References`: `ai-policy-common.md` (Universal Engineering Standards, Universal Testing Standards, AI-Driven Secure Development Practices, Generated File Validation), `ai-policy-observability.md` (Four Golden Signals), the domain policies (`ai-policy-api-backend.md`, `ai-policy-web-frontend.md`, `ai-policy-mobile-apps.md`, `ai-policy-data.md`), and `design-docs/protocol-decisions.md`.

Security: reference the common policy's `AI-Driven Secure Development Practices` instead of restating it. Add only code-specific rules that the common policy does not own, such as never hardcode secrets and never write personal data to logs.

## Proposed change set

- New `ai/policies/ai-policy-code-authoring.md`.
- `AGENTS.md`: add the bounded trigger index to STEP-POLICY-LOADING, add the dispatch and activation rule, extend the recovery and checkpoint re-affirmation indexes, and add a proof-of-load item.
- `ai/policies/ai-policy-meta.md`: replace the "reserved" rule with the trigger declaration standard.
- `support-files/validate-policy-authoring.sh`: allow and validate `## Triggers` and check uniqueness across all policies.
- `support-files/validate-protocol.sh`: either add the new policy to the baseline and change the count to 18, or replace the fixed list with a scan of all `ai-policy-*.md` plus a small required-core list. The scan fits a drop-in plugin model better.
- `docs/ai-customization-guide.md`, `docs/workflow-guide.md`, `docs/ai-customization.md`, `README.md`, `docs/simple-ai-workflow-slides.md`, and `docs/simple-ai-workflow-compared-to-all-ai-assistants-out-there.md`: document on-demand policies and update the policy count.
- A plan under `ai/plans/` with an HLD, an LLD with acceptance criteria, and one ADR entry in `design-docs/protocol-decisions.md`.
- Branch before any edit, peer review after, then the main validator, the authoring validator, the reference-integrity test, and markdownlint.

## Open decisions

1. **Activation lifetime**: session-scoped after one explicit phrase (recommended), or only for the next request.
2. **Trigger phrases**: the three listed above, or the user's own wording.
3. **Existing code**: confirm the default is "new code follows the policy, existing code only within the requested scope, no drive-by cleanup". This is the most important rule for the no-disturbance goal.
4. **Plugin scope**: implement the minimal v0 now, or ship the policy as an Active Expertise opt-in first and defer triggers.
5. **Name**: `code-authoring` is recommended. `software-engineering` overlaps the common policy and invites always-on loading.
6. **Language examples**: keep the policy language-neutral now, with per-language examples as separate optional plugins later.
7. **Telemetry scope**: make telemetry mandatory whenever the code policy is active (recommended, consistent with opt-in adoption), or make it always-on through the common policy. Always-on would change every existing user immediately, which conflicts with the no-disturbance goal. Also confirm the app boundary: services, APIs, workers, and scheduled jobs emit the four signals; CLI tools and one-off scripts emit structured logs only.

## Evidence read

- `AGENTS.md` (all procedures and tiers).
- `ai/policies/ai-policy-common.md` (531 lines).
- `ai/policies/ai-policy-meta.md` (160 lines).
- `ai/policies/ai-policy-observability.md`.
- `support-files/validate-policy-authoring.sh` (236 lines).
- `support-files/test-protocol-references.sh` (91 lines).
- `support-files/validate-protocol.sh` (policy baseline section).
- `design-docs/protocol-decisions.md` (521 lines).
- `docs/ai-customization-guide.md` (137 lines).
- `docs/how-policies-work-in-this-workflow.md` (48 lines).
- `ai/issues/open/self-contained-policy-triggers-and-heading-jit-index.md`.
- `ai/issues/open/policies-to-skills-rename.md`.
- `ai/notes/notes.md` (47 lines, the Gemini draft).
