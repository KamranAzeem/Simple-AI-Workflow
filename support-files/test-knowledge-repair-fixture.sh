#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OLD_HEADER='> **Knowledge file.** Follow `ai-policy-common.md`, section `## Knowledge File Standards`. This header is canonical: copy it verbatim and do not edit it. If it is missing, run `repair knowledge files`.'
NEW_HEADER='> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.'

usage() {
    echo "usage: $0 --prepare | --simulate ROOT | --verify ROOT | --all"
}

prepare() {
    local root
    root="$(mktemp -d /tmp/kilo/knowledge-repair-fixture.XXXXXX)"
    local project="$root/project"
    local home="$root/home"
    local pk="$project/ai/shared/project-knowledge"
    local gk="$home/.ai/global-knowledge"
    mkdir -p "$pk" "$gk" "$project/ai/state" "$project/ai/daily-checkpoints"

    local i
    for i in $(seq -w 1 50); do
        printf '%s\n\n# Small lesson %s\n\n## Context\n\nA small project lesson %s.\n\n## Rule or Fix\n\n- Keep the small lesson intact.\n\n## Why\n\n- It is a single fact.\n\n## Verify\n\n- Confirm the fact.\n' "$OLD_HEADER" "$i" "$i" > "$pk/small-$i.md"
    done

    {
        printf '%s\n\n# Release Checklist\n\n## Context\n\nThe release process for the fixture project.\n\n## Rule or Fix\n\nChecklist:\n\n' "$OLD_HEADER"
        for i in $(seq 1 750); do
            printf -- '- Check item %s and confirm the release evidence for this item is present and complete.\n' "$i"
        done
        printf '\n## Why\n\n- A checklist keeps the release repeatable.\n\n## Verify\n\n- Confirm every item.\n'
    } > "$pk/release-checklist.md"

    {
        printf '%s\n\n# Large Note\n\n## Context\n\n' "$OLD_HEADER"
        for i in $(seq 1 300); do
            printf 'Large note detail %s explains a durable fact for the fixture project. ' "$i"
            [ $((i % 4)) -eq 0 ] && printf '\n'
        done
        printf '\n\n## Rule or Fix\n\n- Keep the large note together.\n\n## Why\n\n- It is one coherent note.\n\n## Verify\n\n- Confirm the note is present.\n'
    } > "$pk/large-note.md"

    printf '%s\n\n# Pointer Note\n\n## Context\n\nAcme Client uses Kubernetes for the fixture. Recorded 2026-01-01. commit abc1234.\n\n## Rule or Fix\n\n- See artifacts/old.md for the rest.\n- See ../backups/old.md for the backup.\n\n| Key | Value |\n| --- | --- |\n| Region | a |\n| Zone | b |\n\n## Why\n\n- The pointer is bookkeeping.\n\n## Verify\n\n- Confirm the rule.\n' "$OLD_HEADER" > "$pk/pointer-note.md"
    printf '%s\n\n# Project Name Note\n\n## Context\n\nAcme Client owns this project.\n\n## Rule or Fix\n\n- Keep the project context.\n\n## Why\n\n- The name is project context.\n\n## Verify\n\n- Confirm the name.\n' "$OLD_HEADER" > "$pk/project-name-note.md"
    printf '%s\n\n# Vendor Note\n\n## Context\n\nKubernetes is the platform.\n\n## Rule or Fix\n\n- Use Kubernetes.\n\n## Why\n\n- The vendor is the subject.\n\n## Verify\n\n- Confirm Kubernetes.\n' "$OLD_HEADER" > "$pk/vendor-note.md"
    printf '%s\n\n# Secret Note\n\n## Context\n\nThe fixture contains a raw secret.\n\n## Rule or Fix\n\n- Remove password=fixture-secret before commit.\n\n## Why\n\n- Secrets are not knowledge.\n\n## Verify\n\n- Confirm the secret is gone.\n' "$OLD_HEADER" > "$pk/secret-note.md"
    printf '%s\n\n# Duplicate Note\n\n## Context\n\nA duplicate fact for the fixture.\n\n## Rule or Fix\n\n- Keep one survivor.\n\n## Why\n\n- The duplicate adds no value.\n\n## Verify\n\n- Confirm one survivor.\n' "$OLD_HEADER" > "$pk/duplicate-note.md"
    cp "$pk/duplicate-note.md" "$pk/duplicate-note-copy.md"
    printf '%s\n\n# Conflict Note\n\n## Context\n\nSPECIAL_CONFLICT: this file has an incomplete manifest.\n\n## Rule or Fix\n\n- Leave this file unchanged.\n\n## Why\n\n- The abort is safe.\n\n## Verify\n\n- Confirm the file is unchanged.\n' "$OLD_HEADER" > "$pk/conflict-note.md"

    printf '%s\n\n# Global Client Note\n\n## Context\n\nFixture Global Client uses Kubernetes in the fixture.\n\n## Rule or Fix\n\n- See docs/old.md for the global detail.\n\n| Key | Value |\n| --- | --- |\n| Owner | a |\n\n## Why\n\n- The global note is portable.\n\n## Verify\n\n- Confirm the rule.\n' "$OLD_HEADER" > "$gk/global-client-note.md"
    printf '%s\n\n# Global Vendor Note\n\n## Context\n\nDocker is a vendor in the fixture.\n\n## Rule or Fix\n\n- Use Docker.\n\n## Why\n\n- The vendor is the subject.\n\n## Verify\n\n- Confirm Docker.\n' "$OLD_HEADER" > "$gk/global-vendor-note.md"
    printf '%s\n\n# Global Secret Note\n\n## Context\n\nThe global fixture contains a secret.\n\n## Rule or Fix\n\n- Remove password=global-secret.\n\n## Why\n\n- Secrets are not knowledge.\n\n## Verify\n\n- Confirm the secret is gone.\n' "$OLD_HEADER" > "$gk/global-secret-note.md"

    echo "$root"
}

