<#
.SYNOPSIS
  Sync AGENTS.md from a source into project directories, then ensure each
  target has a properly configured ai-customization.md at its project root.
  Automatically migrates from the old ai/ai-customization.md location.

.DESCRIPTION
  Recursively finds files named AGENTS.md under a root path and replaces them
  while updating the target's ai-customization.md with the correct workflow
  directory path derived from the source location.

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

$workflowDir = Split-Path -Parent $srcPath

Write-Host "Source: $srcPath"
Write-Host "Workflow directory: $workflowDir"
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

function Get-ConfigSection {
  param([string]$WorkflowDir)
  @"

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: $WorkflowDir

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.
"@
}

function Get-DefaultCustomizationFile {
  param([string]$WorkflowDir)
  @"
# AI Customization

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: $WorkflowDir

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.

## Active Expertise
- web-frontend

## Active Traits
- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile); flag breaking changes in shared schemas or DTOs.

## Required Compliance
- gdpr
- iso-27001
"@
}

function Ensure-CustomizationFile {
  param([string]$ProjectRoot, [string]$WorkflowDir)

  $customizationFile = Join-Path -Path $ProjectRoot -ChildPath "ai-customization.md"
  $oldFile = Join-Path -Path $ProjectRoot -ChildPath "ai/ai-customization.md"
  $bakFile = Join-Path -Path $ProjectRoot -ChildPath "ai-customization.md.bak"
  $configHeader = "## AI Workflow Configuration"
  $configLinePattern = '\*\*Global AI Workflow Directory\*\*:'

  # CASE A: old ai/ location exists
  if (Test-Path -Path $oldFile -PathType Leaf) {
    if (Test-Path -Path $customizationFile -PathType Leaf) {
      Write-Host "  WARNING: both $oldFile and $customizationFile exist."
      Write-Host "  Renaming $oldFile to ai-customization.md.bak"
      if (-not $WhatIf) {
        Move-Item -Path $oldFile -Destination $bakFile -Force
      }
    } else {
      Write-Host "  Moving $oldFile to $customizationFile and adding config section"
      if (-not $WhatIf) {
        Move-Item -Path $oldFile -Destination $customizationFile -Force
        $content = Get-Content -Raw -Path $customizationFile
        $configSection = Get-ConfigSection -WorkflowDir $WorkflowDir
        # Insert config section after the first line (# AI Customization)
        $lines = $content -split "`n"
        if ($lines.Count -ge 1) {
          $newContent = $lines[0] + $configSection + "`n" + ($lines[1..($lines.Count-1)] -join "`n")
          [System.IO.File]::WriteAllText($customizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
        }
      }
    }
    return
  }

  # CASE C: root customization file exists
  if (Test-Path -Path $customizationFile -PathType Leaf) {
    $content = Get-Content -Raw -Path $customizationFile
    if ($content -match $configHeader) {
      # Check if the path is correct
      $expectedLine = "**Global AI Workflow Directory**: $WorkflowDir"
      if ($content -match [regex]::Escape($expectedLine)) {
        Write-Host "  ai-customization.md: config path is correct"
      } else {
        Write-Host "  ai-customization.md: updating workflow directory path"
        if (-not $WhatIf) {
          $newContent = $content -replace "$configLinePattern .*", "**Global AI Workflow Directory**: $WorkflowDir"
          [System.IO.File]::WriteAllText($customizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
        }
      }
    } else {
      Write-Host "  ai-customization.md: adding config section"
      if (-not $WhatIf) {
        $configSection = Get-ConfigSection -WorkflowDir $WorkflowDir
        $lines = $content -split "`n"
        if ($lines.Count -ge 1) {
          $newContent = $lines[0] + $configSection + "`n" + ($lines[1..($lines.Count-1)] -join "`n")
          [System.IO.File]::WriteAllText($customizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
        }
      }
    }
    return
  }

  # CASE D: no customization file exists — create one
  Write-Host "  ai-customization.md: creating with default configuration"
  if (-not $WhatIf) {
    $defaultContent = Get-DefaultCustomizationFile -WorkflowDir $WorkflowDir
    [System.IO.File]::WriteAllText($customizationFile, $defaultContent, [System.Text.UTF8Encoding]::new($false))
  }
}

function Ensure-StateFilesMigration {
  param([string]$ProjectRoot)

  $stateDir = Join-Path -Path $ProjectRoot -ChildPath "ai/state"
  $oldFiles = @("progress.md", "context.md", "next-steps.md")
  $aiDir = Join-Path -Path $ProjectRoot -ChildPath "ai"

  if (Test-Path -Path $aiDir -PathType Container) {
    if (-not $WhatIf) {
      New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
    }
    foreach ($fname in $oldFiles) {
      $oldPath = Join-Path -Path $aiDir -ChildPath $fname
      $newPath = Join-Path -Path $stateDir -ChildPath $fname
      if ((Test-Path -Path $oldPath -PathType Leaf) -and -not (Test-Path -Path $newPath -PathType Leaf)) {
        if (-not $WhatIf) {
          Move-Item -Path $oldPath -Destination $newPath -Force
          Add-Content -Path $newPath -Value ""
          Add-Content -Path $newPath -Value "[MIGRATION-$(Get-Date -Format 'yyyy-MM-dd')] State files relocated from ai/ to ai/state/ per AGENTS.md TIER 1 (resolve **Project AI State Files** to ai/state/)"
        }
        Write-Host "  Migrated $fname to ai/state/"
      } elseif ((Test-Path -Path $oldPath -PathType Leaf) -and (Test-Path -Path $newPath -PathType Leaf)) {
        Write-Host "  WARNING: $fname exists in both ai/ and ai/state/ - skipped"
      }
    }
  }
}

# Read source once; written BOM-less to each target (PS 5.1 Set-Content would add a BOM).
$srcContent = [System.IO.File]::ReadAllText($srcPath)

foreach ($m in $foundFiles) {
  $target = $m.FullName
  $targetRoot = Split-Path -Parent $target
  Write-Host "Target: $target"

  # Step 1: Copy source AGENTS.md to target (no path manipulation needed)
  if ($WhatIf) {
    Write-Host "  DRY-RUN: would update $target from source"
    Write-Host "  (AGENTS.md sync)"
  } else {
    [System.IO.File]::WriteAllText($target, $srcContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  AGENTS.md synced"
  }

  # Step 2: Migrate state files from ai/ to ai/state/ if needed
  Ensure-StateFilesMigration -ProjectRoot $targetRoot

  # Step 3: Ensure ai-customization.md has correct workflow directory
  Ensure-CustomizationFile -ProjectRoot $targetRoot -WorkflowDir $workflowDir

  Write-Host "------------------------------------------------------------"
}

Write-Host ""
Write-Host "Done."
