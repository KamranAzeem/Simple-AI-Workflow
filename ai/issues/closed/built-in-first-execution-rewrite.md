Reported: 2026-11-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Improvement/Refactor
Severity: P1
Size: XL
Label:
URL:
Summary: Rewrite the execution rules so built-in tools lead and no procedure contradicts them

Description:

## Observed

During a full boot, the AI read six protocol files with `cat`, built the module index with `awk`, `sort`, `uniq`, and `cut`, compared headers with `sed` and `diff`, and produced a wall of ad hoc shell. The always-on rule says use a purpose-built tool first. The step text says otherwise. This is a design conflict, not a single lapse.

## Root causes

1. The boot is designed to reimplement a parser. `ai/procedures/load-context.md:37` requires an inline index "in the same line format as the developer `--index` oracle" and forbids running it. `design-docs/protocol-decisions.md:919` (INV-006) forbids a runtime script; `:892` calls one a deployment dependency; `:955` calls the oracle a dev-time test. A correct read-only oracle already exists at `support-files/validate-policy-authoring.sh:532-630`.
2. The boot is explicit about shell and silent about built-ins. `load-context.md` has eight shell mandates (lines 12, 37, 73, 74, 76, 81, 90, 93) and names no built-in tool. `AGENTS.md:79` names the built-in reader only for git-ignored paths. The reader works on those paths and on directories; verified this session.
3. No precedence rule covers procedure steps. `AGENTS.md:115` resolves policy triggers only. A step that says "use one command block" (`load-context.md:74`) beats the ladder in practice.
4. Enforcement is textual. `tests/test-tool-selection.sh:31-57` checks string presence. `tests/test-load-context-boot.sh:60-79` tests its own shell `discovery()` function; `:118` calls the oracle that the boot forbids. The global `kilo.jsonc:19-24` sets `bash: ask`, which gates but does not steer.
5. Docs and knowledge contradict the ladder. `docs/setup.md:14` teaches the `cat` command; `docs/codebase-examination-guide.md:60,88` names tools this harness lacks; `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md:49,89` narrows built-in-first to "content edits" and licenses shell for commands.

## Ladder defects

- `ai/policies/ai-policy-common.md:175` uses the undefined term "file operation", which covers reads.
- `:179` bans Python for file work but says nothing about shell doing the same.
- `:177` requires reporting every fallback, with no per-call hook.
- The knowledge file lists "pipelines" as a built-in limitation (`tool-selection-and-shell-resolution.md:39`), which licenses the awk pipelines.

## Python

- The unconditional rule is correct but does not cover the shell read path.
- The recorded violations were `python3` writes (`ai/daily-checkpoints/2026-11-03.md:73,129`).
- `kilo.jsonc` already sets `bash: ask`; `ai/state/next-steps.md:19` is stale as written.
- The draft in `ai/notes/notes.md:13-18` sets `"*": "allow"` and would weaken the current config. Do not apply it as written.
- `ai/notes/` is excluded from boot (`load-context.md:68`), so its AI instructions are never read by the protocol.

## Legitimate shell boundary

Built-in tools cannot produce byte sizes, line counts, modification times, git state, directory creation, or archives. The protocol should state this boundary once instead of rediscovering it in every step.

The target is zero OS commands for AI file work, not literal zero commands. Shell remains only for a named allowlist: launching the index helper, the git version check, directory creation, the metadata step, the global-store listing and search, and the reported git-ignore fallback. A literal zero would mean dropping the version check, the directory audit, the knowledge lookup, and the helper, which is a different scope.

## Required rewrite, not new rules

Sequenced units, each independently reviewable:

1. Precedence and ladder. Replace `AGENTS.md:115` with a general precedence rule: user instruction, then always-on rules, then procedures and policies; a lower level may narrow a higher one but never contradict it; an exception is named inline with its reason. Rewrite `ai-policy-common.md:170-180` so "file operation" excludes reads, the read ban is explicit, one shell call does one job, and the fallback report is per call.
2. Index helper. Amend INV-006. Add `support-files/index-protocol.sh`. It resolves the global policies recursively including `compliance/`, the global procedures, and the project policies only when that path differs, dedupes, and prints the runtime index. Run it with a POSIX shell when one is available: bash or zsh on Linux and macOS, Git Bash on Windows. When no POSIX shell is available or the helper fails, the AI builds the same small index with the built-in reader, search, and glob, reports `[FALLBACK]` with the reason, and continues. The boot never stops for a missing shell. There is no PowerShell helper. Delete the inline-build sentence at `load-context.md:37`. No new TIER key: the path is `(Global AI Workflow Directory)/support-files/`, resolved by `AGENTS.md:29` and `ai-policy-meta.md:19`.
3. Runtime index contract. The helper and the AI fallback emit the same fields in the same order, so the contract has two consumers and one spec. Limit the runtime contract to what both can produce identically: type, scope, name, source, mode, triggers, headings, effective, conflict, and dispatch errors. Keep the full authoring shape check as a dev-time validator, never a boot dependency. Record the contract in the plan and the ADR, and keep it small enough that the fallback can follow it by reading module headers with built-in tools.
4. Boot discovery and loading. Use the built-in reader and glob for listings and every whole-file read; reserve shell for the version check, directory creation, the metadata step, and the global-store listing and search. Name each boundary.
5. Docs and knowledge. Delete the `cat` wedge, correct the tool names, and fix the false "content edits versus commands" statement. Add the one-line scope note for `Default Shell`: it names the interpreter for commands, not a preference for file operations.
6. Windows and verification. There is no PowerShell helper and no Git Bash requirement. Git Bash is optional; when it exists the `.sh` runs, otherwise the fallback runs. The fallback is OS-agnostic because it uses only built-in tools, so it can be verified on Linux by masking the helper. No GitHub CI and no Windows VM are required. The `.sh` is verified on this Linux host against the golden fixtures.
7. Tests and config. Replace text-presence assertions with: no shell-read mandate in the touched steps, one helper invocation, the golden fixtures, and a transcript check for zero shell reads. Add the masked-helper run to the release evidence. Keep `bash: ask`; fix or drop the notes draft.

The runtime contract and golden-fixture parity in units 3, 6, and 7 are superseded by the round 11 scope cut below: the helper wraps the existing `--index`; the fallback is best-effort.

## Acceptance criteria

- A full boot transcript contains no `cat`, `sed`, `awk`, `sort`, `uniq`, `comm`, or `find` outside the named commands: the git check, directory creation, the helper launch, the metadata step, the global-store listing and search, and the reported git-ignore fallback.
- The touched steps name the built-in reader, search, glob, and edit capabilities; no step instructs an OS file command or Python.
- The helper uses the read-only `--index` output; the fallback is best-effort and reports its source; the dev `--index` output is unchanged and pinned by its existing tests.
- The `.sh` helper matches the dev `--index` output plus the `effective` and `conflict` fields on Linux; the fallback, with the helper masked, produces a usable best-effort index in a recorded run. No CI or Windows VM is required.
- The ADR records the INV-006 amendment; the ADR's pwsh 7+ rule is amended for the boot and still applies to a shell command when one runs.
- A masked-helper run produces a usable best-effort index; the proof marks the index source as `helper` or `fallback` with the reason, and the boot continues.
- The ladder keeps nine bullets; `AGENTS.md` stays within 160 lines and 24,900 bytes; every replaced rule is removed or merged.
- A rule inventory exists with one disposition per execution rule: keep, rewrite, delete, or merge.
- Validators, suite, markdownlint, and shellcheck are green; peer review is `APPROVED`.
- The permission stays `bash: ask`; no `"*": "allow"`.
- The release note explains the change in the user's voice.

