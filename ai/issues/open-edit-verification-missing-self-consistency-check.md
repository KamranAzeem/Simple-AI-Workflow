Reported: 2026-09-10
Reporter: Kamran Azeem / GitHub Copilot
IssueType: Improvement/Refactor
Severity: Human-to-decide (AI estimate: P2)
Size: Human-to-decide (AI estimate: S)
URL:
Summary: Investigation Contract has no rule requiring a claim to be cross-checked against other sections of the same document being edited, or against source documents already read this session

Description:

Real incident, client project session, production database GRS (geo-redundant
storage) migration planning, 2026-09-10.

While drafting a production migration plan document, the AI read the
completed test-environment equivalent plan document in full, twice, and
correctly transcribed its architecture into the new document's own "Key
architectural constraint" section: the new GRS server is created via CLI
first, then adopted into IaC afterward (IaC has exactly one conditional
database module slot per environment, so it cannot describe a server that
does not exist yet).

Later in the same session, responding to a user's 7-point critique of the
document, the AI edited a different, narrow claim in the same file (the
default value of a private-endpoint connection-name parameter) and verified
that narrow claim correctly by grepping the live `main.bicep` /
`test.bicepparam` source. But in the same edit pass it also asserted a much
broader, unverified claim alongside it: that the new production server would
be "provisioned directly via IaC (bicep deploy) from the start, not
adopt-in-place." This directly contradicted the correct architecture already
recorded, minutes earlier in the same document, in that document's own "Key
architectural constraint" section — which the AI had itself read again just
before making this edit, while gathering context for the same critique
response. The user caught the contradiction and had to ask for a correction.

When later asked to explain the mistake, the AI reconstructed the session
transcript in full (628 lines) to answer precisely rather than guess. This
confirmed: project knowledge (the test-environment plan document, the ticket
knowledge file) was genuinely consulted, both at the point the plan was first drafted
and again minutes before the erroneous edit. The failure was not a missing- or
un-consulted-knowledge problem. It was that the AI verified the one specific
sub-claim it was actively grepping for (the connection-name default), then
built a broader architectural inference on top of it without re-checking that
broader inference against (a) other sections of the very document being
edited, or (b) the source document it had already read correctly earlier in
the same turn.

The current Investigation Contract in `ai-policy-common.md` requires every
claim to name a source, and requires cross-checking "a fact that matters" by
more than one independent source before recommending it. In practice this
reads as applying per-claim, at the moment a claim is first authored. It does
not explicitly require re-validating a claim against material the AI has
*already read this session* — including other sections of the same document
currently being edited — when that claim did not originate from the source
just consulted. A multi-section planning/runbook document (Evidence Base, HLD,
LLD, Risk Assessment, Delivery Ledger, etc.) is exactly the shape of artifact
where this gap bites: a narrow fix to one section can silently contradict an
already-correct earlier section, and nothing in the contract catches that
before the edit lands.

Proposed fix (for design/discussion, not locked):

- Add an explicit rule to the Investigation Contract in `ai-policy-common.md`,
  distinct from (but adjacent to) the existing "cross-check before
  recommending... by more than one independent source" sentence: before
  finalizing an edit that introduces or changes a broader claim inside a
  multi-section document, check that claim against (a) every other section of
  the same document already read this session, and (b) any source document
  the current section's content was originally derived from, when that source
  was also already read this session. This is a self-consistency check, not a
  new investigation — it only requires re-checking material already in
  context, so it should not meaningfully add token cost.
- Scope the rule narrowly to avoid false-positive overhead on small, truly
  independent edits: it applies when an edit changes or introduces a claim
  about architecture/mechanism/sequencing (not e.g. a wording, formatting, or
  purely cosmetic fix), and only when the document being edited already has
  other sections that make a related claim.
- Consider whether this belongs as a sub-bullet under the existing
  Investigation Contract paragraph or as its own short paragraph — keep the
  contract's existing prose style and avoid adding new enumerated
  sub-structure if a single added sentence suffices.
- No `validate-protocol.sh` anchor is obviously needed (this is a prose
  behavioral rule, not a file/structure check), but confirm that during
  implementation rather than assuming it.

Scope note: this issue is about the specific gap this incident exposed
(claim not cross-checked against already-read material in the same
document/session). It is not proposing a general rewrite of the Investigation
Contract, and it is not proposing new tooling or scripted enforcement.
