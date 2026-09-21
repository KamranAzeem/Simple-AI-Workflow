<!-- Save this file as $HOME/.ai/settings/global-user-settings.md, then replace the placeholders with your own details. The AI loads this file at the start of every session, so keep it short and current. -->

# Global User Settings

## Identity
- Name/Handle: `<your name or handle>`
- Personal Email: `<you@example.com>`
- Role/Focus: `<what you do, in one line>`
- Base: `<your city, country>`
- Primary Languages (human): `<your languages>`
- SSH Public keys: `<URL to your public keys, or leave blank>`
- Certifications: `<your certifications, or leave blank>`
- Computer OS and Environment: `<your OS and version>`

## Technical Expertise
- Expert In: `<the skills you want the AI to treat as your strongest>`
- Familiar With: `<skills you know but are not expert in>`
- Learning/New To: `<skills you are learning now>`

## Preferences and Style

### Communication Style
- Direct, low-fluff, concise first. Depth on request.
- Use "I", not "we" or "us", for client or customer communications.
- Write directly to the recipient: "you" and "your". Never refer to the client in third person.
- In Jira, Teams, Slack, and similar tools, use plain paragraphs, headings, bullets, and code blocks. No tables.
- No decorative symbols (ticks, arrows, emoji). Use `[PASSED]`, `[FAILED]`, `[PENDING]`, and similar.
- Keep a natural, human, conversational tone. Avoid robotic, AI, or over-formal phrasing.
- Don't use jargon. Use simple English.
- Default to conversational writing, not report style: short sentences, one idea at a time, lead with the point. Cut hedging and passive voice. Switch to formal report style only when asked.
- Ticket files are customer-facing status updates (decisions, outcomes, blockers), not a technical diary of commands, errors, and fixes. Those belong in project knowledge or this file.

### Preferred shell and tools
- `<your terminal, shell, and preferred CLI tools>`

## Words and Phrases to Avoid
Personal word-choice preferences. Add new entries as they come up.

- "folded" → use "included" or similar (e.g. don't write "will be folded into the commit").
- "captured" → use a simpler word depending on context (e.g. "noted", "recorded", "written down").
- "parity" → use "compatible/compatibility", "similar/similarity", or "match/matching" instead.
- "inertia" → use "leftover", "old", or "outdated" (e.g. "may be an old rule" not "may be stale inertia").
- "guidance" → use "note", "instruction", "direction", or "comment" depending on context.
- "spin up" → use "set up", "start", or "create" instead.
- "sentinel" → use "marker", "flag", or "signal" depending on context.
- "coalesce" → use "fall back to", "default to", or "merge" depending on context (e.g. "lets the default kick in" not "lets the null-coalesce kick in").

## Git Conventions
- Branch prefix and commit type: use `feature` (never `feat`).
- Format: `<type>(<scope>): <subject>`, imperative mood subject.
- Include a descriptive body for architectural or complex changes.
- Always use feature branches and squash-merge into master.

## CLI Tools

These tools help the AI work faster. Install the ones that apply to your OS, using your package manager or the tool's own installer. Paths differ by OS and package manager, so this list starts with names only. Once you install a tool, replace "not installed" with its full path so the AI can call it directly. The AI should prefer these tools over the standard utilities (for example `fd` over `find`, and `rg` over `grep`), and fall back to the standard utility when a preferred tool is missing, noting the fallback.

### Essentials for everyone
- `rg` (ripgrep) - not installed
- `fd` - not installed
- `fzf` - not installed
- `bat` - not installed
- `tree` - not installed
- `jq` - not installed
- `yq` - not installed
- `ncdu` - not installed
- `python` - not installed
- `pip` - not installed

### Software developers
- `gh` (GitHub CLI) - not installed
- `glab` (GitLab CLI) - not installed
- `markdownlint-cli2` - not installed

### Cloud and infrastructure practitioners
- `gcloud` - not installed
- `az` (Azure CLI) - not installed
- `kubectl` - not installed
- `terraform` - not installed
- `k9s` - not installed

### Database practitioners
- `psql` - not installed

## Operating Instructions
- Don't recreate SSH keys.
- Don't overwrite existing SSH keys.
- If a remote server or infrastructure component needs a public SSH key, use an existing key from your home directory. Preferred keys: `id_ed25519.pub` and `id_rsa.pub`.

## Git Configuration

```ini
[user]
    name = <your name>
    email = <the email you want on your commits>
[core]
    # Linux/macOS: input. Windows: true.
    autocrlf = input
    eol = lf
    whitespace = cr-at-eol
[init]
    defaultBranch = master
[alias]
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

```bash
git config --global user.name "<your name>"
git config --global user.email "<your email>"
git config --global core.autocrlf input   # true on Windows
git config --global core.eol lf
git config --global core.whitespace cr-at-eol
git config --global init.defaultBranch master
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
