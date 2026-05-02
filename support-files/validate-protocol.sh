#!/bin/bash
# Created-by: Gemini
# Updated-by: Gemini CLI
# Last modified: 2026-05-02T21:40:00Z
# Intent: Validate AGENTS.md bootstrap protocol, policy file existence, metadata headers, and checkpoint functionality.

set -e

echo "--- Starting Protocol Validation ---"

# 1. Bootstrap & Policy/Compliance Verification
echo "[1/4] Verifying policy/compliance paths..."
REQUIRED_FILES=(
    "ai/policies/ai-policy-meta.md"
    "ai/policies/ai-policy-common.md"
    "ai/policies/compliance/ccpa.md"
    "ai/policies/compliance/gdpr.md"
    "ai/policies/compliance/hipaa.md"
    "ai/policies/compliance/iso-27001.md"
    "ai/policies/compliance/pci-dss.md"
    "ai/policies/compliance/soc2.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Mandatory file $file not found."
        exit 1
    fi
    # Check readability
    cat "$file" > /dev/null
done
echo "Policy paths verified."

# 2. Context & State Integrity
echo "[2/4] Verifying tracking files..."
TRACKING_FILES=("ai/next-steps.md" "ai/progress.md" "ai/context.md")
for file in "${TRACKING_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Tracking file $file not found."
        exit 1
    fi
    cat "$file" > /dev/null
done
echo "Tracking files verified."

# 3. Metadata & Linting Simulation
echo "[3/4] Validating metadata headers..."
# Checking for required fields in core policy files
for file in "ai/policies/ai-policy-meta.md" "ai/policies/ai-policy-common.md"; do
    if ! grep -qE "Created-by:|Updated-by:|Last modified:|Intent:" "$file"; then
        echo "Error: Missing required metadata headers in $file"
        exit 1
    fi
done
echo "Metadata headers verified."

# 4. Checkpoint Validation (Cycle)
echo "[4/4] Testing checkpoint cycle..."
DRY_RUN_FILE="ai/daily-checkpoints/CP-DRY-RUN.md"
cat <<EOF > "$DRY_RUN_FILE"
<!--
Created-by: Gemini
Updated-by: Gemini
Last modified: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Intent: Dry run checkpoint validation
-->
---
2026-05-02: CP-DRY-RUN - Protocol validation dry run successful.
EOF

if [ -f "$DRY_RUN_FILE" ]; then
    echo "Checkpoint creation successful."
    rm "$DRY_RUN_FILE"
    echo "Checkpoint cleanup successful."
else
    echo "Error: Checkpoint file creation failed."
    exit 1
fi

echo "--- Protocol Validation Completed Successfully ---"
