#!/bin/bash

set -e

echo "--- Starting Protocol Validation v4.6 ---"

# 1. AGENTS.md Anchors & Hardening
echo "[1/8] Verifying AGENTS.md hardening..."
if ! grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md; then
    echo "Error: Immortality Header missing in AGENTS.md"
    exit 1
fi
if ! grep -q "### PROCEDURE A: When User says \"load context\"" AGENTS.md; then
    echo "Error: Procedure A anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE D: When User says \"peer review\"" AGENTS.md; then
    echo "Error: Procedure D (Peer Review) anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "Post-Compaction Recovery" AGENTS.md; then
    echo "Error: Post-Compaction Recovery procedure anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE F: When the user says \"backup ai\"" AGENTS.md; then
    echo "Error: Procedure F (Backup) anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "Atomic Write Protocol" AGENTS.md; then
    echo "Error: Atomic Write Protocol missing from Procedure C in AGENTS.md."
    exit 1
fi
if ! grep -q "Sliding Horizon Shield" AGENTS.md; then
    echo "Error: Log Condensation / Sliding Horizon Shield missing from Procedure C in AGENTS.md."
    exit 1
fi
if ! grep -q "Token Rationing" AGENTS.md; then
    echo "Error: Token Rationing steps missing from Procedure A in AGENTS.md."
    exit 1
fi
if ! grep -q "Knowledge Loading" AGENTS.md; then
    echo "Error: Knowledge Loading step missing from Procedure A in AGENTS.md (must cover both Global and Project Knowledge)."
    exit 1
fi
if ! grep -q "Policy Loading" AGENTS.md; then
    echo "Error: Policy Loading step missing from Procedure A in AGENTS.md (referenced policies must be fully loaded at boot)."
    exit 1
fi
if ! grep -q "Global AI Knowledge Directory" AGENTS.md; then
    echo "Error: Global AI Knowledge Directory reference missing from Knowledge Loading step in AGENTS.md."
    exit 1
fi
if ! grep -q "State File Proof-of-Read" AGENTS.md; then
    echo "Error: State File Proof-of-Read guarantee missing from Procedure A Step 4 in AGENTS.md."
    exit 1
fi
if ! grep -q "Fresh-Read Before Write" AGENTS.md; then
    echo "Error: Fresh-Read Before Write guarantee missing from Procedure C Step 1 in AGENTS.md."
    exit 1
fi
if ! grep -q "Single-Writer" AGENTS.md; then
    echo "Error: State File Single-Writer Ownership rule missing from TIER 2 in AGENTS.md."
    exit 1
fi
echo "Hardening anchors verified."

# 2. Configuration Mapping
echo "[2/8] Verifying configuration entries..."
CONFIG_KEYS=(
    "Global AI Workflow Directory"
    "Global User AI Directory"
    "Global AI Policies Directory"
    "Global AI Knowledge Directory"
    "Global AI Backups Directory"
    "Global AI Settings Directory"
    "Project Artifacts Directory"
    "Project Code Review Reports Directory"
    "Project Compliance Policies Directory"
    "Project Coordination File"
    "Project Customization File"
    "Project Daily Checkpoints Directory"
    "Project Handoffs Directory"
    "Project AI Knowledge Directory"
    "Project Notes Directory"
    "Project Pending Directory"
    "Project Plans Directory"
    "Project AI Policies Directory"
    "Project Secrets Directory"
    "Project Shared Directory"
    "Project AI State Files"
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
    "artifacts" "code-review-reports" "daily-checkpoints" "notes"
    "pending" "plans" "policies" "policies/compliance" "secrets"
    "shared" "shared/handoffs" "shared/project-knowledge"
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
echo "[6/8] Verifying policy baseline (12 modular policies)..."
# NOTE: Do NOT run filesystem link-resolution checks against ai/policies/ or AGENTS.md.
# Policy files use project-root-relative paths and TIER 1 anchor references that are
# correct from the end user's project root — they will always appear broken when checked
# from inside the protocol repo. See protocol-decisions.md "No markdown hyperlinks" entry.
POLICIES=(
    "common" "meta" "cloud" "api-backend" "web-frontend" 
    "data" "linux-system-admin" "mobile-apps" "dba" "observability"
    "code-review" "codebase-examination"
    "accounting" "academic-researcher"
    "career-coaching"
)
for p in "${POLICIES[@]}"; do
    POLICY_FILE="ai/policies/ai-policy-$p.md"
    if [ ! -f "$POLICY_FILE" ]; then
        echo "Error: Policy file ai-policy-$p.md missing."
        exit 1
    fi
    if ! grep -q "READ-ONLY START" "$POLICY_FILE"; then
        echo "Error: ai-policy-$p.md missing READ-ONLY START marker."
        exit 1
    fi
    if ! grep -q "READ-ONLY END" "$POLICY_FILE"; then
        echo "Error: ai-policy-$p.md missing READ-ONLY END marker."
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

echo "--- Protocol Validation v4.6 Completed Successfully ---"
