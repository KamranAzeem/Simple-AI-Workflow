#!/usr/bin/env bash
# sync-agents-md.sh
# Copy the canonical AGENTS.md into initialized project directories and migrate
# the project, user, and team knowledge stores to the scope-normalized layout.
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 --source PATH --target-path PATH [--dry-run]

  --source      : path to the canonical AGENTS.md (required).
  --target-path : directory to search for AGENTS.md files to update (required).
  --dry-run     : show every backup and move without making changes.

Examples:
  $0 --source ../AGENTS.md --target-path /projects --dry-run
  $0 --source ./AGENTS.md --target-path ~/Projects
EOF
}

SOURCE=""
TARGET_PATH=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      if [ $# -lt 2 ] || [[ "$2" == --* ]]; then echo "Missing value for --source" >&2; usage; exit 2; fi
      SOURCE="$2"; shift 2;;
    --target-path)
      if [ $# -lt 2 ] || [[ "$2" == --* ]]; then echo "Missing value for --target-path" >&2; usage; exit 2; fi
      TARGET_PATH="$2"; shift 2;;
    --dry-run) DRY_RUN=1; shift 1;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2;;
  esac
done

if [ -z "$SOURCE" ] || [ -z "$TARGET_PATH" ]; then
  echo "Both --source and --target-path are required." >&2
  usage; exit 2
fi
if [ ! -f "$SOURCE" ]; then
  echo "Source AGENTS.md not found: $SOURCE" >&2; exit 2
fi
if [ ! -d "$TARGET_PATH" ]; then
  echo "Target path is not a directory: $TARGET_PATH" >&2; exit 2
fi

if ! SRC_DIR=$(cd "$(dirname "$SOURCE")" && pwd -P); then
  echo "Source directory cannot be accessed: $(dirname "$SOURCE")" >&2
  exit 2
fi
SRC_ABS="$SRC_DIR/$(basename "$SOURCE")"
if ! TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P); then
  echo "Target path cannot be accessed: $TARGET_PATH" >&2
  exit 2
fi
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
WORKFLOW_DIR=$(dirname "$SCRIPT_DIR")
MIGRATION_DATE=$(date +%Y-%m-%d)
PATH_PROBE="$SCRIPT_DIR/path-probe.sh"

is_under_workflow() {
  local dir="$1"
  while :; do
    [ "$dir" -ef "$WORKFLOW_DIR" ] && return 0
    [ "$dir" = "/" ] && return 1
    dir=$(dirname "$dir")
  done
}

if ! is_under_workflow "$(dirname "$SRC_ABS")"; then
  echo "Warning: source $SRC_ABS is outside the workflow clone $WORKFLOW_DIR; the clone root still drives the config and exclusion." >&2
fi

echo "Source: $SRC_ABS"
echo "Workflow directory: $WORKFLOW_DIR"
echo "Searching under: $TARGET_ABS"
[ "$DRY_RUN" -eq 1 ] && echo "Mode: dry run; no file is written or moved."

probe_path() {
  local path="$1"
  if [ ! -f "$PATH_PROBE" ]; then
    echo "PENDING: bounded path probe unavailable for $path" >&2
    return 2
  fi
  PATH_PROBE_TIMEOUT="${PATH_PROBE_TIMEOUT:-3}" bash "$PATH_PROBE" "$path" >/dev/null 2>&1
}

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  DRY-RUN: would run: $*"
    return 0
  fi
  "$@"
}

backup_store() {
  local src="$1" dest="$2" label="$3"
  if [ ! -e "$src" ]; then
    return 0
  fi
  if [ -L "$src" ]; then
    echo "  ERROR: refusing symlinked $label store root: $src" >&2
    return 1
  fi
  echo "  Backup $label: $src -> $dest"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  DRY-RUN: would copy the $label store to $dest"
    return 0
  fi
  mkdir -p "$dest" || return 1
  cp -a "$src/." "$dest/" || { echo "  ERROR: backup failed for $label; store unchanged" >&2; return 1; }
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    if [ ! -f "$dest/$rel" ] || ! cmp -s "$file" "$dest/$rel"; then
      echo "  ERROR: backup verification failed for $label; store unchanged" >&2
      return 1
    fi
  done < <(find "$src" -type f -print0)
  return 0
}