## Method

- Inventory every normative statement about tool choice, boot reads, and the index, with its owner and a disposition.
- Assign one owner per concern; every other file references it.
- Rewrite one vertical slice at a time: failing check, rewrite, green, peer review, release.
- Rewrite an unclear rule to actor, action, object, condition, default, and exception. Name the capability, not a harness-specific tool name. Move rationale to the ADR.
- Remove duplicated mandates from procedures; procedures state outcomes, not mechanisms.
- Measure success by the boot transcript and the net rule count, not by the presence of new sentences.
- Keep the scope bounded to the execution surface: `AGENTS.md`, the common policy, `load-context.md`, two docs, one knowledge file, two tests, and the config. Do not rewrite the other 23 policies.
- Treat editorial tightening of a touched policy or section as in scope; tightening adds no rule.

## Decisions

- Severity P1 and Size XL accepted.
- One read-only helper is accepted, and INV-006 is amended for it.
- The helper lives in `support-files/`, not in `ai/procedures/` or `ai/skills/`.
- There is no PowerShell helper. Git Bash is optional; without a POSIX shell, the AI fallback runs. No CI and no Windows VM.
- A missing shell or a helper failure triggers the built-in AI fallback; the boot continues, the proof marks the source, and no work is refused.
- The runtime contract stays small, with two consumers: the `.sh` helper and the AI fallback.
- The fallback is OS-agnostic and is verified by masking the helper on Linux.
- This is a behavior change, not a breaking change. The release class follows the project convention.
- Editorial tightening of a touched policy or section is approved; it adds no rule.
- The `Default Shell` key stays; one scope line is added where it is defined, in the customization guide and the load step. It is a clarification, not a rule.
- After round 11, the runtime v1 contract, the `--runtime`/`--emitter` flags, and byte-level parity are dropped; the helper wraps the existing `--index`, and the fallback is best-effort.

## Still open

- None. The plan is APPROVED by review round 13 (review-49). Implementation awaits the user's request.

## Evidence

- Read in full: `AGENTS.md` (135 lines), `load-context.md` (109), `ai-policy-common.md` (691), `ai-policy-meta.md` (208), `ai-policy-knowledge.md` (168), `ai-policy-issue-management.md` (119), `ai-policy-codebase-examination.md` (89), both validators (438 and 742 lines), the tool-selection and boot tests (64 and 131 lines), `run-all.sh` (39), `docs/setup.md` (14), `docs/codebase-examination-guide.md` (119), `docs/protocol-validation-system.md` (66), the v6.7.0 announcement (37), the tool-selection knowledge file (114), `ai/notes/notes.md` (19), the global `kilo.jsonc` (33), and the full ADR (1,176 lines).
- The 22 domain policies and the common and meta policies were searched, not read in full; their tool references are listed above.
- No files were changed during the examination.

---
2026-11-19
Filed from the codebase examination requested after the boot review. No plan yet; the ticket stays in `open/` until a plan is requested.

---
2026-11-19
Recorded decisions from the review: severity P1, size XL, one read-only helper, helper under `support-files/` with `.sh` and `.ps1`, Windows pwsh 7+ only, behavior change not breaking, and editorial tightening allowed. The helper implements the index in its own runtime. A missing runtime or a helper failure does not stop the boot: the AI builds the same small index with built-in tools, reports `[FALLBACK]`, and continues. The contract stays small because it has three consumers, the two helpers and the AI fallback. The ADR's "never Windows PowerShell 5.x" line stands and needs no amendment; only INV-006 changes.

---
2026-11-19
Accepted the three recommendations: keep the `Default Shell` key, add one scope line where it is defined, and fix the root causes in the plan. The scope line is a clarification, not a rule.

---
2026-11-19
Supersedes the PowerShell-helper decision. There is no `.ps1`; the `.sh` helper plus the AI fallback is the whole runtime path. On Windows, Git Bash is optional; without a POSIX shell the fallback runs. The fallback is OS-agnostic, so it is verified by masking the helper on Linux. No GitHub CI and no Windows VM.

---
2026-11-19
Plan: `ai/plans/built-in-first-execution-rewrite.md` (Evidence, HLD, LLD with acceptance criteria, ADRs, test plan, close sequence). Awaiting peer review.

---
2026-11-19
Peer review round 1: `2026-11-19_02-56_review-37.md`, CHANGES REQUESTED. The 15 Major and 11 Minor findings are fixed in the plan; round 2 is pending.

---
2026-11-19
Peer review rounds 2, 3, and 4: `2026-11-19_03-06_review-38.md`, `2026-11-19_03-15_review-39.md`, and `2026-11-19_03-24_review-40.md`, all CHANGES REQUESTED. The findings are fixed in the plan; round 5 is pending.

---
2026-11-19
Peer review rounds 5 through 10: `2026-11-19_03-34_review-41.md` through `2026-11-19_04-14_review-46.md`, all CHANGES REQUESTED. The findings are fixed in the plan.

---
2026-11-19
Peer review round 11: `2026-11-19_08-26_review-47.md`, CHANGES REQUESTED. The review loop stopped at the user's direction. Scope cut: the ladder and precedence rewrite, the built-in boot reads, and the thin helper remain; the runtime v1 contract, the `--runtime`/`--emitter` flags, and byte-level parity are dropped; the fallback is a documented best-effort path. The plan is revised and not yet approved.

---
2026-11-19
Peer review round 12: `2026-11-19_08-37_review-48.md`, CHANGES REQUESTED. Fixed the one Major (the helper sets `effective` and `conflict` on the dev index output; the fallback computes the same) and the six Minors.

---
2026-11-19
Peer review round 13: `2026-11-19_08-44_review-49.md`, APPROVED. The plan is ready for implementation; no branch or commit yet.

---
2026-11-19
Implementation review: `2026-11-19_09-07_review-50.md`, APPROVED. The suite (25 scripts), both validators, markdownlint over 108 files, and shellcheck are green. The plan is attached below; the ticket closes with v6.10.0.

## Implementation Plan

# Plan: Built-In First Execution Rewrite

Ticket: `ai/issues/closed/built-in-first-execution-rewrite.md`
Status: APPROVED by review round 13 (review-49)
Size: XL
Release: minor, proposed v6.10.0

## Evidence

