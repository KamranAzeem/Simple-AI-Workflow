#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d /tmp/kilo/skills-fixture.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

GLOBAL="$WORK/global"
PROJECT="$WORK/project"
mkdir -p "$GLOBAL" "$PROJECT/ai/skills"

make_skill() {
    local dir="$1" name="$2" desc="$3" body="$4"
    mkdir -p "$dir"
    printf -- '---\nname: %s\ndescription: %s\n---\n\n%s\n' "$name" "$desc" "$body" > "$dir/SKILL.md"
}

make_skill "$GLOBAL/alpha" "alpha" "Global alpha skill." "GLOBAL-BODY-CANARY"
make_skill "$PROJECT/ai/skills/alpha" "alpha" "Project alpha skill." "PROJECT-BODY-CANARY"
make_skill "$PROJECT/ai/skills/beta" "beta" "Project beta skill." "BETA-BODY-CANARY"
make_skill "$PROJECT/ai/skills/gamma" "gamma" "" "GAMMA-BODY-CANARY"
make_skill "$PROJECT/ai/skills/wrong-name" "delta" "Name does not match the directory." "DELTA-BODY-CANARY"
make_skill "$PROJECT/ai/skills/nested/inner" "inner" "Nested skill." "NESTED-BODY-CANARY"
make_skill "$PROJECT/ai/skills/.hidden" "hidden" "Hidden skill." "HIDDEN-BODY-CANARY"
make_skill "$PROJECT/ai/skills/cloud" "cloud" "Cloud skill." "CLOUD-BODY-CANARY"
make_skill "$PROJECT/ai/skills/long-description" "long-description" "$(printf 'x%.0s' $(seq 1 201))" "LONG-BODY-CANARY"
ln -s "$PROJECT/ai/skills/beta" "$PROJECT/ai/skills/linked"

frontmatter_value() {
    local file="$1" key="$2"
    awk -v key="$key" '
        NR == 1 && $0 == "---" { in_fm = 1; next }
        in_fm && $0 == "---" { exit }
        in_fm && index($0, key ": ") == 1 { sub("^" key ": ", ""); print; exit }
    ' "$file"
}

discover() {
    local base="$1" scope="$2" dir name desc
    while IFS= read -r dir; do
        [ -L "$dir" ] && { printf 'REPORT|symlink|%s\n' "$dir"; continue; }
        [ -f "$dir/SKILL.md" ] || { printf 'REPORT|missing SKILL.md|%s\n' "$dir"; continue; }
        [ -L "$dir/SKILL.md" ] && { printf 'REPORT|symlink|%s\n' "$dir"; continue; }
        name="$(frontmatter_value "$dir/SKILL.md" name)"
        desc="$(frontmatter_value "$dir/SKILL.md" description)"
        [ -n "$name" ] || { printf 'REPORT|missing name|%s\n' "$dir"; continue; }
        [ -n "$desc" ] || { printf 'REPORT|missing description|%s\n' "$dir"; continue; }
        [ "$(basename "$dir")" = "$name" ] || { printf 'REPORT|name mismatch|%s\n' "$dir"; continue; }
        printf '%s\n' "$(basename "$dir")" | grep -qE '^[a-z0-9][a-z0-9-]*$' || { printf 'REPORT|bad directory name|%s\n' "$dir"; continue; }
        [ "${#desc}" -le 200 ] || { printf 'REPORT|description over 200 characters|%s\n' "$dir"; continue; }
        printf 'SKILL|%s|%s|%s|%s\n' "$name" "$desc" "$dir" "$scope"
    done < <(find "$base" -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name 'tmp' | LC_ALL=C sort)
}

MODULES="cloud data load-context"

