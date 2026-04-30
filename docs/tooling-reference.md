# AI-Assisted Tooling Reference

This guide outlines the preferred system tools for AI assistants to use when working within this workflow. Installing these tools significantly enhances AI performance, data processing efficiency, and interactive workflows.

## Prerequisites: Tool Installation

For optimal performance, ensure the following tools are installed on your system.

### Install Commands

| OS | Recommended Method |
| :--- | :--- |
| **macOS** | `brew install fd ripgrep fzf bat tree jq yq ncdu k9s` |
| **Ubuntu/Debian** | `sudo apt install fd-find ripgrep fzf bat tree jq yq ncdu k9s` |
| **Fedora/RHEL** | `sudo dnf install fd-find ripgrep fzf bat tree jq yq ncdu k9s` |
| **Windows** | `winget install sharkdp.fd sharkdp.bat junegunn.fzf.bin jq.jq mikefarah.yq k9s.k9s` |

---

## Tool Capability Matrix

*This is the live reference used by AI assistants (stored in `settings/ai-preferred-tools.md`).*

| Capability | Preferred Tool | Why? |
| :--- | :--- | :--- |
| **File Search** | `fd` | Faster and more intuitive than `find` |
| **Text Search** | `rg` | Extremely fast recursive search, handles `.gitignore` |
| **Interactive Find** | `fzf` | Best-in-class for interactive file/command selection |
| **File Viewing** | `bat` | Syntax highlighting makes code review much easier |
| **Dir Structure** | `tree` | Visualizes nested structures cleanly |
| **JSON Data** | `jq` | Standard for parsing/filtering JSON |
| **YAML Data** | `yq` | Simplifies complex YAML/XML configs |
| **Disk Usage** | `ncdu` | Interactive and efficient |
| **Kubernetes** | `k9s` | Rich TUI for interactive pod/log management |

## How to Verify
To ensure these tools are available to your AI assistant, you can run:

```bash
command -v fd rg fzf bat tree jq yq ncdu k9s
```

If any are missing, the AI may fall back to less efficient standard Unix utilities (like `find` or `grep`).
