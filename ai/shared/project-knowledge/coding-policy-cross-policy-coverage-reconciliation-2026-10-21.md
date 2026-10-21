# Coding Policy Cross-Policy Coverage Reconciliation 2026-10-21

Purpose: record which practices the coding policy shares with another policy, which rule the coding policy now owns, and what to reconcile when either side changes. This note keeps `ai-policy-coding-baseline.md` from becoming a second source of truth.

Model (2026-10-21): the coding policy now uses a thin core plus pointers. Cross-cutting practices are referenced, not operationalized. Where an entry below says "operationalized", it now means the owner holds the detail and the coding policy references it. Telemetry defaults on for production code and off for non-production code.

## Shared Practices

### Resilience and idempotency

- Owner: `ai-policy-api-backend.md` (`Idempotency`, timeout and retry behavior), `ai-policy-mobile-apps.md` (`Retry & Resilience`).
- Coding policy rule: `## Resilience`.
- State: operationalized. Timeout, retry, idempotency, cancellation, shutdown, and backpressure actions are in the coding policy. Domain detail stays with the owners.
- Reconcile: compare the coding rules with the owner sections when either changes.

### Public contracts and compatibility

- Owner: `ai-policy-api-backend.md` (`Contract Tests`), `ai-policy-data.md` (`Schema Validation`), `ai-policy-common.md` (`Universal Engineering Standards`, Semantic Versioning).
- Coding policy rule: `## Module and Interface Design`.
- State: operationalized. The contract, deprecation, migration path, and version decision are in the coding policy. Test detail stays with the owners.
- Reconcile: confirm a breaking change still follows SemVer and the API and data contract tests.

### TDD and testing

- Owner: `ai-policy-common.md` (`Universal Testing Standards`).
- Coding policy rule: `## Tests and Verification`.
- State: operationalized. The TDD action, regression test, public-interface test, and performance test rules are in the coding policy.
- Reconcile: if the common policy changes the TDD rule, update the coding policy action.

### SOLID, DRY, YAGNI, Twelve-Factor

- Owner: `ai-policy-common.md` (`Universal Engineering Standards`).
- Coding policy rule: `## Module and Interface Design`, `## Functions and Naming`, `## Configuration`, `## Resilience`.
- State: partly operationalized. Single responsibility, interface segregation, dependency inversion, DRY, YAGNI, and configuration are explicit coding rules. The remaining Twelve-Factor items stay with common and the delivery policies.
- Reconcile: decide whether the remaining factors need coding bullets or keep the reference.

### OWASP, STRIDE, secure development

- Owner: `ai-policy-common.md` (`AI-Driven Secure Development Practices`).
- Coding policy rule: `## Security`, `## Errors and Failure`, `## Telemetry`.
- State: operationalized for secrets, authorization, input validation, injection, output encoding, personal data, and cryptography. Threat modeling detail stays with common.
- Reconcile: confirm the coding rules still map to the current OWASP Top 10.

### Encryption and key management

- Owner: `ai-policy-data.md` (`Encryption and Key Management`), `ai-policy-dba.md` (`Encryption`), `ai-policy-mobile-apps.md` (local encryption).
- Coding policy rule: `## Security`.
- State: operationalized for library choice, no custom crypto, secure randomness, key storage, and password-derived keys. Algorithm, rotation, and at-rest detail stay with the owners.
- Reconcile: align the crypto rules with the data policy key rotation and the mobile local-storage rules.

### Accessibility

- Owner: `ai-policy-web-frontend.md` (`## Frontend Engineering Standards`, accessibility rules).
- Coding policy rule: reference only. No general accessibility bullet.
- State: reference only. The policy applies to the web-frontend domain.
- Reconcile: decide whether a UI-specific coding rule is needed or the domain reference is enough.

### Observability

- Owner: `ai-policy-observability.md` (`## Four Golden Signals`, `## Logs, Metrics, and Traces`).
- Coding policy rule: `## Telemetry`.
- State: owned by the observability policy. The emission rules are now in the policy, and the coding policy keeps only the production/non-production classification and the default-on gate.
- Reconcile: confirm the coding-baseline reference points at the migrated section names.

### Generated file validation

- Owner: `ai-policy-common.md` (`Generated File Validation`).
- Coding policy rule: `## Dependencies and Tooling`.
- State: partly covered. The coding policy runs code formatters, linters, and type checkers. Non-code file validation stays with common.
- Reconcile: confirm the coding tooling rule does not duplicate the file-type list in common.

### Caching

- Owner: `ai-policy-api-backend.md` (data management and caching strategies), `ai-policy-mobile-apps.md` (offline cache).
- Coding policy rule: `## Concurrency and Performance`.
- State: operationalized for key, invalidation, bounds, and sensitive data. Domain strategy stays with the owners.
- Reconcile: align the cache rules with the domain policies when they change.

### Dependency injection

- Owner: `ai-policy-common.md` (preserve existing patterns), `ai-policy-mobile-apps.md` (dependency injection), `ai-policy-api-backend.md` (preserve the DI pattern).
- Coding policy rule: `## Module and Interface Design`.
- State: operationalized. Receive a dependency as a parameter or constructor argument, and do not construct it in business logic.
- Reconcile: confirm the rule matches the project's DI framework.

## Practices Owned by the Coding Policy

These have no other policy owner. The coding policy is their single source:

- Time handling: UTC timestamps, display-boundary conversion, injected clock, monotonic durations.
- Dependency supply chain: license, vulnerabilities, version pinning, lockfile.
- Log levels: error for actionable failures, expected conditions at info or debug.
- Named constants: meaningful literals, module scope, configuration for environment values.
- Test quality: regression test per defect fix, public-interface tests, performance tests for stated targets.

## Open Reconciliation Candidates

- Accessibility: decide whether the coding policy needs a UI rule.
- Twelve-Factor: decide whether the remaining factors need coding bullets.
- Generated File Validation: confirm the split between code tooling and all-file validation.
- Test quality: confirm the regression and performance test rules against the domain policies.

## Change Log

- 2026-10-21: Created with the coding policy expansion. Eleven shared practices and five coding-owned practices were mapped.
- 2026-10-21: Observability migration complete; the emission rules are now owned by `ai-policy-observability.md`.
- 2026-10-21: Authoring-standard migrations complete for web-frontend, API backend, mobile-apps, cloud, DBA, data, and observability; the coding-baseline references are aligned.
