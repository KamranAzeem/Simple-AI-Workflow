#!/bin/bash
# Fixture for the bounded path probe.
set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROBE="$ROOT/support-files/path-probe.sh"
PWSH_PROBE="$ROOT/support-files/path-probe.ps1"
WORK="$(mktemp -d /tmp/kilo/path-probe.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

fail=0
pass() { printf 'PASS %s\n' "$1"; }
fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

mkdir -p "$WORK/readable"

if bash "$PROBE" "$WORK/readable" >/dev/null 2>&1; then
    pass "existing directory exits 0"
else
    fail_case "existing directory exits 0"
fi

set +e
bash "$PROBE" "$WORK/missing" >/dev/null 2>&1
missing_rc=$?
set -e
if [ "$missing_rc" -eq 1 ]; then
    pass "missing directory exits 1"
else
    fail_case "missing directory exits 1 (got $missing_rc)"
fi

mkdir -p "$WORK/fakebin"
cat > "$WORK/fakebin/ls" <<'EOF'
#!/bin/bash
sleep 5
EOF
chmod +x "$WORK/fakebin/ls"
set +e
PATH="$WORK/fakebin:$PATH" PATH_PROBE_TIMEOUT=1 bash "$PROBE" "$WORK/readable" >/dev/null 2>&1
rc=$?
set -e
if [ "$rc" -eq 124 ]; then
    pass "slow listing exits 124"
else
    fail_case "slow listing exits 124 (got $rc)"
fi

if [ -f "$PWSH_PROBE" ]; then
    pass "PowerShell path probe exists"
else
    fail_case "PowerShell path probe exists"
fi
if grep -qF "Start-Job" "$PWSH_PROBE" && grep -qF "Wait-Job" "$PWSH_PROBE"; then
    pass "PowerShell path probe is bounded"
else
    fail_case "PowerShell path probe is bounded"
fi

if [ -x "$PROBE" ] || head -1 "$PROBE" | grep -q '^#!/'; then
    pass "POSIX path probe is executable or has a shebang"
else
    fail_case "POSIX path probe is executable or has a shebang"
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: path probe fixture."
    exit 1
fi
echo "PASSED: path probe fixture."
exit 0
