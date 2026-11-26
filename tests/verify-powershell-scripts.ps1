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

**Global AI Workflow Directory**: C:\Old\Workflow\
'@
Set-Content -Path (Join-Path $old 'ai\ai-customization.md') -Value $legacy
$pruned = Join-Path $projects 'proj-new\node_modules\fake-project'
New-Item -ItemType Directory -Force -Path (Join-Path $pruned 'ai\state'), (Join-Path $pruned 'ai\shared') | Out-Null
Set-Content -Path (Join-Path $pruned 'ai\state\next-steps.md') -Value '- pruned'

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
Check 'sync real rewrites the workflow key' ((Get-Content -Raw -Path (Join-Path $old 'ai-customization.md')) -match '\*\*Workflow AI Directory\*\*')
Check 'sync real creates the new project config' (Test-Path -LiteralPath (Join-Path $new 'ai-customization.md'))

Write-Host "=== list presets ==="
$listOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -ListPresets 2>&1
$listRc = $LASTEXITCODE
$listText = Read-Output $listOut
Write-Host $listText
Check 'list exits 0' ($listRc -eq 0)
Check 'list includes web-developer' ($listText -match 'web-developer')
$presetDir = Join-Path $WorkflowDir 'docs\examples\customization-presets'
$dirNames = @(Get-ChildItem -LiteralPath $presetDir -Filter '*.md' -File | Where-Object { -not ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) } | ForEach-Object { $_.BaseName })
[Array]::Sort($dirNames, [System.StringComparer]::Ordinal)
Check 'list matches the live directory' ($listText -eq ($dirNames -join "`n"))
$listOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -ListPresets -Init 2>&1
$listRc = $LASTEXITCODE
Check 'list with init exits 2' ($listRc -eq 2)
Check 'list with init message' ((Read-Output $listOut) -match 'cannot be combined')

Write-Host "=== init ==="
$initTarget = Join-Path $TestRoot 'init-project'
New-Item -ItemType Directory -Force -Path $initTarget | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initTarget -Role web-developer 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Write-Host $initText
Check 'init exits 0' ($initRc -eq 0)
Check 'init writes AGENTS.md' (Test-Path -LiteralPath (Join-Path $initTarget 'AGENTS.md'))
Check 'init writes ai-customization.md' (Test-Path -LiteralPath (Join-Path $initTarget 'ai-customization.md'))
Check 'init creates no ai directory' (-not (Test-Path -LiteralPath (Join-Path $initTarget 'ai')))
Check 'init writes no Default Shell' (-not ((Get-Content -Raw -Path (Join-Path $initTarget 'ai-customization.md')) -match '\*\*Default Shell\*\*:'))
Check 'init substitutes the workflow path' ((Get-Content -Raw -Path (Join-Path $initTarget 'ai-customization.md')) -match [regex]::Escape("**Workflow AI Directory**: $WorkflowDir"))
Check 'init copies AGENTS.md' ((Get-Content -Raw -Path (Join-Path $initTarget 'AGENTS.md')) -eq (Get-Content -Raw -Path $agents))

Write-Host "=== init -WhatIf ==="
$initDry = Join-Path $TestRoot 'init-dry'
New-Item -ItemType Directory -Force -Path $initDry | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initDry -Role web-developer -WhatIf 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init -WhatIf exits 0' ($initRc -eq 0)
Check 'init -WhatIf writes nothing' ((-not (Test-Path -LiteralPath (Join-Path $initDry 'AGENTS.md'))) -and (-not (Test-Path -LiteralPath (Join-Path $initDry 'ai-customization.md'))))
Check 'init -WhatIf lists the writes' ($initText -match 'Would write:')

Write-Host "=== init existing target ==="
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initTarget -Role web-developer 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init existing target exits 1' ($initRc -eq 1)
Check 'init existing target names the file' ($initText -match 'Refusing to initialize:')

Write-Host "=== init unknown role ==="
$initUnknown = Join-Path $TestRoot 'init-unknown'
New-Item -ItemType Directory -Force -Path $initUnknown | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initUnknown -Role not-a-role 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init unknown role exits 2' ($initRc -eq 2)
Check 'init unknown role names it' ($initText -match 'Unknown role: not-a-role')
Check 'init unknown role lists presets' ($initText -match 'Available presets: .*security-engineer')
Check 'init unknown role guide reference' ($initText -match '11-presets-by-role')
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initUnknown -Role Web-Developer 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init uppercase role exits 2' ($initRc -eq 2)
Check 'init uppercase role is unknown' ($initText -match 'Unknown role: Web-Developer')

Write-Host "=== init without role ==="
$initNoRole = Join-Path $TestRoot 'init-no-role'
New-Item -ItemType Directory -Force -Path $initNoRole | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initNoRole 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init without role exits 2' ($initRc -eq 2)
Check 'init without role lists presets' ($initText -match 'Available presets:')
Check 'init without role guide reference' ($initText -match '11-presets-by-role')

