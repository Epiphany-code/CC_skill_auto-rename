#!/bin/bash
# Auto-rename session by writing custom-title record to session file
# Usage: ./rename_session.sh <session_id> <custom_title>

# Exit if required arguments are missing
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <session_id> <custom_title>"
    exit 1
fi

SESSION_ID="$1"
CUSTOM_TITLE="$2"

# Find the session file across all projects
# Session files are stored in ~/.claude/projects/<project-name>/<session-id>.jsonl
SESSION_FILE=$(find ~/.claude/projects -name "${SESSION_ID}.jsonl" -type f 2>/dev/null | head -1)

if [ -z "$SESSION_FILE" ]; then
    echo "Error: Session file not found for ID: ${SESSION_ID}"
    exit 1
fi

# Remove any existing custom-title records for this session
# Use a temp file for atomic operation
TEMP_FILE=$(mktemp)
if grep -v '"type":"custom-title"' "$SESSION_FILE" > "$TEMP_FILE"; then
    mv "$TEMP_FILE" "$SESSION_FILE"
else
    rm -f "$TEMP_FILE"
fi

# Generate timestamp in ISO format
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Generate a UUID for this record
RECORD_UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')

# Create the custom-title record
# Note: We need to escape special characters in the title for JSON
ESCAPED_TITLE=$(echo "$CUSTOM_TITLE" | sed 's/"/\\"/g')

CUSTOM_TITLE_RECORD="{\"type\":\"custom-title\",\"customTitle\":\"${ESCAPED_TITLE}\",\"sessionId\":\"${SESSION_ID}\",\"timestamp\":\"${TIMESTAMP}\",\"uuid\":\"${RECORD_UUID}\"}"

# Append the record to the session file
echo "$CUSTOM_TITLE_RECORD" >> "$SESSION_FILE"

echo "Session renamed to: ${CUSTOM_TITLE}"
