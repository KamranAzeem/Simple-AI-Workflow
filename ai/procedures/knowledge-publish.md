# PROCEDURE KNOWLEDGE-PUBLISH: Publish a lesson to the team knowledge store

## Triggers

- update team knowledge
- publish team knowledge
- publish to team knowledge

1. **STEP-LOAD-TEAM-POLICY**: Load `ai-policy-team-knowledge.md` and report it active. When **Team AI Knowledge Directory** is absent, report that the team store is not configured and stop.
2. **STEP-RESOLVE-PUBLISH-SCOPE**: Read the lesson name or names; default to the session's lesson.
3. **STEP-CLASSIFY-AND-SCRUB**: Load `ai-policy-outbound-content-scrub.md` and apply `### Destination Classes`; state Class A; remove secrets; keep names; do not apply the local sensitive-names list.
4. **STEP-DEDUPE**: Normalize the body, compute the SHA-256 hash, compare hashes, then compare normalized titles.
5. **STEP-WRITE-LESSON**: Write the frontmatter and body under `team-knowledge/` in the configured **Team AI Knowledge Directory** on a new branch.
6. **STEP-OPEN-PR**: Push the branch to **Team AI Knowledge Repository**, or the clone's `origin` when the key is absent, and open a PR with `gh` or `glab`, or give the compare URL; never merge.
7. **STEP-REPORT-PUBLISH**: Report the lesson path, the branch, the PR, and the duplicate result.
