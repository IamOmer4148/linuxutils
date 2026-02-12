#!/usr/bin/env bash

set -euo pipefail

lu_doctor() {
  local failures=0
  lu_info "Running linuxutils doctor"
  lu_info "Detected distro: $LU_DISTRO"
  lu_info "Detected package manager: $LU_PKG_MGR"
  lu_info "Init system: $LU_INIT_SYSTEM"

  if [[ $EUID -ne 0 ]]; then
    lu_warn "Not running as root (normal for most commands)."
  else
    lu_info "Running as root."
  fi

  local deps=(bash sudo curl tar find)
  local dep
  for dep in "${deps[@]}"; do
    if lu_has_cmd "$dep"; then
      lu_success "Found dependency: $dep"
    else
      lu_error "Missing dependency: $dep"
      failures=$((failures + 1))
    fi
  done

  if [[ -d "$LU_ROOT/.git" ]]; then
    lu_success "Git repository detected (self-update available)."
  else
    lu_warn "Not in a git checkout; self-update may be unavailable."
  fi

  if [[ $failures -gt 0 ]]; then
    lu_die "Doctor found $failures issue(s)" 30
  fi

  lu_success "Doctor checks completed"
}

lu_self_update() {
  if [[ ! -d "$LU_ROOT/.git" ]]; then
    lu_die "Self-update requires git checkout install" 31
  fi

  lu_has_cmd git || lu_die "git is required for self-update" 31
  lu_info "Updating linuxutils from current branch"
  lu_run git -C "$LU_ROOT" pull --ff-only
  lu_success "Update complete"
}