build_index() {
    local global_lines project_lines name
    global_lines="$(discover "$GLOBAL" global)"
    project_lines="$(discover "$PROJECT/ai/skills" project)"
    while IFS='|' read -r kind name _ _ _; do
        [ "$kind" = "SKILL" ] || continue
        printf '%s\n' "$project_lines" | awk -F'|' -v n="$name" '$1 == "SKILL" && $2 == n { found = 1 } END { exit(found ? 0 : 1) }' \
            && printf 'REPORT|override|%s\n' "$name"
    done < <(printf '%s\n' "$global_lines")
    printf '%s\n' "$global_lines" | awk -F'|' -v plist="$project_lines" '
        $1 == "SKILL" {
            split(plist, p, "\n")
            for (i in p) { split(p[i], f, "|"); if (f[1] == "SKILL" && f[2] == $2) next }
            print
        }
        $1 != "SKILL" { print }
    '
    printf '%s\n' "$project_lines"
    while IFS='|' read -r kind name _ _ _; do
        [ "$kind" = "SKILL" ] || continue
        case " $MODULES " in *" $name "*) printf 'REPORT|collision with a policy or procedure name|%s\n' "$name" ;; esac
    done < <(printf '%s\n' "$project_lines")
}

fail=0
index="$(build_index)"
check() { if ! printf '%s\n' "$index" | grep -q "$1"; then echo "FAIL: $2"; fail=1; fi; }
refute() { if printf '%s\n' "$index" | grep -q "$1"; then echo "FAIL: $2"; fail=1; fi; }

check 'SKILL|alpha|Project alpha skill.|.*/project/ai/skills/alpha|project' "project alpha is not indexed"
check 'REPORT|override|alpha' "project-over-global override is not reported"
refute 'SKILL|alpha|Global alpha skill.' "global alpha is still indexed after the override"
check 'SKILL|beta|Project beta skill.' "project beta is not indexed"
check 'REPORT|collision with a policy or procedure name|cloud' "cross-type collision is not reported"
check 'REPORT|missing description|.*/gamma' "missing description is not reported"
check 'REPORT|name mismatch|.*/wrong-name' "directory-name mismatch is not reported"
check 'REPORT|description over 200 characters|.*/long-description' "long description is not reported"
refute 'inner' "nested skill was discovered"
refute 'hidden' "hidden skill was discovered"
refute 'linked' "symlinked skill was discovered"
refute 'BODY-CANARY' "a skill body was read"
bytes=$(printf '%s' "$index" | wc -c)
if [ "$bytes" -gt 16384 ]; then echo "FAIL: skills index is $bytes bytes, over the 16 KB bound."; fail=1; fi

require_in() {
    if ! grep -q "$2" "$ROOT/$1"; then echo "FAIL: $3"; fail=1; fi
}
require_in "AGENTS.md" "STEP-SKILLS-INDEX" "AGENTS.md does not define STEP-SKILLS-INDEX."
require_in "AGENTS.md" "Global AI Skills Directory" "AGENTS.md does not name the global skills directory."
require_in "AGENTS.md" "Project AI Skills Directory" "AGENTS.md does not name the project skills directory."
require_in "AGENTS.md" "use skill <name>" "AGENTS.md does not dispatch use skill."
require_in "AGENTS.md" "200 characters" "AGENTS.md does not cap the description."
require_in "AGENTS.md" "a helper needs explicit approval" "AGENTS.md does not gate a skill helper."
require_in "ai/procedures/load-context.md" "ITEM SKILLS-INDEX" "load-context does not report ITEM SKILLS-INDEX."
require_in "ai/policies/ai-policy-common.md" "^## Skills$" "the common policy has no Skills section."
require_in "ai/policies/ai-policy-common.md" "200 characters" "the common policy does not cap the description."
require_in "ai/policies/ai-policy-common.md" "the user is responsible" "the common policy does not state the user responsibility."
require_in "ai/procedures/write-checkpoint.md" "package names" "the checkpoint does not record package names."
require_in "ai/procedures/repair-knowledge-files.md" "never edits a skill package" "the repair boundary does not exclude skills."
if [ "$(wc -l < "$ROOT/AGENTS.md")" -gt 160 ] || [ "$(wc -c < "$ROOT/AGENTS.md")" -gt 24900 ]; then
    echo "FAIL: AGENTS.md exceeds the thin targets."; fail=1
fi

if [ "$fail" -ne 0 ]; then
    echo "FAILED: skills index fixture."
    exit 1
fi
echo "PASSED: skills index fixture (package, frontmatter, one-level, override, collision, description, no body, 16 KB)."
exit 0
