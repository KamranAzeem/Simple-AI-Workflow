Reported: 2026-11-03
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Add an ai/skills/ subsystem for drop-in agent skills, separate from policies

Description:

## Problem

The protocol has policies: broad guardrails and domain expertise that load at boot through Active Expertise or apply to a session. It has no concept of a skill: a small, task-specific instruction package that loads on demand, often with helper scripts. Other harnesses ship skills as `SKILL.md` packages, sometimes with a directory of helpers. Users want to bring those in, or write their own.

A blanket rename of policies to skills (`policies-to-skills-rename.md`) conflates two different things. Policies are broad and persistent. Skills are narrow and on demand. The protocol should support both rather than choose one.

## Shape options

1. **Flat native file**: `ai/skills/<name>.md`.
   - Simple, matches the protocol's plain-file style.
   - No place for helper scripts.
2. **Public package shape**: `ai/skills/<name>/SKILL.md` plus helpers.
   - Drop-in compatible with the skills published for other harnesses.
   - One directory per skill, which the user finds heavy for simple skills.
3. **Hybrid**: accept both.
   - A single `.md` is a native skill. A directory with `SKILL.md` is a package.
   - The index carries both, and the name comes from the frontmatter or the file stem.
   - Rejected for now by user preference.

User preference (2026-11-03): **package-only**, for standardization. Every skill is a directory `ai/skills/<name>/` with a `SKILL.md`, even when the body is one paragraph. The directory leaves room for helpers later without a shape change. The cost is one directory per trivial skill; that is accepted.

## Proposed behavior

- **Global AI Skills Directory**: `(Global AI Workflow Directory)/ai/skills/`.
- **Project AI Skills Directory**: `ai/skills/`.
- Every skill is a package: `ai/skills/<name>/SKILL.md`, optionally with helper files and scripts.
- At boot, index the package directory name, the frontmatter name and description, and the path only. Never read a skill body at boot.
- A project skill overrides a global skill with the same name, and the AI reports the override.
- Activation is explicit (`"use skill <name>"`) or by a match against the indexed description. The body loads for that task only, not for the session.
- A package may contain helper scripts. The AI never runs a skill script without explicit approval, and paths stay inside the skill directory.
- Skills are separate from policies and knowledge. Policies stay the always-on and domain layer. Active Expertise stays.
- The public frontmatter is authoritative for a skill (`name`, `description`). The policy authoring standard does not apply to skills.

## Security model

A skill is untrusted content. A malicious skill can try to override the protocol, exfiltrate data, or run code. The defense has to be layered, because the same AI that reads the skill is the one that can be fooled by it. The scan applies equally to skills we bundle, skills dropped in, and skills the user writes in `ai/skills/`.

### Threats

- Instruction override: text in `SKILL.md` tells the AI to ignore `AGENTS.md`, the user, or earlier instructions and treat the skill as authoritative.
- Tool poisoning: a skill description or body directs the AI to call a tool in a harmful way.
- Malicious helper scripts: install, network, file, or credential access.
- Path traversal and symlink escape.
- Hidden content: HTML comments, zero-width or bidirectional Unicode, base64 blobs, homoglyphs.
- Supply-chain update: a previously safe skill changes after the scan.

### Required controls

- Treat every skill as data, never as a protocol file. A skill cannot override `AGENTS.md`, a policy, the user, or the customization file. It adds task instructions inside that hierarchy only.
- Quarantine on ingest. A new, dropped-in, copied, or changed skill is untrusted until scanned.
- Scan before first use and on every change: the file tree, `SKILL.md`, every text file, and every script.
- Combine deterministic checks with an AI review. Deterministic checks catch known patterns; the AI review reads intent. The AI review alone is not sufficient, because a skill can target the reviewer.
- Scripts: static review, explicit approval before any run, path containment, no network by default, least privilege, and a recorded hash.
- Content hygiene: reject hidden Unicode, unexpected binaries, embedded credentials, and outbound network instructions unless the user explicitly accepts them.
- Record a trust decision with the skill hash. A hash change forces a re-scan.
- Store the scan report. A failed scan blocks activation and states why.

## Open questions

- Package-only is the user preference; confirm at planning and decide whether `SKILL.md` frontmatter is mandatory. A uniform index argues yes.
- How is the security scan implemented: a deterministic script in `support-files/`, an AI review procedure, or both? Who runs it, and where is the report stored?
- What does the deterministic scan cover: instruction-override phrases, hidden Unicode, network calls, shell execution, credential access, path traversal, binary blobs?
- How is the trust decision stored: a manifest with the skill hash, a report in `ai/artifacts/`, or both? What forces a re-scan?
- Does a failed scan always block activation, or can the user override with an explicit acceptance that is recorded?
- How are legitimate network or script needs declared and approved?
- Where does the boot index live: a new step, or folded into STEP-KNOWLEDGE-INDEXING?
- Precedence: project over global by name. What happens when a skill and a policy share a name?
- Nested discovery: one level under `ai/skills/`, or recursive? One level is simpler and index-friendly.
- Do skills join the checkpoint, knowledge repair, or markdown lint? Lint the `.md`; keep them out of knowledge repair.
- Distribution and update: pull the workflow clone for global skills. Does the sync script need a skill step, or is a future manifest enough?
- Security: per-skill script approval, path containment, secret scanning.
- Validation: a skill validator for frontmatter, name match, path shape, and no path escape.
- Relationship with `policies-to-skills-rename.md`: retire it, keep it, or fold its naming change into this? The recommendation is to pause the rename; policies and skills are distinct layers.
- Relationship with `policy-plugin-v0-trigger-dispatch.md` and `self-contained-policy-triggers-and-heading-jit-index.md`: can the skill index reuse the heading index? Sequence after the plugin v0, or independent?
- Scope: new subsystem, likely XL, with directories, boot index, activation, validation, docs, and tests.

## Draft acceptance criteria

- Both directories are documented as configuration anchors.
- Every skill is a package directory with `SKILL.md`; packages are discovered, indexed, and loadable.
- The boot index lists directory names, frontmatter names and descriptions, and paths only, and reads no body.
- A project skill overrides a global skill by name and the override is reported.
- Every new or changed skill is scanned before activation; a failed scan blocks activation.
- The scan covers `SKILL.md`, every text file, and every script; the trust decision records the skill hash.
- A skill cannot override `AGENTS.md`, a policy, the user, or the customization file.
- A skill script never runs without explicit approval, no network by default, and paths stay inside the package.
- Policies, Active Expertise, knowledge, and the existing validators keep working.
- The reference test and validator cover the new directories, the index, and the scan gate.
- Docs and slides explain skills, the two directories, the package shape, and the security model.

## Not in scope

- Implementation now.
- Moving existing policies into skills.
- Retiring `policies-to-skills-rename.md` before this issue is decided.
- A skill marketplace or installer.
- Bundling third-party skills in this repo.

## Notes

- Origin: user brainstorm on 2026-11-03.
- User preference: package-only. The security scan is mandatory for bundled, dropped-in, and user-authored skills.
- The core threat is instruction override, where a skill tries to become the authoritative protocol. The defense is a fixed instruction hierarchy plus a scan and a trust record, not AI trust.
- Related tickets: `policies-to-skills-rename.md`, `policy-plugin-v0-trigger-dispatch.md`, `self-contained-policy-triggers-and-heading-jit-index.md`.
- Runtime namespace (2026-11-08): a shipped repo validator cannot enforce trigger uniqueness for user-authored or third-party skills. The runtime index must detect collisions at ingest and activation, report the candidates, and dispatch nothing. Decide this when the ticket is planned.
- No plan yet.
