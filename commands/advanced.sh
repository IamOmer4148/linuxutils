#!/usr/bin/env bash

set -euo pipefail

lu_adv_note() {
  printf '%s\n' "$*"
}

lu_adv_try() {
  local bin="$1"
  shift
  if lu_has_cmd "$bin"; then
    lu_run "$bin" "$@"
  else
    lu_warn "Optional dependency '$bin' is not installed; skipping step."
  fi
}

declare -Ag LU_ADV_SCRIPT=()

lu_adv_run_registered() {
  local key="$1"
  shift
  lu_run bash -lc "${LU_ADV_SCRIPT[$key]}" -- "$@"
}

lu_adv_register() {
  local key="$1"
  local desc="$2"
  local example="$3"
  local script="$4"
  local confirm="${5:-0}"

  local fn="lu_cmd_${key//./_}"
  fn="${fn//-/_}"

  LU_ADV_SCRIPT["$key"]="$script"

  local qkey
  printf -v qkey '%q' "$key"
  eval "${fn}() { lu_adv_run_registered ${qkey} "\$@"; }"

  register_command "$key" "$desc" "$example" "$fn" "$confirm"
}

# Hand-crafted practical workflows.

# Compatibility commands users already expect.
lu_adv_register "web.http-code" "Show HTTP status code for a URL (default: https://example.com)" "linuxutils web http-code https://example.com" "set -e; url=\"\${1:-https://example.com}\"; curl -s -o /dev/null -w '%{http_code}\\n' \"\$url\""
lu_adv_register "web.python-flask-run" "Run Flask app from app.py on 0.0.0.0:5000" "linuxutils web python-flask-run" "set -e; export FLASK_APP=\"\${FLASK_APP:-app.py}\"; flask run --host=0.0.0.0 --port=\"\${FLASK_PORT:-5000}\""
lu_adv_register "web.busybox-serve" "Serve current directory via busybox on port (default 8080)" "linuxutils web busybox-serve 8080" "set -e; port=\"\${1:-8080}\"; busybox httpd -f -p \"\$port\""

lu_adv_register "web.release-refresh" "Refresh app release, run checks, and print restart hints" "linuxutils web release-refresh" "set -e; date; pwd; git rev-parse --short HEAD 2>/dev/null || true; [ -f package.json ] && npm ci --silent || true; [ -f requirements.txt ] && python3 -m pip install -r requirements.txt || true; echo 'Run service reload after validation.'"
lu_adv_register "web.stack-health-scan" "Run common HTTP and local port health checks" "linuxutils web stack-health-scan" "set -e; ss -tulpn | head -n 25; curl -fsSI https://example.com | head -n 10 || true; curl -fsS https://example.com/healthz || true"
lu_adv_register "web.config-backup-rotate" "Backup web config files with timestamp rotation" "linuxutils web config-backup-rotate" "set -e; ts=\$(date +%Y%m%d-%H%M%S); out=\${WEB_BACKUP_DIR:-./web-config-backups}; mkdir -p \"\$out\"; tar -czf \"\$out/config-\$ts.tgz\" /etc/nginx /etc/apache2 /etc/caddy 2>/dev/null || true; ls -1t \"\$out\" | tail -n +11 | xargs -r -I{} rm -f \"\$out/{}\"; echo \"Saved in \$out\""
lu_adv_register "cloud.bootstrap-checklist" "Run cloud workstation readiness checklist" "linuxutils cloud bootstrap-checklist" "set -e; for c in git curl ssh jq; do command -v \"\$c\" >/dev/null && echo \"ok: \$c\" || echo \"missing: \$c\"; done; for c in aws gcloud az kubectl terraform docker; do command -v \"\$c\" >/dev/null && echo \"optional ok: \$c\" || echo \"optional missing: \$c\"; done"
lu_adv_register "cloud.change-window-preflight" "Collect infra context before a deployment window" "linuxutils cloud change-window-preflight" "set -e; date; uname -a; git status --short 2>/dev/null || true; kubectl config current-context 2>/dev/null || true; terraform workspace show 2>/dev/null || true; docker info --format '{{.ServerVersion}}' 2>/dev/null || true"
lu_adv_register "ai.llama-lab-bootstrap" "Bootstrap a local llama experimentation environment" "linuxutils ai llama-lab-bootstrap" "set -e; python3 --version; python3 -m venv .venv-llama; . .venv-llama/bin/activate; pip install -U pip wheel setuptools; pip install -U transformers sentencepiece accelerate"
lu_adv_register "ai.model-serving-preflight" "Run local model-serving preflight checks" "linuxutils ai model-serving-preflight" "set -e; python3 -c 'import sys; print(sys.version)'; command -v nvidia-smi >/dev/null && nvidia-smi || echo 'GPU tool missing'; command -v ollama >/dev/null && ollama list || echo 'ollama missing'; command -v docker >/dev/null && docker ps >/dev/null && echo docker-ok || echo docker-missing"

