# claude-mem-clawdbot

Persistent memory with contextual recall for Clawdbot sessions.

## What It Does

- **Session Start**: Injects a smart summary of recent context (last sessions, key observations)
- **During Session**: Saves observations about user preferences, decisions, and learnings
- **Session End**: Generates a summary for future sessions

## Setup

The skill uses a C# Worker (SQLite backend) that runs as a local service.

### First Time Setup

```bash
# From your Clawdbot workspace
cd skills/claude-mem-clawdbot

# Initialize submodule (Worker)
git submodule update --init --recursive

# Start Worker (auto-installs .NET if needed)
./scripts/ensure-worker.sh
```

## Usage

### Session Start (Automatic Context Injection)

At the beginning of each session, run:

```bash
./scripts/inject-context.sh
```

This returns a markdown summary of:
- Recent session summaries
- Key observations about the user
- Relevant context for current work

**Recommended**: Add to your session startup routine or AGENTS.md.

### Save Observations

When you learn something important about the user or make a decision worth remembering:

```bash
./scripts/save-observation.sh "User prefers dark mode" "preference"
./scripts/save-observation.sh "Decided to use PostgreSQL for the project" "decision"
./scripts/save-observation.sh "Lucas works in America/Sao_Paulo timezone" "fact"
```

**Categories**: `preference`, `decision`, `fact`, `learning`, `todo`, `general`

### End Session

When ending a session, generate a summary:

```bash
./scripts/end-session.sh "Worked on claude-mem integration, set up Worker, created skill structure"
```

### Search Memory

Query past observations and sessions:

```bash
./scripts/search-memory.sh "database preferences"
```

## Integration with AGENTS.md

Add this to your AGENTS.md for automatic context:

```markdown
## Session Memory

At session start, run `skills/claude-mem-clawdbot/scripts/inject-context.sh` and incorporate the context into your understanding.

During the session, save important observations with `save-observation.sh`.

At session end, summarize with `end-session.sh`.
```

## API Reference

The Worker runs on `http://127.0.0.1:37777` with these endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/api/context/inject` | GET | Get context summary for session start |
| `/api/observations` | POST | Save an observation |
| `/api/observations/search` | GET | Search observations |
| `/api/sessions` | POST | Create/update session |
| `/api/sessions/complete` | POST | Mark session complete with summary |
| `/api/stats` | GET | Get memory statistics |

## Files

```
claude-mem-clawdbot/
├── SKILL.md              # This file
├── worker/               # C# Worker (git submodule)
├── scripts/
│   ├── ensure-worker.sh  # Auto-start Worker
│   ├── inject-context.sh # Get context for session start
│   ├── save-observation.sh # Save observation
│   ├── end-session.sh    # End session with summary
│   └── search-memory.sh  # Search memory
└── README.md
```

## Requirements

- .NET 9.0 SDK (auto-installed by ensure-worker.sh)
- curl (for API calls)
