#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d /tmp/kilo/skills-fixture.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

GLOBAL="$WORK/global"
PROJECT="$WORK/project"
TEAM="$WORK/team"
mkdir -p "$GLOBAL" "$PROJECT/ai/skills" "$TEAM/skills"

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

make_skill "$GLOBAL/team-global" "team-global" "Global team-global skill." "GLOBAL-TEAM-GLOBAL-BODY-CANARY"
make_skill "$TEAM/skills/alpha" "alpha" "Team alpha skill." "TEAM-ALPHA-BODY-CANARY"
make_skill "$TEAM/skills/team-only" "team-only" "Team only skill." "TEAM-ONLY-BODY-CANARY"
make_skill "$TEAM/skills/team-global" "team-global" "Team team-global skill." "TEAM-TEAM-GLOBAL-BODY-CANARY"
make_skill "$TEAM/skills/cloud" "cloud" "Team cloud skill." "TEAM-CLOUD-BODY-CANARY"
make_skill "$TEAM/skills/team-bad" "team-bad" "" "TEAM-BAD-BODY-CANARY"
make_skill "$TEAM/skills/nested/inner" "inner" "Nested team skill." "TEAM-NESTED-BODY-CANARY"
make_skill "$TEAM/skills/.hidden" "hidden-team" "Hidden team skill." "TEAM-HIDDEN-BODY-CANARY"
ln -s "$TEAM/skills/team-only" "$TEAM/skills/team-link"

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
    local global_lines team_lines project_lines name
    global_lines="$(discover "$GLOBAL" global)"
    team_lines="$(discover "$TEAM/skills" team)"
    project_lines="$(discover "$PROJECT/ai/skills" project)"

    while IFS='|' read -r kind name _ _ _; do
        [ "$kind" = "SKILL" ] || continue
        printf '%s\n' "$team_lines" | awk -F'|' -v n="$name" '$1 == "SKILL" && $2 == n { found = 1 } END { exit(found ? 0 : 1) }' \
            && printf 'REPORT|override|%s\n' "$name"
        printf '%s\n' "$global_lines" | awk -F'|' -v n="$name" '$1 == "SKILL" && $2 == n { found = 1 } END { exit(found ? 0 : 1) }' \
            && printf 'REPORT|override|%s\n' "$name"
    done < <(printf '%s\n' "$project_lines")

    while IFS='|' read -r kind name _ _ _; do
        [ "$kind" = "SKILL" ] || continue
        printf '%s\n' "$global_lines" | awk -F'|' -v n="$name" '$1 == "SKILL" && $2 == n { found = 1 } END { exit(found ? 0 : 1) }' \
            && printf 'REPORT|override|%s\n' "$name"
    done < <(printf '%s\n' "$team_lines")

    printf '%s\n' "$global_lines" | awk -F'|' -v tlist="$team_lines" -v plist="$project_lines" '
        $1 == "SKILL" {
            split(tlist, t, "\n")
            for (i in t) { split(t[i], f, "|"); if (f[1] == "SKILL" && f[2] == $2) next }
            split(plist, p, "\n")
            for (i in p) { split(p[i], f, "|"); if (f[1] == "SKILL" && f[2] == $2) next }
            print
        }
        $1 != "SKILL" { print }
    '
    printf '%s\n' "$team_lines" | awk -F'|' -v plist="$project_lines" '
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
    done < <(printf '%s\n' "$team_lines" "$project_lines")
}

fail=0
index="$(build_index)"
check() { if ! printf '%s\n' "$index" | grep -q "$1"; then echo "FAIL: $2"; fail=1; fi; }
refute() { if printf '%s\n' "$index" | grep -q "$1"; then echo "FAIL: $2"; fail=1; fi; }

