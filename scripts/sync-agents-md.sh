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
# initialize matches as an empty array to avoid 'unbound variable' under set -u
matches=()
while IFS= read -r -d '' f; do
  f_abs="$f"
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
  # Compare contents first; if different -> copy, otherwise report already identical
  # Check if target contains the central policy line and extract the policy path
  policy_line=$(grep -m1 -E '\[central main policy file\]\([^)]*\)' "$f_abs" || true)
  if [ -n "$policy_line" ]; then
    policy_path=$(printf '%s' "$policy_line" | sed -n 's/.*\[central main policy file\](\([^)]*\)).*/\1/p')
  else
    policy_path="(none)"
  fi

  # Print structured per-target info for readability
  echo
  echo "Target AGENTS.md file: $f_abs"
  echo
  echo "Policy file in use: $policy_path"

  # Always overwrite the target with the source content, but if the target defines a
  # central policy path, inject that path into the copied content. This avoids blind
  # overwrites of repository-specific policy pointers.
  src_policy_line=$(grep -m1 -E '\[central main policy file\]\([^)]*\)' "$SRC_ABS" || true)

  tmp=$(mktemp)
  if [ "$policy_path" != "(none)" ]; then
    if [ -n "$src_policy_line" ]; then
      esc_policy_path=$(printf '%s' "$policy_path" | sed 's/[\/&]/\\&/g')
      sed -E "s|(\[central main policy file\]\()([^)]*)(\))|\1$esc_policy_path\3|" "$SRC_ABS" > "$tmp"
    else
      printf '%s
'"[central main policy file]($policy_path) - operating rules and guardrails. If unreachable, then read the local policy file mentioned in the next point.
" > "$tmp"
      cat "$SRC_ABS" >> "$tmp"
    fi
    if [ $DRY_RUN -eq 1 ]; then
      echo ""
      echo "DRY-RUN: would update $f_abs (while retaining target policy path)"
      rm -f "$tmp"
    else
      echo
      echo "Updating $f_abs (while retaining target policy path)"
      mv -f "$tmp" "$f_abs"
    fi
  else
    if [ $DRY_RUN -eq 1 ]; then
      echo ""
      echo "DRY-RUN: would replace $f_abs (no central policy line found)"
    else
      echo
      echo "Replacing $f_abs (no central policy line found)"
      cp -f "$SRC_ABS" "$f_abs"
    fi
  fi
  echo
  echo "----------------------------------------------------------------------------"
done

echo
echo "Done. Processed $match_count AGENTS.md file(s) under $TARGET_ABS"
echo
