#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/linuxutils"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEAN_INSTALL="${CLEAN_INSTALL:-1}"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "required file not found: $path"
}

require_dir() {
  local path="$1"
  [[ -d "$path" ]] || fail "required directory not found: $path"
}

require_dir "$ROOT_DIR/lib"
require_dir "$ROOT_DIR/commands"
require_file "$ROOT_DIR/bin/linuxutils"
require_file "$ROOT_DIR/bin/lu"

mkdir -p "$BINDIR"

if [[ "$CLEAN_INSTALL" == "1" ]]; then
  log "Running clean install (CLEAN_INSTALL=1): removing previous runtime and binaries"
  rm -rf "$LIBDIR"
  rm -f "$BINDIR/linuxutils" "$BINDIR/lu"
fi

mkdir -p "$LIBDIR"
cp -R "$ROOT_DIR/lib" "$ROOT_DIR/commands" "$LIBDIR/"
install -m 0755 "$ROOT_DIR/bin/linuxutils" "$BINDIR/linuxutils"
install -m 0755 "$ROOT_DIR/bin/lu" "$BINDIR/lu"

log "Installed linuxutils to $BINDIR"
log "Runtime files installed to $LIBDIR"
