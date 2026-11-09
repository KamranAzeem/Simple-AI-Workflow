#!/bin/bash
# Validate the authoring shape of AGENTS.md and policy files.
# Usage: ./support-files/validate-policy-authoring.sh [--triggers] <file> [<file>...]
#   --triggers  check the trigger namespace and names only; skip the full policy shape.
# Exit 0 when all checks pass, 1 on a violation, 2 on a usage error.

set -u
export LC_ALL=C

MODE=default
if [ "${1:-}" = "--triggers" ]; then
    MODE=triggers
    shift
fi

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [--triggers] <file> [<file>...]" >&2
    exit 2
fi

fail=0
file_fail=0
TRIGGERS_FILE="$(mktemp)"

cleanup() {
    rm -f "$TRIGGERS_FILE"
}
trap cleanup EXIT

fail_msg() {
    printf '[FAILED] %s:%s: %s\n' "$1" "$2" "$3"
    fail=1
    file_fail=1
}

pass_msg() {
    printf '[PASSED] %s\n' "$1"
}

first_match_line() {
    local file="$1" pattern="$2"
    awk -v re="$pattern" '$0 ~ re { print NR; exit }' "$file"
}

count_matches() {
    local file="$1" pattern="$2"
    awk -v re="$pattern" '$0 ~ re { n++ } END { print n+0 }' "$file"
}

normalize_phrase() {
    printf '%s' "$1" | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]/ /g' | tr -s ' ' | sed 's/^ //; s/ $//'
}

purpose_line_for() {
    local file="$1" title_line="$2"
    awk -v start="$title_line" '
        NR <= start { next }
        /^[[:space:]]*$/ { next }
        /^<!--/ {
            if ($0 !~ /-->/) { in_comment = 1 }
            next
        }
        in_comment {
            if ($0 ~ /-->/) { in_comment = 0 }
            next
        }
        { print NR; exit }
    ' "$file"
}

