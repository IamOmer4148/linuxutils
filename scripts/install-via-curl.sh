#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/IamOmer4148/linuxutils.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/linuxutils}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
CLEAN_INSTALL="${CLEAN_INSTALL:-1}"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

if ! command -v git >/dev/null 2>&1; then
  fail "git is required to install linuxutils"
fi

case "$REPO_URL" in
  https://github.com/*|http://github.com/*)
    ;;
  *)
    fail "REPO_URL must be an http(s) GitHub URL to avoid interactive SSH auth prompts"
    ;;
esac

mkdir -p "$BIN_DIR"

# Disable interactive git prompts so installer never asks for GitHub credentials.
GIT_NO_PROMPT=(env GIT_TERMINAL_PROMPT=0)

if [[ "$CLEAN_INSTALL" == "1" && -d "$INSTALL_DIR" && ! -d "$INSTALL_DIR/.git" ]]; then
  log "Removing non-git install directory for clean reinstall: $INSTALL_DIR"
  rm -rf "$INSTALL_DIR"
fi

if [[ -d "$INSTALL_DIR/.git" ]]; then
  "${GIT_NO_PROMPT[@]}" git -C "$INSTALL_DIR" remote set-url origin "$REPO_URL"
  "${GIT_NO_PROMPT[@]}" git -C "$INSTALL_DIR" fetch --depth=1 origin
  git -C "$INSTALL_DIR" reset --hard origin/HEAD
  if [[ "$CLEAN_INSTALL" == "1" ]]; then
    git -C "$INSTALL_DIR" clean -fdx
  fi
else
  "${GIT_NO_PROMPT[@]}" git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"
fi

install -m 0755 "$INSTALL_DIR/bin/linuxutils" "$BIN_DIR/linuxutils"
install -m 0755 "$INSTALL_DIR/bin/lu" "$BIN_DIR/lu"

log "Installed linuxutils in $BIN_DIR"
log "Add to PATH if needed: export PATH=\"$BIN_DIR:\$PATH\""
