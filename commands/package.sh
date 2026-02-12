#!/usr/bin/env bash

set -euo pipefail

lu_cmd_pkg_install() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg install <packages...>" 10; lu_pkg_install "$@"; }
lu_cmd_pkg_remove() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg remove <packages...>" 10; lu_pkg_remove "$@"; }
lu_cmd_pkg_search() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg search <query>" 10; lu_pkg_search "$*"; }
lu_cmd_pkg_update() { lu_pkg_update_index; }
lu_cmd_pkg_upgrade() { lu_pkg_upgrade_all; }
lu_cmd_pkg_full_upgrade() { lu_pkg_update_index; lu_pkg_upgrade_all; }
lu_cmd_pkg_clean() { case "$LU_PKG_MGR" in apt) lu_run sudo apt-get autoremove -y ;; dnf) lu_run sudo dnf autoremove -y ;; pacman) lu_run sudo pacman -Sc --noconfirm ;; zypper) lu_run sudo zypper clean ;; apk) lu_run sudo apk cache clean ;; esac; }
lu_cmd_pkg_orphans() { case "$LU_PKG_MGR" in apt) lu_run bash -lc "deborphan || true" ;; dnf) lu_run dnf repoquery --unneeded ;; pacman) lu_run bash -lc "pacman -Qdt || true" ;; zypper) lu_run zypper packages --orphaned ;; apk) lu_run apk info -q ;; esac; }
lu_cmd_pkg_list_installed() { case "$LU_PKG_MGR" in apt) lu_run dpkg -l ;; dnf) lu_run dnf list installed ;; pacman) lu_run pacman -Q ;; zypper) lu_run zypper se -i ;; apk) lu_run apk info ;; esac; }
lu_cmd_pkg_info() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg info <package>" 10; case "$LU_PKG_MGR" in apt) lu_run apt-cache show "$1" ;; dnf) lu_run dnf info "$1" ;; pacman) lu_run pacman -Si "$1" ;; zypper) lu_run zypper info "$1" ;; apk) lu_run apk info -a "$1" ;; esac; }
lu_cmd_pkg_reinstall() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg reinstall <package>" 10; case "$LU_PKG_MGR" in apt) lu_run sudo apt-get install --reinstall -y "$@" ;; dnf) lu_run sudo dnf reinstall -y "$@" ;; pacman) lu_run sudo pacman -S --noconfirm "$@" ;; zypper) lu_run sudo zypper install -f -y "$@" ;; apk) lu_run sudo apk fix "$@" ;; esac; }
lu_cmd_pkg_file_owner() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg file-owner <path>" 10; case "$LU_PKG_MGR" in apt) lu_run dpkg -S "$1" ;; dnf) lu_run rpm -qf "$1" ;; pacman) lu_run pacman -Qo "$1" ;; zypper) lu_run rpm -qf "$1" ;; apk) lu_run apk info --who-owns "$1" ;; esac; }
lu_cmd_pkg_history() { case "$LU_PKG_MGR" in apt) lu_run bash -lc "grep ' install ' /var/log/dpkg.log 2>/dev/null | tail -n 100" ;; dnf) lu_run dnf history ;; pacman) lu_run bash -lc "tail -n 200 /var/log/pacman.log" ;; zypper) lu_run zypper history ;; apk) lu_run bash -lc "tail -n 200 /var/log/apk.log" ;; esac; }
lu_cmd_pkg_lock() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg lock <package>" 10; case "$LU_PKG_MGR" in apt) lu_run sudo apt-mark hold "$@" ;; dnf) lu_warn "DNF package locks usually require dnf-plugins-core"; lu_run sudo dnf versionlock add "$@" ;; pacman) lu_warn "Use IgnorePkg in pacman.conf for persistent lock" ;; zypper) lu_run sudo zypper addlock "$@" ;; apk) lu_warn "APK has no direct lock equivalent" ;; esac; }
lu_cmd_pkg_unlock() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils pkg unlock <package>" 10; case "$LU_PKG_MGR" in apt) lu_run sudo apt-mark unhold "$@" ;; dnf) lu_run sudo dnf versionlock delete "$@" ;; pacman) lu_warn "Remove IgnorePkg entry in pacman.conf" ;; zypper) lu_run sudo zypper removelock "$@" ;; apk) lu_warn "APK has no direct unlock equivalent" ;; esac; }

register_command "pkg.install" "Install one or more packages" "linuxutils pkg install htop" lu_cmd_pkg_install 1
register_command "pkg.remove" "Remove one or more packages" "linuxutils pkg remove htop" lu_cmd_pkg_remove 1
register_command "pkg.search" "Search repositories for package names" "linuxutils pkg search nginx" lu_cmd_pkg_search
register_command "pkg.update" "Refresh package indexes" "linuxutils pkg update" lu_cmd_pkg_update 1
register_command "pkg.upgrade" "Upgrade installed packages" "linuxutils pkg upgrade" lu_cmd_pkg_upgrade 1
register_command "pkg.full-upgrade" "Refresh indexes and upgrade packages" "linuxutils pkg full-upgrade" lu_cmd_pkg_full_upgrade 1
register_command "pkg.clean" "Clean package caches and stale deps" "linuxutils pkg clean" lu_cmd_pkg_clean 1
register_command "pkg.orphans" "List orphaned or unneeded packages" "linuxutils pkg orphans" lu_cmd_pkg_orphans
register_command "pkg.list" "List installed packages" "linuxutils pkg list" lu_cmd_pkg_list_installed
register_command "pkg.info" "Show package metadata/details" "linuxutils pkg info curl" lu_cmd_pkg_info
register_command "pkg.reinstall" "Reinstall package(s)" "linuxutils pkg reinstall openssh" lu_cmd_pkg_reinstall 1
register_command "pkg.file-owner" "Find package owning a file" "linuxutils pkg file-owner /usr/bin/curl" lu_cmd_pkg_file_owner
register_command "pkg.history" "Show package transaction history" "linuxutils pkg history" lu_cmd_pkg_history
register_command "pkg.lock" "Pin/lock package version" "linuxutils pkg lock kubelet" lu_cmd_pkg_lock 1
register_command "pkg.unlock" "Unpin/unlock package version" "linuxutils pkg unlock kubelet" lu_cmd_pkg_unlock 1
