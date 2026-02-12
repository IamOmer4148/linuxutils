#!/usr/bin/env bash

set -euo pipefail

lu_cmd_sys_uptime() { lu_run uptime; }
lu_cmd_sys_disk() { lu_run df -h; }
lu_cmd_sys_inodes() { lu_run df -i; }
lu_cmd_sys_memory() { lu_run free -h; }
lu_cmd_sys_cpu() { lu_run lscpu; }
lu_cmd_sys_top() { if lu_has_cmd btop; then lu_run btop; elif lu_has_cmd htop; then lu_run htop; else lu_run top; fi; }
lu_cmd_sys_sensors() { if lu_has_cmd sensors; then lu_run sensors; else lu_die "sensors command missing (lm_sensors)" 11; fi; }
lu_cmd_sys_pci() { lu_run lspci; }
lu_cmd_sys_usb() { lu_run lsusb; }
lu_cmd_sys_kernel() { lu_run uname -a; }
lu_cmd_sys_release() { lu_run bash -lc 'cat /etc/os-release'; }
lu_cmd_sys_mounts() { lu_run mount; }
lu_cmd_sys_processes() { lu_run ps aux; }
lu_cmd_sys_logs() { local n="${1:-100}"; lu_run journalctl -n "$n"; }
lu_cmd_sys_boot_logs() { lu_run journalctl -b; }
lu_cmd_sys_dmesg() { lu_run dmesg; }

register_command "sys.uptime" "Show uptime and load average" "linuxutils sys uptime" lu_cmd_sys_uptime
register_command "sys.disk" "Show disk usage" "linuxutils sys disk" lu_cmd_sys_disk
register_command "sys.inodes" "Show inode usage" "linuxutils sys inodes" lu_cmd_sys_inodes
register_command "sys.memory" "Show memory and swap usage" "linuxutils sys memory" lu_cmd_sys_memory
register_command "sys.cpu" "Show CPU information" "linuxutils sys cpu" lu_cmd_sys_cpu
register_command "sys.top" "Open top-like process monitor" "linuxutils sys top" lu_cmd_sys_top
register_command "sys.sensors" "Show hardware sensors" "linuxutils sys sensors" lu_cmd_sys_sensors
register_command "sys.pci" "List PCI devices" "linuxutils sys pci" lu_cmd_sys_pci
register_command "sys.usb" "List USB devices" "linuxutils sys usb" lu_cmd_sys_usb
register_command "sys.kernel" "Show kernel details" "linuxutils sys kernel" lu_cmd_sys_kernel
register_command "sys.release" "Show distro release info" "linuxutils sys release" lu_cmd_sys_release
register_command "sys.mounts" "Show mounted filesystems" "linuxutils sys mounts" lu_cmd_sys_mounts
register_command "sys.processes" "List running processes" "linuxutils sys processes" lu_cmd_sys_processes
register_command "sys.logs" "Show recent system logs" "linuxutils sys logs 200" lu_cmd_sys_logs
register_command "sys.boot-logs" "Show logs from current boot" "linuxutils sys boot-logs" lu_cmd_sys_boot_logs
register_command "sys.dmesg" "Show kernel ring buffer" "linuxutils sys dmesg" lu_cmd_sys_dmesg
