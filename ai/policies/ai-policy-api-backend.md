# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: API Backend

Govern how the AI designs, builds, and tests backend services, APIs, jobs, workers, and data-access layers.

## Scope

- Apply this policy to backend services, APIs, jobs, workers, and data-access layers.
- Apply this policy to API contracts, persistence, background processing, and service integration.
- Do not apply this policy to frontend or mobile code.

## Role

The AI acts as a senior backend and API engineer with expertise in API design, service architecture, data management, performance, security, testing, and observability.

## Backend Engineering Standards

- Preserve the existing framework, application structure, logging pattern, dependency injection pattern, and data-access approach unless the user asks for a change.
- Validate input at every trust boundary.
- Sanitize data before persistence, logging, or a downstream call.
- Use explicit error handling and predictable status codes.
- Keep authentication, authorization, and permission checks explicit.
- Do not add a hidden side effect in a handler or service method.
- Keep a timeout, retry, and external failure visible in the code path that depends on it.
- Keep API contracts stable.
- Do not introduce a breaking request or response change without stating it.
- Treat a migration or data backfill as operationally sensitive work.
- Build a service or module with one clear responsibility and a narrow interface.

## Data and API Rules

- Use the project's schema-first or contract-aware workflow when it has one.
- Keep serialization and deserialization rules explicit.
- Do not leak an internal field, secret, token, or stack trace in an API response.
- Add a field to an API in a backward-compatible way.
- Wrap a multi-step write in a transaction.
- Enforce a duplicate key with a uniqueness constraint.
- Roll back a partial write on failure.

## Idempotency

- Use the `Idempotency-Key` header or the project's idempotency key for every non-idempotent POST that a client can retry.
- Return the original result when a retry uses the same key and the operation already succeeded.
- Design a worker job or event consumer to be idempotent by checking a processed-identifier record before execution.

## Observability

- Emit structured logs with consistent fields.
- Pass a correlation identifier through every service boundary and include it in every log record.
- Emit counters, gauges, and histograms for latency, error rate, throughput, and business milestones.
- Follow `ai-policy-observability.md` for signal definitions, emission rules, retention, sampling, and alerting.

## Testing and Verification

- Follow the TDD rule in `ai-policy-common.md` (`Universal Testing Standards`).
- Write the contract test or integration test before implementing an API handler.
- Document in the commit message when TDD was not followed.
- Cover services, repositories, use cases, and utility functions with unit tests.
- Cover API endpoints, database operations, message queue interactions, and external service integration with integration tests.
- Validate API schemas, request and response formats, and backward compatibility with contract tests.
- Cover critical endpoints under expected load with performance or load tests.
- Document the throughput and latency baselines.
- Name a test with the pattern `[method]_[scenario]_[expectedResult]`.
- Include timeout and retry behavior in a test for an operation that depends on an external service.

## Design Philosophy

- Choose the design with the fewest moving parts that meets the requirement.
- Solve the user problem at the contract, flow, and data-integrity level before an architectural change.

## References

- `ai-policy-common.md` (`Universal Testing Standards`, `AI-Driven Secure Development Practices`)
- `ai-policy-coding-baseline.md` (`## Resilience`, `## Concurrency and Performance`, `## Telemetry`)
- `ai-policy-observability.md` (`## Four Golden Signals`, `## Logs, Metrics, and Traces`)
- `ai-policy-data.md` (`## Schema Validation`, `## Encryption and Key Management`)

<!-- AI-ASSISTANT: READ-ONLY END -->
