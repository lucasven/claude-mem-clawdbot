#!/bin/bash
# Save an observation to memory
# Usage: save-observation.sh "observation text" [category]
# Categories: preference, decision, fact, learning, todo, general

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "Usage: $0 \"observation text\" [category]" >&2
    echo "Categories: preference, decision, fact, learning, todo, general" >&2
    exit 1
fi

CONTENT="$1"
CATEGORY="${2:-general}"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Save observation
RESPONSE=$(curl -s --max-time 10 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"content\": \"$CONTENT\", \"category\": \"$CATEGORY\"}" \
    "${WORKER_URL}/api/observations")

# Check response
if echo "$RESPONSE" | jq -e '.id' >/dev/null 2>&1; then
    echo "✓ Observation saved"
else
    echo "Error: $RESPONSE" >&2
    exit 1
fi
