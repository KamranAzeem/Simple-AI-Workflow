---
title: Raise the PostgreSQL connection pool before max_connections
owner: Kamran Azeem
source_project: platform-baseline
created: 2026-11-22
updated: 2026-11-22
tags: [postgresql, connection-pool, capacity]
status: active
superseded_by:
---

# Raise the PostgreSQL connection pool before max_connections

## Context

An application pool exhausts before the server limit is reached, and each new connection waits behind a saturated pool.

## Rule or Fix

- Measure the active connections and the pool wait time together.
- Raise the pool size before raising the server connection limit.
- Keep the pool size below the server limit minus the reserved administrative connections.

## Why

A larger server limit does not help when the client pool is the bottleneck, and it hides the real queue.

## Verify

- Confirm the pool wait time falls after the change.
- Confirm the server connection count stays below the limit at peak load.
