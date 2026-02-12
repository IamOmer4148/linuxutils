#!/usr/bin/env bash

set -euo pipefail

lu_cmd_backup_home() { local dest="${1:-$HOME/backups/home-$(date +%F).tar.gz}"; lu_run tar -czf "$dest" "$HOME"; }
lu_cmd_backup_etc() { local dest="${1:-etc-backup-$(date +%F).tar.gz}"; lu_run sudo tar -czf "$dest" /etc; }
lu_cmd_backup_rsync_push() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup rsync-push <source> <dest>" 10; lu_run rsync -avh --progress "$1" "$2"; }
lu_cmd_backup_rsync_pull() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup rsync-pull <source> <dest>" 10; lu_run rsync -avh --progress "$1" "$2"; }
lu_cmd_backup_rsync_mirror() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup rsync-mirror <source> <dest>" 10; lu_run rsync -avh --delete "$1" "$2"; }
lu_cmd_backup_rsync_dryrun() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup rsync-dryrun <source> <dest>" 10; lu_run rsync -avh --delete --dry-run "$1" "$2"; }
lu_cmd_backup_snapshot() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup snapshot <source> <dest-dir>" 10; local stamp; stamp="$(date +%F-%H%M%S)"; lu_run rsync -a "$1" "$2/snapshot-$stamp"; }
lu_cmd_backup_verify_checksum() { [[ $# -ge 2 ]] || lu_die "Usage: linuxutils backup verify-checksum <file> <sha256>" 10; echo "$2  $1" | sha256sum -c -; }
lu_cmd_backup_size_report() { local path="${1:-.}"; lu_run du -sh "$path"; }
lu_cmd_backup_list_recent() { local path="${1:-$HOME/backups}"; lu_run bash -lc "ls -lt '$path' | head -n 20"; }

register_command "backup.home" "Backup home directory to tar.gz" "linuxutils backup home ~/backups/home.tar.gz" lu_cmd_backup_home 1
register_command "backup.etc" "Backup /etc to tar.gz" "linuxutils backup etc ./etc.tar.gz" lu_cmd_backup_etc 1
register_command "backup.rsync-push" "Rsync source to destination" "linuxutils backup rsync-push ./data user@host:/backup" lu_cmd_backup_rsync_push
register_command "backup.rsync-pull" "Rsync remote source to local" "linuxutils backup rsync-pull user@host:/backup ./restore" lu_cmd_backup_rsync_pull
register_command "backup.rsync-mirror" "Mirror source to destination with delete" "linuxutils backup rsync-mirror ./src /mnt/backup/src" lu_cmd_backup_rsync_mirror 1
register_command "backup.rsync-dryrun" "Preview mirror changes" "linuxutils backup rsync-dryrun ./src /mnt/backup/src" lu_cmd_backup_rsync_dryrun
register_command "backup.snapshot" "Create timestamped rsync snapshot" "linuxutils backup snapshot ./src /mnt/snaps" lu_cmd_backup_snapshot
register_command "backup.verify-checksum" "Verify file against sha256 hash" "linuxutils backup verify-checksum archive.tar.gz abc123" lu_cmd_backup_verify_checksum
register_command "backup.size-report" "Show total size of path" "linuxutils backup size-report /var/backups" lu_cmd_backup_size_report
register_command "backup.list-recent" "List latest backup files" "linuxutils backup list-recent ~/backups" lu_cmd_backup_list_recent
