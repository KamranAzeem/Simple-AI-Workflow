#!/usr/bin/env bash
# Build docs/slides/simple-ai-workflow-slides.html from the canonical Markdown deck.
# Usage: bash support-files/build-slides-html.sh [output]
# The default output is docs/slides/simple-ai-workflow-slides.html.

set -eu
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/support-files/slides-html.template.html"
DECK="$ROOT/docs/simple-ai-workflow-slides.md"
OUT="${1:-$ROOT/docs/slides/simple-ai-workflow-slides.html}"

if [ ! -f "$TEMPLATE" ]; then
    echo "Missing template: $TEMPLATE" >&2
    exit 1
fi
if [ ! -f "$DECK" ]; then
    echo "Missing deck: $DECK" >&2
    exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

awk -v deck="$DECK" '
    /<!--DECK-->/ {
        while ((getline line < deck) > 0) print line
        close(deck)
        next
    }
    { print }
' "$TEMPLATE" > "$tmp"

mkdir -p "$(dirname "$OUT")"
cp "$tmp" "$OUT"
chmod 644 "$OUT"
echo "Built $OUT from $DECK"
