#!/usr/bin/env bash
# sync-agents-md.sh
# Copy the canonical AGENTS.md into project directories, then ensure each
# target has a properly configured ai-customization.md at its project root.
# Automatically migrates from the old ai/ai-customization.md location.
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 --source PATH --target-path PATH [--dry-run]

  --source      : path to the canonical AGENTS.md (required).
  --target-path : directory to search for AGENTS.md files to update (required).
  --dry-run     : show what would be done without making changes.

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

# Generate the config section snippet with the correct workflow path
make_config_section() {
  cat <<EOF

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: $WORKFLOW_DIR

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.
EOF
}

# Write temp file $1 to $2, keeping $2 a symlink. A plain mv would replace the
# symlink with a regular file.
replace_file() {
  local tmp="$1" dest="$2"
  if [ -L "$dest" ]; then
    cat "$tmp" > "$dest" || return 1
    rm -f "$tmp" || return 1
  else
    mv "$tmp" "$dest" || return 1
  fi
  return 0
}

prepend_config_section() {
  local file="$1" tmp
  tmp=$(mktemp) || return 1
  if ! head -1 "$file" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  if ! make_config_section >> "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  if ! tail -n +2 "$file" >> "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  if ! replace_file "$tmp" "$file"; then
    rm -f "$tmp"
    return 1
  fi
  return 0
}

# Ensure ai-customization.md at a project root has the correct config
ensure_customization_file() {
  local project_root="$1"
  local customization_file="$project_root/ai-customization.md"
  local old_file="$project_root/ai/ai-customization.md"
  local bak_file="$project_root/ai-customization.md.bak"

  # Root is a symlink to the real file inside ai/ (intentional versioned layout).
  # Keep the link and edit the target instead of treating it as a duplicate.
  if [ -L "$customization_file" ] && [ -f "$old_file" ] && [ "$customization_file" -ef "$old_file" ]; then
    echo "  ai-customization.md: symlink to ai/ai-customization.md; keeping the link"
    customization_file="$old_file"
    old_file=""
  fi

  # CASE A: old ai/ location exists
  if [ -f "$old_file" ]; then
    if [ -f "$customization_file" ]; then
      echo "  WARNING: both $old_file and $customization_file exist."
      echo "  Renaming $old_file to ai-customization.md.bak"
      if [ "$DRY_RUN" -eq 0 ]; then
        mv "$old_file" "$bak_file" || return 1
      fi
    else
      echo "  Moving $old_file to $customization_file and adding config section"
      if [ "$DRY_RUN" -eq 0 ]; then
        mv "$old_file" "$customization_file" || return 1
        prepend_config_section "$customization_file" || return 1
      fi
    fi
    return 0
  fi

  # CASE C: root customization file exists
  if [ -f "$customization_file" ]; then
    if grep -q '^## AI Workflow Configuration' "$customization_file"; then
      local current_dir
      current_dir=$(grep '^\*\*Global AI Workflow Directory\*\*:' "$customization_file" | head -1 | sed 's/^\*\*Global AI Workflow Directory\*\*: //') || return 1
      if [ "$current_dir" = "$WORKFLOW_DIR" ]; then
        echo "  ai-customization.md: config path is correct"
      else
        echo "  ai-customization.md: updating workflow directory path (was: $current_dir)"
        if [ "$DRY_RUN" -eq 0 ]; then
          local escaped_dir tmp
          escaped_dir=$(printf '%s' "$WORKFLOW_DIR" | sed 's/[&\]/\\&/g') || return 1
          tmp=$(mktemp) || return 1
          if ! sed 's#^\*\*Global AI Workflow Directory\*\*:.*#**Global AI Workflow Directory**: '"$escaped_dir"'#' "$customization_file" > "$tmp"; then
            rm -f "$tmp"
            return 1
          fi
          if ! replace_file "$tmp" "$customization_file"; then
            rm -f "$tmp"
            return 1
          fi
          if ! grep -qF "**Global AI Workflow Directory**: $WORKFLOW_DIR" "$customization_file"; then
            echo "  ERROR: failed to update the workflow directory path in $customization_file"
            return 1
          fi
        fi
      fi
    else
      echo "  ai-customization.md: adding config section"
      if [ "$DRY_RUN" -eq 0 ]; then
        prepend_config_section "$customization_file" || return 1
      fi
    fi
    return 0
  fi

  # CASE D: no customization file exists — create one
  echo "  ai-customization.md: creating with default configuration"
  if [ "$DRY_RUN" -eq 0 ]; then
    cat > "$customization_file" <<CUSTEOF || return 1
# AI Customization

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: $WORKFLOW_DIR

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.

## Active Expertise
- web-frontend

## Active Traits
- System Integrator: Coordinate dependencies and ensure contract consistency across all system layers (infra, API, web, mobile); flag breaking changes in shared schemas or DTOs.

## Required Compliance
- gdpr
- iso-27001
CUSTEOF
  fi
  return 0
}

ensure_state_files_migration() {
  local project_root="$1"
  local state_dir="$project_root/ai/state"
  local old_files=(progress.md context.md next-steps.md)
  local fname old_path new_path migration_date

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
        migration_date=$(date +%Y-%m-%d) || return 1
        printf '\n[MIGRATION-%s] State files relocated from ai/ to ai/state/ per AGENTS.md TIER CONFIGURATION (resolve **Project AI State Files** to ai/state/)\n' "$migration_date" >> "$new_path" || return 1
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

process_target() {
  local f_abs="$1"
  local target_root cmp_rc
  target_root=$(dirname "$f_abs") || return 1
  echo "Target: $f_abs"

  if cmp -s "$SRC_ABS" "$f_abs"; then
    echo "  AGENTS.md already up to date"
  else
    cmp_rc=$?
    if [ "$cmp_rc" -gt 1 ]; then
      echo "  ERROR: cannot compare $f_abs"
      return 1
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  DRY-RUN: would update $f_abs from source"
      echo "  (AGENTS.md sync)"
    else
      cp -f "$SRC_ABS" "$f_abs" || return 1
      echo "  AGENTS.md synced"
    fi
  fi

  ensure_state_files_migration "$target_root" || return 1
  ensure_customization_file "$target_root" || return 1
  return 0
}

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