- The ticket records the examination findings, the root causes, and the decisions taken with the user.
- Read in full for this plan: `AGENTS.md` (135 lines), `ai/procedures/load-context.md` (109), `ai/policies/ai-policy-common.md` (691), `ai/policies/ai-policy-meta.md` (208), `ai/policies/ai-policy-knowledge.md` (168), `ai/policies/ai-policy-issue-management.md` (119), `ai/policies/ai-policy-design-docs.md` (171), `ai/policies/ai-policy-code-review.md` (131), `ai/procedures/manage-issues.md` (17), `ai/procedures/run-peer-review.md` (14), `ai/procedures/implement-plan.md` (13), both validators (438 and 742 lines), the tool-selection and boot tests (64 and 131 lines), `tests/run-all.sh` (39), `docs/setup.md` (14), `docs/codebase-examination-guide.md` (119), `docs/protocol-validation-system.md` (66), the v6.7.0 announcement (37), `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md` (114), `ai/notes/notes.md` (19 reader lines), the global `kilo.jsonc` (33), `docs/workflow-guide.md`, `README.md`, `docs/ai-customization-guide.md`, `tests/test-trigger-rules.sh`, `tests/test-policy-load-paths.sh`, and the full ADR (1,176 lines).
- Commands and results:
  - `grep -n` over `ai/procedures/load-context.md` found eight shell-directed instructions: lines 12, 37, 73, 74, 76, 81, 90, 93.
  - `grep -n` found no built-in tool name in `ai/procedures/load-context.md`.
  - `command -v pwsh` and `command -v powershell` returned nothing on this host; the host is Linux.
  - A `.github` glob returned no files; there is no CI workflow.
  - `markdownlint-cli2` on the previous plan reported 0 issues.
  - `wc -l ai/notes/notes.md` reports 18 because the last line has no newline; the reader reports 19 lines.
  - The current `--index` on `ai-policy-common.md` emits the raw source, raw headings, `mode=legacy`, `effective=yes`, `conflict=none`, and `error_classes=none`; on `load-context.md` it emits the H1 procedure name `LOAD-CONTEXT` and `mode=legacy`. The dev output is pinned by `tests/test-trigger-rules.sh:255-257`, `tests/test-policy-load-paths.sh:179-203`, and the five policy fixtures, so this plan leaves it unchanged.
- Confirmed facts:
  - The dev `--index` format stays and is the boot index; the helper calls it directly. The fallback is best-effort.
  - The runtime host is Linux without `pwsh`; `pwsh` is not required by this design.
  - The ticket has no branch and no commit; planning is branch-free and implementation uses the branch named below.
- Open questions: none.

## Context

The boot procedure tells the AI to build the module index with shell tools, and the always-on ladder tells it to use built-in tools first. No rule resolves the conflict. The index oracle that already exists cannot be used at boot by rule, so each session reimplements it in ad hoc shell. Documentation and project knowledge repeat the shell-first reading, and the tests only check that the rule sentences exist.

The result is a boot that reads files with `cat`, parses with `awk`, sorts with `sort`, and reports a summary the user cannot audit. The fix is a rewrite of the execution surface, not another rule.

## Goals

- Every file read, search, listing, and edit by the AI uses a built-in capability. The exceptions are the named commands below, each with its authorizing rule and its reason.
- The index is produced by one read-only helper when `bash` exists, and by the AI with built-in tools when it does not. The boot never stops for a missing shell, a missing `bash`, or a missing project `ai/` directory.
- One thin helper around the existing read-only `--index`; the fallback is a documented best-effort path that reports its source and its limits.
- One precedence rule that resolves procedure-versus-rule conflicts.
- The ladder keeps nine bullets; `AGENTS.md` stays within 160 lines, 24,900 bytes, and 2,400 words; every replaced rule is removed or merged.
- Documentation, tests, and the ADR describe the new behavior.

## Named Commands

These are the only commands the AI may run at boot. Each names its authorizing ladder bullet and its reason.

- `git`: the version check and the tracked-file age source. Ladder bullet 3. Reason: built-ins cannot inspect the remote or the commit date. Ages use `git log -1 --format=%ct -- <path>`, added to the git allowlist at `load-context.md:24`. Keep the nine reason strings in `load-context.md:34-35` verbatim; a missing command runner uses the existing `version check skipped: git unavailable` string.
- Directory creation: structural audit. Ladder bullet 3. Reason: built-ins cannot create a directory. Form: `mkdir -p` on POSIX, `New-Item -ItemType Directory -Force` on `pwsh`; if the runner has no directory-creation form, report and skip.
- Helper launch: the index. Ladder bullet 3. Reason: a read-only helper. Form: `bash "<Global AI Workflow Directory>/support-files/index-protocol.sh"`. The helper requires bash; a host without bash uses the fallback.
- Metadata: byte sizes and ages. Ladder bullet 3, metadata reads. Reason: built-ins do not expose bytes or mtimes. Form: `wc -c` and `stat` or `find` on POSIX; skipped with a report on a non-POSIX runner.
- Global module and knowledge listing and search: the global index and lookup. Ladder bullets 3 and 9. Reason: the built-in glob and search may not reach the clone or the home directory. Form: `find` and `grep` on POSIX, `Get-ChildItem` and `Select-String` on `pwsh`; if the runner has no form, report and skip the global scope.
- Git-ignore fallback: `AGENTS.md:79`. Ladder bullet 4. Reason: the harness refuses a git-ignored path. Used only on that refusal and reported.

Line counts come from the reader's own output; no `wc -l` call is needed.

## Non-goals

- Rewriting the 22 domain policies. Only the execution surface is touched, plus editorial tightening of a touched section.
- Adding a PowerShell helper, GitHub CI, or a Windows VM.
- Changing the trigger namespace, the state-file model, or the issue model.
- Changing the dev `--index` output or the tests that pin it.
- Adding a runtime v1 contract, `--runtime` or `--emitter` flags, or byte-level parity between the helper and the fallback.
- Removing the git version check, the structural directory creation, the metadata step, or the backup archive command.

## Rule Inventory

Each execution rule gets one disposition. The inventory covers normative execution rules; the documentation updates are listed in LLD-002, LLD-007, and LLD-008.

