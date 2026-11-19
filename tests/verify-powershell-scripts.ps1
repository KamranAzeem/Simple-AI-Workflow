<#
.SYNOPSIS
  Verify the protocol PowerShell scripts on Windows.

.DESCRIPTION
  Creates a throwaway project tree, then exercises sync-agents-md.ps1 and
  backup-ai.ps1: the dry runs, the real runs, the old-layout migration, the
  Merge Policy insertion, the secrets exclusion, and the archive ACL.

  Run with pwsh 7 on Windows:
    pwsh -NoProfile -ExecutionPolicy Bypass -File .\tests\verify-powershell-scripts.ps1

.PARAMETER WorkflowDir
  The Simple-AI-Workflow clone. Defaults to the parent of this script's directory.

.PARAMETER TestRoot
  The scratch directory. Defaults to a new directory under the temp path.
#>
[CmdletBinding()]
param(
  [string]$WorkflowDir = (Split-Path -Parent $PSScriptRoot),
  [string]$TestRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$failures = New-Object System.Collections.Generic.List[string]
function Check([string]$Name, [bool]$Condition) {
  if ($Condition) {
    Write-Host "PASS: $Name"
  } else {
    Write-Host "FAIL: $Name"
    $script:failures.Add($Name)
  }
}
function Read-Output($Lines) {
  ($Lines | ForEach-Object { $_.ToString() }) -join "`n"
}

$sync = Join-Path (Join-Path $WorkflowDir 'support-files') 'sync-agents-md.ps1'
$backup = Join-Path (Join-Path $WorkflowDir 'support-files') 'backup-ai.ps1'
$agents = Join-Path $WorkflowDir 'AGENTS.md'
foreach ($path in @($sync, $backup, $agents)) {
  if (-not (Test-Path -LiteralPath $path)) { throw "Missing required file: $path" }
}

$pwsh = (Get-Command pwsh -ErrorAction Stop).Source
if (-not $TestRoot) {
  $TestRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("sa-wf-pwsh-" + [guid]::NewGuid().ToString('N'))
}

$projects = Join-Path $TestRoot 'projects'
$old = Join-Path $projects 'proj-old'
$new = Join-Path $projects 'proj-new'
$backups = Join-Path $TestRoot 'backups'
$backupsNoSecrets = Join-Path $TestRoot 'backups-nosecrets'

New-Item -ItemType Directory -Force -Path (Join-Path $old 'ai\state'), (Join-Path $old 'ai\shared'), (Join-Path $old 'ai\secrets'), $new, $backups, $backupsNoSecrets | Out-Null
Set-Content -Path (Join-Path $old 'AGENTS.md') -Value '# Old project AGENTS.md'
Set-Content -Path (Join-Path $new 'AGENTS.md') -Value '# New project AGENTS.md'
Set-Content -Path (Join-Path $old 'ai\state\next-steps.md') -Value '- test'
Set-Content -Path (Join-Path $old 'ai\shared\coordination.md') -Value '# Board'
Set-Content -Path (Join-Path $old 'ai\secrets\token.txt') -Value 'test-secret'
$legacy = @'
# AI Customization

## AI Workflow Configuration

- **Global AI Workflow Directory**: C:\Old\Workflow\
'@
Set-Content -Path (Join-Path $old 'ai\ai-customization.md') -Value $legacy

Write-Host "=== sync -WhatIf ==="
$syncOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Source $agents -TargetPath $projects -WhatIf 2>&1
$syncRc = $LASTEXITCODE
$syncText = Read-Output $syncOut
Write-Host $syncText
Check 'sync -WhatIf exits 0' ($syncRc -eq 0)
Check 'sync -WhatIf reports the planned move' ($syncText -match 'Moving .*ai-customization\.md')
Check 'sync -WhatIf writes nothing' ((Test-Path -LiteralPath (Join-Path $old 'ai\ai-customization.md')) -and -not (Test-Path -LiteralPath (Join-Path $old 'ai-customization.md')))

Write-Host "=== sync real ==="
$syncOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Source $agents -TargetPath $projects 2>&1
$syncRc = $LASTEXITCODE
$syncText = Read-Output $syncOut
Write-Host $syncText
Check 'sync real exits 0' ($syncRc -eq 0)
Check 'sync real moves the old file' ((-not (Test-Path -LiteralPath (Join-Path $old 'ai\ai-customization.md'))) -and (Test-Path -LiteralPath (Join-Path $old 'ai-customization.md')))
Check 'sync real adds Merge Policy' ((Get-Content -Raw -Path (Join-Path $old 'ai-customization.md')) -match '(?m)^## Merge Policy')
Check 'sync real creates the new project config' (Test-Path -LiteralPath (Join-Path $new 'ai-customization.md'))

Write-Host "=== backup -WhatIf ==="
$backOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $backup -TargetPath $projects -BackupDir $backups -WhatIf 2>&1
$backRc = $LASTEXITCODE
$backText = Read-Output $backOut
Write-Host $backText
Check 'backup -WhatIf exits 0' ($backRc -eq 0)
Check 'backup -WhatIf finds both projects' (($backText -match 'proj-old') -and ($backText -match 'proj-new'))
Check 'backup -WhatIf writes nothing' (@(Get-ChildItem -Path $backups -Filter *.tar.gz -ErrorAction SilentlyContinue).Count -eq 0)

Write-Host "=== backup real ==="
$backOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $backup -TargetPath $projects -BackupDir $backups 2>&1
$backRc = $LASTEXITCODE
Write-Host (Read-Output $backOut)
Check 'backup real exits 0' ($backRc -eq 0)
$archives = @(Get-ChildItem -Path $backups -Filter *.tar.gz -ErrorAction Stop)
Check 'backup real creates two archives' ($archives.Count -eq 2)
$oldArchive = $archives | Where-Object { $_.Name -like '*proj-old*' } | Select-Object -First 1
$oldList = & tar.exe -tzf $oldArchive.FullName 2>&1
Check 'backup includes ai/secrets' ((Read-Output $oldList) -match 'ai/secrets/token\.txt')
$acl = Get-Acl -Path $oldArchive.FullName
$foreign = @($acl.Access | Where-Object { $_.AccessControlType -eq 'Allow' -and $_.IdentityReference -notmatch [regex]::Escape($env:USERNAME) })
Check 'backup archive is owner-only' ($foreign.Count -eq 0)

Write-Host "=== backup -ExcludeSecrets ==="
$backOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $backup -TargetPath $projects -BackupDir $backupsNoSecrets -ExcludeSecrets 2>&1
$backRc = $LASTEXITCODE
Write-Host (Read-Output $backOut)
Check 'backup -ExcludeSecrets exits 0' ($backRc -eq 0)
$noSecret = @(Get-ChildItem -Path $backupsNoSecrets -Filter *.tar.gz -ErrorAction Stop | Where-Object { $_.Name -like '*proj-old*' })[0]
$noSecretList = & tar.exe -tzf $noSecret.FullName 2>&1
Check 'backup -ExcludeSecrets omits ai/secrets' (-not ((Read-Output $noSecretList) -match 'ai/secrets'))

foreach ($script in @($sync, $backup, $PSCommandPath)) {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile($script, [ref]$tokens, [ref]$errors) | Out-Null
  Check "parses $(Split-Path -Leaf $script)" ($errors.Count -eq 0)
}

Write-Host ""
if ($failures.Count -eq 0) {
  Write-Host "ALL CHECKS PASSED"
  Write-Host "TestRoot: $TestRoot"
  exit 0
}
Write-Host "FAILED: $($failures.Count)"
$failures | ForEach-Object { Write-Host " - $_" }
Write-Host "TestRoot: $TestRoot"
exit 1
