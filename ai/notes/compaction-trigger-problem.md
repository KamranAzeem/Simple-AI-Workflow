# Problem: Reliable post-compaction recovery in AI-assisted workflows

## What the problem is

Long AI coding sessions eventually fill the context window. When that happens, most AI assistants (Claude, GPT-4o, Gemini, GitHub Copilot/VS Code) automatically compact the conversation — they replace the full history with a compressed summary. The AI continues from there.

Many structured AI workflows load standing rules from files at the start of each session: policies, project conventions, role definitions. After compaction those files are no longer in context. The AI needs to re-read them before continuing. If it does not, it will work from an incomplete or wrong understanding of the rules.

## Why text instructions alone do not solve it

The obvious fix is to write a text instruction in an always-on location (user memory, system prompt, project instructions file) that says something like: "if you detect a compaction summary, run the reload procedure before responding."

This fails reliably in practice because:

1. **Detection is ambiguous.** A compaction summary looks like ordinary resume context to the AI. There is no guaranteed structural marker the AI can use to distinguish it from a normal session opening.
2. **Text instructions are declarative, not imperative.** The model generates its response holistically. "Run the reload procedure first" competes with "answer the user's request" and loses, especially when the first message is a direct task.
3. **Always-on context does not help here.** Even if the instruction is in the highest-priority always-on file, the AI may acknowledge it and still skip the reload and go straight to work.

Both failure modes have been observed in practice with AGENTS.md in context and user memory containing an explicit trigger — the reload was skipped silently on two separate occasions.

## How VS Code/Copilot partially addresses it

VS Code exposes a hook system at `~/.copilot/hooks/*.json`. One of the hooks is `PreCompact`, which fires before context compaction begins.

A hook file configured like this displays a warning in the chat before every compaction:

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

The user sees the message at the right moment, and after compaction finishes knows to explicitly prompt the AI for the reload. This is stronger than a text-only instruction because it does not require the AI to notice anything — the warning reaches the user mechanically.

## The remaining gap

`PreCompact` fires before the summary is generated. At that moment the AI has no opportunity to inject anything into the first post-compaction turn. So:

- **Mid-session automatic compaction**: The user gets the PreCompact warning, but the AI's first response after compaction still depends on the user remembering to ask.
- **Session-start compaction** (a prior session was compacted and the new session opens with the summary): No PreCompact fires at all. The hook only fires during a live session.

There is currently no `PostCompact` hook in VS Code. That hook would fire after the compaction summary is injected into context and could add `additionalContext` or a `systemMessage` directly into the model's first post-compaction turn — solving the gap without any human action.

## What would actually solve it

A `PostCompact` (or `AfterCompaction` or `SessionResume`) hook that:

1. Fires after the compaction summary is placed into context, before the model generates its next response.
2. Can inject text directly into the model's context for that turn (`additionalContext`) — not just a chat message to the user.
3. Does not depend on text-instruction compliance.

## Question for other AI tools and assistants

Does your tooling (CLI, IDE extension, desktop app, API) expose a hook or lifecycle event that:

- Fires **before** context compaction or summarization? If yes, what is it called and where is it configured?
- Fires **after** compaction and can inject instructions or additional context into the model's **next response** (not just display a message to the user)?
- Provides a **SessionStart** event that distinguishes a fresh session from a compaction-resume, and can inject context accordingly?

If any of these exist, what is the mechanism called, how is it configured, and does it support injecting into the model context (not just showing a UI message)?
