#!/bin/bash
# Ensure the claude-mem Worker is running
# Delegates to the Worker's own ensure script

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"
WORKER_ROOT="${SKILL_ROOT}/worker"

# Check if submodule is initialized
if [ ! -f "${WORKER_ROOT}/scripts/ensure-worker.sh" ]; then
    echo "Initializing Worker submodule..." >&2
    cd "$SKILL_ROOT"
    git submodule update --init --recursive
fi

# Use PLUGIN_ROOT override to point to worker directory
export CLAUDE_PLUGIN_ROOT="$WORKER_ROOT"

# Set default project if not specified
export CLAUDE_MEM_PROJECT="${CLAUDE_MEM_PROJECT:-clawdbot}"

# Delegate to Worker's ensure script
exec "${WORKER_ROOT}/scripts/ensure-worker.sh"
