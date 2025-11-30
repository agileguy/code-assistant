# Code Assistant - Python Expert

This is a custom AI Code Assistant configuration that implements a Python coding assistant persona. The assistant is an expert software engineer specializing in Python development, code review, and best practices.

**✨ Works with both Claude CLI and Cursor CLI!**

## Overview

The Code Assistant helps developers write better Python code through thoughtful guidance, practical examples, and comprehensive code reviews. It combines deep Python expertise with clear communication to improve code quality and developer skills.

This configuration works seamlessly with **both Claude CLI and Cursor**, providing:
- ✓ Same expert Python assistant in both tools
- ✓ Automatic session transcript export to `docs/`
- ✓ Unified project documentation integration
- ✓ Cross-platform compatibility (macOS & Linux)

## How It Works

The assistant's behavior and expertise are defined in:
- `CLAUDE.md` - Instructions for Claude CLI
- `.cursorrules` - Instructions for Cursor (same content)

Both tools receive identical instructions, ensuring consistent behavior regardless of which CLI you use.

### Key Features

- **Expert Python knowledge**: Deep understanding of Python 3.x, standard library, frameworks, and ecosystem
- **Code review focus**: Systematic approach to reviewing code for correctness, style, security, and performance
- **Best practices guidance**: Advocates for PEP 8, type hints, modern Python features, and idiomatic code
- **Practical examples**: Provides working code examples and explains tradeoffs
- **Document integration**: Automatically reads and incorporates user-provided materials from the `docs/` folder
- **Session transcripts**: Automatically exports conversation history for reference

## The docs/ Folder

Place any documents in the `docs/` folder that you want the assistant to review and incorporate into sessions. These might include:

- Project requirements or specifications
- Architecture documentation
- Code style guides specific to your project
- Research materials or API documentation
- Design notes or technical decisions

**The assistant will automatically read all documents in this folder at the start of each session.**

## Reference Materials

The following reference document provides guidance for the assistant:

- `python-best-practices.md` - Comprehensive Python best practices, patterns, and idioms

## Quick Start

### Option 1: Using Claude CLI

```bash
cd /path/to/this/project
claude
```

### Option 2: Using Cursor

1. Open Cursor IDE
2. Open this folder
3. Start Cursor Agent (Cmd/Ctrl+Shift+P → "Cursor: Open Agent")

### Option 3: Automated Setup

Run the setup script to verify your configuration:

```bash
./setup-dual-cli.sh
```

For detailed instructions, see [**DUAL-CLI-GUIDE.md**](DUAL-CLI-GUIDE.md).

## Usage

Simply start either Claude Code or Cursor in this directory and begin your conversation. The assistant will:

1. Check the `docs/` folder for any project materials
2. Read and familiarize itself with your documents
3. Provide code reviews, write code, or answer Python questions
4. Reference your project-specific context when relevant

## Example Use Cases

### Code Review
```
You: "Can you review this function in app.py?"
Assistant: [Reads the file, analyzes against best practices, provides specific feedback with examples]
```

### Writing Code
```
You: "I need a Python script to parse JSON logs and extract error messages"
Assistant: [Clarifies requirements, writes clean Python code with type hints and error handling]
```

### Explaining Concepts
```
You: "What's the difference between a list comprehension and a generator expression?"
Assistant: [Explains clearly with examples and discusses when to use each]
```

### Architecture Guidance
```
You: "How should I structure a Flask API with database models?"
Assistant: [Provides project structure, explains separation of concerns, shows examples]
```

## Session Transcripts

### Automatic Export

Session transcripts are **automatically exported** when your session ends (works with both Claude and Cursor).

**How it works:**
- When any session ends (via exit, logout, or natural completion), a SessionEnd hook automatically captures the full conversation
- Transcripts are formatted in a human-readable format with box-drawing characters
- Files are saved to `docs/{timestamp}.txt` where timestamp format is `YYYY-MM-DD-HHMMSS`
- Example filename: `docs/2025-11-30-143022-a1b2c3d4.txt`
- The tool name (Claude or Cursor) is included in the transcript header

