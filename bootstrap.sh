#!/usr/bin/env bash
#
# bootstrap.sh — one-time setup after cloning the raptors pack on a new machine.
#
# It:
#   1. Adds the `raptors` command to your PATH (via a line in your shell rc).
#   2. Installs the /raptors-install slash command at the user level (~/.claude).
#
# Usage:  ./bootstrap.sh
#
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$KIT_DIR/bin/raptors"

chmod +x "$BIN" "$KIT_DIR/install.sh" 2>/dev/null || true

# 1. PATH wiring — pick the user's rc file.
case "${SHELL:-}" in
  *zsh)  RC="$HOME/.zshrc" ;;
  *bash) RC="$HOME/.bashrc" ;;
  *)     RC="$HOME/.profile" ;;
esac

LINE="export PATH=\"$KIT_DIR/bin:\$PATH\"  # raptors"
if [ -f "$RC" ] && grep -qF "# raptors" "$RC"; then
  echo "PATH already wired in $RC (skipping)."
else
  printf '\n%s\n' "$LINE" >> "$RC"
  echo "Added raptors to PATH in $RC."
fi

# 2. Install the global bootstrap slash command.
mkdir -p "$HOME/.claude/commands"
cp "$KIT_DIR/commands/raptors-install.md" "$HOME/.claude/commands/raptors-install.md"
echo "Installed /raptors-install slash command at ~/.claude/commands."

echo ""
echo "Done. Open a new terminal (or 'source $RC'), then:"
echo "  cd <any project> && raptors install ."
echo "or, inside a Claude session in that project, run: /raptors-install"
