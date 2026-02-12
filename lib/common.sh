#!/usr/bin/env bash

set -euo pipefail

if [[ -t 1 ]]; then
  LU_COLOR=1
else
  LU_COLOR=0
fi

lu_color() {
  local code="$1"
  local text="$2"
  if [[ "$LU_COLOR" -eq 1 ]]; then
    printf '\033[%sm%s\033[0m\n' "$code" "$text"
  else
    printf '%s\n' "$text"
  fi
}

lu_info() { lu_color "1;34" "[INFO] $*"; }
lu_warn() { lu_color "1;33" "[WARN] $*"; }
lu_error() { lu_color "1;31" "[ERROR] $*" >&2; }
lu_success() { lu_color "1;32" "[OK] $*"; }

lu_die() {
  lu_error "$1"
  exit "${2:-1}"
}

lu_has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

lu_confirm() {
  local prompt="$1"
  if [[ "${LU_YES:-0}" -eq 1 ]]; then
    return 0
  fi
  read -r -p "$prompt [y/N]: " response
  [[ "$response" =~ ^[Yy]$ ]]
}

lu_run() {
  local cmd="$1"
  shift
  lu_info "Running: $cmd $*"
  "$cmd" "$@"
}

lu_join_by() {
  local delimiter="$1"
  shift
  local first=1
  for element in "$@"; do
    if [[ $first -eq 1 ]]; then
      printf '%s' "$element"
      first=0
    else
      printf '%s%s' "$delimiter" "$element"
    fi
  done
}
