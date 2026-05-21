<#
.SYNOPSIS
  Sync AGENTS.md from a source into project directories that contain an older AGENTS.md

.DESCRIPTION
  Recursively finds files named AGENTS.md under a root path and replaces them while 
  preserving target-specific base directory settings.
  Updated for "Layer Cake" protocol (v3.0)

USAGE
  ./sync-agents-md.ps1 -Source ../AGENTS.md -TargetPath C:\Projects -WhatIf
#>

param(
  [string]$Source = "./AGENTS.md",
  [string]$TargetPath = ".",
  [switch]$WhatIf
)

Set-StrictMode -Version Latest

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

Write-Host "Source: $srcPath"
Write-Host "Searching under: $targetAbs"

$foundFiles = Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -ne $srcPath -and $_.FullName.StartsWith($targetAbs, [System.StringComparison]::OrdinalIgnoreCase) }

$matchCount = ($foundFiles | Measure-Object).Count
if ($matchCount -eq 0) {
  Write-Host "No AGENTS.md files found under $targetAbs"
  exit 0
}

Write-Host ""
Write-Host "Found $matchCount AGENTS.md file(s)"
Write-Host "------------------------------------------------------------"

$srcContent = Get-Content -Raw -Path $srcPath

foreach ($m in $foundFiles) {
  $target = $m.FullName
  Write-Host "Target: $target"
  
  $targetContent = Get-Content -Raw -Path $target
  
  # Extract Base Directories
  $targetWfDir = if ($targetContent -match '\*\*Global AI (Framework|Workflow) Directory\*\*: `([^`]+)`') { $Matches[2] } else { $null }
  $targetUserDir = if ($targetContent -match '\*\*Global User AI Directory\*\*: `([^`]+)`') { $Matches[1] } else { $null }

  # Fallback to older nomenclature
  if (-not $targetWfDir -and ($targetContent -match '\*\*Global Policies Directory\*\*: `([^`]+)`')) {
     $oldPath = $Matches[1]
     $targetWfDir = $oldPath -replace '\\ai\\policies\\?$', '' -replace '/ai/policies/?$', ''
  }

  Write-Host "  Preserved Workflow Dir: $(if ($targetWfDir) { $targetWfDir } else { "(using source)" })"
  Write-Host "  Preserved User AI Dir:   $(if ($targetUserDir) { $targetUserDir } else { "(using source)" })"

  try {
    $newContent = $srcContent

    if ($targetWfDir) {
      $newContent = [regex]::Replace($newContent, '(\*\*Global AI Workflow Directory\*\*: `)([^`]+)(`)', '$1' + $targetWfDir + '$3')
    }
    if ($targetUserDir) {
      $newContent = [regex]::Replace($newContent, '(\*\*Global User AI Directory\*\*: `)([^`]+)(`)', '$1' + $targetUserDir + '$3')
    }

    if ($WhatIf) {
      Write-Host "  DRY-RUN: would update $target"
    } else {
      Write-Host "  Updating $target"
      [System.IO.File]::WriteAllText($target, $newContent, [System.Text.UTF8Encoding]::new($false))
    }
  } catch {
    Write-Warning "  Failed to process $target : $_"
  }
  Write-Host "------------------------------------------------------------"
}

Write-Host ""
Write-Host "Done."
