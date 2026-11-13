#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HEADER='> **Knowledge file.** This file stands on its own. Keep the facts, rules, reasons, and checks that belong to it; remove bookkeeping and duplicates. Run `repair knowledge files` when it passes 15 KB.'
ART_DATE="2026-11-09"

usage() {
    echo "usage: $0 --prepare | --simulate ROOT | --verify ROOT | --dry-run ROOT | --all"
}

fail() {
    echo "FAIL: $*"
    exit 1
}

knowledge_count() {
    local store="$1"
    find "$store" -type f -name '*.md' ! -path '*/tickets/*' ! -name 'issue-template.md' | wc -l
}

knowledge_recommendation() {
    local count
    count="$(knowledge_count "$1")"
    if [ "$count" -ge 50 ]; then
        echo "recommend repair ($count)"
    else
        echo "no repair ($count)"
    fi
}

make_note() {
    local path="$1" title="$2" body="$3"
    printf '%s\n\n# %s\n\n## Context\n\n%s\n\n## Rule or Fix\n\n- Keep the rule.\n\n## Why\n\n- The rule matters.\n\n## Verify\n\n- Confirm the rule.\n' \
        "$HEADER" "$title" "$body" > "$path"
}

prepare() {
    local root project home pk gk i n dir
    root="$(mktemp -d /tmp/kilo/knowledge-repair-fixture.XXXXXX)"
    project="$root/project"
    home="$root/home"
    pk="$project/ai/shared/project-knowledge"
    gk="$home/.ai/global-knowledge"
    mkdir -p "$pk/tickets" "$gk" "$project/ai/state" "$project/ai/daily-checkpoints" \
        "$project/ai/artifacts" "$home/.ai/settings"

    for i in $(seq -w 1 51); do
        make_note "$pk/small-$i.md" "Small lesson $i" "A small project lesson $i."
    done

    printf '# Issue Ticket Template\n\nTemplate body.\n' > "$pk/issue-template.md"
    printf 'Tracker-State: Done\n\n# Ticket T-1\n\nA closed ticket.\n' > "$pk/tickets/t-1.md"
    printf 'Tracker-State: Open\n\n# Ticket T-2\n\nAn open ticket.\n' > "$pk/tickets/t-2.md"

    {
        printf '%s\n\n# PostgreSQL Operations\n\n' "$HEADER"
        for topic in postgresql-grs-and-restore postgresql-migration-service-replication postgresql-parameters-extensions-iac postgresql-autovacuum-and-performance; do
            printf '## Topic: %s\n\n## Rule or Fix\n\n- Rule for %s.\n\n## Why\n\n- It matters.\n\n' "$topic" "$topic"
            for i in $(seq 1 60); do
                printf 'Detail line %s for %s keeps this topic over the automatic review size.\n' "$i" "$topic"
            done
            printf '\n## Verify\n\n- Confirm it.\n\n## Evidence\n\nIncident narrative for %s.\n\n' "$topic"
        done
    } > "$pk/postgresql-operations.md"

    make_note "$pk/postgresql-backup-command.md" "PostgreSQL backup command" "Run the backup command for this project."
    printf '%s\n\n# Incident Evidence File\n\n## Context\n\nAn incident.\n\n## Evidence\n\nOnly narrative for the incident.\n\n## Rule or Fix\n\n- Keep the reusable rule.\n\n## Why\n\n- The rule is reusable.\n\n## Verify\n\n- Confirm the rule.\n' "$HEADER" > "$pk/incident-only.md"

    make_note "$pk/postgresql-restore-and-pitr.md" "PostgreSQL restore and PITR" "Use the restore procedure."
    make_note "$gk/postgresql-restore-and-pitr.md" "PostgreSQL restore and PITR" "Use the restore procedure."

    make_note "$pk/pr-review-123.md" "PR review finding" "A per-PR finding."
    printf '%s\n\n# Repository Inventory\n\nA generated inventory.\n' "$HEADER" > "$pk/ado-repository-inventory.md"

    for n in 49 50 51; do
        dir="$root/stores/$n"
        mkdir -p "$dir"
        for i in $(seq -w 1 "$n"); do
            make_note "$dir/lesson-$i.md" "Lesson $i" "Lesson $i."
        done
    done

    printf '# User Settings\n\n- Knowledge pointer: ai/shared/project-knowledge/postgresql-operations.md\n' \
        > "$home/.ai/settings/global-user-settings.md"

    echo "$root"
}