check_policy_name() {
    local file="$1" base
    base="$(basename "$file")"
    case "$file" in
        ai/policies/*|*/ai/policies/*)
            if ! printf '%s\n' "$base" | grep -qE '^ai-policy-[a-z0-9][a-z0-9-]*\.md$'; then
                fail_msg "$file" "0" "name mismatch: policy filename must match ai-policy-<name>.md"
            fi
            ;;
    esac
}

check_trigger_block() {
    local file="$1" title_line="$2" purpose_line="$3"
    local count trig_line scope_line ln line raw norm bullets next_heading intervening
    count="$(count_matches "$file" '^## Triggers[[:space:]]*$')"
    [ "$count" -eq 0 ] && return 0
    if [ "$count" -gt 1 ]; then
        fail_msg "$file" "0" "invalid trigger block: more than one '## Triggers' section"
        return 0
    fi
    trig_line="$(first_match_line "$file" '^## Triggers[[:space:]]*$')"
    scope_line="$(first_match_line "$file" '^## Scope[[:space:]]*$')"
    if [ -n "$purpose_line" ] && [ -n "$scope_line" ]; then
        if [ "$trig_line" -lt "$purpose_line" ] || [ "$trig_line" -gt "$scope_line" ]; then
            fail_msg "$file" "$trig_line" "invalid policy shape: '## Triggers' must sit after the purpose and before '## Scope'"
            return 0
        fi
    fi
    if [ -n "$purpose_line" ]; then
        next_heading="$(awk -v start="$purpose_line" 'NR > start && /^## / { print NR; exit }' "$file")"
        if [ -n "$next_heading" ] && [ "$next_heading" -ne "$trig_line" ]; then
            fail_msg "$file" "$trig_line" "invalid policy shape: '## Triggers' must be the first section after the purpose"
            return 0
        fi
    fi
    if [ -n "$purpose_line" ]; then
        intervening="$(awk -v start="$purpose_line" -v end="$trig_line" 'NR > start && NR < end && !/^[[:space:]]*$/ { print NR; exit }' "$file")"
        if [ -n "$intervening" ]; then
            fail_msg "$file" "$intervening" "invalid policy shape: '## Triggers' must immediately follow the purpose"
            return 0
        fi
    fi
    bullets=0
    ln=$trig_line
    while IFS= read -r line; do
        ln=$((ln + 1))
        if printf '%s\n' "$line" | grep -qE '^## '; then
            break
        fi
        [ -z "$line" ] && continue
        if ! printf '%s\n' "$line" | grep -qE '^- [a-z0-9 -]+$'; then
            fail_msg "$file" "$ln" "invalid trigger block: '$line'"
            continue
        fi
        raw="${line#- }"
        norm="$(normalize_phrase "$raw")"
        if [ -z "$norm" ]; then
            fail_msg "$file" "$ln" "invalid trigger block: empty phrase"
            continue
        fi
        bullets=$((bullets + 1))
    done < <(sed -n "$((trig_line + 1)),\$p" "$file")
    if [ "$bullets" -eq 0 ]; then
        fail_msg "$file" "$trig_line" "empty trigger block"
    fi
    return 0
}

check_policy_file() {
    local file="$1" base title_line purpose_line purpose_text domain_sections readonly_start_line readonly_end_line

    base="$(basename "$file")"
    check_policy_name "$file"

    title_line="$(first_match_line "$file" '^# AI Policy: .+')"
    case "$file" in
        ai/policies/ai-policy-common.md|*/ai/policies/ai-policy-common.md)
            if [ -z "$title_line" ]; then
                title_line="$(first_match_line "$file" '^# AI Assistant Policy: .+')"
            fi
            ;;
    esac
    if [ -z "$title_line" ]; then
        fail_msg "$file" "0" "invalid policy shape: missing policy title '# AI Policy: <Domain>'"
    fi

    if ! sed -n '1p' "$file" | grep -q 'DO NOT MODIFY'; then
        fail_msg "$file" "1" "invalid policy shape: missing DO NOT MODIFY guard"
    fi

    readonly_start_line="$(first_match_line "$file" '^<!-- AI-ASSISTANT: READ-ONLY START -->$')"
    readonly_end_line="$(first_match_line "$file" '^<!-- AI-ASSISTANT: READ-ONLY END -->$')"

    if [ -z "$readonly_start_line" ]; then
        fail_msg "$file" "0" "invalid policy shape: missing READ-ONLY START marker"
    fi

    if [ -z "$readonly_end_line" ]; then
        fail_msg "$file" "0" "invalid policy shape: missing READ-ONLY END marker"
    fi

    if [ -n "$title_line" ] && [ -n "$readonly_start_line" ] && [ "$title_line" -lt "$readonly_start_line" ]; then
        fail_msg "$file" "$title_line" "invalid policy shape: policy title must appear after the READ-ONLY START marker"
    fi

    if [ -n "$title_line" ] && [ -n "$readonly_end_line" ] && [ "$readonly_end_line" -lt "$title_line" ]; then
        fail_msg "$file" "$title_line" "invalid policy shape: READ-ONLY END marker must appear after the policy title"
    fi

    purpose_line=""
    if [ -n "$title_line" ]; then
        purpose_line="$(purpose_line_for "$file" "$title_line")"

        if [ -z "$purpose_line" ]; then
            fail_msg "$file" "$title_line" "invalid policy shape: missing one-line purpose below the title"
        else
            purpose_text="$(sed -n "${purpose_line}p" "$file")"
            case "$purpose_text" in
                \#*|\>*|-*|'<!--'*)
                    fail_msg "$file" "$purpose_line" "invalid policy shape: purpose must be a one-line sentence"
                    ;;
            esac
        fi
    fi

    if ! grep -qE '^## Scope[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "invalid policy shape: missing '## Scope' heading"
    fi

    if ! grep -qE '^## References[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "invalid policy shape: missing '## References' heading"
    fi

    domain_sections="$(grep -E '^## ' "$file" | sed 's/^## //; s/[[:space:]]*$//' | grep -vE '^(Scope|References|Purpose|Notes|Triggers)$')"
    if [ -z "$domain_sections" ]; then
        fail_msg "$file" "0" "invalid policy shape: missing '## Rules' or a domain-named section"
    fi

    if grep -qE '^## Purpose[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "invalid policy shape: '## Purpose' heading is not allowed"
    fi

    if grep -qE '^## Notes[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "invalid policy shape: '## Notes' heading is not allowed"
    fi

    check_trigger_block "$file" "$title_line" "$purpose_line"
}

check_agents_file() {
    local file="$1" ln msg alias_text base

    while IFS=: read -r ln msg; do
        if [ -n "$ln" ]; then
            fail_msg "$file" "$ln" "$msg"
        fi
    done < <(awk '
        /^### PROCEDURE / {
            if (in_proc && !has_alias) {
                print start ":procedure missing **Aliases** line"
            }
            in_proc = 1
            has_alias = 0
            start = NR
            if ($0 !~ /^### PROCEDURE [A-Z][A-Z0-9-]*: /) {
                print NR ":procedure name must be ALL-CAPS kebab-case"
            }
        }
        /^## / {
            if (in_proc && !has_alias) {
                print start ":procedure missing **Aliases** line"
            }
            in_proc = 0
        }
        /^\*\*Aliases\*\*:/ {
            if (in_proc) { has_alias = 1 }
        }
        END {
            if (in_proc && !has_alias) {
                print start ":procedure missing **Aliases** line"
            }
        }
    ' "$file")

    while IFS=: read -r ln alias_text; do
        [ -n "$ln" ] || continue
        case "$alias_text" in
            none) continue ;;
        esac
        base="$alias_text"
        case "$base" in
            *'#N') base="${base%#N}" ;;
        esac
        if [ -z "$base" ] || ! printf '%s\n' "$base" | grep -qE '^[A-Za-z0-9 .-]+$'; then
            fail_msg "$file" "$ln" "invalid trigger block: '$alias_text'"
        fi
    done < <(awk '
        /^\*\*Aliases\*\*:/ {
            line = NR
            sub(/^\*\*Aliases\*\*:[[:space:]]*/, "")
            n = split($0, parts, ";")
            for (i = 1; i <= n; i++) {
                t = parts[i]
                gsub(/^[ \t]+/, "", t)
                gsub(/[ \t]+$/, "", t)
                gsub(/^"|"$/, "", t)
                if (t != "" && t != "none") { print line ":" t }
            }
        }
    ' "$file")

    if grep -qE '^\*\*Loads\*\*:' "$file"; then
        ln="$(grep -nE '^\*\*Loads\*\*:' "$file" | cut -d: -f1 | tr '\n' ' ')"
        fail_msg "$file" "$ln" "**Loads** line is not allowed"
    fi
}

