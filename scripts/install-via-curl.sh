#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/IamOmer4148/linuxutils.git}"
TARBALL_URL="${TARBALL_URL:-https://github.com/IamOmer4148/linuxutils/archive/refs/heads/main.tar.gz}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/linuxutils}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

mkdir -p "$INSTALL_DIR" "$BIN_DIR"

install_links() {
  ln -sf "$INSTALL_DIR/bin/linuxutils" "$BIN_DIR/linuxutils"
  ln -sf "$INSTALL_DIR/bin/lu" "$BIN_DIR/lu"
}

if command -v git >/dev/null 2>&1; then
  if [[ -d "$INSTALL_DIR/.git" ]]; then
    if GIT_TERMINAL_PROMPT=0 git -C "$INSTALL_DIR" pull --ff-only; then
      install_links
      echo "Updated linuxutils in $BIN_DIR"
      echo "Add to PATH if needed: export PATH=\"$BIN_DIR:\$PATH\""
      exit 0
    fi
    echo "Non-interactive git update failed, falling back to tarball install..." >&2
    rm -rf "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
  fi

  if GIT_TERMINAL_PROMPT=0 git clone "$REPO_URL" "$INSTALL_DIR"; then
    install_links
    echo "Installed linuxutils in $BIN_DIR"
    echo "Add to PATH if needed: export PATH=\"$BIN_DIR:\$PATH\""
    exit 0
  fi

  echo "Non-interactive git clone failed, falling back to tarball install..." >&2
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required when git clone is unavailable" >&2
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
curl -fsSL "$TARBALL_URL" | tar -xz -C "$tmpdir"
cp -R "$tmpdir"/linuxutils-main/* "$INSTALL_DIR"/
install_links

echo "Installed linuxutils in $BIN_DIR (tarball mode)"
echo "Note: tarball mode does not support linuxutils self-update via git."
echo "Add to PATH if needed: export PATH=\"$BIN_DIR:\$PATH\""
