#!/bin/bash
# Fixture for the repair global settings procedure and policy.
# shellcheck disable=SC2016
# Usage: ./tests/test-global-settings-repair-fixture.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

present() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s\n' "$label"
        fail=1
    fi
}

absent() {
    local file="$1" text="$2" label="$3"
    if grep -qF -- "$text" "$file" 2>/dev/null; then
        printf 'FAIL %s\n' "$label"
        fail=1
    else
        printf 'PASS %s\n' "$label"
    fi
}

POLICY="$ROOT/ai/policies/ai-policy-global-settings.md"
PROC="$ROOT/ai/procedures/repair-global-settings.md"
TPL="$ROOT/docs/global-user-settings.md"

present "$POLICY" "# AI Policy: Global User Settings" "policy title"
present "$POLICY" "- Mode: procedure" "policy loading mode"
present "$POLICY" "- Load in: repair-global-settings" "policy load path"
present "$POLICY" '`Name`' "policy names the identity key"
present "$POLICY" '`Default Shell Path`' "policy names the shell key"
present "$POLICY" '`Sensitive Names`' "policy names the sensitive list"
present "$POLICY" "command -v" "policy verifies tools on Unix"
present "$POLICY" "Get-Command" "policy verifies tools on Windows"
present "$POLICY" "settings-repair-backups" "policy sets the backup path"
present "$POLICY" "removed as a dead tool" "policy defines the dead-tool disposition"
present "$POLICY" "byte-for-byte" "policy leaves a compact file unchanged"
absent "$POLICY" "### Style Sources" "policy drops the Style Sources section"
absent "$POLICY" "Universal git conventions live" "policy drops the git pointer"

present "$PROC" "# PROCEDURE REPAIR-GLOBAL-SETTINGS" "procedure title"
present "$PROC" "- repair global settings" "procedure trigger"
present "$PROC" "- tidy global settings" "procedure tidy trigger"
present "$PROC" "- heal global settings" "procedure heal trigger"
present "$PROC" "STEP-BACKUP-SETTINGS" "procedure backup step"
present "$PROC" "STEP-REVIEW-SETTINGS-REPAIR" "procedure review step"

present "$TPL" "## Identity" "template identity section"
present "$TPL" "## Profile" "template profile section"
present "$TPL" "## Communication" "template communication section"
present "$TPL" "## Default Shell Path" "template shell section"
present "$TPL" "## Tools" "template tools section"
present "$TPL" "## Operating Instructions" "template operating section"
present "$TPL" "## Sensitive Names" "template sensitive section"
present "$TPL" '**Name**' "template identity name label"
present "$TPL" '**Email**' "template identity email label"
absent "$TPL" "Style Sources" "template drops Style Sources"
absent "$TPL" "Universal git conventions live" "template drops the git pointer"

present "$ROOT/support-files/validate-protocol.sh" "POLICY_FLOOR=24" "validator floor is 24"
present "$ROOT/ai/shared/project-knowledge/protocol-verification-toolchain.md" "24 policies (12 domain and 12 protocol)" "toolchain note policy count"
present "$ROOT/ai/shared/project-knowledge/protocol-verification-toolchain.md" "15 procedures, 121 steps" "toolchain note procedure count"
test_count=$(find "$ROOT/tests" -maxdepth 1 -name 'test-*.sh' -print | wc -l | tr -d ' ')
present "$ROOT/ai/shared/project-knowledge/protocol-verification-toolchain.md" "$test_count test scripts" "toolchain note test count"
present "$ROOT/ai/shared/project-knowledge/protocol-verification-toolchain.md" "50 triggers" "toolchain note trigger count"

# Simulated consolidation over a bloated fixture.
WORK="$(mktemp -d)"
# shellcheck disable=SC2329
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

cat > "$WORK/bloated.md" <<'EOF'
# User Settings

## Identity
- **Name**: Test Person
- **Email**: test@example.com

## Communication and Writing Style

### Voice
Write like a person.

### Style Sources
Distilled from old articles.

## Git Conventions

Universal git conventions live in the common policy. Add only user-specific overrides here.

- Always use your own name and email.

## CLI Tools

- **`deadtool`**: /nonexistent/deadtool
- **`rg`**: /usr/bin/rg

## Sensitive Names To Never Commit

- Example Name
EOF

# Apply the documented rules: keep the identity, the git override, and live tools;
# drop Style Sources, the git pointer, dead tools, and the old heading.
awk '
  /^### Style Sources$/ { skip=1; next }
  skip && /^$/ { skip=0; next }
  skip { next }
  /^Universal git conventions live/ { next }
  /^## Sensitive Names To Never Commit$/ { print "## Sensitive Names"; next }
  /deadtool/ { next }
  { print }
' "$WORK/bloated.md" > "$WORK/repaired.md"

present "$WORK/repaired.md" "**Name**: Test Person" "fixture keeps the name"
present "$WORK/repaired.md" "**Email**: test@example.com" "fixture keeps the email"
present "$WORK/repaired.md" "Always use your own name and email." "fixture keeps the git override"
present "$WORK/repaired.md" "**\`rg\`**: /usr/bin/rg" "fixture keeps a live tool"
present "$WORK/repaired.md" "## Sensitive Names" "fixture renames the sensitive heading"
absent "$WORK/repaired.md" "Style Sources" "fixture drops Style Sources"
absent "$WORK/repaired.md" "Universal git conventions live" "fixture drops the git pointer"
absent "$WORK/repaired.md" "deadtool" "fixture drops a dead tool"
absent "$WORK/repaired.md" "Sensitive Names To Never Commit" "fixture drops the old heading"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: global settings repair fixture."
    exit 1
fi
echo "PASSED: global settings repair fixture."
exit 0
