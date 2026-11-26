#!/bin/bash
# Customization preset fixture: the eight role presets, the guide section,
# the trait catalog, the ADR entries, and the placeholder safety.
# Usage: ./tests/test-customization-presets.sh
# Exit 0 when every assertion passes, 1 otherwise.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PRESETS="$ROOT/docs/examples/customization-presets"
GUIDE="$ROOT/docs/ai-customization-guide.md"
WORKFLOW_GUIDE="$ROOT/docs/workflow-guide.md"
DECK="$ROOT/docs/simple-ai-workflow-slides.md"
TEMPLATE="$ROOT/docs/ai-customization.md"
DECISIONS="$ROOT/design-docs/protocol-decisions.md"
fail=0

pass() { printf 'PASS %s\n' "$1"; }

fail_case() { printf 'FAIL %s\n' "$1"; fail=1; }

present() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        pass "$label"
    else
        fail_case "$label"
    fi
}

absent() {
    local file="$1" needle="$2" label="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        fail_case "$label"
    else
        pass "$label"
    fi
}

exact_line() {
    local file="$1" line="$2" label="$3"
    if [ -f "$file" ] && grep -qxF -- "$line" "$file"; then
        pass "$label"
    else
        fail_case "$label"
    fi
}

no_exact_line() {
    local file="$1" line="$2" label="$3"
    if [ -f "$file" ] && grep -qxF -- "$line" "$file"; then
        fail_case "$label"
    else
        pass "$label"
    fi
}

check_expertise() {
    local slug="$1" expected="$2"
    local actual
    actual="$(awk '/^## Active Expertise/{f=1;next} f&&/^## /{exit} f&&/^- /{print}' "$PRESETS/$slug.md")"
    if [ "$actual" = "$expected" ]; then
        pass "expertise set: $slug"
    else
        fail_case "expertise set: $slug"
    fi
}

check_anchors() {
    local slug="$1"
    local file="$PRESETS/$slug.md"
    local anchor
    for anchor in \
        "## AI Workflow Configuration" \
        "**Workflow AI Directory**: /path/to/Simple-AI-Workflow" \
        "## Active Expertise" \
        "## Active Traits" \
        "## Required Compliance" \
        "## Design Docs" \
        "**Location**: design-docs/" \
        "## Merge Policy" \
        "**Merge Mode**: auto"; do
        present "$file" "$anchor" "anchor $slug: $anchor"
    done
    present "$file" "**User AI Directory**: [HOME]/.ai/" "anchor $slug: user AI directory"
}

check_trait() {
    local slug="$1" trait="$2"
    local file="$PRESETS/$slug.md"
    local count
    count="$(awk '/^## Active Traits/{f=1;next} f&&/^## /{exit} f&&/^- /{c++} END{print c+0}' "$file")"
    if [ "$count" = "1" ]; then
        pass "one trait bullet: $slug"
    else
        fail_case "one trait bullet: $slug ($count)"
    fi
    present "$file" "- **$trait**:" "trait $slug: $trait"
}

roles="cloud-architect solution-architect web-developer mobile-developer platform-engineer dba data-engineer security-engineer"

for slug in $roles; do
    if [ -f "$PRESETS/$slug.md" ]; then
        pass "preset exists: $slug"
    else
        fail_case "preset missing: $slug"
    fi
    check_anchors "$slug"
done

check_expertise "cloud-architect" "- cloud
- api-backend
- data
- dba
- web-frontend
- observability"
check_expertise "solution-architect" "- cloud
- api-backend
- data
- dba
- web-frontend
- mobile-apps"
check_expertise "web-developer" "- web-frontend
- api-backend
- coding-baseline"
check_expertise "mobile-developer" "- mobile-apps
- api-backend
- coding-baseline"
check_expertise "platform-engineer" "- cloud
- linux-system-admin
- windows-system-admin
- observability"
check_expertise "dba" "- dba
- data"
check_expertise "data-engineer" "- data
- dba
- cloud"
check_expertise "security-engineer" "- coding-baseline
- observability
- cloud"

check_trait "cloud-architect" "System Architect"
check_trait "solution-architect" "System Integrator"
check_trait "web-developer" "Software Developer"
check_trait "mobile-developer" "Software Developer"
check_trait "platform-engineer" "Platform Engineer"
check_trait "dba" "Senior DBA"
check_trait "data-engineer" "Data Engineer"
check_trait "security-engineer" "Security Specialist"

for slug in cloud-architect solution-architect platform-engineer data-engineer security-engineer; do
    exact_line "$PRESETS/$slug.md" "- soc2" "compliance soc2: $slug"
    exact_line "$PRESETS/$slug.md" "- iso-27001" "compliance iso-27001: $slug"
done

for slug in web-developer mobile-developer dba; do
    no_exact_line "$PRESETS/$slug.md" "- soc2" "no compliance soc2: $slug"
    no_exact_line "$PRESETS/$slug.md" "- iso-27001" "no compliance iso-27001: $slug"
done

present "$PRESETS/platform-engineer.md" "- linux-system-admin" "platform-engineer keeps the plain linux token"
present "$PRESETS/platform-engineer.md" "markdownlint-disable MD044" "platform-engineer disables MD044"

presets_section="$(awk '/^## 11\. Presets by Role/{f=1;next} f&&/^## /{exit} f{print}' "$GUIDE")"
for slug in $roles; do
    role_cell="| \`$slug\` |"
    if printf '%s\n' "$presets_section" | grep -qF -- "$role_cell"; then
        pass "guide section 11 names preset: $slug"
    else
        fail_case "guide section 11 names preset: $slug"
    fi
done
present "$GUIDE" "## 11. Presets by Role" "guide has the presets section"
present "$GUIDE" "\`linux-system-admin\`" "guide uses inline-code linux token"
for trait in "Platform Engineer" "Software Developer" "Data Engineer"; do
    present "$GUIDE" "**$trait**:" "guide catalog trait: $trait"
    present "$WORKFLOW_GUIDE" "$trait" "workflow guide trait: $trait"
done
for deck_trait in "platform engineer" "software developer" "data engineer"; do
    present "$DECK" "$deck_trait" "deck names trait: $deck_trait"
done

present "$TEMPLATE" "coding-baseline" "template lists coding-baseline"
present "$TEMPLATE" "linux-system-admin" "template lists lowercase linux token"
present "$TEMPLATE" "markdownlint-disable-next-line MD044" "template scopes the MD044 disable"

for heading in \
    "## 2026-11-26: Customization presets are full variants under docs/examples/customization-presets/" \
    "## 2026-11-26: Three traits join the catalog for the presets" \
    "## 2026-11-26: The preset slugs are the init preset identifiers" \
    "## 2026-11-26: Preset compliance is a suggestion, not a determination" \
    "## 2026-11-26: Documentation-only additions ship as a PATCH"; do
    present "$DECISIONS" "$heading" "ADR heading: $heading"
done

for slug in $roles; do
    present "$PRESETS/$slug.md" "/path/to/Simple-AI-Workflow" "placeholder path: $slug"
    absent "$PRESETS/$slug.md" "/home/" "no absolute home path: $slug"
    absent "$PRESETS/$slug.md" "/Users/" "no mac absolute path: $slug"
done

if [ "$fail" -ne 0 ]; then
    echo "FAILED: customization preset fixture."
    exit 1
fi
echo "PASSED: customization preset fixture (eight presets, guide section, traits, compliance, ADRs, placeholders)."
exit 0
