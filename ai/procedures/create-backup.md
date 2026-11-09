# PROCEDURE CREATE-BACKUP: When the user says "backup ai" or "backup ai state"

## Triggers

- backup ai
- backup ai state

1. **STEP-BACKUP-MANDATE**: Run the native backup command for your OS, substituting variables for resolved absolute paths:
    - **Linux/Bash**: `tar -czf [Global AI Backups Directory]/$(basename $(dirname $(pwd)))_$(basename $(pwd))_$(date +%Y-%m-%d_%H-%M).tar.gz ai/ ai-customization.md`
    - **Windows/PS**: `Compress-Archive -Path ai/, ai-customization.md -DestinationPath "[Global AI Backups Directory]/$(Split-Path -Leaf (Split-Path -Parent $PWD))_$(Split-Path -Leaf $PWD)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').zip"`
2. **STEP-REPORT-BACKUP-PATH**: Confirm the backup file path.
