# Architecture Overview
## Dual CLI Configuration for Python Code Assistant

## Visual Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                    Python Code Assistant                            │
│                    (Same Persona & Behavior)                        │
│                                                                     │
└──────────────┬──────────────────────────────────┬───────────────────┘
               │                                  │
               │                                  │
    ┌──────────▼──────────┐          ┌──────────▼──────────┐
    │                     │          │                     │
    │    Claude CLI       │          │     Cursor CLI      │
    │                     │          │                     │
    └──────────┬──────────┘          └──────────┬──────────┘
               │                                  │
               │                                  │
    ┌──────────▼──────────┐          ┌──────────▼──────────┐
    │  .claude/           │          │  .cursor/           │
    │  ├─ settings.json   │          │  ├─ settings.json   │
    │  └─ scripts/        │          │  └─ scripts/        │
    │     └─ session-end  │          │     └─ session-end  │
    └──────────┬──────────┘          └──────────┬──────────┘
               │                                  │
               │                                  │
               └──────────┬───────────────────────┘
                          │
                          │ Both write to:
                          ▼
                ┌────────────────────┐
                │  docs/             │
                │  ├─ transcripts    │
                │  └─ project docs   │
                └────────────────────┘
```

## Data Flow

### Session Start
```
User starts CLI tool
        │
        ├─── Claude CLI → reads CLAUDE.md
        │                → loads .claude/settings.json
        │
        └─── Cursor    → reads .cursorrules
                       → loads .cursor/hooks.json
        
        Both read docs/*.md for project context
```

### Session End
```
User ends session
        │
        ├─── Claude CLI → triggers .claude/scripts/session-end.sh
        │                → detects "Claude" from path
        │                → writes docs/YYYY-MM-DD-HHMMSS.txt
        │
        └─── Cursor    → triggers .cursor/scripts/session-end.sh
                       → detects "Cursor" from path
                       → writes docs/YYYY-MM-DD-HHMMSS.txt
```

## File Relationships

```
Project Root
│
├── Configuration Files
│   │
│   ├── CLAUDE.md ──────────┐
│   │   (Claude instructions) │
│   │                          ├──> Same content
│   └── .cursorrules ────────┘
│       (Cursor instructions)
│
├── Claude CLI Setup
│   │
│   ├── .claude/
│   │   ├── settings.json
│   │   │   └── points to → session-end.sh
│   │   │
│   │   └── scripts/
│   │       └── session-end.sh
│   │           ├── detects tool = "Claude"
│   │           ├── reads transcript
│   │           └── writes to docs/
│   │
│
├── Cursor Setup
│   │
│   ├── .cursor/
│   │   ├── hooks.json
│   │   │   └── points to → session-end.sh
│   │   │
│   │   └── scripts/
│   │       └── session-end.sh
│   │           ├── detects tool = "Cursor"
│   │           ├── reads transcript
│   │           └── writes to docs/
│   │
│
├── Shared Resources
│   │
│   ├── docs/
│   │   ├── python-best-practices.md ←┐
│   │   ├── [project-docs].md        ├─── Both tools read these
│   │   └── [transcripts].txt ───────┴─── Both tools write these
│   │
│   ├── setup-dual-cli.sh ──────────────── Verifies both setups
│   │
│   └── Documentation
│       ├── README.md ──────────────────── Main entry point
│       ├── DUAL-CLI-GUIDE.md ──────────── Comprehensive guide
│       ├── ARCHITECTURE.md ────────────── This file
│       └── CHANGES-SUMMARY.md ─────────── Change log
│
```

## Component Details

### 1. Instruction Files

| File | Used By | Size | Content |
|------|---------|------|---------|
| `CLAUDE.md` | Claude CLI | ~8KB | Python expert persona |
| `.cursorrules` | Cursor | ~8KB | Same as CLAUDE.md |

**Why duplicated?**
- Each tool expects its own file format/location
- No parsing or conversion needed
- Clear separation of tool-specific config

### 2. Hook Configuration

**Claude CLI** (`.claude/settings.json`):
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/session-end.sh"
          }
        ]
      }
    ]
  }
}
```

**Cursor** (`.cursor/hooks.json`):
```json
{
  "version": 1,
  "hooks": {
    "stop": [
      {
        "command": ".cursor/scripts/session-end.sh"
      }
    ]
  }
}
```

**Trigger**: Automatically when session ends
**Input**: JSON via stdin with session metadata
**Output**: Formatted transcript in docs/

### 3. Hook Script Architecture

```bash
session-end.sh
│
├── Configuration Detection
│   └── Determines tool from script path
│       ├── ".claude" in path → Claude
│       └── ".cursor" in path → Cursor
│
├── Input Processing
│   ├── Read stdin (JSON)
│   ├── Validate with jq
│   ├── Parse session metadata
│   └── Extract transcript path
│
├── Cross-Platform Support
│   ├── Detect OS (Darwin/Linux)
│   ├── Use appropriate commands
│   └── Handle path differences
│
├── Transcript Generation
│   ├── Filter context doc reads
│   ├── Format with box-drawing chars
│   ├── Truncate long outputs
│   └── Add tool label
│
└── Output
    ├── Validate docs/ exists
    ├── Generate unique filename
    └── Write formatted transcript
```

### 4. Setup Script Flow

```bash
setup-dual-cli.sh
│
├── Requirements Check
│   ├── jq installed?
│   ├── bash version?
│   ├── Claude CLI installed?
│   └── Cursor installed?
│
├── Structure Verification
│   ├── .claude/ exists?
│   ├── .cursor/ exists?
│   ├── docs/ exists?
│   └── Create if missing
│
├── File Verification
│   ├── Check all config files
│   ├── Validate JSON files
│   └── Report missing files
│
├── Permissions
│   ├── Make scripts executable
│   └── Verify execution rights
│
└── Report
    ├── Configuration status
    ├── Usage instructions
    └── Installation links
```

## Execution Flow Examples

### Example 1: Code Review with Claude CLI

```
User: claude
      > "Review app.py"

1. Claude CLI starts
   ├─ Reads CLAUDE.md
   ├─ Loads .claude/settings.json
   └─ Reads docs/*.md

2. Assistant reviews code
   ├─ Analyzes app.py
   ├─ Checks best practices
   └─ Provides feedback

3. User exits: exit

4. SessionEnd hook triggers
   ├─ .claude/scripts/session-end.sh runs
   ├─ Receives JSON with transcript path
   ├─ Detects tool = "Claude"
   ├─ Formats transcript
   └─ Saves to docs/2025-11-30-143022.txt
```

### Example 2: Feature Development with Cursor

```
User: Opens Cursor IDE
      Opens project folder
      Starts Cursor Agent

1. Cursor starts
   ├─ Reads .cursorrules
   ├─ Loads .cursor/hooks.json
   └─ Reads docs/*.md

2. Assistant helps with feature
   ├─ Edits multiple files
   ├─ Suggests improvements
   └─ Runs tests

3. User closes Cursor

4. SessionEnd hook triggers
   ├─ .cursor/scripts/session-end.sh runs
   ├─ Receives JSON with transcript path
   ├─ Detects tool = "Cursor"
   ├─ Formats transcript
   └─ Saves to docs/2025-11-30-145530.txt
```

## Tool Detection Logic

```bash
# In session-end.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$SCRIPT_DIR" == *".claude"* ]]; then
    TOOL_NAME="Claude"
    CONFIG_DIR=".claude"
elif [[ "$SCRIPT_DIR" == *".cursor"* ]]; then
    TOOL_NAME="Cursor"
    CONFIG_DIR=".cursor"
else
    TOOL_NAME="Unknown"
    CONFIG_DIR=".claude"  # Default fallback
fi
```

**How it works:**
1. Get absolute path of running script
2. Check if path contains ".claude" or ".cursor"
3. Set tool name and config dir accordingly
4. Use tool name in transcript header

**Why this approach?**
- ✓ Zero user configuration
- ✓ Automatic detection
- ✓ Impossible to misconfigure
- ✓ Works out of the box

## Cross-Platform Compatibility

### File Size Detection

```bash
get_file_size() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "freebsd"* ]]; then
        # macOS/BSD
        stat -f%z "$file" 2>/dev/null || echo "0"
    else
        # Linux/GNU
        stat -c%s "$file" 2>/dev/null || echo "0"
    fi
}
```

### Path Expansion

```bash
expand_path() {
    local path="$1"
    if [[ "$path" =~ ^~(/|$) ]]; then
        path="${HOME}${path#\~}"
    fi
    echo "$path"
}
```

## Transcript Format

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  ▐▛███▜▌   Cursor Code Session                            │
│ ▝▜█████▛▘  Sonnet 4.5 · Code Assistant                    │
│   ▘▘ ▝▝    Python Expert                                  │
│                                                             │
│ Session ID: a1b2c3d4-e5f6-7890-abcd-ef1234567890          │
│ Date: 2025-11-30 14:30:22                                  │
│ Tool: Cursor                                                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ ╭─ USER                                                     │
│ │ Can you review my Python code?                           │
│ ╰─                                                          │
│                                                             │
│ ╭─ ASSISTANT                                                │
│ │ I'll help you review the code.                           │
│ │                                                           │
│ │ ◇ Tool: Read                                              │
│ │   Input: {"path": "app.py"}                              │
│ ╰─                                                          │
│                                                             │
│ ╭─ USER                                                     │
│ │ ○ Tool Result [toolu_abc123]:                            │
│ │   def main():                                             │
│ │       print("Hello")                                      │
│ ╰─                                                          │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Session ended: 2025-11-30 14:35:30                         │
│ Reason: exit                                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Features:**
- ✓ Box-drawing characters for clarity
- ✓ Tool name in header
- ✓ Session ID and timestamps
- ✓ Formatted conversations
- ✓ Tool calls and results
- ✓ Thinking blocks preserved

## Configuration Management

### Settings Files

**Claude CLI** (`.claude/settings.json`):
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/session-end.sh"
          }
        ]
      }
    ]
  }
}
```

**Cursor** (`.cursor/hooks.json`):
```json
{
  "version": 1,
  "hooks": {
    "stop": [
      {
        "command": ".cursor/scripts/session-end.sh"
      }
    ]
  }
}
```

**Note**: Cursor uses `hooks.json` with a different format (`stop` event instead of `SessionEnd`), while Claude CLI uses `settings.json` with the `SessionEnd` event format.

### Validation

```bash
# Automatic validation in setup script
jq empty < .claude/settings.json
jq empty < .cursor/hooks.json
```

## Error Handling

### Hook Script Errors

```bash
# Insufficient data
if [[ "$FILE_SIZE" -lt 10 ]]; then
    echo "ERROR: Received insufficient data" >&2
    exit 1
fi

# Invalid JSON
if ! jq empty < "$TEMP_JSON"; then
    echo "ERROR: Invalid JSON" >&2
    exit 1
fi

# Missing transcript
if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
    echo "ERROR: Transcript file not found" >&2
    exit 1
fi

# Directory creation failed
if ! mkdir -p "$DOCS_DIR"; then
    echo "ERROR: Cannot create directory" >&2
    exit 1
fi
```

### Setup Script Checks

```bash
# Missing jq
if ! command -v jq &> /dev/null; then
    echo "❌ ERROR: jq is required"
    exit 1
fi

# Invalid JSON
if ! jq empty < "$CONFIG_FILE"; then
    echo "✗ Invalid JSON"
fi

# Missing files
if [[ ! -f "$REQUIRED_FILE" ]]; then
    echo "✗ File missing"
    ALL_PRESENT=false
fi
```

## Security Considerations

### Safe Path Handling
```bash
# Expand tilde safely
if [[ "$path" =~ ^~(/|$) ]]; then
    path="${HOME}${path#\~}"
fi

# Validate paths
if [[ ! -d "$directory" ]]; then
    echo "ERROR: Invalid directory" >&2
    exit 1
fi
```

### Cleanup on Exit
```bash
# Ensure temp files are removed
TEMP_JSON=$(mktemp)
trap 'rm -f "$TEMP_JSON"' EXIT
```

### Input Validation
```bash
# Validate JSON before processing
if ! jq empty < "$INPUT_FILE"; then
    exit 1
fi

# Check file sizes
FILE_SIZE=$(get_file_size "$FILE")
if [[ "$FILE_SIZE" -lt 10 ]]; then
    exit 1
fi
```

## Performance Considerations

### Efficient Transcript Processing

```bash
# Single-pass filtering
while IFS= read -r line; do
    # Process each line once
    # Extract and format content
done < "$TRANSCRIPT_PATH"

# Truncate long outputs
if [[ "$line_count" -gt 20 ]]; then
    echo "... (truncated)"
fi
```

### Minimal Dependencies

- **jq**: JSON processing (ubiquitous)
- **bash**: Shell execution (standard)
- **basic utilities**: cat, sed, grep (always present)

## Extension Points

### Adding New Tools

To add support for another CLI tool:

1. Create `.toolname/` directory
2. Copy settings.json template
3. Copy session-end.sh script
4. Update script detection logic
5. Create `.toolnamerules` if needed
6. Update setup script

### Custom Transcript Formats

Edit the formatting section in `session-end.sh`:

```bash
# Around line 200
{
    echo "Custom header"
    # ... custom formatting
} > "$OUTPUT_FILE"
```

### Additional Hooks

Add more hooks in settings.json:

```json
{
  "hooks": {
    "SessionStart": [...],
    "SessionEnd": [...],
    "CustomEvent": [...]
  }
}
```

## Maintenance

### Regular Tasks

1. **Update instructions** when AI capabilities change
2. **Test with new CLI versions** when released
3. **Review transcripts** for quality issues
4. **Update best practices** as Python evolves

### Monitoring

Enable debug logging to monitor hook execution:

```bash
# In session-end.sh, uncomment:
LOG_FILE="$HOME/${TOOL_NAME,,}-hook-debug.log"
exec 2>>"$LOG_FILE"
```

## Summary

This architecture provides:

- ✓ **Unified Interface**: Same assistant across tools
- ✓ **Tool Flexibility**: Choose right tool for each task
- ✓ **Automatic Operation**: No manual configuration
- ✓ **Cross-Platform**: Works on macOS and Linux
- ✓ **Maintainable**: Clear structure and documentation
- ✓ **Extensible**: Easy to add features or tools
- ✓ **Reliable**: Robust error handling
- ✓ **Well-Documented**: Comprehensive guides

---

**Last Updated**: 2025-11-30  
**Version**: 1.0  
**Status**: Production Ready
