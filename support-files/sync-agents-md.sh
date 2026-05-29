#!/usr/bin/env bash
# sync-agents-md.sh
# Copy the canonical AGENTS.md into project directories, preserving each
# target's CONFIGURATION section (Workflow Dir and User AI Dir).
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

# Resolve absolute paths
SRC_ABS=$(cd "$(dirname "$SOURCE")" && pwd -P)/$(basename "$SOURCE")
TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P)

echo "Source: $SRC_ABS"
echo "Searching under: $TARGET_ABS"

# Find all AGENTS.md files under target, excluding the source itself
matches=()
while IFS= read -r -d '' f; do
  f_abs=$(cd "$(dirname "$f")" && pwd -P)/$(basename "$f")
  [ "$f_abs" = "$SRC_ABS" ] && continue
  matches+=("$f_abs")
done < <(find "$TARGET_PATH" -type f -name 'AGENTS.md' -print0 2>/dev/null)

match_count=${#matches[@]}
if [ $match_count -eq 0 ]; then
  echo "No AGENTS.md files found under $TARGET_ABS"
  exit 0
fi

echo "Found $match_count AGENTS.md file(s)"
echo "----------------------------------------------------------------------------"

for f_abs in "${matches[@]}"; do
  echo "Target: $f_abs"

  # Extract preserved config values from the target file.
  # Uses capturing group for alternation; back-references \1 and \3
  # are used in the replacement pattern below.
  target_wf_dir=$(sed -n -E 's/.*\*\*Global AI (Framework|Workflow) Directory\*\*: `([^`]*)`.*/\2/p' "$f_abs" | head -1 || true)

  target_user_dir=$(sed -n -E 's/.*\*\*Global User AI Directory\*\*: `([^`]*)`.*/\1/p' "$f_abs" | head -1 || true)

  # Fallback: older files used "Global Policies Directory" instead of Workflow Dir
  if [ -z "$target_wf_dir" ]; then
    target_wf_dir=$(sed -n -E 's/.*\*\*Global Policies Directory\*\*: `([^`]*)`.*/\1/p' "$f_abs" | head -1 || true)
    # Strip the /ai/policies/ suffix to get the workflow directory
    target_wf_dir="${target_wf_dir%/ai/policies}"
  fi

  echo "  Preserved Workflow Dir: ${target_wf_dir:-(using source)}"
  echo "  Preserved User AI Dir:   ${target_user_dir:-(using source)}"

  tmp=$(mktemp)
  cp -f "$SRC_ABS" "$tmp"

  if [ -n "$target_wf_dir" ]; then
    # Escape only & and \ for sed replacement (delimiter is # so / is safe)
    esc_val=$(printf '%s' "$target_wf_dir" | sed 's/[&\]/\\&/g')
    # Use # as delimiter to avoid conflict with | inside alternation groups.
    # Single-quote the pattern to avoid backtick interpretation by bash.
    # The $esc_val is injected by breaking out of single quotes.
    sed -i -E 's#(\*\*Global AI (Framework|Workflow) Directory\*\*: `)[^`]+(`)#\1'"${esc_val}"'\3#' "$tmp"
  fi
  if [ -n "$target_user_dir" ]; then
    esc_val=$(printf '%s' "$target_user_dir" | sed 's/[&\]/\\&/g')
    sed -i -E 's#(\*\*Global User AI Directory\*\*: `)[^`]+(`)#\1'"${esc_val}"'\2#' "$tmp"
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo "  DRY-RUN: would update $f_abs"
    rm -f "$tmp"
  else
    echo "  Updating $f_abs"
    mv -f "$tmp" "$f_abs"
  fi
  echo "----------------------------------------------------------------------------"
done

echo "Done."
