# Full-History Sensitive-Data Purge Plan

**Owner**: Kamran Azeem
**Created**: 2026-09-21
**Status**: Proposed, pending peer review

## Objective

Remove every sensitive identifier and any credential from the entire git history of this repository, keep all legitimate work, recreate all tags, and republish. The literal identifiers are deliberately not repeated here. They live in the user's global settings file (`~/.ai/settings/global-user-settings.md`, section "Sensitive Names To Never Commit") and in the external replacements file at `/tmp/kilo/purge-replacements.txt`.

## Evidence (read-only scans, 2026-09-21)

- **Credentials**: zero hits across all blobs for private keys, cloud access keys, tokens, JWTs, connection strings, and password assignments. `ai/secrets/` was never committed.
- **Placement**: sensitive identifiers appear only in markdown prose. None in filenames, scripts, config, policy files, or `AGENTS.md`.
- **At HEAD (working tree)**, 4 files still carry them:
  - `ai/daily-checkpoints/2026-08-25.md`
  - `ai/daily-checkpoints/2026-09-09.md`
  - `ai/issues/closed/checkpoint-procedure-never-writes-daily-checkpoint-file.md`
  - `ai/issues/closed/proof-of-load-report-should-index-issues-directory.md`
- **Across all history**: 9 commits introduce identifiers; 3 tags point at commits containing them (`v2.0.0`, `v2.2.0`, `v2.3.0`); 2 commit messages carry them (`91b0396` subject, `cddc87d` body); 92 commit identities use a company-domain email; 2 use an older personal domain.
- **Blast radius**: first affected commit is `888bdf6` (2026-06-22). Rewriting from there changes 90 commits (89 on `master`, 1 on `docs/readme-overhaul`). `v1.0.0` predates it and is content-clean.

## Scope

- Rewrite all history reachable from `master`, `docs/readme-overhaul`, and all tags.
- Replace identifiers in blobs with `--replace-text`, and in commit messages with `--replace-message`.
- Normalize author and committer emails with `--mailmap`.
- Recreate all 5 tags (`v1.0.0` through `v2.3.0`) on the rewritten commits, preserving their messages.

## Accepted losses and side effects

- Every commit hash from `888bdf6` forward changes (90 commits).
- 32 tracked files record short commit hashes; those references become stale. Not repaired (provenance text only).
- Tag hashes change; tags are recreated on the new commits.
- 92 commits get the gmail author/committer identity.
- GitHub may serve old objects by SHA for a while after the force-push.
- Existing clones must re-clone or run `git fetch && git reset --hard origin/master`; a notice is added to the README.

## Preconditions

1. Working tree clean of uncommitted tracked changes (commit the protocol-decisions cleanup first).
2. A mirror backup and a bundle exist under `/tmp/kilo/`.
3. The applied stash is dropped (its content is already committed and verified on the branch).
4. `git filter-repo` is installed.

## Procedure

1. **Safety net**
   - `git clone --mirror . /tmp/kilo/SWF-mirror-<ts>.git`
   - `git bundle create /tmp/kilo/SWF-<ts>.bundle --all`
   - Save tag messages: `git for-each-ref refs/tags --format='%(refname:short) %(contents)' > /tmp/kilo/tag-messages.txt`
   - Drop the applied stash: `git stash drop`
2. **Pre-purge commits**
   - Commit the protocol-decisions cleanup on `docs/readme-overhaul`.
   - Add a short migration notice near the top of `README.md` on `master` ("This repository's history was rewritten on 2026-09-21; existing clones must run `git fetch && git reset --hard origin/master`.") and commit on `master`.
3. **Replacement inputs (outside the repo)**
   - `/tmp/kilo/purge-replacements.txt`: one `regex:`/literal rule per identifier, all mapping to `[redacted]`. Includes word-boundary regexes for person names, the company name, the client project name, client ticket prefixes with and without numbers, and client infrastructure identifiers. Word boundaries prevent false positives where a short identifier appears inside an ordinary English word.
   - `/tmp/kilo/mailmap.txt`: maps the company-domain and older personal-domain emails to `kamranazeem@gmail.com`.
4. **Install tool**
   - `pip install --user git-filter-repo` (fallback `--break-system-packages`).
5. **Run the purge**
   - `git filter-repo --force --replace-text /tmp/kilo/purge-replacements.txt --replace-message /tmp/kilo/purge-replacements.txt --mailmap /tmp/kilo/mailmap.txt`
   - filter-repo rewrites all refs, repacks, and prunes old objects. It also drops the `origin` remote.
6. **Recreate tags**
   - Inspect tags after the run. Use `.git/filter-repo/commit-map` to move each tag onto its rewritten commit and recreate annotated tags with the saved messages.
7. **Verify (nothing lost)**
   - `git log --all -G'<pattern set>'` returns nothing.
   - `git grep -inE '...'` across every ref returns nothing.
   - Commit count is preserved (no commits lost or added beyond the two pre-purge commits): `git rev-list --count master` equals 219 plus Step 2 commits; `docs/readme-overhaul` has exactly one more commit than `master`; `git tag | wc -l` equals 5.
   - Tree comparison against the mirror backup shows only the expected redactions, and no file is added or removed.
   - `support-files/validate-protocol.sh` passes 8/8; markdownlint reports 0 issues.
8. **Clean global knowledge (outside git)**
   - Genericize client and ticket identifiers in `~/.ai/global-knowledge/engineering-lessons-and-conventions.md`, keeping the engineering lessons intact. Confirm no identifiers remain in `~/.ai/` except the intentional list in the global settings file.
9. **Publish**
   - `git remote add origin <url>` (filter-repo removes it).
   - `git push --force-with-lease origin master`
   - `git push --force origin refs/tags/v1.0.0 refs/tags/v2.0.0 refs/tags/v2.1.0 refs/tags/v2.2.0 refs/tags/v2.3.0`
   - Leave `docs/readme-overhaul` local (it is not on origin).

## Rollback

Restore from `/tmp/kilo/SWF-mirror-<ts>.git` (re-clone, or reset refs to the saved SHAs). The bundle is a second restore path.

## Out of scope

- Untracked `ai/artifacts/` contains client names but is not committed. Left on disk; recommend deleting or moving it out of the repository.
- The global knowledge file is cleaned separately, outside git.
- Credential rotation is not needed; no credentials were found.
