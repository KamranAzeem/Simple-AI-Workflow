#!/bin/bash
# Validate the authoring shape of AGENTS.md, policy files, and procedure modules.
# Usage: ./support-files/validate-policy-authoring.sh [--triggers|--index] <file> [<file>...]
#   --triggers  check the trigger namespace and names for policies, and the procedure-module shape; skip the full policy shape.
#   --index     print the read-only module index and a summary; tolerate shape gaps, fail only on an unreadable module, an invalid trigger block, or a name mismatch.
# Exit 0 when all checks pass, 1 on a violation, 2 on a usage error.

set -u
export LC_ALL=C

MODE=default
if [ "${1:-}" = "--triggers" ]; then
    MODE=triggers
    shift
elif [ "${1:-}" = "--index" ]; then
    MODE=index
    shift
fi

if [ "$MODE" = index ] && [ "$#" -eq 0 ]; then
    set -- ai/policies/*.md ai/procedures/*.md
fi

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [--triggers|--index] <file> [<file>...]" >&2
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

check_thin_agents() {
    local file="$1" ln step section

    if grep -qE '^### PROCEDURE |^# PROCEDURE |^\*\*Aliases\*\*:' "$file"; then
        ln="$(grep -nE '^### PROCEDURE |^# PROCEDURE |^\*\*Aliases\*\*:' "$file" | cut -d: -f1 | head -1)"
        fail_msg "$file" "$ln" "procedure content is not allowed in the thin AGENTS.md"
    fi
    if grep -qE '^\*\*Loads\*\*:' "$file"; then
        ln="$(grep -nE '^\*\*Loads\*\*:' "$file" | cut -d: -f1 | head -1)"
        fail_msg "$file" "$ln" "**Loads** line is not allowed"
    fi

    while IFS=: read -r ln step; do
        [ -n "$ln" ] || continue
        if ! printf '%s' "$step" | grep -qE '\*\*STEP-(PROTOCOL|SKILLS)-INDEX\*\*'; then
            fail_msg "$file" "$ln" "shared step definition is not allowed in the thin AGENTS.md"
        fi
    done < <(grep -nE '\*\*STEP-[A-Z0-9-]+\*\*' "$file")

    for section in '## TIER CONFIGURATION' '## TIER READ-FIRST-RULES' '## Shared Protocol Steps' '## Protocol Dispatch' '## TIER TRIGGERED-PROCEDURES' '## TIER APPENDIX'; do
        if ! grep -qxF "$section" "$file"; then
            fail_msg "$file" "0" "missing required section: $section"
        fi
    done
}

check_procedure_module() {
    local file="$1" base name stem title_line trig_line count ln line raw base_phrase norm bullets first_section intervening

    base="$(basename "$file")"
    title_line="$(first_match_line "$file" '^# PROCEDURE [A-Z][A-Z0-9-]*: .+')"
    if [ -z "$title_line" ]; then
        fail_msg "$file" "0" "invalid policy shape: procedure module missing '# PROCEDURE <NAME>: <description>'"
    else
        name="$(sed -n "${title_line}p" "$file" | sed -E 's/^# PROCEDURE ([A-Z][A-Z0-9-]*): .*/\1/')"
        stem="${base%.md}"
        if [ "$stem" != "$(printf '%s' "$name" | tr 'A-Z' 'a-z')" ]; then
            fail_msg "$file" "$title_line" "name mismatch: file stem '$stem' must match the lowercase procedure name"
        fi
    fi

    if ! sed -n '1p' "$file" | grep -qE '^# PROCEDURE [A-Z][A-Z0-9-]*: .+'; then
        fail_msg "$file" "1" "invalid policy shape: procedure module must start with '# PROCEDURE <NAME>: <description>'"
    fi

    if grep -qE '^\*\*Loads\*\*:' "$file"; then
        ln="$(grep -nE '^\*\*Loads\*\*:' "$file" | cut -d: -f1 | head -1)"
        fail_msg "$file" "$ln" "**Loads** line is not allowed"
    fi

    first_section="$(awk 'NR > 1 && /^## / { print NR; exit }' "$file")"
    if [ -n "$first_section" ] && ! sed -n "${first_section}p" "$file" | grep -qE '^## Triggers[[:space:]]*$'; then
        fail_msg "$file" "$first_section" "invalid policy shape: '## Triggers' must be the first section"
    fi

    if grep -qE '^\*\*Aliases\*\*:' "$file"; then
        ln="$(grep -nE '^\*\*Aliases\*\*:' "$file" | cut -d: -f1 | head -1)"
        fail_msg "$file" "$ln" "aliases are not allowed in a procedure module"
    fi

    count="$(count_matches "$file" '^## Triggers[[:space:]]*$')"
    if [ "$count" -eq 0 ]; then
        fail_msg "$file" "0" "missing triggers: procedure module needs a '## Triggers' section"
        return 0
    fi
    if [ "$count" -gt 1 ]; then
        fail_msg "$file" "0" "invalid trigger block: more than one '## Triggers' section"
        return 0
    fi

    trig_line="$(first_match_line "$file" '^## Triggers[[:space:]]*$')"
    intervening="$(awk -v end="$trig_line" 'NR > 1 && NR < end && !/^[[:space:]]*$/ { print NR; exit }' "$file")"
    if [ -n "$intervening" ]; then
        fail_msg "$file" "$intervening" "invalid policy shape: '## Triggers' must immediately follow the H1"
    fi
    bullets=0
    ln=$trig_line
    while IFS= read -r line; do
        ln=$((ln + 1))
        if [ -z "$line" ]; then
            if [ "$bullets" -gt 0 ]; then
                break
            fi
            continue
        fi
        if ! printf '%s\n' "$line" | grep -qE '^- [A-Za-z0-9 .#-]+$'; then
            fail_msg "$file" "$ln" "invalid trigger block: '$line'"
            continue
        fi
        raw="${line#- }"
        base_phrase="$raw"
        case "$base_phrase" in
            *'#N') base_phrase="${base_phrase%#N}" ;;
        esac
        if printf '%s' "$base_phrase" | grep -q '#' || ! printf '%s' "$base_phrase" | grep -qE '^[a-z0-9 .-]+$'; then
            fail_msg "$file" "$ln" "invalid trigger block: only lowercase text and one trailing #N are allowed"
            continue
        fi
        norm="$(normalize_phrase "$base_phrase")"
        if [ -z "$norm" ]; then
            fail_msg "$file" "$ln" "invalid trigger block: empty phrase"
            continue
        fi
        bullets=$((bullets + 1))
    done < <(sed -n "$((trig_line + 1)),\$p" "$file")
    if [ "$bullets" -eq 0 ]; then
        fail_msg "$file" "$trig_line" "empty trigger block"
    fi
}

