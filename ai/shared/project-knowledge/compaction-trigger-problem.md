> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.

# Reliable Post-Compaction Recovery

## Context

Long AI sessions fill the context window. Most assistants then compact the conversation and replace the history with a summary. Standing rules loaded from files at session start are no longer in context.

## Rule or Fix

- Notice the compaction summary and run Post-Compaction Recovery before the next task.
- Show the user a PreCompact warning on VS Code and Copilot.
- Place the hook file in `~/.copilot/hooks/*.json`.
- Ask the user to run the recovery when the first reply lacks the reload line.
- Prefer a PostCompact or SessionResume hook that injects context into the next turn.
- Use this PreCompact hook shape where the harness supports it:

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

## Why

- Detection is ambiguous because a summary looks like ordinary resume context.
- A text instruction is declarative and competes with the user request.
- An always-on instruction can be acknowledged and skipped.
- Two silent skips were observed with `AGENTS.md` and user memory present.
- A mechanical warning reaches the user without model compliance.

## Verify

- Confirm the first reply after a compaction starts with `[Reloading key files into context...]`.
- Confirm the rules, policies, and knowledge index are present after the reload.
- Confirm the user prompt is available when the reload does not fire.

## Caveats

- PreCompact fires before the summary and cannot inject `additionalContext` into the first post-compaction turn.
- A PostCompact or SessionResume hook could inject `additionalContext` or a `systemMessage` into that turn.
- Session-start compaction fires no PreCompact event.
- VS Code has no PostCompact hook.
- The human prompt remains the backstop.
