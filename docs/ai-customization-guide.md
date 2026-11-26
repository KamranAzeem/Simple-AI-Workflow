# AI Customization Guide

The `ai-customization.md` file is the **"Single Dial"** for tailoring your AI assistant to a specific project, directory, or group of projects. It uses a flexible "soft composition" model for project customization.

## Workflow configuration

The `## AI Workflow Configuration` section holds the paths and the shell. It is read before the first named command.

- **`Workflow AI Directory`**: your clone of Simple-AI-Workflow. This entry is mandatory.
- **`User AI Directory`**: where the user settings, knowledge, skills, and backups live. The default is `[HOME]/.ai/`. Use `[HOME]` on Linux and macOS, or `%USERPROFILE%` on Windows, and resolve it to an absolute path.
- **`Default Shell`**: optional. Use `bash`, `zsh`, `pwsh`, or `git-bash`. Leave it out to keep your current shell behavior. The key names the interpreter for named commands; the optional index helper runs with `bash` when a maintainer invokes it.
- **`Default Shell Path`**: set in the user settings file, not here. It is the native OS path to the named shell, for example `/bin/bash` or `C:\Program Files\Git\bin\bash.exe`. The path wins over the name; a mismatch or a missing shell is reported, and the boot continues with built-ins.
- **`Team AI Directory`**: optional. The local clone or mount of the shared team repository. The boot derives `knowledge/` and `skills/`, indexes them read-only, and an absent key behaves exactly as today.
- **`Team AI Knowledge Repository`**: optional. The publish remote for team lessons. An absent key falls back to the clone's `origin`.

The boot reads the customization first, then the whole user settings directory, then runs the first named command. Absent keys keep the default directory and the current shell.

**Tracking**: the customization is the project's dial. The workflow repository tracks its own copy so a clone boots without a setup step. The bootstrap ignores the file by default in new projects; a project may track it instead, for example when the whole team shares the dial. The loader accepts either state.

## Why Customization?

Different projects require different expertise (Cloud vs. Frontend), different behaviors (Mentor vs. Reviewer), and different regulatory standards (GDPR vs. SOC2). Instead of having one massive policy, we "compose" the AI's persona in the project directory using this file.

---

## 1. Composing Expertise (Technical Roles)

Use the `## Active Expertise` section to load domain-specific policies from the `ai/policies/` directory in your clone (resolved through **Workflow AI Directory**).

**Example:**

```markdown
## Active Expertise
- cloud
- api-backend
```

**How it works**: The AI assistant will look for a matching file in the global directory using two patterns (`ai-policy-<name>.md` first, then `<name>.md`) and load all matched files as additive layers.

### On-demand policy triggers

A policy may declare its own trigger phrases in a `## Triggers` section. Say one of its phrases, such as `"cloud standards"`, and the AI loads that policy for the session without an Active Expertise entry. The policy phrases include `cloud standards`, `data standards`, `database standards`, `backend standards`, `outbound content scrub`, `knowledge file standards`, `issue standards`, `ticket standards`, `grill me`, and `brainstorm`.

- The trigger list is rebuilt at load context, post-compaction recovery, and checkpoint re-affirmation; it is never written to disk.
- A policy loaded only by a trigger is session-scoped. It does not survive a compaction; say the phrase again.
- `"use policy <name>"` loads any policy by its Active Expertise name, with or without a declared trigger.
- A duplicate or contained phrase across policies and procedures is rejected by the validator.

### Declared loading

A policy may declare when it loads in an optional `## Loading` section. Use one mode per policy:

- `- Mode: boot` loads it at boot.
- `- Mode: trigger` loads it by a `## Triggers` phrase, and requires at least one trigger.
- `- Mode: procedure` loads it when the named procedure runs, with `- Load in: <procedure-file-stem>`.
- `- Mode: expertise` loads it through `## Active Expertise`.

A policy without `## Loading` keeps today's behavior. A non-trigger mode forbids `## Triggers`, so adding one to a policy that has triggers requires removing them. The declaration describes the global loading paths: Active Expertise, a trigger phrase, boot, or an explicit procedure load. A project policy keeps the legacy boot load. Validate a custom policy with `support-files/validate-policy-authoring.sh`; see the [custom policy howto](custom-policy-howto.md).

### Team knowledge

The team knowledge store is optional. It is a Git repository or a read-only mount that a team shares.

