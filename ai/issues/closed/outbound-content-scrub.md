Reported: 2026-11-11
Reporter: Kamran Azeem
IssueType: Feature
Severity: P2
Size: L
Label:
URL: <https://github.com/KamranAzeem/Simple-AI-Workflow/issues/7>
Summary: Scrub secrets and audience-inappropriate identifying data from outbound artifacts

Description:

Two-class outbound scrub. Class A (internal or same audience) keeps names and infrastructure detail and removes secrets. Class B (external or different audience) removes names, internal hosts, identifiers, and secrets. Secrets are never overridable.

v1 covers external ticket creation, plan-entry comments, close or reopen comments, PR/MR title and body, and release notes. Reports, slides, handoffs, and design-document sharing get their own steps later.

Plan attached below.

---
2026-11-13
Plan created. Peer review in progress.

---
2026-11-13
Peer review APPROVED. The plan is ready for implementation on `feature/outbound-content-scrub`. No branch is open and no implementation has started.

---
2026-11-13
Plan scope updated to option A. Step 0 delivers the `/tests/` test-location move. Peer review round 3 is APPROVED.

## Implementation Plan

> This is the approved plan, attached at implementation time. The dated ticket entries above record the implementation outcome.

# Outbound Content Scrub: Implementation Plan

**Ticket**: GitHub #7 at <https://github.com/KamranAzeem/Simple-AI-Workflow/issues/7>, mirrored as `ai/issues/open/outbound-content-scrub.md`.
**Status**: Planning only. No branch, no implementation, no external writes.
**Size**: L.
**Merge mode**: `direct` (default; `ai-customization.md` has no `## Merge Policy`).
**Release**: v6.4.0 (minor).
**Approval**: The approved plan is the human approval to edit the read-only common policy, per `ai-policy-meta.md` (`## Required Pre-action Checks`).

## Goal

Remove secrets and audience-inappropriate identifying data from every artifact before it leaves the project. Use two destination classes. Secrets are never overridable.

## Decisions from the grilling

- Two classes: Class A (internal or same audience) and Class B (external or different audience).
- Secrets are always removed in both classes. The user cannot override this.
- The test is the intended destination and audience, not the physical path.
- The AI infers the destination from the request, states the class before drafting, and asks only when the destination is ambiguous.
- Class A keeps customer names and infrastructure detail, and still removes secrets.
- Class B offers the full scrub. On acceptance, remove names, internal hosts, URLs, identifiers, ticket keys, and named file paths.
- A public or irreversible destination defaults to redaction and requires explicit approval.
- Private IP addresses are kept: IPv4 RFC 1918, loopback, and link-local, and IPv6 ULA and link-local. Public addresses are replaced with documentation addresses unless the user confirms they are public and necessary.
- Non-secret names may be restored by a recorded override after a warning. A public post needs explicit confirmation. Secrets have no override.
- Names-list sources: the global settings list, an optional project customization list, and project knowledge as context. The union of all sources wins.
- Placeholders: neutral phrases, `example.com`, RFC 5737 addresses for public IPs, `user@example.com`, `PROJECT-123`, `<redacted-secret>`, and `<internal-host>`.
- Two passes: a judgment pass, then a mechanical pass over the exact text that leaves. The mechanical patterns are emails, public IPs, GUIDs, non-public URLs, token shapes, private-key markers, and signed-URL query parameters.
- Non-text artifacts get a visual review and a metadata strip. Scrub the exported artifact, not only the source.
- No helper script runs the scrub. The AI performs the checks.
- Report categories and counts in chat only. The categories are person names, usernames or handles, email addresses, company or client names, internal project or system names, internal hosts, public IP addresses, internal URLs, ticket keys, paths with names, secrets or tokens, and metadata. Never repeat a removed value. Keep no persistent report file.
- The unscrubbed draft may live under `ai/artifacts/`. Only the scrubbed text leaves.
- v1 is wider: it covers external ticket creation, plan-entry comments, close or reopen comments, PR/MR title and body, and release notes.
- GitHub issue #7 is not updated during planning. A closing comment reports the outcome when the merge lands.

## Scope

In scope:

- The common policy contract.
- The manage-issues procedure.
- The implement-plan procedure.
- Validator anchors.
- The `/tests/` test-location move.
- Class A and Class B fixtures.
- The ADR entry.
- README, workflow guide, slides, global settings template, and customization guide.
- The release announcement.

Out of scope for v1:

