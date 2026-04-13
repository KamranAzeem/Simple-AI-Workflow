# AI Policy Override

## Windows Shell Priority (Local Setup)

For terminal execution on this Windows machine:

1. Use Git Bash first for all commands by default.
2. Prefer Git Bash-compatible command forms and tools (`bash`, `rg`, `jq`, POSIX pipelines).
3. Use PowerShell only when the operation is truly Windows-native and no practical Git Bash equivalent is available.
4. When PowerShell is used, include a brief reason why Git Bash was not suitable.
5. Avoid unnecessary shell switching during a single task.
