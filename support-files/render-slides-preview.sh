#!/usr/bin/env bash
# Render the Markdown deck to per-slide PNGs for the AI's own review.
# Usage: ./support-files/render-slides-preview.sh
# Requires: python3, curl, and Google Chrome. No installation and no network beyond the preview CDN.

set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DECK="$ROOT/docs/simple-ai-workflow-slides.md"
OUT="$ROOT/ai/artifacts/slides-preview"
PORT="${PORT:-8765}"
CHROME="${CHROME:-google-chrome}"

if [ ! -f "$DECK" ]; then
    echo "Missing deck: $DECK" >&2
    exit 1
fi
if ! command -v "$CHROME" >/dev/null 2>&1; then
    echo "Missing browser: $CHROME" >&2
    exit 1
fi

mkdir -p "$OUT"
separators="$(grep -c '^---$' "$DECK" || true)"
slides=$((separators + 1))
profile="$(mktemp -d)"

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$ROOT" >/dev/null 2>&1 &
server=$!
trap 'kill "$server" 2>/dev/null || true; rm -rf "$profile"' EXIT

ready=0
for _ in $(seq 1 30); do
    if curl -fsS "http://127.0.0.1:$PORT/support-files/preview-slides.html" >/dev/null 2>&1; then
        ready=1
        break
    fi
    sleep 0.2
done
if [ "$ready" -ne 1 ]; then
    echo "Preview server did not start on port $PORT" >&2
    exit 1
fi

fail=0
for i in $(seq 1 "$slides"); do
    output="$OUT/slide-$(printf '%02d' "$i").png"
    if "$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
        --disable-dev-shm-usage --force-device-scale-factor=1 \
        --user-data-dir="$profile" \
        --window-size=1600,900 --virtual-time-budget=6000 \
        --screenshot="$output" \
        "http://127.0.0.1:$PORT/support-files/preview-slides.html#/$((i - 1))" >/dev/null 2>&1; then
        printf 'Rendered slide %s\n' "$i"
    else
        printf 'FAILED slide %s\n' "$i"
        fail=1
    fi
done

if [ "$fail" -ne 0 ]; then
    echo "Some slides failed; see $OUT" >&2
    exit 1
fi
printf 'Rendered %s slides to %s\n' "$slides" "$OUT"