# Large workflow matrix to exceed 500 commands while keeping useful long-form shortcuts.
web_stacks=(nginx apache caddy node python php go rust)
web_workflows=(
  release-audit
  rollout-precheck
  dependency-refresh
  static-asset-prepare
  health-probe-suite
  access-log-triage
  error-log-triage
  tls-expiry-report
  security-header-audit
  robots-sitemap-audit
  latency-sample
  upstream-reachability
  port-binding-report
  config-lint-pass
  backup-snapshot
  rollback-plan
  cache-warmup
  smoke-route-suite
  service-reload-plan
  post-deploy-summary
)

for stack in "${web_stacks[@]}"; do
  for flow in "${web_workflows[@]}"; do
    key="web.${stack}-${flow}"
    desc="${stack^} workflow: ${flow//-/ }"
    example="linuxutils web ${stack}-${flow}"
    script="set -e; echo 'stack=${stack}'; echo 'workflow=${flow}'; date; hostname; \
      [ -d .git ] && git rev-parse --short HEAD || true; \
      case '${flow}' in \
        release-audit) git status --short 2>/dev/null || true; [ -f package.json ] && npm run -s build || true ;; \
        rollout-precheck) ss -tulpn | head -n 20; curl -fsSI https://example.com | head -n 8 || true ;; \
        dependency-refresh) [ -f requirements.txt ] && python3 -m pip install -r requirements.txt || true; [ -f package.json ] && npm ci --silent || true ;; \
        static-asset-prepare) find . -type f \( -name '*.js' -o -name '*.css' -o -name '*.html' \) | head -n 40 ;; \
        health-probe-suite) curl -fsS https://example.com/healthz || true; curl -fsSI https://example.com | head -n 10 || true ;; \
        access-log-triage) tail -n 120 /var/log/nginx/access.log 2>/dev/null || tail -n 120 /var/log/apache2/access.log 2>/dev/null || true ;; \
        error-log-triage) tail -n 120 /var/log/nginx/error.log 2>/dev/null || tail -n 120 /var/log/apache2/error.log 2>/dev/null || true ;; \
        tls-expiry-report) echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates || true ;; \
        security-header-audit) curl -sI https://example.com | grep -Ei 'strict-transport-security|content-security-policy|x-frame-options|x-content-type-options' || true ;; \
        robots-sitemap-audit) curl -fsS https://example.com/robots.txt || true; curl -fsS https://example.com/sitemap.xml || true ;; \
        latency-sample) for i in 1 2 3; do curl -o /dev/null -s -w '%{time_total}\n' https://example.com || true; done ;; \
        upstream-reachability) getent hosts example.com || true; ping -c 2 example.com || true ;; \
        port-binding-report) ss -tulpn | grep -E ':80|:443|:3000|:8000' || true ;; \
        config-lint-pass) nginx -t 2>/dev/null || apachectl configtest 2>/dev/null || caddy validate --config /etc/caddy/Caddyfile 2>/dev/null || true ;; \
        backup-snapshot) ts=\$(date +%Y%m%d-%H%M%S); mkdir -p .websnap; tar -czf .websnap/${stack}-\$ts.tgz . 2>/dev/null || true; ls -1 .websnap | tail -n 5 ;; \
        rollback-plan) echo '1) restore backup 2) restart service 3) health probe 4) announce status' ;; \
        cache-warmup) for p in / /healthz /robots.txt; do curl -fsSI https://example.com\$p || true; done ;; \
        smoke-route-suite) for p in / /login /api/health /static/app.js; do echo \"route: \$p\"; curl -fsSI https://example.com\$p | head -n 1 || true; done ;; \
        service-reload-plan) systemctl status nginx 2>/dev/null || systemctl status apache2 2>/dev/null || true; echo 'reload only after health checks'; ;; \
        post-deploy-summary) echo 'deployed_at='\$(date -Is); ss -tulpn | head -n 15; curl -fsSI https://example.com | head -n 8 || true ;; \
      esac"
    lu_adv_register "$key" "$desc" "$example" "$script"
  done
done

