#!/usr/bin/env bash
# sync-agents-md.sh
# Copy the repository's AGENTS.md into project directories where an older
# AGENTS.md exists. Works on Linux and macOS with Bash.
# Updated for "Layer Cake" protocol (v3.0)

set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 --source PATH --target-path PATH [--dry-run]

Notes:
  --source      : path to the canonical AGENTS.md (required).
  --target-path : directory to search for AGENTS.md files to update (required).

Order requirement: --source must appear before --target-path on the command line.

Examples:
  $0 --source ../AGENTS.md --target-path /projects --dry-run
EOF
}

SOURCE=""
TARGET_PATH=""
DRY_RUN=0

if [ "$#" -eq 0 ]; then
  usage
  exit 0
fi

orig_args=("$@")
pos_source=-1
pos_target=-1
for i in "${!orig_args[@]}"; do
  if [ "${orig_args[$i]}" = "--source" ]; then
    pos_source=$i
  elif [ "${orig_args[$i]}" = "--target-path" ]; then
    pos_target=$i
  fi
done
if [ $pos_source -lt 0 ] || [ $pos_target -lt 0 ]; then
  echo "Both --source and --target-path must be specified (order: --source then --target-path)." >&2
  usage
  exit 2
fi
if [ $pos_source -gt $pos_target ]; then
  echo "Invalid argument order: --source must appear before --target-path." >&2
  usage
  exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
        echo "Missing value for --source" >&2
        usage
        exit 2
      fi
      SOURCE="$2"; shift 2;;
    --target-path)
      if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
        echo "Missing value for --target-path" >&2
        usage
        exit 2
      fi
      TARGET_PATH="$2"; shift 2;;
    --dry-run) DRY_RUN=1; shift 1;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

if [ ! -f "$SOURCE" ]; then
  echo "Source AGENTS.md not found: $SOURCE" >&2
  exit 2
fi

if command -v realpath >/dev/null 2>&1; then
  SRC_ABS=$(realpath "$SOURCE")
elif command -v readlink >/dev/null 2>&1 && readlink -f "$SOURCE" >/dev/null 2>&1; then
  SRC_ABS=$(readlink -f "$SOURCE")
else
  SRC_DIR=$(cd "$(dirname "$SOURCE")" && pwd -P)
  SRC_ABS="$SRC_DIR/$(basename "$SOURCE")"
fi

if command -v realpath >/dev/null 2>&1; then
  TARGET_ABS=$(realpath "$TARGET_PATH")
elif command -v readlink >/dev/null 2>&1 && readlink -f "$TARGET_PATH" >/dev/null 2>&1; then
  TARGET_ABS=$(readlink -f "$TARGET_PATH")
else
  TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P)
fi

echo "Source: $SRC_ABS"
echo "Searching under: $TARGET_ABS"

IFS=$'\n'
matches=()
while IFS= read -r -d '' f; do
  if command -v realpath >/dev/null 2>&1; then
    f_abs=$(realpath "$f")
  elif command -v readlink >/dev/null 2>&1 && readlink -f "$f" >/dev/null 2>&1; then
    f_abs=$(readlink -f "$f")
  else
    f_abs="$f"
  fi
  
  case "$f_abs" in
    "$TARGET_ABS"/*) ;;
    *) continue ;;
  esac
  if [ "$f_abs" = "$SRC_ABS" ]; then
    continue
  fi
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
  
  # Extract Base Directories
  target_wf_dir=$(grep -m1 -E '\*\*Global AI (Framework|Workflow) Directory\*\*: `[^`]+`' "$f_abs" | sed -n -E 's/.*\*\*Global AI (Framework\|Workflow) Directory\*\*: `([^`]*)`.*/\2/p' || true)
  target_user_dir=$(grep -m1 -E '\*\*Global User AI Directory\*\*: `[^`]+`' "$f_abs" | sed -n 's/.*\*\*Global User AI Directory\*\*: `\([^`]*\)`.*/\1/p' || true)

  # Fallback to older nomenclature if not found
  if [ -z "$target_wf_dir" ]; then
    target_wf_dir=$(grep -m1 -E '\*\*Global Policies Directory\*\*: `[^`]+`' "$f_abs" | sed -n 's/.*\*\*Global Policies Directory\*\*: `\([^`]*\)\/ai\/policies\/.*/\1/p' || true)
  fi
  if [ -z "$target_user_dir" ]; then
    target_user_dir=$(grep -m1 -E '\*\*Global User AI Directory\*\*: `[^`]+`' "$f_abs" | sed -n 's/.*\*\*Global User AI Directory\*\*: `\([^`]*\)`.*/\1/p' || true)
  fi

  echo "  Preserved Workflow Dir: ${target_wf_dir:-"(using source)"}"
  echo "  Preserved User AI Dir:   ${target_user_dir:-"(using source)"}"

  tmp=$(mktemp)
  sed_args=()
  if [ -n "$target_wf_dir" ]; then
    esc_val=$(printf '%s' "$target_wf_dir" | sed 's/[\/&]/\\&/g')
    sed_args+=("-e" 's|(\*\*Global AI Workflow Directory\*\*: `)([^`]+)(`.*)|\1'"$esc_val"'\3|')
  fi
  if [ -n "$target_user_dir" ]; then
    esc_val=$(printf '%s' "$target_user_dir" | sed 's/[\/&]/\\&/g')
    sed_args+=("-e" 's|(\*\*Global User AI Directory\*\*: `)([^`]+)(`.*)|\1'"$esc_val"'\3|')
  fi

  if [ ${#sed_args[@]} -gt 0 ]; then
    sed -E "${sed_args[@]}" "$SRC_ABS" > "$tmp"
  else
    cp -f "$SRC_ABS" "$tmp"
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