unique_dest() {
  local dest_dir="$1" name="$2"
  local candidate="$dest_dir/$name"
  local n=2
  if [ ! -e "$candidate" ]; then
    printf '%s\n' "$candidate"
    return 0
  fi
  candidate="$dest_dir/$name.migrated-$MIGRATION_DATE"
  while [ -e "$candidate" ]; do
    candidate="$dest_dir/$name.migrated-$MIGRATION_DATE-$n"
    n=$((n + 1))
  done
  printf '%s\n' "$candidate"
}

move_tree_merge() {
  local src="$1" dest="$2" label="$3"
  if [ ! -e "$src" ]; then
    return 0
  fi
  if [ -L "$src" ]; then
    echo "  ERROR: refusing symlinked $label store root: $src" >&2
    return 1
  fi
  echo "  Migrate $label: $src -> $dest"
  if [ "$DRY_RUN" -eq 1 ]; then
    while IFS= read -r -d '' file; do
      local rel="${file#"$src"/}"
      echo "  DRY-RUN: would move $file -> $dest/$rel"
    done < <(find "$src" -type f -print0)
    return 0
  fi
  mkdir -p "$dest" || return 1
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    local target
    target=$(unique_dest "$dest" "$rel") || return 1
    mkdir -p "$(dirname "$target")" || return 1
    mv "$file" "$target" || return 1
    echo "  Moved $file -> $target"
  done < <(find "$src" -type f -print0)
  find "$src" -depth -type d -empty -delete 2>/dev/null || true
  if [ -d "$src" ]; then
    echo "  WARNING: $label old directory is not empty; left in place: $src"
  fi
  return 0
}

move_file_unique() {
  local src="$1" dest_dir="$2" name="$3" label="$4"
  if [ ! -e "$src" ]; then
    return 0
  fi
  local target
  target=$(unique_dest "$dest_dir" "$name") || return 1
  echo "  Migrate $label: $src -> $target"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  DRY-RUN: would move $src -> $target"
    return 0
  fi
  mkdir -p "$dest_dir" || return 1
  mv "$src" "$target" || return 1
  return 0
}

make_config_section() {
  cat <<EOF

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Workflow AI Directory**: $WORKFLOW_DIR

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.
EOF
}

make_merge_policy_section() {
  cat <<EOF

## Merge Policy

**Merge Mode**: auto

<!-- Use pr for team repositories that require a pull request; direct for solo work. -->
EOF
}

replace_file() {
  local tmp="$1" dest="$2"
  if [ -L "$dest" ]; then
    echo "  ERROR: refusing to write through a symlink: $dest" >&2
    rm -f "$tmp"
    return 1
  fi
  mv "$tmp" "$dest" || return 1
}

ensure_merge_policy_section() {
  local file="$1" tmp
  if grep -q '^## Merge Policy' "$file"; then
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  ai-customization.md: would add Merge Policy"
    return 0
  fi
  tmp=$(mktemp) || return 1
  if ! cat "$file" > "$tmp"; then rm -f "$tmp"; return 1; fi
  if ! make_merge_policy_section >> "$tmp"; then rm -f "$tmp"; return 1; fi
  if ! replace_file "$tmp" "$file"; then rm -f "$tmp"; return 1; fi
  echo "  ai-customization.md: added Merge Policy"
  return 0
}

prepend_config_section() {
  local file="$1" tmp
  tmp=$(mktemp) || return 1
  if ! head -1 "$file" > "$tmp"; then rm -f "$tmp"; return 1; fi
  if ! make_config_section >> "$tmp"; then rm -f "$tmp"; return 1; fi
  if ! tail -n +2 "$file" >> "$tmp"; then rm -f "$tmp"; return 1; fi
  if ! replace_file "$tmp" "$file"; then rm -f "$tmp"; return 1; fi
  return 0
}

