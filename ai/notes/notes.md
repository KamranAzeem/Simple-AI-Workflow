## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---


"permission": {
  "bash": {
    "*python3 *": "ask",
    "*python *": "ask",
    "*": "ask"
  }
}


---

## Planning status

The plan exists at `ai/plans/built-in-first-execution-rewrite.md` (489 lines) and the ticket is still open at 131 lines. Markdownlint is clean. No branch exists and no implementation has started.

## Review history

I ran ten independent peer reviews, all recorded in `ai/code-review-reports/` from `review-37` to `review-46`. Every round returned `CHANGES REQUESTED`. The findings were real, not cosmetic: the boot sub-rules, the runtime contract, the proof labels, the docs, and the tests each had gaps.

The plan is **not APPROVED**. The round 10 verdict still lists five Majors:

- The ladder's read ban contradicts the metadata `wc`/`stat`/`find` exception.
- The Level 1 user instruction conflicts with the `"use policy <name>"` always-on exception.
- The proof step is counts-only while the plan adds emitter, reason, and age fields.
- `Default Shell Path` is optional, but the plan reports it as missing on the normal path.
- The Step 6 rewrite omits the author identity, design-docs migration, trigger-only design rule, and the "Global Knowledge is not loaded here" statement.

I have applied fixes for all five and for the round 10 Minors. Round 11 has not run, so those fixes are unverified.

## The decision point

The loop is not converging fast enough for the scope. The plan covers the boot rewrite, a new runtime contract, a helper, a fallback, proof changes, docs, tests, and an ADR amendment. Each review round surfaced another edge case in that surface.

Three honest options:

1. Run round 11. If it approves, implementation can start. If it requests changes again, stop the loop and cut the scope.
2. Cut the scope now. Keep the ladder and precedence rewrite, the built-in boot reads, and the thin helper. Drop the runtime v1 parity and make the fallback a documented best-effort path. That removes most of the remaining review surface.
3. Accept the plan with the five Majors recorded and proceed at your direction. The procedure requires `APPROVED`, so this is your override as the human authority, not a protocol pass.

My recommendation is option 1 first, then option 2 if round 11 fails. The plan is strongest on the boot rewrite and weakest on byte-level parity between the helper and the fallback. That parity is where most of the last six rounds went.

Nothing is committed. The plan, the ticket, and all ten review reports are on disk.