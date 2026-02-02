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

# Get or generate a session ID (same logic as save-observation.sh)
SESSION_ID="${CLAUDE_MEM_SESSION_ID:-clawdbot-$(date +%Y%m%d)}"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Escape summary for JSON
SUMMARY_ESCAPED=$(echo "$SUMMARY" | jq -Rs '.')

# Complete the session
RESPONSE=$(curl -s --max-time 10 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"contentSessionId\": \"$SESSION_ID\", \"summary\": $SUMMARY_ESCAPED}" \
    "${WORKER_URL}/api/sessions/complete")

# Check response
if echo "$RESPONSE" | jq -e '.success' >/dev/null 2>&1; then
    echo "✓ Session completed (${SESSION_ID})"
elif echo "$RESPONSE" | jq -e '.error' >/dev/null 2>&1; then
    echo "Error: $(echo "$RESPONSE" | jq -r '.error')" >&2
    exit 1
else
    echo "Session ended: $RESPONSE"
fi
