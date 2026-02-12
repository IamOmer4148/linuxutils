# linuxutils Command Catalog

Generated from the command registry.

| Shortcut | Description | Example |
|---|---|---|
| `backup.etc` | Backup /etc to tar.gz | `linuxutils backup etc ./etc.tar.gz` |
| `backup.home` | Backup home directory to tar.gz | `linuxutils backup home ~/backups/home.tar.gz` |
| `backup.list-recent` | List latest backup files | `linuxutils backup list-recent ~/backups` |
| `backup.rsync-dryrun` | Preview mirror changes | `linuxutils backup rsync-dryrun ./src /mnt/backup/src` |
| `backup.rsync-mirror` | Mirror source to destination with delete | `linuxutils backup rsync-mirror ./src /mnt/backup/src` |
| `backup.rsync-pull` | Rsync remote source to local | `linuxutils backup rsync-pull user@host:/backup ./restore` |
| `backup.rsync-push` | Rsync source to destination | `linuxutils backup rsync-push ./data user@host:/backup` |
| `backup.size-report` | Show total size of path | `linuxutils backup size-report /var/backups` |
| `backup.snapshot` | Create timestamped rsync snapshot | `linuxutils backup snapshot ./src /mnt/snaps` |
| `backup.verify-checksum` | Verify file against sha256 hash | `linuxutils backup verify-checksum archive.tar.gz abc123` |
| `core.doctor` | Run dependency and environment checks | `linuxutils core doctor` |
| `core.update` | Self-update from git clone | `linuxutils core update` |
| `core.version` | Print version | `linuxutils core version` |
| `dev.build` | Run make with optional target | `linuxutils dev build test` |
| `dev.cc` | Compile C source with gcc | `linuxutils dev cc main.c main` |
| `dev.docker-images` | List Docker images | `linuxutils dev docker-images` |
| `dev.docker-prune` | Prune Docker resources | `linuxutils dev docker-prune` |
| `dev.docker-ps` | List Docker containers | `linuxutils dev docker-ps` |
| `dev.git-cleanup-branches` | Delete merged local branches | `linuxutils dev git-cleanup-branches` |
| `dev.git-pull` | Run git pull --rebase | `linuxutils dev git-pull` |
| `dev.git-status` | Run git status | `linuxutils dev git-status` |
| `dev.git-sync` | Fetch/prune remotes then rebase pull | `linuxutils dev git-sync` |
| `dev.node-init` | Initialize package.json quickly | `linuxutils dev node-init` |
| `dev.node-install` | Install npm package(s) | `linuxutils dev node-install eslint` |
| `dev.podman-prune` | Prune Podman resources | `linuxutils dev podman-prune` |
| `dev.podman-ps` | List Podman containers | `linuxutils dev podman-ps` |
| `dev.py-activate-hint` | Print venv activation command | `linuxutils dev py-activate-hint .venv` |
| `dev.py-venv` | Create a Python virtual environment | `linuxutils dev py-venv .venv` |
| `dev.rust-check` | Run cargo check in Rust project | `linuxutils dev rust-check` |
| `file.archive` | Create tar.gz archive | `linuxutils file archive out.tar.gz folder` |
| `file.checksum` | Compute sha256 checksum | `linuxutils file checksum backup.tar.gz` |
| `file.chmod` | Change file permissions | `linuxutils file chmod 644 test.txt` |
| `file.chown` | Change file owner/group | `linuxutils file chown user:user file` |
| `file.du-top` | Show top disk consumers | `linuxutils file du-top /var` |
| `file.extract` | Alias for unarchive/extract-anything | `linuxutils file extract file.zip` |
| `file.find-large` | Find large files | `linuxutils file find-large /var 500M` |
| `file.find-name` | Find files by partial name | `linuxutils file find-name ssh ~/.config` |
| `file.grep-count` | Count matching lines recursively | `linuxutils file grep-count main src` |
| `file.grep` | Search text recursively with ripgrep | `linuxutils file grep TODO src` |
| `file.link` | Create symbolic link | `linuxutils file link ~/.vimrc ~/.config/nvim/init.vim` |
| `file.permissions` | Show octal/symbolic permissions | `linuxutils file permissions ~/.ssh` |
| `file.serve-here` | Serve current folder over HTTP | `linuxutils file serve-here 9000` |
| `file.touch` | Create an empty file | `linuxutils file touch notes.txt` |
| `file.tree` | Display tree view of directory | `linuxutils file tree .` |
| `file.unarchive` | Extract archive by extension | `linuxutils file unarchive out.tar.gz /tmp` |
| `help.commands` | Print full command registry | `linuxutils help commands` |
| `help.examples` | Show practical usage examples | `linuxutils help examples` |
| `help.group` | List commands within a group | `linuxutils help group pkg` |
| `help.overview` | Show top-level help | `linuxutils help overview` |
| `help.search` | Search commands by keyword | `linuxutils help search docker` |
| `net.dns-lookup` | Resolve DNS records | `linuxutils net dns-lookup openai.com` |
| `net.dns-trace` | Trace DNS delegation path | `linuxutils net dns-trace openai.com` |
| `net.firewall-allow` | Allow firewall port | `linuxutils net firewall-allow 22/tcp` |
| `net.firewall-deny` | Deny/remove firewall port | `linuxutils net firewall-deny 22/tcp` |
| `net.firewall-status` | Show firewall status/rules | `linuxutils net firewall-status` |
| `net.http-head` | Fetch HTTP response headers | `linuxutils net http-head https://example.com` |
| `net.http-time` | Measure HTTP timing metrics | `linuxutils net http-time https://example.com` |
| `net.ip` | Show network interfaces and IPs | `linuxutils net ip` |
| `net.ping` | Ping a host | `linuxutils net ping 1.1.1.1` |
| `net.ports` | Show listening ports | `linuxutils net ports` |
| `net.public-ip` | Print public IP address | `linuxutils net public-ip` |
| `net.routes` | Show routing table | `linuxutils net routes` |
| `net.tcpdump` | Capture packets on interface | `linuxutils net tcpdump eth0` |
| `net.traceroute` | Traceroute to remote host | `linuxutils net traceroute openai.com` |
| `net.wifi-scan` | Scan nearby Wi-Fi networks | `linuxutils net wifi-scan` |
| `net.wifi-status` | Show Wi-Fi connection status | `linuxutils net wifi-status` |
| `pkg.clean` | Clean package caches and stale deps | `linuxutils pkg clean` |
| `pkg.file-owner` | Find package owning a file | `linuxutils pkg file-owner /usr/bin/curl` |
| `pkg.full-upgrade` | Refresh indexes and upgrade packages | `linuxutils pkg full-upgrade` |
| `pkg.history` | Show package transaction history | `linuxutils pkg history` |
| `pkg.info` | Show package metadata/details | `linuxutils pkg info curl` |
| `pkg.install` | Install one or more packages | `linuxutils pkg install htop` |
| `pkg.list` | List installed packages | `linuxutils pkg list` |
| `pkg.lock` | Pin/lock package version | `linuxutils pkg lock kubelet` |
| `pkg.orphans` | List orphaned or unneeded packages | `linuxutils pkg orphans` |
| `pkg.reinstall` | Reinstall package(s) | `linuxutils pkg reinstall openssh` |
| `pkg.remove` | Remove one or more packages | `linuxutils pkg remove htop` |
| `pkg.search` | Search repositories for package names | `linuxutils pkg search nginx` |
| `pkg.unlock` | Unpin/unlock package version | `linuxutils pkg unlock kubelet` |
| `pkg.update` | Refresh package indexes | `linuxutils pkg update` |
| `pkg.upgrade` | Upgrade installed packages | `linuxutils pkg upgrade` |
| `qol.cal` | Show calendar | `linuxutils qol cal` |
| `qol.epoch` | Show current Unix epoch | `linuxutils qol epoch` |
| `qol.json-pretty` | Pretty-print JSON file | `linuxutils qol json-pretty package.json` |
| `qol.localip` | Show local interface IPs | `linuxutils qol localip` |
| `qol.myip` | Show public IP | `linuxutils qol myip` |
| `qol.now` | Show current date and time | `linuxutils qol now` |
| `qol.path` | Display PATH entries line by line | `linuxutils qol path` |
| `qol.ports-used` | Show listening ports | `linuxutils qol ports-used` |
| `qol.randpw` | Generate random password | `linuxutils qol randpw 32` |
| `qol.uuid` | Generate UUID | `linuxutils qol uuid` |
| `qol.weather` | Fetch weather from wttr.in | `linuxutils qol weather London` |
| `sec.audit-logins` | Show recent login history | `linuxutils sec audit-logins` |
| `sec.check-updates` | Refresh package metadata for updates | `linuxutils sec check-updates` |
| `sec.fail2ban-status` | Show fail2ban status | `linuxutils sec fail2ban-status` |
| `sec.firewall-status` | Show firewall state | `linuxutils sec firewall-status` |
| `sec.list-suid` | Find SUID binaries | `linuxutils sec list-suid /usr` |
| `sec.ssh-config-check` | Validate effective sshd config | `linuxutils sec ssh-config-check` |
| `sec.ssh-password-auth` | Check PasswordAuthentication setting | `linuxutils sec ssh-password-auth` |
| `sec.ssh-root-login` | Check PermitRootLogin setting | `linuxutils sec ssh-root-login` |
| `sec.sudoers-check` | Validate sudoers syntax | `linuxutils sec sudoers-check` |
| `sec.update-all` | Apply all package security updates | `linuxutils sec update-all` |
| `sec.users-shell` | List users and login shells | `linuxutils sec users-shell` |
| `sec.world-writable` | Find world-writable files | `linuxutils sec world-writable /etc` |
| `svc.daemon-reload` | Run systemctl daemon-reload | `linuxutils svc daemon-reload` |
| `svc.disable` | Disable service on boot | `linuxutils svc disable sshd` |
| `svc.enable` | Enable service on boot | `linuxutils svc enable sshd` |
| `svc.is-active` | Check if service is active | `linuxutils svc is-active sshd` |
| `svc.list-failed` | List failed services | `linuxutils svc list-failed` |
| `svc.list-running` | List running services | `linuxutils svc list-running` |
| `svc.logs` | Show service logs | `linuxutils svc logs sshd 200` |
| `svc.reload` | Reload a service | `linuxutils svc reload nginx` |
| `svc.restart` | Restart a service | `linuxutils svc restart sshd` |
| `svc.start` | Start a service | `linuxutils svc start sshd` |
| `svc.status` | Show service status | `linuxutils svc status sshd` |
| `svc.stop` | Stop a service | `linuxutils svc stop sshd` |
| `sys.boot-logs` | Show logs from current boot | `linuxutils sys boot-logs` |
| `sys.cpu` | Show CPU information | `linuxutils sys cpu` |
| `sys.disk` | Show disk usage | `linuxutils sys disk` |
| `sys.dmesg` | Show kernel ring buffer | `linuxutils sys dmesg` |
| `sys.inodes` | Show inode usage | `linuxutils sys inodes` |
| `sys.kernel` | Show kernel details | `linuxutils sys kernel` |
| `sys.logs` | Show recent system logs | `linuxutils sys logs 200` |
| `sys.memory` | Show memory and swap usage | `linuxutils sys memory` |
| `sys.mounts` | Show mounted filesystems | `linuxutils sys mounts` |
| `sys.pci` | List PCI devices | `linuxutils sys pci` |
| `sys.processes` | List running processes | `linuxutils sys processes` |
| `sys.release` | Show distro release info | `linuxutils sys release` |
| `sys.sensors` | Show hardware sensors | `linuxutils sys sensors` |
| `sys.top` | Open top-like process monitor | `linuxutils sys top` |
| `sys.uptime` | Show uptime and load average | `linuxutils sys uptime` |
| `sys.usb` | List USB devices | `linuxutils sys usb` |
