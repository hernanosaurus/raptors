#!/usr/bin/env bash
#
# Thin wrapper around bin/raptors so there is a single source of truth for how
# files get placed (the raptors/ command subdir, the flat bootstrap command, etc).
#
# Usage:
#   ./install.sh [target-project-dir]     # copy into <dir>/.claude (default: cwd)
#   ./install.sh --link [target-dir]      # symlink instead of copy (edits propagate)
#   ./install.sh --global                 # install the bootstrap command into ~/.claude
#
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAPTORS="$KIT_DIR/bin/raptors"

MODE="install"
TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --link)   MODE="link";   shift ;;
    --global) MODE="global"; shift ;;
    *)        TARGET="$1";   shift ;;
  esac
done

case "$MODE" in
  global) exec "$RAPTORS" global ;;
  link)   exec "$RAPTORS" link "${TARGET:-$(pwd)}" ;;
  *)      exec "$RAPTORS" install "${TARGET:-$(pwd)}" ;;
esac
