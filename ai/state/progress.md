<!-- STATE-FILE-HEADER: progress.md START -->
**State-file header. Source: `ai-policy-common.md`, section `## State File Ownership Protocol`, subsection `### Canonical State-File Headers`. Canonical; copy verbatim; do not edit.**

- **Write only:** completed work, one entry per line, newest at the bottom.
- **Never write:** transcripts, rationale, plans, commands, implementation steps, investigation notes, or git metadata. Detail goes to the daily checkpoints or Project Knowledge.
- **Brevity:** at most three short bullets per item.
- **Size and archive:** 7 KB soft target; move the oldest completed entries to the daily checkpoints when the file is over the target or holds entries older than 14 days. If the file is still over target, let it exceed and report the overage.
- **Writer:** only the project-root orchestrator writes this file; other agents report on the coordination board.
- **Repair:** if this block is missing or does not match the policy, run `repair state files`. Never rewrite it by hand.

<!-- STATE-FILE-HEADER: progress.md END -->

[2026-11-17] Loaded context and reviewed the tracker: GitHub #10 received the design rewrite and the refined user-facing section; #9 is parked and #8 stays open. No protocol change.
[2026-11-17] Recorded the tool-selection and shell design in Project Knowledge and filed the local ticket: the tool ladder and the git-ignore rewrite are a separate unit; the shell preference stays with GitHub #9; no shell fixture.
[2026-11-17] Audited the common-policy prose shape read-only: 90 multi-sentence rules, 16 rationale bullets, 6 banned words, and 8 prose sections; recorded the debt in the program ticket and filed the L rewrite ticket. No protocol change.
[2026-11-17] Filed the AGENTS.md thinness audit and ran the peer review: verdict CHANGES REQUESTED; the router is at 157/160 lines and 2,399/2,400 words, with nine long bullets, two procedure blocks, and a Single-Writer duplicate. No protocol change.
[2026-11-17] Set the refactor order: AGENTS.md structural cleanup first, then the common-policy prose rewrite, then the other flagged policies.
[2026-11-18] Prepared the v6.6.0 release: the common-policy plug-in split, the loading contract, the custom-policy howto, the five legacy rewrites, and the validator and fixture upgrades; the live test passed, the suite and both validators are green, the release notes are written, and the parent plus 12 child tickets are closed.
[2026-11-18] Refactored AGENTS.md: the boot scan exclusions and the two index step bodies moved to load-context, git workspace detection moved to bootstrap-project, Single-Writer is a pointer, the long bullets are split, and the router-shape fixture is added; the suite and both validators are green, and the v6.6.1 release is prepared.
[2026-11-18] Released v6.6.1 and published its GitHub release: the thinner AGENTS.md is live, the shape fixture guards it, and the release notes are in the user's voice.
[2026-11-18] Rewrote the v6.6.0 and v6.6.1 release notes in the user's voice from his approved drafts, updated the banner, and recorded the voice, draft-first, and no-invented-events rules; no version bump.
[2026-11-18] Added the loading declarations to 12 policies, recorded the common-policy exemption in the ADR, moved the legacy test case, and prepared the v6.6.2 release note from the user's approved text; no rule changed.
[2026-11-18] Released v6.6.2 and published its GitHub release: the 12 load paths are declared, the common policy is exempt, the load-path test pins all four modes, and the note uses the approved plain text.
[2026-11-18] Fixed the AGENTS.md refactor follow-ups: restored the maintainer scope, corrected the write-checkpoint pointer, fixed the loading sentence, updated the validator message, and added the quoted-label test; prepared the v6.6.3 release.
[2026-11-18] Released v6.6.3 and published its GitHub release: the refactor follow-ups are fixed, the quoted-label test is live, and the note uses the approved text.
[2026-11-18] Rewrote the common policy to the authoring prose shape: 90 multi-sentence rules split, 16 rationale bullets moved to the ADR, 6 banned words removed, 8 prose sections flattened; the shape fixture passes new and fails old with 132 findings; prepared the v6.6.4 release.
[2026-11-18] Released v6.6.4 and published its GitHub release: the common policy is rules-only, the rationale is in the ADR, and the shape guard is live.
[2026-11-19] Added the tool-selection ladder, made git-ignored protocol files readable, removed the old file-edit rules, and added the tool-selection fixture; prepared the v6.7.0 release.
[2026-11-19] Released v6.7.0 and published its GitHub release: the tool-selection ladder is live, the readable git-ignore rule is in place, and the 22nd test guards both.
[2026-11-19] Filed the config ticket for the configurable global directory, early settings load, and shell configuration; linked GitHub #9 and the bootstrap ticket; P2/XL, AI estimate.
[2026-11-19] Reviewed the idea-tracking options and chose the safe path: a discussed problem or solution becomes one next-steps line at the checkpoint; no mid-session next-steps writes.
[2026-11-19] Added the checkpoint discussed-idea rule and corrected the design-docs trigger scope; released v6.7.1.
[2026-11-19] Agreed the config design: `Default Shell` in the customization, `Default Shell Path` in the settings, the whole settings directory read early, the sync keeps Merge Policy, the bootstrap owned, the skills root separate.
[2026-11-19] Finished the configurable global user directory and default shell unit: the customization keys, the early whole-settings read, the shell path and name resolution, the validator and sync updates, the bootstrap, the quoted backup, the live docs, the ADR, and the strengthened test; review-30 APPROVED; suite 23/23, protocol 8/8, authoring, markdownlint, and shellcheck green.
[2026-11-19] Released v6.8.0 and published its GitHub release: the configurable global user directory, early whole-settings read, and default shell are live; GitHub #9 is closed as absorbed.
