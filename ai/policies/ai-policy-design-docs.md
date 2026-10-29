# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Design Documents

Loaded by `PROCEDURE UPDATE-DESIGN-DOCS`, only when the user says `"update design documents"` (alias `"update design docs"`).

## Scope

- Apply this policy to design documents in `design-docs/` and in the `ai/shared/project-knowledge/` fallback.
- This policy owns document types, naming, creation, update, extraction, migration, and the delivery ledger.
- It does not own knowledge file standards, state files, or issue tickets.

## Nature

- A design document describes a solution, an application, a module, a component, or infrastructure.
- It is self-standing. It holds design content only.
- Prohibited in a design document: work logs, checkpoint targets, version-control references (commit hashes, branch names), session trivia, command transcripts, and prose filler.
- A plan is not a design document.
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

## Delivery Ledger

- Update the ledger when a design document lands or changes, and only for the documents touched.
- One ledger per repo, plus a project-root rollup.
- Create the ledger when the first design document lands.
- The checkpoint never updates the ledger.

## Prohibited

- No operational bookkeeping in any design document.
- No design document is written without confirmation.
- No invented doc types, IDs, or content.

## References

- `ai-policy-common.md` for the common guardrails and the knowledge boundary.
- `AGENTS.md` for `PROCEDURE UPDATE-DESIGN-DOCS` and `PROCEDURE MIGRATE-DESIGN-DOCS`.
- The Project Customization File for the design-docs location.

<!-- AI-ASSISTANT: READ-ONLY END -->
