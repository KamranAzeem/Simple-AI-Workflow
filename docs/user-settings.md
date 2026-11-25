<!-- Save this file as <User AI Directory>/settings/user-settings.md (default $HOME/.ai/settings/user-settings.md), then replace the placeholders with your own details. The AI loads the whole settings directory before the first named command. Run `repair user settings` to consolidate it, normalize the keys, and verify the tools. The repair redacts secrets and never copies the sensitive names. -->

# User Settings

Universal rules live in the common policy. This file holds personal preferences and the identity fallback.

## Identity

- **Name**: `<your name>`
- **Email**: `<you@example.com>`

## Profile

- **Role**: `<what you do, in one line>`
- **Base**: `<your city, country; OS and version>`
- **Certs**: `<your certifications, or leave blank>`

## Expertise

- **Expert**: `<the skills you want the AI to treat as your strongest>`
- **Familiar**: `<skills you know but are not expert in>`

## Communication

- **Voice**: `<your tone and point of view>`
- **Structure**: `<how you open, organize, and close a piece>`
- **Greetings**: `<how you greet a known person and a stranger>`
- **Language Habits**: `<the words, numbers, and asides you use>`
- **Words to Avoid**: `<the words you never want to see>`

## Default Shell Path

- **Default Shell Path**: `<the native OS path to the shell named by Default Shell in ai-customization.md, for example /bin/bash or C:\Program Files\Git\bin\bash.exe>`

## Tools

List only a tool you have installed and verified. One compact line per tool, with its full path and no prose. Remove the examples you do not use.

- **`rg`**: `<full path>`
- **`fd`**: `<full path>`
- **`jq`**: `<full path>`

## Operating Instructions

- **Git identity**: `<use your own name and email in all communication, taken from the applicable .gitconfig>`
- `<the actions the AI must never take, one per line>`

## Sensitive Names

- `<name or company>`
