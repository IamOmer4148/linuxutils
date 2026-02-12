#!/usr/bin/env bash

set -euo pipefail

lu_cmd_dev_git_status() { lu_run git status; }
lu_cmd_dev_git_pull() { lu_run git pull --rebase; }
lu_cmd_dev_git_sync() { lu_run git fetch --all --prune; lu_run git pull --rebase; }
lu_cmd_dev_git_cleanup_branches() { lu_run bash -lc "git branch --merged | grep -v '\*\|main\|master\|develop' | xargs -r git branch -d"; }
lu_cmd_dev_docker_ps() { lu_has_cmd docker || lu_die "docker missing" 11; lu_run docker ps -a; }
lu_cmd_dev_docker_images() { lu_has_cmd docker || lu_die "docker missing" 11; lu_run docker images; }
lu_cmd_dev_docker_prune() { lu_has_cmd docker || lu_die "docker missing" 11; lu_run docker system prune -af; }
lu_cmd_dev_podman_ps() { lu_has_cmd podman || lu_die "podman missing" 11; lu_run podman ps -a; }
lu_cmd_dev_podman_prune() { lu_has_cmd podman || lu_die "podman missing" 11; lu_run podman system prune -af; }
lu_cmd_dev_py_venv() { local dir="${1:-.venv}"; lu_run python3 -m venv "$dir"; }
lu_cmd_dev_py_activate_hint() { local dir="${1:-.venv}"; lu_info "Run: source $dir/bin/activate"; }
lu_cmd_dev_node_init() { lu_has_cmd npm || lu_die "npm missing" 11; lu_run npm init -y; }
lu_cmd_dev_node_install() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils dev node-install <package...>" 10; lu_has_cmd npm || lu_die "npm missing" 11; lu_run npm install "$@"; }
lu_cmd_dev_build_make() { lu_run make "$@"; }
lu_cmd_dev_cc_compile() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils dev cc <source.c> [output]" 10; local out="${2:-a.out}"; lu_run gcc "$1" -o "$out"; }
lu_cmd_dev_rust_check() { lu_has_cmd cargo || lu_die "cargo missing" 11; lu_run cargo check; }

register_command "dev.git-status" "Run git status" "linuxutils dev git-status" lu_cmd_dev_git_status
register_command "dev.git-pull" "Run git pull --rebase" "linuxutils dev git-pull" lu_cmd_dev_git_pull
register_command "dev.git-sync" "Fetch/prune remotes then rebase pull" "linuxutils dev git-sync" lu_cmd_dev_git_sync
register_command "dev.git-cleanup-branches" "Delete merged local branches" "linuxutils dev git-cleanup-branches" lu_cmd_dev_git_cleanup_branches 1
register_command "dev.docker-ps" "List Docker containers" "linuxutils dev docker-ps" lu_cmd_dev_docker_ps
register_command "dev.docker-images" "List Docker images" "linuxutils dev docker-images" lu_cmd_dev_docker_images
register_command "dev.docker-prune" "Prune Docker resources" "linuxutils dev docker-prune" lu_cmd_dev_docker_prune 1
register_command "dev.podman-ps" "List Podman containers" "linuxutils dev podman-ps" lu_cmd_dev_podman_ps
register_command "dev.podman-prune" "Prune Podman resources" "linuxutils dev podman-prune" lu_cmd_dev_podman_prune 1
register_command "dev.py-venv" "Create a Python virtual environment" "linuxutils dev py-venv .venv" lu_cmd_dev_py_venv
register_command "dev.py-activate-hint" "Print venv activation command" "linuxutils dev py-activate-hint .venv" lu_cmd_dev_py_activate_hint
register_command "dev.node-init" "Initialize package.json quickly" "linuxutils dev node-init" lu_cmd_dev_node_init
register_command "dev.node-install" "Install npm package(s)" "linuxutils dev node-install eslint" lu_cmd_dev_node_install
register_command "dev.build" "Run make with optional target" "linuxutils dev build test" lu_cmd_dev_build_make
register_command "dev.cc" "Compile C source with gcc" "linuxutils dev cc main.c main" lu_cmd_dev_cc_compile
register_command "dev.rust-check" "Run cargo check in Rust project" "linuxutils dev rust-check" lu_cmd_dev_rust_check