- `AGENTS.md:77` OS-sensitive command state: rewrite. It applies to the named commands only; built-in steps state the capability. Keep the "report the command used and any deviation" clause.
- `AGENTS.md:89` Policy Loading Set: amend to name the project-policy boot exception; the no-scan rule is `AGENTS.md:89`.
- `AGENTS.md:78` no tool installation: amend to authorize the reported `[PENDING]` skip when a named tool is missing and the built-in path can continue; stop only when the task cannot proceed.
- `AGENTS.md:79` built-in first for git-ignored paths: keep, including the reported shell fallback.
- `AGENTS.md:91` archive exclusion for shell listings: rewrite to name `find`, `ls`, and `Get-ChildItem`. It applies to the helper, the metadata step, the global listing and search, and the git-ignore fallback.
- `AGENTS.md:96` Boot Scan Exclusions: keep. The index exclusions are separate: hidden, `tmp`, archive, and escaping symlink.
- `AGENTS.md:115` policy-trigger precedence: replace the single line with the eight-line precedence section.
- `AGENTS.md:133` "including the bootstrap wedge": rewrite after the `cat` wedge is deleted.
- `ai-policy-common.md:170-180` tool ladder: rewrite, same bullet count.
- `ai-policy-common.md:175` undefined "file operation": delete the term; name the operations.
- `ai-policy-common.md:177` report every fallback: keep, tie it to the call.
- `ai-policy-common.md:179` Python file-operation ban: keep, name the operations, and add the shell read ban in its own bullet.
- `ai-policy-common.md:180` shell search exception: keep.
- `load-context.md:12` first shell command after settings: rewrite. A missing or invalid shell is reported and the boot continues with built-ins.
- `load-context.md:24` git allowed forms: add `git log -1 --format=%ct`.
- `load-context.md:34-35` git skip reasons: keep the nine strings verbatim.
- `load-context.md:37` inline index: delete. `load-context.md:38-49` inline fields, normalization, counts, and ten-class vocabulary: delete; the validator's `--index`, the helper post-process in HLD-003, and the supplementary recipe file own them.
- `load-context.md:55` project coordination file check: keep, unchanged.
- `load-context.md:59-60` issue template and `.gitignore` check: keep, unchanged.
- `load-context.md:73-76` Bash reference, one command block, no per-file subprocess, shell list of `ai/`: delete.
- `load-context.md:81` shell `find` or `ls -R` for knowledge: rewrite as built-in listings, with the global listing exception; preserve the issue, design-docs, and skills indexes, the 16 KB bound, `ITEM KNOWLEDGE-INDEX`, and `ITEM STALE-KNOWLEDGE`.
- `load-context.md:90` shell search for expertise policies: rewrite as built-in read and glob.
- `load-context.md:93` shell search for project policies: rewrite as glob and read.
- `load-context.md:77` author identity, design-docs migration, and trigger-only design rule: keep and preserve.
- `load-context.md:94` Protocol Developer Mode policy exception: keep and preserve.
- `load-context.md:97,109` counts-only proof rule and the two item definitions: amend to allow the index source, fallback reason, age source, and global skip on the expansion line.
- `ai-policy-knowledge.md:37` age source: rewrite the exact sentence to the commit date for tracked files when git is available, mtime otherwise, and record the source in the proof.
- `ai-policy-knowledge.md:103` shell `find` and `grep` for the global store: rewrite to the runner's listing and search forms with the skip and the archive exclusion, and name ladder bullet 9 as its authorizing level.
- `docs/setup.md:14` `cat` wedge: delete.
- `docs/ai-customization-guide.md:7,12-14` first-shell sentences and the stop: rewrite to report and continue, covering a missing `Default Shell Path` and a path mismatch.
- `docs/codebase-examination-guide.md:60,88` foreign tool names: rewrite as capability classes.
- `README.md:33` "the bootstrap wedge": rewrite.
- `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md` `### Tool ladder`, `## Verify`, `### Shell preference`: rewrite the whole sections to the new nine bullets, the new tests, and the report-and-continue behavior.
- `tests/test-tool-selection.sh` string-presence checks: rewrite and add absence checks.
- `tests/test-load-context-boot.sh` private `discovery()` and `skills_index()` shell helpers and old summary parser: rewrite to test the procedure contract and the dev index summary, and keep the canaries.
- `tests/test-config-resolution.sh:41,44,45` load-context shell strings: rewrite to the report-and-continue behavior.
- `tests/test-trigger-rules.sh`, `tests/test-policy-load-paths.sh`, and the five policy fixtures: keep; the dev `--index` output is unchanged.

## HLD

### HLD-001: Precedence model

Replace the single line at `AGENTS.md:115` with this section, placed after `## Protocol Dispatch` as a `## Precedence` section.

- Level 0: the always-on safety rules in `AGENTS.md` and the common policy. They bind every level, including the user instruction.
- Level 1: the user's explicit instruction.
- Level 2: the rest of `AGENTS.md` and the common policy.
- Level 3: the project customization.
- Level 4: domain policies.
- Level 5: procedure steps.
- A lower level may narrow a higher level; it never contradicts it.
- An exception is valid only when the level that owns the rule authorizes it; the step states the exception, its reason, and the authorizing level.
- A policy trigger never overrides the always-on rules, `AGENTS.md`, the customization file, or an explicit user instruction.

The old line's policy-trigger sentence is preserved in the last bullet. Consequences: a procedure step can no longer mandate shell for a file read. A step that needs a command names the command class, the reason, and the authorizing level. The file grows by about nine lines.

### HLD-002: Tool ladder

Rewrite `## Tool Selection` in place, with nine bullets and the same net count.

1. Use the tools the harness exposes, never a tool it does not list.
2. Use a purpose-built harness tool for one operation (read, search, glob, edit, diagnostics, tests, version control, web access, external integration) before any other rung.
3. Use the shell second only for a system operation on the host: git, a helper or validator, directory creation, archives, permissions, metadata reads, and a global listing or search the built-in tools cannot reach.
4. Never use the shell to read, search, list, or edit a file a built-in tool can reach, except the helper launch, the global listing and search, the backup archive, the reported Git-Ignored Protocol Files Are Readable fallback, and the metadata step's byte and age reads.
5. Never use Python or another runtime to read, search, create, append to, or edit a file; use the built-in tool.
6. Use a runtime for computation only when neither a built-in tool nor the shell performs it.
7. Run one job per shell call and report each fallback at that call, naming the tool and the reason.
8. Never use a lower rung to bypass an approval, a rule, or a safety check.
9. Use shell search only when the built-in search cannot reach the path.

The count stays at nine. Bullet 2 absorbs the purpose-built definition, bullet 3 absorbs the system-operation definition, and the no-bypass and shell-search rules keep their own bullets. Bullet 4 carries one exception list: the helper, the global listing and search, the backup archive, the git-ignore fallback, and the metadata reads. The ladder does not name a harness-specific tool and does not use the term "file operation."

### HLD-003: The helper reuses the existing index; the fallback is best-effort

- The helper calls `bash "$SCRIPT_DIR/validate-policy-authoring.sh" --index <files>`, then sets `effective` and `conflict` on the module lines from the same-name and trigger rules. The dev `--index` output itself stays unchanged; no new flags are added.
- The post-process marks a global policy `effective=shadowed:<project-name>` when a project policy has the same name, and sets `conflict=duplicate:<name>` or `conflict=overlap:<name>` for trigger pairs. The fallback computes the same fields with built-ins.
- The trigger rule uses the dev validator's normalization: lowercase, replace every character outside `[a-z0-9]` with a space, collapse spaces, and trim; a trailing `#N` is dropped. A duplicate is the same normalized phrase; an overlap is a whole-word containment that is not identical.
- The helper applies the HLD-004 file list and exclusions, dedupes by canonical path, and writes no file.
- The fallback emits a best-effort index in the same line format, with the fields it can read with built-ins. Its module lines and counts may differ from the helper's; it reports `index-source=fallback` and the reason, and the boot continues.
- The dev `--index` output stays unchanged and remains pinned by the existing tests.
- No v1 grammar, no `--runtime`, no `--emitter`, and no byte-level parity.

### HLD-004: One thin helper and a best-effort fallback

