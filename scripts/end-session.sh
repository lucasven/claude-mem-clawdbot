#!/bin/bash
# End the current session with a summary
# Usage: end-session.sh "Summary of what was accomplished"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "Usage: $0 \"Summary of what was accomplished\"" >&2
    exit 1
fi

SUMMARY="$1"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Complete the session
RESPONSE=$(curl -s --max-time 10 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"summary\": \"$SUMMARY\"}" \
    "${WORKER_URL}/api/sessions/complete")

# Check response
if echo "$RESPONSE" | jq -e '.success' >/dev/null 2>&1; then
    echo "✓ Session completed"
else
    echo "Session ended: $RESPONSE"
fi
