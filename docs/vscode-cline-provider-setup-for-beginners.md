<!--
Created-by: GitHub Copilot
Updated-by: GitHub Copilot
Last modified: 2026-04-27T12:20:00+02:00
Intent: Provide a layman-friendly step-by-step guide to install VS Code, install Cline, configure API keys for popular AI providers, and set up the right-side AI chat layout.
-->
---
# Beginner Guide: VS Code + Cline + API Key Setup

## 1-Minute Setup Checklist

If you want the short version, do this:

1. Install VS Code.
2. Install the `Cline` extension.
3. Open Cline and choose your provider.
4. Paste your API key.
5. Choose a model.
6. Open the AI chat view and move it to the right side.
7. Send a test prompt.

Expected layout:

`[File browser] [Code editor] [AI chat]`

Need help choosing a provider first? See `docs/ai-provider-selection-guide.md`.

This guide is for non-technical users who want to:

1. Install VS Code
2. Install the Cline extension
3. Open and place the AI chat window on the right side
4. Add an API key from a popular AI provider
5. Avoid common provider naming confusion (for example, ChatGPT key vs OpenAI in Cline)

Examples of assistants people commonly ask about: Cline, ChatGPT, Claude, Gemini, and GitHub Copilot.

## Before You Start

- You need a paid API account with at least one provider (OpenAI, Anthropic, Github Copilot, Google Gemini, OpenRouter, and so on).
- Chat subscriptions in websites/apps and API billing are often separate products.
- Cline may ask you to sign in/register for Cline features. That is separate from your AI provider account.
- You can use Cline as the chat interface in VS Code while paying for usage through your own provider API subscription.
- Keep your API key private. Treat it like a password.

## Important: Cline Account vs AI Provider Subscription

- Cline account/sign-in: used for Cline product features and extension experience.
- AI provider account (OpenAI/Anthropic/Google/etc.): used for model access and API billing.
- These are separate. Do not assume a Cline sign-up automatically includes model/API credits for every provider.

## Step 1: Install VS Code

1. Go to the official Visual Studio Code website.
2. Download VS Code for your operating system (Windows, macOS, or Linux).
3. Install it with default options.
4. Open VS Code.

## Step 2: Install Cline Extension

1. In VS Code, click Extensions (left sidebar) or press `Ctrl+Shift+X`.
2. Search for `Cline`.
3. Install the extension named `Cline`.
4. Reload VS Code if prompted.

## Step 3: Open AI Chat and Dock It on the Right

Goal layout:

`[VSCode file explorer] [Code window] [AI chat window]`

1. Open the AI chat view (Cline) from the Activity Bar (left side icons).
2. If the chat opens in the left sidebar, right-click the Cline/Chat view title.
3. Choose `Move View` -> `Secondary Side Bar`.
4. If the right-side area is hidden, enable it from:
   - `View` -> `Appearance` -> `Secondary Side Bar`
5. Keep Explorer/File Browser on the left and editor in the center.

You should now see the 3-column working layout.

## Step 4: Open Cline Provider Settings

1. Open the Cline panel in VS Code.
2. Open Settings (gear icon) inside Cline.
3. Find the provider/model configuration section.

Depending on Cline version, labels may differ slightly, but the flow is the same: choose provider, paste key, choose model, save.

## Step 5: Choose Provider and Paste API Key

Use this mapping to avoid confusion.

## Provider Name Mapping (Important)

| What users call it | Where key comes from | Provider name you usually pick in Cline | Notes |
|---|---|---|---|
| GitHub Copilot | GitHub account/subscription | Not applicable in Cline provider list | Copilot is usually used through the GitHub Copilot extension, not as a Cline API provider entry. |
| ChatGPT API key | OpenAI Platform dashboard | OpenAI | This is the most common confusion: ChatGPT API keys are configured under OpenAI in Cline. |
| Claude API key | Anthropic Console | Anthropic | Pick an available Claude model after adding key. |
| Gemini API key | Google AI Studio or Vertex AI | Gemini (or Google/Vertex AI, version-dependent) | Name may vary by Cline version. |
| OpenRouter key | OpenRouter dashboard | OpenRouter | Lets you access many model families behind one key. |
| Azure OpenAI key | Azure portal | Azure OpenAI or OpenAI-compatible/custom endpoint | Some versions expose Azure directly; others use endpoint + key fields. |
| DeepSeek key | DeepSeek platform | DeepSeek or OpenAI-compatible/custom endpoint | Depends on current provider list in Cline version. |
| Mistral key | Mistral platform | Mistral or OpenAI-compatible/custom endpoint | Depends on current provider list in Cline version. |
| Groq key | Groq console | Groq or OpenAI-compatible/custom endpoint | Depends on current provider list in Cline version. |

If your provider is not listed directly, check whether Cline supports it via an OpenAI-compatible/custom endpoint mode.

## Step 6: Select Model and Run a Test Prompt

1. Select a model offered by your chosen provider.
2. Save settings.
3. Send a simple test prompt in Cline, for example:
   - `Hello. Please confirm which provider and model are currently configured.`

If you get a response, setup is complete.

## Common Mistakes and Fixes

## Mistake 1: "I have ChatGPT key, but I cannot find ChatGPT provider in Cline"

Fix:
- Choose `OpenAI` in Cline.
- Paste your OpenAI API key there.

## Mistake 2: "I copied the key, but requests fail"

Fix checklist:
- Confirm there are no extra spaces before/after the key.
- Confirm API billing is active on the provider side.
- Confirm selected model is valid for your account.
- Regenerate key and retry.

## Mistake 3: "My provider name looks different"

Fix:
- Cline UI labels can change between versions.
- Pick the closest provider name from the mapping table above.
- If needed, use OpenAI-compatible/custom endpoint mode.

## Mistake 4: "I subscribed to GitHub Copilot, why does Cline still ask for provider/API setup?"

Fix:
- GitHub Copilot subscription and Cline provider API configuration are separate setups.
- In Cline, configure a supported provider key (OpenAI/Anthropic/Gemini/OpenRouter/etc.).
- If you want Copilot itself, use the GitHub Copilot extension in VS Code.

## Security Checklist

- Never paste API keys into project source files.
- Never commit keys to Git.
- Prefer environment variables or global secret stores when possible.
- Rotate keys immediately if accidentally exposed.

## Quick Copy Prompts for Support

If setup fails, you can ask Cline:

- `Check my current provider settings and tell me what is missing.`
- `I use OpenAI key from platform.openai.com. Guide me to the exact fields in Cline.`
- `Validate my provider + model selection step-by-step.`
