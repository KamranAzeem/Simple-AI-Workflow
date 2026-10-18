#!/bin/bash
# Validate the authoring shape of AGENTS.md and policy files.
# Usage: ./support-files/validate-policy-authoring.sh <file> [<file>...]
# Exit 0 when all checks pass, 1 on a violation, 2 on a usage error.

set -u

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <file> [<file>...]" >&2
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

check_policy_file() {
    local file="$1" base title_line purpose_line purpose_text domain_sections readonly_start_line readonly_end_line

    base="$(basename "$file")"

    case "$file" in
        ai/policies/*|*/ai/policies/*)
            if ! printf '%s\n' "$base" | grep -qE '^ai-policy-[a-z0-9][a-z0-9-]*\.md$'; then
                fail_msg "$file" "0" "policy filename must match ai-policy-<domain>.md"
            fi
            ;;
    esac

    title_line="$(first_match_line "$file" '^# AI Policy: .+')"
    case "$file" in
        ai/policies/ai-policy-common.md|*/ai/policies/ai-policy-common.md)
            if [ -z "$title_line" ]; then
                title_line="$(first_match_line "$file" '^# AI Assistant Policy: .+')"
            fi
            ;;
    esac
    if [ -z "$title_line" ]; then
        fail_msg "$file" "0" "missing policy title '# AI Policy: <Domain>'"
    fi

    if ! sed -n '1p' "$file" | grep -q 'DO NOT MODIFY'; then
        fail_msg "$file" "1" "missing DO NOT MODIFY guard"
    fi

    readonly_start_line="$(first_match_line "$file" '^<!-- AI-ASSISTANT: READ-ONLY START -->$')"
    readonly_end_line="$(first_match_line "$file" '^<!-- AI-ASSISTANT: READ-ONLY END -->$')"

    if [ -z "$readonly_start_line" ]; then
        fail_msg "$file" "0" "missing READ-ONLY START marker"
    fi

    if [ -z "$readonly_end_line" ]; then
        fail_msg "$file" "0" "missing READ-ONLY END marker"
    fi

    if [ -n "$title_line" ] && [ -n "$readonly_start_line" ] && [ "$title_line" -lt "$readonly_start_line" ]; then
        fail_msg "$file" "$title_line" "policy title must appear after the READ-ONLY START marker"
    fi

    if [ -n "$title_line" ] && [ -n "$readonly_end_line" ] && [ "$readonly_end_line" -lt "$title_line" ]; then
        fail_msg "$file" "$title_line" "READ-ONLY END marker must appear after the policy title"
    fi

    if [ -n "$title_line" ]; then
        purpose_line="$(awk -v start="$title_line" '
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
        ' "$file")"

        if [ -z "$purpose_line" ]; then
            fail_msg "$file" "$title_line" "missing one-line purpose below the title"
        else
            purpose_text="$(sed -n "${purpose_line}p" "$file")"
            case "$purpose_text" in
                \#*|\>*|-*|'<!--'*)
                    fail_msg "$file" "$purpose_line" "purpose must be a one-line sentence"
                    ;;
            esac
        fi
    fi

    if ! grep -qE '^## Scope[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "missing '## Scope' heading"
    fi

    if ! grep -qE '^## References[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "missing '## References' heading"
    fi

    domain_sections="$(grep -E '^## ' "$file" | sed 's/^## //; s/[[:space:]]*$//' | grep -vE '^(Scope|References|Purpose|Notes)$')"
    if [ -z "$domain_sections" ]; then
        fail_msg "$file" "0" "missing '## Rules' or a domain-named section"
    fi

    if grep -qE '^## Purpose[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "'## Purpose' heading is not allowed"
    fi

    if grep -qE '^## Notes[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "'## Notes' heading is not allowed"
    fi

    if grep -qE '^## Triggers[[:space:]]*$' "$file"; then
        fail_msg "$file" "0" "'## Triggers' is reserved for the plugin model"
    fi
}

check_agents_file() {
    local file="$1" ln msg

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

    if grep -qE '^\*\*Loads\*\*:' "$file"; then
        ln="$(grep -nE '^\*\*Loads\*\*:' "$file" | cut -d: -f1 | tr '\n' ' ')"
        fail_msg "$file" "$ln" "**Loads** line is not allowed"
    fi
}

collect_triggers() {
    local file="$1"

    if [ "$(basename "$file")" = "AGENTS.md" ]; then
        awk '
            /^\*\*Aliases\*\*:/ {
                sub(/^\*\*Aliases\*\*:[[:space:]]*/, "")
                n = split($0, parts, ";")
                for (i = 1; i <= n; i++) {
                    t = parts[i]
                    gsub(/^[ \t]+/, "", t)
                    gsub(/[ \t]+$/, "", t)
                    if (t != "" && t != "none") { print t }
                }
            }
        ' "$file" | tr '[:upper:]' '[:lower:]' | sed 's/^"//; s/"$//' >> "$TRIGGERS_FILE"
    fi
}

for file in "$@"; do
    file_fail=0

    if [ ! -f "$file" ]; then
        fail_msg "$file" "0" "file not found"
        continue
    fi

    case "$(basename "$file")" in
        AGENTS.md) check_agents_file "$file" ;;
        *) check_policy_file "$file" ;;
    esac

    collect_triggers "$file"

    if [ "$file_fail" -eq 0 ]; then
        pass_msg "$file"
    fi
done

if [ -s "$TRIGGERS_FILE" ]; then
    dups="$(sort "$TRIGGERS_FILE" | uniq -d)"
    if [ -n "$dups" ]; then
        while IFS= read -r t; do
            if [ -n "$t" ]; then
                printf '[FAILED] duplicate trigger phrase: "%s"\n' "$t"
                fail=1
            fi
        done <<< "$dups"
    fi
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: authoring validation found violations."
    exit 1
fi

echo "PASSED: authoring validation."
exit 0
