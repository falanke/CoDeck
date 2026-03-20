#!/bin/bash
# CoDeck - Git Hook Installer
# Sets up a post-commit hook that reminds or auto-triggers codeck updates.
# Usage: bash scripts/setup_git_hook.sh [project_root] [--auto]
#   --auto: attempt to call Claude Code CLI directly (requires claude CLI)

set -euo pipefail

PROJECT_ROOT="${1:-.}"
AUTO_MODE="${2:-}"

HOOK_DIR="$PROJECT_ROOT/.git/hooks"

if [ ! -d "$PROJECT_ROOT/.git" ]; then
  echo "Error: No .git directory found in $PROJECT_ROOT"
  echo "This script requires a git repository."
  exit 1
fi

mkdir -p "$HOOK_DIR"

HOOK_FILE="$HOOK_DIR/post-commit"

# Check if hook already exists
if [ -f "$HOOK_FILE" ]; then
  if grep -q "CoDeck" "$HOOK_FILE"; then
    echo "CoDeck hook already installed. Updating..."
    # Remove old codeck section
    sed -i '/# --- CoDeck Start ---/,/# --- CoDeck End ---/d' "$HOOK_FILE"
  fi
fi

# Append codeck hook
cat >> "$HOOK_FILE" << 'HOOKEOF'
# --- CoDeck Start ---
# Auto-update trigger for CoDeck dashboard
CODECK_JSON="codeck.json"
if [ -f "$CODECK_JSON" ]; then
HOOKEOF

if [ "$AUTO_MODE" = "--auto" ]; then
  cat >> "$HOOK_FILE" << 'HOOKEOF'
  # Attempt automatic regeneration via Claude Code CLI
  if command -v claude &> /dev/null; then
    echo "[CoDeck] Regenerating dashboard..."
    claude -p "update codeck silently" 2>/dev/null &
  else
    echo "[CoDeck] Project changed since last dashboard update."
    echo "[CoDeck] Run: update codeck"
  fi
HOOKEOF
else
  cat >> "$HOOK_FILE" << 'HOOKEOF'
  echo "[CoDeck] Project changed since last dashboard update."
  echo "[CoDeck] Run: update codeck"
HOOKEOF
fi

cat >> "$HOOK_FILE" << 'HOOKEOF'
fi
# --- CoDeck End ---
HOOKEOF

chmod +x "$HOOK_FILE"

echo "Git hook installed at $HOOK_FILE"
if [ "$AUTO_MODE" = "--auto" ]; then
  echo "Mode: automatic (will try to call Claude Code CLI after each commit)"
else
  echo "Mode: reminder (will print a message after each commit)"
fi
