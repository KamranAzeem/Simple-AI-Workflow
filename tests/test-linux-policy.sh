#!/bin/bash
# Dev-time fixture for the Linux policy rewrite: the expertise loading and the rule anchors.
# Usage: ./tests/test-linux-policy.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POLICY="$ROOT/ai/policies/ai-policy-linux-system-admin.md"
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
present "Filesystem Hierarchy Standard" "rule: FHS"
present "apt, yum, dnf, pacman" "rule: package managers"
present "systemd" "rule: systemd"
present "SELinux/AppArmor" "rule: mandatory access control"
present "journald and logrotate" "rule: log management"
present "shellcheck" "rule: shellcheck"
present "bats" "rule: bats"
present "systemd-analyze verify" "rule: systemd syntax check"
present "visudo -c" "rule: sudoers syntax check"
present "RTO/RPO" "rule: recovery targets"
present "CIS Benchmarks" "rule: CIS reference"
present "NIST SP 800-53" "rule: NIST reference"

index_out="$(bash "$VALIDATOR" --index "$POLICY" 2>&1)"
if printf '%s\n' "$index_out" | grep -q '|linux-system-admin|'; then
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
    echo "FAILED: Linux policy fixture."
    exit 1
fi
echo "PASSED: Linux policy fixture."
exit 0
