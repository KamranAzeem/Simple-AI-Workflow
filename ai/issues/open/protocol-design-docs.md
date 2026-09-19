Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P3
Size: L
URL:
Summary: Create the protocol's own design documents (Vision, PRD, Delivery Ledger, HLD, LLD)

Description:

The protocol ships a design-documentation feature for user projects, but the protocol repository itself has none of those documents. `protocol-decisions.md` already serves as the ADR store.

Deliverables, in priority order:
1. Delivery Ledger first, so implementation work can be tracked against design items with REQ/HLD/LLD IDs.
2. Vision: short and plain language, what the protocol is and why.
3. PRD: requirements with REQ-NNN IDs.
4. Lean HLD: architecture and component decomposition with HLD-NNN IDs.
5. LLD per module, built incrementally as the protocol is tightened.

Constraints:
- Follow the naming and ID conventions in the common policy's Design Documentation Standards.
- Keep the protocol's own docs lean; do not duplicate `protocol-decisions.md` (ADRs) or the README.
- The documents live under the Project AI Knowledge Directory until a decision moves them to `docs/`.

Acceptance criteria:
- A Delivery Ledger exists and is updated at each checkpoint once implementation begins against it.
- Vision, PRD, and lean HLD exist with numbered items.
- No duplication of existing ADR or README content.
