<#
.SYNOPSIS
  Sync AGENTS.md into initialized project directories, or initialize a new
  project from a role preset.

.DESCRIPTION
  Sync mode recursively finds AGENTS.md under a target root and migrates the
  project, user, and team knowledge stores. Init mode writes only AGENTS.md and
  ai-customization.md into a new project root from a role preset. -WhatIf prints
  every action and writes nothing.

.USAGE
  ./sync-agents-md.ps1 -Source ../AGENTS.md -TargetPath C:\Projects -WhatIf
  ./sync-agents-md.ps1 -Init -TargetPath C:\Projects\New -Role web-developer
#>

param(
  [string]$Source = "./AGENTS.md",
  [string]$TargetPath = ".",
  [switch]$Init,
  [string]$Role = "",
  [switch]$WhatIf
)

Set-StrictMode -Version Latest

$scriptDir = $PSScriptRoot
$workflowDir = Split-Path -Parent $scriptDir
$workflowDirFull = (Get-Item -LiteralPath $workflowDir -Force).FullName.TrimEnd([char[]]@('\', '/'))

function Get-InitRoles {
  return @('cloud-architect','solution-architect','web-developer','mobile-developer','platform-engineer','dba','data-engineer','security-engineer')
}

function Test-UnderWorkflow {
  param([string]$Path)
  $full = (Get-Item -LiteralPath $Path -Force).FullName.TrimEnd([char[]]@('\', '/'))
  if ($full.Equals($workflowDirFull, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
  $prefix = $workflowDirFull + [System.IO.Path]::DirectorySeparatorChar
  return $full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
}

function Test-InitRole {
  param([string]$RoleValue)
  if ([string]::IsNullOrWhiteSpace($RoleValue)) { return $false }
  if ($RoleValue -cnotmatch '^[a-z0-9-]+$') { return $false }
  return ((Get-InitRoles) -ccontains $RoleValue)
}

function Get-InitPresetPath {
  param([string]$RoleValue)
  return (Join-Path -Path (Join-Path -Path $workflowDirFull -ChildPath 'docs/examples/customization-presets') -ChildPath ($RoleValue + '.md'))
}

function Get-InitPresetContent {
  param([string]$RoleValue, [string]$PresetPath)
  $item = Get-Item -LiteralPath $PresetPath -Force -ErrorAction SilentlyContinue
  if ($null -eq $item) {
    Write-Error "Missing preset file for role $RoleValue`: $PresetPath"
    Write-Error "Available presets: $((Get-InitRoles) -join ' ')"
    return $null
  }
  if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
    Write-Error "Invalid preset file for role $RoleValue`: $PresetPath"
    return $null
  }
  if (-not (Test-Path -LiteralPath $PresetPath -PathType Leaf)) {
    Write-Error "Missing preset file for role $RoleValue`: $PresetPath"
    Write-Error "Available presets: $((Get-InitRoles) -join ' ')"
    return $null
  }
  $content = [System.IO.File]::ReadAllText($PresetPath)
  if ($content -match '(?m)^\*\*Default Shell\*\*:') {
    Write-Error "Preset contains a forbidden Default Shell key: $PresetPath"
    return $null
  }
  $placeholders = [regex]::Matches($content, '(?m)^\*\*Workflow AI Directory\*\*: /path/to/Simple-AI-Workflow$')
  if ($placeholders.Count -eq 0) {
    Write-Error "Preset is missing the workflow placeholder: $PresetPath"
    return $null
  }
  if ($placeholders.Count -gt 1) {
    Write-Error "Preset has a duplicate workflow placeholder: $PresetPath"
    return $null
  }
  return $content
}

function Convert-InitPreset {
  param([string]$Content)
  $replacement = ('**Workflow AI Directory**: ' + $workflowDirFull).Replace('$', '$$')
  return [regex]::Replace($Content, '(?m)^\*\*Workflow AI Directory\*\*: /path/to/Simple-AI-Workflow$', $replacement)
}

function Test-InitRootPaths {
  param([string]$TargetRoot)
  $paths = @((Join-Path -Path $TargetRoot -ChildPath 'AGENTS.md'), (Join-Path -Path $TargetRoot -ChildPath 'ai-customization.md'))
  $code = 0
  foreach ($p in $paths) {
    $item = Get-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) { continue }
    if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
      Write-Error "Refusing to initialize: $p is a symlink."
      $code = 2
    } else {
      Write-Error "Refusing to initialize: $p already exists."
      if ($code -eq 0) { $code = 1 }
    }
  }
  return $code
}

function Set-InitUnixMode {
  param([string]$Path)
  if ($PSVersionTable.PSVersion.Major -lt 6) { return }
  try {
    $mode = [System.IO.UnixFileMode]::UserRead -bor [System.IO.UnixFileMode]::UserWrite -bor [System.IO.UnixFileMode]::GroupRead -bor [System.IO.UnixFileMode]::OtherRead
    [System.IO.File]::SetUnixFileMode($Path, $mode)
  } catch { }
}

function Invoke-Init {
  param(
    [bool]$SourceBound,
    [bool]$RoleBound,
    [bool]$TargetBound,
    [string]$RoleValue,
    [string]$TargetValue,
    [bool]$DryRun
  )
  if ($SourceBound) { Write-Error '--source is not allowed with --init.'; return 2 }
  if (-not $RoleBound -or [string]::IsNullOrWhiteSpace($RoleValue)) { Write-Error '--role is required with --init.'; return 2 }
  if (-not $TargetBound) { Write-Error '--target-path is required with --init.'; return 2 }
  if (-not (Test-Path -LiteralPath $TargetValue -PathType Container)) { Write-Error "Target path is not a directory: $TargetValue"; return 2 }
  try { $targetAbs = (Resolve-Path -LiteralPath $TargetValue -ErrorAction Stop).Path } catch { Write-Error "Target path cannot be accessed: $TargetValue"; return 2 }
  if (Test-UnderWorkflow -Path $targetAbs) { Write-Error "Target is the workflow clone or inside it: $targetAbs"; return 2 }
  if (-not (Test-InitRole -RoleValue $RoleValue)) {
    Write-Error "Unknown role: $RoleValue"
    Write-Error "Available presets: $((Get-InitRoles) -join ' ')"
    return 2
  }
  $preset = Get-InitPresetPath -RoleValue $RoleValue
  $content = Get-InitPresetContent -RoleValue $RoleValue -PresetPath $preset
  if ($null -eq $content) { return 1 }
  $src = Join-Path -Path $workflowDirFull -ChildPath 'AGENTS.md'
  if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { Write-Error "Missing canonical AGENTS.md: $src"; return 1 }
  $agents = Join-Path -Path $targetAbs -ChildPath 'AGENTS.md'
  $custom = Join-Path -Path $targetAbs -ChildPath 'ai-customization.md'
  $code = Test-InitRootPaths -TargetRoot $targetAbs
  if ($code -ne 0) { return $code }
  if ($DryRun) {
    Write-Host "Dry run: would initialize $targetAbs"
    Write-Host "Would write: $agents"
    Write-Host "Would write: $custom"
    Write-Host "Next: run `"bootstrap using AGENTS.md protocol`" in $targetAbs."
    return 0
  }
  $agentsTemp = Join-Path -Path $targetAbs -ChildPath ('.agents.' + [guid]::NewGuid().ToString('N'))
  $customTemp = Join-Path -Path $targetAbs -ChildPath ('.custom.' + [guid]::NewGuid().ToString('N'))
  try {
    [System.IO.File]::Copy($src, $agentsTemp, $false)
    [System.IO.File]::WriteAllText($customTemp, (Convert-InitPreset -Content $content), [System.Text.UTF8Encoding]::new($false))
    Set-InitUnixMode -Path $agentsTemp
    Set-InitUnixMode -Path $customTemp
  } catch {
    Remove-Item -LiteralPath $agentsTemp -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $customTemp -Force -ErrorAction SilentlyContinue
    Write-Error "Initialization failed: $($_.Exception.Message)"
    return 1
  }
  $code = Test-InitRootPaths -TargetRoot $targetAbs
  if ($code -ne 0) {
    Remove-Item -LiteralPath $agentsTemp -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $customTemp -Force -ErrorAction SilentlyContinue
    return $code
  }
  try {
    [System.IO.File]::Move($agentsTemp, $agents)
  } catch {
    Remove-Item -LiteralPath $agentsTemp -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $customTemp -Force -ErrorAction SilentlyContinue
    Write-Error "Initialization failed: $($_.Exception.Message)"
    return 1
  }
  try {
    [System.IO.File]::Move($customTemp, $custom)
  } catch {
    Remove-Item -LiteralPath $agents -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $agentsTemp -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $customTemp -Force -ErrorAction SilentlyContinue
    Write-Error "Initialization failed: $($_.Exception.Message)"
    return 1
  }
  Write-Host "Initialized $targetAbs"
  Write-Host "Next: run `"bootstrap using AGENTS.md protocol`" in $targetAbs."
  return 0
}

if ($Init) {
  $initCode = Invoke-Init -SourceBound $PSBoundParameters.ContainsKey('Source') -RoleBound $PSBoundParameters.ContainsKey('Role') -TargetBound $PSBoundParameters.ContainsKey('TargetPath') -RoleValue $Role -TargetValue $TargetPath -DryRun ([bool]$WhatIf)
  exit $initCode
}

if ($PSBoundParameters.ContainsKey('Role')) {
  Write-Error '--role is only valid with --init.'
  exit 2
}

if (-not (Test-Path -Path $Source -PathType Leaf)) {
  Write-Error "Source AGENTS.md not found: $Source"
  exit 2
}
try {
  $srcPath = (Resolve-Path -Path $Source -ErrorAction Stop).Path
} catch {
  Write-Error "Failed to resolve source path: $Source"
  exit 2
}
try {
  $targetAbs = (Resolve-Path -Path $TargetPath -ErrorAction Stop).Path
} catch {
  Write-Error "Target path not found or not a directory: $TargetPath"
  exit 2
}

$migrationDate = Get-Date -Format 'yyyy-MM-dd'
$sepChars = [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

if (-not $srcPath.StartsWith($workflowDirFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
  Write-Warning "Source $srcPath is outside the workflow clone $workflowDirFull; the clone root still drives the config and exclusion."
}

Write-Host "Source: $srcPath"
Write-Host "Workflow directory: $workflowDirFull"
Write-Host "Searching under: $targetAbs"
if ($WhatIf) { Write-Host "Mode: dry run; no file is written or moved." }

function Write-Action {
  param([string]$Message)
  Write-Host $Message
}

function Test-BoundedPath {
  param([string]$Path)
  if (-not (Test-Path -Path $Path -PathType Container)) { return $false }
  $timeout = 3
  if ($env:PATH_PROBE_TIMEOUT) {
    $parsed = 0
    if ([int]::TryParse($env:PATH_PROBE_TIMEOUT, [ref]$parsed) -and $parsed -gt 0) { $timeout = $parsed }
  }
  try {
    $job = Start-Job -ScriptBlock {
      param($p)
      Get-ChildItem -LiteralPath $p -Force -ErrorAction Stop | Select-Object -First 1 | Out-Null
    } -ArgumentList $Path
    $done = Wait-Job -Job $job -Timeout $timeout
    if ($null -eq $done) {
      Stop-Job -Job $job -ErrorAction SilentlyContinue
      Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
      Write-Warning "PENDING: path probe timed out for $Path"
      return $false
    }
    Receive-Job -Job $job -ErrorAction SilentlyContinue | Out-Null
    Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
    return $true
  } catch {
    Write-Warning "PENDING: path probe failed for $Path"
    return $false
  }
}

function Get-UniqueDest {
  param([string]$DestDir, [string]$Name)
  $candidate = Join-Path -Path $DestDir -ChildPath $Name
  if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }
  $candidate = Join-Path -Path $DestDir -ChildPath "$Name.migrated-$migrationDate"
  $n = 2
  while (Test-Path -LiteralPath $candidate) {
    $candidate = Join-Path -Path $DestDir -ChildPath "$Name.migrated-$migrationDate-$n"
    $n++
  }
  return $candidate
}

function Backup-Store {
  param([string]$Src, [string]$Dest, [string]$Label)
  if (-not (Test-Path -LiteralPath $Src)) { return }
  $item = Get-Item -LiteralPath $Src -Force
  if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw "Refusing symlinked $Label store root: $Src"
  }
  Write-Action "  Backup $Label: $Src -> $Dest"
  if ($WhatIf) {
    Write-Action "  DRY-RUN: would copy the $Label store to $Dest"
    return
  }
  New-Item -ItemType Directory -Force -Path $Dest -ErrorAction Stop | Out-Null
  Get-ChildItem -LiteralPath $Src -Force | Copy-Item -Destination $Dest -Recurse -Force -ErrorAction Stop
  foreach ($file in (Get-ChildItem -LiteralPath $Src -Recurse -File -Force -ErrorAction Stop)) {
    $rel = [System.IO.Path]::GetRelativePath($Src, $file.FullName)
    $target = Join-Path -Path $Dest -ChildPath $rel
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
      throw "Backup verification failed for $Label; store unchanged"
    }
    if ((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash) {
      throw "Backup verification failed for $Label; store unchanged"
    }
  }
}

function Move-TreeMerge {
  param([string]$Src, [string]$Dest, [string]$Label)
  if (-not (Test-Path -LiteralPath $Src)) { return }
  $item = Get-Item -LiteralPath $Src -Force
  if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw "Refusing symlinked $Label store root: $Src"
  }
  Write-Action "  Migrate $Label: $Src -> $Dest"
  $files = Get-ChildItem -LiteralPath $Src -Recurse -File -Force -ErrorAction Stop
  if ($WhatIf) {
    foreach ($file in $files) {
      $rel = [System.IO.Path]::GetRelativePath($Src, $file.FullName)
      Write-Action "  DRY-RUN: would move $($file.FullName) -> $Dest/$rel"
    }
    return
  }
  New-Item -ItemType Directory -Force -Path $Dest -ErrorAction Stop | Out-Null
  foreach ($file in $files) {
    $rel = [System.IO.Path]::GetRelativePath($Src, $file.FullName)
    $relDir = Split-Path -Parent $rel
    $parent = if ($relDir) { Join-Path -Path $Dest -ChildPath $relDir } else { $Dest }
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
      New-Item -ItemType Directory -Force -Path $parent -ErrorAction Stop | Out-Null
    }
    $target = Get-UniqueDest -DestDir $parent -Name (Split-Path -Leaf $rel)
    Move-Item -LiteralPath $file.FullName -Destination $target -Force -ErrorAction Stop
    Write-Action "  Moved $($file.FullName) -> $target"
  }
  Get-ChildItem -LiteralPath $Src -Recurse -Directory -Force -ErrorAction SilentlyContinue |
    Sort-Object -Property FullName -Descending |
    ForEach-Object {
      if (-not (Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue)) {
        Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
      }
    }
  if (Test-Path -LiteralPath $Src) {
    if (-not (Get-ChildItem -LiteralPath $Src -Force -ErrorAction SilentlyContinue)) {
      Remove-Item -LiteralPath $Src -Force -ErrorAction SilentlyContinue
    } else {
      Write-Warning "$Label old directory is not empty; left in place: $Src"
    }
  }
}

function Move-FileUnique {
  param([string]$Src, [string]$DestDir, [string]$Name, [string]$Label)
  if (-not (Test-Path -LiteralPath $Src)) { return }
  $target = Get-UniqueDest -DestDir $DestDir -Name $Name
  Write-Action "  Migrate $Label: $Src -> $target"
  if ($WhatIf) {
    Write-Action "  DRY-RUN: would move $Src -> $target"
    return
  }
  New-Item -ItemType Directory -Force -Path $DestDir -ErrorAction Stop | Out-Null
  Move-Item -LiteralPath $Src -Destination $target -Force -ErrorAction Stop
}

function Get-ConfigSection {
  param([string]$WorkflowDir)
  @"

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Workflow AI Directory**: $WorkflowDir

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.
"@
}

function Get-MergePolicySection {
  @"

## Merge Policy

**Merge Mode**: auto

<!-- Use pr for team repositories that require a pull request; direct for solo work. -->
"@
}

function Add-MergePolicySection {
  param([string]$CustomizationFile)
  $content = Get-Content -Raw -Path $CustomizationFile -ErrorAction Stop
  if ($content -match '(?m)^## Merge Policy') { return }
  if ($WhatIf) {
    Write-Action "  ai-customization.md: would add Merge Policy"
    return
  }
  $newContent = $content.TrimEnd() + "`n" + (Get-MergePolicySection) + "`n"
  [System.IO.File]::WriteAllText($CustomizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
  Write-Action "  ai-customization.md: added Merge Policy"
}

function Add-ConfigSection {
  param([string]$CustomizationFile, [string]$WorkflowDir)
  $content = Get-Content -Raw -Path $CustomizationFile -ErrorAction Stop
  if ($content -match '(?m)^## AI Workflow Configuration') { return }
  if ($WhatIf) {
    Write-Action "  ai-customization.md: would add AI Workflow Configuration"
    return
  }
  $lines = $content -split "`n"
  $section = Get-ConfigSection -WorkflowDir $WorkflowDir
  $newContent = if ($lines.Count -ge 1) {
    $lines[0] + $section + "`n" + ($lines[1..($lines.Count - 1)] -join "`n")
  } else {
    $section + "`n"
  }
  [System.IO.File]::WriteAllText($CustomizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
}

function Rewrite-Key {
  param([string]$File, [string]$OldKey, [string]$NewKey)
  $content = Get-Content -Raw -Path $File -ErrorAction Stop
  $oldPattern = '(?m)^\*\*' + [regex]::Escape($OldKey) + '\*\*:\s*(.*)$'
  $newPattern = '(?m)^\*\*' + [regex]::Escape($NewKey) + '\*\*:'
  if ($content -notmatch $oldPattern) { return }
  if ($content -match $newPattern) {
    Write-Warning "  ai-customization.md: $NewKey wins; removing duplicate $OldKey"
    if (-not $WhatIf) {
      $newContent = [regex]::Replace($content, $oldPattern + '\r?\n?', '')
      [System.IO.File]::WriteAllText($File, $newContent, [System.Text.UTF8Encoding]::new($false))
    }
    return
  }
  $match = [regex]::Match($content, $oldPattern)
  $value = $match.Groups[1].Value
  Write-Action "  ai-customization.md: $OldKey -> $NewKey"
  if ($WhatIf) {
    Write-Action "  DRY-RUN: would rewrite the key and preserve the value"
    return
  }
  $safeValue = $value -replace '\$', '$$$$'
  $replacement = '**' + $NewKey + '**: ' + $safeValue
  $newContent = [regex]::Replace($content, $oldPattern, $replacement)
  [System.IO.File]::WriteAllText($File, $newContent, [System.Text.UTF8Encoding]::new($false))
}

function Get-KeyValue {
  param([string]$File, [string]$Key)
  $content = Get-Content -Raw -Path $File -ErrorAction Stop
  $pattern = '(?m)^\*\*' + [regex]::Escape($Key) + '\*\*:\s*(.*)$'
  $match = [regex]::Match($content, $pattern)
  if (-not $match.Success) { return "" }
  $value = $match.Groups[1].Value.Trim()
  $value = $value -replace '\[HOME\]', $env:USERPROFILE
  $value = $value -replace '^~', $env:USERPROFILE
  return $value
}

function Rewrite-CustomizationKeys {
  param([string]$File)
  # LEGACY-GLOBAL-START
  Rewrite-Key -File $File -OldKey 'Global AI Workflow Directory' -NewKey 'Workflow AI Directory'
  Rewrite-Key -File $File -OldKey 'Global User AI Directory' -NewKey 'User AI Directory'
  Rewrite-Key -File $File -OldKey 'Team AI Knowledge Directory' -NewKey 'Team AI Directory'
  # LEGACY-GLOBAL-END
  $content = Get-Content -Raw -Path $File -ErrorAction Stop
  if ($content -match '(?m)^- global-settings$') {
    Write-Action "  ai-customization.md: Active Expertise global-settings -> user-settings"
    if (-not $WhatIf) {
      $newContent = $content -replace '(?m)^- global-settings$', '- user-settings'
      [System.IO.File]::WriteAllText($File, $newContent, [System.Text.UTF8Encoding]::new($false))
    }
  }
}

function Test-TargetInitialized {
  param([string]$ProjectRoot)
  $customizationFile = Join-Path -Path $ProjectRoot -ChildPath "ai-customization.md"
  $oldFile = Join-Path -Path $ProjectRoot -ChildPath "ai/ai-customization.md"
  foreach ($path in @($customizationFile, $oldFile)) {
    if (Test-Path -LiteralPath $path) {
      $item = Get-Item -LiteralPath $path -Force
      if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "$path is a symlink; refusing to migrate. Replace it with a regular file."
      }
    }
  }
  if (-not (Test-Path -LiteralPath $customizationFile -PathType Leaf) -and
      -not (Test-Path -LiteralPath $oldFile -PathType Leaf)) {
    throw 'Uninitialized project. Run "bootstrap using AGENTS.md protocol".'
  }
}

function Ensure-CustomizationFile {
  param([string]$ProjectRoot, [string]$WorkflowDir)
  $customizationFile = Join-Path -Path $ProjectRoot -ChildPath "ai-customization.md"
  $oldFile = Join-Path -Path $ProjectRoot -ChildPath "ai/ai-customization.md"

  foreach ($path in @($customizationFile, $oldFile)) {
    if (Test-Path -LiteralPath $path) {
      $item = Get-Item -LiteralPath $path -Force
      if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "$path is a symlink; refusing to migrate. Replace it with a regular file."
      }
    }
  }

  if ((Test-Path -LiteralPath $oldFile -PathType Leaf) -and -not (Test-Path -LiteralPath $customizationFile -PathType Leaf)) {
    Write-Action "  Moving $oldFile to $customizationFile"
    if (-not $WhatIf) {
      Move-Item -LiteralPath $oldFile -Destination $customizationFile -Force -ErrorAction Stop
      Add-ConfigSection -CustomizationFile $customizationFile -WorkflowDir $WorkflowDir
    }
  } elseif ((Test-Path -LiteralPath $oldFile -PathType Leaf) -and (Test-Path -LiteralPath $customizationFile -PathType Leaf)) {
    Write-Warning "  both $oldFile and $customizationFile exist; keeping the root file and leaving the old file untouched"
  } elseif (-not (Test-Path -LiteralPath $customizationFile -PathType Leaf)) {
    throw 'Uninitialized project. Run "bootstrap using AGENTS.md protocol".'
  }

  if ($WhatIf -and -not (Test-Path -LiteralPath $customizationFile -PathType Leaf)) {
    Write-Action "  DRY-RUN: would add the config section, rewrite keys, and add Merge Policy"
    return
  }

  Add-ConfigSection -CustomizationFile $customizationFile -WorkflowDir $WorkflowDir
  Rewrite-CustomizationKeys -File $customizationFile
  Add-MergePolicySection -CustomizationFile $customizationFile
}

function Migrate-ProjectStore {
  param([string]$ProjectRoot)
  $src = Join-Path -Path $ProjectRoot -ChildPath "ai/shared/project-knowledge"
  $dest = Join-Path -Path $ProjectRoot -ChildPath "ai/knowledge"
  $backup = Join-Path -Path $ProjectRoot -ChildPath "ai/artifacts/scope-migration-$migrationDate/project-knowledge"
  if (-not (Test-Path -LiteralPath $src)) { return }
  Backup-Store -Src $src -Dest $backup -Label "project knowledge"
  Move-TreeMerge -Src $src -Dest $dest -Label "project knowledge"
}

function Migrate-StateFiles {
  param([string]$ProjectRoot)
  $aiDir = Join-Path -Path $ProjectRoot -ChildPath "ai"
  if (-not (Test-Path -LiteralPath $aiDir -PathType Container)) { return }
  $stateDir = Join-Path -Path $aiDir -ChildPath "state"
  if (-not $WhatIf) { New-Item -ItemType Directory -Force -Path $stateDir -ErrorAction Stop | Out-Null }
  foreach ($fname in @("progress.md", "context.md", "next-steps.md")) {
    $oldPath = Join-Path -Path $aiDir -ChildPath $fname
    $newPath = Join-Path -Path $stateDir -ChildPath $fname
    if ((Test-Path -LiteralPath $oldPath -PathType Leaf) -and -not (Test-Path -LiteralPath $newPath -PathType Leaf)) {
      if (-not $WhatIf) {
        Move-Item -LiteralPath $oldPath -Destination $newPath -Force -ErrorAction Stop
        Add-Content -Path $newPath -Value "" -ErrorAction Stop
        Add-Content -Path $newPath -Value "[MIGRATION-$migrationDate] State files relocated from ai/ to ai/state/ per AGENTS.md TIER CONFIGURATION (resolve **Project AI State Files** to ai/state/)" -ErrorAction Stop
        Write-Action "  Migrated $fname to ai/state/"
      } else {
        Write-Action "  DRY-RUN: would migrate $fname to ai/state/"
      }
    } elseif ((Test-Path -LiteralPath $oldPath -PathType Leaf) -and (Test-Path -LiteralPath $newPath -PathType Leaf)) {
      Write-Warning "  $fname exists in both ai/ and ai/state/ - skipped"
    }
  }
}

function Migrate-UserStore {
  param([string]$CustomizationFile)
  $userDir = Get-KeyValue -File $CustomizationFile -Key 'User AI Directory'
  if (-not $userDir) { $userDir = Join-Path -Path $env:USERPROFILE -ChildPath ".ai" }
  Write-Action "  User AI Directory: $userDir"
  if (-not (Test-BoundedPath -Path $userDir)) {
    Write-Warning "  PENDING: user store unreachable; project store continues: $userDir"
    return
  }
  $backup = Join-Path -Path $userDir -ChildPath "backups/scope-migration-$migrationDate/user"
  $src = Join-Path -Path $userDir -ChildPath "global-knowledge"  # LEGACY-GLOBAL
  $dest = Join-Path -Path $userDir -ChildPath "knowledge"
  if (Test-Path -LiteralPath $src) {
    Backup-Store -Src $src -Dest $backup -Label "user knowledge"
    Move-TreeMerge -Src $src -Dest $dest -Label "user knowledge"
  }
  $skills = Join-Path -Path $userDir -ChildPath "skills"
  if (-not (Test-Path -LiteralPath $skills)) {
    Write-Action "  Create user skills store: $skills"
    if (-not $WhatIf) { New-Item -ItemType Directory -Force -Path $skills -ErrorAction Stop | Out-Null }
  }
  $oldSettings = Join-Path -Path $userDir -ChildPath "settings/global-user-settings.md"  # LEGACY-GLOBAL
  if (Test-Path -LiteralPath $oldSettings -PathType Leaf) {  # LEGACY-GLOBAL
    Move-FileUnique -Src $oldSettings -DestDir (Join-Path -Path $userDir -ChildPath "settings") -Name "user-settings.md" -Label "user settings"  # LEGACY-GLOBAL
  }
  Write-Action "  User settings and backups stay in place."
  Write-Action "  Exempt repair directories: $userDir/knowledge-repair-backups/ and $userDir/settings-repair-backups/"
}

function Migrate-TeamStore {
  param([string]$CustomizationFile)
  $teamDir = Get-KeyValue -File $CustomizationFile -Key 'Team AI Directory'
  if (-not $teamDir) {
    Write-Action "  Team store: not configured"
    return
  }
  Write-Action "  Team AI Directory: $teamDir"
  if (-not (Test-BoundedPath -Path $teamDir)) {
    Write-Warning "  PENDING: team store unreachable; project store continues: $teamDir"
    return
  }
  $userDir = Get-KeyValue -File $CustomizationFile -Key 'User AI Directory'
  if (-not $userDir) { $userDir = Join-Path -Path $env:USERPROFILE -ChildPath ".ai" }
  $backup = Join-Path -Path $userDir -ChildPath "backups/scope-migration-$migrationDate/team"
  $dest = Join-Path -Path $teamDir -ChildPath "knowledge"
  # LEGACY-GLOBAL-START
  $oldA = Join-Path -Path $teamDir -ChildPath "team-knowledge"
  $oldB = Join-Path -Path $teamDir -ChildPath "lessons"
  # LEGACY-GLOBAL-END
  if (Test-Path -LiteralPath $oldA) {
    Backup-Store -Src $oldA -Dest $backup -Label "team knowledge"
    Move-TreeMerge -Src $oldA -Dest $dest -Label "team knowledge"
  }
  if (Test-Path -LiteralPath $oldB) {
    Backup-Store -Src $oldB -Dest $backup -Label "team lessons"
    Move-TreeMerge -Src $oldB -Dest $dest -Label "team lessons"
  }
  Write-Action "  Team store changes are left uncommitted; commit or open a PR in the team repository."
}

$discoveryErrors = @()
$foundFiles = @(
  Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue -ErrorVariable +discoveryErrors |
    Where-Object {
      $full = $_.FullName
      -not $full.Equals($srcPath, [System.StringComparison]::OrdinalIgnoreCase) -and
      -not $full.StartsWith($workflowDirFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
    }
)

if ($discoveryErrors.Count -gt 0) {
  Write-Warning "Some directories under $targetAbs could not be read; processing the matches that were found."
  $discoveryErrors | ForEach-Object { Write-Warning $_.Exception.Message }
}
if ($foundFiles.Count -eq 0 -and $discoveryErrors.Count -eq 0) {
  Write-Host "No AGENTS.md files found under $targetAbs"
  exit 0
}
if ($foundFiles.Count -eq 0 -and $discoveryErrors.Count -gt 0) { exit 2 }

Write-Host ""
Write-Host "Found $($foundFiles.Count) AGENTS.md file(s)"
Write-Host "------------------------------------------------------------"

$srcContent = [System.IO.File]::ReadAllText($srcPath)
$srcBytes = [System.Text.UTF8Encoding]::new($false).GetBytes($srcContent)
$sha = [System.Security.Cryptography.SHA256]::Create()
$srcHash = [Convert]::ToBase64String($sha.ComputeHash($srcBytes))
$failedTargets = @()

foreach ($m in $foundFiles) {
  $target = $m.FullName
  $targetRoot = Split-Path -Parent $target
  Write-Host "Target: $target"
  try {
    $ErrorActionPreference = 'Stop'
    Test-TargetInitialized -ProjectRoot $targetRoot
    $customizationFile = Join-Path -Path $targetRoot -ChildPath "ai-customization.md"

    $targetBytes = [System.IO.File]::ReadAllBytes($target)
    $targetHash = [Convert]::ToBase64String($sha.ComputeHash($targetBytes))
    if ($srcHash -eq $targetHash) {
      Write-Host "  AGENTS.md already up to date"
    } elseif ($WhatIf) {
      Write-Host "  DRY-RUN: would update $target from source"
    } else {
      [System.IO.File]::WriteAllText($target, $srcContent, [System.Text.UTF8Encoding]::new($false))
      Write-Host "  AGENTS.md synced"
    }

    Ensure-CustomizationFile -ProjectRoot $targetRoot -WorkflowDir $workflowDirFull
    Migrate-StateFiles -ProjectRoot $targetRoot
    Migrate-ProjectStore -ProjectRoot $targetRoot
    Migrate-UserStore -CustomizationFile $customizationFile
    Migrate-TeamStore -CustomizationFile $customizationFile
  } catch {
    Write-Host "  ERROR: $($_.Exception.Message)"
    $failedTargets += $target
  }
  Write-Host "------------------------------------------------------------"
}

Write-Host ""
Write-Host "Processed $($foundFiles.Count) target(s); $($failedTargets.Count) failed."
if ($failedTargets.Count -gt 0) {
  Write-Host "Failed targets:"
  foreach ($target in $failedTargets) { Write-Host "  $target" }
}
if ($discoveryErrors.Count -gt 0) {
  Write-Host "Discovery failure: some directories could not be read."
  exit 2
}
if ($failedTargets.Count -gt 0) { exit 1 }
Write-Host "Done."
