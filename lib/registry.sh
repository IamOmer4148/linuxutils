#!/usr/bin/env bash

set -euo pipefail

declare -Ag LU_DESC=()
declare -Ag LU_EXAMPLE=()
declare -Ag LU_HANDLER=()
declare -Ag LU_CONFIRM=()
declare -ag LU_KEYS=()

register_command() {
  local key="$1"
  local desc="$2"
  local example="$3"
  local handler="$4"
  local confirm="${5:-0}"
  LU_DESC["$key"]="$desc"
  LU_EXAMPLE["$key"]="$example"
  LU_HANDLER["$key"]="$handler"
  LU_CONFIRM["$key"]="$confirm"
  LU_KEYS+=("$key")
}

lu_load_commands() {
  local dir="$1"
  local file
  for file in "$dir"/*.sh; do
    # shellcheck disable=SC1090
    source "$file"
  done
}

lu_dispatch() {
  local group="$1"
  local action="$2"
  shift 2
  local key="${group}.${action}"

  if [[ -z "${LU_HANDLER[$key]:-}" ]]; then
    lu_die "Unknown command '$group $action'. Try: linuxutils help search $group" 2
  fi

  if [[ "${LU_CONFIRM[$key]:-0}" -eq 1 ]]; then
    lu_confirm "Command '$group $action' may modify your system. Continue?" || {
      lu_warn "Canceled by user"
      exit 3
    }
  fi

  "${LU_HANDLER[$key]}" "$@"
}

lu_search_commands() {
  local query="$1"
  local key
  for key in "${LU_KEYS[@]}"; do
    if [[ "$key ${LU_DESC[$key]} ${LU_EXAMPLE[$key]}" == *"$query"* ]]; then
      printf '%-24s %s\n' "$key" "${LU_DESC[$key]}"
    fi
  done
}

lu_list_group() {
  local group="$1"
  local key
  for key in "${LU_KEYS[@]}"; do
    if [[ "$key" == "$group."* ]]; then
      printf '%-24s %s\n' "$key" "${LU_DESC[$key]}"
    fi
  done
}

lu_print_all_commands() {
  local key
  for key in "${LU_KEYS[@]}"; do
    printf '%-24s %-70s %s\n' "$key" "${LU_DESC[$key]}" "${LU_EXAMPLE[$key]}"
  done | sort
}

lu_pkg_install() {
  case "$LU_PKG_MGR" in
    apt) lu_run sudo apt-get install -y "$@" ;;
    dnf) lu_run sudo dnf install -y "$@" ;;
    pacman) lu_run sudo pacman -S --noconfirm "$@" ;;
    zypper) lu_run sudo zypper install -y "$@" ;;
    apk) lu_run sudo apk add "$@" ;;
  esac
}

lu_pkg_remove() {
  case "$LU_PKG_MGR" in
    apt) lu_run sudo apt-get remove -y "$@" ;;
    dnf) lu_run sudo dnf remove -y "$@" ;;
    pacman) lu_run sudo pacman -Rns --noconfirm "$@" ;;
    zypper) lu_run sudo zypper remove -y "$@" ;;
    apk) lu_run sudo apk del "$@" ;;
  esac
}

lu_pkg_search() {
  case "$LU_PKG_MGR" in
    apt) lu_run apt-cache search "$*" ;;
    dnf) lu_run dnf search "$*" ;;
    pacman) lu_run pacman -Ss "$*" ;;
    zypper) lu_run zypper search "$*" ;;
    apk) lu_run apk search "$*" ;;
  esac
}

lu_pkg_update_index() {
  case "$LU_PKG_MGR" in
    apt) lu_run sudo apt-get update ;;
    dnf) lu_run sudo dnf makecache ;;
    pacman) lu_run sudo pacman -Sy ;;
    zypper) lu_run sudo zypper refresh ;;
    apk) lu_run sudo apk update ;;
  esac
}

lu_pkg_upgrade_all() {
  case "$LU_PKG_MGR" in
    apt) lu_run sudo apt-get upgrade -y ;;
    dnf) lu_run sudo dnf upgrade -y ;;
    pacman) lu_run sudo pacman -Syu --noconfirm ;;
    zypper) lu_run sudo zypper update -y ;;
    apk) lu_run sudo apk upgrade ;;
  esac
}

lu_service_cmd() {
  local action="$1"
  local name="$2"
  if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then
    lu_run sudo systemctl "$action" "$name"
  elif [[ "$LU_INIT_SYSTEM" == "openrc" ]]; then
    case "$action" in
      restart|start|stop|status) lu_run sudo rc-service "$name" "$action" ;;
      enable) lu_run sudo rc-update add "$name" default ;;
      disable) lu_run sudo rc-update del "$name" default ;;
      *) lu_die "Unsupported service action '$action' for OpenRC" 5 ;;
    esac
  else
    lu_die "No supported init system found" 4
  fi
}
