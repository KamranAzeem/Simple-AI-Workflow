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

SRC_ABS=$(cd "$(dirname "$SOURCE")" && pwd -P)/$(basename "$SOURCE")
TARGET_ABS=$(cd "$TARGET_PATH" && pwd -P)
WORKFLOW_DIR=$(dirname "$SRC_ABS")

echo "Source: $SRC_ABS"
echo "Workflow directory: $WORKFLOW_DIR"
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

# Generate the config section snippet with the correct workflow path
make_config_section() {
  cat <<EOF

## AI Workflow Configuration

<!-- Configuring this directory is mandatory. Point it to your Simple-AI-Workflow clone. -->

**Global AI Workflow Directory**: $WORKFLOW_DIR

See https://github.com/kamranazeem/Simple-AI-Workflow/blob/main/docs/ai-customization-guide.md for help.
EOF
}

# Ensure ai-customization.md at a project root has the correct config
ensure_customization_file() {
  local project_root="$1"
  local customization_file="$project_root/ai-customization.md"
  local old_file="$project_root/ai/ai-customization.md"
  local bak_file="$project_root/ai-customization.md.bak"

  # CASE A: old ai/ location exists
  if [ -f "$old_file" ]; then
    if [ -f "$customization_file" ]; then
      echo "  WARNING: both $old_file and $customization_file exist."
      echo "  Renaming $old_file to ai-customization.md.bak"
      if [ $DRY_RUN -eq 0 ]; then
        mv "$old_file" "$project_root/ai-customization.md.bak"
      fi
    else
      echo "  Moving $old_file to $customization_file and adding config section"
      if [ $DRY_RUN -eq 0 ]; then
        mv "$old_file" "$customization_file"
        # Prepend config section after the # AI Customization title
        local tmp
        tmp=$(mktemp)
        {
          head -1 "$customization_file"
          make_config_section
          tail -n +2 "$customization_file"
        } > "$tmp"
        mv "$tmp" "$customization_file"
      fi
    fi
    return
  fi

  # CASE C: root customization file exists
  if [ -f "$customization_file" ]; then
    if grep -q '^## AI Workflow Configuration' "$customization_file"; then
      # Section exists — extract current path and compare
      local current_dir
      current_dir=$(grep "^\*\*Global AI Workflow Directory\*\*:" "$customization_file" | head -1 | sed 's/^\*\*Global AI Workflow Directory\*\*: //')
      if [ "$current_dir" = "$WORKFLOW_DIR" ]; then
        echo "  ai-customization.md: config path is correct"
      else
        echo "  ai-customization.md: updating workflow directory path (was: $current_dir)"
        if [ $DRY_RUN -eq 0 ]; then
          local escaped_dir
          escaped_dir=$(printf '%s' "$WORKFLOW_DIR" | sed 's/[&\]/\\&/g')
          sed -i -E 's#^(\*\*Global AI Workflow Directory\*\*): .*#\1: '"$escaped_dir"'#' "$customization_file"
        fi
      fi
    else
      echo "  ai-customization.md: adding config section"
      if [ $DRY_RUN -eq 0 ]; then
        local tmp
        tmp=$(mktemp)
        {
          head -1 "$customization_file"
          make_config_section
          tail -n +2 "$customization_file"
        } > "$tmp"
        mv "$tmp" "$customization_file"
      fi
    fi
    return
  fi

  # CASE D: no customization file exists — create one
  echo "  ai-customization.md: creating with default configuration"
  if [ $DRY_RUN -eq 0 ]; then
    cat > "$customization_file" <<CUSTEOF
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
}

for f_abs in "${matches[@]}"; do
  target_root=$(dirname "$f_abs")
  echo "Target: $f_abs"

  # Step 1: Copy source AGENTS.md to target (no path manipulation needed)
  if [ $DRY_RUN -eq 1 ]; then
    echo "  DRY-RUN: would update $f_abs from source"
    echo "  (AGENTS.md sync)"
  else
    cp -f "$SRC_ABS" "$f_abs"
    echo "  AGENTS.md synced"
  fi

  # Step 2: Ensure ai-customization.md has correct workflow directory
  ensure_customization_file "$target_root"

  echo "----------------------------------------------------------------------------"
done

echo "Done."
