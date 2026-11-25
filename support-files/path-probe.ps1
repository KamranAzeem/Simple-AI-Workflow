<#
.SYNOPSIS
  Bounded reachability check for a configured User AI Directory or Team AI Directory.
.DESCRIPTION
  Exit 0: reachable; 1: not reachable; 124: timeout; 2: no bounded mechanism.
#>
param(
  [Parameter(Mandatory = $true)][string]$Path
)

$timeout = 3
if ($env:PATH_PROBE_TIMEOUT) {
  $parsed = 0
  if ([int]::TryParse($env:PATH_PROBE_TIMEOUT, [ref]$parsed) -and $parsed -gt 0) { $timeout = $parsed }
}

if (-not (Get-Command Start-Job -ErrorAction SilentlyContinue)) {
  Write-Error "PENDING: bounded check unavailable"
  exit 2
}

try {
  $job = Start-Job -ScriptBlock {
    param($p)
    Get-ChildItem -LiteralPath $p -Force -ErrorAction Stop | Select-Object -First 1 | Out-Null
  } -ArgumentList $Path
  $done = Wait-Job -Job $job -Timeout $timeout
  if ($null -eq $done -or $job.State -eq 'Running') {
    Stop-Job -Job $job -ErrorAction SilentlyContinue
    Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
    exit 124
  }
  Receive-Job -Job $job -ErrorAction SilentlyContinue | Out-Null
  Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
  exit 0
} catch {
  exit 1
}
