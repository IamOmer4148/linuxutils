#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/your-org/linuxutils.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/linuxutils}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required to install linuxutils" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR" "$BIN_DIR"
if [[ -d "$INSTALL_DIR/.git" ]]; then
  git -C "$INSTALL_DIR" pull --ff-only
else
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

ln -sf "$INSTALL_DIR/bin/linuxutils" "$BIN_DIR/linuxutils"
ln -sf "$INSTALL_DIR/bin/lu" "$BIN_DIR/lu"

echo "Installed linuxutils in $BIN_DIR"
echo "Add to PATH if needed: export PATH=\"$BIN_DIR:\$PATH\""