rewrite_key() {
  local file="$1" old_key="$2" new_key="$3"
  local old_line new_line old_value
  old_line=$(grep -E "^\*\*${old_key}\*\*:" "$file" | head -1 || true)
  new_line=$(grep -E "^\*\*${new_key}\*\*:" "$file" | head -1 || true)
  if [ -z "$old_line" ]; then
    return 0
  fi
  if [ -n "$new_line" ]; then
    echo "  ai-customization.md: $new_key wins; removing duplicate $old_key" >&2
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  DRY-RUN: would remove the $old_key line"
      return 0
    fi
    local tmp
    tmp=$(mktemp) || return 1
    grep -vE "^\*\*${old_key}\*\*:" "$file" > "$tmp" || true
    replace_file "$tmp" "$file" || { rm -f "$tmp"; return 1; }
    return 0
  fi
  old_value=$(printf '%s\n' "$old_line" | sed -E "s/^\*\*${old_key}\*\*:[[:space:]]*//")
  echo "  ai-customization.md: $old_key -> $new_key"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  DRY-RUN: would rewrite the key and preserve the value"
    return 0
  fi
  local tmp escaped
  escaped=$(printf '%s' "$old_value" | sed 's/[&\]/\\&/g') || return 1
  tmp=$(mktemp) || return 1
  awk -v old="$old_key" -v new="$new_key" -v val="$escaped" '
    $0 ~ "^\\*\\*" old "\\*\\*:" { print "**" new "**: " val; next }
    { print }
  ' "$file" > "$tmp" || { rm -f "$tmp"; return 1; }
  replace_file "$tmp" "$file" || { rm -f "$tmp"; return 1; }
  return 0
}

read_key() {
  local file="$1" key="$2" value
  value=$(grep -E "^\*\*${key}\*\*:" "$file" | head -1 | sed -E "s/^\*\*${key}\*\*:[[:space:]]*//" || true)
  value="${value//\[HOME\]/$HOME}"
  if [ "${value:0:1}" = "~" ]; then value="$HOME${value:1}"; fi
  printf '%s\n' "$value"
}

rewrite_customization_keys() {
  local file="$1"
  # LEGACY-GLOBAL-START
  rewrite_key "$file" 'Global AI Workflow Directory' 'Workflow AI Directory' || return 1
  rewrite_key "$file" 'Global User AI Directory' 'User AI Directory' || return 1
  rewrite_key "$file" 'Team AI Knowledge Directory' 'Team AI Directory' || return 1
  # LEGACY-GLOBAL-END
  if grep -qx -- '- global-settings' "$file"; then
    echo "  ai-customization.md: Active Expertise global-settings -> user-settings"
    if [ "$DRY_RUN" -eq 0 ]; then
      local tmp
      tmp=$(mktemp) || return 1
      sed 's/^- global-settings$/- user-settings/' "$file" > "$tmp" || { rm -f "$tmp"; return 1; }
      replace_file "$tmp" "$file" || { rm -f "$tmp"; return 1; }
    fi
  fi
  return 0
}

ensure_customization_file() {
  local project_root="$1"
  local customization_file="$project_root/ai-customization.md"
  local old_file="$project_root/ai/ai-customization.md"

  if [ -L "$customization_file" ]; then
    echo "  ERROR: $customization_file is a symlink; refusing to migrate. Replace it with a regular file." >&2
    return 1
  fi
  if [ -L "$old_file" ]; then
    echo "  ERROR: $old_file is a symlink; refusing to migrate. Replace it with a regular file." >&2
    return 1
  fi

  if [ -f "$old_file" ] && [ ! -f "$customization_file" ]; then
    echo "  Moving $old_file to $customization_file"
    if [ "$DRY_RUN" -eq 0 ]; then
      mv "$old_file" "$customization_file" || return 1
      prepend_config_section "$customization_file" || return 1
    fi
  elif [ -f "$old_file" ] && [ -f "$customization_file" ]; then
    echo "  WARNING: both $old_file and $customization_file exist; keeping the root file and leaving the old file untouched"
  elif [ ! -f "$customization_file" ]; then
    echo "  ERROR: uninitialized project: no ai-customization.md and no ai/ai-customization.md" >&2
    return 1
  fi

  if [ "$DRY_RUN" -eq 1 ] && [ ! -f "$customization_file" ]; then
    echo "  DRY-RUN: would add the config section, rewrite keys, and add Merge Policy"
    return 0
  fi

  if ! grep -q '^## AI Workflow Configuration' "$customization_file"; then
    echo "  ai-customization.md: adding config section"
    if [ "$DRY_RUN" -eq 0 ]; then
      prepend_config_section "$customization_file" || return 1
    fi
  fi

  rewrite_customization_keys "$customization_file" || return 1
  ensure_merge_policy_section "$customization_file" || return 1
  return 0
}