replace_header() {
    local file="$1"
    local tmp
    tmp="$(mktemp)"
    { printf '%s\n' "$NEW_HEADER"; tail -n +2 "$file"; } > "$tmp"
    mv "$tmp" "$file"
}

simulate() {
    local root="$1"
    local project="$root/project"
    local home="$root/home"
    local pk="$project/ai/shared/project-knowledge"
    local gk="$home/.ai/global-knowledge"
    local art="$project/ai/artifacts/knowledge-repair-2026-10-29"
    local gback="$home/.ai/knowledge-repair-backups/2026-10-29/global"
    mkdir -p "$art/project" "$gback"
    cp -a "$pk/." "$art/project/"
    cp -a "$gk/." "$gback/"
    local f
    for f in "$pk"/*.md; do
        if grep -q 'SPECIAL_CONFLICT' "$f"; then
            continue
        fi
        replace_header "$f"
        sed -i -E \
            -e '/See artifacts\//d' \
            -e '/See \.\.\/backups\//d' \
            -e '/Recorded [0-9]{4}-[0-9]{2}-[0-9]{2}/d' \
            -e '/Learned [0-9]{4}-[0-9]{2}-[0-9]{2}/d' \
            -e '/commit [0-9a-f]{7,}/d' \
            -e 's/^password=.*//' \
            -e 's/^- Remove password=.*/- Remove the secret./' \
            -e 's/^\| --- \| --- \|$//' \
            -e 's/^\| (.*) \| (.*) \|$/- \1: \2/' \
            "$f"
    done
    rm -f "$pk/duplicate-note-copy.md"
    for f in "$gk"/*.md; do
        replace_header "$f"
        sed -i -E \
            -e 's/Fixture Global Client/a client project/g' \
            -e '/See docs\//d' \
            -e 's/^password=.*//' \
            -e 's/^- Remove password=.*/- Remove the secret./' \
            -e 's/^\| --- \| --- \|$//' \
            -e 's/^\| (.*) \| (.*) \|$/- \1: \2/' \
            "$f"
    done
    local cand="$art/candidate.md"
    printf 'temporary candidate\n' > "$cand"
    cat > "$art/manifest.md" <<'EOF'
# Knowledge repair manifest

| File | Disposition | Review |
| --- | --- | --- |
| release-checklist.md | kept | APPROVED |
| large-note.md | kept | APPROVED; 15k review |
| duplicate-note-copy.md | merged | APPROVED |
| conflict-note.md | aborted unchanged | ABORTED |
| pointer-note.md | trimmed | APPROVED |
EOF
    rm -f "$cand"
    printf '# Project Context\n\n## Current Status\n\n- Manifest: %s\n- Project backup: %s\n- Global backup: %s\n' "$art/manifest.md" "$art/project/" "$gback/" > "$project/ai/state/context.md"
    printf '# Daily Checkpoint 2026-10-29\n\n## Repair\n\n- Manifest: %s\n- Project backup: %s\n- Global backup: %s\n' "$art/manifest.md" "$art/project/" "$gback/" > "$project/ai/daily-checkpoints/2026-10-29.md"
}

