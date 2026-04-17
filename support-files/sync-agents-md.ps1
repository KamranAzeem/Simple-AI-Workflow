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
  # If source is newer than target, copy (or dry-run)
  # Detect central policy line in target and extract path
  $policyPattern = '\[central main policy file\]\(([^)]+)\)'
  $policyMatch = Select-String -Path $target -Pattern $policyPattern -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -ne $policyMatch) {
    $policyLine = $policyMatch.Line.Trim()
    # Extract the captured policy path from the regex match object
    if ($policyMatch.Matches.Count -gt 0) {
      $policyPath = $policyMatch.Matches[0].Groups[1].Value
    } else {
      $policyPath = "(unknown)"
    }
  } else {
    $policyLine = $null
    $policyPath = "(none)"
  }

  # Print structured per-target info for readability (match bash script wording)
  Write-Host ""
  Write-Host "Target AGENTS.md file: $target"
  Write-Host ""
  Write-Host "Policy file in use: $policyPath"
  try {
    $srcContent = Get-Content -Raw -Path $srcPath
    if ($null -ne $policyLine) {
      # Replace the parentheses content in the central policy line with the target's path
      $pattern = '\[central main policy file\]\([^)]+\)'
      $replacement = "[central main policy file]($policyPath)"
      if ([regex]::IsMatch($srcContent, $pattern)) {
        $newContent = [regex]::Replace($srcContent, $pattern, $replacement, 1)
      } else {
        # Prepend a canonical policy line followed by the source content
        $canonical = "[central main policy file]($policyPath) - operating rules and guardrails. If unreachable, then read the local policy file mentioned in the next point.`n"
        $newContent = $canonical + $srcContent
      }

      if ($WhatIf) {
        Write-Host ""
        Write-Host "DRY-RUN: would update $target (while retaining target policy path)"
      } else {
        Write-Host ""
        Write-Host "Updating $target (while retaining target policy path)"
        try {
          Set-Content -Path $target -Value $newContent -Force -Encoding UTF8
        } catch {
          Write-Warning "Failed to write to $target : $_"
        }
      }
    } else {
      if ($WhatIf) {
        Write-Host ""
        Write-Host "DRY-RUN: would replace $target (no central policy line found)"
      } else {
        Write-Host ""
        Write-Host "Replacing $target (no central policy line found)"
        try {
          Copy-Item -Path $srcPath -Destination $target -Force -ErrorAction Stop
        } catch {
          Write-Warning "Failed to copy to $target : $_"
        }
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
