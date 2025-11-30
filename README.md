# Code Assistant - Python Expert

A custom Claude Code configuration that implements a Python coding assistant persona. The assistant is an expert software engineer specializing in Python development, code review, and best practices.

## Overview

The Code Assistant helps developers write better Python code through thoughtful guidance, practical examples, and comprehensive code reviews. It combines deep Python expertise with clear communication to improve code quality and developer skills.

### Key Features

- **Expert Python knowledge**: Deep understanding of Python 3.x, standard library, frameworks, and ecosystem
- **Code review focus**: Systematic approach to reviewing code for correctness, style, security, and performance
- **Best practices guidance**: Advocates for PEP 8, type hints, modern Python features, and idiomatic code
- **Practical examples**: Provides working code examples and explains tradeoffs
- **Document integration**: Automatically reads and incorporates user-provided materials from the `docs/` folder
- **Session transcripts**: Automatically exports conversation history for reference

## How It Works

The assistant's behavior and expertise are defined in `CLAUDE.md`.

## The docs/ Folder

Place any documents in the `docs/` folder that you want the assistant to review and incorporate into sessions:

- Project requirements or specifications
- Architecture documentation
- Code style guides specific to your project
- Research materials or API documentation
- Design notes or technical decisions

**The assistant will automatically read all documents in this folder at the start of each session.**

## Quick Start

```bash
cd /path/to/this/project
claude
```

## Usage

Start Claude Code in this directory and begin your conversation. The assistant will:

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

## Session Transcripts

Session transcripts are **automatically exported** when your session ends.

**How it works:**
- When any session ends, a SessionEnd hook automatically captures the full conversation
- Transcripts are formatted in a human-readable format
- Files are saved to `docs/{timestamp}.txt`

**Configuration:**
- Hook: `.claude/settings.json` → `.claude/scripts/session-end.sh`
- Cross-platform support (macOS & Linux)

**Requirements:**
- `jq` must be installed for JSON processing

## Python Focus Areas

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

## Project Structure

```
code-assistant/
├── .claude/                      # Claude CLI configuration
│   ├── settings.json            # Hook settings
│   └── scripts/
│       └── session-end.sh       # Transcript export script
│
├── CLAUDE.md                     # Claude assistant instructions
│
├── docs/                         # Documentation & transcripts
│   ├── python-best-practices.md # Python reference
│   └── [auto-generated].txt    # Session transcripts
│
└── README.md                    # This file
```

## Installation

1. Clone or download this repository
2. Install `jq` if not already installed:
   - **macOS**: `brew install jq`
   - **Linux (Debian/Ubuntu)**: `sudo apt-get install jq`
   - **Linux (RHEL/CentOS)**: `sudo yum install jq`
3. Start Claude Code in this directory
4. Add any project-specific documents to `docs/`
5. Begin coding or ask for a code review!

## License

MIT License - feel free to use and modify for your own projects.