verify() {
    local root="$1"
    local project="$root/project"
    local home="$root/home"
    local pk="$project/ai/shared/project-knowledge"
    local gk="$home/.ai/global-knowledge"
    local count
    count="$(find "$pk" -maxdepth 1 -name '*.md' | wc -l)"
    [ "$count" -le 59 ] || { echo "FAIL: project file count $count"; exit 1; }
    [ -f "$pk/release-checklist.md" ] || { echo "FAIL: checklist missing"; exit 1; }
    [ "$(find "$pk" -maxdepth 1 -name 'release-checklist*' | wc -l)" -eq 1 ] || { echo "FAIL: checklist split"; exit 1; }
    [ "$(wc -c < "$pk/release-checklist.md")" -gt 60000 ] || { echo "FAIL: checklist not large"; exit 1; }
    [ -f "$pk/large-note.md" ] || { echo "FAIL: large note missing"; exit 1; }
    [ "$(find "$pk" -maxdepth 1 -name 'large-note*' | wc -l)" -eq 1 ] || { echo "FAIL: large note split"; exit 1; }
    [ "$(wc -c < "$pk/large-note.md")" -gt 15000 ] || { echo "FAIL: large note not over 15 KB"; exit 1; }
    grep -q 'Region: a' "$pk/pointer-note.md" || { echo "FAIL: table row lost"; exit 1; }
    grep -q 'Zone: b' "$pk/pointer-note.md" || { echo "FAIL: table row lost"; exit 1; }
    grep -q 'SPECIAL_CONFLICT' "$pk/conflict-note.md" || { echo "FAIL: aborted file changed"; exit 1; }
    if grep -R -n -E --exclude=conflict-note.md '^> \*\*Knowledge file\.\*\* Follow|^\||See artifacts/|See \.\./backups/|See docs/|password=|Recorded 20|Learned 20|commit [0-9a-f]{7,}' "$pk" "$gk"; then
        echo "FAIL: garbage remains"
        exit 1
    fi
    grep -q 'Acme Client' "$pk/project-name-note.md" || { echo "FAIL: project name lost"; exit 1; }
    grep -q 'Kubernetes' "$pk/vendor-note.md" || { echo "FAIL: project vendor lost"; exit 1; }
    grep -q 'Docker' "$gk/global-vendor-note.md" || { echo "FAIL: global vendor lost"; exit 1; }
    ! grep -R -q 'Fixture Global Client' "$gk" || { echo "FAIL: global name remains"; exit 1; }
    [ -f "$project/ai/artifacts/knowledge-repair-2026-10-29/manifest.md" ] || { echo "FAIL: manifest missing"; exit 1; }
    grep -q 'APPROVED' "$project/ai/artifacts/knowledge-repair-2026-10-29/manifest.md" || { echo "FAIL: review gate missing"; exit 1; }
    grep -q 'aborted unchanged' "$project/ai/artifacts/knowledge-repair-2026-10-29/manifest.md" || { echo "FAIL: abort disposition missing"; exit 1; }
    grep -q '15k review' "$project/ai/artifacts/knowledge-repair-2026-10-29/manifest.md" || { echo "FAIL: 15k review missing"; exit 1; }
    ! find "$project/ai/artifacts/knowledge-repair-2026-10-29" -name '*candidate*' | grep -q . || { echo "FAIL: candidate left behind"; exit 1; }
    [ -f "$home/.ai/knowledge-repair-backups/2026-10-29/global/global-client-note.md" ] || { echo "FAIL: global backup missing"; exit 1; }
    grep -q 'Manifest:' "$project/ai/state/context.md" || { echo "FAIL: checkpoint path missing"; exit 1; }
    grep -q 'Manifest:' "$project/ai/daily-checkpoints/2026-10-29.md" || { echo "FAIL: diary path missing"; exit 1; }
    grep -q 'APPROVED' "$REPO/AGENTS.md" || { echo "FAIL: review gate missing"; exit 1; }
    grep -q 'aborted unchanged' "$REPO/ai/policies/ai-policy-common.md" || { echo "FAIL: abort rule missing"; exit 1; }
    grep -q 'do not ask' "$REPO/AGENTS.md" || { echo "FAIL: no-question rule missing"; exit 1; }
    if grep -q 'Get human approval' "$REPO/AGENTS.md"; then echo "FAIL: approval question remains"; exit 1; fi
    echo "PASS: knowledge repair fixture verified; project files=$count"
}

dry_run() {
    local root="$1"
    local art="$root/project/ai/artifacts/knowledge-repair-2026-10-29"
    [ ! -e "$art/manifest.md" ] || { echo "FAIL: dry run wrote the manifest"; exit 1; }
    echo "DRY RUN: no files written"
}

case "${1:-}" in
    --prepare) prepare ;;
    --simulate) [ $# -eq 2 ] || { usage; exit 2; }; simulate "$2" ;;
    --verify) [ $# -eq 2 ] || { usage; exit 2; }; verify "$2" ;;
    --dry-run) [ $# -eq 2 ] || { usage; exit 2; }; dry_run "$2" ;;
    --all)
        root="$(prepare)"
        dry_run "$root"
        echo "Prepared. Run the actual repair procedure, then: $0 --verify $root"
        echo "fixture_root=$root"
        ;;
    *) usage; exit 2 ;;
esac
