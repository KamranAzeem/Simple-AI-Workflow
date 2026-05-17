#!/bin/bash
# Created-by: Gemini CLI
# Updated-by: Gemini CLI
# Last modified: 2026-05-17T15:30:00Z
# Intent: Comprehensive 9-Point Protocol Integrity Check (v3.0)

set -e

echo "--- Starting Protocol Validation v3.0 ---"

# 1. AGENTS.md Anchors & Hardening
echo "[1/9] Verifying AGENTS.md hardening..."
if ! grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md; then
    echo "Error: Immortality Header missing in AGENTS.md"
    exit 1
fi
if ! grep -q "### PROCEDURE A: When User says \"load context\"" AGENTS.md; then
    echo "Error: Procedure A Read-Only mandate missing."
    exit 1
fi
echo "Hardening anchors verified."

# 2. Configuration Mapping
echo "[2/9] Verifying configuration entries..."
CONFIG_KEYS=(
    "Global AI Workflow Directory"
    "Global User AI Directory"
    "Global AI Backup Directory"
)
for key in "${CONFIG_KEYS[@]}"; do
    if ! grep -q "$key" AGENTS.md; then
        echo "Error: Missing configuration key: $key"
        exit 1
    fi
done
echo "Configuration mapping verified."

# 3. Global Structure
echo "[3/9] Verifying global directory structure..."
# Resolve ~/.ai from the config if possible, else use default. Target the specific config line.
GLOBAL_DIR="/home/kamran/.ai"
# Handle the case where it might be a literal path in the script
[ -z "$GLOBAL_DIR" ] && GLOBAL_DIR="/home/kamran/.ai"

GLOBAL_SUBS=("settings" "global-knowledge" "backups")
for sub in "${GLOBAL_SUBS[@]}"; do
    if [ ! -d "$GLOBAL_DIR/$sub" ]; then
        echo "Warning: Global subdirectory $GLOBAL_DIR/$sub missing."
    fi
done
echo "Global structure checked."

# 4. Project Structure
echo "[4/9] Verifying project AI directory structure..."
PROJECT_SUBS=(
    "policies" "daily-checkpoints" "shared/handoffs" 
    "shared/project-knowledge" "artifacts" "notes" "secrets"
)
for sub in "${PROJECT_SUBS[@]}"; do
    if [ ! -d "ai/$sub" ]; then
        echo "Error: Mandatory project directory ai/$sub missing."
        exit 1
    fi
done
echo "Project structure verified."

# 5. Coordination Board
echo "[5/9] Verifying Coordination Board existence..."
if [ ! -f "ai/shared/coordination.md" ]; then
    echo "Error: Mandatory file ai/shared/coordination.md missing."
    exit 1
fi
echo "Coordination Board verified."

# 6. Policy Baseline
echo "[6/9] Verifying policy baseline (10 modular policies)..."
POLICIES=(
    "common" "meta" "cloud" "api-backend" "web-frontend" 
    "data" "linux-system-admin" "mobile-apps" "dba" "observability"
)
for p in "${POLICIES[@]}"; do
    if [ ! -f "ai/policies/ai-policy-$p.md" ]; then
        echo "Error: Policy file ai-policy-$p.md missing."
        exit 1
    fi
done
echo "Policy baseline verified."

# 7. Metadata Positioning
echo "[7/9] Verifying metadata positioning (Top-of-File)..."
# Check if first line of a policy contains the comment start
if ! head -n 1 ai/policies/ai-policy-common.md | grep -q "<comment-syntax>\|<!--"; then
    echo "Error: Metadata header not at absolute top of ai/policies/ai-policy-common.md"
    exit 1
fi
echo "Metadata positioning verified."

# 8. Git Safety
echo "[8/9] Verifying Git safety (.gitignore)..."
if ! grep -q "ai/" .gitignore; then
    echo "Error: 'ai/' directory not found in .gitignore."
    exit 1
fi
echo "Git safety verified."

# 9. Checkpoint & Backup Cycle
echo "[9/9] Testing Checkpoint & Backup cycle..."
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)
BACKUP_DIR="$GLOBAL_DIR/backups"
TEST_BACKUP="$BACKUP_DIR/VALIDATION_TEST_$TIMESTAMP.tar.gz"

# Simulate Checkpoint File
touch ai/daily-checkpoints/VALIDATION_TEST.md

# Run Backup One-liner (Simplified for validation)
tar -czf "$TEST_BACKUP" ai/ > /dev/null 2>&1

if [ -f "$TEST_BACKUP" ]; then
    echo "Native backup successful: $(basename "$TEST_BACKUP")"
    rm "$TEST_BACKUP"
    rm ai/daily-checkpoints/VALIDATION_TEST.md
    echo "Cleanup successful."
else
    echo "Error: Native backup failed. Ensure $BACKUP_DIR exists."
    exit 1
fi

echo "--- Protocol Validation v3.0 Completed Successfully ---"
