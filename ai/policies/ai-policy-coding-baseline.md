# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Coding Baseline

Govern how the AI writes and changes program code in any language when this policy is active.

## Scope

- Apply this policy to program code the AI creates or changes in the active project.
- Apply this policy to source files, tests, build scripts, and infrastructure-as-code for that project.
- Do not apply this policy to protocol files, project knowledge, plans, or project documentation unless the user includes them in the request.
- Treat this policy as the base layer for code construction, not a replacement for a domain policy.
- Treat `ai-policy-common.md` as the owner of the engineering principles this policy applies.
- Load and follow the domain policy that owns the concern at hand.
- Activate this policy when the **Project Customization File** lists `coding-baseline` under `## Active Expertise` or the user asks for the coding baseline policy by name.
- Apply this policy for the rest of the session after activation.
- Stop applying this policy when the user says to stop or the session ends.

## Activation

- Announce once that the coding baseline policy is active.
- Apply this policy to new code and to code changed inside the requested scope.
- Do not modify existing code when this policy activates.
- Do not reformat, rewrite, or re-instrument code outside the requested scope.
- Do not run a project-wide cleanup or instrumentation pass without an explicit request.

## Existing Code Discipline

- Read the surrounding module, and its tests and configuration when they exist, before writing code.
- Follow the conventions, patterns, and idioms already used in the file and module.
- Preserve runtime behavior unless the request changes it.
- Change existing code only inside the requested scope.
- Remove dead code only when the removal is inside the requested scope.
- When the project provides a formatter or linter, run each on changed files only.
- Do not present placeholder or stubbed code as complete.

## Module and Interface Design

- Give each module one business purpose.
- Keep related logic inside one module.
- Expose a narrow public interface and hide implementation details.
- Split a module only at a public surface, a dependency cycle, an ownership boundary, or a reuse boundary.
- Use composition over inheritance unless the language provides a standard pattern for the problem.
- Treat each public interface as a contract and preserve it unless the request changes it.
- Deprecate an interface before removal and state the migration path.
- Receive a dependency as a parameter or constructor argument instead of constructing it in business logic.

## Functions and Naming

- Name identifiers by domain intent.
- Use an abbreviation only when the language or the project glossary defines it.
- Give each function one job.
- Size a function by the number of jobs it performs, not by line count.
- Replace a boolean parameter that selects behavior with a separate function or a named option.
- Keep call chains inside one abstraction boundary.
- Exempt fluent APIs and builders from the call-chain rule.
- Use the language's standard idiom for return values and errors.
- Replace a literal that carries meaning with a named constant scoped to its module.

## Data and State

- Make invalid states unrepresentable when the type system allows it.
- Use immutable values by default.
- Record each exception for performance or language idiom at the definition site.
- Keep side effects at the module boundary.
- Define null, empty, missing, and optional behavior for every input and output.
- Release resources on every path, including error paths.
- Store and transmit timestamps in UTC, and convert to a local time zone only at the display boundary.
- Inject the clock when time affects behavior.
- Use a monotonic clock for durations.

## Configuration

- Read configuration from the environment or the project's configuration system.
- Validate required configuration at startup and fail with an error that names the missing key.
- Do not hardcode an environment-specific hostname, port, path, or credential.
- Keep a default only when the default is safe for every environment.
- Keep process state in a backing service, not in process memory.

## Errors and Failure

- Validate input at the system boundary.
- Fail fast on invalid input and on violated invariants.
- Use the language's error idiom: exceptions, result types, or error returns.
- Never swallow an error.
- Add context to a propagated error.
- Keep secrets and personal data out of error messages.
- Do not add a silent fallback that hides a failure.
- State each required fallback and its default in the code and in the report to the user.
- Do not log and rethrow the same error more than once.

## Concurrency and Performance

- Define the owner of each piece of shared mutable state.
- Use message passing or immutable values when the language supports them.
- Measure before optimizing.
- State the time or space cost when the request depends on it.
- Bound queues, pools, and buffers.
- Define the behavior when a bound is reached.
- Define the cache key, invalidation rule, and miss path before adding a cache.
- Bound the cache size and the entry lifetime.

## Comments and Documentation