- `support-files/index-protocol.sh` is the only helper. It is read-only and resolves its own directory and the project root.
- The procedure launches it by its resolved workflow path, `bash "<Global AI Workflow Directory>/support-files/index-protocol.sh"`, from the project root.
- A missing project `ai/` is an empty project scope, not an error.
- It resolves the global policies recursively, the global procedures, and the project policies recursively including `compliance/` when present. It applies the index exclusions: hidden entries, `tmp`, archives, and escaping symlinks.
- It dedupes by canonical path, calls `bash "$SCRIPT_DIR/validate-policy-authoring.sh" --index` with the resolved file list, and sets `effective` and `conflict` on the result.
- The fallback runs when `bash` is missing, the helper is missing, stdout is empty, the output has no `summary|` line, or the helper exits 2. It uses the built-in reader, search, and glob with the same scope resolution, dedupe, and project-root handling, and emits a best-effort index in the dev `--index` line format. It reports `index-source=fallback` and the reason in the proof.
- When the built-in glob cannot reach the workflow clone, the fallback uses the runner's listing form for the global modules. If no runner form exists, it indexes the project modules and reports the global scope as `[PENDING]` in `ITEM PROTOCOL-INDEX`.
- The fallback applies the hidden, `tmp`, and archive exclusions but cannot detect an escaping symlink with built-ins. The helper enforces the exclusion; the masked run records the divergence.
- The proof reports `index-source=helper` or `index-source=fallback` with the reason. A helper that exits 1 with output does not trigger the fallback; its errors are reported and the boot continues.
- The fallback recipe is a short inline paragraph in `load-context.md` Step 2; `(Global AI Workflow Directory)/support-files/index-protocol-contract.md` is supplementary, and its absence is not fatal.
- No PowerShell helper, no GitHub CI, no Windows VM. The fallback is verified by masking the helper on Linux. The procedure and helper ship together in the clone; the recipe file is supplementary. An old clone uses its old boot and is out of scope.

### HLD-005: Built-in-first boot

- Step 0 reads the customization and the whole settings directory with the built-in reader. An absent `Default Shell` key keeps the current or default shell and does not suppress the helper; a named shell that is not found, or a configured `Default Shell Path` that does not exist, is reported, and the boot continues with built-ins. An absent path resolves the named shell from `PATH`. The helper uses its bash shebang regardless of `Default Shell`. The step states that the key names the interpreter.
- Step 1 keeps the git version check as a named command with the nine reason strings; if the command runner is missing, report and skip.
- Step 2 launches the helper by its resolved workflow path when `bash` exists and uses its index output. On an HLD-004 fallback trigger, it uses the inline recipe and, when present, the supplementary contract file.
- Step 3 reads the common policy with the built-in reader.
- Step 4 checks directories with glob and read, preserves the issue-template, `.gitignore`, and project coordination file checks, and uses one directory-creation command for missing paths.
- Step 5 uses glob and read for the boot roots, and the Boot Scan Exclusions at `load-context.md:63-72` survive in the built-in listings and the metadata step. Step 5 owns the state-file byte sizes; Step 7 owns the knowledge ages. Sizes and ages use the POSIX metadata commands when the runner is POSIX; ages use the commit date for tracked files when git is available and mtime otherwise, and `ITEM STALE-KNOWLEDGE` reports `age-source`. When the sizes or ages are unavailable, `ITEM STATE-FILE-HEALTH` and `ITEM STALE-KNOWLEDGE` report `[PENDING]` with the reason.
- Step 6 reads state files, checkpoint, and coordination with the built-in reader; the header blocks are compared after normalizing a BOM, CRLF, and trailing whitespace.
- Step 7 indexes knowledge with glob and read, and preserves `ITEM KNOWLEDGE-INDEX` and `ITEM STALE-KNOWLEDGE`, the issue, design-docs, and skills indexes, and the 16 KB bound. The Global Knowledge file list and the global-store search use the runner's forms when the built-in glob and search cannot reach the home directory; the archive exclusion applies. If the runner has no form, `ITEM KNOWLEDGE-INDEX` reports the global store as `[PENDING]` with the reason.
- Step 8 reuses the Step 3 common-policy read, then reads the Active Expertise policies and every project policy in the Project AI Policies Directory with the built-in reader, as today; it does not load every global policy. In Protocol Developer Mode it loads only the common policy and the Active Expertise policies and skips the project-policy scan. `AGENTS.md:89` is amended to name the project-policy boot exception.
- Step 9 reports the proof. The item lines stay counts-only; `index-source=helper` or `index-source=fallback`, the fallback reason, the age source, and the global `[PENDING]` are printed on the item's expansion line. The expansion line prints for a `[PASSED]` item when these fields are present.

## LLD with Acceptance Criteria

### LLD-001: Precedence rule

- Replace the single line at `AGENTS.md:115` with the HLD-001 section.
- Acceptance: the validator anchors `Level 0` through `Level 5`, the exception sentence, and the policy-trigger sentence; `AGENTS.md` stays within 160 lines, 24,900 bytes, and 2,400 words; the old one-line disposition is not duplicated.

### LLD-002: Tool ladder

- Replace `ai-policy-common.md:170-180` with the nine bullets.
- Add the `Default Shell` scope sentence to `docs/ai-customization-guide.md`; Step 0 states that the key names the interpreter.
- Acceptance: `tests/test-tool-selection.sh` asserts the nine bullet anchors, asserts exactly nine bullets in the section, asserts the absence of the term "file operation," and asserts the read ban. The transcript check is the accepted manual gate for behavior.

### LLD-003: Helper output and fallback best-effort

- The helper calls the existing `validate-policy-authoring.sh --index`; no new flags.
- The dev output stays unchanged; the helper sets `effective` and `conflict` on its own output.
- The fallback emits a best-effort index in the same line format, computes the same fields when it can, and reports `index-source=fallback`.
- Acceptance: `tests/test-protocol-index.sh` covers the helper output on a normal set, a same-name shadowing pair, a trigger conflict, a first-boot set with no `ai/`, a fallback smoke test with the helper masked, the existing dev `--index` regression, a `summary|` line, the module count for the fixture, `index-source`, LF, and no BOM. It does not assert byte-level parity.

### LLD-004: Helper

- Add `support-files/index-protocol.sh` with a `#!/usr/bin/env bash` shebang.
- Resolve `SCRIPT_DIR` from `$0`; `WORKFLOW_DIR` is its parent; `PROJECT_ROOT` is `pwd`.
- Treat a missing project `ai/` as an empty project scope.
- Build the file list with the HLD-004 exclusions, dedupe by canonical path, call `bash "$SCRIPT_DIR/validate-policy-authoring.sh" --index <files>`, set `effective` and `conflict` on the result with the dev validator's normalization and whole-word containment rules, and pass the result and exit code.
- Do not parse the customization file.
- Acceptance: `shellcheck` is clean; the helper runs on this Linux host; the output equals the existing `--index` output for the fixture plus the two computed fields; a same-name project policy shadows the global in the helper output; the helper writes no repository file; a first-boot fixture with no `ai/` indexes the global modules; a host without `bash` falls back; the procedure's launch path is the resolved workflow path.

### LLD-005: Fallback recipe