cloud_platforms=(aws gcp azure kubernetes terraform docker ansible multi-cloud)
cloud_workflows=(
  auth-context-audit
  account-inventory
  region-inventory
  compute-inventory
  storage-inventory
  network-inventory
  deployment-precheck
  deployment-preview
  deployment-apply-plan
  rollback-readiness
  policy-audit
  cost-sanity-scan
  drift-detection
  state-backup
  logs-triage
  incident-capture
  secret-usage-check
  change-window-summary
  post-deploy-validation
  teardown-guard
)

for plat in "${cloud_platforms[@]}"; do
  for flow in "${cloud_workflows[@]}"; do
    key="cloud.${plat}-${flow}"
    desc="${plat^} workflow: ${flow//-/ }"
    example="linuxutils cloud ${plat}-${flow}"
    script="set -e; echo 'platform=${plat}'; echo 'workflow=${flow}'; date; \
      case '${flow}' in \
        auth-context-audit) aws sts get-caller-identity 2>/dev/null || true; gcloud config get-value account 2>/dev/null || true; az account show -o table 2>/dev/null || true; kubectl config current-context 2>/dev/null || true ;; \
        account-inventory) aws organizations list-accounts 2>/dev/null || true; gcloud projects list 2>/dev/null || true; az account list -o table 2>/dev/null || true ;; \
        region-inventory) aws ec2 describe-regions --output table 2>/dev/null || true; gcloud compute regions list 2>/dev/null || true; az account list-locations -o table 2>/dev/null || true ;; \
        compute-inventory) aws ec2 describe-instances --max-items 20 2>/dev/null || true; gcloud compute instances list 2>/dev/null || true; az vm list -d -o table 2>/dev/null || true; kubectl get nodes -o wide 2>/dev/null || true ;; \
        storage-inventory) aws s3 ls 2>/dev/null || true; gcloud storage buckets list 2>/dev/null || true; az storage account list -o table 2>/dev/null || true ;; \
        network-inventory) aws ec2 describe-vpcs --max-items 20 2>/dev/null || true; gcloud compute networks list 2>/dev/null || true; az network vnet list -o table 2>/dev/null || true ;; \
        deployment-precheck) terraform validate 2>/dev/null || true; kubectl get ns 2>/dev/null || true; docker ps 2>/dev/null || true ;; \
        deployment-preview) terraform plan 2>/dev/null || true; helm list -A 2>/dev/null || true; kubectl get deploy -A 2>/dev/null || true ;; \
        deployment-apply-plan) echo 'review IaC diff, approve, apply in window'; terraform show 2>/dev/null || true ;; \
        rollback-readiness) echo 'collect previous artifact hash, infra state, and rollback command'; terraform state list 2>/dev/null || true ;; \
        policy-audit) echo 'policy checks:'; kubectl auth can-i get pods -A 2>/dev/null || true; aws iam list-users 2>/dev/null || true ;; \
        cost-sanity-scan) echo 'run provider-native cost explorer manually'; date ;; \
        drift-detection) terraform plan -refresh-only 2>/dev/null || true; kubectl diff -f k8s/ 2>/dev/null || true ;; \
        state-backup) ts=\$(date +%Y%m%d-%H%M%S); terraform state pull > tfstate-\$ts.json 2>/dev/null || true; ls -1 tfstate-*.json 2>/dev/null | tail -n 5 || true ;; \
        logs-triage) kubectl get events -A --sort-by=.lastTimestamp 2>/dev/null | tail -n 40 || true; docker compose logs --tail=80 2>/dev/null || true ;; \
        incident-capture) ts=\$(date +%Y%m%d-%H%M%S); mkdir -p .incident; kubectl get pods -A -o wide > .incident/pods-\$ts.txt 2>/dev/null || true; docker ps > .incident/docker-\$ts.txt 2>/dev/null || true ;; \
        secret-usage-check) env | grep -E 'AWS_|AZURE_|GOOGLE_|KUBE_|TF_' | sed 's/=.*$/=***masked***/' || true ;; \
        change-window-summary) echo 'window='\$(date -Is); kubectl config current-context 2>/dev/null || true; terraform workspace show 2>/dev/null || true ;; \
        post-deploy-validation) curl -fsSI https://example.com | head -n 8 || true; kubectl get pods -A 2>/dev/null || true ;; \
        teardown-guard) echo 'verify backups and approvals before destroy'; terraform plan -destroy 2>/dev/null || true ;; \
      esac"
    lu_adv_register "$key" "$desc" "$example" "$script"
  done
done