- A dedicated report-sharing procedure.
- A dedicated presentation or slide-deck procedure.
- A handoff-creation step. The handoff ticket adds it later.
- Design-document sharing.
- A scrub helper script.
- Updating the GitHub issue body.

## HLD

Components:

- `ai-policy-common.md` owns the contract.
- `MANAGE-ISSUES` invokes the contract for external ticket writes.
- `IMPLEMENT-PLAN` invokes the same step for PR/MR and release writes.
- `validate-protocol.sh` and `/tests/` pin the structure and the fixtures.
- The ADR records the decision.
- User-facing docs explain the behavior.

Ownership boundaries:

- The existing commit guardrail stays in the common policy. The outbound contract does not duplicate it.
- Domain policies keep their domain-specific sensitive-data rules. The common contract points to them.
- Knowledge-file scope rules stay separate. Stored knowledge is not an outbound artifact.
- Peer review stays a separate quality gate.

Flow:

1. Resolve the destination class.
2. Draft.
3. Run the judgment pass, then the mechanical pass.
4. Show the scrubbed text and the category report.
5. Get approval.
6. Post, merge, or release.

Failure behavior:

- Unknown destination: ask.
- Unknown sensitivity: treat the item as sensitive and ask. For a public destination, redact and report.
- Image or attachment not visually reviewed: write "not verified" and wait.
- A secret is found: remove it. Do not offer an override.
- The user declines a non-secret scrub for Class B: record the override. For a public destination, require explicit confirmation.

## LLD with acceptance criteria

### 0. Test-location prerequisite

Changes:

- Create `tests/` at the project root.
- Move the six test scripts from `support-files/` to `tests/`:
  - `test-load-context-boot.sh`
  - `test-protocol-references.sh`
  - `test-skills-index.sh`
  - `test-sync-agents-md.sh`
  - `test-knowledge-repair-fixture.sh`
  - `test-trigger-rules.sh`
- In `tests/test-sync-agents-md.sh`, resolve the sync script as `"$ROOT/support-files/sync-agents-md.sh"`.
- Update the usage comments in `tests/test-load-context-boot.sh` and `tests/test-trigger-rules.sh`.
- Update the test paths in `docs/protocol-validation-system.md`.
- Update the test paths in `ai/shared/project-knowledge/protocol-verification-toolchain.md`.
- Leave the historical announcement `docs/announcements/v5.5.2.md` unchanged.
- Run all six tests from `tests/`.

Acceptance criteria:

- The six scripts run from `tests/` and pass.
- No test script remains in `support-files/`.
- `support-files/` holds only the sync scripts, the validators, and its README.
- The docs name the new paths.
- The move is one commit, separate from the scrub feature.

### 1. Common policy contract

Changes in `ai/policies/ai-policy-common.md`:

