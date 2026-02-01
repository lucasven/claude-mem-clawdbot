#!/bin/bash
# Search memory for relevant observations
# Usage: search-memory.sh "query"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "Usage: $0 \"search query\"" >&2
    exit 1
fi

QUERY="$1"
QUERY_ENCODED=$(echo "$QUERY" | jq -sRr @uri)

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Search observations
RESPONSE=$(curl -s --max-time 10 \
    "${WORKER_URL}/api/search?query=${QUERY_ENCODED}")

# Format output
if echo "$RESPONSE" | jq -e '.results | length > 0' >/dev/null 2>&1; then
    echo "$RESPONSE" | jq -r '.results[] | "[\(.type)] \(.title) (score: \(.score | tostring | .[0:4]))"'
else
    echo "No results found for: $QUERY"
fi
