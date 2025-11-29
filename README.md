# Code Assistant - Python Expert

This is a custom Claude Code configuration that implements a Python coding assistant persona. The assistant is an expert software engineer specializing in Python development, code review, and best practices.

## Overview

The Code Assistant helps developers write better Python code through thoughtful guidance, practical examples, and comprehensive code reviews. It combines deep Python expertise with clear communication to improve code quality and developer skills.

## How It Works

The assistant's behavior and expertise are defined in `CLAUDE.md`, which serves as the primary instruction set for Claude Code when operating in this directory.

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

## Usage

Simply start Claude Code in this directory and begin your conversation. The assistant will:

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

Session transcripts are **automatically exported** when your Claude Code session ends.

**How it works:**
- When any session ends (via exit, logout, or natural completion), a SessionEnd hook automatically captures the full conversation
- Transcripts are formatted in a human-readable format matching the Claude Code UI
- Files are saved to `docs/{timestamp}.txt` where timestamp format is `YYYY-MM-DD-HHMM`
- Example filename: `docs/2025-11-28-2145.txt`

**What's included:**
- Complete conversation history
- Code review discussions
- Implementation decisions
- Questions and answers
- Code changes and rationale

**Configuration:**
- Hook configuration: `.claude/settings.json`
- The SessionEnd hook runs automatically on every session end
- No manual export needed - just exit normally

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

1. Clone or download this repository
2. Start Claude Code in this directory
3. Add any project-specific documents to `docs/`
4. Begin coding or ask for a code review!

## Recent Changes

### 2025-11-29
- **Forked from lifecoach repository**: Transformed from life coaching assistant to Python code assistant
- **Rewrote CLAUDE.md**: Complete rewrite for Python expert persona
- **Created python-best-practices.md**: Comprehensive Python best practices reference
- **Updated README.md**: Documentation for code assistant functionality
- **Removed coaching materials**: Removed character-background.md, coaching-principles.md, scottish-slang.md

### From Original Project
- **SessionEnd Hook**: Automatic transcript export functionality
- **Document integration**: Mandatory document reading at session start
- **Session transcripts**: Formatted conversation history in `docs/{timestamp}.txt`

## Privacy

All code, documents, and conversations are treated as confidential development materials.

## Contributing

This is a personal code assistant configuration. Feel free to fork and adapt to your needs.

## License

MIT License - feel free to use and modify for your own projects.
