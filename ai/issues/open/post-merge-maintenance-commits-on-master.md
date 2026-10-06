Reported: 2026-10-06
Reporter: Kamran Azeem (via Kilo)
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P4)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Decide whether post-merge maintenance commits on master (plan removal, ADR merge record with the squash SHA) are a real problem, and if so, fold branch paperwork into the branch before the squash merge.

Description:

## What was observed

After the descriptive-names feature was squash-merged, `master` showed two commits in a row:

- `f311fe7` feature(protocol): rename procedures, steps, and tiers to stable kebab names (the feature squash)
- `7d733b3` chore(ai): record the naming rename merge and remove the plan (a post-merge housekeeping commit)

The second commit did two things: appended the ADR "Merge record" to `protocol-decisions.md`, and deleted the executed plan from `ai/plans/`.

## Root cause

The protocol currently forces this second commit:

- The plan's Process step says "After merge, remove this executed plan from `ai/plans/`."
- The ADR convention appends a "Merge record" containing the squash SHA, for example "Squash-merged ... as `f311fe7`".
- Neither can happen before the merge, because the squash SHA does not exist until after the squash.

So every feature leaves one or more maintenance commits on `master`, separate from the feature itself.

## Why this may not be a problem

- The history is already consolidated: the feature is a single squash commit, and the housekeeping commit is small and rare (one per feature).
- The SHA in the ADR merge record is a useful audit trail linking a decision to the exact commit that implemented it.
- `7d733b3` is also the record that the plan was removed, which is arguably worth keeping.
- Rewriting history to remove such commits has its own cost and risk, especially once pushed.

## Why it may be a problem

- The user considers these "maintenance type small little commits" as noise on `master`.
- The branch is the natural unit of work. Everything the branch produces (plan removal, ADR completion, ticket close) arguably belongs inside the squash, not after it.
- The ticket already closes on the branch; the plan removal and merge record do not, which is inconsistent.
- The state-file model v2 already banned branch/hash/push metadata from the state files. Keeping a SHA in ADR merge records is a leftover of the same pattern.

## Options to weigh

1. **Leave as-is.** Post-merge housekeeping commits are acceptable; the audit SHA is worth it. Close this as P4 / not an issue.
2. **Fold plan removal into the branch, drop the SHA.** Remove the executed plan as part of the branch's final change, and change ADR merge records to not include a commit SHA ("Squash-merged into `master` on YYYY-MM-DD"). One commit per feature, still an audit note.
3. **Fold plan removal into the branch, drop merge records entirely.** Rely on `git log` for the date; ADR entries describe decisions, not merges.
4. **Keep the SHA, clean up at checkpoint.** Allow the post-merge commit, then squash it away at the next checkpoint. Rejected on first read, because it rewrites published history as a routine habit.

## Questions to answer before deciding

- Is the squash SHA in an ADR merge record actually used, or is it ceremony?
- Should an executed plan be removed at all, or archived somewhere (for example the daily checkpoint already records the merge)?
- If a SHA is dropped from future merge records, do we leave the existing historical merge records alone? (Presume yes; history is not rewritten.)
- Is there any external consumer (a hook, a script, a human workflow) that depends on the merge record SHA?

## Constraints

- Historical ADR entries and daily checkpoints are not rewritten.
- Any change here is a protocol change and needs its own ADR.
- Related: the 2026-09-17 "no pre-work commits on master" decision (closed ticket `pre-work-commits-on-master.md`) fixed the front end of this problem (nothing before the branch). This ticket is about the back end (nothing after the squash).

Filed as a discussion. No decision yet; evaluate whether this is worth solving before proposing a fix.
