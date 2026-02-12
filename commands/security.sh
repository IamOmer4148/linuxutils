#!/usr/bin/env bash

set -euo pipefail

lu_cmd_sec_update_all() { lu_pkg_update_index; lu_pkg_upgrade_all; }
lu_cmd_sec_firewall_status() { lu_cmd_net_firewall_status; }
lu_cmd_sec_ssh_config_check() { lu_has_cmd sshd || lu_die "sshd not found" 11; lu_run sshd -T; }
lu_cmd_sec_ssh_root_login() { local cfg="/etc/ssh/sshd_config"; [[ -r "$cfg" ]] || lu_die "$cfg not readable" 11; lu_run bash -lc "grep -Ei '^PermitRootLogin' '$cfg' || echo 'PermitRootLogin not explicitly set'"; }
lu_cmd_sec_ssh_password_auth() { local cfg="/etc/ssh/sshd_config"; [[ -r "$cfg" ]] || lu_die "$cfg not readable" 11; lu_run bash -lc "grep -Ei '^PasswordAuthentication' '$cfg' || echo 'PasswordAuthentication not explicitly set'"; }
lu_cmd_sec_fail2ban_status() { lu_has_cmd fail2ban-client || lu_die "fail2ban-client missing" 11; lu_run sudo fail2ban-client status; }
lu_cmd_sec_users_shell() { lu_run bash -lc "awk -F: '{print \$1,\$7}' /etc/passwd"; }
lu_cmd_sec_sudoers_check() { lu_run sudo visudo -c; }
lu_cmd_sec_world_writable() { local path="${1:-/}"; lu_run sudo find "$path" -xdev -type f -perm -0002; }
lu_cmd_sec_list_suid() { local path="${1:-/}"; lu_run sudo find "$path" -xdev -perm -4000 -type f; }
lu_cmd_sec_audit_logins() { lu_run last -a | head -n 50; }
lu_cmd_sec_check_updates() { lu_cmd_pkg_update; }

register_command "sec.update-all" "Apply all package security updates" "linuxutils sec update-all" lu_cmd_sec_update_all 1
register_command "sec.firewall-status" "Show firewall state" "linuxutils sec firewall-status" lu_cmd_sec_firewall_status
register_command "sec.ssh-config-check" "Validate effective sshd config" "linuxutils sec ssh-config-check" lu_cmd_sec_ssh_config_check
register_command "sec.ssh-root-login" "Check PermitRootLogin setting" "linuxutils sec ssh-root-login" lu_cmd_sec_ssh_root_login
register_command "sec.ssh-password-auth" "Check PasswordAuthentication setting" "linuxutils sec ssh-password-auth" lu_cmd_sec_ssh_password_auth
register_command "sec.fail2ban-status" "Show fail2ban status" "linuxutils sec fail2ban-status" lu_cmd_sec_fail2ban_status
register_command "sec.users-shell" "List users and login shells" "linuxutils sec users-shell" lu_cmd_sec_users_shell
register_command "sec.sudoers-check" "Validate sudoers syntax" "linuxutils sec sudoers-check" lu_cmd_sec_sudoers_check
register_command "sec.world-writable" "Find world-writable files" "linuxutils sec world-writable /etc" lu_cmd_sec_world_writable
register_command "sec.list-suid" "Find SUID binaries" "linuxutils sec list-suid /usr" lu_cmd_sec_list_suid
register_command "sec.audit-logins" "Show recent login history" "linuxutils sec audit-logins" lu_cmd_sec_audit_logins
register_command "sec.check-updates" "Refresh package metadata for updates" "linuxutils sec check-updates" lu_cmd_sec_check_updates
