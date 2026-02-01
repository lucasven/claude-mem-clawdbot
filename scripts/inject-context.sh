#!/bin/bash
# Inject context at session start
# Returns a markdown summary of recent context

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Get context injection
RESPONSE=$(curl -s --max-time 10 "${WORKER_URL}/api/context/inject")

# Check if we got valid response
if [ -z "$RESPONSE" ] || [ "$RESPONSE" = "null" ]; then
    echo "No previous context found. Starting fresh session."
    exit 0
fi

# Output the context (it's already markdown formatted)
echo "$RESPONSE" | jq -r '.context // .message // "No context available"' 2>/dev/null || echo "$RESPONSE"
