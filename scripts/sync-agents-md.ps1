<#
.SYNOPSIS
  Sync AGENTS.md from a source into project directories that contain an older AGENTS.md

.DESCRIPTION
  Recursively finds files named AGENTS.md under a root path and replaces them if the
  source AGENTS.md is newer. Supports a WhatIf (dry-run) mode.

USAGE
  ./sync-agents-md.ps1 -Source ../AGENTS.md -Root C:\Projects -WhatIf
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

# Resolve absolute source path
try {
  $srcPath = (Resolve-Path -Path $Source -ErrorAction Stop).Path
} catch {
  Write-Error "Failed to resolve source path: $Source"
  exit 2
}

# Canonicalize target path
try {
  $targetAbs = (Resolve-Path -Path $TargetPath -ErrorAction Stop).Path
} catch {
  Write-Error "Target path not found or not a directory: $TargetPath"
  exit 2
}

Write-Host "Source: $srcPath"
Write-Host ""
Write-Host "Searching under: $targetAbs"

$srcInfo = Get-Item $srcPath

# Collect matches strictly under the canonical target path
$matches = Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -ne $srcPath -and $_.FullName.StartsWith($targetAbs, [System.StringComparison]::OrdinalIgnoreCase) }

$matchCount = ($matches | Measure-Object).Count
if ($matchCount -eq 0) {
  Write-Host "No AGENTS.md files found under $targetAbs"
  exit 0
}

Write-Host ""
Write-Host "Found $matchCount AGENTS.md file(s) under $targetAbs"
Write-Host "------------------------------------------------------------"

foreach ($m in $matches) {
  $target = $m.FullName
  # If source is newer than target, copy (or dry-run)
  # Compare contents (hash) first; if different -> copy, otherwise report already identical
  try {
    $srcHash = Get-FileHash -Path $srcPath -Algorithm SHA256
    $tgtHash = Get-FileHash -Path $target -Algorithm SHA256
    if ($srcHash.Hash -eq $tgtHash.Hash) {
      Write-Host "Already identical: $target"
    } else {
      if ($WhatIf) {
        Write-Host ""
        Write-Host "DRY-RUN: would copy (source)/AGENTS.md -> $target"
      } else {
        Write-Host ""
        Write-Host "Copying (source)/AGENTS.md -> $target"
        try {
          Copy-Item -Path $srcPath -Destination $target -Force -ErrorAction Stop
        } catch {
          Write-Warning "Failed to copy to $target : $_"
        }
      }
    }
  } catch {
    # If hashing fails, fall back to a conservative skip (or dry-run copy)
    if ($WhatIf) {
      Write-Host "DRY-RUN: would copy (source)/AGENTS.md -> $target"
    } else {
      Write-Host "Skipping (unable to compare): $target"
    }
  }
}
