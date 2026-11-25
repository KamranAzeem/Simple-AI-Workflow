#!/usr/bin/env bash
# Optional maintainer protocol index tool. Not used at boot.
# Usage: timeout 20 bash support-files/index-protocol.sh
# The helper calls the dev index, then sets effective and conflict on the module lines.

set -u
export LC_ALL=C

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
PROJECT_ROOT="$(pwd -P)"
VALIDATOR="$SCRIPT_DIR/validate-policy-authoring.sh"

if [ ! -f "$VALIDATOR" ]; then
    printf 'helper: validator not found\n' >&2
    exit 2
fi

declare -a files=()
declare -A seen=()

add_files() {
    local root="$1"
    [ -d "$root" ] || return 0
    local f dir canon
    while IFS= read -r -d '' f; do
        dir="$(cd "$(dirname "$f")" && pwd -P)" || continue
        canon="$dir/$(basename "$f")"
        [ -n "${seen[$canon]:-}" ] && continue
        seen[$canon]=1
        files+=("$f")
    done < <(find "$root" \( -name '.*' -o -name tmp -o -name '*.tar' -o -name '*.tar.gz' -o -name '*.tgz' -o -name '*.tar.bz2' -o -name '*.tar.xz' -o -name '*.zip' \) -prune -o -type f -name '*.md' -print0 2>/dev/null)
}

add_files "$WORKFLOW_DIR/ai/policies"
add_files "$WORKFLOW_DIR/ai/procedures"
add_files "$PROJECT_ROOT/ai/policies"

if [ "${#files[@]}" -eq 0 ]; then
    printf 'helper: no modules found\n' >&2
    exit 2
fi

project_is_workflow=0
if [ "$PROJECT_ROOT" = "$WORKFLOW_DIR" ]; then
    project_is_workflow=1
fi

dev_out="$(bash "$VALIDATOR" --index "${files[@]}" 2>&1)"
rc=$?

printf '%s\n' "$dev_out" | awk -F'|' \
    -v project_root="$PROJECT_ROOT" \
    -v project_is_workflow="$project_is_workflow" '
function norm(s,  t) {
    t = tolower(s)
    gsub(/[^a-z0-9]/, " ", t)
    gsub(/ +/, " ", t)
    sub(/^ /, "", t)
    sub(/ $/, "", t)
    sub(/ #?[0-9]+$/, "", t)
    return t
}
function add_conf(i, item,  n, a, j) {
    if (item == "") return
    n = split(conf[i], a, ",")
    for (j = 1; j <= n; j++) if (a[j] == item) return
    conf[i] = (conf[i] == "" ? item : conf[i] "," item)
}
function sort_conf(s,  n, a, i, j, tmp, out) {
    n = split(s, a, ",")
    for (i = 2; i <= n; i++) {
        tmp = a[i]
        for (j = i - 1; j >= 1 && a[j] > tmp; j--) a[j + 1] = a[j]
        a[j + 1] = tmp
    }
    out = ""
    for (i = 1; i <= n; i++) out = out (i > 1 ? "," : "") a[i]
    return out
}
{
    all[NR] = $0
    if ($1 != "policy" && $1 != "procedure") next
    n++
    is_module[NR] = 1
    mod_index[NR] = n
    type[n] = $1
    scope[n] = $2
    name[n] = $3
    source[n] = $4
    mode[n] = $5
    trig[n] = $6
    head[n] = $7
    eff[n] = "yes"
    conf[n] = ""
    if (!project_is_workflow && $2 == "workflow" && index(source[n], project_root "/ai/policies/") == 1) {
        scope[n] = "project"
    }
    t = trig[n]
    sub(/^triggers=/, "", t)
    if (t != "" && t != "none") {
        nt = split(t, parts, ";")
        for (k = 1; k <= nt; k++) {
            z = norm(parts[k])
            if (z != "") {
                tc[n]++
                tn[n, tc[n]] = z
            }
        }
    }
}
END {
    for (i = 1; i <= n; i++) {
        if (scope[i] != "project" || type[i] != "policy") continue
        for (j = 1; j <= n; j++) {
            if (scope[j] == "workflow" && type[j] == "policy" && name[j] == name[i]) {
                eff[j] = "shadowed:" name[i]
            }
        }
    }
    for (i = 1; i <= n; i++) {
        for (j = i + 1; j <= n; j++) {
            if (type[i] == "policy" && type[j] == "policy" && name[i] == name[j] &&
                ((scope[i] == "workflow" && eff[i] == "shadowed:" name[j]) ||
                 (scope[j] == "workflow" && eff[j] == "shadowed:" name[i]))) continue
            for (x = 1; x <= tc[i]; x++) {
                for (y = 1; y <= tc[j]; y++) {
                    a = tn[i, x]
                    b = tn[j, y]
                    if (a == b) {
                        add_conf(i, "duplicate:" name[j])
                        add_conf(j, "duplicate:" name[i])
                    } else if (index(" " b " ", " " a " ") > 0) {
                        add_conf(i, "overlap:" name[j])
                        add_conf(j, "overlap:" name[i])
                    } else if (index(" " a " ", " " b " ") > 0) {
                        add_conf(i, "overlap:" name[j])
                        add_conf(j, "overlap:" name[i])
                    }
                }
            }
        }
    }
    for (l = 1; l <= NR; l++) {
        if (!is_module[l]) {
            print all[l]
            continue
        }
        m = mod_index[l]
        printf "%s|%s|%s|%s|%s|%s|%s|effective=%s|conflict=%s\n", \
            type[m], scope[m], name[m], source[m], mode[m], trig[m], head[m], \
            eff[m], (conf[m] == "" ? "none" : sort_conf(conf[m]))
    }
}
'

exit "$rc"
