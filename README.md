# linuxutils

`linuxutils` is a cross-distro Bash CLI that turns long Linux commands into memorable shortcuts.

- Main command: `linuxutils` (alias: `lu`)
- Pattern: `linuxutils <group> <action> [flags]`
- Supported distros/package managers:
  - Ubuntu / Debian (`apt`)
  - Fedora (`dnf`)
  - Arch / Manjaro (`pacman`)
  - openSUSE (`zypper`)
  - Alpine (`apk`)

## Features

- Bash strict mode and explicit exit codes.
- Auto-detect OS/package manager from `/etc/os-release` + binary fallback.
- Plugin-like command registry (`commands/*.sh`) with 250+ shortcuts.
- Built-in help system with examples and keyword search.
- `linuxutils doctor` for dependency/environment checks.
- `linuxutils update` self-update (when installed from git checkout).
- Confirmation required for destructive actions unless `--yes` is passed.
- Colored output on TTY, plain output for pipes.

## Installation

### 1) Curl installer (safe/readable)

```bash
curl -fsSL https://raw.githubusercontent.com/IamOmer4148/linuxutils/main/scripts/install-via-curl.sh | bash
```

Read the installer first:

```bash
curl -fsSL https://raw.githubusercontent.com/IamOmer4148/linuxutils/main/scripts/install-via-curl.sh
```

### 2) Manual install

```bash
git clone https://github.com/IamOmer4148/linuxutils.git
cd linuxutils
# system-wide (requires sudo)
sudo make install

# user-local (no sudo)
make PREFIX="$HOME/.local" install
export PATH="$HOME/.local/bin:$PATH"
```

### 3) Homebrew on Linux (optional)

Create a custom tap formula or install from local formula if your org maintains one.

## Quick usage

```bash
linuxutils help
linuxutils help search firewall
linuxutils pkg install htop
linuxutils net ports
linuxutils file extract archive.tar.gz /tmp
linuxutils svc restart sshd --yes
linuxutils doctor
```

## Command groups

- `pkg` - package management shortcuts
- `sys` - system info and logs
- `net` - networking, DNS, HTTP checks, firewall helpers
- `dev` - git/container/runtime helpers
- `file` - find/grep/archive/permissions/symlink shortcuts
- `svc` - service management (`systemd`/`openrc` aware)
- `sec` - security hygiene checks
- `backup` - backup and rsync presets
- `qol` - quality-of-life shortcuts
- `web` - basic web server, deploy, and site health checks
- `cloud` - basic cloud/Kubernetes/Terraform/containers shortcuts
- `ai` - basic llama/Ollama/HuggingFace/vLLM helpers
- `help` - searchable help, grouped lists, examples

## Full command list

This project ships with **250+ commands**.

- View all commands in terminal:

```bash
linuxutils help commands
```

- Full generated command catalog (committed): [`docs/COMMANDS.md`](docs/COMMANDS.md)

## Project layout

```text
bin/
  linuxutils
  lu
lib/
  common.sh
  os.sh
  registry.sh
  help.sh
  health.sh
commands/
  *.sh
scripts/
  install-via-curl.sh
  generate-commands-doc.sh
docs/
  COMMANDS.md
tests/
  os_detection.bats
```

## Development

```bash
make lint
make test
make docs
```

## Testing

Bats tests cover distro detection and command routing.