check 'SKILL|alpha|Project alpha skill.|.*/project/ai/skills/alpha|project' "project alpha is not indexed"
check 'REPORT|override|alpha' "the project-over-team-and-global override is not reported"
refute 'SKILL|alpha|Global alpha skill.' "global alpha is still indexed after the override"
refute 'SKILL|alpha|Team alpha skill.' "team alpha is still indexed after the project override"
check 'SKILL|team-only|Team only skill.|.*/team/skills/team-only|team' "team-only is not indexed"
check 'SKILL|team-global|Team team-global skill.|.*/team/skills/team-global|team' "team does not override global"
refute 'SKILL|team-global|Global team-global skill.' "global team-global is still indexed after the team override"
check 'REPORT|override|team-global' "the team-over-global override is not reported"
check 'SKILL|beta|Project beta skill.' "project beta is not indexed"
check 'REPORT|collision with a policy or procedure name|cloud' "cross-type collision is not reported"
check 'REPORT|missing description|.*/gamma' "missing description is not reported"
check 'REPORT|missing description|.*/team/skills/team-bad' "team missing description is not reported"
check 'REPORT|name mismatch|.*/wrong-name' "directory-name mismatch is not reported"
check 'REPORT|description over 200 characters|.*/long-description' "long description is not reported"
refute 'inner' "nested skill was discovered"
refute 'hidden' "hidden skill was discovered"
refute 'linked' "symlinked project skill was discovered"
refute 'team-link' "symlinked team skill was discovered"
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
require_in "ai/procedures/load-context.md" "200 characters" "load-context does not cap the skill description."
require_in "AGENTS.md" "a helper needs explicit approval" "AGENTS.md does not gate a skill helper."
require_in "ai/procedures/load-context.md" "ITEM SKILLS-INDEX" "load-context does not report ITEM SKILLS-INDEX."
require_in "ai/policies/ai-policy-common.md" "^## Skills$" "the common policy has no Skills section."
require_in "ai/policies/ai-policy-common.md" "200 characters" "the common policy does not cap the description."
require_in "ai/policies/ai-policy-common.md" "the user is responsible" "the common policy does not state the user responsibility."
require_in "ai/procedures/write-checkpoint.md" "package names" "the checkpoint does not record package names."
require_in "ai/procedures/repair-knowledge-files.md" "never edits a skill package" "the repair boundary does not exclude skills."
require_in "AGENTS.md" "configured team root" "AGENTS.md does not name the configured team skills root."
require_in "ai/procedures/load-context.md" "configured team skills root" "load-context does not name the configured team skills root."
require_in "ai/procedures/load-context.md" "skip and report a hidden entry, symlink" "load-context does not require reporting a hidden or symlink entry."
require_in "ai/policies/ai-policy-common.md" "or the configured" "the common policy does not name the team skills root in the Skills section."
require_in "ai/policies/ai-policy-common.md" "Apply the precedence project, then team, then global" "the common policy lacks the team precedence."
require_in "ai/policies/ai-policy-team-knowledge.md" "skills/" "the team policy lacks the skills pointer."
require_in "ai/procedures/post-compaction-recovery.md" "configured team root" "post-compaction does not name the team root."
require_in "ai/procedures/write-checkpoint.md" "configured team root" "the checkpoint does not name the team root."
require_in "ai/procedures/repair-knowledge-files.md" "any skills root" "the repair boundary does not cover every skills root."
require_in "docs/announcements/v7.2.0.md" "# v7.2.0" "the v7.2.0 announcement is missing."
require_in "README.md" "v7.2.0" "README banner does not name v7.2.0."
require_in "README.md" "docs/announcements/v7.2.0.md" "README banner does not link the v7.2.0 announcement."

KANBAN="$ROOT/ai/skills/kanban-board/SKILL.md"
if [ -f "$KANBAN" ]; then
    name="$(frontmatter_value "$KANBAN" name)"
    desc="$(frontmatter_value "$KANBAN" description)"
    [ "$name" = "kanban-board" ] || { echo "FAIL: the Kanban skill name is not kanban-board."; fail=1; }
    [ -n "$desc" ] && [ "${#desc}" -le 200 ] || { echo "FAIL: the Kanban skill description is missing or over 200 characters."; fail=1; }
else
    echo "FAIL: the Kanban skill package is missing."
    fail=1
fi
require_in "ai/skills/kanban-board/SKILL.md" "Read-only" "the Kanban skill is not read-only."
require_in "ai/skills/kanban-board/SKILL.md" "Never create, move, rename, edit, or delete a ticket" "the Kanban skill does not prohibit ticket changes."
require_in "ai/skills/kanban-board/SKILL.md" "Open" "the Kanban skill lacks the Open column."
require_in "ai/skills/kanban-board/SKILL.md" "In progress" "the Kanban skill lacks the In progress column."
require_in "ai/skills/kanban-board/SKILL.md" "Closed" "the Kanban skill lacks the Closed column."
require_in "docs/workflow-guide.md" "kanban-board" "the guide does not document the Kanban skill."
require_in "docs/simple-ai-workflow-slides.md" "kanban-board" "the deck does not mention the Kanban skill."

if [ "$fail" -ne 0 ]; then
    echo "FAILED: skills index fixture."
    exit 1
fi
echo "PASSED: skills index fixture (three roots, package, frontmatter, one-level, overrides, collision, description, no body, 16 KB)."
exit 0
