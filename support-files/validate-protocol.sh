#!/bin/bash
# Created-by: Gemini CLI
# Updated-by: GitHub Copilot
# Last modified: 2026-05-21T00:00:00+02:00
# Intent: Fix hardcoded Linux home path; use $HOME for portability across Linux, macOS, and Git Bash on Windows.

set -e

echo "--- Starting Protocol Validation v3.1 ---"

# 1. AGENTS.md Anchors & Hardening
echo "[1/8] Verifying AGENTS.md hardening..."
if ! grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md; then
    echo "Error: Immortality Header missing in AGENTS.md"
    exit 1
fi
if ! grep -q "### PROCEDURE A: When User says \"load context\"" AGENTS.md; then
    echo "Error: Procedure A Read-Only mandate missing."
    exit 1
fi
if ! grep -q "### PROCEDURE D: When User says \"peer review\"" AGENTS.md; then
    echo "Error: Procedure D (Peer Review) anchor missing in AGENTS.md."
    exit 1
fi
echo "Hardening anchors verified."

# 2. Configuration Mapping
echo "[2/8] Verifying configuration entries..."
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
echo "[3/8] Verifying global directory structure..."
GLOBAL_DIR="$HOME/.ai"

GLOBAL_SUBS=("settings" "global-knowledge" "backups")
for sub in "${GLOBAL_SUBS[@]}"; do
    if [ ! -d "$GLOBAL_DIR/$sub" ]; then
        echo "Warning: Global subdirectory $GLOBAL_DIR/$sub missing."
    fi
done
echo "Global structure checked."

# 4. Project Structure
echo "[4/8] Verifying project AI directory structure..."
PROJECT_SUBS=(
    "policies" "daily-checkpoints" "shared/handoffs" 
    "shared/project-knowledge" "artifacts" "notes" "secrets"
    "code-review-reports"
)
for sub in "${PROJECT_SUBS[@]}"; do
    if [ ! -d "ai/$sub" ]; then
        echo "Error: Mandatory project directory ai/$sub missing."
        exit 1
    fi
done
echo "Project structure verified."

# 5. Coordination Board
echo "[5/8] Verifying Coordination Board existence..."
if [ ! -f "ai/shared/coordination.md" ]; then
    echo "Error: Mandatory file ai/shared/coordination.md missing."
    exit 1
fi
echo "Coordination Board verified."

# 6. Policy Baseline
echo "[6/8] Verifying policy baseline (11 modular policies)..."
POLICIES=(
    "common" "meta" "cloud" "api-backend" "web-frontend" 
    "data" "linux-system-admin" "mobile-apps" "dba" "observability"
    "code-review"
)
for p in "${POLICIES[@]}"; do
    if [ ! -f "ai/policies/ai-policy-$p.md" ]; then
        echo "Error: Policy file ai-policy-$p.md missing."
        exit 1
    fi
done
echo "Policy baseline verified."

# 7. Git Safety
echo "[7/8] Verifying Git safety (.gitignore)..."
if ! grep -q "ai/" .gitignore; then
    echo "Error: 'ai/' directory not found in .gitignore."
    exit 1
fi
echo "Git safety verified."

# 8. Checkpoint & Backup Cycle
echo "[8/8] Testing Checkpoint & Backup cycle..."
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)
BACKUP_DIR="$GLOBAL_DIR/backups"
TEST_BACKUP="$BACKUP_DIR/VALIDATION_TEST_$TIMESTAMP.tar.gz"

# Simulate Checkpoint File
trap 'rm -f ai/daily-checkpoints/VALIDATION_TEST.md' EXIT
touch ai/daily-checkpoints/VALIDATION_TEST.md

# Run Backup One-liner (Simplified for validation)
tar -czf "$TEST_BACKUP" ai/ > /dev/null 2>&1

if [ -f "$TEST_BACKUP" ]; then
    echo "Native backup successful: $(basename "$TEST_BACKUP")"
    rm "$TEST_BACKUP"
else
    echo "Error: Native backup failed. Ensure $BACKUP_DIR exists."
    exit 1
fi

echo "--- Protocol Validation v3.1 Completed Successfully ---"
