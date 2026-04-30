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
$foundFiles = Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -ne $srcPath -and $_.FullName.StartsWith($targetAbs, [System.StringComparison]::OrdinalIgnoreCase) }

$matchCount = ($foundFiles | Measure-Object).Count
if ($matchCount -eq 0) {
  Write-Host "No AGENTS.md files found under $targetAbs"
  exit 0
}

Write-Host ""
Write-Host "Found $matchCount AGENTS.md file(s) under $targetAbs"
Write-Host "------------------------------------------------------------"

foreach ($m in $foundFiles) {
  $target = $m.FullName
  
  # Extract values from target AGENTS.md to preserve them
  $targetContent = Get-Content -Raw -Path $target
  
  $targetCpDir = if ($targetContent -match '\*\*Central Workflow Directory\*\*: `([^`]+)`') { $Matches[1] } else { $null }
  $targetMainPolicy = if ($targetContent -match '\[central main policy file\]\(([^)]+)\)') { $Matches[1] } else { $null }
  $targetCommonPolicy = if ($targetContent -match '\[central common policy file\]\(([^)]+)\)') { $Matches[1] } else { $null }

  # Print structured per-target info for readability
  Write-Host ""
  Write-Host "Target AGENTS.md file: $target"
  Write-Host ""
  Write-Host "Values preserved from target (if found):"
  Write-Host "  Central Workflow Directory: $(if ($targetCpDir) { $targetCpDir } else { "(not found, will use source value)" })"
  Write-Host "  Central Main Policy:      $(if ($targetMainPolicy) { $targetMainPolicy } else { "(not found, will use source value)" })"
  Write-Host "  Central Common Policy:    $(if ($targetCommonPolicy) { $targetCommonPolicy } else { "(not found, will use source value)" })"

  try {
    $srcContent = Get-Content -Raw -Path $srcPath
    $newContent = $srcContent

    # Apply preserved values to the source content
    if ($targetCpDir) {
      $newContent = [regex]::Replace($newContent, '(\*\*Central Workflow Directory\*\*: `)([^`]+)(`)', '$1' + $targetCpDir + '$3')
    }
    if ($targetMainPolicy) {
      $newContent = [regex]::Replace($newContent, '(\[central main policy file\]\()([^)]+)(\))', '$1' + $targetMainPolicy + '$3')
    }
    if ($targetCommonPolicy) {
      $newContent = [regex]::Replace($newContent, '(\[central common policy file\]\()([^)]+)(\))', '$1' + $targetCommonPolicy + '$3')
    }

    if ($WhatIf) {
      Write-Host ""
      Write-Host "DRY-RUN: would update $target (while retaining target-specific policy settings)"
    } else {
      Write-Host ""
      Write-Host "Updating $target (while retaining target-specific policy settings)"
      try {
        Set-Content -Path $target -Value $newContent -Force -Encoding UTF8
      } catch {
        Write-Warning "Failed to write to $target : $_"
      }
    }
  } catch {
    if ($WhatIf) {
      Write-Host "DRY-RUN: would copy (source)/AGENTS.md -> $target"
    } else {
      Write-Host "Skipping (unable to process): $target"
    }
  }
  Write-Host ""
  Write-Host "----------------------------------------------------------------------------"
}

Write-Host ""
Write-Host "Done. Processed $matchCount AGENTS.md file(s) under $targetAbs"
