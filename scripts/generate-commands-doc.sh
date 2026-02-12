#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT_DIR/docs/COMMANDS.md"

# shellcheck disable=SC1091
source "$ROOT_DIR/lib/common.sh"
# shellcheck disable=SC1091
source "$ROOT_DIR/lib/registry.sh"
lu_load_commands "$ROOT_DIR/commands"

{
  echo "# linuxutils Command Catalog"
  echo
  echo "Generated from the command registry."
  echo
  echo "| Shortcut | Description | Example |"
  echo "|---|---|---|"
  for key in "${LU_KEYS[@]}"; do
    printf '| `%s` | %s | `%s` |\n' "$key" "${LU_DESC[$key]}" "${LU_EXAMPLE[$key]}"
  done | sort
} > "$OUT"

echo "Wrote $OUT"
