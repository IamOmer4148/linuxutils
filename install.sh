#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/linuxutils"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$BINDIR" "$LIBDIR"
cp -R "$ROOT_DIR/lib" "$ROOT_DIR/commands" "$LIBDIR/"
cp "$ROOT_DIR/bin/linuxutils" "$BINDIR/linuxutils"
cp "$ROOT_DIR/bin/lu" "$BINDIR/lu"
chmod +x "$BINDIR/linuxutils" "$BINDIR/lu"

echo "Installed linuxutils to $BINDIR"
