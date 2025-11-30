# Dual CLI Setup Guide
## Using Python Code Assistant with Both Claude CLI & Cursor

This guide explains how to use the Python Code Assistant configuration with both Claude CLI and Cursor CLI tools in the same project.

## Overview

This project is configured to work seamlessly with **both** CLI tools:

| Tool | Config Location | Rules File | Hook Support |
|------|----------------|------------|--------------|
| **Claude CLI** | `.claude/` | `CLAUDE.md` | ✓ SessionEnd |
| **Cursor** | `.cursor/` | `.cursorrules` | ✓ SessionEnd |

Both configurations share:
- ✓ Same Python expert persona
- ✓ Same code review approach
- ✓ Same automatic transcript export
- ✓ Same `docs/` folder for project materials
- ✓ Cross-platform compatibility

## Quick Start

### 1. Run Setup Script

```bash
./setup-dual-cli.sh
```

This script will:
- Verify all configuration files are present
- Check for required dependencies (`jq`)
- Make hook scripts executable
- Validate JSON configuration files
- Show installation instructions if CLIs are missing

### 2. Choose Your Tool

**Option A: Claude CLI**
```bash
cd /path/to/project
claude
```

**Option B: Cursor IDE**
1. Open Cursor application
2. Open this folder
3. Start Cursor Agent (Cmd/Ctrl+Shift+P → "Cursor: Open Agent")

**Option C: Cursor CLI** (if available)
```bash
cd /path/to/project
cursor .
```

## Directory Structure

```
project/
├── .claude/                      # Claude CLI configuration
│   ├── settings.json            # Hook configuration
│   └── scripts/
│       └── session-end.sh       # SessionEnd hook
│
├── .cursor/                      # Cursor configuration
│   ├── hooks.json               # Hook configuration (Cursor format)
│   └── scripts/
│       └── session-end.sh       # SessionEnd hook
│
├── CLAUDE.md                     # Claude rules (verbose)
├── .cursorrules                  # Cursor rules (same content)
│
├── docs/                         # Shared documentation
│   ├── python-best-practices.md # Reference material
│   └── YYYY-MM-DD-HHMMSS.txt   # Auto-generated transcripts
│
├── setup-dual-cli.sh            # Setup automation script
└── README.md                    # Main documentation
```

## How It Works

### Automatic Tool Detection

The session hook script automatically detects which tool is running based on its location:

```bash
# In .claude/scripts/session-end.sh → detects as "Claude"
# In .cursor/scripts/session-end.sh → detects as "Cursor"
```

This means:
- ✓ Same script works in both locations
- ✓ Transcripts are labeled with the tool name
- ✓ No manual configuration needed

### Session Transcript Export

Both tools automatically export session transcripts when you end a session:

**Filename Format:**
```
docs/YYYY-MM-DD-HHMMSS-<session-id>.txt
```

**Example:**
```
docs/2025-11-30-143022-a1b2c3d4.txt
```

**What's Included:**
- Full conversation history
- Code review discussions
- Tool calls and results
- Thinking blocks (if available)
- Implementation decisions

### Document Integration

Both tools automatically read project documents at session start:

**Where to Put Documents:**
```
docs/
├── requirements.md              # Project requirements
├── architecture.md              # System design
├── style-guide.md              # Project-specific style rules
└── api-spec.md                 # API documentation
```

**Automatic Behavior:**
- At session start, the assistant reads all `.md` files in `docs/`
- Content is integrated into responses
- Tool reads are filtered from transcript output (to avoid clutter)

## Configuration Files

### `.claude/settings.json` & `.cursor/hooks.json`

**Claude CLI** uses `settings.json`:
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

**Cursor** uses `hooks.json` (different format):
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

**Note**: Cursor uses a different configuration format (`hooks.json` with `stop` event) compared to Claude CLI (`settings.json` with `SessionEnd` event). This reflects each tool's specific configuration requirements.

### `CLAUDE.md` & `.cursorrules`

Both files contain the same Python Code Assistant instructions:
- Expert Python persona definition
- Code review checklist
- Communication style
- Technical philosophy
- Best practices emphasis

**Why Two Files?**
- Claude CLI reads `CLAUDE.md`
- Cursor reads `.cursorrules`
- Content is identical for consistency

## Session Hook Script Features

The improved `session-end.sh` includes:

### ✓ Cross-Platform Compatibility

```bash
# Works on both macOS and Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    stat -f%z "$file"
else
    # Linux
    stat -c%s "$file"
fi
```

### ✓ Automatic Tool Detection

