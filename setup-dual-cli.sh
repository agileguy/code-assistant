#!/bin/bash
#
# Setup Script for Dual Claude CLI & Cursor CLI Configuration
#
# This script helps you set up the Python Code Assistant to work with both
# Claude CLI and Cursor CLI tools in the same project.
#

set -euo pipefail

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Python Code Assistant - Dual CLI Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get workspace root
WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Workspace: $WORKSPACE_ROOT"
echo ""

# ============================================================================
# Check Requirements
# ============================================================================

echo "Checking requirements..."

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "❌ ERROR: jq is required but not installed"
    echo "   Install with: sudo apt-get install jq (Linux) or brew install jq (macOS)"
    exit 1
fi
echo "✓ jq found"

# Check for bash
if [[ -z "${BASH_VERSION:-}" ]]; then
    echo "❌ ERROR: This script requires bash"
    exit 1
fi
echo "✓ bash found (version $BASH_VERSION)"

# Check CLI tools
CLAUDE_INSTALLED=false
CURSOR_INSTALLED=false

if command -v claude &> /dev/null; then
    CLAUDE_INSTALLED=true
    echo "✓ Claude CLI found ($(claude --version 2>/dev/null || echo 'version unknown'))"
else
    echo "⚠ Claude CLI not found"
fi

if command -v cursor &> /dev/null; then
    CURSOR_INSTALLED=true
    echo "✓ Cursor CLI found ($(cursor --version 2>/dev/null || echo 'version unknown'))"
else
    echo "⚠ Cursor CLI not found"
fi

if [[ "$CLAUDE_INSTALLED" == false ]] && [[ "$CURSOR_INSTALLED" == false ]]; then
    echo ""
    echo "⚠ WARNING: Neither Claude CLI nor Cursor CLI found"
    echo "   The configuration will be set up, but you'll need to install at least one CLI tool."
    echo ""
fi

# ============================================================================
# Verify Directory Structure
# ============================================================================

echo ""
echo "Verifying directory structure..."

REQUIRED_DIRS=(
    ".claude"
    ".claude/scripts"
    ".cursor"
    ".cursor/scripts"
    "docs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ -d "$WORKSPACE_ROOT/$dir" ]]; then
        echo "✓ $dir exists"
    else
        echo "✗ $dir missing - creating..."
        mkdir -p "$WORKSPACE_ROOT/$dir"
    fi
done

# ============================================================================
# Verify Files
# ============================================================================

echo ""
echo "Verifying configuration files..."

REQUIRED_FILES=(
    ".claude/settings.json:Claude hook configuration"
    ".claude/scripts/session-end.sh:Claude session hook script"
    ".cursor/hooks.json:Cursor hook configuration"
    ".cursor/scripts/session-end.sh:Cursor session hook script"
    ".cursorrules:Cursor rules file"
    "CLAUDE.md:Claude instructions file"
    "docs/python-best-practices.md:Python best practices reference"
)

ALL_PRESENT=true
for file_desc in "${REQUIRED_FILES[@]}"; do
    IFS=':' read -r file desc <<< "$file_desc"
    if [[ -f "$WORKSPACE_ROOT/$file" ]]; then
        echo "✓ $file ($desc)"
    else
        echo "✗ $file missing ($desc)"
        ALL_PRESENT=false
    fi
done

# ============================================================================
# Make Scripts Executable
# ============================================================================

echo ""
echo "Setting script permissions..."

chmod +x "$WORKSPACE_ROOT/.claude/scripts/session-end.sh" 2>/dev/null || true
chmod +x "$WORKSPACE_ROOT/.cursor/scripts/session-end.sh" 2>/dev/null || true

if [[ -x "$WORKSPACE_ROOT/.claude/scripts/session-end.sh" ]]; then
    echo "✓ Claude script is executable"
else
    echo "✗ Failed to make Claude script executable"
fi

if [[ -x "$WORKSPACE_ROOT/.cursor/scripts/session-end.sh" ]]; then
    echo "✓ Cursor script is executable"
else
    echo "✗ Failed to make Cursor script executable"
fi

# ============================================================================
# Test Configuration
# ============================================================================

echo ""
echo "Testing configurations..."

# Test Claude settings.json
if jq empty < "$WORKSPACE_ROOT/.claude/settings.json" 2>/dev/null; then
    echo "✓ Claude settings.json is valid JSON"
else
    echo "✗ Claude settings.json has invalid JSON"
fi

# Test Cursor hooks.json
if jq empty < "$WORKSPACE_ROOT/.cursor/hooks.json" 2>/dev/null; then
    echo "✓ Cursor hooks.json is valid JSON"
else
    echo "✗ Cursor hooks.json has invalid JSON"
fi

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Setup Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Configuration Status:"
echo "  Claude CLI:  $(if [[ $CLAUDE_INSTALLED == true ]]; then echo '✓ Installed'; else echo '✗ Not installed'; fi)"
echo "  Cursor CLI:  $(if [[ $CURSOR_INSTALLED == true ]]; then echo '✓ Installed'; else echo '✗ Not installed'; fi)"
echo ""
echo "Files Status:    $(if [[ $ALL_PRESENT == true ]]; then echo '✓ All present'; else echo '⚠ Some missing'; fi)"
echo ""

# ============================================================================
# Usage Instructions
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Usage Instructions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Using with Claude CLI:"
echo "  cd $WORKSPACE_ROOT"
echo "  claude"
echo ""
echo "Using with Cursor:"
echo "  1. Open Cursor"
echo "  2. Open this folder: $WORKSPACE_ROOT"
echo "  3. Start Cursor Agent (Cmd/Ctrl+Shift+P → 'Cursor: Open Agent')"
echo ""
echo "Using with Cursor CLI:"
echo "  cd $WORKSPACE_ROOT"
echo "  cursor ."
echo ""
echo "Session Transcripts:"
echo "  - Automatically saved to: $WORKSPACE_ROOT/docs/"
echo "  - Format: YYYY-MM-DD-HHMMSS.txt"
echo "  - Works with both Claude and Cursor"
echo ""
echo "Project Documents:"
echo "  - Add project-specific docs to: $WORKSPACE_ROOT/docs/"
echo "  - The assistant will automatically read them at session start"
echo ""

# ============================================================================
# Troubleshooting
# ============================================================================

if [[ "$CLAUDE_INSTALLED" == false ]] || [[ "$CURSOR_INSTALLED" == false ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "   Installation Instructions"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ "$CLAUDE_INSTALLED" == false ]]; then
        echo "Install Claude CLI:"
        echo "  Visit: https://claude.ai/download"
        echo "  Or use: npm install -g @anthropic-ai/claude-cli"
        echo ""
    fi
    
    if [[ "$CURSOR_INSTALLED" == false ]]; then
        echo "Install Cursor:"
        echo "  Visit: https://cursor.sh"
        echo "  Download and install Cursor IDE"
        echo ""
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
