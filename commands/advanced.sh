#!/usr/bin/env bash

set -euo pipefail

lu_adv_require_cmd() {
  local cmd="$1"
  lu_has_cmd "$cmd" || lu_die "$cmd is required for this command" 11
}

lu_adv_register_shell() {
  local key="$1"
  local desc="$2"
  local example="$3"
  local shell_cmd="$4"
  local need_cmd="${5:-}"
  local confirm="${6:-0}"
  local fn="lu_cmd_${key//./_}"
  fn="${fn//-/_}"

  local qcmd qneed
  printf -v qcmd '%q' "$shell_cmd"
  printf -v qneed '%q' "$need_cmd"
  eval "${fn}() { local _cmd=${qcmd}; local _need=${qneed}; [[ -n \"\$_need\" ]] && lu_adv_require_cmd \"\$_need\"; lu_run bash -lc \"\$_cmd\"; }"

  register_command "$key" "$desc" "$example" "$fn" "$confirm"
}

# Web/server basics
lu_cmd_web_py_serve() { local port="${1:-8000}"; lu_adv_require_cmd python3; lu_run python3 -m http.server "$port"; }
lu_cmd_web_busybox_serve() { local port="${1:-8080}"; lu_adv_require_cmd busybox; lu_run busybox httpd -f -p "$port"; }
lu_cmd_web_php_serve() { local host="${1:-127.0.0.1}"; local port="${2:-8000}"; lu_adv_require_cmd php; lu_run php -S "${host}:${port}"; }
lu_cmd_web_node_serve() { local port="${1:-3000}"; lu_adv_require_cmd npx; lu_run npx serve -l "$port"; }
lu_cmd_web_caddy_serve() { local root="${1:-.}"; local addr="${2:-:8080}"; lu_adv_require_cmd caddy; lu_run caddy file-server --root "$root" --listen "$addr"; }
lu_cmd_web_nginx_test() { lu_adv_require_cmd nginx; lu_run sudo nginx -t; }
lu_cmd_web_nginx_reload() { lu_adv_require_cmd nginx; lu_run sudo systemctl reload nginx; }
lu_cmd_web_apache_test() { if lu_has_cmd apachectl; then lu_run sudo apachectl configtest; elif lu_has_cmd httpd; then lu_run sudo httpd -t; else lu_die "apache/httpd not found" 11; fi; }
lu_cmd_web_apache_reload() { if lu_has_cmd systemctl; then lu_run sudo systemctl reload apache2 || lu_run sudo systemctl reload httpd; else lu_die "systemctl missing" 11; fi; }
lu_cmd_web_certbot_renew() { lu_adv_require_cmd certbot; lu_run sudo certbot renew --dry-run; }
lu_cmd_web_curl_json() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils web curl-json <url>" 10; lu_run curl -fsSL -H 'Accept: application/json' "$1"; }
lu_cmd_web_bench_ab() { [[ $# -gt 1 ]] || lu_die "Usage: linuxutils web bench-ab <url> <requests> [concurrency]" 10; local c="${3:-20}"; lu_adv_require_cmd ab; lu_run ab -n "$2" -c "$c" "$1"; }
lu_cmd_web_bench_hey() { [[ $# -gt 1 ]] || lu_die "Usage: linuxutils web bench-hey <url> <requests> [concurrency]" 10; local c="${3:-20}"; lu_adv_require_cmd hey; lu_run hey -n "$2" -c "$c" "$1"; }

register_command "web.py-serve" "Serve current directory via Python HTTP server" "linuxutils web py-serve 8000" lu_cmd_web_py_serve
register_command "web.busybox-serve" "Serve current directory via busybox httpd" "linuxutils web busybox-serve 8080" lu_cmd_web_busybox_serve
register_command "web.php-serve" "Serve current directory via PHP built-in server" "linuxutils web php-serve 127.0.0.1 8000" lu_cmd_web_php_serve
register_command "web.node-serve" "Serve static files using npx serve" "linuxutils web node-serve 3000" lu_cmd_web_node_serve
register_command "web.caddy-serve" "Run Caddy static file server" "linuxutils web caddy-serve . :8080" lu_cmd_web_caddy_serve
register_command "web.nginx-test" "Validate nginx configuration" "linuxutils web nginx-test" lu_cmd_web_nginx_test
register_command "web.nginx-reload" "Reload nginx service" "linuxutils web nginx-reload" lu_cmd_web_nginx_reload 1
register_command "web.apache-test" "Validate Apache/httpd configuration" "linuxutils web apache-test" lu_cmd_web_apache_test
register_command "web.apache-reload" "Reload Apache/httpd service" "linuxutils web apache-reload" lu_cmd_web_apache_reload 1
register_command "web.certbot-renew" "Dry-run Let's Encrypt renewal" "linuxutils web certbot-renew" lu_cmd_web_certbot_renew
register_command "web.curl-json" "Fetch URL with JSON accept header" "linuxutils web curl-json https://httpbin.org/json" lu_cmd_web_curl_json
register_command "web.bench-ab" "Benchmark endpoint with ApacheBench" "linuxutils web bench-ab http://127.0.0.1:8000/ 1000 50" lu_cmd_web_bench_ab
register_command "web.bench-hey" "Benchmark endpoint with hey" "linuxutils web bench-hey http://127.0.0.1:8000/ 1000 50" lu_cmd_web_bench_hey

# Cloud and infra basics
lu_cmd_cloud_aws_login_hint() { lu_info "Run: aws configure"; }
lu_cmd_cloud_gcp_login_hint() { lu_info "Run: gcloud auth login"; }
lu_cmd_cloud_azure_login_hint() { lu_info "Run: az login"; }
lu_cmd_cloud_tf_fmt() { lu_adv_require_cmd terraform; lu_run terraform fmt -recursive; }
lu_cmd_cloud_tf_validate() { lu_adv_require_cmd terraform; lu_run terraform validate; }
lu_cmd_cloud_tf_plan() { lu_adv_require_cmd terraform; lu_run terraform plan; }
lu_cmd_cloud_tf_apply() { lu_adv_require_cmd terraform; lu_run terraform apply; }
lu_cmd_cloud_tf_destroy() { lu_adv_require_cmd terraform; lu_run terraform destroy; }
lu_cmd_cloud_ansible_ping() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils cloud ansible-ping <inventory> [pattern]" 10; local pattern="${2:-all}"; lu_adv_require_cmd ansible; lu_run ansible -i "$1" "$pattern" -m ping; }
lu_cmd_cloud_kube_ctx_use() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils cloud kube-ctx-use <context>" 10; lu_adv_require_cmd kubectl; lu_run kubectl config use-context "$1"; }
lu_cmd_cloud_kube_ns_use() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils cloud kube-ns-use <namespace>" 10; lu_adv_require_cmd kubectl; lu_run kubectl config set-context --current --namespace="$1"; }

register_command "cloud.aws-login-hint" "Show AWS CLI login hint" "linuxutils cloud aws-login-hint" lu_cmd_cloud_aws_login_hint
register_command "cloud.gcp-login-hint" "Show gcloud login hint" "linuxutils cloud gcp-login-hint" lu_cmd_cloud_gcp_login_hint
register_command "cloud.azure-login-hint" "Show Azure CLI login hint" "linuxutils cloud azure-login-hint" lu_cmd_cloud_azure_login_hint
register_command "cloud.tf-fmt" "Format Terraform files recursively" "linuxutils cloud tf-fmt" lu_cmd_cloud_tf_fmt
register_command "cloud.tf-validate" "Validate Terraform configuration" "linuxutils cloud tf-validate" lu_cmd_cloud_tf_validate
register_command "cloud.tf-plan" "Run Terraform plan" "linuxutils cloud tf-plan" lu_cmd_cloud_tf_plan
register_command "cloud.tf-apply" "Run Terraform apply" "linuxutils cloud tf-apply" lu_cmd_cloud_tf_apply 1
register_command "cloud.tf-destroy" "Run Terraform destroy" "linuxutils cloud tf-destroy" lu_cmd_cloud_tf_destroy 1
register_command "cloud.ansible-ping" "Ping hosts via ansible" "linuxutils cloud ansible-ping ./inventory.ini all" lu_cmd_cloud_ansible_ping
register_command "cloud.kube-ctx-use" "Switch kubectl context" "linuxutils cloud kube-ctx-use prod-cluster" lu_cmd_cloud_kube_ctx_use
register_command "cloud.kube-ns-use" "Set default kubectl namespace" "linuxutils cloud kube-ns-use default" lu_cmd_cloud_kube_ns_use

# AI / LLM / llama helpers
lu_cmd_ai_ollama_pull() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils ai ollama-pull <model>" 10; lu_adv_require_cmd ollama; lu_run ollama pull "$1"; }
lu_cmd_ai_ollama_run() { [[ $# -gt 1 ]] || lu_die "Usage: linuxutils ai ollama-run <model> <prompt>" 10; lu_adv_require_cmd ollama; local model="$1"; shift; lu_run ollama run "$model" "$*"; }
lu_cmd_ai_ollama_ps() { lu_adv_require_cmd ollama; lu_run ollama ps; }
lu_cmd_ai_ollama_rm() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils ai ollama-rm <model>" 10; lu_adv_require_cmd ollama; lu_run ollama rm "$1"; }
lu_cmd_ai_llama_cpp_run() { [[ $# -gt 1 ]] || lu_die "Usage: linuxutils ai llama-cpp-run <model.gguf> <prompt>" 10; lu_adv_require_cmd llama-cli; local model="$1"; shift; lu_run llama-cli -m "$model" -p "$*"; }
lu_cmd_ai_hf_download() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils ai hf-download <repo_id>" 10; lu_adv_require_cmd huggingface-cli; lu_run huggingface-cli download "$1"; }
lu_cmd_ai_vllm_serve() { [[ $# -gt 0 ]] || lu_die "Usage: linuxutils ai vllm-serve <model_path_or_id>" 10; lu_adv_require_cmd python3; lu_run python3 -m vllm.entrypoints.openai.api_server --model "$1"; }
lu_cmd_ai_openwebui_run() { lu_adv_require_cmd docker; lu_run docker run -d -p 3000:8080 --name open-webui ghcr.io/open-webui/open-webui:main; }

register_command "ai.ollama-pull" "Download an Ollama model" "linuxutils ai ollama-pull llama3.1" lu_cmd_ai_ollama_pull
register_command "ai.ollama-run" "Run prompt against Ollama model" "linuxutils ai ollama-run llama3.1 hello" lu_cmd_ai_ollama_run
register_command "ai.ollama-ps" "List running Ollama models" "linuxutils ai ollama-ps" lu_cmd_ai_ollama_ps
register_command "ai.ollama-rm" "Remove local Ollama model" "linuxutils ai ollama-rm llama3.1" lu_cmd_ai_ollama_rm 1
register_command "ai.llama-cpp-run" "Run llama.cpp model with prompt" "linuxutils ai llama-cpp-run ./model.gguf hello" lu_cmd_ai_llama_cpp_run
register_command "ai.hf-download" "Download model/artifact from Hugging Face" "linuxutils ai hf-download meta-llama/Llama-3.2-1B-Instruct" lu_cmd_ai_hf_download
register_command "ai.vllm-serve" "Start vLLM OpenAI-compatible server" "linuxutils ai vllm-serve meta-llama/Llama-3.2-1B-Instruct" lu_cmd_ai_vllm_serve
register_command "ai.openwebui-run" "Run Open WebUI container" "linuxutils ai openwebui-run" lu_cmd_ai_openwebui_run 1

# Bulk additions (tab-delimited): key<TAB>desc<TAB>example<TAB>shell<TAB>required_bin<TAB>confirm
while IFS=$'\t' read -r key desc example shell_cmd req confirm; do
  [[ -n "$key" ]] || continue
  lu_adv_register_shell "$key" "$desc" "$example" "$shell_cmd" "$req" "$confirm"
done <<'BULK'
web.curl-head	Send HEAD request with curl	linuxutils web curl-head https://example.com	curl -I https://example.com	curl	0
web.curl-follow	Fetch URL and follow redirects	linuxutils web curl-follow https://example.com	curl -L https://example.com	curl	0
web.http-code	Show HTTP status code only	linuxutils web http-code	curl -s -o /dev/null -w '%{http_code}\n' https://example.com	curl	0
web.http-latency	Show HTTP total latency	linuxutils web http-latency	curl -o /dev/null -s -w '%{time_total}\n' https://example.com	curl	0
web.dns-a	Query A records quickly	linuxutils web dns-a	dig +short A example.com	dig	0
web.dns-aaaa	Query AAAA records quickly	linuxutils web dns-aaaa	dig +short AAAA example.com	dig	0
web.dns-mx	Query MX records quickly	linuxutils web dns-mx	dig +short MX example.com	dig	0
web.dns-ns	Query NS records quickly	linuxutils web dns-ns	dig +short NS example.com	dig	0
web.socket-listen	List listening sockets for web ports	linuxutils web socket-listen	ss -tulpn	ss	0
web.check-robots	Fetch robots.txt	linuxutils web check-robots	curl -fsSL https://example.com/robots.txt	curl	0
web.check-sitemap	Fetch sitemap.xml	linuxutils web check-sitemap	curl -fsSL https://example.com/sitemap.xml	curl	0
web.check-healthz	Fetch health endpoint	linuxutils web check-healthz	curl -fsSL https://example.com/healthz	curl	0
web.python-flask-run	Run Flask app from app.py	linuxutils web python-flask-run	FLASK_APP=app.py flask run --host=0.0.0.0 --port=5000	flask	0
web.python-django-run	Run Django dev server	linuxutils web python-django-run	python3 manage.py runserver 0.0.0.0:8000	python3	0
web.go-run	Run Go web app	linuxutils web go-run	go run .	go	0
web.go-test	Run Go tests	linuxutils web go-test	go test ./...	go	0
web.node-dev	Run npm dev server	linuxutils web node-dev	npm run dev	npm	0
web.node-build	Build npm web app	linuxutils web node-build	npm run build	npm	0
web.node-start	Run npm start	linuxutils web node-start	npm start	npm	0
web.pm2-list	List PM2 processes	linuxutils web pm2-list	pm2 list	pm2	0
web.pm2-logs	Tail PM2 logs	linuxutils web pm2-logs	pm2 logs	pm2	0
web.pm2-save	Save PM2 process list	linuxutils web pm2-save	pm2 save	pm2	0
web.pm2-startup	Generate PM2 startup script	linuxutils web pm2-startup	pm2 startup	pm2	0
web.nginx-tail	Tail nginx access log	linuxutils web nginx-tail	sudo tail -n 200 /var/log/nginx/access.log	tail	0
web.nginx-error-tail	Tail nginx error log	linuxutils web nginx-error-tail	sudo tail -n 200 /var/log/nginx/error.log	tail	0
web.apache-tail	Tail apache access log	linuxutils web apache-tail	sudo tail -n 200 /var/log/apache2/access.log	tail	0
web.apache-error-tail	Tail apache error log	linuxutils web apache-error-tail	sudo tail -n 200 /var/log/apache2/error.log	tail	0
web.systemd-reload	Reload systemd manager config	linuxutils web systemd-reload	sudo systemctl daemon-reload	systemctl	1
web.watch-logs	Tail system journal for web services	linuxutils web watch-logs	sudo journalctl -fu nginx	tail	0
web.cache-bust-touch	Touch static assets to bust cache	linuxutils web cache-bust-touch	find . -type f -name '*.js' -exec touch {} \;	find	0
web.open-ports-web	Show open web-related ports	linuxutils web open-ports-web	sudo lsof -iTCP -sTCP:LISTEN -P -n	lsof	0
cloud.aws-whoami	Show AWS caller identity	linuxutils cloud aws-whoami	aws sts get-caller-identity	aws	0
cloud.aws-list-regions	List AWS regions	linuxutils cloud aws-list-regions	aws ec2 describe-regions --query 'Regions[].RegionName' --output table	aws	0
cloud.aws-list-instances	List EC2 instances	linuxutils cloud aws-list-instances	aws ec2 describe-instances --query 'Reservations[].Instances[].{Id:InstanceId,State:State.Name}' --output table	aws	0
cloud.aws-list-s3	List S3 buckets	linuxutils cloud aws-list-s3	aws s3 ls	aws	0
cloud.aws-eks-list	List EKS clusters	linuxutils cloud aws-eks-list	aws eks list-clusters --output table	aws	0
cloud.gcp-project	Show active gcloud project	linuxutils cloud gcp-project	gcloud config get-value project	gcloud	0
cloud.gcp-projects	List gcloud projects	linuxutils cloud gcp-projects	gcloud projects list	gcloud	0
cloud.gcp-compute-list	List Compute Engine VMs	linuxutils cloud gcp-compute-list	gcloud compute instances list	gcloud	0
cloud.gcp-gke-list	List GKE clusters	linuxutils cloud gcp-gke-list	gcloud container clusters list	gcloud	0
cloud.gcp-storage-list	List GCS buckets	linuxutils cloud gcp-storage-list	gcloud storage buckets list	gcloud	0
cloud.azure-subscriptions	List Azure subscriptions	linuxutils cloud azure-subscriptions	az account list -o table	az	0
cloud.azure-vm-list	List Azure VMs	linuxutils cloud azure-vm-list	az vm list -d -o table	az	0
cloud.azure-aks-list	List AKS clusters	linuxutils cloud azure-aks-list	az aks list -o table	az	0
cloud.azure-storage-list	List storage accounts	linuxutils cloud azure-storage-list	az storage account list -o table	az	0
cloud.kube-get-ns	List Kubernetes namespaces	linuxutils cloud kube-get-ns	kubectl get ns	kubectl	0
cloud.kube-get-nodes	List Kubernetes nodes	linuxutils cloud kube-get-nodes	kubectl get nodes -o wide	kubectl	0
cloud.kube-get-pods	List pods in all namespaces	linuxutils cloud kube-get-pods	kubectl get pods -A -o wide	kubectl	0
cloud.kube-top-nodes	Show node resource usage	linuxutils cloud kube-top-nodes	kubectl top nodes	kubectl	0
cloud.kube-top-pods	Show pod resource usage	linuxutils cloud kube-top-pods	kubectl top pods -A	kubectl	0
cloud.kube-events	Show latest Kubernetes events	linuxutils cloud kube-events	kubectl get events -A --sort-by=.lastTimestamp	kubectl	0
cloud.kube-contexts	List kube contexts	linuxutils cloud kube-contexts	kubectl config get-contexts	kubectl	0
cloud.kube-apply	Apply Kubernetes manifests	linuxutils cloud kube-apply	kubectl apply -f k8s/	kubectl	1
cloud.kube-delete	Delete Kubernetes manifests	linuxutils cloud kube-delete	kubectl delete -f k8s/	kubectl	1
cloud.docker-build	Build Docker image	linuxutils cloud docker-build	docker build -t "$DOCKER_IMAGE" .	docker	0
cloud.docker-push	Push Docker image	linuxutils cloud docker-push	docker push "$DOCKER_IMAGE"	docker	0
cloud.docker-login	Docker login to registry	linuxutils cloud docker-login	docker login "$DOCKER_REGISTRY"	docker	0
cloud.compose-up	Start services with compose	linuxutils cloud compose-up	docker compose up -d	docker	0
cloud.compose-down	Stop services with compose	linuxutils cloud compose-down	docker compose down	docker	1
cloud.compose-logs	Tail compose logs	linuxutils cloud compose-logs	docker compose logs -f	docker	0
cloud.tf-init	Initialize Terraform project	linuxutils cloud tf-init	terraform init	terraform	0
cloud.tf-show	Show Terraform state	linuxutils cloud tf-show	terraform show	terraform	0
cloud.tf-output	Show Terraform outputs	linuxutils cloud tf-output	terraform output	terraform	0
cloud.tf-state-list	List Terraform resources	linuxutils cloud tf-state-list	terraform state list	terraform	0
cloud.tf-workspaces	List Terraform workspaces	linuxutils cloud tf-workspaces	terraform workspace list	terraform	0
cloud.ansible-lint	Lint ansible playbooks	linuxutils cloud ansible-lint	ansible-lint	ansible-lint	0
cloud.ansible-vault-view	View ansible vault file	linuxutils cloud ansible-vault-view	ansible-vault view "$ANSIBLE_VAULT_FILE"	ansible-vault	0
cloud.helm-list	List Helm releases	linuxutils cloud helm-list	helm list -A	helm	0
cloud.helm-template	Render helm templates	linuxutils cloud helm-template	helm template "$HELM_RELEASE" "$HELM_CHART"	helm	0
cloud.helm-lint	Lint helm chart	linuxutils cloud helm-lint	helm lint "$HELM_CHART"	helm	0
cloud.kind-create	Create KIND cluster	linuxutils cloud kind-create	kind create cluster --name "$KIND_CLUSTER"	kind	0
cloud.kind-delete	Delete KIND cluster	linuxutils cloud kind-delete	kind delete cluster --name "$KIND_CLUSTER"	kind	1
cloud.minikube-start	Start minikube	linuxutils cloud minikube-start	minikube start	minikube	0
cloud.minikube-stop	Stop minikube	linuxutils cloud minikube-stop	minikube stop	minikube	1
cloud.minikube-status	Show minikube status	linuxutils cloud minikube-status	minikube status	minikube	0
cloud.packer-build	Build image with packer	linuxutils cloud packer-build	packer build "$PACKER_TEMPLATE"	packer	0
cloud.vault-status	Show Vault status	linuxutils cloud vault-status	vault status	vault	0
cloud.nomad-status	Show Nomad status	linuxutils cloud nomad-status	nomad status	nomad	0
ai.ollama-list	List local Ollama models	linuxutils ai ollama-list	ollama list	ollama	0
ai.ollama-serve	Run Ollama server foreground	linuxutils ai ollama-serve	ollama serve	ollama	0
ai.ollama-stop	Stop Ollama service	linuxutils ai ollama-stop	sudo systemctl stop ollama	systemctl	1
ai.ollama-start	Start Ollama service	linuxutils ai ollama-start	sudo systemctl start ollama	systemctl	1
ai.ollama-logs	Tail Ollama service logs	linuxutils ai ollama-logs	sudo journalctl -fu ollama	journalctl	0
ai.llama-cpp-bench	Run llama.cpp benchmark	linuxutils ai llama-cpp-bench	llama-bench	llama-bench	0
ai.llama-cpp-quantize	Quantize GGUF model	linuxutils ai llama-cpp-quantize	llama-quantize "$LLAMA_MODEL_IN" "$LLAMA_MODEL_OUT" "$LLAMA_QUANT"	llama-quantize	0
ai.python-pip-upgrade	Upgrade core AI Python packages	linuxutils ai python-pip-upgrade	python3 -m pip install -U pip setuptools wheel transformers accelerate sentencepiece	python3	0
ai.python-torch-cuda	Check torch CUDA availability	linuxutils ai python-torch-cuda	python3 -c 'import torch; print(torch.cuda.is_available())'	python3	0
ai.python-gpu-info	Show GPU info with nvidia-smi	linuxutils ai python-gpu-info	nvidia-smi	nvidia-smi	0
ai.jupyter-start	Start Jupyter Lab	linuxutils ai jupyter-start	jupyter lab --ip=0.0.0.0 --port=8888 --no-browser	jupyter	0
ai.jupyter-stop	Stop Jupyter server	linuxutils ai jupyter-stop	jupyter server stop 8888	jupyter	1
ai.gradio-run	Run Gradio app from app.py	linuxutils ai gradio-run	python3 app.py	python3	0
ai.streamlit-run	Run Streamlit app from app.py	linuxutils ai streamlit-run	streamlit run app.py	streamlit	0
ai.hf-whoami	Show Hugging Face logged in user	linuxutils ai hf-whoami	huggingface-cli whoami	huggingface-cli	0
ai.hf-login	Login to Hugging Face CLI	linuxutils ai hf-login	huggingface-cli login	huggingface-cli	0
ai.hf-cache-info	Show HF cache size	linuxutils ai hf-cache-info	du -sh ~/.cache/huggingface	du	0
ai.hf-cache-clear	Remove HF cache	linuxutils ai hf-cache-clear	rm -rf ~/.cache/huggingface	rm	1
ai.openai-env-check	Check OPENAI_API_KEY availability	linuxutils ai openai-env-check	test -n "$OPENAI_API_KEY" && echo set || echo missing	bash	0
ai.langchain-quickstart	Install LangChain stack	linuxutils ai langchain-quickstart	python3 -m pip install -U langchain langchain-community langchain-openai	python3	0
ai.rag-chroma-install	Install ChromaDB package	linuxutils ai rag-chroma-install	python3 -m pip install -U chromadb	python3	0
ai.rag-faiss-install	Install FAISS CPU package	linuxutils ai rag-faiss-install	python3 -m pip install -U faiss-cpu	python3	0
ai.textgen-webui-run	Run text-generation-webui container	linuxutils ai textgen-webui-run	docker run --rm -it -p 7860:7860 ataraxia/text-generation-webui	docker	0
ai.comfyui-run	Run ComfyUI container	linuxutils ai comfyui-run	docker run --rm -it -p 8188:8188 yanwk/comfyui-boot:cu121-slim	docker	0
ai.sd-webui-run	Run stable-diffusion-webui container	linuxutils ai sd-webui-run	docker run --rm -it -p 7860:7860 universonic/stable-diffusion-webui	docker	0
ai.model-card-open	Print model card URL from HF_MODEL env	linuxutils ai model-card-open	echo "https://huggingface.co/$HF_MODEL"	echo	0
BULK
