Reported: 2026-11-20
Reporter: Kamran Azeem
IssueType: Feature
Severity: P3
Size: Human-to-decide (AI estimate: XL)
Label:
URL:
Summary: Add an optional shared team knowledge store that members publish to and the boot indexes

Description:

Origin.

- A customer asked whether team members can pool their accumulated AI knowledge at a central network location.
- The proposal is a uniform way to publish local global and project knowledge to a shared store, and to use that store as another just-in-time knowledge source when it is configured.

Scope.

- Publish side: select lessons from the global and project stores, scrub them, dedupe them, and contribute them in one uniform way.
- Consumption side: index the shared store at boot, read a file only when a task needs it, and report its source and age.
- Configuration: an opt-in setting, so an unconfigured machine behaves exactly as today.

Open questions.

- Store shape: one lesson per file with frontmatter, mirrored `global/` and `projects/` trees, or flat topic files.
- Identity and ownership: who authored a lesson, who may change it, and how a retired lesson is marked.
- Contribution protocol: direct write, inbox plus curation, pull request, or a publish CLI.
- Dedupe and conflict: content hash, normalized title, provenance, or review.
- Read precedence: project, then team, then personal global, or another order.
- Security: secrets, identifying names, access groups, and encryption at rest.
- Offline behaviour: cache, queue, and a clean degrade when the store is unreachable.
- Size and count limits at boot, and whether the store obeys the knowledge file standards.

Constraints.

- No new runtime dependency at boot; the AI does the indexing with built-in tools.
- The store is optional and never blocks the load.
- The existing global and project stores keep their meaning; the shared store is a third scope with its own precedence.

Full brainstorm, 2026-11-20.

Transport.

- Internal Git repo, one per team or one per company.
- NFS mount, read-only for consumers.
- SMB or Windows file share.
- Synced folder: OneDrive, Nextcloud, or Syncthing.
- Object storage plus a small CLI.
- Read-only mirror served by an MCP or search service.
- Existing wiki or Confluence as the source of truth, exported to markdown.

Store shape.

- Mirror the current model: `global/` plus `projects/<name>/`.
- Flat topic files, six-segment names, no folders.
- Domain folders with an index per domain.
- Inbox plus curated area, two zones.
- One lesson per file with frontmatter: id, owner, source, date, tags, confidence.
- Manifest with checksums and a generated index.
- Markdown only, attachments by link.

Contribution.

- A `knowledge publish` procedure: classify, scrub, dedupe, contribute.
- Pull request with a checklist and one reviewer.
- A small CLI that validates frontmatter and opens a pull request.
- Copy into a synced inbox, curation later.
- Auto-export new local lessons at checkpoint, queued for review.
- Branch per contributor, squash on approval.
- Direct write with a lock file, for a small trusted team.

Consumption.

- One config key in `ai-customization.md` naming the store path or URL.
- Clone or mount under a configured path, read-only.
- Boot builds a JIT index from filenames and headers only.
- Search on demand with the built-in search, load one file at a time.
- Precedence: project, then team, then personal global.
- Tag filter so only relevant domains are indexed.
- Staleness flag by commit date, as the current knowledge layers do.
- Graceful degrade when the store is unreachable.

Governance.

- Scrub secrets and identifying names before publish.
- Provenance: author, source project, date, supersession link.
- Content-hash and normalized-title dedupe at publish.
- Owner per lesson, retire with a tombstone, never delete silently.
- Access groups per team, read-only for most consumers.
- Retention and license review for exported material.

Shortlist.

- Git-backed team repo with a `knowledge publish` procedure: review, history, provenance, and conflict handling with no new service. The clone is read-only at boot.
- Network share with inbox and curated zones: no Git skill needed, weakest conflict handling, best for mixed teams.
- Synced folder with a strict layout and manifest: simplest across operating systems, sync conflicts are the risk.
- Read-only mirror plus MCP or search service: scales to a large organization, heaviest to build and operate.

What shapes the choice.

- Whether the team already uses Git.
- Whether contribution needs review before it is visible.
- Whether the store must work offline.
- Who owns a shared lesson after the author leaves.
- Whether project names may appear in shared lessons.

Recommended first shape.

- The Git-backed repository, because it gives review, provenance, history, and conflict handling with no new service.
- Use the network-share variant when the team does not use Git.

Next step.

- Grill the open questions, then write a plan.

---

2026-11-20

Recorded the full brainstorm set from the design discussion, including all transport, shape, contribution, consumption, and governance options. No decisions are final; the open questions and a grilling round come next.
