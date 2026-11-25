> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Upgrade Before Refactor

## Context

An upgrade changes the platform, language version, or dependencies. A refactor changes internal design without changing behavior. Doing both at once makes a failure impossible to attribute: the cause may be a platform change or a logic change.

## Rule or Fix

- Separate the upgrade from the refactor.
- Establish or find a test baseline before the upgrade.
- Upgrade first and make the old code compatible with the new platform.
- Run the tests until the upgrade passes.
- Refactor second, in small steps, with the tests staying green.
- Change no external behavior during the refactor.
- Identify the goal before choosing upgrade, refactor, or rewrite.
- Guard legacy code against global-state coupling.

## Why

- One change at a time isolates the cause of a failure.
- A test baseline protects existing behavior.
- A refactor with no behavior change is easier to review.
- A clear goal prevents a larger rewrite than the problem needs.

## Verify

- Confirm the upgrade passes the test baseline before the refactor starts.
- Confirm the refactor keeps the tests green.
- Confirm the public behavior is unchanged.
- Confirm the work order is upgrade, then refactor.

## Caveats

- Legacy code may need a test harness before either step.
- A rewrite is a separate decision with its own risk.
