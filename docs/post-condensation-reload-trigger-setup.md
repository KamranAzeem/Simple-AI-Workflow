# Post-Condensation Reload Trigger: Setup for Any AI Assistant

## What this is

When a long chat session gets automatically summarized (a "condensation" or
"compaction"), your AI assistant continues from a short summary instead of the
full history. The problem: the summary can drop the standing rules, policies,
and project knowledge the assistant had loaded. It then keeps working with a
thinner context and can quietly break your conventions.

The Simple-AI-Workflow protocol has a recovery routine for exactly this: the
**Post-Condensation Recovery** procedure in `AGENTS.md`. It reloads the standing
rules from disk before the assistant does anything else.

## Why a small external note is needed (the necessary evil)

`AGENTS.md` is the thing that gets dropped during condensation, so it cannot
reliably tell the assistant to reload itself. The instruction to re-arm the
recovery has to live somewhere the assistant re-reads on **every** turn: its
own persistent memory or always-on custom instructions.

That layer is different for every assistant, and it lives outside every git
repository, in your personal settings. Keeping one tiny note there is a
deliberate, accepted trade-off. It is not part of the tool-agnostic protocol on
purpose. The realistic goal is **high reliability with a loud, visible signal
and your own quick check**, not a hard guarantee that a reload can never be
missed.

## The generic trigger (same text for everyone)

Paste this into your assistant's persistent-memory or always-on-instructions
layer (see the per-assistant locations below). Do not change the wording much;
it is deliberately assistant-agnostic.

```
When a conversation opens with an automatically generated summary of an earlier
session (a "condensation" or "compaction" that you did not write, the tool did),
treat that as a signal BEFORE you respond:

1. Do not act on the user's first request yet.
2. Reload the project's standing rules from disk: read the AGENTS.md file at the
   project root and run its "Post-Condensation Recovery" procedure, the one that
   reloads policies, knowledge, and settings and re-reads AGENTS.md.
3. Announce that you have done this as the first line of your reply, then continue.

This applies ONLY in projects that use the Simple-AI-Workflow protocol (an
AGENTS.md file exists at the project root). Ignore it everywhere else.
Identify the procedure by its title "Post-Condensation Recovery", never by a
letter or number. Those can change.
```

## Where to put it, per assistant

The idea is always the same: find the layer your assistant applies to *every*
conversation, and drop the trigger there. Exact names and paths change over
time. When in doubt, search your assistant's docs for "memory", "custom
instructions", "rules", or "system prompt".

| Assistant | Where the always-on layer lives |
|---|---|
| **GitHub Copilot** (VS Code) | User memory, auto-loaded every chat. Managed via the memory feature; on disk at `%APPDATA%\Code\User\globalStorage\github.copilot-chat\memory-tool\memories\`. A project-scoped alternative is `.github/copilot-instructions.md`, but user memory is better for a cross-project rule. |
| **Claude** (Claude Code) | Global user memory file `~/.claude/CLAUDE.md` (loaded in every session). A project `./CLAUDE.md` also works but is per-repo. |
| **Claude** (claude.ai web/desktop) | Settings → Profile → personal preferences / custom instructions, or a Project's custom instructions. |
| **ChatGPT** | Settings → Personalization → Custom Instructions (and Memory). Paste the trigger into custom instructions. |
| **KiloCode** | Global custom instructions in Settings, or a rules file under `.kilocode/rules/` in the workspace. |
| **Kimi** (Moonshot) | The assistant's custom instructions / system-prompt setting. |
| **Gemini CLI / Code Assist** | Global `~/.gemini/GEMINI.md`, or a project `GEMINI.md`. |
| **AntiGravity** (Google) | Its Rules / Memories panel. |
| **Any other assistant** | Any "custom instructions", "system prompt", "rules", or "memory" feature that is applied to every conversation. |

Keep the note short. If your assistant limits how much always-on text it keeps,
this trigger is high value per line, so give it priority.

## The human backstop (do not skip this)

No text-only setup makes a missed reload impossible. The most reliable check is
simple and takes five seconds: **after you notice a session has been
summarized, ask your assistant "did you run the post-condensation reload?"**
before you trust its next answer. This is what has caught misses in practice.
Treat it as the final safety net, not an admission of failure.
