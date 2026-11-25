#!/usr/bin/env bash
# path-probe.sh
# Bounded reachability check for a configured User AI Directory or Team AI Directory.
# Exit 0: reachable; 1: not reachable; 124: timeout; 2: no bounded mechanism.
set -u

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PATH" >&2
  exit 2
fi

PATH_TO_PROBE="$1"
TIMEOUT_VALUE="${PATH_PROBE_TIMEOUT:-3}"

case "$TIMEOUT_VALUE" in
  ''|*[!0-9]*)
    echo "PATH_PROBE_TIMEOUT must be a positive integer" >&2
    exit 2
    ;;
esac
if [ "$TIMEOUT_VALUE" -le 0 ]; then
  echo "PATH_PROBE_TIMEOUT must be a positive integer" >&2
  exit 2
fi

if command -v timeout >/dev/null 2>&1; then
  timeout "$TIMEOUT_VALUE" ls "$PATH_TO_PROBE" >/dev/null 2>&1
  rc=$?
elif command -v gtimeout >/dev/null 2>&1; then
  gtimeout "$TIMEOUT_VALUE" ls "$PATH_TO_PROBE" >/dev/null 2>&1
  rc=$?
elif command -v perl >/dev/null 2>&1; then
  PATH_PROBE_TIMEOUT="$TIMEOUT_VALUE" perl -e 'alarm($ENV{PATH_PROBE_TIMEOUT} || 3); exec @ARGV' ls "$PATH_TO_PROBE" >/dev/null 2>&1
  rc=$?
else
  echo "PENDING: bounded check unavailable" >&2
  exit 2
fi

if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || [ "$rc" -eq 142 ]; then
  exit 124
fi
if [ "$rc" -eq 0 ]; then
  exit 0
fi
exit 1
