#!/usr/bin/env bash

set -euo pipefail

lu_cmd_help_overview() { lu_show_help; }
lu_cmd_help_search() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils help search <query>" 10; lu_search_commands "$*"; }
lu_cmd_help_group() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils help group <group>" 10; lu_list_group "$1"; }
lu_cmd_help_examples() { lu_show_examples; }
lu_cmd_help_commands() { lu_print_all_commands; }
lu_cmd_core_doctor() { lu_doctor; }
lu_cmd_core_update() { lu_self_update; }
lu_cmd_core_version() { echo "linuxutils ${LU_VERSION}"; }

register_command "help.overview" "Show top-level help" "linuxutils help overview" lu_cmd_help_overview
register_command "help.search" "Search commands by keyword" "linuxutils help search docker" lu_cmd_help_search
register_command "help.group" "List commands within a group" "linuxutils help group pkg" lu_cmd_help_group
register_command "help.examples" "Show practical usage examples" "linuxutils help examples" lu_cmd_help_examples
register_command "help.commands" "Print full command registry" "linuxutils help commands" lu_cmd_help_commands
register_command "core.doctor" "Run dependency and environment checks" "linuxutils core doctor" lu_cmd_core_doctor
register_command "core.update" "Self-update from git clone" "linuxutils core update" lu_cmd_core_update 1
register_command "core.version" "Print version" "linuxutils core version" lu_cmd_core_version
