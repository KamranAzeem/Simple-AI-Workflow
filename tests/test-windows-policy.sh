#!/bin/bash
# Dev-time fixture for the Windows policy rewrite: the expertise loading and the rule anchors.
# Usage: ./tests/test-windows-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-windows-system-admin.md"
VALIDATOR="$ROOT/support-files/validate-policy-authoring.sh"
fail=0

present() {
    local text="$1" label="$2"
    if grep -qF -- "$text" "$POLICY" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

present "## Loading" "policy declares its loading"
present "- Mode: expertise" "policy declares the expertise mode"
present "## Role: Windows System Administrator" "role section"
present "## Microsoft Frameworks and Standards" "frameworks section"
present "## PowerShell Standards" "PowerShell section"
present "## Active Directory and Identity" "AD section"
present "## Security Operations" "security operations section"
present "## Testing and Validation" "testing section"
present "Security Compliance Toolkit" "framework: SCT"
present "CIS Benchmarks" "framework: CIS"
present "DISA STIG" "framework: DISA STIG"
present "Zero Trust" "framework: Zero Trust"
present "Cloud Adoption Framework" "framework: CAF"
present "Secure Score" "framework: Secure Score"
present "Intune" "framework: Intune"
present "MECM" "framework: MECM"
present "Windows Admin Center" "framework: WAC"
present "Desired State Configuration" "framework: DSC"
present "Get-Verb" "PowerShell: approved verbs"
present "Set-StrictMode" "PowerShell: strict mode"
present "ErrorActionPreference" "PowerShell: error handling"
present "UTF8Encoding" "PowerShell: BOM-less encoding"
present "-WhatIf" "PowerShell: WhatIf"
present "RemoteSigned" "PowerShell: execution policy"
present "5986" "remoting: HTTPS port"
present "JEA" "remoting: JEA"
present "Protected Users" "AD: protected users"
present "LAPS" "AD: LAPS"
present "Tier 0" "AD: tiered model"
present "Gpresult" "GPO: verification"
present "SMBv1" "hardening: SMBv1"
present "NTLMv2" "hardening: NTLMv2"
present "Credential Guard" "hardening: Credential Guard"
present "BitLocker" "hardening: BitLocker"
present "Privileged Identity Management" "JIT: PIM"
present "PSScriptAnalyzer" "testing: PSScriptAnalyzer"
present "Pester" "testing: Pester"
present "Test-DscConfiguration" "testing: DSC"
present "canary" "testing: canary ring"
present "## References" "references section"
present "NIST SP 800-53" "reference: NIST"

index_out="$(bash "$VALIDATOR" --index "$POLICY" 2>&1)"
if printf '%s\n' "$index_out" | grep -q '|windows-system-admin|'; then
    if printf '%s\n' "$index_out" | grep -q 'mode=expertise'; then
        printf 'PASS index reports the expertise mode\n'
    else
        printf 'FAIL index does not report the expertise mode\n'
        printf '%s\n' "$index_out"
        fail=1
    fi
else
    printf 'FAIL index does not list the policy\n'
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: Windows policy fixture."
    exit 1
fi
echo "PASSED: Windows policy fixture."
exit 0
