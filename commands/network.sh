#!/usr/bin/env bash

set -euo pipefail

lu_cmd_net_ip() { lu_run ip -brief addr; }
lu_cmd_net_routes() { lu_run ip route; }
lu_cmd_net_ports() { lu_run ss -tulpn; }
lu_cmd_net_ping() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net ping <host>" 10; lu_run ping -c 4 "$1"; }
lu_cmd_net_dns_lookup() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net dns-lookup <host>" 10; if lu_has_cmd dig; then lu_run dig +short "$1"; else lu_run getent ahosts "$1"; fi; }
lu_cmd_net_dns_trace() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net dns-trace <host>" 10; lu_has_cmd dig || lu_die "dig not installed" 11; lu_run dig +trace "$1"; }
lu_cmd_net_http_head() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net http-head <url>" 10; lu_run curl -I "$1"; }
lu_cmd_net_http_time() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net http-time <url>" 10; lu_run curl -o /dev/null -s -w 'connect=%{time_connect}s total=%{time_total}s\n' "$1"; }
lu_cmd_net_wifi_scan() { if lu_has_cmd nmcli; then lu_run nmcli dev wifi list; else lu_die "nmcli is required for wifi scan" 11; fi; }
lu_cmd_net_wifi_status() { if lu_has_cmd nmcli; then lu_run nmcli -t -f DEVICE,TYPE,STATE dev status; else lu_warn "nmcli missing"; fi; }
lu_cmd_net_firewall_status() { if lu_has_cmd ufw; then lu_run sudo ufw status; elif lu_has_cmd firewall-cmd; then lu_run sudo firewall-cmd --state; lu_run sudo firewall-cmd --list-all; elif lu_has_cmd iptables; then lu_run sudo iptables -L; else lu_die "No firewall tool found" 11; fi; }
lu_cmd_net_firewall_allow() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net firewall-allow <port/proto>" 10; if lu_has_cmd ufw; then lu_run sudo ufw allow "$1"; elif lu_has_cmd firewall-cmd; then lu_run sudo firewall-cmd --add-port="$1" --permanent; lu_run sudo firewall-cmd --reload; else lu_die "No supported firewall tool" 11; fi; }
lu_cmd_net_firewall_deny() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net firewall-deny <port/proto>" 10; if lu_has_cmd ufw; then lu_run sudo ufw deny "$1"; elif lu_has_cmd firewall-cmd; then lu_run sudo firewall-cmd --remove-port="$1" --permanent; lu_run sudo firewall-cmd --reload; else lu_die "No supported firewall tool" 11; fi; }
lu_cmd_net_public_ip() { lu_run curl -fsSL https://ifconfig.me; }
lu_cmd_net_traceroute() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net traceroute <host>" 10; if lu_has_cmd traceroute; then lu_run traceroute "$1"; else lu_die "traceroute command missing" 11; fi; }
lu_cmd_net_tcpdump() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils net tcpdump <iface>" 10; lu_has_cmd tcpdump || lu_die "tcpdump missing" 11; lu_run sudo tcpdump -i "$1"; }

register_command "net.ip" "Show network interfaces and IPs" "linuxutils net ip" lu_cmd_net_ip
register_command "net.routes" "Show routing table" "linuxutils net routes" lu_cmd_net_routes
register_command "net.ports" "Show listening ports" "linuxutils net ports" lu_cmd_net_ports
register_command "net.ping" "Ping a host" "linuxutils net ping 1.1.1.1" lu_cmd_net_ping
register_command "net.dns-lookup" "Resolve DNS records" "linuxutils net dns-lookup openai.com" lu_cmd_net_dns_lookup
register_command "net.dns-trace" "Trace DNS delegation path" "linuxutils net dns-trace openai.com" lu_cmd_net_dns_trace
register_command "net.http-head" "Fetch HTTP response headers" "linuxutils net http-head https://example.com" lu_cmd_net_http_head
register_command "net.http-time" "Measure HTTP timing metrics" "linuxutils net http-time https://example.com" lu_cmd_net_http_time
register_command "net.wifi-scan" "Scan nearby Wi-Fi networks" "linuxutils net wifi-scan" lu_cmd_net_wifi_scan
register_command "net.wifi-status" "Show Wi-Fi connection status" "linuxutils net wifi-status" lu_cmd_net_wifi_status
register_command "net.firewall-status" "Show firewall status/rules" "linuxutils net firewall-status" lu_cmd_net_firewall_status
register_command "net.firewall-allow" "Allow firewall port" "linuxutils net firewall-allow 22/tcp" lu_cmd_net_firewall_allow 1
register_command "net.firewall-deny" "Deny/remove firewall port" "linuxutils net firewall-deny 22/tcp" lu_cmd_net_firewall_deny 1
register_command "net.public-ip" "Print public IP address" "linuxutils net public-ip" lu_cmd_net_public_ip
register_command "net.traceroute" "Traceroute to remote host" "linuxutils net traceroute openai.com" lu_cmd_net_traceroute
register_command "net.tcpdump" "Capture packets on interface" "linuxutils net tcpdump eth0" lu_cmd_net_tcpdump 1
