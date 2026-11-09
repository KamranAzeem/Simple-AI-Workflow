#!/bin/bash

set -e

echo "--- Starting Protocol Validation v6.3 ---"

# 1. AGENTS.md Anchors & Hardening
echo "[1/8] Verifying AGENTS.md hardening..."
if ! grep -q "⚠️ STOP: READ-ONLY PROTOCOL" AGENTS.md; then
    echo "Error: Immortality Header missing in AGENTS.md"
    exit 1
fi

require_in() {
    local file="$1" pattern="$2" message="$3"
    if ! grep -q "$pattern" "$file"; then
        echo "Error: $message"
        exit 1
    fi
}

require_in "ai/procedures/load-context.md" '# PROCEDURE LOAD-CONTEXT: When the user says "load context"' "PROCEDURE LOAD-CONTEXT anchor missing in ai/procedures/load-context.md."
require_in "ai/procedures/bootstrap-project.md" '# PROCEDURE BOOTSTRAP-PROJECT: Empty repository' "PROCEDURE BOOTSTRAP-PROJECT anchor missing in ai/procedures/bootstrap-project.md."
require_in "ai/procedures/write-checkpoint.md" '# PROCEDURE WRITE-CHECKPOINT: When the user says "checkpoint"' "PROCEDURE WRITE-CHECKPOINT anchor missing in ai/procedures/write-checkpoint.md."
require_in "ai/procedures/run-peer-review.md" '# PROCEDURE RUN-PEER-REVIEW: When the user says "peer review"' "PROCEDURE RUN-PEER-REVIEW anchor missing in ai/procedures/run-peer-review.md."
require_in "ai/procedures/post-compaction-recovery.md" '# PROCEDURE POST-COMPACTION-RECOVERY:' "PROCEDURE POST-COMPACTION-RECOVERY anchor missing in ai/procedures/post-compaction-recovery.md."
require_in "ai/procedures/create-backup.md" '# PROCEDURE CREATE-BACKUP: When the user says "backup ai"' "PROCEDURE CREATE-BACKUP anchor missing in ai/procedures/create-backup.md."
require_in "ai/procedures/examine-codebase.md" '# PROCEDURE EXAMINE-CODEBASE: When the user says' "PROCEDURE EXAMINE-CODEBASE anchor missing in ai/procedures/examine-codebase.md."
require_in "ai/procedures/manage-issues.md" '# PROCEDURE MANAGE-ISSUES:' "PROCEDURE MANAGE-ISSUES anchor missing in ai/procedures/manage-issues.md."
require_in "ai/procedures/implement-plan.md" '# PROCEDURE IMPLEMENT-PLAN:' "PROCEDURE IMPLEMENT-PLAN anchor missing in ai/procedures/implement-plan.md."
require_in "ai/procedures/repair-state-files.md" '# PROCEDURE REPAIR-STATE-FILES:' "PROCEDURE REPAIR-STATE-FILES anchor missing in ai/procedures/repair-state-files.md."
require_in "ai/procedures/repair-knowledge-files.md" '# PROCEDURE REPAIR-KNOWLEDGE-FILES:' "PROCEDURE REPAIR-KNOWLEDGE-FILES anchor missing in ai/procedures/repair-knowledge-files.md."
require_in "ai/procedures/update-design-docs.md" '# PROCEDURE UPDATE-DESIGN-DOCS:' "PROCEDURE UPDATE-DESIGN-DOCS anchor missing in ai/procedures/update-design-docs.md."
require_in "ai/procedures/migrate-design-docs.md" '# PROCEDURE MIGRATE-DESIGN-DOCS:' "PROCEDURE MIGRATE-DESIGN-DOCS anchor missing in ai/procedures/migrate-design-docs.md."

require_in "ai/procedures/write-checkpoint.md" "STEP-ATOMIC-WRITE" "STEP-ATOMIC-WRITE missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "STEP-STATE-FILE-TRIMMING" "STEP-STATE-FILE-TRIMMING missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "STEP-DAILY-CHECKPOINT-FILE" "STEP-DAILY-CHECKPOINT-FILE missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "STEP-KNOWLEDGE-HEADER-PRE-WRITE" "STEP-KNOWLEDGE-HEADER-PRE-WRITE anchor missing in ai/procedures/write-checkpoint.md."
for anchor in STEP-DRY-RUN-KNOWLEDGE-REPAIR STEP-REPLACE-KNOWLEDGE-REPAIR STEP-REVIEW-KNOWLEDGE-REPAIR STEP-REVIEW-KNOWLEDGE-SIZE STEP-REPORT-KNOWLEDGE-REPAIR; do
    require_in "ai/procedures/repair-knowledge-files.md" "$anchor" "$anchor anchor missing in ai/procedures/repair-knowledge-files.md."
done

