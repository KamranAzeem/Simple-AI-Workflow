#!/usr/bin/env bash
# sync-agents-md.sh
# Copy the repository's AGENTS.md into project directories where an older
# AGENTS.md exists. Works on Linux and macOS with Bash.

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

# If no args provided, show usage to avoid silent failures when run from wrong cwd
if [ "$#" -eq 0 ]; then
  usage
  exit 0
fi

# Require both --source and --target-path and enforce order: --source must come before --target-path
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
    --force) echo "Unknown argument: --force (removed); use default behavior: overwrite when contents differ" >&2; usage; exit 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

if [ ! -f "$SOURCE" ]; then
  echo "Source AGENTS.md not found: $SOURCE" >&2
  echo
  usage
  exit 2
fi

if command -v realpath >/dev/null 2>&1; then
  SRC_ABS=$(realpath "$SOURCE")
elif command -v readlink >/dev/null 2>&1 && readlink -f "$SOURCE" >/dev/null 2>&1; then
  SRC_ABS=$(readlink -f "$SOURCE")
else
  # POSIX-compatible fallback: resolve using dirname + pwd -P
  SRC_DIR=$(cd "$(dirname "$SOURCE")" && pwd -P)
  SRC_ABS="$SRC_DIR/$(basename "$SOURCE")"
fi

# show what we're doing
echo
echo "Source: $SRC_ABS"
echo
# Canonicalize TARGET_PATH to avoid escaping via symlinks or odd paths
if command -v realpath >/dev/null 2>&1; then
  TARGET_ABS=$(realpath "$TARGET_PATH")
elif command -v readlink >/dev/null 2>&1 && readlink -f "$TARGET_PATH" >/dev/null 2>&1; then
  TARGET_ABS=$(readlink -f "$TARGET_PATH")
else
  TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P)
fi

echo "Searching under: $TARGET_ABS"

# Ensure target path exists and is a directory
if [ ! -d "$TARGET_ABS" ]; then
  echo "Target path not found or not a directory: $TARGET_ABS" >&2
  exit 2
fi

# Find all AGENTS.md files under TARGET_PATH and collect matches strictly under TARGET_ABS
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
  
  # ensure the found file is inside the canonical target path
  case "$f_abs" in
    "$TARGET_ABS"/*) ;;
    *)
      # skip anything outside the canonical target path
      continue
      ;;
  esac
  # skip the source itself
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

# Print summary early so user sees what will be affected
echo
echo "Found $match_count AGENTS.md file(s) under $TARGET_ABS"
echo
echo "----------------------------------------------------------------------------"
echo

# Process matches
for f_abs in "${matches[@]}"; do
  # Extract values from target AGENTS.md to preserve them
  # 1. Central Policy Directory
  target_cp_dir=$(grep -m1 -E '\*\*Central Policy Directory\*\*: `[^`]+`' "$f_abs" | sed -n 's/.*\*\*Central Policy Directory\*\*: `\([^`]*\)`.*/\1/p' || true)
  # 2. Central Main Policy File
  target_main_policy=$(grep -m1 -E '\[central main policy file\]\([^)]+\)' "$f_abs" | sed -n 's/.*\[central main policy file\](\([^)]*\)).*/\1/p' || true)
  # 3. Central Common Policy File
  target_common_policy=$(grep -m1 -E '\[central common policy file\]\([^)]+\)' "$f_abs" | sed -n 's/.*\[central common policy file\](\([^)]*\)).*/\1/p' || true)

  # Print structured per-target info for readability
  echo
  echo "Target AGENTS.md file: $f_abs"
  echo
  echo "Values preserved from target (if found):"
  echo "  Central Policy Directory: ${target_cp_dir:-"(not found, will use source value)"}"
  echo "  Central Main Policy:      ${target_main_policy:-"(not found, will use source value)"}"
  echo "  Central Common Policy:    ${target_common_policy:-"(not found, will use source value)"}"

  tmp=$(mktemp)
  
  # Construct sed command dynamically based on found values
  sed_args=()
  if [ -n "$target_cp_dir" ]; then
    esc_val=$(printf '%s' "$target_cp_dir" | sed 's/[\/&]/\\&/g')
    sed_args+=("-e" 's|(\*\*Central Policy Directory\*\*: `)([^`]+)(`.*)|\1'"$esc_val"'\3|')
  fi
  if [ -n "$target_main_policy" ]; then
    esc_val=$(printf '%s' "$target_main_policy" | sed 's/[\/&]/\\&/g')
    sed_args+=("-e" 's|(\[central main policy file\]\()([^)]*)(\))|\1'"$esc_val"'\3|')
  fi
  if [ -n "$target_common_policy" ]; then
    esc_val=$(printf '%s' "$target_common_policy" | sed 's/[\/&]/\\&/g')
    sed_args+=("-e" 's|(\[central common policy file\]\()([^)]*)(\))|\1'"$esc_val"'\3|')
  fi

  if [ ${#sed_args[@]} -gt 0 ]; then
    sed -E "${sed_args[@]}" "$SRC_ABS" > "$tmp"
  else
    cp -f "$SRC_ABS" "$tmp"
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo
    echo "DRY-RUN: would update $f_abs (while retaining target-specific policy settings)"
    rm -f "$tmp"
  else
    echo
    echo "Updating $f_abs (while retaining target-specific policy settings)"
    mv -f "$tmp" "$f_abs"
  fi
  echo
  echo "----------------------------------------------------------------------------"
done

echo
echo "Done. Processed $match_count AGENTS.md file(s) under $TARGET_ABS"
echo
