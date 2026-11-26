#!/usr/bin/env bash
# Build the source-backed slide diagrams from docs/slides/diagrams/src.
# Usage: D2_BIN=/path/to/d2 ./support-files/build-slide-diagrams.sh
# The manifest records each diagram as source-backed or legacy with a reason.

set -euo pipefail
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$ROOT/docs/slides/diagrams/manifest.tsv"
SRC="$ROOT/docs/slides/diagrams/src"
OUT="$ROOT/docs/slides/diagrams"
D2_BIN="${D2_BIN:-$(command -v d2 || true)}"
MMDC_BIN="${MMDC_BIN:-$(command -v mmdc || true)}"
PUPPETEER_CONFIG="${PUPPETEER_CONFIG:-$HOME/.ai/settings/puppeteer-config.json}"

if [ ! -f "$MANIFEST" ]; then
    echo "Missing manifest: $MANIFEST" >&2
    exit 1
fi

fail=0
while IFS='|' read -r name status source reason; do
    case "$name" in
        ''|'#'*) continue ;;
    esac
    out="$OUT/$name.svg"
    if [ "$status" = "source" ]; then
        src="$SRC/$source"
        if [ ! -f "$src" ]; then
            echo "Missing source: $src" >&2
            fail=1
            continue
        fi
        case "$source" in
            *.d2)
                if [ -z "$D2_BIN" ]; then
                    echo "d2 not found; set D2_BIN" >&2
                    fail=1
                    continue
                fi
                "$D2_BIN" "$src" "$out"
                ;;
            *.mmd)
                if [ -z "$MMDC_BIN" ]; then
                    echo "mmdc not found; set MMDC_BIN" >&2
                    fail=1
                    continue
                fi
                "$MMDC_BIN" -p "$PUPPETEER_CONFIG" -i "$src" -o "$out"
                ;;
            *)
                echo "Unknown source type: $source" >&2
                fail=1
                ;;
        esac
    elif [ "$status" = "legacy" ]; then
        if [ ! -f "$out" ]; then
            echo "Missing legacy output: $out" >&2
            fail=1
        fi
        if [ -z "$reason" ]; then
            echo "Legacy diagram without a reason: $name" >&2
            fail=1
        fi
    else
        echo "Unknown status for $name: $status" >&2
        fail=1
    fi
done < "$MANIFEST"

if [ "$fail" -ne 0 ]; then
    echo "FAILED: diagram build." >&2
    exit 1
fi
echo "PASSED: slide diagrams."
