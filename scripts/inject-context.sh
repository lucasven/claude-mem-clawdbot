#!/bin/bash
# Inject context at session start
# Returns a markdown summary of recent context

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="${CLAUDE_MEM_PROJECT:-clawdbot}"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Get context injection
RESPONSE=$(curl -s --max-time 10 "${WORKER_URL}/api/context/inject?project=${PROJECT}")

# Check if we got valid response
if [ -z "$RESPONSE" ] || [ "$RESPONSE" = "null" ] || [ "$RESPONSE" = '""' ]; then
    echo "No previous context found. Starting fresh session."
    exit 0
fi

# Output the context - unescape the JSON string and format as markdown
echo "$RESPONSE" | jq -r '.' 2>/dev/null | sed 's/\\n/\n/g' || echo "$RESPONSE"
