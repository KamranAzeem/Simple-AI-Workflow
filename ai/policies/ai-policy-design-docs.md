# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Design Documents

Govern the design document chain, types, naming, location, and delivery ledger.

## Loading

- Mode: procedure
- Load in: update-design-docs

## Scope

- Apply this policy to design documents in `design-docs/` and in the `ai/shared/project-knowledge/` fallback.
- Exempt acceptance specs under `design-docs/specs/`; the owning procedure or test work writes and updates them, and they are not design documents.
- This policy owns document types, naming, creation, update, extraction, migration, and the delivery ledger.
- It does not own knowledge file standards, state files, or issue tickets.

## Nature

- A design document describes a solution, an application, a module, a component, or infrastructure.
- It is self-standing. It holds design content only.
- Prohibited in a design document: work logs, checkpoint targets, version-control references (commit hashes, branch names), session trivia, command transcripts, and prose filler.
- A plan is not a design document.
- Plans live under `ai/`, never in `design-docs/`; do not suggest moving a plan into `design-docs/`.
- Prefer refusing over corrupting an existing document.

## Document Types

Fixed lowercase doc-type tokens, and nothing else:

- `vision`
- `prd`
- `hld`
- `lld`
- `risk-and-gap-analysis`
- `delivery-ledger`
- `adr-<nnn>-<short>`

Acceptance criteria are coupled to the LLD. They are not a separate document type. An unknown doc type is never invented; ask.

## Document Chain

- Documents form a chain; each feeds the next: notes, vision, PRD, HLD, LLD with acceptance criteria, risk and gap analysis, ADRs, and the delivery ledger.
- Work one document at a time. Before creating the next, run a gap analysis and peer review on the existing ones and resolve every finding.
- Apply the blocking review gate in `ai-policy-code-review.md` to that peer review.
- Never skip from notes or vision to implementation.

## Requirement Gathering

- Gather enough requirements to build an MVP, then iterate.

## Proportional Depth

- For small work, use context plus acceptance criteria.
- For medium, large, and architectural work, use the full document set.
- Application developers mostly need the light path plus ADRs for real decisions; solution architects need the layered, multi-repo set; infrastructure engineers need requirements, design, and a runbook.

## Layering

- A large solution may use layered design documents.
- Layer 1 is the bird's-eye view: major components, modules, and subsystems.
- Each later layer details one component.

## Naming

- Suffix form only. The doc type is the last token, in lowercase.
- Migrated (`design-docs/`): the simple name, with no project token.
  - `vision.md`, `prd.md`, `hld.md`, `lld.md`, `risk-and-gap-analysis.md`, `delivery-ledger.md`, `adr-001-<short>.md`.
- Not migrated (`ai/shared/project-knowledge/`): a project or component token precedes the doc type.
  - `payment-gateway-app-prd.md`, `kubernetes-setup-hld.md`.

## Discovery and Scope

- Index every `design-docs/` directory at boot, at post-compaction recovery, and at the checkpoint re-affirmation, up to five levels deep.
- Fallback: match the doc-type vocabulary in the project knowledge directory.
- Scope comes from the directory location, never from a filename alone.
- No manifest is kept. The filesystem is the source of truth.
- No qualifier means the session's design context. An ambiguous or unmatched qualifier is resolved with the user.

## Location and Migration

- Write in the location the project currently uses.
- Detect the current location: a `design-docs/` directory means migrated, otherwise the project knowledge fallback.
- The update procedure never moves a file between locations.
- The trigger `"migrate design docs"` is the only cross-location mover.
- When the project is not migrated, offer migration once per session. State the benefits: the design is version-controlled and travels with the code. State that `design-docs/` is JIT-indexed at boot and at recovery.
- If the user declines, keep working in the current location and acknowledge the choice.

## Customization Record

- `## Design Docs` section with a `**Location**:` entry in the customization file.
- Written only on the user's explicit instruction.
- A detected firm decision is recorded in the appropriate project knowledge file, so it is not lost.

## Extraction

- A design file found under the fallback location moves to its proper location. It is never copied.
- Design content embedded in a broader knowledge file is extracted into a design document. The extracted document is the authority; the source knowledge file does not keep a pointer.

## Confirmation and Challenge

- Present the change set first: which documents, which sections, and whether each change is an add or a modify.
- Challenge each substantive design decision with one to three sharp questions, each with a recommended answer.
- Show a per-document diff. Approve per document or as a batch.
- A dry run writes nothing.
- Refuse when the scope is ambiguous, when a design statement lacks evidence, or when content conflicts.
- In Protocol Developer Mode, write the ADR entry for a protocol change as part of that change, confirmed by the plan and implement approval.
- In Protocol Developer Mode, the `update design documents` trigger is not required for that ADR entry.

## Conciseness

- Bullets and IDs. No narrative and no rationale essays.
- Rationale belongs in an ADR and stays terse.
- Create a missing document only when the discussion names its content, from its per-type skeleton.

## Per-type Skeleton

- `vision`: What, Why, Goals, Out of scope.
- `prd`: problem, users, success criteria, scope. `REQ-NNN` IDs.
- `hld`: architecture, components, boundaries, technology. `HLD-NNN` IDs.
- `lld`: interfaces, data flows, APIs, schemas, acceptance criteria. `LLD-NNN` IDs.
- `risk-and-gap-analysis`: open risks and gaps. `RSK-NNN` IDs.
- `adr-<nnn>-<short>`: decision, context, consequences. `ADR-NNN` IDs.
- `delivery-ledger`: one line per item: ID, status, release.

## Session-Start Check

- At the start of each session, check for the mandatory artifacts.
- For medium or larger work, tell the user when any is missing and ask whether to create it.

## ID Convention

- Give every requirement, component, design item, risk, and decision a unique sequential ID starting at `001`.
- Never reuse or delete an ID.
- Mark a cancelled item `[CANCELLED]` and leave the ID in place.

## Delivery Ledger

- Update the ledger when a design document lands or changes, and only for the documents touched.
- One ledger per repo, plus a project-root rollup.
- Create the ledger when the first design document lands.
- Keep one section per design document and one line per item.
- Use the status values `Not Started`, `In Progress`, `Done`, and `Cancelled`.
- The checkpoint never updates the ledger.

## Supplementary Documents

- Create these when the project's complexity warrants them: an API specification, a data model or ERD, a security architecture, a deployment architecture, and a glossary.

## Update Discipline

- Update design documents alongside the code they describe.
- Treat documentation drift as a defect.

## Prohibited

- No operational bookkeeping in any design document.
- No design document is written without confirmation.
- No invented doc types, IDs, or content.

## References

- `ai-policy-common.md` for the common guardrails and the knowledge boundary.
- The clone's `ai/procedures/` store for the update-design-docs and migrate-design-docs modules.
- The Project Customization File for the design-docs location.

<!-- AI-ASSISTANT: READ-ONLY END -->
