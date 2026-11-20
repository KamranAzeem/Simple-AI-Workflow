<#
.SYNOPSIS
  Back up workflow project AI state without an AI assistant.

.DESCRIPTION
  Walks a search path, finds every project marked by ai-customization.md or by
  ai/state/ plus ai/shared/, and writes one tar.gz per project into the backup
  directory. The workflow clone itself is skipped. A project is never rescanned,
  and .git is not descended.

.PARAMETER TargetPath
  Directory to search for projects.

.PARAMETER BackupDir
  Archive destination. Defaults to $HOME/.ai/backups.

.PARAMETER ExcludeSecrets
  Leave ai/secrets/ out of the archive.

.EXAMPLE
  ./backup-ai.ps1 -TargetPath C:\Users\me\Projects -BackupDir D:\backups -WhatIf

.EXAMPLE
  ./backup-ai.ps1 -TargetPath C:\Users\me\Projects
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [Parameter(Mandatory = $true)]
  [string]$TargetPath,
  [string]$BackupDir,
  [switch]$ExcludeSecrets
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Fail([string]$message) {
  [Console]::Error.WriteLine("Error: $message")
  exit 2
}

if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
  Fail "Target path is not a directory: $TargetPath"
}

try {
  $targetAbs = (Resolve-Path -LiteralPath $TargetPath -ErrorAction Stop).Path
} catch {
  Fail "Target path cannot be accessed: $TargetPath"
}

