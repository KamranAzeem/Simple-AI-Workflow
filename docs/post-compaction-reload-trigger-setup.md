# Post-Compaction Reload Trigger: Setup for Any AI Assistant

## What this is

When a long chat session gets automatically summarized (a "compaction", also
called "condensation"), your AI assistant continues from a short summary instead
of the full history. The problem: the summary can drop the standing rules,
policies, and project knowledge the assistant had loaded. It then keeps working
with a thinner context and can quietly break your conventions.

The Simple-AI-Workflow protocol has a recovery routine for exactly this: the
**Post-Compaction Recovery** procedure in `AGENTS.md`. It reloads the standing
rules from disk, and it only adds those files to context, so it never wipes the
working conversation.

## Why a small external note is needed (the necessary evil)

`AGENTS.md` is the thing that gets dropped during a compaction, so it cannot
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
Applies only in projects that use the Simple-AI-Workflow protocol (an AGENTS.md
file exists at the project root). Ignore everywhere else.

Signal - the conversation was compacted. Concretely, ANY of:
- the label "Compacted conversation" appears in the transcript, or
- the session opens with a machine-generated summary you did not write, or
- the user explicitly asks you to run post-compaction recovery.

On the signal:
1. Do not act on the user's first request yet.
2. Read the AGENTS.md file at the project root and run its "Post-Compaction
   Recovery" procedure - it re-reads config, settings, global knowledge, and
   policies, and indexes the shared directory, without reading the three AI
   state files.
3. Make "[Reloading key files into context...]" the literal first line of your
   reply, then continue.

This reload only ADDS rule and config files; it never wipes the working
conversation, so it is safe to run even when unsure. Identify the procedure by
its title "Post-Compaction Recovery", never by a letter or number - those change.
```

## Where to put it, per assistant

The idea is always the same: find the layer your assistant applies to *every*
conversation, and drop the trigger there. Exact names and paths change over
time. When in doubt, search your assistant's docs for "memory", "custom
instructions", "rules", or "system prompt".

| Assistant | Where the always-on layer lives |
|---|---|
| **GitHub Copilot** (VS Code) | A `PreCompact` hook at `~/.copilot/hooks/` fires before every mid-session compaction and shows a warning in the chat — no text-instruction compliance needed. See the hooks section below. For other assistants or for the session-start case, user memory also works: `%APPDATA%\Code\User\globalStorage\github.copilot-chat\memory-tool\memories\`. |
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

## GitHub Copilot (VS Code): hooks layer

VS Code exposes a `PreCompact` hook that fires before every context compaction.
This is stronger than a text-instruction trigger because it does not depend on
the AI noticing the signal. Create this file once in your user home directory
(outside any project) and it applies to all your workspaces:

`~/.copilot/hooks/compaction-recovery.json`

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "command",
        "command": "bash -c \"printf '{\\\"systemMessage\\\": \\\"Context compaction is starting. When it completes, ask the AI to run Post-Compaction Recovery before resuming work.\\\"}'\"",
        "windows": "powershell -NoProfile -Command \"Write-Output '{\\\"systemMessage\\\": \\\"Context compaction is starting. When it completes, ask the AI to run Post-Compaction Recovery before resuming work.\\\"}'\""
      }
    ]
  }
}
```

When compaction starts, VS Code displays the message in the chat so you know to
prompt the AI for the recovery when the compaction finishes.

Note: there is currently no PostCompact hook in VS Code. The PreCompact warning
is the closest available mechanism; the human backstop below covers the gap.

## The human backstop (do not skip this)

No text-only setup makes a missed reload impossible. The most reliable check is
simple and takes five seconds: **after you notice a session has been
summarized, ask your assistant "did you run the post-compaction reload?"**
before you trust its next answer. This is what has caught misses in practice.
Treat it as the final safety net, not an admission of failure.
