# claude-mem-clawdbot

🧠 Persistent memory with contextual recall for [Clawdbot](https://github.com/clawdbot/clawdbot).

## Features

- **Smart Context Injection**: Start each session with a summary of what matters
- **Observation Tracking**: Save preferences, decisions, and learnings
- **Semantic Search**: Find relevant memories when you need them
- **Session Summaries**: End sessions with summaries for future context

## Installation

### Via ClawdHub (coming soon)

```bash
clawdhub install lucasven/claude-mem-clawdbot
```

### Manual

```bash
cd your-clawdbot-workspace/skills
git clone --recursive https://github.com/lucasven/claude-mem-clawdbot.git
```

## Quick Start

```bash
# Start a session - get context from previous sessions
./scripts/inject-context.sh

# During session - save important observations
./scripts/save-observation.sh "User prefers TypeScript over JavaScript" "preference"

# End session - save summary for next time
./scripts/end-session.sh "Set up project structure, chose PostgreSQL for database"

# Search memories
./scripts/search-memory.sh "database"
```

## How It Works

Uses the [claude-mem-csharp](https://github.com/lucasven/claude-mem-csharp) Worker (included as submodule) as a local SQLite-backed memory service.

The Worker auto-installs .NET 9 SDK if needed and runs on `http://127.0.0.1:37777`.

## Requirements

- Clawdbot
- curl, jq
- .NET 9.0 SDK (auto-installed)

## License

MIT
