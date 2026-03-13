#!/bin/bash

# Install script for CC_session_rename
# This script installs the auto-rename skill to Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/auto-rename"

echo "🚀 Installing CC_session_rename..."

# Create skill directory
mkdir -p "$SKILL_DIR/scripts"

# Copy files
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/"
cp "$SCRIPT_DIR/scripts/rename_session.sh" "$SKILL_DIR/scripts/"

# Set permissions
chmod +x "$SKILL_DIR/scripts/rename_session.sh"

echo "✅ Installation complete!"
echo ""
echo "Usage: In Claude Code, type /auto-rename to rename the current session"
echo ""
echo "Make sure you also have jq installed (required for statusline):"
echo "  brew install jq  # macOS"
