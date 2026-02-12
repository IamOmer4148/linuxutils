#!/usr/bin/env bash

set -euo pipefail

lu_cmd_qol_weather() { local city="${1:-}"; local target="wttr.in"; [[ -n "$city" ]] && target+="/$city"; lu_run curl -fsSL "$target"; }
lu_cmd_qol_now() { lu_run date; }
lu_cmd_qol_epoch() { lu_run date +%s; }
lu_cmd_qol_uuid() { if lu_has_cmd uuidgen; then lu_run uuidgen; else lu_run cat /proc/sys/kernel/random/uuid; fi; }
lu_cmd_qol_cal() { if lu_has_cmd cal; then lu_run cal; else lu_die "cal missing" 11; fi; }
lu_cmd_qol_myip() { lu_cmd_net_public_ip; }
lu_cmd_qol_localip() { lu_run hostname -I; }
lu_cmd_qol_ports_used() { lu_cmd_net_ports; }
lu_cmd_qol_json_pretty() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils qol json-pretty <file>" 10; if lu_has_cmd jq; then lu_run jq . "$1"; else lu_die "jq missing" 11; fi; }
lu_cmd_qol_randpw() { local len="${1:-24}"; lu_run bash -lc "tr -dc 'A-Za-z0-9!@#$%^&*()_+=' </dev/urandom | head -c '$len'; echo"; }
lu_cmd_qol_path() { tr ':' '\n' <<<"$PATH"; }

register_command "qol.weather" "Fetch weather from wttr.in" "linuxutils qol weather London" lu_cmd_qol_weather
register_command "qol.now" "Show current date and time" "linuxutils qol now" lu_cmd_qol_now
register_command "qol.epoch" "Show current Unix epoch" "linuxutils qol epoch" lu_cmd_qol_epoch
register_command "qol.uuid" "Generate UUID" "linuxutils qol uuid" lu_cmd_qol_uuid
register_command "qol.cal" "Show calendar" "linuxutils qol cal" lu_cmd_qol_cal
register_command "qol.myip" "Show public IP" "linuxutils qol myip" lu_cmd_qol_myip
register_command "qol.localip" "Show local interface IPs" "linuxutils qol localip" lu_cmd_qol_localip
register_command "qol.ports-used" "Show listening ports" "linuxutils qol ports-used" lu_cmd_qol_ports_used
register_command "qol.json-pretty" "Pretty-print JSON file" "linuxutils qol json-pretty package.json" lu_cmd_qol_json_pretty
register_command "qol.randpw" "Generate random password" "linuxutils qol randpw 32" lu_cmd_qol_randpw
register_command "qol.path" "Display PATH entries line by line" "linuxutils qol path" lu_cmd_qol_path
