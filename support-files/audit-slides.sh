#!/usr/bin/env bash
# Audit every slide for content overflow and content outside the safe margins.
# This is the deterministic check; the visual review only inspects the flagged slides.
# Usage: ./support-files/audit-slides.sh
set -u
export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${PORT:-8767}"
CHROME="${CHROME:-google-chrome}"

if ! command -v "$CHROME" >/dev/null 2>&1; then
    echo "Missing browser: $CHROME" >&2
    exit 1
fi

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$ROOT" >/dev/null 2>&1 &
server=$!
trap 'kill "$server" 2>/dev/null || true' EXIT

ready=0
for _ in $(seq 1 30); do
    if curl -fsS "http://127.0.0.1:$PORT/docs/slides/simple-ai-workflow-slides.html" >/dev/null 2>&1; then
        ready=1
        break
    fi
    sleep 0.2
done
if [ "$ready" -ne 1 ]; then
    echo "Preview server did not start on port $PORT" >&2
    exit 1
fi

"$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
    --disable-dev-shm-usage --window-size=1600,900 --virtual-time-budget=20000 --dump-dom \
    "http://127.0.0.1:$PORT/docs/slides/simple-ai-workflow-slides.html?audit=1" \
    >/tmp/slides-audit.html 2>/dev/null

python3 - <<'PY'
import html
import json
import re
import sys

raw = open('/tmp/slides-audit.html', encoding='utf-8', errors='replace').read()
match = re.search(r'<pre id="audit">(.*?)</pre>', raw, re.S)
if not match:
    print('audit: no metrics found; the page did not finish the audit', file=sys.stderr)
    sys.exit(1)
rows = json.loads(html.unescape(match.group(1)))
bad = 0
for row in rows:
    over = row.get('over') or []
    if row['sh'] > row['limit'] or over:
        bad += 1
        print(f"slide {row['slide']:02d}: content {row['sh']}>{row['limit']} out={over[:4]}")
print(f"audited {len(rows)} slides; overflow {bad}")
PY
