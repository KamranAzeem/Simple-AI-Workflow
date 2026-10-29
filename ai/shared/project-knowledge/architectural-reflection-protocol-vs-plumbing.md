> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.

# Protocol Over Plumbing

## Context

A policy-driven bootstrap turns AI chat into governance as code. The protocol is a set of declarative markdown files. It has no orchestration framework, no background process, and no brittle API. The trade-off is a few hundred startup tokens for thousands saved in correction, hallucinations, and inconsistent behavior.

## Rule or Fix

- Keep the protocol as plain markdown files.
- Load only the policies the project needs.
- Keep policy files short and mandatory.
- Keep lessons in the knowledge stores.
- Use Analyze, Plan, Stop to hold the AI to the task.
- Index knowledge by filename and load it on demand.

## Why

- Plain files stay transparent and portable.
- A small loaded set saves startup tokens.
- The token ROI is high: the rules force safety, compliance, and architectural correctness by design.
- A separate knowledge store keeps the rules short.
- Analyze, Plan, Stop prevents unrequested work.
- Filename indexing keeps the active context small.
- The protocol is version-controlled, portable, and audit-ready.

## Verify

- Confirm the project runs from `AGENTS.md` and policy files.
- Confirm the active policy set matches the project.
- Confirm the knowledge files are indexed, not loaded in full at boot.
- Confirm an inquiry stops before implementation.

## Caveats

- A larger policy set raises startup context.
- A deep framework adds coupling and failure modes.
- The trade-off is deliberate: a small startup cost buys consistent behavior.
