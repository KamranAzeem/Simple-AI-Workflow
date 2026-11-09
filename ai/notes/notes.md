## How to process this file

**Notes to AI assistant:**

* When you process ideas in this file, and implement them successfully (and fully), then mark the point as Processed. If there is ambiguity/doubt, then instead of implementing it, you mark it as "more information needed", and then list your question below it.
* Always analyse, present your thoughts, and plan, and then stop.
* When updating main AGENTS.md protocol, run tests to ensure that it is not broken. Run lints, and necessary format checks. Ensure the file and directory paths links are not broken. Also update any necessary documents, and examples, etc.
* When updating any documentation, ensure that it is written in easy , common human readable plain english language. Ensure that no links are broken.

---

Grilling Round 1

For implementation on all of the points, it must be remembered that this workflow is used by end-users in their own project directories. So all paths to various locations must be written accordingly / using relative paths. I think this is already in-place, I just want to highlight it's importance. I want you to confirm to be that you are aware of this, and you know how to handle/write paths.

1. Where do procedure definitions live in the end state? 

Procedure bodies live in one file per procedure under (Global AI Workflow Directory)/ai/procedures/, anchored as the Global AI Procedures Directory.
Each file holds the procedure body: the ### PROCEDURE <NAME>: ... heading, its trigger declaration (format decided in Q4), and the numbered steps.
The file stem is the canonical procedure name in lowercase kebab case, for example load-context.md.
AGENTS.md keeps the always-on read-first rules, the router, the single dispatch and index step, and no procedure bodies.
At boot, the index reads procedure filenames and trigger lines only. The body is read when the procedure is invoked, then it runs once.
Policies never hold procedure bodies. Procedure and policy stay separate module types, and the type comes from the directory.
No project-level procedures directory: no ai/procedures/, no project anchor, no scan. If a user creates one, its files are inert.
The indexer takes a directory list. A project tier can be added later as one list entry plus a precedence rule, with no parser or format change.
Staging: procedures stay in AGENTS.md until the thinning stage. v0 does not move them. validate-protocol.sh and test-protocol-references.sh move to the procedure store in the same thinning change.


2. Do policies and procedures share one trigger namespace? 

Yes. One namespace, one uniqueness check. A trigger that resolves to two modules is a validator failure, not a precedence puzzle. This removes the entire "who wins" branch.


3. Is there a generated registry file? No. A generated registry drifts and becomes a second source. The sources are the live modules; the index is rebuilt in memory at each boot. Keep it ephemeral.

4. What is the exact declaration format? ## Triggers with one literal phrase per bullet, exact phrase only, no wildcards, no metadata beyond the phrases. Module type comes from the directory, never from a field inside the file. That prevents a declaration from disagreeing with its location.

5. How is a trigger matched? Whole-phrase match against the user message; longest matching phrase wins. No fuzzy matching, no keyword extraction, no AI intent matching in v0. The heading index is for candidate discovery, not for dispatch decisions.

6. What is loaded, and for how long? A triggered policy loads in full for the session, matching the v0 ticket. A triggered procedure executes once. There is no unload command; a new session resets. Define this in the declaration's owning procedure, not per file.

7. What happens when a module has no triggers? It keeps today's behavior. A policy loads through Active Expertise or explicit request; a procedure runs through its existing aliases. No declaration means "not triggerable", not "broken".

8. What is indexed, and when? Filenames, trigger lines, and headings. Never bodies. At load context, post-compaction recovery, and checkpoint re-affirmation, through one shared step. If headings are not needed until the broad ticket, index filenames and trigger lines first, but design the index output to carry headings so the second stage adds no new format.

9. What is the discovery scope, and what does Protocol Developer Mode do? Global and project policy directories plus the procedure store. In Protocol Developer Mode, index trigger lines and headings from the distribution tree but do not load bodies. The current exception is about loading; indexing is a different cost. State that explicitly so the exception does not become a hole.

10. Where does the index logic live? My recommendation: one executable, support-files/index-protocol.sh, with a PowerShell twin, a single documented output contract, and one fixture test that asserts both produce identical output. The AI runs it at boot; the validators call it. No consumer writes its own grep logic. That is the strongest anti-duplication move available, and it makes "self-standing" real without five parsers.

11. What does the validator do with a bad declaration? A malformed block, a duplicate trigger, a missing file, or a name mismatch is a release-blocking validator failure. At runtime, an unreadable module is report-and-skip, never a hard stop. Fail early in CI, fail soft in the session.

12. How do project, global, and Expertise interact? Project wins over global by module name and the override is reported. Active Expertise keeps loading exactly as today. A trigger loads a module; it never overrides always-on rules, AGENTS.md, or the customization file. A collision between a project and a global module is an override; a collision between two triggers is invalid.

13. Where does the shared indexing step live? One named step, defined once in AGENTS.md, referenced by load context, recovery, and checkpoint re-affirmation. AGENTS.md is already read at boot, so this adds no new always-loaded policy, and it prevents three copies of the same step text. The reference test already resolves cross-file step references, so the mechanism exists.

14. What is the target for AGENTS.md? Router plus always-on rules plus the one index step. Policy triggers leave AGENTS.md in the broad stage. Procedure bodies leave only in the thinning stage, one module at a time, with anchors and tests migrated in the same change. Policies never hold procedure bodies.

15. How do we guarantee the acceptance criteria do not mutate? Write behavioral criteria plus invariants, not implementation steps. At minimum: a new policy needs no AGENTS.md edit; no consumer re-implements the indexer; a duplicate trigger fails validation; every declaration resolution comes from one parser; the index contains no body text; project overrides global; a module without declarations behaves as today; the reference test and validator cover all three stages. A later change that breaks one of these is a breaking change that needs an ADR, not a quiet edit.

16. What is the sequencing? One design decision, then v0, then the broad ticket, then thinning. Do not implement both tickets in one branch. v0 must already use the final indexer and the final declaration shape, even if it only indexes policies. The broad ticket adds discovery, headings, and dispatch. Thinning is a third release with its own migration shim.

Answer these in order. Your answers to 1, 4, 10, and 14 decide whether this is one mechanism or three, and the next round will follow the branches they open.

