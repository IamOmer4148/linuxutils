# linuxutils Command Catalog

Generated from the command registry.

| Shortcut | Description | Example |
|---|---|---|
| `ai.comfyui-run` | Run ComfyUI container | `linuxutils ai comfyui-run` |
| `ai.gradio-run` | Run Gradio app from app.py | `linuxutils ai gradio-run` |
| `ai.hf-cache-clear` | Remove HF cache | `linuxutils ai hf-cache-clear` |
| `ai.hf-cache-info` | Show HF cache size | `linuxutils ai hf-cache-info` |
| `ai.hf-download` | Download model/artifact from Hugging Face | `linuxutils ai hf-download meta-llama/Llama-3.2-1B-Instruct` |
| `ai.hf-login` | Login to Hugging Face CLI | `linuxutils ai hf-login` |
| `ai.hf-whoami` | Show Hugging Face logged in user | `linuxutils ai hf-whoami` |
| `ai.jupyter-start` | Start Jupyter Lab | `linuxutils ai jupyter-start` |
| `ai.jupyter-stop` | Stop Jupyter server | `linuxutils ai jupyter-stop` |
| `ai.langchain-quickstart` | Install LangChain stack | `linuxutils ai langchain-quickstart` |
| `ai.llama-cpp-bench` | Run llama.cpp benchmark | `linuxutils ai llama-cpp-bench` |
| `ai.llama-cpp-quantize` | Quantize GGUF model | `linuxutils ai llama-cpp-quantize` |
| `ai.llama-cpp-run` | Run llama.cpp model with prompt | `linuxutils ai llama-cpp-run ./model.gguf hello` |
| `ai.model-card-open` | Print model card URL from HF_MODEL env | `linuxutils ai model-card-open` |
| `ai.ollama-list` | List local Ollama models | `linuxutils ai ollama-list` |
| `ai.ollama-logs` | Tail Ollama service logs | `linuxutils ai ollama-logs` |
| `ai.ollama-ps` | List running Ollama models | `linuxutils ai ollama-ps` |
| `ai.ollama-pull` | Download an Ollama model | `linuxutils ai ollama-pull llama3.1` |
| `ai.ollama-rm` | Remove local Ollama model | `linuxutils ai ollama-rm llama3.1` |
| `ai.ollama-run` | Run prompt against Ollama model | `linuxutils ai ollama-run llama3.1 hello` |
| `ai.ollama-serve` | Run Ollama server foreground | `linuxutils ai ollama-serve` |
| `ai.ollama-start` | Start Ollama service | `linuxutils ai ollama-start` |
| `ai.ollama-stop` | Stop Ollama service | `linuxutils ai ollama-stop` |
| `ai.openai-env-check` | Check OPENAI_API_KEY availability | `linuxutils ai openai-env-check` |
| `ai.openwebui-run` | Run Open WebUI container | `linuxutils ai openwebui-run` |
| `ai.python-gpu-info` | Show GPU info with nvidia-smi | `linuxutils ai python-gpu-info` |
| `ai.python-pip-upgrade` | Upgrade core AI Python packages | `linuxutils ai python-pip-upgrade` |
| `ai.python-torch-cuda` | Check torch CUDA availability | `linuxutils ai python-torch-cuda` |
| `ai.rag-chroma-install` | Install ChromaDB package | `linuxutils ai rag-chroma-install` |
| `ai.rag-faiss-install` | Install FAISS CPU package | `linuxutils ai rag-faiss-install` |
| `ai.sd-webui-run` | Run stable-diffusion-webui container | `linuxutils ai sd-webui-run` |
| `ai.streamlit-run` | Run Streamlit app from app.py | `linuxutils ai streamlit-run` |
| `ai.textgen-webui-run` | Run text-generation-webui container | `linuxutils ai textgen-webui-run` |
| `ai.vllm-serve` | Start vLLM OpenAI-compatible server | `linuxutils ai vllm-serve meta-llama/Llama-3.2-1B-Instruct` |
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
| `cloud.ansible-lint` | Lint ansible playbooks | `linuxutils cloud ansible-lint` |
| `cloud.ansible-ping` | Ping hosts via ansible | `linuxutils cloud ansible-ping ./inventory.ini all` |
| `cloud.ansible-vault-view` | View ansible vault file | `linuxutils cloud ansible-vault-view` |
| `cloud.aws-eks-list` | List EKS clusters | `linuxutils cloud aws-eks-list` |
| `cloud.aws-list-instances` | List EC2 instances | `linuxutils cloud aws-list-instances` |
| `cloud.aws-list-regions` | List AWS regions | `linuxutils cloud aws-list-regions` |
| `cloud.aws-list-s3` | List S3 buckets | `linuxutils cloud aws-list-s3` |
| `cloud.aws-login-hint` | Show AWS CLI login hint | `linuxutils cloud aws-login-hint` |
| `cloud.aws-whoami` | Show AWS caller identity | `linuxutils cloud aws-whoami` |
| `cloud.azure-aks-list` | List AKS clusters | `linuxutils cloud azure-aks-list` |
| `cloud.azure-login-hint` | Show Azure CLI login hint | `linuxutils cloud azure-login-hint` |
| `cloud.azure-storage-list` | List storage accounts | `linuxutils cloud azure-storage-list` |
| `cloud.azure-subscriptions` | List Azure subscriptions | `linuxutils cloud azure-subscriptions` |
| `cloud.azure-vm-list` | List Azure VMs | `linuxutils cloud azure-vm-list` |
| `cloud.compose-down` | Stop services with compose | `linuxutils cloud compose-down` |
| `cloud.compose-logs` | Tail compose logs | `linuxutils cloud compose-logs` |
| `cloud.compose-up` | Start services with compose | `linuxutils cloud compose-up` |
| `cloud.docker-build` | Build Docker image | `linuxutils cloud docker-build` |
| `cloud.docker-login` | Docker login to registry | `linuxutils cloud docker-login` |
| `cloud.docker-push` | Push Docker image | `linuxutils cloud docker-push` |
| `cloud.gcp-compute-list` | List Compute Engine VMs | `linuxutils cloud gcp-compute-list` |
| `cloud.gcp-gke-list` | List GKE clusters | `linuxutils cloud gcp-gke-list` |
| `cloud.gcp-login-hint` | Show gcloud login hint | `linuxutils cloud gcp-login-hint` |
| `cloud.gcp-project` | Show active gcloud project | `linuxutils cloud gcp-project` |
| `cloud.gcp-projects` | List gcloud projects | `linuxutils cloud gcp-projects` |
| `cloud.gcp-storage-list` | List GCS buckets | `linuxutils cloud gcp-storage-list` |
| `cloud.helm-lint` | Lint helm chart | `linuxutils cloud helm-lint` |
| `cloud.helm-list` | List Helm releases | `linuxutils cloud helm-list` |
| `cloud.helm-template` | Render helm templates | `linuxutils cloud helm-template` |
| `cloud.kind-create` | Create KIND cluster | `linuxutils cloud kind-create` |
| `cloud.kind-delete` | Delete KIND cluster | `linuxutils cloud kind-delete` |
| `cloud.kube-apply` | Apply Kubernetes manifests | `linuxutils cloud kube-apply` |
| `cloud.kube-contexts` | List kube contexts | `linuxutils cloud kube-contexts` |
| `cloud.kube-ctx-use` | Switch kubectl context | `linuxutils cloud kube-ctx-use prod-cluster` |
| `cloud.kube-delete` | Delete Kubernetes manifests | `linuxutils cloud kube-delete` |
| `cloud.kube-events` | Show latest Kubernetes events | `linuxutils cloud kube-events` |
| `cloud.kube-get-nodes` | List Kubernetes nodes | `linuxutils cloud kube-get-nodes` |
| `cloud.kube-get-ns` | List Kubernetes namespaces | `linuxutils cloud kube-get-ns` |
| `cloud.kube-get-pods` | List pods in all namespaces | `linuxutils cloud kube-get-pods` |
| `cloud.kube-ns-use` | Set default kubectl namespace | `linuxutils cloud kube-ns-use default` |
| `cloud.kube-top-nodes` | Show node resource usage | `linuxutils cloud kube-top-nodes` |
| `cloud.kube-top-pods` | Show pod resource usage | `linuxutils cloud kube-top-pods` |
| `cloud.minikube-start` | Start minikube | `linuxutils cloud minikube-start` |
| `cloud.minikube-status` | Show minikube status | `linuxutils cloud minikube-status` |
| `cloud.minikube-stop` | Stop minikube | `linuxutils cloud minikube-stop` |
| `cloud.nomad-status` | Show Nomad status | `linuxutils cloud nomad-status` |
| `cloud.packer-build` | Build image with packer | `linuxutils cloud packer-build` |
| `cloud.tf-apply` | Run Terraform apply | `linuxutils cloud tf-apply` |
| `cloud.tf-destroy` | Run Terraform destroy | `linuxutils cloud tf-destroy` |
| `cloud.tf-fmt` | Format Terraform files recursively | `linuxutils cloud tf-fmt` |
| `cloud.tf-init` | Initialize Terraform project | `linuxutils cloud tf-init` |
| `cloud.tf-output` | Show Terraform outputs | `linuxutils cloud tf-output` |
| `cloud.tf-plan` | Run Terraform plan | `linuxutils cloud tf-plan` |
| `cloud.tf-show` | Show Terraform state | `linuxutils cloud tf-show` |
| `cloud.tf-state-list` | List Terraform resources | `linuxutils cloud tf-state-list` |
| `cloud.tf-validate` | Validate Terraform configuration | `linuxutils cloud tf-validate` |
| `cloud.tf-workspaces` | List Terraform workspaces | `linuxutils cloud tf-workspaces` |
| `cloud.vault-status` | Show Vault status | `linuxutils cloud vault-status` |
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
| `web.apache-error-tail` | Tail apache error log | `linuxutils web apache-error-tail` |
| `web.apache-reload` | Reload Apache/httpd service | `linuxutils web apache-reload` |
| `web.apache-tail` | Tail apache access log | `linuxutils web apache-tail` |
| `web.apache-test` | Validate Apache/httpd configuration | `linuxutils web apache-test` |
| `web.bench-ab` | Benchmark endpoint with ApacheBench | `linuxutils web bench-ab http://127.0.0.1:8000/ 1000 50` |
| `web.bench-hey` | Benchmark endpoint with hey | `linuxutils web bench-hey http://127.0.0.1:8000/ 1000 50` |
| `web.busybox-serve` | Serve current directory via busybox httpd | `linuxutils web busybox-serve 8080` |
| `web.cache-bust-touch` | Touch static assets to bust cache | `linuxutils web cache-bust-touch` |
| `web.caddy-serve` | Run Caddy static file server | `linuxutils web caddy-serve . :8080` |
| `web.certbot-renew` | Dry-run Let's Encrypt renewal | `linuxutils web certbot-renew` |
| `web.check-healthz` | Fetch health endpoint | `linuxutils web check-healthz` |
| `web.check-robots` | Fetch robots.txt | `linuxutils web check-robots` |
| `web.check-sitemap` | Fetch sitemap.xml | `linuxutils web check-sitemap` |
| `web.curl-follow` | Fetch URL and follow redirects | `linuxutils web curl-follow https://example.com` |
| `web.curl-head` | Send HEAD request with curl | `linuxutils web curl-head https://example.com` |
| `web.curl-json` | Fetch URL with JSON accept header | `linuxutils web curl-json https://httpbin.org/json` |
| `web.dns-a` | Query A records quickly | `linuxutils web dns-a` |
| `web.dns-aaaa` | Query AAAA records quickly | `linuxutils web dns-aaaa` |
| `web.dns-mx` | Query MX records quickly | `linuxutils web dns-mx` |
| `web.dns-ns` | Query NS records quickly | `linuxutils web dns-ns` |
| `web.go-run` | Run Go web app | `linuxutils web go-run` |
| `web.go-test` | Run Go tests | `linuxutils web go-test` |
| `web.http-code` | Show HTTP status code only | `linuxutils web http-code` |
| `web.http-latency` | Show HTTP total latency | `linuxutils web http-latency` |
| `web.nginx-error-tail` | Tail nginx error log | `linuxutils web nginx-error-tail` |
| `web.nginx-reload` | Reload nginx service | `linuxutils web nginx-reload` |
| `web.nginx-tail` | Tail nginx access log | `linuxutils web nginx-tail` |
| `web.nginx-test` | Validate nginx configuration | `linuxutils web nginx-test` |
| `web.node-build` | Build npm web app | `linuxutils web node-build` |
| `web.node-dev` | Run npm dev server | `linuxutils web node-dev` |
| `web.node-serve` | Serve static files using npx serve | `linuxutils web node-serve 3000` |
| `web.node-start` | Run npm start | `linuxutils web node-start` |
| `web.open-ports-web` | Show open web-related ports | `linuxutils web open-ports-web` |
| `web.php-serve` | Serve current directory via PHP built-in server | `linuxutils web php-serve 127.0.0.1 8000` |
| `web.pm2-list` | List PM2 processes | `linuxutils web pm2-list` |
| `web.pm2-logs` | Tail PM2 logs | `linuxutils web pm2-logs` |
| `web.pm2-save` | Save PM2 process list | `linuxutils web pm2-save` |
| `web.pm2-startup` | Generate PM2 startup script | `linuxutils web pm2-startup` |
| `web.py-serve` | Serve current directory via Python HTTP server | `linuxutils web py-serve 8000` |
| `web.python-django-run` | Run Django dev server | `linuxutils web python-django-run` |
| `web.python-flask-run` | Run Flask app from app.py | `linuxutils web python-flask-run` |
| `web.socket-listen` | List listening sockets for web ports | `linuxutils web socket-listen` |
| `web.systemd-reload` | Reload systemd manager config | `linuxutils web systemd-reload` |
| `web.watch-logs` | Tail system journal for web services | `linuxutils web watch-logs` |
