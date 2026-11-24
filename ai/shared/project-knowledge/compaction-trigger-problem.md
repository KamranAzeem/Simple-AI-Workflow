> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Reliable Post-Compaction Recovery

## Context

Long AI sessions fill the context window. Most assistants then compact the conversation and replace the history with a summary. Standing rules loaded from files at session start are no longer in context.

## Rule or Fix

- The user runs Post-Compaction Recovery manually after a summary, before the next task.
- The user types `run post-compaction recovery procedure`; no harness hook fires it today.
- Treat a PreCompact warning as a reminder to run the phrase, never as the recovery itself.
- Ask the user to run the recovery when the first reply after a summary lacks the reload line.
- Do not claim the reload runs automatically.
- Use this PreCompact warning shape where the harness supports it:

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

### Kilo Code

- Kilo Code keeps `AGENTS.md` always-on.
- The compaction summary is visible in chat.
- The recovery is still manual; after a summary, ask the AI to run post-compaction recovery.
- The human step is the only reliable path today; no slash command or new file is needed.

## Why

- A post-compaction hook would have to run after the summary and inject instructions into the next turn, and no current harness exposes one that works that way.
- PreCompact fires before the summary and cannot inject `additionalContext` into the first post-compaction turn.
- Detection is ambiguous because a summary looks like ordinary resume context.
- A text instruction is declarative and competes with the user request.
- An always-on instruction can be acknowledged and skipped.
- Two silent skips were observed with `AGENTS.md` and user memory present.
- A mechanical warning reaches the user without model compliance, but it is still only a reminder to run the phrase.

## Verify

- Confirm the first reply after a compaction starts with `[Reloading key files into context...]` when the user runs the procedure.
- Confirm the rules, policies, and knowledge index are present after the reload.
- Confirm the user knows to run the phrase when a summary appears.

## Caveats

- Session-start compaction fires no PreCompact event.
- VS Code has no PostCompact hook.
- The manual run remains the mechanism.