- Trigger: the HLD-004 fallback list.
- Use the inline recipe in Step 2; read the supplementary contract file when present.
- Use `glob` for the project module files and the runner's listing for the global modules when the built-in glob cannot reach them; apply the same exclusions, scope resolution, dedupe, and project-root handling as the helper; `read` each module in full.
- Extract the dev `--index` fields the built-ins can read, compute best-effort conflicts and shadowing, and emit the same line format with `index-source=fallback`, sorted.
- Report `index-source=fallback` with the reason in the proof. A missing project `ai/` is an empty project scope; a missing global access reports the global scope as skipped.
- Use no shell for file content, no Python, and no temp file.
- The symlink exclusion is helper-only; the fallback records the divergence. The masked run includes a symlink canary.
- Acceptance: a masked-helper run on this Linux host produces a usable index and reports `index-source=fallback`; a no-`ai/` first-boot run produces the global index; the transcript contains no OS file command outside the named commands. It does not claim byte-level parity.

### LLD-006: Boot procedure rewrite

- Rewrite the eight shell-directed steps per HLD-005.
- Delete the `cat`/`find`/`awk` instructions and the "one command block" requirement.
- Name the resolved workflow helper path and the inline fallback recipe in Step 2; name the contract file as supplementary.
- Keep the named commands with their bullet, reason, and authorizing level: git, directory creation, the helper launch, the POSIX metadata step, the global listing and search, and the reported git-ignore fallback.
- Preserve the issue-template and `.gitignore` checks, `ITEM KNOWLEDGE-INDEX`, `ITEM STALE-KNOWLEDGE`, the issue, design-docs, and skills indexes, the 16 KB bound, and the Protocol Developer Mode policy exception.
- Preserved behavior checklist: the customization section and old `ai/ai-customization.md` stops (`load-context.md:11,13-14`); the full state-file proof rules (`:79`: chronological order with no duplicates, at most three short bullets, the daily-checkpoint H1 date, the newest progress and checkpoint date match, the per-file byte size and total, missing state file `[FAILED]` and stop, missing checkpoint `[PENDING]`, header or title mismatch `[FAILED]` with the repair instruction, no filesystem metadata, one START/END, line 1, and one blank line); the latest checkpoint is read once and the proof reuses that read (`:77`); the author identity resolution and git config offer, the design-docs migration offer, the design-documents-only-through-the-trigger rule, and the "Global Knowledge is not loaded here" statement (`:77`); the expertise `ai-policy-<name>.md` then `<name>.md` fallback (`:89`); the coordination, issue-template, and `.gitignore` checks (`:55,59-60`); the issue, design-docs, and skills indexes and the 16 KB bound (`:81-87`); the Boot Scan Exclusions (`:63-72`); and the developer-mode exception (`:94`).
- Add `index-source=helper` or `index-source=fallback` and the fallback reason to `ITEM PROTOCOL-INDEX`, and the global scope `[PENDING]` when the global listing is unavailable; add `age-source` to `ITEM STALE-KNOWLEDGE`. Amend the Step 9 rule and the two item definitions to allow these fields on the expansion line, including a `[PASSED]` item.
- Acceptance: the text guard matches commands, not prose verbs, so `find the named shell` does not trip it; it allows `git cat-file`, `git ls-remote`, and the named commands, and finds no other `cat`, `sed`, `awk`, `sort`, `uniq`, `comm`, `find`, `python`, or `python3` instruction. The helper source is exempt. The proof items include the index source, the reason, and the age source; the phase stays within 16 KB.

### LLD-007: Documentation and knowledge

- Delete the `cat` wedge in `docs/setup.md` and the "including the bootstrap wedge" clause in `AGENTS.md:133`.
- Replace the foreign tool names in `docs/codebase-examination-guide.md` with capability classes: the read tool, the search tool, the glob tool.
- Add the `Default Shell` scope line to `docs/ai-customization-guide.md`, rewrite `:7` and `:12-14` to report and continue on a missing shell, a missing path, or a mismatch, and remove the first-shell sentences.
- Rewrite `ai-policy-knowledge.md:37` and `:103` to the HLD-005 wording.
- Rewrite `ai/shared/project-knowledge/tool-selection-and-shell-resolution.md` in full to the new nine bullets, the new tests, and the report-and-continue behavior, including the `:39` pipelines, `:49` not-a-conflict, `:82` first-command, `:88-92` file-edit, and `:83` stops-and-reports sentences.
- Rewrite `README.md:33,398`, `docs/workflow-guide.md:108,447`, and `docs/custom-policy-howto.md:66` after the wedge is deleted.
- Do not apply the `"*": "allow"` draft in `ai/notes/notes.md`; the user config keeps `bash: ask`, and the notes draft is corrected to keep it.
- Acceptance: markdownlint is clean; the knowledge file passes the knowledge header check; no touched doc tells the AI to use an OS file command outside the named commands.

### LLD-008: Tests, validator, and proof docs

- Rewrite `tests/test-tool-selection.sh` with the nine bullet anchors, the bullet count, the read ban, the absence checks, the precedence anchor, and the named-command allowlist.
- Add `tests/test-protocol-index.sh` for the helper output, the first-boot case, the fallback smoke test, and the canaries. Do not add the v1 parity fixtures.
- Update the exact-string anchors at `validate-protocol.sh:78` and `:80` to the new ladder sentences, and add anchors for the precedence rule, the helper path, the fallback marker, the proof index source, and the age source. Preserve the exact anchors at `validate-protocol.sh:48-56,66`: the `Index open/ and in-progress/` phrase, `ITEM PROTOCOL-INDEX`, `Boot Scan Exclusions`, `Token Rationing`, `STEP-KNOWLEDGE-INDEXING`, `STEP-POLICY-LOADING`, `STEP-WORKFLOW-VERSION-CHECK`, `Global AI Knowledge Directory`, `STEP-STATE-FILE-PROOF-OF-READ`, and `ITEM SKILLS-INDEX`.
- Rewrite `tests/test-load-context-boot.sh` to test the procedure contract and the dev index summary instead of its own `discovery()` and `skills_index()` helpers, and keep the canary cases.
- Update `docs/protocol-validation-system.md:36` to the helper index and the fatal classes (`invalid trigger block`, `invalid loading block`, `empty trigger block`, `missing triggers`, `name mismatch`, `unreadable module`); update `docs/workflow-guide.md:256,264,266` to the helper and the built-in and runner forms.
- Keep `bash: ask`; the repo does not test the user config.
- Acceptance: the suite, both validators, markdownlint, and shellcheck are green, including the unchanged dev `--index` consumers.

### LLD-009: ADR and release

- Amend INV-006 to: "The index is ephemeral; one read-only helper may produce it; the helper is not a cache or a state file; the full authoring validator remains dev-time."
- Amend INV-009 to add the index source and the summary.
- Supersede the error-count wording at `design-docs/protocol-decisions.md:888-890` with the single summary count.
- Supersede the default-shell decision at `:1160`: a missing shell reports and continues, and the boot has no first-shell requirement.
- Supersede `:882`, the index-is-inline statement at `:955`, and the parity clause at `:894`.
- Record the precedence rule and the ladder rewrite in the dated entry.
- Amend the `pwsh` 7+ statement (`:957`): Windows uses pwsh 7+ when a shell command runs; the boot does not require pwsh because the built-in path and the fallback cover it. No 5.x fallback.
- Add the dated, self-contained entry below to `design-docs/protocol-decisions.md`.
- The fallback recipe is also written to `support-files/index-protocol-contract.md` in the clone, so it survives the plan's deletion.
- Delivery ledger: the repo has no ledger. This change follows the existing convention and records the deferral; creating a ledger is out of scope.
- Add `docs/announcements/v6.10.0.md`, update the README banner, and write the release note in the user's voice. All of it is created in the branch before the merge.
- Acceptance: the ADR entry is present and self-contained; the supplementary fallback recipe is present; the release note is approved before publication.

