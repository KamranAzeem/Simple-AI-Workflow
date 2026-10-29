> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.

# Protocol Routing Principle

## Context

`AGENTS.md` is a router, not a catalog. A rule belongs in one of three places: the read-first rules, a triggered procedure with its own policy, or Active Expertise loaded at boot.

## Rule or Fix

- Put a rule that applies to every task and is costly to break in the read-first rules tier.
- Put situation-specific behavior in its own policy reached by a trigger phrase.
- Put persistent domain behavior in Active Expertise.
- Keep the read-first rules tier small.
- Avoid adding a per-feature pointer to a rule that the routing mechanisms already reach.

## Why

- A router keeps `AGENTS.md` short.
- Three activation mechanisms already wire the rules.
- A growing catalog dilutes attention and raises boot cost.

## Verify

- Confirm a new rule fits one mechanism.
- Confirm a trigger phrase is unique.
- Confirm the rule is not a second copy of an existing owner.
- Confirm `AGENTS.md` did not grow a new pointer without a routing reason.

## Caveats

- The consolidation follow-up lives in `ai/issues/open/tier2-vs-non-negotiables-consolidation.md`.
- The read-first rules and the common policy both claim an always-on role; the consolidation is unresolved.
