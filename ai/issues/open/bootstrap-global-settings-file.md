Reported: 2026-09-20
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Feature
Severity: P3
Size: L
URL:
Summary: Bootstrap should create ~/.ai/ and a starter global user settings file

Description:

The bootstrap process should create `~/.ai/` and its directories, and write a basic `~/.ai/settings/global-user-settings.md` the user can then edit.

Content the AI should seed, based on the chosen customization (expertise and traits) and the OS:
- A list of tools the AI can use to work more efficiently.
- Tools that are not installed are listed in a disabled state, with an offer to install them.
- Tools that need admin access are installed by the user, not the AI.
- Words to avoid.
- A writing style.

The user will provide example global-settings files for Windows and Linux to base this on.

Acceptance criteria:
- Bootstrap creates `~/.ai/`, the settings directory, and a starter global-settings file.
- The seeded content reflects the chosen expertise and traits and the detected OS.
- Missing tools appear disabled with an install offer, and admin-only tools are left to the user.
- The file includes a writing style and words to avoid.