Write-Host "=== init target inside clone ==="
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath (Join-Path $WorkflowDir 'support-files') -Role web-developer 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init inside clone exits 2' ($initRc -eq 2)
Check 'init inside clone names it' ($initText -match 'Target is the workflow clone or inside it')

Write-Host "=== init removed preset (copied clone) ==="
$spaceClone = Join-Path $TestRoot 'clone with space'
New-Item -ItemType Directory -Force -Path (Join-Path $spaceClone 'support-files'), (Join-Path $spaceClone 'docs\examples\customization-presets') | Out-Null
Copy-Item -LiteralPath $sync -Destination (Join-Path $spaceClone 'support-files\sync-agents-md.ps1') -Force
Copy-Item -LiteralPath $agents -Destination (Join-Path $spaceClone 'AGENTS.md') -Force
Copy-Item -Path (Join-Path (Join-Path $WorkflowDir 'docs\examples\customization-presets') '*.md') -Destination (Join-Path $spaceClone 'docs\examples\customization-presets') -Force
Remove-Item -LiteralPath (Join-Path $spaceClone 'docs\examples\customization-presets\dba.md') -Force
$initMissing = Join-Path $TestRoot 'init-missing'
New-Item -ItemType Directory -Force -Path $initMissing | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File (Join-Path $spaceClone 'support-files\sync-agents-md.ps1') -Init -TargetPath $initMissing -Role dba 2>&1
$initRc = $LASTEXITCODE
$initText = Read-Output $initOut
Check 'init removed preset exits 2' ($initRc -eq 2)
Check 'init removed preset is unknown' ($initText -match 'Unknown role: dba')
Check 'init removed preset lists the live set' ($initText -match 'Available presets:')
Check 'init removed preset guide reference' ($initText -match '11-presets-by-role')

Write-Host "=== init temp preset (copied clone) ==="
Copy-Item -LiteralPath (Join-Path $spaceClone 'docs\examples\customization-presets\web-developer.md') -Destination (Join-Path $spaceClone 'docs\examples\customization-presets\temp-role.md') -Force
$listOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File (Join-Path $spaceClone 'support-files\sync-agents-md.ps1') -ListPresets 2>&1
Check 'temp preset appears in the list' ((Read-Output $listOut) -match 'temp-role')
$initTemp = Join-Path $TestRoot 'init-temp'
New-Item -ItemType Directory -Force -Path $initTemp | Out-Null
$initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File (Join-Path $spaceClone 'support-files\sync-agents-md.ps1') -Init -TargetPath $initTemp -Role temp-role 2>&1
Check 'temp preset init exits 0' ($LASTEXITCODE -eq 0)

Write-Host "=== init symlink refusal ==="
$initLink = Join-Path $TestRoot 'init-link'
New-Item -ItemType Directory -Force -Path $initLink | Out-Null
$linkTarget = Join-Path $TestRoot 'link-target.txt'
Set-Content -Path $linkTarget -Value 'link target'
$linkCreated = $false
try {
  New-Item -ItemType SymbolicLink -Path (Join-Path $initLink 'AGENTS.md') -Target $linkTarget -ErrorAction Stop | Out-Null
  $linkCreated = $true
} catch { }
if ($linkCreated) {
  $initOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $sync -Init -TargetPath $initLink -Role web-developer 2>&1
  $initRc = $LASTEXITCODE
  $initText = Read-Output $initOut
  Check 'init symlink exits 2' ($initRc -eq 2)
  Check 'init symlink names it' ($initText -match 'is a symlink')
} else {
  Write-Host 'SKIP: init symlink case (platform cannot create symlinks)'
}

Write-Host "=== backup -WhatIf ==="
$backOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $backup -TargetPath $projects -BackupDir $backups -WhatIf 2>&1
$backRc = $LASTEXITCODE
$backText = Read-Output $backOut
Write-Host $backText
Check 'backup -WhatIf exits 0' ($backRc -eq 0)
Check 'backup -WhatIf finds both projects' (($backText -match 'proj-old') -and ($backText -match 'proj-new'))
Check 'backup -WhatIf streams discovery' ($backText -match 'Scanning .* for workflow projects')
Check 'backup -WhatIf streams summary' ($backText -match 'Summary: \d+ projects would be archived')
Check 'backup -WhatIf prunes node_modules' (-not ($backText -match 'fake-project'))
Check 'backup -WhatIf writes nothing' (@(Get-ChildItem -Path $backups -Filter *.tar.gz -ErrorAction SilentlyContinue).Count -eq 0)

Write-Host "=== backup real ==="
$backOut = & $pwsh -NoProfile -ExecutionPolicy Bypass -File $backup -TargetPath $projects -BackupDir $backups 2>&1
$backRc = $LASTEXITCODE
Write-Host (Read-Output $backOut)
Check 'backup real exits 0' ($backRc -eq 0)
Check 'backup real streams summary' ((Read-Output $backOut) -match 'Summary: 2 archived')
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
