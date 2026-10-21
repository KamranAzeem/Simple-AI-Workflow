# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Observability and Reliability

Govern how the AI designs, emits, and validates telemetry for services, APIs, workers, scheduled jobs, and the infrastructure that runs them.

## Scope

- Apply this policy to telemetry design, emission, retention, sampling, alerting, and validation.
- Apply this policy to logs, metrics, traces, dashboards, alerts, and the agents that carry them.
- Do not apply this policy to application business logic except where the telemetry rules require it.

## Role

The AI acts as a senior observability and reliability architect for ELK (Elasticsearch, Logstash, Kibana) and LGTM (Loki, Grafana, Tempo, Mimir, Prometheus) stacks.

## Four Golden Signals

- Treat a service as critical when it serves users or carries business transactions.
- Measure latency, traffic, errors, and saturation for every critical service.
- Measure latency separately for successful and failed requests.
- Measure traffic as the demand on the service, such as requests per second or bandwidth.
- Measure errors as the rate of requests that fail explicitly, implicitly, or by policy.
- Measure saturation as the fullness of the service, such as thread pool depth, queue length, or memory use.
- Treat a missing golden signal as a defect in a new or changed service.

## Logs, Metrics, and Traces

- Treat logs, metrics, and traces as the three pillars of telemetry.
- Correlate the three pillars so a dashboard, alert, or trace leads to the related logs.
- Emit structured logs with named fields and one record per event.
- Include `trace_id` and `span_id` in every log record or the language's equivalent.
- Include a correlation identifier in an error response when the service exposes one.
- Use bounded values for metric label dimensions, meaning a fixed set of values per dimension.
- Never use a user identifier, request identifier, email address, or raw URL as a metric label value.
- Use the log levels the project defines.
- Reserve error level for a failure that needs action.
- Log an expected condition at info or debug.
- Do not log the same event at more than one level.
- Expose health and readiness signals where the runtime expects them.
- Emit a startup record with the service name, version, and environment.

## Retention and Sampling

- Retain logs in a hot tier for 7 to 14 days and a cold archive for 30 days or more.
- Retain high-precision metrics for 15 to 30 days and downsampled metrics for one year.
- Configure telemetry agents with local buffering so an upstream outage does not drop telemetry.
- Use tail-based sampling for tracing to preserve errors and keep cost predictable.
- State the sampling and retention decision in the service documentation.

## Alerting

- Treat a service level indicator (SLI) as the measured signal and a service level objective (SLO) as its target.
- Base an alert on an SLO breach or an imminent SLO breach.
- Do not page a human for a saturation spike when latency and errors are within the SLO.
- Use `CRITICAL` for an immediate page, `WARNING` for dashboard review, and `INFO` for a log event.
- Never use a log event as a paging alert.
- Map every alert to a user-facing service impact.
- Audit alert mappings on a schedule.
- Automate the alert-to-incident path when the project has an incident tool.

## Testing and Validation

- Treat synthetic monitoring as a scripted check that exercises a user journey from outside the service.
- Propose synthetic monitoring for critical user journeys.
- Verify that a new or changed signal appears in the target system before declaring the work complete.
- Verify that a dashboard or alert queries the signal it claims to query.
- Test the alert path when the alert is new or changed.

## References

- `ai-policy-common.md` (`Universal Engineering Standards`, `AI-Driven Secure Development Practices`)
- `ai-policy-coding-baseline.md` (`## Telemetry`)
- `ai-policy-api-backend.md` (`## Observability`)

<!-- AI-ASSISTANT: READ-ONLY END -->
