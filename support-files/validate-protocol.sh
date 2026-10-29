#!/bin/bash

set -e

echo "--- Starting Protocol Validation v6.1 ---"

# 1. AGENTS.md Anchors & Hardening
echo "[1/8] Verifying AGENTS.md hardening..."
if ! grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md; then
    echo "Error: Immortality Header missing in AGENTS.md"
    exit 1
fi
if ! grep -q "### PROCEDURE LOAD-CONTEXT: When the user says \"load context\"" AGENTS.md; then
    echo "Error: PROCEDURE LOAD-CONTEXT anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE RUN-PEER-REVIEW: When the user says \"peer review\"" AGENTS.md; then
    echo "Error: PROCEDURE RUN-PEER-REVIEW anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE POST-COMPACTION-RECOVERY:" AGENTS.md; then
    echo "Error: PROCEDURE POST-COMPACTION-RECOVERY anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE CREATE-BACKUP: When the user says \"backup ai\"" AGENTS.md; then
    echo "Error: PROCEDURE CREATE-BACKUP anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "### PROCEDURE EXAMINE-CODEBASE: When the user says" AGENTS.md; then
    echo "Error: PROCEDURE EXAMINE-CODEBASE anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-ATOMIC-WRITE" AGENTS.md; then
    echo "Error: STEP-ATOMIC-WRITE missing from PROCEDURE WRITE-CHECKPOINT in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-STATE-FILE-TRIMMING" AGENTS.md; then
    echo "Error: STEP-STATE-FILE-TRIMMING missing from PROCEDURE WRITE-CHECKPOINT in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-DAILY-CHECKPOINT-FILE" AGENTS.md; then
    echo "Error: STEP-DAILY-CHECKPOINT-FILE missing from PROCEDURE WRITE-CHECKPOINT in AGENTS.md."
    exit 1
fi
if ! grep -q 'Index `open/` and `in-progress/`' AGENTS.md; then
    echo "Error: Project Issues indexing step (three-directory status convention) missing from PROCEDURE LOAD-CONTEXT in AGENTS.md."
    exit 1
fi
if ! grep -q '### PROCEDURE MANAGE-ISSUES:' AGENTS.md; then
    echo "Error: PROCEDURE MANAGE-ISSUES anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q '### PROCEDURE REPAIR-STATE-FILES:' AGENTS.md; then
    echo "Error: PROCEDURE REPAIR-STATE-FILES anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q '### PROCEDURE REPAIR-KNOWLEDGE-FILES:' AGENTS.md; then
    echo "Error: PROCEDURE REPAIR-KNOWLEDGE-FILES anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q 'STEP-KNOWLEDGE-HEADER-PRE-WRITE' AGENTS.md; then
    echo "Error: STEP-KNOWLEDGE-HEADER-PRE-WRITE anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q '### PROCEDURE UPDATE-DESIGN-DOCS:' AGENTS.md; then
    echo "Error: PROCEDURE UPDATE-DESIGN-DOCS anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q '### PROCEDURE MIGRATE-DESIGN-DOCS:' AGENTS.md; then
    echo "Error: PROCEDURE MIGRATE-DESIGN-DOCS anchor missing in AGENTS.md."
    exit 1
fi
if ! grep -q "Token Rationing" AGENTS.md; then
    echo "Error: Token Rationing steps missing from PROCEDURE LOAD-CONTEXT in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-KNOWLEDGE-INDEXING" AGENTS.md; then
    echo "Error: STEP-KNOWLEDGE-INDEXING missing from PROCEDURE LOAD-CONTEXT in AGENTS.md (must cover both Global and Project Knowledge)."
    exit 1
fi
if ! grep -q "STEP-POLICY-LOADING" AGENTS.md; then
    echo "Error: STEP-POLICY-LOADING missing from PROCEDURE LOAD-CONTEXT in AGENTS.md (referenced policies must be fully loaded at boot)."
    exit 1
fi
if ! grep -q "Global AI Knowledge Directory" AGENTS.md; then
    echo "Error: Global AI Knowledge Directory reference missing from STEP-KNOWLEDGE-INDEXING in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-STATE-FILE-PROOF-OF-READ" AGENTS.md; then
    echo "Error: STEP-STATE-FILE-PROOF-OF-READ guarantee missing from STEP-LOADING in PROCEDURE LOAD-CONTEXT in AGENTS.md."
    exit 1
fi
if ! grep -q "STEP-FRESH-READ-BEFORE-WRITE" AGENTS.md; then
    echo "Error: STEP-FRESH-READ-BEFORE-WRITE guarantee missing from STEP-ATOMIC-WRITE in PROCEDURE WRITE-CHECKPOINT in AGENTS.md."
    exit 1
fi
if ! grep -q "Before writing, verify each state-file header." AGENTS.md; then
    echo "Error: state-file header pre-write check missing from STEP-ATOMIC-WRITE in AGENTS.md."
    exit 1
fi
if ! grep -q "Before appending, verify today's header." AGENTS.md; then
    echo "Error: checkpoint header pre-append check missing from STEP-DAILY-CHECKPOINT-FILE in AGENTS.md."
    exit 1
