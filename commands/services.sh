#!/usr/bin/env bash

set -euo pipefail

lu_cmd_svc_status() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc status <service>" 10; lu_service_cmd status "$1"; }
lu_cmd_svc_start() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc start <service>" 10; lu_service_cmd start "$1"; }
lu_cmd_svc_stop() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc stop <service>" 10; lu_service_cmd stop "$1"; }
lu_cmd_svc_restart() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc restart <service>" 10; lu_service_cmd restart "$1"; }
lu_cmd_svc_enable() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc enable <service>" 10; lu_service_cmd enable "$1"; }
lu_cmd_svc_disable() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc disable <service>" 10; lu_service_cmd disable "$1"; }
lu_cmd_svc_list_failed() { if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then lu_run systemctl --failed; else lu_warn "Not supported on OpenRC"; fi; }
lu_cmd_svc_list_running() { if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then lu_run systemctl list-units --type=service --state=running; else lu_run rc-status; fi; }
lu_cmd_svc_logs() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc logs <service> [lines]" 10; local n="${2:-100}"; if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then lu_run journalctl -u "$1" -n "$n"; else lu_warn "OpenRC logs depend on logger; showing dmesg"; lu_run dmesg; fi; }
lu_cmd_svc_reload() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc reload <service>" 10; if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then lu_run sudo systemctl reload "$1"; else lu_warn "Reload not always supported on OpenRC; doing restart"; lu_service_cmd restart "$1"; fi; }
lu_cmd_svc_daemon_reload() { [[ "$LU_INIT_SYSTEM" == "systemd" ]] || lu_die "daemon-reload only for systemd" 5; lu_run sudo systemctl daemon-reload; }
lu_cmd_svc_is_active() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils svc is-active <service>" 10; if [[ "$LU_INIT_SYSTEM" == "systemd" ]]; then lu_run systemctl is-active "$1"; else lu_run rc-service "$1" status; fi; }

register_command "svc.status" "Show service status" "linuxutils svc status sshd" lu_cmd_svc_status
register_command "svc.start" "Start a service" "linuxutils svc start sshd" lu_cmd_svc_start 1
register_command "svc.stop" "Stop a service" "linuxutils svc stop sshd" lu_cmd_svc_stop 1
register_command "svc.restart" "Restart a service" "linuxutils svc restart sshd" lu_cmd_svc_restart 1
register_command "svc.enable" "Enable service on boot" "linuxutils svc enable sshd" lu_cmd_svc_enable 1
register_command "svc.disable" "Disable service on boot" "linuxutils svc disable sshd" lu_cmd_svc_disable 1
register_command "svc.list-failed" "List failed services" "linuxutils svc list-failed" lu_cmd_svc_list_failed
register_command "svc.list-running" "List running services" "linuxutils svc list-running" lu_cmd_svc_list_running
register_command "svc.logs" "Show service logs" "linuxutils svc logs sshd 200" lu_cmd_svc_logs
register_command "svc.reload" "Reload a service" "linuxutils svc reload nginx" lu_cmd_svc_reload 1
register_command "svc.daemon-reload" "Run systemctl daemon-reload" "linuxutils svc daemon-reload" lu_cmd_svc_daemon_reload 1
register_command "svc.is-active" "Check if service is active" "linuxutils svc is-active sshd" lu_cmd_svc_is_active
