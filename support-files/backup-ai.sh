#!/usr/bin/env bash
# Out-of-band backup: find workflow projects under a search path and archive each
# project's ai/ directory and ai-customization.md. No AI assistant is required.
set -u

usage() {
  cat <<'EOF'
Usage: backup-ai.sh --target-path PATH [--backup-dir PATH] [--exclude-secrets] [--dry-run]

  --target-path PATH : directory to search for workflow projects (required).
  --backup-dir PATH  : archive destination (default: $HOME/.ai/backups).
  --exclude-secrets  : leave ai/secrets/ out of the archive.
  --dry-run          : list the projects and archive names; write nothing.
  -h, --help         : show this help.

A project is marked by ai-customization.md, or by an ai/ directory that
contains both state/ and shared/. The workflow clone itself is skipped.

Examples:
  backup-ai.sh --target-path ~/Projects --dry-run
  backup-ai.sh --target-path ~/Projects --backup-dir ~/backups
EOF
}

die() {
  printf 'Error: %s\n' "$1" >&2
  exit 2
}

TARGET_PATH=""
BACKUP_DIR=""
EXCLUDE_SECRETS=0
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --target-path)
      [ $# -ge 2 ] && [ "${2#--}" = "$2" ] || die "Missing value for --target-path"
      TARGET_PATH="$2"
      shift 2
      ;;
    --backup-dir)
      [ $# -ge 2 ] && [ "${2#--}" = "$2" ] || die "Missing value for --backup-dir"
      BACKUP_DIR="$2"
      shift 2
      ;;
    --exclude-secrets)
      EXCLUDE_SECRETS=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[ -n "$TARGET_PATH" ] || die "--target-path is required."
[ -d "$TARGET_PATH" ] || die "Target path is not a directory: $TARGET_PATH"
TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P) || die "Target path cannot be accessed: $TARGET_PATH"

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P) || die "Cannot resolve the script directory."
WORKFLOW_DIR=$(dirname "$SCRIPT_DIR")

if [ -z "$BACKUP_DIR" ]; then
  [ -n "${HOME:-}" ] || die "HOME is not set; use --backup-dir."
  BACKUP_DIR="$HOME/.ai/backups"
fi

STAMP=$(date +%Y-%m-%d_%H-%M) || die "Cannot read the current date."

is_under_workflow() {
  local dir="$1"
  while :; do
    [ "$dir" -ef "$WORKFLOW_DIR" ] && return 0
    [ "$dir" = "/" ] && return 1
    dir=$(dirname "$dir")
  done
}

is_project() {
  local dir="$1"
  if [ -e "$dir/ai-customization.md" ] || [ -L "$dir/ai-customization.md" ]; then
    return 0
  fi
  if [ -d "$dir/ai/state" ] && [ -d "$dir/ai/shared" ]; then
    return 0
  fi
  return 1
}

sanitize_component() {
  local value="$1" clean
  clean=$(printf '%s' "$value" | sed 's/[^A-Za-z0-9._-]/_/g')
  [ -n "$clean" ] || clean="_"
  printf '%s' "$clean"
}

archive_name() {
  local project="$1" parent name
  parent=$(sanitize_component "$(basename "$(dirname "$project")")")
  name=$(sanitize_component "$(basename "$project")")
  printf '%s/%s_%s_%s.tar.gz\n' "$BACKUP_DIR" "$parent" "$name" "$STAMP"
}

