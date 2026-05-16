#!/bin/bash
# backup-ai-dir.sh — Backup the ai/ directory of the current project
# Usage: ./backup-ai-dir.sh
# Creates: ~/.ai/backups/{project-name}_{timestamp}.tar.gz

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"
BACKUP_DIR="$HOME/.ai/backups"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M')"
BACKUP_FILE="$BACKUP_DIR/${PROJECT_NAME}_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" -C "$PROJECT_ROOT" ai/

echo "Backup created: $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"
