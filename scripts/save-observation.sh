#!/bin/bash
# Save an observation to memory
# Usage: save-observation.sh "observation text" [category]
# Categories: preference, decision, fact, learning, todo, discovery

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "Usage: $0 \"observation text\" [category]" >&2
    echo "Categories: preference, decision, fact, learning, todo, discovery" >&2
    exit 1
fi

CONTENT="$1"
CATEGORY="${2:-discovery}"

# Get or generate a session ID
SESSION_ID="${CLAUDE_MEM_SESSION_ID:-clawdbot-$(date +%Y%m%d)}"
PROJECT="${CLAUDE_MEM_PROJECT:-clawdbot}"

# Ensure Worker is running
WORKER_URL=$("${SCRIPT_DIR}/ensure-worker.sh" 2>/dev/null)

# Ensure session exists (init if needed)
curl -s --max-time 5 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"contentSessionId\": \"$SESSION_ID\", \"project\": \"$PROJECT\"}" \
    "${WORKER_URL}/api/sessions/init" >/dev/null 2>&1

# Escape content for JSON
CONTENT_ESCAPED=$(echo "$CONTENT" | jq -Rs '.')

# Save observation
RESPONSE=$(curl -s --max-time 10 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{
        \"contentSessionId\": \"$SESSION_ID\",
        \"title\": $CONTENT_ESCAPED,
        \"narrative\": $CONTENT_ESCAPED,
        \"observationType\": \"$CATEGORY\"
    }" \
    "${WORKER_URL}/api/sessions/observations")

# Check response
if echo "$RESPONSE" | jq -e '.observationId' >/dev/null 2>&1; then
    echo "✓ Observation saved (id: $(echo "$RESPONSE" | jq -r '.observationId'))"
elif echo "$RESPONSE" | jq -e '.error' >/dev/null 2>&1; then
    echo "Error: $(echo "$RESPONSE" | jq -r '.error')" >&2
    exit 1
else
    # Try to extract useful info
    if echo "$RESPONSE" | grep -q "queued\|success"; then
        echo "✓ Observation saved"
    else
        echo "Response: $RESPONSE" >&2
    fi
fi