### Dated ADR entry

```markdown
## 2026-11-19: One read-only index helper and a built-in-first boot

The runtime index is produced by `(Global AI Workflow Directory)/support-files/index-protocol.sh` when bash exists, and by the AI with built-in tools otherwise. The helper calls the existing read-only `validate-policy-authoring.sh --index`; the dev output is the index format. The fallback emits a best-effort index in the same line format, reports `index-source=fallback` and its limits, and the boot continues. There is no v1 contract, no `--runtime` flag, and no byte-level parity.

INV-006 becomes: the index is ephemeral; one read-only helper may produce it; the helper is not a cache or a state file; the full authoring validator remains dev-time. INV-009 gains the index source and the summary. The boot reads and listings use built-in tools; the only commands are the version check, directory creation, the helper launch, the metadata step, the global listing and search, the backup archive, and the reported git-ignore fallback. Precedence is the always-on safety rules, then the user instruction, then AGENTS.md and the common policy, then the customization, then domain policies, then procedure steps. The ladder keeps nine bullets, names the allowed shell reads, and names the operations Python may not perform. A missing shell, bash, project `ai/`, or fallback contract reports and continues. The knowledge age source is the commit date for tracked files when git is available, and mtime otherwise. This supersedes only the `:882` clause "never produced by a runtime script"; the replacement sentence is the INV-006 text above, and the ephemeral, rebuild, and no-cache sentences stand. It supersedes the index-is-inline statement at `:955`, the parity clause at `:894`, the error-count wording at `:888-890`, and the missing-shell stop at `:1160`; it amends `:957` so pwsh 7+ applies to a shell command when one runs, not to the boot. The delivery ledger is deferred because the repo has no ledger; this change follows the existing convention.
```

## ADRs

### ADR-001: Precedence lives in AGENTS.md

Decision: replace the single line at `AGENTS.md:115` with the Level 0 to Level 5 precedence section, the policy-trigger sentence, and the exception authorization.
Context: procedure steps contradict the always-on ladder, and only policy triggers had a precedence rule.
Consequences: a step cannot override a rule; a step that needs an exception names it, its reason, and the authorizing level; the file grows by about seven lines.

### ADR-002: The ladder defines its terms and keeps its size

Decision: rewrite the ladder with nine bullets, define a system operation, ban shell file reads, name the operations Python may not perform, and keep one job per shell call.
Context: "file operation" covered reads, and the Python ban did not cover shell.
Consequences: the shell is limited to commands; the net bullet count is unchanged.

### ADR-003: One thin helper, one best-effort fallback

Decision: the helper wraps the existing read-only `--index`; the fallback is a best-effort built-in implementation. No new oracle mode and no parity claim.
Context: the oracle already produces the index; the fallback cannot call it without bash.
Consequences: the dev output is the contract; the fallback may differ but reports its source and limits; the boot continues.

### ADR-004: One bash helper; the AI fallback covers Windows

Decision: one bash helper and the AI fallback; no `.ps1`, no CI, no VM.
Context: Windows without bash can still run the boot because the fallback uses built-ins; the command runner still provides git, directory creation, and the global listing and search.
Consequences: Windows without bash uses the best-effort built-in index every boot; the proof marks `index-source=fallback`; a `.ps1` can be added later. The `pwsh` 7+ rule applies to a shell command when one runs, not to the boot.

### ADR-005: Boot reads and listings use built-ins

Decision: remove the shell reads, listings, and index emulation from `load-context.md`; keep only the named commands.
Context: the procedure was the strongest cue for shell use, and the built-in reader works on git-ignored paths.
Consequences: the AI types no `cat`, `sed`, `awk`, `sort`, `uniq`, `comm`, or `find` at boot outside the named commands; each named command carries its bullet, reason, and authorizing level.

### ADR-006: The `Default Shell` key names an interpreter only

Decision: keep the key and add one scope line where it is defined, with a reference from Step 0.
Context: the key is read before the first command and can be read as a general tool preference.
Consequences: the key stays compatible; the scope line removes the ambiguity without a new rule; a missing or invalid shell is reported, not fatal.

### ADR-007: The durable record is a dated ADR entry and a knowledge file

Decision: the plan's ADRs are working notes; the durable record is one dated entry in `design-docs/protocol-decisions.md` and the fallback recipe in `support-files/index-protocol-contract.md`.
Context: the plan file is deleted after the plan is attached, and the fallback must be executable by a future booting AI.
Consequences: the recipe, the ladder, and every supersession survive the plan's deletion; the delivery-ledger deferral is recorded.

## Risks and Gaps

- RSK-001: The fallback is best-effort and may differ from the helper. Mitigation: the helper is the primary path; the fallback reports `index-source=fallback` and its limits; the masked run records a usable index; the boot continues.
- RSK-002: The boot depends on the validator script. Mitigation: the helper's `--index` mode is read-only, the helper is a thin wrapper, the clone is already a dependency, and the fallback covers a missing script.
- RSK-003: The model may still choose shell out of habit. Mitigation: the precedence rule, the text guard, the permission, and the transcript audit.
- RSK-004: The state-header comparison without a diff can miss an invisible difference. Mitigation: normalize a BOM, CRLF, and trailing whitespace, compare the exact canonical block and the file block line by line, and report the first difference.
- RSK-005: Windows without bash uses the fallback on every boot and skips the POSIX metadata; the global listing uses the runner's `Get-ChildItem` form when available. Mitigation: the proof records the index source and the skips; installing Git Bash is optional; a `.ps1` can be added later.
- RSK-006: The 16 KB proof bound could be exceeded by the new fields. Mitigation: the index lines are compact, the proof prints counts only, and the indexes stay in working context.
- RSK-007: The fallback cannot detect an escaping symlink. Mitigation: the module directories are assumed to contain no symlinks, the helper enforces the exclusion, and the masked run records a symlink canary. This is a residual divergence, not a project rule.

## Test Plan

- Unit and fixture:
  - `tests/test-protocol-index.sh`: the helper output on a normal set; a same-name shadowing pair; a trigger conflict; the existing dev `--index` regression; the first-boot case with no `ai/`; a fallback smoke test with the helper masked; the `summary|` line; `index-source`; LF and BOM; the hidden, `tmp`, archive, and symlink canaries. It does not assert byte-level parity.
  - `tests/test-tool-selection.sh`: nine bullets and the count, the read ban, absence checks, the precedence anchor, the named-command allowlist.
  - `tests/test-load-context-boot.sh`: the helper path, the bash attempt, the fallback markers, the built-in capability names, the preserved indexes and checks, the author identity and migration offers, the state-file proof clauses, the checkpoint read once, the boot-exclusion canaries, the developer-mode exception, and the canaries.
  - `tests/test-config-resolution.sh`: the rewritten report-and-continue load-context strings.
  - `tests/test-policy-shape.sh`: all touched modules keep their shape.
  - The unchanged dev `--index` consumers: `test-trigger-rules.sh`, `test-policy-load-paths.sh`, and the five fixtures `test-windows-policy.sh`, `test-academic-policy.sh`, `test-career-policy.sh`, `test-linux-policy.sh`, and `test-accounting-policy.sh`.
