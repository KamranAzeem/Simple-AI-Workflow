Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Defect/Bugfix
Severity: P2
Size: M
URL:
Summary: Sync script breaks a symlinked ai-customization.md, renaming the real file to .bak and leaving a dangling link

Description:

Some users keep their `ai/` directory as a git repo and want `ai-customization.md` versioned with it. They store the real file inside `ai/` and create a symlink named `ai-customization.md` at the project root pointing to it.

When the sync script runs, it sees the legacy layout (a file inside `ai/` plus a root `ai-customization.md`) and mis-handles it:
1. It renames the real file inside `ai/` to `ai-customization.md.bak`.
2. Its copy step targets the root path, which is now a dangling symlink, so the write goes nowhere.
3. The next load context finds no readable customization file and fails to load customization.

The script must detect a symlink at the root path and treat the target correctly, or leave a symlink that points at the real file untouched.

Acceptance criteria:
- A root `ai-customization.md` that is a symlink to a real file is recognized and not broken.
- The real file is not renamed to .bak in this case.
- If migration is genuinely needed, the symlink target is updated, not replaced by a copy.
- Behavior on a normal (non-symlink) root file is unchanged.
- Verified with a test that creates the symlink layout in a temp directory.

---
2026-09-19
Implemented on branch `fix/sync-script-symlinked-customization-file`.
- Bash: added a symlink guard in `ensure_customization_file` so a root `ai-customization.md` that is a symlink to `ai/ai-customization.md` is edited in place, and a `replace_file` helper so a symlinked root is never replaced by a regular file. A genuine old-plus-root conflict (regular file) still renames the old file to `.bak`.
- PowerShell: same guard using ReparsePoint detection and the skip-the-rename branch. Not executed locally (no `pwsh`); verified by reading.
- Test: `support-files/test-sync-agents-md.sh` builds temp projects for the symlink layout, a normal regular root, the legacy move, and the genuine conflict. All checks pass.
- Validator v5.0 8/8. Peer review review-14 APPROVED. Merged to master on 2026-09-19. Ticket closed.