migrate_project_store() {
  local project_root="$1"
  local src="$project_root/ai/shared/project-knowledge"
  local dest="$project_root/ai/knowledge"
  local backup="$project_root/ai/artifacts/scope-migration-$MIGRATION_DATE/project-knowledge"

  if [ ! -e "$src" ]; then
    return 0
  fi
  backup_store "$src" "$backup" "project knowledge" || return 1
  move_tree_merge "$src" "$dest" "project knowledge" || return 1
  if [ ! -e "$src" ]; then
    echo "  Project knowledge store is now $dest"
  fi
  return 0
}

migrate_state_files() {
  local project_root="$1"
  local state_dir="$project_root/ai/state"
  local old_files=(progress.md context.md next-steps.md)
  local fname old_path new_path

  if [ ! -d "$project_root/ai" ]; then
    return 0
  fi
  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$state_dir" || return 1
  fi
  for fname in "${old_files[@]}"; do
    old_path="$project_root/ai/$fname"
    new_path="$state_dir/$fname"
    if [ -f "$old_path" ] && [ ! -f "$new_path" ]; then
      if [ "$DRY_RUN" -eq 0 ]; then
        mv "$old_path" "$new_path" || return 1
        printf '\n[MIGRATION-%s] State files relocated from ai/ to ai/state/ per AGENTS.md TIER CONFIGURATION (resolve **Project AI State Files** to ai/state/)\n' "$MIGRATION_DATE" >> "$new_path" || return 1
        echo "  Migrated $fname to ai/state/"
      else
        echo "  DRY-RUN: would migrate $fname to ai/state/"
      fi
    elif [ -f "$old_path" ] && [ -f "$new_path" ]; then
      echo "  WARNING: $fname exists in both ai/ and ai/state/ - skipped"
    fi
  done
  return 0
}

migrate_user_store() {
  local customization="$1"
  local user_dir
  user_dir=$(read_key "$customization" 'User AI Directory')
  [ -z "$user_dir" ] && user_dir="$HOME/.ai"
  echo "  User AI Directory: $user_dir"

  if ! probe_path "$user_dir"; then
    echo "  PENDING: user store unreachable; project store continues: $user_dir" >&2
    return 0
  fi

  local backup="$user_dir/backups/scope-migration-$MIGRATION_DATE/user"
  local src="$user_dir/global-knowledge"
  local dest="$user_dir/knowledge"
  if [ -e "$src" ]; then
    backup_store "$src" "$backup" "user knowledge" || return 1
    move_tree_merge "$src" "$dest" "user knowledge" || return 1
  fi
  if [ ! -d "$user_dir/skills" ]; then
    echo "  Create user skills store: $user_dir/skills"
    run_cmd mkdir -p "$user_dir/skills" || return 1
  fi
  if [ -f "$user_dir/settings/global-user-settings.md" ]; then  # LEGACY-GLOBAL
    move_file_unique "$user_dir/settings/global-user-settings.md" "$user_dir/settings" "user-settings.md" "user settings" || return 1  # LEGACY-GLOBAL
  fi
  echo "  User settings and backups stay in place."
  echo "  Exempt repair directories: $user_dir/knowledge-repair-backups/ and $user_dir/settings-repair-backups/"
  return 0
}

migrate_team_store() {
  local customization="$1"
  local team_dir
  team_dir=$(read_key "$customization" 'Team AI Directory')
  if [ -z "$team_dir" ]; then
    echo "  Team store: not configured"
    return 0
  fi
  echo "  Team AI Directory: $team_dir"
  if ! probe_path "$team_dir"; then
    echo "  PENDING: team store unreachable; project store continues: $team_dir" >&2
    return 0
  fi

  local user_dir backup
  user_dir=$(read_key "$customization" 'User AI Directory')
  [ -z "$user_dir" ] && user_dir="$HOME/.ai"
  backup="$user_dir/backups/scope-migration-$MIGRATION_DATE/team"
  local dest="$team_dir/knowledge"
  # LEGACY-GLOBAL-START
  local old_a="$team_dir/team-knowledge"
  local old_b="$team_dir/lessons"
  # LEGACY-GLOBAL-END
  if [ -e "$old_a" ]; then
    backup_store "$old_a" "$backup" "team knowledge" || return 1
    move_tree_merge "$old_a" "$dest" "team knowledge" || return 1
  fi
  if [ -e "$old_b" ]; then
    backup_store "$old_b" "$backup" "team lessons" || return 1
    move_tree_merge "$old_b" "$dest" "team lessons" || return 1
  fi
  echo "  Team store changes are left uncommitted; commit or open a PR in the team repository."
  return 0
}