archive_project() {
  local project="$1" out="$2"
  local stage=""
  local custom_dir=""
  local has_content=0
  local -a tar_args

  if [ -e "$project/ai-customization.md" ] || [ -L "$project/ai-customization.md" ]; then
    has_content=1
    if [ -L "$project/ai-customization.md" ]; then
      stage=$(mktemp -d) || {
        printf 'FAILED: cannot create a staging directory for %s\n' "$project" >&2
        return 1
      }
      if ! cp -L "$project/ai-customization.md" "$stage/ai-customization.md" 2>/dev/null; then
        printf 'FAILED: cannot read the customization file in %s\n' "$project" >&2
        rm -rf "$stage"
        return 1
      fi
      custom_dir="$stage"
    else
      custom_dir="$project"
    fi
  fi

  if [ -d "$project/ai" ]; then
    has_content=1
  fi

  if [ "$has_content" -eq 0 ]; then
    printf 'FAILED: nothing to archive in %s\n' "$project" >&2
    [ -n "$stage" ] && rm -rf "$stage"
    return 1
  fi

  if [ -e "$out" ] || [ -L "$out" ]; then
    printf 'FAILED: archive already exists: %s\n' "$out" >&2
    [ -n "$stage" ] && rm -rf "$stage"
    return 1
  fi

  tar_args=(-czf "$out")
  if [ "$EXCLUDE_SECRETS" -eq 1 ]; then
    tar_args+=(--exclude=ai/secrets)
  fi
  if [ -d "$project/ai" ]; then
    tar_args+=(-C "$project" ai)
  fi
  if [ -n "$custom_dir" ]; then
    tar_args+=(-C "$custom_dir" ai-customization.md)
  fi

  if ! ( umask 077; tar "${tar_args[@]}" ) 2>/dev/null; then
    printf 'FAILED: tar failed for %s\n' "$project" >&2
    [ -e "$out" ] && rm -f "$out"
    [ -n "$stage" ] && rm -rf "$stage"
    return 1
  fi
  [ -n "$stage" ] && rm -rf "$stage"

  if ! find "$out" -perm 600 -print 2>/dev/null | grep -q .; then
    printf 'FAILED: archive is not owner-only: %s\n' "$out" >&2
    rm -f "$out"
    return 1
  fi

  printf 'Backed up: %s -> %s\n' "$project" "$out"
  return 0
}

list_file=$(mktemp) || die "Cannot create a temporary file."
err_file=$(mktemp) || {
  rm -f "$list_file"
  die "Cannot create a temporary file."
}
trap 'rm -f "$list_file" "$err_file"' EXIT

discovery_failed=0
if ! find "$TARGET_ABS" -name .git -prune -o -type d -print0 > "$list_file" 2>"$err_file"; then
  discovery_failed=1
fi
if [ -s "$err_file" ]; then
  printf 'Warning: some directories under %s could not be read; processing the matches that were found.\n' "$TARGET_ABS" >&2
  cat "$err_file" >&2 || true
  discovery_failed=1
fi

projects=()
while IFS= read -r -d '' dir; do
  skip=0
  if [ "${#projects[@]}" -gt 0 ]; then
    for p in "${projects[@]}"; do
      if [ "$dir" = "$p" ]; then
        skip=1
        break
      fi
      if [ "${dir#"$p"/}" != "$dir" ]; then
        skip=1
        break
      fi
    done
  fi
  [ "$skip" -eq 1 ] && continue
  is_under_workflow "$dir" && continue
  if is_project "$dir"; then
    projects+=("$dir")
  fi
done < "$list_file"

if [ "$DRY_RUN" -eq 1 ]; then
  if [ "${#projects[@]}" -eq 0 ]; then
    printf 'No projects found under %s\n' "$TARGET_ABS"
    exit 0
  fi
  for p in "${projects[@]}"; do
    printf 'DRY-RUN: would archive %s -> %s\n' "$p" "$(archive_name "$p")"
  done
  exit 0
fi

if [ ! -d "$BACKUP_DIR" ]; then
  if ! mkdir -p "$BACKUP_DIR"; then
    printf 'Error: cannot create the backup directory: %s\n' "$BACKUP_DIR" >&2
    exit 2
  fi
  printf 'Created backup directory: %s\n' "$BACKUP_DIR"
fi

if [ "${#projects[@]}" -eq 0 ]; then
  printf 'No projects found under %s\n' "$TARGET_ABS"
fi

failed=0
if [ "${#projects[@]}" -gt 0 ]; then
  for p in "${projects[@]}"; do
    out=$(archive_name "$p")
    if ! archive_project "$p" "$out"; then
      failed=$((failed + 1))
    fi
  done
fi

if [ "$discovery_failed" -ne 0 ]; then
  exit 2
fi
if [ "$failed" -ne 0 ]; then
  exit 1
fi
exit 0