fi
if ! grep -q "Preserve each header verbatim." AGENTS.md; then
    echo "Error: header preservation check missing from STEP-STATE-FILE-TRIMMING in AGENTS.md."
    exit 1
fi
if ! grep -q "Single-Writer" AGENTS.md; then
    echo "Error: State File Single-Writer Ownership rule missing from TIER READ-FIRST-RULES in AGENTS.md."
    exit 1
fi
if ! grep -q "Full File Reads" AGENTS.md; then
    echo "Error: Full File Reads mandate missing from TIER READ-FIRST-RULES in AGENTS.md."
    exit 1
fi
if grep -qE "\bPROCEDURE [A-I]\b|\bProcedure [A-I]\b|\bprocedure [A-I]\b" AGENTS.md; then
    echo "Error: letter-based procedure reference found in AGENTS.md; use PROCEDURE <NAME> instead."
    exit 1
fi
if grep -qE "\bTIER [0-9]\b|\bStep [0-9]\b" AGENTS.md; then
    echo "Error: numeric tier or step reference found in AGENTS.md; use TIER <NAME> or STEP <NAME> instead."
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
    "Project Issues Directory"
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
if [ -f "ai-customization.md" ]; then
    for sec in "## AI Workflow Configuration" "## Active Expertise"; do
        if ! grep -q "$sec" ai-customization.md; then
            echo "Warning: ai-customization.md missing section: $sec"
        fi
    done
fi
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

warn_state_header() {
    echo "[WARNING] State-file health is degraded and work quality is at risk. Run \"repair state files\" now."
}

check_state_file_header() {
    local type="$1"
    local file="$2"
    local policy="ai/policies/ai-policy-common.md"
    local start="<!-- STATE-FILE-HEADER: $type START -->"
    local end="<!-- STATE-FILE-HEADER: $type END -->"
    local policy_start_count policy_end_count

    if [ ! -f "$policy" ]; then
        echo "[FAILED] $policy: policy file missing"
        return 1
    fi
    policy_start_count=$(grep -Fxc "$start" "$policy" || true)
    policy_end_count=$(grep -Fxc "$end" "$policy" || true)
    if [ "$policy_start_count" -ne 1 ] || [ "$policy_end_count" -ne 1 ]; then
        echo "[FAILED] $policy: canonical header blocks missing or duplicated"
        return 1
    fi
    if [ ! -f "$file" ]; then
        echo "[FAILED] $file: missing state file; restore it before continuing"
        return 1
    fi

    local norm start_count end_count start_line end_line total
    norm=$(mktemp)
    awk 'NR==1{sub(/^\357\273\277/, "")} {sub(/\r$/, ""); sub(/[ \t]+$/, ""); print}' "$file" > "$norm"
    start_count=$(grep -Fxc "$start" "$norm" || true)
    end_count=$(grep -Fxc "$end" "$norm" || true)

    if [ "$start_count" -eq 0 ]; then
        if head -n 1 "$norm" | grep -Eq '^(<!-- )?(State file \(|Daily checkpoint \()'; then
            echo "[FAILED] $file header: legacy header at line 1"
        else
            echo "[FAILED] $file header: missing START marker"
        fi
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ "$start_count" -gt 1 ]; then
        echo "[FAILED] $file header: duplicate START marker"
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ "$end_count" -eq 0 ]; then
        echo "[FAILED] $file header: missing END marker"
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ "$end_count" -gt 1 ]; then
        echo "[FAILED] $file header: duplicate END marker"
        warn_state_header
        rm -f "$norm"
        return 1
    fi

    start_line=$(grep -Fxn "$start" "$norm" | cut -d: -f1)
    end_line=$(grep -Fxn "$end" "$norm" | cut -d: -f1)
    if [ "$start_line" -ne 1 ]; then
        echo "[FAILED] $file header: block not first"
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ "$end_line" -le "$start_line" ]; then
        echo "[FAILED] $file header: END before START"
        warn_state_header
        rm -f "$norm"
        return 1
    fi

    total=$(awk 'END{print NR}' "$norm")
    if [ $((end_line + 1)) -gt "$total" ] || [ -n "$(sed -n "$((end_line + 1))p" "$norm")" ]; then
        echo "[FAILED] $file header: expected exactly one blank line after END"
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ $((end_line + 2)) -le "$total" ] && [ -z "$(sed -n "$((end_line + 2))p" "$norm")" ]; then
        echo "[FAILED] $file header: expected exactly one blank line after END"
        warn_state_header
        rm -f "$norm"
        return 1
    fi

    local fblock pblock first_diff
    fblock=$(mktemp)
    pblock=$(mktemp)
    sed -n "${start_line},${end_line}p" "$norm" > "$fblock"
    awk -v s="$start" -v e="$end" '$0==s{f=1} f{print} $0==e && f{exit}' "$policy" > "$pblock"
    if ! cmp -s "$pblock" "$fblock"; then
        first_diff=$(awk 'NR==FNR{a[NR]=$0; next} $0!=a[FNR]{print FNR; exit}' "$pblock" "$fblock")
        if [ -z "$first_diff" ]; then
            first_diff=$(awk 'END{print NR}' "$fblock")
        fi
        echo "[FAILED] $file header: mismatch at line $first_diff"
        warn_state_header
        rm -f "$norm" "$fblock" "$pblock"
        return 1
    fi
    rm -f "$norm" "$fblock" "$pblock"
    echo "[PASSED] $file header"
    return 0
}

