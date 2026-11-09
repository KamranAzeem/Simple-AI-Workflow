# PROCEDURE UPDATE-DESIGN-DOCS: When the user says "update design documents"

## Triggers

- update design documents
- update design docs
- update design-docs

**Boundaries**: handles design documents only. It never updates project knowledge or global knowledge, and never writes operational bookkeeping into a design document. The checkpoint never invokes it. The rules live in `ai-policy-design-docs.md` in the **Global AI Policies Directory**, loaded at STEP-LOAD-DESIGN-DOCS-POLICY.

**Failure rule**: refuse rather than corrupt. When the scope is ambiguous, a design statement lacks evidence, or content conflicts, stop and ask.

1. **STEP-LOAD-DESIGN-DOCS-POLICY**: Load `ai-policy-design-docs.md` from the **Global AI Policies Directory** in full.
2. **STEP-DETERMINE-LOCATION**: Read the `## Design Docs` `**Location**:` entry from the **Project Customization File** if it is present. Detect the current location: a `design-docs/` directory means migrated, otherwise the `ai/shared/project-knowledge/` fallback.
3. **STEP-RESOLVE-SCOPE**: Parse the qualifier that follows the trigger, for example "related to the payment gateway app". Match it to a component directory, a repo, or a document scope. No qualifier means the session's design context. An ambiguous or unmatched qualifier is resolved with the user before any write.
4. **STEP-FIND-DOCS**: Find candidate documents using the boot design-docs index, the doc-type vocabulary, and the fallback location.
5. **STEP-GATHER-DELTAS**: Collect candidate design deltas from the session, and from project knowledge only when the user points at it or a design file is found there. Never invent content.
6. **STEP-PROPOSE-CHANGESET**: Present the change set: which documents, which sections, and whether each change is an add or a modify.
7. **STEP-CHALLENGE**: Challenge every substantive design decision with one to three sharp questions, each carrying a recommended answer.
8. **STEP-CONFIRM**: Show a per-document diff. Get approval per document or as a batch. A dry run writes nothing.
9. **STEP-WRITE**: Create a missing document from its per-type skeleton only when the discussion names its content, or update an existing one. Dedupe by ID. Keep it concise, with no bookkeeping.
10. **STEP-UPDATE-LEDGER**: Update the Delivery Ledger for the documents touched. Create the ledger when the first design document lands.
11. **STEP-OFFER-MIGRATION**: When the project is not migrated, offer migration once per session, state the benefits, and acknowledge any choice. The trigger `"migrate design docs"` performs the move when the user accepts.
12. **STEP-REPORT**: Summarize the documents created or updated, the location used, and any deferral.