```bash
# Detects which tool is running
if [[ "$SCRIPT_DIR" == *".claude"* ]]; then
    TOOL_NAME="Claude"
elif [[ "$SCRIPT_DIR" == *".cursor"* ]]; then
    TOOL_NAME="Cursor"
fi
```

### ✓ Collision Prevention

```bash
# Unique timestamps with seconds
TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")

# Optional session ID suffix
if [[ -n "$SESSION_ID" ]]; then
    SESSION_SUFFIX="-${SESSION_ID:0:8}"
fi
```

### ✓ Robust Error Handling

```bash
# Validates JSON input
if ! jq empty < "$TEMP_JSON"; then
    echo "ERROR: Invalid JSON" >&2
    exit 1
fi

# Ensures directory exists
if ! mkdir -p "$DOCS_DIR"; then
    echo "ERROR: Cannot create directory" >&2
    exit 1
fi
```

### ✓ Clean Output Formatting

Transcripts use box-drawing characters for clarity:

```
╭─ USER
│ Can you review this code?
╰─

╭─ ASSISTANT
│ I'll help you review the code. Let me read the file first.
│
│ ◇ Tool: Read
│   Input: {"path": "app.py"}
╰─
```

## Switching Between Tools

You can use both tools on the same project without conflicts:

### Scenario 1: Use Claude CLI for Code Review

```bash
cd ~/project
claude
> "Review the changes in app.py"
```

Transcript saved to: `docs/2025-11-30-140000.txt`

### Scenario 2: Use Cursor for Development

Open Cursor IDE → Open folder → Start agent
> "Implement the new feature in app.py"

Transcript saved to: `docs/2025-11-30-140500.txt`

### Benefits:
- ✓ All transcripts in one location (`docs/`)
- ✓ Same assistant persona and behavior
- ✓ Unified project knowledge base
- ✓ Choose tool based on workflow preference

## Advanced Usage

### Custom Debug Logging

Enable debug logging in either hook script:

```bash
# Edit .claude/scripts/session-end.sh or .cursor/scripts/session-end.sh
# Uncomment these lines:

LOG_FILE="$HOME/${TOOL_NAME,,}-session-hook-debug.log"
exec 2>>"$LOG_FILE"
echo "[$(date)] ===== SessionEnd hook invoked =====" >&2
```

This creates detailed logs at:
- `~/claude-session-hook-debug.log`
- `~/cursor-session-hook-debug.log`

### Customizing Transcript Format

Edit the transcript generation section in either script:

```bash
# Around line 200 in session-end.sh
{
    echo "Custom header here"
    echo "Tool: $TOOL_NAME"
    # ... rest of transcript formatting
} > "$OUTPUT_FILE"
```

### Filtering Tool Results

The script automatically filters reads from `docs/` to avoid clutter:

```bash
# Modify this jq filter to change behavior
.message.content[]? |
select(.type == "tool_use" and .name == "Read") |
select(.input.path | test("docs/.*\\.(md|txt)$")) |
.id
```

## Troubleshooting

### Hook Not Running

**Symptom:** No transcript files appear in `docs/`

**Solutions:**
1. Check script is executable:
   ```bash
   ls -l .claude/scripts/session-end.sh
   ls -l .cursor/scripts/session-end.sh
   ```

2. Run setup script:
   ```bash
   ./setup-dual-cli.sh
   ```

3. Verify JSON configuration:
   ```bash
   jq empty < .claude/settings.json
   jq empty < .cursor/hooks.json
   ```

4. Enable debug logging (see Advanced Usage)

### Invalid JSON Error

**Symptom:** Script fails with "Invalid JSON" message

**Solutions:**
1. Check tool is sending data:
   ```bash
   # Enable debug logging and check log file
   ```

2. Verify jq is installed:
   ```bash
   which jq
   jq --version
   ```

3. Check stdin data in logs

### Permission Denied

**Symptom:** Script fails to create files

**Solutions:**
1. Make scripts executable:
   ```bash
   chmod +x .claude/scripts/session-end.sh
   chmod +x .cursor/scripts/session-end.sh
   ```

2. Check `docs/` directory permissions:
   ```bash
   ls -ld docs/
   ```

3. Ensure write access to project directory

### Transcripts Not Formatted Correctly

**Symptom:** Transcripts show raw JSON or broken formatting

**Solutions:**
1. Verify jq is working:
   ```bash
   echo '{"test": "value"}' | jq .
   ```

2. Check transcript file exists:
   ```bash
   ls -lh docs/
   ```

3. Review debug logs for processing errors

## Comparison: Claude CLI vs Cursor

### When to Use Claude CLI

**Best For:**
- ✓ Quick code reviews from terminal
- ✓ Scripting and automation
- ✓ Remote server development (SSH)
- ✓ CI/CD integration
- ✓ Command-line workflow

