#!/usr/bin/env bash
#
# Release the raptors (agents + commands) into a project's .claude/ dir.
#
# Usage:
#   ./install.sh [target-project-dir]     # copy into <dir>/.claude (default: cwd)
#   ./install.sh --link [target-dir]      # symlink instead of copy (edits propagate)
#   ./install.sh --global                 # install into ~/.claude (all projects)
#
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="copy"
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --link) MODE="link"; shift ;;
    --global) TARGET="$HOME"; shift ;;
    *) TARGET="$1"; shift ;;
  esac
done

TARGET="${TARGET:-$(pwd)}"
DEST="$TARGET/.claude"

mkdir -p "$DEST/agents" "$DEST/commands"

install_dir() {
  local src="$1" dst="$2"
  for f in "$src"/*.md; do
    [ -e "$f" ] || continue
    local base; base="$(basename "$f")"
    if [ "$MODE" = "link" ]; then
      ln -sf "$f" "$dst/$base"
    else
      cp "$f" "$dst/$base"
    fi
  done
}

install_dir "$KIT_DIR/agents" "$DEST/agents"
install_dir "$KIT_DIR/commands" "$DEST/commands"

echo "Released the raptors ($MODE) into: $DEST"
echo "  agents:   $(ls "$DEST/agents" | wc -l | tr -d ' ') files"
echo "  commands: $(ls "$DEST/commands" | wc -l | tr -d ' ') files"

if [ ! -f "$TARGET/CLAUDE.md" ] && [ "$TARGET" != "$HOME" ]; then
  echo ""
  echo "No CLAUDE.md found in $TARGET."
  echo "Copy the template to give the pack project context:"
  echo "  cp \"$KIT_DIR/templates/CLAUDE.md.template\" \"$TARGET/CLAUDE.md\""
fi