validate_target() {
  local project_root="$1"
  local customization="$project_root/ai-customization.md"
  local legacy="$project_root/ai/ai-customization.md"
  if [ -L "$customization" ] || [ -L "$legacy" ]; then
    echo "  ERROR: a customization file is a symlink; refusing to migrate. Replace it with a regular file." >&2
    return 1
  fi
  # LEGACY-GLOBAL-START
  if [ ! -f "$customization" ] && [ ! -f "$legacy" ]; then
  # LEGACY-GLOBAL-END
    echo "  Uninitialized project. Run \"bootstrap using AGENTS.md protocol\"." >&2
    return 1
  fi
  return 0
}

process_target() {
  local f_abs="$1"
  local target_root
  target_root=$(dirname "$f_abs") || return 1
  echo "Target: $f_abs"

  validate_target "$target_root" || return 1

  local customization="$target_root/ai-customization.md"

  if cmp -s "$SRC_ABS" "$f_abs"; then
    echo "  AGENTS.md already up to date"
  else
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  DRY-RUN: would update $f_abs from source"
    else
      cp -f "$SRC_ABS" "$f_abs" || return 1
      echo "  AGENTS.md synced"
    fi
  fi

  ensure_customization_file "$target_root" || return 1
  migrate_state_files "$target_root" || return 1
  migrate_project_store "$target_root" || return 1
  migrate_user_store "$customization" || return 1
  migrate_team_store "$customization" || return 1
  return 0
}

list_file=$(mktemp) || { echo "Error: cannot create a temp file" >&2; exit 2; }
err_file=$(mktemp) || { echo "Error: cannot create a temp file" >&2; rm -f "$list_file"; exit 2; }
discovery_failed=0
if ! find "$TARGET_ABS" -type f -name 'AGENTS.md' -print0 > "$list_file" 2>"$err_file"; then
  echo "Warning: some directories under $TARGET_ABS could not be read; processing the matches that were found." >&2
  cat "$err_file" >&2 || true
  discovery_failed=1
fi
rm -f "$err_file" || true

matches=()
while IFS= read -r -d '' f; do
  if ! f_dir=$(cd "$(dirname "$f")" && pwd -P); then
    echo "Warning: cannot resolve directory for $f" >&2
    discovery_failed=1
    continue
  fi
  f_abs="$f_dir/$(basename "$f")"
  if [ "$f_abs" -ef "$SRC_ABS" ]; then
    echo "Skipping source file: $f_abs"
    continue
  fi
  if is_under_workflow "$f_dir"; then
    echo "Skipping workflow file: $f_abs"
    continue
  fi
  matches+=("$f_abs")
done < "$list_file"
rm -f "$list_file" || true

if [ "${#matches[@]}" -eq 0 ]; then
  if [ "$discovery_failed" -ne 0 ]; then
    echo "No readable AGENTS.md targets found under $TARGET_ABS" >&2
    exit 2
  fi
  echo "No AGENTS.md files found under $TARGET_ABS"
  exit 0
fi

echo "Found ${#matches[@]} AGENTS.md file(s)"
echo "----------------------------------------------------------------------------"

set +e
failed_targets=()
for f_abs in "${matches[@]}"; do
  if process_target "$f_abs"; then
    :
  else
    failed_targets+=("$f_abs")
    echo "  FAILED: $f_abs"
  fi
  echo "----------------------------------------------------------------------------"
done
set -e

echo "Processed ${#matches[@]} target(s); ${#failed_targets[@]} failed."
if [ "${#failed_targets[@]}" -gt 0 ]; then
  echo "Failed targets:"
  for target in "${failed_targets[@]}"; do
    echo "  $target"
  done
fi
if [ "$discovery_failed" -ne 0 ]; then
  echo "Discovery failure: some directories could not be read." >&2
  exit 2
fi
if [ "${#failed_targets[@]}" -gt 0 ]; then
  exit 1
fi
echo "Done."
