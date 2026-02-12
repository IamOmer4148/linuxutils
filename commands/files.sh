#!/usr/bin/env bash

set -euo pipefail

lu_cmd_file_find_name() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file find-name <pattern> [path]" 10; lu_run find "${2:-.}" -iname "*$1*"; }
lu_cmd_file_find_large() { local path="${1:-.}"; local size="${2:-100M}"; lu_run find "$path" -type f -size +"$size"; }
lu_cmd_file_grep() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file grep <pattern> [path]" 10; lu_run rg "$1" "${2:-.}"; }
lu_cmd_file_grep_count() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file grep-count <pattern> [path]" 10; lu_run rg -c "$1" "${2:-.}"; }
lu_cmd_file_tree() { lu_has_cmd tree || lu_die "tree missing" 11; lu_run tree "${1:-.}"; }
lu_cmd_file_permissions() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file permissions <path>" 10; lu_run stat -c '%A %a %n' "$1"; }
lu_cmd_file_chmod_safe() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils file chmod <mode> <path>" 10; lu_run chmod "$1" "$2"; }
lu_cmd_file_chown_safe() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils file chown <owner[:group]> <path>" 10; lu_run sudo chown "$1" "$2"; }
lu_cmd_file_link() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils file link <target> <link_name>" 10; lu_run ln -s "$1" "$2"; }
lu_cmd_file_checksum() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file checksum <path>" 10; lu_run sha256sum "$1"; }
lu_cmd_file_archive() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils file archive <output.tar.gz> <inputs...>" 10; local out="$1"; shift; lu_run tar -czf "$out" "$@"; }
lu_cmd_file_unarchive() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file unarchive <archive> [dest]" 10; local arc="$1"; local dest="${2:-.}"; case "$arc" in *.tar.gz|*.tgz) lu_run tar -xzf "$arc" -C "$dest" ;; *.tar.bz2) lu_run tar -xjf "$arc" -C "$dest" ;; *.tar.xz) lu_run tar -xJf "$arc" -C "$dest" ;; *.zip) lu_run unzip "$arc" -d "$dest" ;; *.gz) lu_run gunzip "$arc" ;; *.bz2) lu_run bunzip2 "$arc" ;; *.xz) lu_run unxz "$arc" ;; *) lu_die "Unsupported archive format: $arc" 12 ;; esac; }
lu_cmd_file_extract_anything() { lu_cmd_file_unarchive "$@"; }
lu_cmd_file_du_top() { local path="${1:-.}"; lu_run bash -lc "du -h '$path' | sort -hr | head -n 20"; }
lu_cmd_file_touch() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils file touch <path>" 10; lu_run touch "$1"; }
lu_cmd_file_serve_here() { local port="${1:-8000}"; lu_run python3 -m http.server "$port"; }

register_command "file.find-name" "Find files by partial name" "linuxutils file find-name ssh ~/.config" lu_cmd_file_find_name
register_command "file.find-large" "Find large files" "linuxutils file find-large /var 500M" lu_cmd_file_find_large
register_command "file.grep" "Search text recursively with ripgrep" "linuxutils file grep TODO src" lu_cmd_file_grep
register_command "file.grep-count" "Count matching lines recursively" "linuxutils file grep-count main src" lu_cmd_file_grep_count
register_command "file.tree" "Display tree view of directory" "linuxutils file tree ." lu_cmd_file_tree
register_command "file.permissions" "Show octal/symbolic permissions" "linuxutils file permissions ~/.ssh" lu_cmd_file_permissions
register_command "file.chmod" "Change file permissions" "linuxutils file chmod 644 test.txt" lu_cmd_file_chmod_safe 1
register_command "file.chown" "Change file owner/group" "linuxutils file chown user:user file" lu_cmd_file_chown_safe 1
register_command "file.link" "Create symbolic link" "linuxutils file link ~/.vimrc ~/.config/nvim/init.vim" lu_cmd_file_link 1
register_command "file.checksum" "Compute sha256 checksum" "linuxutils file checksum backup.tar.gz" lu_cmd_file_checksum
register_command "file.archive" "Create tar.gz archive" "linuxutils file archive out.tar.gz folder" lu_cmd_file_archive
register_command "file.unarchive" "Extract archive by extension" "linuxutils file unarchive out.tar.gz /tmp" lu_cmd_file_unarchive
register_command "file.extract" "Alias for unarchive/extract-anything" "linuxutils file extract file.zip" lu_cmd_file_extract_anything
register_command "file.du-top" "Show top disk consumers" "linuxutils file du-top /var" lu_cmd_file_du_top
register_command "file.touch" "Create an empty file" "linuxutils file touch notes.txt" lu_cmd_file_touch
register_command "file.serve-here" "Serve current folder over HTTP" "linuxutils file serve-here 9000" lu_cmd_file_serve_here