**What's included:**
- Complete conversation history
- Code review discussions
- Implementation decisions
- Questions and answers
- Code changes and rationale

**Configuration:**
- Claude hook: `.claude/settings.json` → `.claude/scripts/session-end.sh`
- Cursor hook: `.cursor/hooks.json` → `.cursor/scripts/session-end.sh`
- The SessionEnd hook runs automatically on every session end
- No manual export needed - just exit normally
- Works cross-platform (macOS & Linux)

**Requirements:**
- `jq` must be installed for JSON processing (the script will check and provide a clear error if missing)
- Cross-platform support: Works on Linux and macOS

**Debug Mode:**
- Enable verbose debug logging by setting `CLAUDE_HOOK_DEBUG=1` environment variable
- Optionally set `CLAUDE_HOOK_LOG_FILE` to specify a custom log file path
- Debug logs include environment variables, raw input data, and processing steps

**Benefits:**
- Track technical decisions over time
- Review past code review discussions
- Reference previous implementation choices
- Build a knowledge base of your project

## Python Focus Areas

The assistant emphasizes:

### Modern Python (3.10+)
- Type hints and static typing
- Dataclasses for data containers
- Pathlib for file operations
- F-strings for formatting
- Structural pattern matching (3.10+)

### Code Quality
- PEP 8 compliance
- Clear naming and structure
- Appropriate use of design patterns
- Comprehensive docstrings
- Effective error handling

### Testing
- pytest-based testing
- Test fixtures and parametrization
- Mocking external dependencies
- Test coverage analysis

### Security
- Input validation
- SQL injection prevention
- Secrets management
- Dependency security

### Performance
- Appropriate data structures
- Generator expressions for memory efficiency
- Profiling guidance
- Optimization strategies

## Getting Started

### 1. Install CLI Tools (if not already installed)

**Claude CLI:**
```bash
npm install -g @anthropic-ai/claude-cli
# or visit https://claude.ai/download
```

**Cursor:**
```bash
# Download from https://cursor.sh
# Cursor CLI may be included with the IDE
```

### 2. Clone or Download This Repository

```bash
git clone <repository-url>
cd code-assistant
```

### 3. Run Setup Script

```bash
./setup-dual-cli.sh
```

This will verify your configuration and ensure everything is set up correctly.

### 4. Start Using the Assistant

**With Claude CLI:**
```bash
claude
```

**With Cursor:**
- Open Cursor IDE
- Open this folder
- Start Cursor Agent

### 5. Add Project Documents

Add any project-specific documents to `docs/`:
```bash
echo "# Project Requirements" > docs/requirements.md
echo "# Architecture Notes" > docs/architecture.md
```

The assistant will automatically read these at session start!

## Documentation

- **[DUAL-CLI-GUIDE.md](DUAL-CLI-GUIDE.md)** - Comprehensive guide for using both CLIs
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture and design documentation
- **[CHANGES-SUMMARY.md](CHANGES-SUMMARY.md)** - Summary of changes and improvements
- **[WORKSPACE-REVIEW.md](WORKSPACE-REVIEW.md)** - Comprehensive workspace review and code quality assessment
- **[docs/python-best-practices.md](docs/python-best-practices.md)** - Python reference guide
- **[CLAUDE.md](CLAUDE.md)** - Full assistant instructions

## Project Structure

```
code-assistant/
├── .claude/                      # Claude CLI configuration
│   ├── settings.json            # Hook settings
│   └── scripts/
│       └── session-end.sh       # Transcript export script
│
├── .cursor/                      # Cursor configuration
│   ├── hooks.json               # Hook settings (Cursor format)
│   └── scripts/
│       └── session-end.sh       # Transcript export script
│
├── CLAUDE.md                     # Claude assistant instructions
├── .cursorrules                  # Cursor assistant instructions
│
├── docs/                         # Documentation & transcripts
│   ├── python-best-practices.md # Python reference
│   └── [auto-generated].txt    # Session transcripts
│
├── setup-dual-cli.sh            # Setup automation script
├── DUAL-CLI-GUIDE.md            # Detailed dual CLI guide
└── README.md                    # This file
```