collect_raw_triggers() {
    local file="$1" base module name
    base="$(basename "$file")"
    case "$file" in
        ai/procedures/*|*/ai/procedures/*)
            name="$(sed -n '1s/^# PROCEDURE \([A-Z][A-Z0-9-]*\): .*/\1/p' "$file")"
            awk -v module="procedure:$name" '
                /^## Triggers[[:space:]]*$/ { in_trig = 1; seen = 0; next }
                in_trig && /^[[:space:]]*$/ { if (seen) { in_trig = 0 }; next }
                in_trig && /^- / {
                    seen = 1
                    t = $0
                    sub(/^- /, "", t)
                    pat = 0
                    if (t ~ /#N$/) {
                        sub(/[[:space:]]*#N$/, "", t)
                        pat = 1
                    }
                    print module "|" FILENAME "|" NR "|" t "|" pat
                    next
                }
                in_trig { in_trig = 0 }
            ' "$file"
            ;;
        AGENTS.md)
            return 0
            ;;
        *)
            module="policy:${base#ai-policy-}"
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
            ;;
    esac
}

index_mode() {
    local fatal=0 modules=0 policies=0 procedures=0 triggers_total=0 errors_total=0 conflicts=0
    local file base type name source trigs headings shape_out shape_count error_classes
    local idxdir
    idxdir="$(mktemp -d)"
    : > "$idxdir/trig"
    : > "$idxdir/errors"

    for file in "$@"; do
        if [ ! -f "$file" ] || [ ! -r "$file" ]; then
            printf '[FAILED] %s:0: unreadable module\n' "$file"
            fatal=1
            continue
        fi
        base="$(basename "$file")"
        case "$file" in
            */ai/procedures/*|ai/procedures/*)
                type=procedure
                name="$(sed -n '1s/^# PROCEDURE \([A-Z][A-Z0-9-]*\): .*/\1/p' "$file")"
                [ -n "$name" ] || name="${base%.md}"
                procedures=$((procedures + 1))
                ;;
            *)
                type=policy
                name="${base#ai-policy-}"
                name="${name%.md}"
                policies=$((policies + 1))
                ;;
        esac
        source="$file"
        trigs="$(awk '
            /^## Triggers[[:space:]]*$/ { in_trig = 1; next }
            in_trig && /^##[[:space:]]/ { in_trig = 0 }
            in_trig && /^- / { t = $0; sub(/^- /, "", t); printf "%s%s", sep, t; sep = ";" }
        ' "$file")"
        headings="$(grep -E '^#{1,6} ' "$file" | sed 's/|/ /g' | awk '{ printf "%s%s", sep, $0; sep = ";" }')"
        printf '%s|global|%s|%s|triggers=%s|headings=%s|effective=yes|conflict=none\n' \
            "$type" "$name" "$source" "${trigs:-none}" "${headings:-none}"

        while IFS='|' read -r _ f ln raw pattern; do
            [ -z "$raw" ] && continue
            norm="$(normalize_phrase "$raw")"
            [ -z "$norm" ] && continue
            printf '%s|%s|%s|%s|%s\n' "$type:$name" "$f" "$ln" "$norm" "$pattern" >> "$idxdir/trig"
            triggers_total=$((triggers_total + 1))
        done < <(collect_raw_triggers "$file")

        shape_out="$(bash "$0" "$file" 2>&1 || true)"
        shape_count="$(printf '%s\n' "$shape_out" | grep -c '^\[FAILED\]' || true)"
        errors_total=$((errors_total + shape_count))
        if printf '%s\n' "$shape_out" | grep -qE 'invalid trigger block|empty trigger block|missing triggers|name mismatch|unreadable module'; then
            fatal=1
        fi
        printf '%s\n' "$shape_out" | grep -oE 'invalid policy shape|invalid trigger block|empty trigger block|missing triggers|name mismatch|unreadable module' >> "$idxdir/errors" || true
        modules=$((modules + 1))
    done

    if [ -s "$idxdir/trig" ]; then
        conflicts="$(awk -F'|' '
            {
                n++
                mod[n] = $1
                phr[n] = " " $4 " "
            }
            END {
                c = 0
                for (i = 1; i <= n; i++) {
                    for (j = i + 1; j <= n; j++) {
                        if (mod[i] == mod[j]) { continue }
                        if (phr[i] == phr[j] || index(phr[j], phr[i]) > 0 || index(phr[i], phr[j]) > 0) { c++ }
                    }
                }
                print c
            }
        ' "$idxdir/trig")"
    fi

    error_classes="$(sort "$idxdir/errors" | uniq -c | awk '{ printf "%s%s=%s", sep, substr($0, index($0, $2)), $1; sep = "," }')"

    printf 'summary|modules=%s|policies=%s|procedures=%s|triggers=%s|conflicts=%s|errors=%s|error_classes=%s\n' \
        "$modules" "$policies" "$procedures" "$triggers_total" "$conflicts" "$errors_total" "${error_classes:-none}"
    rm -rf "$idxdir"
    if [ "$fatal" -ne 0 ]; then
        exit 1
    fi
    exit 0
}

if [ "$MODE" = index ]; then
    index_mode "$@"
fi

for file in "$@"; do
    file_fail=0

    if [ ! -f "$file" ]; then
        fail_msg "$file" "0" "file not found"
        continue
    fi

    case "$file" in
        ai/procedures/*|*/ai/procedures/*)
            check_procedure_module "$file"
            ;;
        *)
            case "$(basename "$file")" in
                AGENTS.md)
                    check_thin_agents "$file"
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
