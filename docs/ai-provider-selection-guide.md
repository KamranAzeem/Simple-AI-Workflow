# AI Provider Selection Guide (Cost and Usage)

This guide helps you choose an AI provider and the VS Code extension before you set up the workflow. VS Code is the recommended home; Kilo Code is the recommended extension.

Use this as a decision helper, not as a price contract.

- Prices and model availability can change frequently.
- Always verify current pricing and limits on the provider's official page.

## Quick Decision (60 seconds)

1. If you want the easiest coding assistant setup in VS Code with minimal API management:
   - Start with GitHub Copilot.
2. If you want full control over model choice and API usage:
   - Start with Kilo Code plus OpenAI, Anthropic, Gemini, or OpenRouter.
3. If you want one API key with multiple model families:
   - Start with OpenRouter.
4. If your company requires Azure governance or compliance:
   - Start with Azure OpenAI.

## Two Common Paths

### Path A: extension subscription model

- Example: a GitHub Copilot subscription.
- You subscribe to the tool service itself.
- Good for users who want simple onboarding and less provider-key management.

### Path B: provider API billing model

- Examples: OpenAI API, Anthropic API, Google Gemini API, OpenRouter API.
- You pay per usage (or usage tiers) to the model provider.
- Use Kilo Code as the chat extension and add the provider key there.
- Good for users who want flexible model selection and deeper control.

## Important Clarification

- A GitHub Copilot subscription does not automatically configure a provider API key.
- A Kilo Code provider setup does not automatically include GitHub Copilot subscription features.
- Kilo Code and Copilot can run side by side in the same VS Code environment.

## Selection by User Type

### 1) Beginner, low friction first

Recommended start:

- GitHub Copilot for the assistant workflow.
- Optionally add one provider API later for Kilo Code experiments.

Why:

- Fewer setup steps.
- Fast time-to-value.

### 2) Cost-aware learner, experimenting with multiple models

Recommended start:

- OpenRouter or one direct provider API.
- Use Kilo Code with strict model and usage choices.

Why:

- Easier to compare models and cost behavior.
- Better control over token spending.

### 3) Professional developer working daily in a codebase

Recommended start:

- GitHub Copilot for daily speed.
- Add one API provider for advanced tasks in Kilo Code.

Why:

- The best of both worlds: convenience and flexibility.

### 4) Enterprise, security, or governance-heavy team

Recommended start:

- Azure OpenAI or an approved enterprise provider path.
- Follow the company compliance, identity, logging, and data policies.

Why:

- Better alignment with enterprise controls.

## The Kilo Code Path

1. Install VS Code.
2. Install the Kilo Code extension from the Marketplace.
3. Open Kilo Code and choose a provider from this guide.
4. Paste the provider API key and choose a model.
5. Open the project root with `AGENTS.md` and `ai-customization.md`, then run `"bootstrap using AGENTS.md protocol"`.
6. Start each session with `"load context using AGENTS.md protocol"`.

See [setup](setup.md#kilo-code-setup) for the steps and the update flow.

## Cost and Usage Checklist

Before committing to one provider or tool, check:

1. Billing model.
   - Subscription, pay-as-you-go, or mixed?
2. Daily usage profile.
   - Light, medium, or heavy coding and chat volume?
3. Model quality for your tasks.
   - Coding, architecture, documentation, debugging?
4. Rate limits.
   - Are requests throttled at your plan level?
5. Team and compliance constraints.
   - Data policy, region policy, audit requirements?
6. Tool compatibility.
   - Works well with Kilo Code, Copilot, or both?

## Practical Starter Recommendations

If you are unsure, start here:

1. Start simple with one assistant flow you can use every day.
2. Track one week of real usage.
3. Add a second provider only if you need better quality, better speed, or lower cost.

This avoids over-configuring too early.

## Related Guides

- [Setup](setup.md): install and update the workflow.
- [Post-compaction reload](post-compaction-reload-trigger-setup.md): keep the rules after a summary.
- [The README](../README.md): the landing page.
