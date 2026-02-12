#!/usr/bin/env bash

set -euo pipefail

lu_show_help() {
  cat <<'EOT'
linuxutils - unified Linux shortcuts CLI

Usage:
  linuxutils <group> <action> [args] [--yes]
  linuxutils help [overview|search|group|examples|commands]
  linuxutils doctor
  linuxutils update

Aliases:
  lu (same command)

Examples:
  linuxutils pkg install htop
  linuxutils net ports
  linuxutils file extract archive.tar.gz /tmp
  linuxutils help search firewall

Groups:
  pkg, sys, net, dev, file, svc, sec, backup, qol, help, core
EOT
}

lu_show_examples() {
  cat <<'EOT'
Common examples:
  linuxutils pkg full-upgrade --yes
  linuxutils sys logs 200
  linuxutils net http-time https://example.com
  linuxutils dev py-venv .venv
  linuxutils file find-large /var 500M
  linuxutils svc restart sshd --yes
  linuxutils sec ssh-root-login
  linuxutils backup rsync-dryrun ./src /mnt/backup/src
  linuxutils qol weather Tokyo
EOT
}
