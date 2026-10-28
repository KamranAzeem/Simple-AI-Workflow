<#
.SYNOPSIS
  Sync AGENTS.md from a source into project directories, then ensure each
  target has a properly configured ai-customization.md at its project root.
  Automatically migrates from the old ai/ai-customization.md location.

.DESCRIPTION
  Recursively finds files named AGENTS.md under a root path and replaces them
  while updating the target's ai-customization.md with the correct workflow
  directory path. The workflow directory is derived from the script location,
  not from the source path. The workflow clone itself is excluded, identical
  files are skipped, and a failed target does not stop the remaining targets.

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

$scriptDir = $PSScriptRoot
$workflowDir = Split-Path -Parent $scriptDir
$sepChars = [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
$workflowDirFull = (Get-Item -LiteralPath $workflowDir -Force).FullName.TrimEnd($sepChars)

if (-not $srcPath.StartsWith($workflowDirFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
  Write-Warning "Source $srcPath is outside the workflow clone $workflowDirFull; the clone root still drives the config and exclusion."
}

Write-Host "Source: $srcPath"
Write-Host "Workflow directory: $workflowDirFull"
Write-Host "Searching under: $targetAbs"

$discoveryErrors = @()
$foundFiles = @(
  Get-ChildItem -Path $targetAbs -Recurse -Filter AGENTS.md -File -ErrorAction SilentlyContinue -ErrorVariable +discoveryErrors |
    Where-Object {
      $full = $_.FullName
      -not $full.Equals($srcPath, [System.StringComparison]::OrdinalIgnoreCase) -and
      -not $full.StartsWith(
        $workflowDirFull + [System.IO.Path]::DirectorySeparatorChar,
        [System.StringComparison]::OrdinalIgnoreCase
      )
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
if ($foundFiles.Count -eq 0 -and $discoveryErrors.Count -gt 0) {
  exit 2
}

Write-Host ""
Write-Host "Found $($foundFiles.Count) AGENTS.md file(s)"
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

  $custItem = Get-Item -LiteralPath $customizationFile -Force -ErrorAction SilentlyContinue
  $custIsLink = ($null -ne $custItem) -and (($custItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)

  # CASE A: old ai/ location exists
  if (Test-Path -Path $oldFile -PathType Leaf) {
    if ($custIsLink) {
      # Symlinked root: keep the link and edit the target. Do not rename the real file.
      Write-Host "  ai-customization.md: symlink detected; keeping the link and updating the target"
    } elseif (Test-Path -Path $customizationFile -PathType Leaf) {
      Write-Host "  WARNING: both $oldFile and $customizationFile exist."
      Write-Host "  Renaming $oldFile to ai-customization.md.bak"
      if (-not $WhatIf) {
        Move-Item -Path $oldFile -Destination $bakFile -Force -ErrorAction Stop
      }
      return
    } else {
      Write-Host "  Moving $oldFile to $customizationFile and adding config section"
      if (-not $WhatIf) {
        Move-Item -Path $oldFile -Destination $customizationFile -Force -ErrorAction Stop
        $content = Get-Content -Raw -Path $customizationFile -ErrorAction Stop
        $configSection = Get-ConfigSection -WorkflowDir $WorkflowDir
        # Insert config section after the first line (# AI Customization)
        $lines = $content -split "`n"
        if ($lines.Count -ge 1) {
          $newContent = $lines[0] + $configSection + "`n" + ($lines[1..($lines.Count-1)] -join "`n")
          [System.IO.File]::WriteAllText($customizationFile, $newContent, [System.Text.UTF8Encoding]::new($false))
        }
      }
      return
    }
  }

  # CASE C: root customization file exists
  if (Test-Path -Path $customizationFile -PathType Leaf) {
    $content = Get-Content -Raw -Path $customizationFile -ErrorAction Stop
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
          if (-not $newContent.Contains($expectedLine)) {
            throw "Failed to update the workflow directory path in $customizationFile"
          }
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
      New-Item -ItemType Directory -Force -Path $stateDir -ErrorAction Stop | Out-Null
    }
    foreach ($fname in $oldFiles) {
      $oldPath = Join-Path -Path $aiDir -ChildPath $fname
      $newPath = Join-Path -Path $stateDir -ChildPath $fname
      if ((Test-Path -Path $oldPath -PathType Leaf) -and -not (Test-Path -Path $newPath -PathType Leaf)) {
        if (-not $WhatIf) {
          Move-Item -Path $oldPath -Destination $newPath -Force -ErrorAction Stop
          Add-Content -Path $newPath -Value "" -ErrorAction Stop
          Add-Content -Path $newPath -Value "[MIGRATION-$(Get-Date -Format 'yyyy-MM-dd')] State files relocated from ai/ to ai/state/ per AGENTS.md TIER CONFIGURATION (resolve **Project AI State Files** to ai/state/)" -ErrorAction Stop
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
    if ($WhatIf) {
      $targetBytes = [System.IO.File]::ReadAllBytes($target)
      $targetHash = [Convert]::ToBase64String($sha.ComputeHash($targetBytes))
      if ($srcHash -eq $targetHash) {
        Write-Host "  AGENTS.md already up to date"
      } else {
        Write-Host "  DRY-RUN: would update $target from source"
        Write-Host "  (AGENTS.md sync)"
      }
    } else {
      $targetBytes = [System.IO.File]::ReadAllBytes($target)
      $targetHash = [Convert]::ToBase64String($sha.ComputeHash($targetBytes))
      if ($srcHash -eq $targetHash) {
        Write-Host "  AGENTS.md already up to date"
      } else {
        [System.IO.File]::WriteAllText($target, $srcContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  AGENTS.md synced"
      }
    }

    # Step 2: Migrate state files from ai/ to ai/state/ if needed
    Ensure-StateFilesMigration -ProjectRoot $targetRoot

    # Step 3: Ensure ai-customization.md has correct workflow directory
    Ensure-CustomizationFile -ProjectRoot $targetRoot -WorkflowDir $workflowDirFull
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
  foreach ($target in $failedTargets) {
    Write-Host "  $target"
  }
}
if ($discoveryErrors.Count -gt 0) {
  Write-Host "Discovery failure: some directories could not be read."
  exit 2
}
if ($failedTargets.Count -gt 0) {
  exit 1
}
Write-Host "Done."