simulate() {
    local root project home pk gk art gback target f before after
    root="$1"
    project="$root/project"
    home="$root/home"
    pk="$project/ai/shared/project-knowledge"
    gk="$home/.ai/global-knowledge"
    art="$project/ai/artifacts/knowledge-repair-$ART_DATE"
    gback="$home/.ai/knowledge-repair-backups/$ART_DATE/global"
    mkdir -p "$art/project" "$gback"
    cp -a "$pk/." "$art/project/"
    cp -a "$gk/." "$gback/"
    before="$(knowledge_count "$pk")"

    awk -v pk="$pk" -v header="$HEADER" '
        /^## Topic: / {
            name = $0
            sub(/^## Topic: /, "", name)
            out = pk "/" name ".md"
            print header > out
            print "\n# " name "\n\n## Context\n\nSplit from the operations note.\n" > out
            in_evidence = 0
            next
        }
        /^## Evidence$/ { in_evidence = 1; next }
        /^## / { in_evidence = 0 }
        { if (out != "" && !in_evidence) print > out }
    ' "$pk/postgresql-operations.md"
    rm "$pk/postgresql-operations.md"

    rm -f "$pk/postgresql-restore-and-pitr.md"
    rm -f "$pk/tickets/t-1.md"
    mv "$pk/ado-repository-inventory.md" "$project/ai/artifacts/"

    target="$pk/postgresql-operations-small-lessons.md"
    printf '%s\n\n# PostgreSQL Operations Small Lessons\n\n## Context\n\nMerged small lessons.\n\n## Rule or Fix\n' "$HEADER" > "$target"
    for f in "$pk"/*.md; do
        [ -f "$f" ] || continue
        [ "$f" = "$target" ] && continue
        case "$f" in
            */tickets/*) continue ;;
        esac
        [ "$(basename "$f")" = "issue-template.md" ] && continue
        if [ "$(wc -c < "$f")" -lt 3000 ]; then
            sed -n '/^## Rule or Fix/,/^## Why/p' "$f" | sed '1d' | sed '$d' >> "$target"
            rm "$f"
        fi
    done
    printf '\n## Why\n\n- The merged lessons belong to one topic.\n\n## Verify\n\n- Confirm the merged rules.\n' >> "$target"

    printf 'dangling pointer: ai/shared/project-knowledge/postgresql-operations.md (settings)\n' > "$art/pointers.txt"
    after="$(knowledge_count "$pk")"

    {
        printf '# Knowledge repair manifest\n\n'
        printf -- '- postgresql-operations.md: split by topic\n'
        printf -- '- small-*.md and the backup command: merged\n'
        printf -- '- incident-only.md: removed as incident evidence; rule merged\n'
        printf -- '- postgresql-restore-and-pitr.md: merged into global\n'
        printf -- '- pr-review-123.md: folded into a topic file\n'
        printf -- '- ado-repository-inventory.md: moved to artifacts\n'
        printf -- '- tickets/t-1.md: retired\n'
        printf -- '- tickets/t-2.md: kept\n'
        printf -- '- store count: before %s, after %s\n' "$before" "$after"
        printf -- '- settings pointer: reported\n'
    } > "$art/manifest.md"

    printf '# Project Context\n\n## Current Status\n\n- Knowledge repair: before %s files, after %s files.\n- Manifest: %s\n- Project backup: %s\n- Global backup: %s\n' \
        "$before" "$after" "$art/manifest.md" "$art/project/" "$gback/" > "$project/ai/state/context.md"
    printf '# Daily Checkpoint %s\n\n## Knowledge repair\n\n- Before: %s files\n- After: %s files\n- Manifest: %s\n' \
        "$ART_DATE" "$before" "$after" "$art/manifest.md" > "$project/ai/daily-checkpoints/$ART_DATE.md"
}

dry_run() {
    local root="$1"
    local art="$root/project/ai/artifacts/knowledge-repair-$ART_DATE"
    [ ! -e "$art/manifest.md" ] || fail "dry run wrote the manifest"
    echo "DRY RUN: no files written"
}

verify() {
    local root project home pk gk art gback count
    root="$1"
    project="$root/project"
    home="$root/home"
    pk="$project/ai/shared/project-knowledge"
    gk="$home/.ai/global-knowledge"
    art="$project/ai/artifacts/knowledge-repair-$ART_DATE"
    gback="$home/.ai/knowledge-repair-backups/$ART_DATE/global"

    count="$(knowledge_count "$pk")"
    [ "$count" -le 50 ] || fail "store count $count is over 50"
    [ "$(knowledge_recommendation "$root/stores/49")" = "no repair (49)" ] || fail "49-file store recommends a repair"
    [ "$(knowledge_recommendation "$root/stores/50")" = "recommend repair (50)" ] || fail "50-file store does not recommend a repair"
    [ "$(knowledge_recommendation "$root/stores/51")" = "recommend repair (51)" ] || fail "51-file store does not recommend a repair"

    for topic in postgresql-grs-and-restore postgresql-migration-service-replication postgresql-parameters-extensions-iac postgresql-autovacuum-and-performance; do
        [ -f "$pk/$topic.md" ] || fail "split topic missing: $topic"
    done
    [ -f "$pk/postgresql-operations-small-lessons.md" ] || fail "merge target missing"
    grep -q 'Keep the rule.' "$pk/postgresql-operations-small-lessons.md" || fail "merged rule missing"
    grep -q 'Keep the reusable rule.' "$pk/postgresql-operations-small-lessons.md" || fail "incident rule missing"
    ! grep -R -q 'Only narrative' "$pk" || fail "incident evidence remains"
    ! grep -R -q 'Incident narrative' "$pk" || fail "split evidence remains"

    [ -f "$gk/postgresql-restore-and-pitr.md" ] || fail "global duplicate missing"
    [ ! -f "$pk/postgresql-restore-and-pitr.md" ] || fail "project duplicate remains"
    [ ! -f "$pk/pr-review-123.md" ] || fail "per-PR file remains"
    [ -f "$project/ai/artifacts/ado-repository-inventory.md" ] || fail "inventory not moved"
    [ ! -f "$pk/ado-repository-inventory.md" ] || fail "inventory remains in the store"
    [ ! -f "$pk/tickets/t-1.md" ] || fail "Done ticket not retired"
    [ -f "$pk/tickets/t-2.md" ] || fail "Open ticket retired"
    [ -f "$pk/issue-template.md" ] || fail "template missing"

    grep -q 'postgresql-operations.md' "$art/pointers.txt" || fail "dangling pointer not reported"
    grep -q 'removed as incident evidence' "$art/manifest.md" || fail "evidence disposition missing"
    grep -q 'split by topic' "$art/manifest.md" || fail "split disposition missing"
    grep -q 'retired' "$art/manifest.md" || fail "retirement disposition missing"
    [ -f "$art/project/postgresql-operations.md" ] || fail "project backup missing"
    [ -f "$gback/postgresql-restore-and-pitr.md" ] || fail "global backup missing"
    ! find "$art" -name '*candidate*' | grep -q . || fail "candidate left behind"

    grep -q '### Knowledge Lookup' "$REPO/ai/policies/ai-policy-common.md" || fail "Knowledge Lookup missing"
    grep -q '### Knowledge Retirement' "$REPO/ai/policies/ai-policy-common.md" || fail "Knowledge Retirement missing"
    grep -q 'six or fewer hyphen-separated segments' "$REPO/ai/policies/ai-policy-common.md" || fail "naming rule missing"
    grep -q '50 knowledge files per store' "$REPO/ai/policies/ai-policy-common.md" || fail "review threshold missing"
    grep -q '3,000 bytes' "$REPO/ai/policies/ai-policy-common.md" || fail "merge floor missing"
    grep -q 'split only by task topic' "$REPO/ai/procedures/repair-knowledge-files.md" || fail "procedure topic split missing"
    if grep -nE 'never split a file|never split it|file count (cannot|can.t|must not) increase' \
        "$REPO/ai/policies/ai-policy-common.md" "$REPO/ai/procedures/repair-knowledge-files.md"; then
        fail "legacy no-split wording remains"
    fi

    echo "PASS: knowledge repair fixture verified; store files=$count"
}

case "${1:-}" in
    --prepare) prepare ;;
    --simulate) [ $# -eq 2 ] || { usage; exit 2; }; simulate "$2" ;;
    --verify) [ $# -eq 2 ] || { usage; exit 2; }; verify "$2" ;;
    --dry-run) [ $# -eq 2 ] || { usage; exit 2; }; dry_run "$2" ;;
    --all)
        root="$(prepare)"
        dry_run "$root"
        simulate "$root"
        verify "$root"
        echo "fixture_root=$root"
        echo "cleanup: rm -rf $root"
        ;;
    *) usage; exit 2 ;;
esac