- Set `Team AI Directory` to the local clone or mount.
- Set `Team AI Knowledge Repository` to the publish remote when it differs from the clone's `origin`.
- The store is `<Team AI Directory>/knowledge/`, and team skills are `<Team AI Directory>/skills/`.
- Keep lessons in `knowledge/<lesson-name>.md`. The filename is the id.
- Precedence is project knowledge, then team knowledge, then user knowledge.
- Team lessons are Class A: names and infrastructure detail stay, and secrets never do. The local sensitive-names list is not applied to team lessons; repository access is the privacy control.
- Say `"update team knowledge"` or `"publish to team knowledge"` to contribute one lesson. The AI removes secrets, checks for duplicates, writes the lesson on a branch, and opens a pull request. It never merges.

---

## 2. Activating Traits (Functional Personas)

Use the `## Active Traits` section to define *how* the AI should behave. These are not external files; they are behavioral directives adopted for the session.

**Note:** Only select **one** trait that best matches your role.

**Available traits:**

- **System Architect:** Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines; ensure cohesion across all system components. **Engagement style: Pressure-test architectural ideas with honest critique, identify risks, trade-offs, and blind spots. Do not be a "yes man."**
- **System Integrator**: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile). Flags breaking changes in shared schemas or DTOs.
- **Senior DBA**: Prioritize HA/DR, performance tuning (Explain First), and strict security guardrails.
- **Observability Architect**: Prioritize Four Golden Signals, log correlation, distributed tracing, and actionable alerting.
- **Code Reviewer**: Look for security vulnerabilities, performance bottlenecks, and coding standard violations.
- **Security Specialist**: Minimize attack surface. Enforce least privilege, check for exposed secrets, align with OWASP/CIS benchmarks.
- **Teacher/Trainer**: Explain the 'why' behind every 'how'. Break down complex tasks into teachable steps.
- **Platform Engineer**: Build and operate the shared platform: Kubernetes, CI/CD, infrastructure as code, and observability. Optimize for reliability, repeatability, least privilege, and self-service.
- **Software Developer**: Build and change application code across web and mobile components. Follow the project's existing stack and conventions, write the failing test first, and keep changes inside the requested scope.
- **Data Engineer**: Design and operate data pipelines, storage, and models. Prioritize correctness, idempotence, schema evolution, and cost-aware batch and streaming flows.

