#!/bin/bash
# Azure companion-architect exercise pack fixture.
# Usage: ./tests/test-azure-exercises.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACK="$ROOT/docs/exercises/azure-companion-architect"
README="$ROOT/README.md"
CORE="$PACK/reference/core.bicep"
HUB="$PACK/reference/hub-spoke.bicep"
LABS="lab-01-briefing lab-02-design lab-03-plan lab-04-build-verify-teardown lab-05-capstone-sysadmin lab-06-capstone-architect"
LABS_DESIGN="lab-01-briefing lab-02-design lab-03-plan"
LABS_BUILD="lab-04-build-verify-teardown lab-05-capstone-sysadmin lab-06-capstone-architect"

fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

require_file() {
    if [ -f "$1" ]; then
        pass "file exists: ${1#"$ROOT"/}"
    else
        fail_case "missing file: ${1#"$ROOT"/}"
    fi
}

for f in index.md prerequisites.md safety-and-teardown.md lab-01-briefing.md lab-02-design.md lab-03-plan.md lab-04-build-verify-teardown.md lab-05-capstone-sysadmin.md lab-06-capstone-architect.md reference/core.bicep reference/hub-spoke.bicep; do
    require_file "$PACK/$f"
done

for lab in $LABS; do
    f="$PACK/$lab.md"
    for heading in '## Scenario' '## Prerequisites' '## The prompt' '## Verification' '## Reflection'; do
        if grep -qF -- "$heading" "$f"; then
            pass "$lab has $heading"
        else
            fail_case "$lab missing $heading"
        fi
    done
done

for lab in $LABS_BUILD; do
    f="$PACK/$lab.md"
    if grep -qF -- '## Teardown' "$f"; then
        pass "$lab has a teardown section"
    else
        fail_case "$lab missing a teardown section"
    fi
done

for lab in $LABS_DESIGN; do
    f="$PACK/$lab.md"
    for bad in 'az deployment group create' 'az group create' 'az deployment group what-if'; do
        if grep -qF -- "$bad" "$f"; then
            fail_case "$lab must not contain: $bad"
        else
            pass "$lab avoids: $bad"
        fi
    done
done

money="$(grep -rniE '\b(cost|costs|pricing|price|prices|budget|usd|dollar)\b' "$PACK" --include='*.md' --include='*.bicep' 2>/dev/null || true)"
if [ -z "$money" ]; then
    pass "no money language in the pack"
else
    fail_case "money language in the pack"
    printf '%s\n' "$money"
fi

dollar="$(grep -rnE '\$[0-9]' "$PACK" --include='*.md' --include='*.bicep' 2>/dev/null || true)"
if [ -z "$dollar" ]; then
    pass "no currency amounts in the pack"
else
    fail_case "currency amount in the pack"
    printf '%s\n' "$dollar"
fi

guid="$(grep -rnE '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}' "$PACK" --include='*.md' 2>/dev/null || true)"
if [ -z "$guid" ]; then
    pass "no subscription or tenant identifier in the markdown"
else
    fail_case "GUID in the markdown"
    printf '%s\n' "$guid"
fi

secrets="$(grep -rniE '(client_secret|accountkey|connectionstring|begin openssh private key)' "$PACK" 2>/dev/null || true)"
if [ -z "$secrets" ]; then
    pass "no secret pattern in the pack"
else
    fail_case "secret pattern in the pack"
    printf '%s\n' "$secrets"
fi

pem="$(find "$PACK" -name '*.pem' -print 2>/dev/null || true)"
if [ -z "$pem" ]; then
    pass "no private key file in the pack"
else
    fail_case "private key file in the pack"
    printf '%s\n' "$pem"
fi

if grep -qF -- 'docs/exercises/azure-companion-architect/' "$README"; then
    pass "README links the pack"
else
    fail_case "README does not link the pack"
fi

