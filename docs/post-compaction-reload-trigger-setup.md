# Post-Compaction Reload: Manual Setup and Reminders for Any AI Assistant

## What this is

When a long chat session gets automatically summarized (a "compaction", also
called "condensation"), your AI assistant continues from a short summary instead
of the full history. The summary can drop the standing rules, policies, and
project knowledge the assistant had loaded. It then keeps working with a thinner
context and can quietly break your conventions.

The Simple-AI-Workflow protocol has a recovery routine for exactly this: the
**Post-Compaction Recovery** procedure in the clone's `ai/procedures/` store. It
reloads the standing rules from disk, and it only adds those files to context, so
it never wipes the working conversation.

## The procedure is manual

**Post-Compaction Recovery does not run automatically.** No harness currently
provides a reliable hook that fires after compaction and re-injects the protocol.
The hooks available today fire before the summary and cannot inject context into
the next turn.

So you run it. After you notice a compaction, type:

> *"run post-compaction recovery procedure"*

The procedure announces itself with `[Reloading key files into context...]` as
the first line of the reply. If you see a summary and that line is missing, the
procedure did not run: type the phrase again.

## Why there is no automatic trigger

- A post-compaction hook would have to run after the summary and inject
  instructions into the next turn. Current harnesses do not expose one that
  works this way.
- A pre-compaction hook only warns you before the summary. It cannot re-inject
  the rules into the next turn.
- A text instruction in the assistant's own memory can be acknowledged and
  skipped, and has been skipped in practice.
- The protocol is tool-agnostic. It cannot depend on a hook that does not exist.

## Optional reminders, per assistant

A reminder only tells the assistant to prompt you to run the phrase. It does not
make the recovery automatic. Paste the text below only if you want that prompt.

```text
Applies only in projects that use the Simple-AI-Workflow protocol (an AGENTS.md
file exists at the project root). Ignore everywhere else.

Signal: the conversation was compacted. Concretely, ANY of:
- the label "Compacted conversation" appears in the transcript, or
- the session opens with a machine-generated summary you did not write.

On the signal:
1. Tell the user in one line that the context was compacted and the standing
   rules need a reload.
2. Ask the user to run "run post-compaction recovery procedure" before you
   continue.
3. Do not claim the reload runs automatically; no harness hook fires it.
```

## Where a reminder can live, per assistant

The idea is always the same: find the layer your assistant applies to *every*
conversation, and put the reminder there. Exact names and paths change over
time. When in doubt, search your assistant's docs for "memory", "custom
instructions", "rules", or "system prompt".

| Assistant | Where the always-on layer lives |
|---|---|
| **GitHub Copilot** (VS Code) | A `PreCompact` hook at `~/.copilot/hooks/` fires before every mid-session compaction and shows a warning in the chat. It cannot run the recovery for you; you still type the phrase. See the warning-hook section below. User memory can also hold the reminder for the session-start case, though it does not guarantee the reload. The memory path is `%APPDATA%\Code\User\globalStorage\github.copilot-chat\memory-tool\memories\`. |
| **Claude** (Claude Code) | Global user memory file `~/.claude/CLAUDE.md` (loaded in every session). A project `./CLAUDE.md` also works but is per-repo. |
| **Claude** (claude.ai web/desktop) | Settings → Profile → personal preferences / custom instructions, or a Project's custom instructions. |
| **ChatGPT** | Settings → Personalization → Custom Instructions (and Memory). Paste the reminder into custom instructions. |
| **KiloCode** | AGENTS.md is always-on, and the compaction summary is visible in chat. The recovery still needs you: after a summary, ask the AI to run Post-Compaction Recovery. No slash command and no new files are needed. |
| **Kimi** (Moonshot) | The assistant's custom instructions / system-prompt setting. |
| **Gemini CLI / Code Assist** | Global `~/.gemini/GEMINI.md`, or a project `GEMINI.md`. |
| **AntiGravity** (Google) | Its Rules / Memories panel. |
| **Any other assistant** | Any "custom instructions", "system prompt", "rules", or "memory" feature that is applied to every conversation. |

Keep the note short. If your assistant limits how much always-on text it keeps,
this reminder is high value per line, so give it priority.

### Kilo Code

Kilo Code keeps `AGENTS.md` always-on, so the protocol is present without a
separate reminder. The compaction summary is visible in chat. The recovery is
still manual: after a summary, ask the AI to run post-compaction recovery. The
human step is the only reliable path today.

## GitHub Copilot (VS Code): warning hook

VS Code exposes a `PreCompact` hook that fires before every context compaction.
It is a useful warning. It does not depend on the AI noticing the signal, and
it cannot inject the reloaded rules into the next turn. Create this file once in
your user home directory (outside any project) and it applies to all your
workspaces:

`~/.copilot/hooks/compaction-recovery.json`

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "command",
        "command": "bash -c \"printf '{\\\"systemMessage\\\": \\\"Context compaction is starting. When it completes, run post-compaction recovery before resuming work.\\\"}'\"",
        "windows": "powershell -NoProfile -Command \"Write-Output '{\\\"systemMessage\\\": \\\"Context compaction is starting. When it completes, run post-compaction recovery before resuming work.\\\"}'\""
      }
    ]
  }
}
```

When compaction starts, VS Code displays the message in the chat so you know to
run the recovery when the compaction finishes.

Note: there is currently no PostCompact hook in VS Code. The PreCompact warning
is the closest available mechanism; the human step below covers the gap.

## The human step (do not skip this)

No text-only setup makes a missed reload impossible, and no current harness
fires the recovery for you. The most reliable check is simple and takes five
seconds: **after you notice a session has been summarized, type "run
post-compaction recovery procedure"** before you trust the next answer. The first
reply should start with `[Reloading key files into context...]`.

Treat the manual phrase as the mechanism.