check_diary_title() {
    local file="$1"
    local today="$2"
    local norm h1_count h1_line
    norm=$(mktemp)
    awk 'NR==1{sub(/^\357\273\277/, "")} {sub(/\r$/, ""); sub(/[ \t]+$/, ""); print}' "$file" > "$norm"
    h1_count=$(awk '/^```/{f=!f; next} !f && /^# /{c++} END{print c+0}' "$norm")
    h1_line=$(awk '/^```/{f=!f; next} !f && /^# /{print; exit}' "$norm")
    if [ "$h1_count" -ne 1 ]; then
        echo "[FAILED] $file title: expected exactly one \"# Daily Checkpoint YYYY-MM-DD\""
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    if [ "$h1_line" != "# Daily Checkpoint $today" ]; then
        echo "[FAILED] $file title: date does not match the filename"
        warn_state_header
        rm -f "$norm"
        return 1
    fi
    rm -f "$norm"
    echo "[PASSED] $file title"
    return 0
}

# 4. Project Structure
echo "[4/8] Verifying project AI directory structure..."
PROJECT_SUBS=(
    "artifacts" "code-review-reports" "daily-checkpoints" "issues"
    "issues/open" "issues/in-progress" "issues/closed" "notes"
    "pending" "plans" "policies" "policies/compliance" "secrets"
    "shared" "shared/handoffs" "shared/project-knowledge" "state"
)
for sub in "${PROJECT_SUBS[@]}"; do
    if [ ! -d "ai/$sub" ]; then
        echo "Error: Mandatory project directory ai/$sub missing."
        exit 1
    fi
done
if find ai/issues -maxdepth 1 -type f -name '*.md' | grep -q .; then
    echo "Error: ticket files must live under ai/issues/{open,in-progress,closed}/, not directly under ai/issues/."
    exit 1
fi
if [ ! -f "ai/shared/project-knowledge/issue-template.md" ]; then
    echo "Error: Mandatory issue template ai/shared/project-knowledge/issue-template.md missing."
    exit 1
fi
HEADER_FAILED=0
for sf in context.md progress.md next-steps.md; do
    if ! check_state_file_header "$sf" "ai/state/$sf"; then
        HEADER_FAILED=1
    fi
done
TODAY=$(date +%F)
DIARY="ai/daily-checkpoints/$TODAY.md"
if [ -f "$DIARY" ]; then
    if ! check_state_file_header "daily-checkpoint" "$DIARY"; then
        HEADER_FAILED=1
    fi
    if ! check_diary_title "$DIARY" "$TODAY"; then
        HEADER_FAILED=1
    fi
else
    echo "[PENDING] $DIARY: no checkpoint for today; run a checkpoint"
fi
if [ "$HEADER_FAILED" -ne 0 ]; then
    exit 1
fi
STATE_BYTES=$(wc -c ai/state/context.md ai/state/progress.md ai/state/next-steps.md | awk 'END {print $1}')
if [ "$STATE_BYTES" -gt 20480 ]; then
    echo "Advisory: the three state files total $STATE_BYTES bytes, over the 20 KB soft target (non-fatal)."
fi
echo "Project structure verified."

# 5. Coordination Board
echo "[5/8] Verifying Coordination Board existence..."
if [ ! -f "ai/shared/coordination.md" ]; then
    echo "Error: Mandatory file ai/shared/coordination.md missing."
    exit 1
fi
echo "Coordination Board verified."

# 6. Policy Baseline
echo "[6/8] Verifying policy baseline (18 modular policies)..."
# NOTE: Do NOT run filesystem link-resolution checks against ai/policies/ or AGENTS.md.
# Policy files use project-root-relative paths and TIER CONFIGURATION anchor references that are
# correct from the end user's project root — they will always appear broken when checked
# from inside the protocol repo. See protocol-decisions.md "No markdown hyperlinks" entry.
POLICIES=(
    "common" "meta" "cloud" "api-backend" "web-frontend" 
    "data" "linux-system-admin" "windows-system-admin" "mobile-apps" "dba" "observability"
    "code-review" "codebase-examination" "design-docs" "coding-baseline"
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
if ! grep -q '^## State File Ownership Protocol$' ai/policies/ai-policy-common.md; then
    echo "Error: ai-policy-common.md missing '## State File Ownership Protocol'."
    exit 1
fi
if ! grep -q '^### Canonical State-File Headers$' ai/policies/ai-policy-common.md; then
    echo "Error: ai-policy-common.md missing '### Canonical State-File Headers'."
    exit 1
fi
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

echo "--- Protocol Validation v6.1 Completed Successfully ---"