**Example Use Cases:**
```bash
# Quick code review
claude < code.py

# Interactive session
claude

# Piped input
git diff | claude "review these changes"
```

### When to Use Cursor

**Best For:**
- ✓ Full IDE experience with code intelligence
- ✓ Multi-file editing with context
- ✓ Visual code navigation
- ✓ Integrated debugging
- ✓ GUI-based workflow

**Example Use Cases:**
- Writing new features across multiple files
- Refactoring with visual feedback
- Debugging with inline suggestions
- Code navigation with AI assistance

### Feature Comparison

| Feature | Claude CLI | Cursor |
|---------|-----------|--------|
| **Terminal Access** | ✓ Native | ○ Via integrated terminal |
| **Visual Editor** | ✗ No | ✓ Full IDE |
| **Code Intelligence** | ○ Basic | ✓ Advanced |
| **Transcript Export** | ✓ Yes | ✓ Yes |
| **Multi-file Edit** | ○ Sequential | ✓ Simultaneous |
| **Remote Dev** | ✓ Easy | ○ Possible |
| **Automation** | ✓ Easy | ○ Limited |

## Best Practices

### 1. Consistent Project Structure

Keep project documentation organized:

```
docs/
├── README.md                    # Project overview
├── requirements.md              # Feature requirements
├── architecture.md              # System design
├── style-guide.md              # Code standards
└── [transcripts]/              # Auto-generated
```

### 2. Regular Transcript Review

Periodically review transcripts for:
- Implementation decisions
- Code review feedback
- Technical discussions
- Lessons learned

### 3. Tool Selection Strategy

- Use **Claude CLI** for quick reviews and terminal workflows
- Use **Cursor** for feature development and refactoring
- Both tools create unified history in `docs/`

### 4. Custom Documentation

Add project-specific docs that both tools will read:

```bash
# Create project-specific guide
cat > docs/project-conventions.md << 'EOF'
# Project Conventions

## Naming
- Use `snake_case` for functions
- Use `PascalCase` for classes
- Prefix private methods with `_`

## Testing
- All features require tests
- Use pytest fixtures
- 80% coverage minimum
EOF
```

### 5. Version Control

Add to `.gitignore`:

```gitignore
# Session transcripts (optional - keep or ignore)
docs/20*.txt

# Debug logs
*-session-hook-debug.log
```

Consider **keeping** transcripts in version control to:
- Track technical decisions
- Review code evolution
- Onboard new team members

## Migration from Single CLI

If you're migrating from a single-CLI setup:

### From Claude-Only Setup

```bash
# 1. Create Cursor configuration
mkdir -p .cursor/scripts

# 2. Create Cursor hooks.json (different format)
cat > .cursor/hooks.json << 'EOF'
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
EOF

# 4. Copy script
cp .claude/scripts/session-end.sh .cursor/scripts/

# 5. Create .cursorrules
cp CLAUDE.md .cursorrules

# 6. Run setup
./setup-dual-cli.sh
```

### From Cursor-Only Setup

```bash
# 1. Create Claude configuration
mkdir -p .claude/scripts

# 2. Create Claude settings.json (different format)
cat > .claude/settings.json << 'EOF'
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
EOF

# 4. Copy script
cp .cursor/scripts/session-end.sh .claude/scripts/

# 5. Create CLAUDE.md
cp .cursorrules CLAUDE.md

# 6. Run setup
./setup-dual-cli.sh
```

## Contributing

### Reporting Issues

If you encounter issues with the dual CLI setup:

1. Run the setup script with verbose output
2. Check debug logs (if enabled)
3. Verify both configurations independently
4. Report which tool(s) are affected

### Suggesting Improvements

Consider these areas:
- Script portability (Windows support?)
- Additional CLI tool support
- Transcript format enhancements
- Configuration validation

## Resources

### Official Documentation

- **Claude CLI**: https://claude.ai/docs/cli
- **Cursor**: https://docs.cursor.sh
- **jq Manual**: https://stedolan.github.io/jq/manual/

### Related Files

- `README.md` - Main project documentation
- `CLAUDE.md` - Claude instructions
- `.cursorrules` - Cursor instructions
- `docs/python-best-practices.md` - Python reference guide

## Summary

This dual CLI setup provides:

✓ **Flexibility** - Use either tool based on workflow
✓ **Consistency** - Same assistant behavior in both
✓ **Unified History** - All transcripts in one location
✓ **Portability** - Works on macOS and Linux
✓ **Maintainability** - Single set of documentation
✓ **Extensibility** - Easy to add more tools

Choose the right tool for each task and let the configuration handle the rest!