- Comment why code exists, not what it does.
- Delete commented-out code inside the changed scope.
- Document public interfaces in the language's doc-comment idiom.
- Update a comment when the code it describes changes.
- Treat a stale comment as a defect.

## Telemetry

- Treat logs, metrics, and traces as telemetry.
- Analyze the scope before writing code and classify it as production or non-production.
- Treat a service, an API, a worker, a scheduled job, and a component or module of one as production code.
- Treat test code, examples, exercises, one-off scripts, throwaway prototypes, and a command-line tool that is not a service, API, worker, or scheduled job as non-production code.
- Treat an ambiguous scope as production code.
- Follow the project telemetry standard for production code when it covers the four signals.
- Add telemetry for production code by default when the project has no standard or the standard does not cover the four signals.
- State the classification and the telemetry recommendation in the response before writing code.
- Tell the user that telemetry is highly recommended for production code.
- Add telemetry for production code unless the user declines.
- Ask the user whether to add telemetry for non-production code.
- Default to no telemetry for non-production code.
- Wait for the answer before adding telemetry to non-production code.
- Apply the answer to the requested scope for the rest of the session.
- Record a declined telemetry decision in the response.
- Emit the four signals for every application classified as production when telemetry is enabled.
- Keep telemetry calls out of business logic.
- Never fail a request or job because telemetry export failed.
- Read `ai-policy-observability.md` before writing telemetry code, and follow its emission rules.

## Security

- Follow `ai-policy-common.md` (`AI-Driven Secure Development Practices`).
- Never hardcode a secret, credential, token, or key; read it from the environment or the project's secret store.
- Use the platform's standard cryptography library and a standard password hashing function.
- Never implement a cryptographic algorithm or a security random number generator.

## Testing and Verification

- Write a test for every behavior change and a regression test for every defect fix.
- Follow the TDD rule in `ai-policy-common.md` (`Universal Testing Standards`).
- Test through the public interface, not a private implementation detail.

## Resilience

- Set a timeout on every network call.
- Retry only an operation that is safe to retry, with a bounded count and backoff with jitter.
- Make a job or message consumer idempotent with an idempotency key or a processed-identifier record.

## Dependencies and Tooling

- Use the language's standard library before a dependency.
- Check the license and known vulnerabilities of each new dependency before adding it.
- Pin the dependency version in the project manifest and commit the lockfile.
- Use the project's package manager and build tool when the project provides them.
- Run the formatter, linter, and type checker that the project provides before presenting code.
- Fix findings in the changed files.
- Do not edit generated or vendored files.
- Do not introduce a new package manager, build tool, or test framework without approval.

## Cross-Cutting Pointers

- Apply SOLID, DRY, YAGNI, and Twelve-Factor as defined in `ai-policy-common.md` (`Universal Engineering Standards`).
- Read `ai-policy-web-frontend.md` before writing UI code.
- Read `ai-policy-api-backend.md` before writing a service or API.
- Read `ai-policy-mobile-apps.md` before writing mobile code.
- Read `ai-policy-data.md` and `ai-policy-dba.md` before writing data, schema, or persistence code.
- Read `ai-policy-cloud.md`, `ai-policy-linux-system-admin.md`, or `ai-policy-windows-system-admin.md` before writing IaC or scripts.

## References

- `ai-policy-common.md` (`Universal Engineering Standards`, `Universal Testing Standards`, `AI-Driven Secure Development Practices`, `Generated File Validation`)
- `ai-policy-observability.md` (Four Golden Signals, emission rules)
- `ai-policy-api-backend.md` (Idempotency, caching, contracts)
- `ai-policy-web-frontend.md` (Accessibility)
- `ai-policy-mobile-apps.md` (Retry & Resilience, caching)
- `ai-policy-data.md` (Schema Validation, Encryption and Key Management)
- `ai-policy-dba.md` (Encryption)
- `ai-policy-cloud.md` (Cloud Engineering Standards, Infrastructure Security)
- `ai-policy-linux-system-admin.md` (OS-Specific Standards)
- `ai-policy-windows-system-admin.md` (PowerShell Standards)

<!-- AI-ASSISTANT: READ-ONLY END -->