- Broaden Non-Negotiables item 5 to cover commits and outbound artifacts.
- Keep the commit detail in the `## Universal Operational Guardrails` bullet and add a pointer to the new section.
- Add `## Outbound Content Scrub` after the guardrails section.
- Add subsections for destination classes, always-remove secrets, Class B removals, keep list, detection, placeholders, approval and report, override, non-text artifacts, local draft, and failure behavior.
- Define the private ranges that stay: IPv4 `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `127.0.0.0/8`, and `169.254.0.0/16`; IPv6 `fc00::/7` and `fe80::/10`.
- Define the mechanical patterns: emails, public IPs, GUIDs, non-public URLs, token shapes, private-key markers, and signed-URL query parameters.
- Define the report categories: person names, usernames or handles, email addresses, company or client names, internal project or system names, internal hosts, public IP addresses, internal URLs, ticket keys, paths with names, secrets or tokens, and metadata.

Acceptance criteria:

- The section exists with both classes and the unconditional secret rule.
- The guardrail bullet points to the section.
- The full rule is not duplicated in two places.
- The section passes the authoring validator.

### 2. Manage issues

Changes in `ai/procedures/manage-issues.md`:

- Split `STEP-TICKET` into three steps: `STEP-TICKET` for resolve and draft, `STEP-SCRUB-OUTBOUND` for the scrub, and `STEP-POST-TICKET` for the write.
- `STEP-TICKET` resolves the request and the destination, and drafts the text.
- `STEP-SCRUB-OUTBOUND` applies the contract, states the class, shows the scrubbed text and category report, and gets approval.
- `STEP-POST-TICKET` creates, closes, or reopens the ticket.
- `STEP-PLAN` appends the plan entry to the local ticket. If the ticket is external, run `STEP-SCRUB-OUTBOUND` before posting.
- Apply the scrub to close and reopen comments when one is posted.

Acceptance criteria:

- `STEP-SCRUB-OUTBOUND` is defined once.
- A local ticket skips the name scrub but still removes secrets.
- An external ticket creation, a plan-entry comment, and a close or reopen comment are scrubbed before posting.

### 3. Implement plan

Changes in `ai/procedures/implement-plan.md`:

- In `STEP-SHIP`, reference `STEP-SCRUB-OUTBOUND` before opening or updating a PR/MR.
- Reference it again before publishing release notes.
- Name the PR/MR title, the PR/MR body, and the release notes as the artifacts.

Acceptance criteria:

- The step is referenced in plain text, not redefined as a bold step, so the reference test sees one definition.
- The PR/MR and release artifacts are named.
- The approval gate applies before the external write.

### 4. Validators and tests

Changes:

- `support-files/validate-protocol.sh`: add anchors for the section and the step.
- Add `tests/test-outbound-content-scrub.sh` and fixtures:
  - `tests/outbound-content-scrub/class-a-input.md`
  - `tests/outbound-content-scrub/class-a-expected.md`
  - `tests/outbound-content-scrub/class-b-input.md`
  - `tests/outbound-content-scrub/class-b-expected.md`
- `docs/protocol-validation-system.md`: list the new checks.

Acceptance criteria:

- The validator passes.
- The Class A fixture keeps the customer name and removes the token.
- The Class B fixture removes the person name, company name, internal host, public IP, email, GUID, and token.
- The Class B fixture keeps the private IP and contains the expected placeholders.
- The test does not implement the scrub. It asserts the fixtures and the policy anchors.
- The expected files are hand-written by the implementer and peer-reviewed. The test asserts them statically. It does not prove the AI's judgment pass.
- Step 0 completes before the scrub fixture lands. The scrub fixture lives in `tests/outbound-content-scrub/`.

### 5. Documentation

Changes:

- `README.md`: add the outbound scrub to the feature list and the issue-management bullet.
- `docs/workflow-guide.md`: extend Section 16 and add a short outbound section.
- `docs/simple-ai-workflow-slides.md`: add the feature bullet.
- `docs/global-user-settings.md`: add an optional `## Sensitive Names` section with placeholders.
- `docs/ai-customization-guide.md`: add the optional project `## Sensitive Names` section.
- `docs/announcements/v6.4.0.md`: write at release time.

Acceptance criteria:

- Each document states the two-class model and the v1 scope.
- The global settings template contains no real names.
- Markdown lint passes.

### 6. ADR

Changes:

- Add a dated entry to `design-docs/protocol-decisions.md`.

Acceptance criteria:

- The entry states the decision, context, consequences, and deferred consumers.
- The entry is self-contained and has no commit hash or branch name.

## Top-level acceptance criteria

1. The common policy has `## Outbound Content Scrub` with the two classes and the unconditional secret rule.
2. The Non-Negotiables item and the guardrail bullet cover outbound artifacts and point to the section.
3. `STEP-SCRUB-OUTBOUND` is defined once and referenced by both work-item procedures.
4. External ticket creation, plan-entry comments, close or reopen comments, PR/MR title and body, and release notes run the scrub before posting.
5. A Class A fixture keeps the customer name and removes the token.
6. A Class B fixture removes the person name, company name, internal host, public IP, email, GUID, and token; keeps the private IP; and contains the expected placeholders.
7. A public destination defaults to redaction and requires explicit approval.
8. A non-secret override is recorded. A secret override is refused.
9. The category report shows categories and counts, never values, and stays in chat.
10. No helper script implements the scrub.
11. `validate-protocol.sh`, the reference test, the new fixture, markdownlint, and shellcheck pass.
12. The ADR entry and the docs are updated.
13. `AGENTS.md` stays under its thin targets: 160 lines, 2,400 words, and 24,900 bytes. It is 157 lines, 2,399 words, and 16,869 bytes today.
14. Step 0 moves the six test scripts to `/tests/`, updates the references, and all six pass from the new location.

## Risks and mitigations

