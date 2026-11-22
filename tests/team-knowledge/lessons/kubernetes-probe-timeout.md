---
title: Give a slow startup probe its own timeout budget
owner: Kamran Azeem
source_project: platform-baseline
created: 2026-11-22
updated: 2026-11-22
tags: [kubernetes, probes, startup]
status: active
superseded_by:
---

# Give a slow startup probe its own timeout budget

## Context

A pod restarts during a slow start because the liveness probe uses a short timeout and no startup probe.

## Rule or Fix

- Add a startup probe for the slow initialization phase.
- Set the startup probe budget to the measured worst-case startup time plus margin.
- Keep the liveness probe focused on the running state.

## Why

The startup probe suspends the liveness and readiness checks while the process initializes, so a slow start does not look like a crash.

## Verify

- Confirm the pod reaches ready without a restart on a cold start.
- Confirm a real hang still fails the liveness probe after the startup budget ends.