$scriptDir = $PSScriptRoot
$workflowDir = Split-Path -Parent $scriptDir
$sepChars = [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
$workflowFull = (Get-Item -LiteralPath $workflowDir -Force).FullName.TrimEnd($sepChars)

if (-not $BackupDir) {
  $homeDir = $HOME
  if (-not $homeDir) { $homeDir = $env:USERPROFILE }
  if (-not $homeDir) { Fail "HOME is not set; use -BackupDir." }
  $BackupDir = Join-Path (Join-Path $homeDir '.ai') 'backups'
}

$tar = Get-Command tar.exe -ErrorAction SilentlyContinue
if (-not $tar) {
  Fail "tar.exe is required but was not found."
}

$script:discoveryFailed = $false
$script:archived = 0
$script:failed = 0
$script:warnings = 0
$script:planned = 0
$script:pruneNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($name in @('.git', 'node_modules', '.venv', 'venv', 'vendor', 'target', 'build', 'dist', '.next', '.cache', '__pycache__', '.terraform')) {
  [void]$script:pruneNames.Add($name)
}

function Test-IsUnderWorkflow([string]$path) {
  $full = (Get-Item -LiteralPath $path -Force).FullName.TrimEnd($sepChars)
  if ($full -eq $workflowFull) { return $true }
  $prefix = $workflowFull + [System.IO.Path]::DirectorySeparatorChar
  return $full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
}

function Test-IsProject([string]$dir) {
  $custom = Join-Path $dir 'ai-customization.md'
  if (Test-Path -LiteralPath $custom) { return $true }
  $link = Get-Item -LiteralPath $custom -Force -ErrorAction SilentlyContinue
  if ($null -ne $link) { return $true }
  $state = Join-Path (Join-Path $dir 'ai') 'state'
  $shared = Join-Path (Join-Path $dir 'ai') 'shared'
  return (Test-Path -LiteralPath $state -PathType Container) -and (Test-Path -LiteralPath $shared -PathType Container)
}

function Get-ProjectDirs([string]$path) {
  $stack = [System.Collections.Generic.Stack[string]]::new()
  $stack.Push($path)
  while ($stack.Count -gt 0) {
    $dir = $stack.Pop()
    $errs = @()
    $children = Get-ChildItem -LiteralPath $dir -Directory -Force -ErrorAction SilentlyContinue -ErrorVariable +errs
    if ($errs.Count -gt 0) {
      Write-Warning "Some directories under $dir could not be read; processing the matches that were found."
      $script:discoveryFailed = $true
    }
    foreach ($child in $children) {
      if ($script:pruneNames.Contains($child.Name)) { continue }
      if ($child.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { continue }
      if (Test-IsUnderWorkflow $child.FullName) { continue }
      if (Test-IsProject $child.FullName) {
        Write-Host "Found project: $($child.FullName)"
        Write-Output $child.FullName
        continue
      }
      $stack.Push($child.FullName)
    }
  }
}

function Get-SafeComponent([string]$value) {
  $clean = $value -replace '[^A-Za-z0-9._-]', '_'
  if (-not $clean) { return '_' }
  return $clean
}

$stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm'

function Get-ArchivePath([string]$project) {
  $parent = Get-SafeComponent (Split-Path -Leaf (Split-Path -Parent $project))
  $name = Get-SafeComponent (Split-Path -Leaf $project)
  return (Join-Path $BackupDir "${parent}_${name}_${stamp}.tar.gz")
}

function Invoke-ArchiveProject([string]$project) {
  $out = Get-ArchivePath $project
  if ($WhatIfPreference) {
    Write-Host "DRY-RUN: would archive $project -> $out"
    return $true
  }
  if (Test-Path -LiteralPath $out) {
    Write-Warning "FAILED: archive already exists: $out"
    return $false
  }

  Write-Host "Backing up: $project"

  $stage = $null
  $customDir = $null
  $custom = Join-Path $project 'ai-customization.md'
  if (Test-Path -LiteralPath $custom) {
    $item = Get-Item -LiteralPath $custom -Force
    if ($item.LinkType) {
      $stage = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
      New-Item -ItemType Directory -Path $stage | Out-Null
      Copy-Item -LiteralPath $custom -Destination (Join-Path $stage 'ai-customization.md') -Force
      $customDir = $stage
    } else {
      $customDir = $project
    }
  } elseif ($null -ne (Get-Item -LiteralPath $custom -Force -ErrorAction SilentlyContinue)) {
    Write-Warning "FAILED: cannot read the customization file in $project"
    return $false
  }

  $ai = Join-Path $project 'ai'
  $hasContent = $false
  $tarArgs = @('-czf', $out)
  if ($ExcludeSecrets) { $tarArgs += '--exclude=ai/secrets' }
  if (Test-Path -LiteralPath $ai -PathType Container) {
    $tarArgs += @('-C', $project, 'ai')
    $hasContent = $true
  }
  if ($customDir) {
    $tarArgs += @('-C', $customDir, 'ai-customization.md')
    $hasContent = $true
  }
  if (-not $hasContent) {
    Write-Warning "FAILED: nothing to archive in $project"
    if ($stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
    return $false
  }

  & tar.exe @tarArgs
  if ($LASTEXITCODE -ne 0) {
    if (Test-Path -LiteralPath $out) { Remove-Item -LiteralPath $out -Force }
    Write-Warning "FAILED: tar failed for $project"
    if ($stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
    return $false
  }
  if ($stage) { Remove-Item -LiteralPath $stage -Recurse -Force }

  $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
  & icacls.exe $out /inheritance:r /grant:r "${identity}:(F)" | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "WARNING: archive kept but not restricted to the owner: $out"
    $script:warnings++
  }

  Write-Host "Backed up: $project -> $out"
  return $true
}

Write-Host "Scanning $targetAbs for workflow projects"
if (-not (Test-IsUnderWorkflow $targetAbs) -and (Test-IsProject $targetAbs)) {
  Write-Host "Found project: $targetAbs"
  $projects = @($targetAbs)
} elseif (Test-IsUnderWorkflow $targetAbs) {
  $projects = @()
} else {
  $projects = @(Get-ProjectDirs $targetAbs)
}

if (-not $WhatIfPreference) {
  if (-not (Test-Path -LiteralPath $BackupDir -PathType Container)) {
    try {
      New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
      Write-Host "Created backup directory: $BackupDir"
    } catch {
      Fail "Cannot create the backup directory: $BackupDir"
    }
  }
}

if ($projects.Count -eq 0) {
  Write-Host "No projects found under $targetAbs"
}

foreach ($project in $projects) {
  if ($WhatIfPreference) {
    [void](Invoke-ArchiveProject $project)
    $script:planned++
  } elseif (Invoke-ArchiveProject $project) {
    $script:archived++
  } else {
    $script:failed++
  }
}

if ($WhatIfPreference) {
  Write-Host "Summary: $script:planned projects would be archived; archives in $BackupDir"
} else {
  Write-Host "Summary: $script:archived archived, $script:failed failed, $script:warnings warnings; archives in $BackupDir"
}

if ($script:discoveryFailed) { exit 2 }
if ($script:failed -gt 0 -or $script:warnings -gt 0) { exit 1 }
exit 0