- Judgment varies between models. Mitigation: the mechanical pass, fixtures, peer review, and a conservative default.
- Over-scrubbing makes a report useless. Mitigation: keep technical facts and shape-preserving placeholders.
- Under-scrubbing a public post is irreversible. Mitigation: redact by default, show the category report, and require explicit approval.
- The test cannot execute the AI. Mitigation: test the mechanical patterns and the anchors, and peer review the judgment.
- A duplicate step name fails the reference test. Mitigation: define the step once in manage-issues and reference it from implement-plan.
- Step 0 adds a structural change to the scrub branch. Mitigation: keep it as its own first commit, review it independently, and run all six tests before the scrub changes.
- Private and public IPs are confused. Mitigation: define the private ranges and keep them.
- Images and rendered exports are missed. Mitigation: visual review, metadata strip, and a "not verified" stop.

## Evidence

Files read in full:

- `AGENTS.md` (157 lines).
- `ai-customization.md` (36).
- All 18 policy files (3,017 lines).
- All 13 procedure modules (350).
- `design-docs/protocol-decisions.md` (983).
- `support-files/validate-protocol.sh` (418).
- `support-files/validate-policy-authoring.sh` (580).
- `support-files/test-protocol-references.sh` (134).
- `support-files/test-load-context-boot.sh` (131).
- `README.md` (457).
- The affected docs: protocol validation system (48), agent collaboration (74), multi-agent runbook (167), compliance guide (36), customization guide (183), global user settings (124), workflow guide sections 360 to 469, and slides sections 1 to 80.

Commands and results:

- `gh issue view 6` and `gh issue view 7`: issue details and the companion relationship.
- `wc -l`: the line counts above.
- `git status --short`: the working tree also holds the TDD ticket edits and state-file edits from earlier work.
- `wc -l -w -c AGENTS.md`: 157 lines, 2,399 words, 16,869 bytes.
- `git rev-parse --abbrev-ref HEAD`: `master`.
- `git rev-parse --short HEAD`: `e3d774c`.
- `grep -c '^## Merge Policy' ai-customization.md`: 0, so the merge mode defaults to `direct`.

Confirmed facts:

- `ai/procedures/manage-issues.md` has four steps. `STEP-TICKET` is line 12 and `STEP-PLAN` is line 13.
- `ai/procedures/implement-plan.md` `STEP-SHIP` is line 11.
- `ai/policies/ai-policy-common.md` Non-Negotiables item 5 is line 27 and the guardrail bullet is line 117.
- `support-files/test-protocol-references.sh` rejects duplicate step definitions, so the step is defined once.
- `support-files/test-sync-agents-md.sh` resolves the sync script from its own directory, so the move needs a one-line path fix.
- The test-path references are four in `docs/protocol-validation-system.md` and five in `ai/shared/project-knowledge/protocol-verification-toolchain.md`.
- `ai-customization.md` has no `## Merge Policy`, so the plan uses `direct`.
- GitHub #7 is open and its body is stale. It will not be updated during planning.

Open questions:

- None from the grilling. The only dependency is the TDD test-location move.

## Close Sequence

- Repo: this project root.
- Base ref: `master`.
- Branch: `feature/outbound-content-scrub`.
- Merge mode: `direct`.
- Ticket: `ai/issues/open/outbound-content-scrub.md`, with external issue #7.
- Release: v6.4.0 (minor).

Actions:

1. Open the branch before the first file change.
2. Implement step 0 and run all six tests from `tests/`.
3. Implement the scrub changes.
4. Run the implementation peer review. Fix every Critical and Major finding and re-review until APPROVED.
5. Attach this plan to the local ticket under `## Implementation Plan`. Replace the active plan link with `Plan attached below.`. Move the local ticket to `closed/`. Delete the plan file.
6. Run the checkpoint on the branch.
7. Commit the branch, keeping step 0 as its own commit.
8. Squash merge to `master`, delete the branch, and push.
9. Tag and publish v6.4.0.
10. Post the closing comment on GitHub #7 and close it when the merge lands. Show the exact comment and wait for approval before posting.

Evidence for the terminal gate: validator, authoring, reference test, the new fixture, markdownlint, shellcheck, and an APPROVED implementation review.

## Peer Review Log

- Round 1: `ai/code-review-reports/2026-11-13_16-20_review-27.md`, CHANGES REQUESTED, 7 Major.
- Round 2: `ai/code-review-reports/2026-11-13_16-22_review-28.md`, APPROVED, 0 Critical, 0 Major, 2 Minor.
- Round 3: `ai/code-review-reports/2026-11-13_18-56_review-29.md`, APPROVED after the option A scope change (step 0), 0 Critical, 0 Major, 2 Minor.