collect_raw_triggers() {
    local file="$1" base module
    base="$(basename "$file")"
    if [ "$base" = "AGENTS.md" ]; then
        awk '
            /^### PROCEDURE [A-Z][A-Z0-9-]*:/ {
                name = $3
                sub(/:$/, "", name)
            }
            /^\*\*Aliases\*\*:/ {
                line = NR
                sub(/^\*\*Aliases\*\*:[[:space:]]*/, "")
                n = split($0, parts, ";")
                for (i = 1; i <= n; i++) {
                    t = parts[i]
                    gsub(/^[ \t]+/, "", t)
                    gsub(/[ \t]+$/, "", t)
                    gsub(/^"|"$/, "", t)
                    if (t == "" || t == "none") { continue }
                    pat = 0
                    if (t ~ /#N$/) {
                        sub(/[[:space:]]*#N$/, "", t)
                        pat = 1
                    }
                    print name "|" FILENAME "|" line "|" t "|" pat
                }
            }
        ' "$file"
    else
        module="${base#ai-policy-}"
        module="${module%.md}"
        awk -v module="$module" '
            /^## Triggers[[:space:]]*$/ { in_trig = 1; next }
            in_trig && /^##[[:space:]]/ { in_trig = 0 }
            in_trig && /^- / {
                t = $0
                sub(/^- /, "", t)
                print module "|" FILENAME "|" NR "|" t "|0"
            }
        ' "$file"
    fi
}

for file in "$@"; do
    file_fail=0

    if [ ! -f "$file" ]; then
        fail_msg "$file" "0" "file not found"
        continue
    fi

    case "$(basename "$file")" in
        AGENTS.md)
            check_agents_file "$file"
            ;;
        *)
            if [ "$MODE" = default ]; then
                check_policy_file "$file"
            else
                check_policy_name "$file"
                title_line="$(first_match_line "$file" '^# AI (Policy|Assistant Policy): .+')"
                if [ -n "$title_line" ]; then
                    purpose_line="$(purpose_line_for "$file" "$title_line")"
                else
                    purpose_line=""
                fi
                check_trigger_block "$file" "$title_line" "$purpose_line"
            fi
            ;;
    esac

    while IFS='|' read -r module f ln raw pattern; do
        [ -z "$raw" ] && continue
        norm="$(normalize_phrase "$raw")"
        if [ -z "$norm" ]; then
            fail_msg "$f" "$ln" "invalid trigger block: empty phrase"
            continue
        fi
        printf '%s|%s|%s|%s|%s\n' "$module" "$f" "$ln" "$norm" "$pattern" >> "$TRIGGERS_FILE"
    done < <(collect_raw_triggers "$file")

    if [ "$file_fail" -eq 0 ]; then
        pass_msg "$file"
    fi
done

if [ -s "$TRIGGERS_FILE" ]; then
    while IFS='|' read -r phrase locs; do
        printf '[FAILED] duplicate trigger: "%s"%s\n' "$phrase" "$locs"
        fail=1
    done < <(sort -t'|' -k4,4 "$TRIGGERS_FILE" | awk -F'|' '
        {
            if ($4 != prev) {
                if (prev != "" && mod_count > 1) { print prev "|" locs }
                prev = $4
                mod_count = 0
                mods = ""
                locs = ""
            }
            if (index(" " mods " ", " " $1 " ") == 0) {
                mods = mods " " $1
                mod_count++
            }
            locs = locs " " $2 ":" $3
        }
        END {
            if (prev != "" && mod_count > 1) { print prev "|" locs }
        }
    ')

    while IFS='|' read -r a aloc b bloc; do
        printf '[FAILED] trigger overlap: "%s" (%s) is contained in "%s" (%s)\n' "$a" "$aloc" "$b" "$bloc"
        fail=1
    done < <(awk -F'|' '
        {
            n++
            mod[n] = $1
            loc[n] = $2 ":" $3
            raw[n] = $4
            phr[n] = " " $4 " "
        }
        END {
            for (i = 1; i <= n; i++) {
                for (j = i + 1; j <= n; j++) {
                    if (mod[i] == mod[j]) { continue }
                    if (phr[i] != phr[j] && index(phr[j], phr[i]) > 0) {
                        print raw[i] "|" loc[i] "|" raw[j] "|" loc[j]
                    } else if (phr[i] != phr[j] && index(phr[i], phr[j]) > 0) {
                        print raw[j] "|" loc[j] "|" raw[i] "|" loc[i]
                    }
                }
            }
        }
    ' "$TRIGGERS_FILE")
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: authoring validation found violations."
    exit 1
fi

echo "PASSED: authoring validation."
exit 0