## Features

### 🤖 Expert Python Assistant
- Deep knowledge of Python 3.10+ features
- PEP 8 and modern best practices
- Type hints and static typing
- pytest-based testing patterns

### 📝 Code Review Excellence
- Systematic review checklist
- Correctness, style, security, and performance
- Specific feedback with line numbers
- Working code examples

### 🔄 Dual CLI Support
- Works with Claude CLI and Cursor
- Automatic tool detection
- Unified transcript format
- Cross-platform compatibility

### 📦 Automatic Transcript Export
- Every session saved to `docs/`
- Human-readable format
- Preserves thinking blocks
- Filters clutter (auto-read docs)

### 📚 Document Integration
- Auto-reads `docs/*.md` at session start
- Project-specific context
- Requirements and architecture
- Style guides and conventions

## Recent Changes

### 2025-11-30 (Latest)
- **🔧 Script improvements**: Cleaned up duplicate code in session-end.sh
- **📝 Cursor config update**: Changed from `settings.json` to `hooks.json` (Cursor format)
- **📋 Workspace review**: Added comprehensive workspace review document
- **✨ Code cleanup**: Simplified error handling and removed redundant code blocks

### 2025-11-30
- **✨ Added Cursor CLI support**: Full dual CLI configuration
- **Created `.cursorrules`**: Cursor-specific instructions file
- **Created `.cursor/` config**: Mirror of `.claude/` structure
- **Improved session-end.sh**: Cross-platform, better error handling
- **Added setup-dual-cli.sh**: Automated setup and verification
- **Created DUAL-CLI-GUIDE.md**: Comprehensive dual CLI documentation
- **Enhanced transcripts**: Better formatting with box-drawing characters
- **Fixed portability**: macOS and Linux compatible `stat` usage
- **Improved timestamps**: Added seconds to prevent collisions
- **Better error handling**: Proper directory validation

## Installation

1. Clone or download this repository
2. Install `jq` if not already installed:
   - **macOS**: `brew install jq`
   - **Linux (Debian/Ubuntu)**: `sudo apt-get install jq`
   - **Linux (RHEL/CentOS)**: `sudo yum install jq`
3. Start Claude Code in this directory
4. Add any project-specific documents to `docs/`
5. Begin coding or ask for a code review!

**Note:** The session transcript export hook requires `jq` to be installed. The script will check for this dependency and provide a helpful error message if it's missing.

## Recent Changes

### Latest Updates
- **Enhanced session-end.sh script**:
  - Added cross-platform compatibility (Linux and macOS)
  - Added dependency check for `jq` with clear error messages
  - Improved error handling with `set -euo pipefail`
  - Added automatic cleanup of temporary files using trap
  - Made debug logging optional via `CLAUDE_HOOK_DEBUG` environment variable
- **Documentation improvements**:
  - Removed references to non-existent files from CLAUDE.md
  - Added LICENSE file (MIT License)
  - Updated README with requirements and debug mode information

### 2025-11-29
- **Forked from lifecoach repository**: Transformed to Python code assistant
- **Rewrote CLAUDE.md**: Complete rewrite for Python expert persona
- **Created python-best-practices.md**: Comprehensive Python reference
- **Updated README.md**: Documentation for code assistant functionality

### From Original Project
- **SessionEnd Hook**: Automatic transcript export functionality
- **Document integration**: Mandatory document reading at session start
- **Session transcripts**: Formatted conversation history

## Privacy

All code, documents, and conversations are treated as confidential development materials.

## Contributing

This is a personal code assistant configuration. Feel free to fork and adapt to your needs.

## License

MIT License - feel free to use and modify for your own projects.