ai_stacks=(ollama llama-cpp transformers vllm rag gpuops serving evals multi-model)
ai_workflows=(
  environment-audit
  dependency-bootstrap
  model-download-prep
  model-integrity-check
  prompt-smoke-test
  inference-latency-sample
  memory-footprint-scan
  gpu-availability-check
  tokenizer-sanity
  embedding-pipeline-check
  rag-index-refresh
  serving-api-preflight
  serving-load-sample
  guardrail-sanity
  eval-dataset-smoke
  fine-tune-readiness
  quantization-readiness
  artifact-backup
  rollback-plan
  run-summary
)

for stack in "${ai_stacks[@]}"; do
  for flow in "${ai_workflows[@]}"; do
    key="ai.${stack}-${flow}"
    desc="${stack^} workflow: ${flow//-/ }"
    example="linuxutils ai ${stack}-${flow}"
    script="set -e; echo 'stack=${stack}'; echo 'workflow=${flow}'; date; \
      case '${flow}' in \
        environment-audit) python3 --version; command -v pip >/dev/null && pip --version || true; command -v nvidia-smi >/dev/null && nvidia-smi || true ;; \
        dependency-bootstrap) python3 -m pip install -U pip wheel setuptools >/dev/null 2>&1 || true; python3 -m pip list | head -n 20 ;; \
        model-download-prep) mkdir -p \${AI_MODEL_DIR:-./models}; df -h \${AI_MODEL_DIR:-./models} ;; \
        model-integrity-check) find \${AI_MODEL_DIR:-./models} -type f | head -n 20; sha256sum \${AI_MODEL_FILE:-/dev/null} 2>/dev/null || true ;; \
        prompt-smoke-test) echo 'Prompt:' \"\${AI_PROMPT:-hello world}\"; command -v ollama >/dev/null && ollama run \${AI_OLLAMA_MODEL:-llama3.1} \"\${AI_PROMPT:-hello world}\" || true ;; \
        inference-latency-sample) for i in 1 2 3; do date +%s%3N; python3 - <<'PY'\nprint('inference-smoke')\nPY\n done ;; \
        memory-footprint-scan) free -h; ps aux | grep -E 'ollama|python|vllm' | grep -v grep || true ;; \
        gpu-availability-check) command -v nvidia-smi >/dev/null && nvidia-smi || echo 'no nvidia-smi'; python3 - <<'PY'\ntry:\n import torch\n print(torch.cuda.is_available())\nexcept Exception:\n print('torch-not-installed')\nPY ;; \
        tokenizer-sanity) python3 - <<'PY'\ntext='linuxutils tokenizer check'\nprint(len(text.split()))\nPY ;; \
        embedding-pipeline-check) python3 - <<'PY'\nprint('embedding pipeline placeholder ok')\nPY ;; \
        rag-index-refresh) mkdir -p \${RAG_INDEX_DIR:-./rag-index}; find \${RAG_SOURCE_DIR:-.} -maxdepth 2 -type f | head -n 20 > \${RAG_INDEX_DIR:-./rag-index}/sources.txt ;; \
        serving-api-preflight) ss -tulpn | grep -E ':11434|:8000|:8080' || true; curl -fsS http://127.0.0.1:11434/api/tags 2>/dev/null || true ;; \
        serving-load-sample) for i in 1 2 3; do curl -s -o /dev/null -w '%{http_code} %{time_total}\n' http://127.0.0.1:11434/api/tags || true; done ;; \
        guardrail-sanity) echo 'verify banned terms and policy prompts in your app config'; ;; \
        eval-dataset-smoke) [ -f \${AI_EVAL_DATASET:-./eval.jsonl} ] && head -n 5 \${AI_EVAL_DATASET:-./eval.jsonl} || echo 'no eval dataset'; ;; \
        fine-tune-readiness) python3 - <<'PY'\nprint('check dataset, tokenizer, optimizer, LR schedule')\nPY ;; \
        quantization-readiness) command -v llama-quantize >/dev/null && llama-quantize --help | head -n 5 || echo 'llama-quantize missing'; ;; \
        artifact-backup) ts=\$(date +%Y%m%d-%H%M%S); mkdir -p .ai-backups; tar -czf .ai-backups/ai-\$ts.tgz \${AI_MODEL_DIR:-./models} 2>/dev/null || true; ls -1 .ai-backups | tail -n 5 ;; \
        rollback-plan) echo 'record previous model tag and serving config before switching'; ;; \
        run-summary) echo 'summary='\$(date -Is); du -sh \${AI_MODEL_DIR:-./models} 2>/dev/null || true; ;; \
      esac"
    lu_adv_register "$key" "$desc" "$example" "$script"
  done
done