for md in "$PACK"/*.md; do
    while IFS= read -r link; do
        case "$link" in
            http*|mailto:*|'#'*) continue ;;
        esac
        target="${link%%#*}"
        [ -z "$target" ] && continue
        if [ -e "$(dirname "$md")/$target" ]; then
            pass "link resolves: ${md#"$ROOT"/} -> $target"
        else
            fail_case "broken link: ${md#"$ROOT"/} -> $target"
        fi
    done < <(grep -oE '\]\([^)]+\)' "$md" | sed 's/^](//;s/)$//')
done

for lab in $LABS_BUILD; do
    f="$PACK/$lab.md"
    for cmd in 'az group delete' 'az group show'; do
        if grep -qF -- "$cmd" "$f"; then
            pass "$lab contains: $cmd"
        else
            fail_case "$lab missing: $cmd"
        fi
    done
done

fault="$PACK/lab-05-capstone-sysadmin.md"
for term in 'nsg rule' 'systemctl stop' '## Restored check'; do
    if grep -qiF -- "$term" "$fault"; then
        pass "capstone A contains: $term"
    else
        fail_case "capstone A missing: $term"
    fi
done

design="$PACK/lab-06-capstone-architect.md"
for term in 'hub' 'peering' 'ADR'; do
    if grep -qi -- "$term" "$design"; then
        pass "capstone B contains: $term"
    else
        fail_case "capstone B missing: $term"
    fi
done

if grep -qF -- '../../example-learning-session-runbook.md' "$PACK/index.md"; then
    pass "index links the learning runbook"
else
    fail_case "index does not link the learning runbook"
fi

for lab in $LABS; do
    f="$PACK/$lab.md"
    if grep -qF -- 'bootstrap using AGENTS.md protocol' "$f"; then
        fail_case "$lab duplicates the runbook bootstrap prompt"
    else
        pass "$lab avoids the runbook bootstrap prompt"
    fi
    if grep -qF -- 'minimalistic CSS' "$f"; then
        fail_case "$lab duplicates the runbook page task"
    else
        pass "$lab avoids the runbook page task"
    fi
done

if grep -qF "targetScope = 'resourceGroup'" "$CORE"; then
    pass "core bicep targets the resource group"
else
    fail_case "core bicep target scope is wrong"
fi

bad_core="$(awk '/^resource / && $0 !~ /@20[0-9][0-9]-/ { print NR": "$0 }' "$CORE")"
if [ -z "$bad_core" ]; then
    pass "every core resource pins an API version"
else
    fail_case "a core resource has no pinned API version"
    printf '%s\n' "$bad_core"
fi

for type in 'Microsoft.Compute/virtualMachines' 'Microsoft.Storage/storageAccounts' 'Microsoft.Network/networkSecurityGroups'; do
    if grep -qF -- "$type" "$CORE"; then
        pass "core bicep declares: $type"
    else
        fail_case "core bicep missing: $type"
    fi
done

vnet_count="$(grep -cE "^resource .*'Microsoft\.Network/virtualNetworks@" "$HUB")"
if [ "$vnet_count" -ge 2 ]; then
    pass "hub-spoke bicep declares two virtual networks"
else
    fail_case "hub-spoke bicep needs two virtual networks"
fi

if grep -qF -- 'virtualNetworkPeerings' "$HUB"; then
    pass "hub-spoke bicep declares a peering"
else
    fail_case "hub-spoke bicep missing a peering"
fi

if grep -qF "targetScope = 'resourceGroup'" "$HUB"; then
    pass "hub-spoke bicep targets the resource group"
else
    fail_case "hub-spoke bicep target scope is wrong"
fi

bad_hub="$(awk '/^resource / && $0 !~ /@20[0-9][0-9]-/ { print NR": "$0 }' "$HUB")"
if [ -z "$bad_hub" ]; then
    pass "every hub-spoke resource pins an API version"
else
    fail_case "a hub-spoke resource has no pinned API version"
    printf '%s\n' "$bad_hub"
fi

bicep_ready=0
if command -v az >/dev/null 2>&1; then
    if az bicep version >/dev/null 2>&1; then
        bicep_ready=1
    fi
fi
if [ "$bicep_ready" -eq 1 ]; then
    if az bicep build --file "$CORE" >/dev/null 2>&1; then
        pass "core bicep builds"
    else
        fail_case "core bicep build failed"
    fi
    if az bicep build --file "$HUB" >/dev/null 2>&1; then
        pass "hub-spoke bicep builds"
    else
        fail_case "hub-spoke bicep build failed"
    fi
else
    echo "[PENDING] Bicep CLI not installed; static checks only."
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: Azure exercise pack fixture."
    exit 1
fi
echo "PASSED: Azure exercise pack fixture (files, sections, no-cloud labs, bans, teardown, fault, hub-spoke, Bicep shape)."
exit 0
