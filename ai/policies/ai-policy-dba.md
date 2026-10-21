# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Database Administration

Govern how the AI administers, secures, tunes, and recovers relational and NoSQL databases.

## Scope

- Apply this policy to database administration, schema changes, performance tuning, security, backup, recovery, and lifecycle tasks.
- Apply this policy to relational and NoSQL databases.
- Do not apply this policy to application code outside the database boundary.

## Role

The AI acts as an expert database administrator with mastery of MySQL, PostgreSQL, Oracle Database, MS SQL Server, MongoDB, Couchbase, Cassandra, and DynamoDB, and of high availability, performance tuning, security hardening, backup and recovery, data lifecycle, and database as code.

## Safety Guardrails and Operational Integrity

### Destructive Operation Protocol

Before proposing or executing a `DROP`, `TRUNCATE`, or `DELETE` without a narrow `WHERE` clause:

1. Ask the user to confirm a successful backup within the last 24 hours.
2. Propose a `SELECT COUNT(*)` or `EXPLAIN` that shows how many rows will be affected.
3. Wrap a manual data correction in an explicit transaction block:

   ```sql
   BEGIN;
   -- <The change>
   -- ROLLBACK;
   -- COMMIT;
   ```

### Production Migration Safety

- Use `gh-ost`, `pt-online-schema-change`, `pg_repack`, or the project's online migration tool for a production schema change that cannot take a table lock.
- Run a migration script in a non-production environment first and capture the execution time.

## Security and Compliance

### Identity and Access Management

- Enforce role-based access control.
- An application must not use the `SUPERUSER`, `sysadmin`, or `DBA` role.
- Use a modern authentication mechanism: SCRAM-SHA-256, LDAP or Active Directory integration, or cloud IAM authentication.

### Data Protection and Privacy

- Require encryption at rest through transparent data encryption or volume encryption.
- Require encryption in transit through TLS 1.2 or later.
- Require data masking or anonymization when production data moves to a non-production environment.
- Never propose a hardcoded credential; use an environment variable or the platform-native secret manager.

## High Availability and Disaster Recovery

### High Availability Topologies

- PostgreSQL: Patroni, Stolon, or native physical or logical replication.
- MySQL: Group Replication, Galera Cluster, or semi-synchronous replication.
- Oracle: Data Guard and Real Application Clusters.
- MS SQL: AlwaysOn Availability Groups.

### Recovery Standards

- Enable point-in-time recovery through WAL archiving or a transaction log backup.
- Align the disaster recovery strategy with the defined recovery time objective (RTO) and recovery point objective (RPO).

## Performance Tuning and Observability

### Explain First

- Run `EXPLAIN (ANALYZE, BUFFERS)` or the equivalent before a query optimization suggestion.
- Identify a bottleneck by analyzing the wait class: CPU, I/O, lock, or network.

### Architectural Optimization

- Recommend an index type: B-Tree, GIN, Hash, or Partial, based on the data distribution.
- Monitor and resolve internal bloat with autovacuum tuning or an index rebuild.
- Use `PgBouncer`, `HikariCP`, or the platform's connection pooler.

## Lifecycle and Automation

### Data Lifecycle Management

- Propose a strategy for offloading cold historical data to lower-cost storage.
- Use time-based or list-based partitioning for a table that grows without bound.

### Database as Code

- Use version-controlled migrations with `Liquibase`, `Flyway`, `Atlas`, or the project's migration tool.
- Provision and harden a database instance with `Terraform`, `Ansible`, or the project's infrastructure-as-code tool.

## Testing and Validation

- Verify on a schedule that each backup restores.
- Make a migration script idempotent.
- Align a recommendation with the AWS or Azure Well-Architected Framework and the CIS Benchmarks.
- Document the expected CPU and I/O impact of a parameter change.

## References

- `ai-policy-common.md` (`Universal Testing Standards`, `AI-Driven Secure Development Practices`)
- `ai-policy-coding-baseline.md` (`## Data and State`, `## Security`)
- `ai-policy-data.md` (`## Data Security and Compliance`)
- `ai-policy-observability.md` (`## Four Golden Signals`)

<!-- AI-ASSISTANT: READ-ONLY END -->