See [Presets by Role](#11-presets-by-role) for ready-made files that pair one trait with an expertise set and a compliance suggestion.

**Example:**

```markdown
## Active Traits
- System Architect: Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines; ensure cohesion across all system components. **Engagement style: Pressure-test architectural ideas with honest critique, identify risks, trade-offs, and blind spots. Do not be a "yes man."**
```

---

## 3. Enabling Compliance (Regulatory Standards)

Use the `## Required Compliance` section to load compliance modules from the global repository without copying them in the project directory.

**Example:**

```markdown
## Required Compliance
- gdpr
- iso-27001
```

**How it works**: The AI uses its built-in knowledge to apply the relevant requirements for each listed standard. No on-disk compliance files are needed.

---

## 4. The "Architect" Setup (Group-Level View)

If you are an **Architect** managing a group-level directory that contains multiple sub-projects (e.g., a "Solutions" folder containing `/infra`, `/api`, and `/frontend`), you can use `ai-customization.md` at the root to give the AI a comprehensive cross-domain vision.

**Architect Configuration Example:**

```markdown
## Active Expertise
- cloud        # For the infrastructure sub-folder
- api-backend  # For the backend services
- web-frontend # For the UI components

## Active Traits
- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile).
- System Architect: Design end-to-end infrastructure across networking, databases, Kubernetes, and virtual machines.
- Mentor: Help the team grow by providing high-signal architectural feedback.

## Required Compliance
- soc2
```

By placing this at the top level of the group directory, the AI is "bootstrapped" with all the necessary expertise to understand and coordinate the entire solution.

---

## 5. Choosing Where Design Docs Live

Use the optional `## Design Docs` section to record where your design documents live:

```markdown
## Design Docs
**Location**: design-docs/
```

Two values are recognized:

- `design-docs/`: the documents live beside your code, so they are version-controlled and travel with it.
- `ai/knowledge/`: the documents live under `ai/`, the fallback location before migration to `design-docs/`.

This section is optional, and it is normally written for you. Say `"update design documents"` and ask the AI to record your choice. If you have not decided, the AI detects the location from your project and asks when it is unclear.

---

## 6. Choosing the Merge Mode

Use the optional `## Merge Policy` section to tell the AI how to deliver an approved plan:

```markdown
## Merge Policy
**Merge Mode**: auto
```

Three values are recognized:

- `auto` (default): behaves as `direct`.
- `direct`: the AI squash-merges the branch to the trunk, deletes the branch, and pushes.
- `pr`: the AI pushes the branch and opens a pull request or merge request, or gives you the URL. It waits for the team to merge, then pulls the trunk.

Set `pr` when your team requires a pull request even if the remote would accept a direct push. `auto` falls back to `pr` when a direct push is rejected. No CLI is required: without `gh` or `glab`, the AI gives you the create or compare URL.

---

## 7. Summary of Naming Conventions

| Component | Example | Path Inferred |
| :--- | :--- | :--- |
| **Expertise** | `cloud` | `ai/policies/ai-policy-cloud.md` |
| **Expertise** | `web-frontend` | `ai/policies/ai-policy-web-frontend.md` |
| **Expertise** | `dba` | `ai/policies/ai-policy-dba.md` |
| **Expertise** | `observability` | `ai/policies/ai-policy-observability.md` |
| **Expertise** | `meta` | `ai/policies/ai-policy-meta.md` |
| **Expertise** | `accounting` | `ai/policies/ai-policy-accounting.md` |
| **Expertise** | `academic-researcher` | `ai/policies/ai-policy-academic-researcher.md` |
| **Expertise** | `career-coaching` | `ai/policies/ai-policy-career-coaching.md` |
| **Expertise** | `coding-baseline` | `ai/policies/ai-policy-coding-baseline.md` |
| **Expertise** | `windows-system-admin` | `ai/policies/ai-policy-windows-system-admin.md` |
| **Compliance**| `gdpr` | (AI built-in knowledge) |
| **Compliance**| `hipaa` | (AI built-in knowledge) |

> **Note: Peer Review (`code-review`)**. You do not need to add `code-review` to `ai-customization.md`. The peer review policy is loaded automatically when you say `"peer review"`, `"code review"`, or `"PR review"` in your AI chat. It is an on-demand mode, not a persistent expertise module.
>
> **Note: Codebase Examination (`codebase-examination`)**. Same behavior as peer review: say `"codebase examination"` or `"examine this codebase"` to activate it. Not an Active Expertise entry; not loaded in full at boot, and its metadata is indexed.
>
> **Note: Coding Baseline (`coding-baseline`)**. This policy is opt-in. Add `coding-baseline` to `## Active Expertise` to load it, or ask for the coding baseline policy by name. It gives the AI one language-neutral coding standard for most code work, covering Clean Code, SOLID, DRY, YAGNI, Twelve-Factor, TDD, OWASP secure coding, resilience, and telemetry. Telemetry is on by default for production code, with a clear recommendation and an easy opt-out. Tests, examples, exercises, and one-off scripts stay telemetry-free by default. Existing code changes only inside the requested scope.

---

## 8. Skills

Skills are separate from policies and do not appear under `## Active Expertise`. They load on demand.

- Global skills live in the workflow clone's `ai/skills/`; project skills live in your project root's `ai/skills/`; team skills live in `<Team AI Knowledge Directory>/skills/` when the team store is configured.
- A project skill replaces a team skill, and a team skill replaces a global one.
- Each skill is `ai/skills/<name>/SKILL.md` with `name` and a one-line `description` of at most 200 characters.
- Say `"use skill <name>"` to activate one, or let a single best description match load it for the task.
- A skill cannot override the protocol, a policy, or your customization file.
- The team repository's one-reviewer PR gate and access control are the trust boundary; the protocol does not verify review at boot.
- To contribute a team skill, copy the package into `skills/` and open a PR; one reviewer merges.
- The protocol does not scan a skill; you are responsible for its source.

See the [example skill](examples/skills/example-skill/SKILL.md).

---

## 9. Sensitive Names

Use the optional `## Sensitive Names` section to list the people, companies, clients, and internal names that must never appear in outbound artifacts for this project. The AI reads the list at run time and treats each entry as a hard scrub target. It never copies the list into its output.

```markdown
## Sensitive Names
- <name or company>
- <name or company>
```

---

## 10. Report Anomalies

Most sessions fail quietly. A tool call is denied, a file is missing, or the AI corrects a wrong statement, and the user never sees it. The opt-in "Report anomalies" rule makes the AI report each anomaly in the turn it notices it, so you can watch the work and file a precise issue when something breaks.

The rule is an instruction, not enforcement. An AI can still miss an anomaly. Treat the log as a best-effort record, not a guarantee. It is useful in two settings: a project where you want to watch the AI closely, and the protocol repository itself, where an entry often becomes a protocol fix.

### How to add it

Copy the rule into `ai-customization.md`. The `### Rule:` block needs a top-level `##` parent:

- Use `## Development Workflow` when the file already keeps workflow rules.
- Use `## Report Anomalies` when it does not.

```markdown
### Rule: Report anomalies

- Report every anomaly in the same turn you notice it. Never fail silently.
- An anomaly is a denied or failed tool call, an unreadable or missing file, a failed or no-op edit, a state-file problem, a deviation from the rules or the protocol, a wrong statement you later correct, or tool friction (a hang, a slow command, a missing tool).
- Tag each one A (AI deviation), W (wrong statement) or F (tool friction). Number each tag per day from 1: A1, A2, W1, F1. The day is the current calendar date, matching the daily checkpoint file.
- In chat, say what happened, what was done, and what changed.
- In the checkpoint log, record each entry without names, internal paths, or secrets. Keep the full detail in chat.
- At each checkpoint, add the new A, W and F entries as an `### Anomalies` subsection inside that checkpoint's section in the daily checkpoint file. Never edit an earlier entry.
- When there are no new entries at a checkpoint, omit the `### Anomalies` subsection.
```

### What the AI reports

- **Tags**: A is an AI deviation, W is a wrong statement the AI later corrects, and F is tool friction. Numbers reset each day per tag, so `A1`, `A2`, `W1`, and `F1` are separate.
- **Chat**: the AI says what happened, what it did, and what changed, in the same turn it notices the anomaly.
- **Checkpoint**: the AI adds the new entries as an `### Anomalies` subsection inside that checkpoint's section in the daily checkpoint file. An earlier entry is never edited, and the subsection is omitted when there is nothing new.
- **Privacy**: the checkpoint can be committed with the repository, so entries stay terse. No names, internal paths, or secrets; the full detail stays in chat.

### Turning an entry into an issue

Include the tag, the step or file involved, and what the AI did. A short line such as "F2: the index helper hung for five minutes in step 2" gives enough to start. Scrub names, internal paths, and secrets before you post.

---

## 11. Presets by Role

Presets are ready-to-copy `ai-customization.md` files for common roles. Each one is a full variant with the workflow placeholders, one suggested trait, the `design-docs/` location, and the `auto` merge mode. The files live in `docs/examples/customization-presets/`.

To use one, copy `<role>.md` to your project root as `ai-customization.md`, set **Workflow AI Directory** to your clone, then adjust the expertise, trait, or compliance entries for the project. A preset is a starting point, not a policy. The protocol modules remain authoritative.

The role slugs are the preset identifiers the `--init` mode consumes. The compliance entries are suggestions; confirm them for your project.

To scaffold a new project from one of these presets, see [Initialize a new project](setup.md#initialize-a-new-project).

| Role | Active Expertise | Suggested trait | Compliance |
| --- | --- | --- | --- |
| `cloud-architect` | `cloud`, `api-backend`, `data`, `dba`, `web-frontend`, `observability` | System Architect | `soc2`, `iso-27001` |
| `solution-architect` | `cloud`, `api-backend`, `data`, `dba`, `web-frontend`, `mobile-apps` | System Integrator | `soc2`, `iso-27001` |
| `web-developer` | `web-frontend`, `api-backend`, `coding-baseline` | Software Developer | None pre-filled |
| `mobile-developer` | `mobile-apps`, `api-backend`, `coding-baseline` | Software Developer | None pre-filled |
| `platform-engineer` | `cloud`, `linux-system-admin`, `windows-system-admin`, `observability` | Platform Engineer | `soc2`, `iso-27001` |
| `dba` | `dba`, `data` | Senior DBA | None pre-filled |
| `data-engineer` | `data`, `dba`, `cloud` | Data Engineer | `soc2`, `iso-27001` |
| `security-engineer` | `coding-baseline`, `observability`, `cloud` | Security Specialist | `soc2`, `iso-27001` |

See [the full-stack example](examples/full-stack-web-mobile-ai-customization.md) for a combined multi-component configuration.

## Best Practices

1. **Start Small**: Don't load every policy at once. Only activate what you need for the current focus.
2. **Explicit Traits**: Be specific with your traits. Instead of just "Teacher," say "Teacher: Focus on explaining Bicep syntax."
3. **No Project Copies**: Never copy the `ai-policy-*.md` files into your project. Referencing them by name keeps your project clean and ensures you always use the latest global standards.
