#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/linuxutils"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

mkdir -p "$BINDIR" "$LIBDIR"

# Keep installs idempotent and avoid stale files from prior versions.
rm -rf "$LIBDIR/lib" "$LIBDIR/commands"
cp -R "$ROOT_DIR/lib" "$ROOT_DIR/commands" "$LIBDIR/"

install -m 0755 "$ROOT_DIR/bin/linuxutils" "$BINDIR/linuxutils"
install -m 0755 "$ROOT_DIR/bin/lu" "$BINDIR/lu"

log "Installed linuxutils to $BINDIR"
log "Runtime files installed to $LIBDIR"
