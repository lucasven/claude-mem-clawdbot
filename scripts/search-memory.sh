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
    "${WORKER_URL}/api/observations/search?q=${QUERY_ENCODED}")

# Format output
echo "$RESPONSE" | jq -r '.[] | "[\(.category)] \(.content) (\(.createdAt | split("T")[0]))"' 2>/dev/null || echo "$RESPONSE"