- Host checks:
  - `support-files/validate-protocol.sh` green, including the updated `:78` and `:80` anchors.
  - `tests/run-all.sh` green.
  - `markdownlint-cli2` green on the touched files.
  - `shellcheck` green on the helper.
- Manual gates:
  - Masked-helper run: the AI produces a usable best-effort index with built-ins, and the proof says `index-source=fallback`.
  - First-boot run: a project with no `ai/` indexes the global modules.
  - Missing-bash run: a stub runner without `bash` produces a usable best-effort index and reports `index-source=fallback`.
  - Empty, no-header, and exit-2 fallback: stub helpers.
  - Symlink canary: the helper excludes the link; the fallback records the divergence.
  - Full boot transcript: no `cat`, `sed`, `awk`, `sort`, `uniq`, `comm`, `find`, `python`, or `python3` outside the named commands.
  - Release-note approval.

## Migration and Compatibility

- No user configuration changes. `Default Shell` and `Default Shell Path` keep their names; a missing or invalid shell no longer stops the boot.
- The helper appears in the clone; the sync script does not copy it. Re-sync the workflow clone, not only `AGENTS.md`.
- The dev `--index` output is unchanged; the helper and the supplementary contract file are new.
- The knowledge age source changes to the commit date for tracked files when git is available and mtime otherwise; a fresh clone may flag conservatively, and the proof reports the source.
- A project policy with the same name still shadows a global one; the index shows it.
- A host without bash uses the fallback and skips the POSIX metadata and, when no runner form exists, the global listing; the proof records the source and the skips.

## Release

- Minor release, proposed v6.10.0, because the boot behavior changes and a helper is added.
- Announcement at `docs/announcements/v6.10.0.md`; README banner updated in the branch.
- Release note in the user's voice, draft-first for approval.
- GitHub Release after the tag; no repository edit after the merge.

## Close Sequence

- Repo: `/home/kamran/Projects/Personal/Simple-AI-Workflow`, remote `origin`.
- Base: `master`.
- Branch: `feature/built-in-first-execution`.
- Merge mode: direct, one squash commit with a conventional `feature(tooling):` subject; a rejected direct push falls back to `pr` and reports it.
- Implementation review: `APPROVED` before the commit.
- Ticket: `ai/issues/open/built-in-first-execution-rewrite.md`; move to `in-progress/` on implement; attach this plan under `## Implementation Plan`; move to `closed/` in the branch commit.
- Plan file: delete after the plan is attached.
- Checkpoint: write on the branch before the commit.
- Commit and push: commit on the branch, squash merge to `master`, push `master`, delete the branch.
- Release: tag `v6.10.0` after the merge; publish the GitHub Release. The announcement and README banner are already in the branch; no post-merge repository edit.
- Evidence: validator output, suite output, markdownlint, shellcheck, the helper run, the masked-helper fallback smoke run, the first-boot run, the symlink canary, the boot transcript, and the peer-review verdict.
- Terminal gate: the branch is at least one commit ahead and the tree is clean before the merge.

## Peer Review Log

- Round 1: `2026-11-19_02-56_review-37.md`, CHANGES REQUESTED. Fixed the 15 Major and 11 Minor findings.
- Round 2: `2026-11-19_03-06_review-38.md`, CHANGES REQUESTED. Fixed the 8 Major and 11 Minor findings.
- Round 3: `2026-11-19_03-15_review-39.md`, CHANGES REQUESTED. Fixed the 10 Major and 12 Minor findings.
- Round 4: `2026-11-19_03-24_review-40.md`, CHANGES REQUESTED. Fixed the 8 Major and 16 Minor findings.
- Round 5: `2026-11-19_03-34_review-41.md`, CHANGES REQUESTED. Fixed the 7 Major and 11 Minor findings by keeping the dev output unchanged, splitting the helper and fallback path, adding the contract file, and defining the parity as module lines and error classes.
- Round 6: `2026-11-19_03-43_review-42.md`, CHANGES REQUESTED. Fixed the 7 Major and 13 Minor findings: the error-line module name, the class predicates, the ladder fallback exception, the project-policy load, the workflow-guide lines, the removed out-of-reach phrase, the coordination check, and the minors.
- Round 7: `2026-11-19_03-50_review-43.md`, CHANGES REQUESTED. Fixed the 7 Major and 13 Minor findings: `[PENDING]`, the error cardinality and mode, the policy-name mismatch, the preserved-behavior checklist, the workflow-guide line, the retained project-policy load set with the `AGENTS.md:89` exception, the summary validation trigger, and the minors.
- Round 8: `2026-11-19_03-57_review-44.md`, CHANGES REQUESTED. Fixed the 6 Major and 11 Minor findings: the `:38-49` disposition, the canonical fallback list, the Boot Scan Exclusions, the optional `Default Shell`, the full state-file checklist, the error-case field values, and the minors.
- Round 9: `2026-11-19_04-04_review-45.md`, CHANGES REQUESTED. Fixed the 4 Major and 6 Minor findings: the fixture, the config-resolution test, the `AGENTS.md:78` skip authorization, the exact oracle flags, and the minors.
- Round 10: `2026-11-19_04-14_review-46.md`, CHANGES REQUESTED. Fixed the 5 Major and 14 Minor findings in the plan: the metadata exception, the Level 1 always-on exception, the proof expansion fields, the optional path distinction, the Step 6 preserved clauses, and the minors.
- Round 11: `2026-11-19_08-26_review-47.md`, CHANGES REQUESTED. Stopped the loop and cut the scope: the ladder and precedence rewrite, the built-in boot reads, and the thin helper remain; the runtime v1 contract, `--runtime`, `--emitter`, and byte-level parity are dropped; the fallback is best-effort. The four Majors are addressed by the ladder exception list, the Level 0 safety tier, and the inline fallback recipe.
- Round 12: `2026-11-19_08-37_review-48.md`, CHANGES REQUESTED. Fixed the one Major: the helper now sets `effective` and `conflict` on the dev index output, and the fallback computes the same fields. Fixed the six Minors: the Level 0 duplicate, the `:78`/`:77` citation, the fatal-class list, the validator wording, the absolute-path assertion, and the "emitter" wording.
- Round 13: `2026-11-19_08-44_review-49.md`, APPROVED. No new Critical, Major, or Minor. The optional suggestions are separate duplicate/overlap fixtures and a combined shadowing/conflict fixture.
- Implementation review: `2026-11-19_09-07_review-50.md`, APPROVED. The suite, both validators, markdownlint, and shellcheck are green.