require_in "ai/procedures/load-context.md" 'Index `open/` and `in-progress/`' "Project Issues indexing step missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "Token Rationing" "Token Rationing steps missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "STEP-KNOWLEDGE-INDEXING" "STEP-KNOWLEDGE-INDEXING missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "STEP-POLICY-LOADING" "STEP-POLICY-LOADING missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "STEP-WORKFLOW-VERSION-CHECK" "STEP-WORKFLOW-VERSION-CHECK missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "Global AI Knowledge Directory" "Global AI Knowledge Directory reference missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "ITEM PROTOCOL-INDEX" "ITEM PROTOCOL-INDEX missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "Boot Scan Exclusions" "Boot Scan Exclusions reference missing from ai/procedures/load-context.md."
require_in "ai/procedures/load-context.md" "STEP-STATE-FILE-PROOF-OF-READ" "STEP-STATE-FILE-PROOF-OF-READ missing from ai/procedures/load-context.md."
require_in "ai/procedures/write-checkpoint.md" "STEP-FRESH-READ-BEFORE-WRITE" "STEP-FRESH-READ-BEFORE-WRITE missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "Before writing, verify each state-file header." "State-file header pre-write check missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "Before appending, verify today's header." "Checkpoint header pre-append check missing from ai/procedures/write-checkpoint.md."
require_in "ai/procedures/write-checkpoint.md" "Preserve each header verbatim." "Header preservation check missing from ai/procedures/write-checkpoint.md."

require_in "AGENTS.md" "^## Shared Protocol Steps$" "Shared Protocol Steps section missing from AGENTS.md."
require_in "AGENTS.md" "STEP-PROTOCOL-INDEX" "STEP-PROTOCOL-INDEX missing from AGENTS.md."
require_in "AGENTS.md" "STEP-SKILLS-INDEX" "STEP-SKILLS-INDEX missing from AGENTS.md."
require_in "AGENTS.md" 'use skill <name>' "use skill dispatch missing from AGENTS.md."
require_in "ai/procedures/load-context.md" "ITEM SKILLS-INDEX" "ITEM SKILLS-INDEX missing from ai/procedures/load-context.md."
require_in "ai/policies/ai-policy-common.md" '^## Skills$' "Skills section missing from ai-policy-common.md."
require_in "AGENTS.md" "^## Protocol Dispatch$" "Protocol Dispatch section missing from AGENTS.md."
require_in "AGENTS.md" "Single-Writer" "State File Single-Writer Ownership rule missing from TIER READ-FIRST-RULES in AGENTS.md."
require_in "AGENTS.md" "Full File Reads" "Full File Reads mandate missing from TIER READ-FIRST-RULES in AGENTS.md."

if grep -qE "\bPROCEDURE [A-I]\b|\bProcedure [A-I]\b|\bprocedure [A-I]\b" AGENTS.md ai/procedures/*.md; then
    echo "Error: letter-based procedure reference found; use PROCEDURE <NAME> instead."
    exit 1
fi
if grep -qE "\bTIER [0-9]\b|\bStep [0-9]\b" AGENTS.md ai/procedures/*.md; then
    echo "Error: numeric tier or step reference found; use TIER <NAME> or STEP <NAME> instead."
    exit 1
fi
if [ "$(wc -l < AGENTS.md)" -gt 160 ] || [ "$(wc -w < AGENTS.md)" -gt 2400 ] || [ "$(wc -c < AGENTS.md)" -gt 24900 ]; then
    echo "Error: AGENTS.md exceeds the thin targets (160 lines, 2,400 words, 24,900 bytes)."
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
    "Global AI Skills Directory"
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
    "Project AI Skills Directory"
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
    "shared" "shared/handoffs" "shared/project-knowledge" "skills" "state"
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
for anchor in "### Knowledge Lookup" "### Knowledge Retirement" "six or fewer hyphen-separated segments" "50 knowledge files per store" "3,000 bytes" "Split a file only by task topic"; do
    require_in "ai/policies/ai-policy-common.md" "$anchor" "Knowledge rule missing: $anchor"
done
require_in "ai/procedures/repair-knowledge-files.md" "split only by task topic" "Knowledge repair topic-split rule missing."
if grep -nE 'never split a file|never split it|no split|file count (cannot|can.t|must not) increase' ai/policies/ai-policy-common.md ai/procedures/repair-knowledge-files.md docs/workflow-guide.md README.md docs/simple-ai-workflow-slides.md; then
    echo "Error: legacy no-split wording remains in the current knowledge rules."
    exit 1
fi
for pair in "cloud:cloud standards" "data:data standards" "dba:database standards" "api-backend:backend standards"; do
    name="${pair%%:*}"
    phrase="${pair#*:}"
    if ! awk -v phrase="- $phrase" '
        /^## Triggers[[:space:]]*$/ { in_trig = 1; next }
        in_trig && /^##[[:space:]]/ { in_trig = 0 }
        in_trig && $0 == phrase { found = 1 }
        END { exit(found ? 0 : 1) }
    ' "ai/policies/ai-policy-$name.md"; then
        echo "Error: ai-policy-$name.md missing the trigger '- $phrase' under '## Triggers'."
        exit 1
    fi
done

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

echo "--- Protocol Validation v6.3 Completed Successfully ---"
