#!/usr/bin/env bash

set -euo pipefail

LU_DISTRO=""
LU_PKG_MGR=""
LU_INIT_SYSTEM=""

lu_detect_os() {
  local os_release_file="${LU_OS_RELEASE_FILE:-/etc/os-release}"
  if [[ -r "$os_release_file" ]]; then
    # shellcheck disable=SC1091
    source "$os_release_file"
  else
    lu_die "/etc/os-release not found; unsupported system" 20
  fi

  local id_lc="${ID,,}"
  local id_like_lc="${ID_LIKE:-}"
  id_like_lc="${id_like_lc,,}"

  case "$id_lc" in
    ubuntu|debian|linuxmint|pop)
      LU_DISTRO="debian"
      LU_PKG_MGR="apt"
      ;;
    fedora|rhel|centos)
      LU_DISTRO="fedora"
      LU_PKG_MGR="dnf"
      ;;
    arch|manjaro|endeavouros)
      LU_DISTRO="arch"
      LU_PKG_MGR="pacman"
      ;;
    opensuse*|sles)
      LU_DISTRO="opensuse"
      LU_PKG_MGR="zypper"
      ;;
    alpine)
      LU_DISTRO="alpine"
      LU_PKG_MGR="apk"
      ;;
    *)
      if [[ "$id_like_lc" == *"debian"* ]]; then
        LU_DISTRO="debian"; LU_PKG_MGR="apt"
      elif [[ "$id_like_lc" == *"fedora"* || "$id_like_lc" == *"rhel"* ]]; then
        LU_DISTRO="fedora"; LU_PKG_MGR="dnf"
      elif [[ "$id_like_lc" == *"arch"* ]]; then
        LU_DISTRO="arch"; LU_PKG_MGR="pacman"
      elif [[ "$id_like_lc" == *"suse"* ]]; then
        LU_DISTRO="opensuse"; LU_PKG_MGR="zypper"
      elif [[ "$id_like_lc" == *"alpine"* ]]; then
        LU_DISTRO="alpine"; LU_PKG_MGR="apk"
      fi
      ;;
  esac

  if [[ -z "$LU_PKG_MGR" ]]; then
    if lu_has_cmd apt-get; then LU_PKG_MGR="apt"; LU_DISTRO="debian"; fi
    if lu_has_cmd dnf; then LU_PKG_MGR="dnf"; LU_DISTRO="fedora"; fi
    if lu_has_cmd pacman; then LU_PKG_MGR="pacman"; LU_DISTRO="arch"; fi
    if lu_has_cmd zypper; then LU_PKG_MGR="zypper"; LU_DISTRO="opensuse"; fi
    if lu_has_cmd apk; then LU_PKG_MGR="apk"; LU_DISTRO="alpine"; fi
  fi

  [[ -n "$LU_PKG_MGR" ]] || lu_die "Could not detect supported package manager" 21

  if lu_has_cmd systemctl; then
    LU_INIT_SYSTEM="systemd"
  elif lu_has_cmd rc-service; then
    LU_INIT_SYSTEM="openrc"
  else
    LU_INIT_SYSTEM="unknown"
  fi
}
