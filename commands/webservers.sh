#!/usr/bin/env bash

set -euo pipefail

lu_cmd_web_make_simple_page() {
  local dir="${1:-webserver}"
  mkdir -p "$dir"
  cat >"$dir/index.html" <<'EOT'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>linuxutils webserver</title></head>
  <body>
    <h1>It works ✅</h1>
    <p>Served by linuxutils premade webserver command.</p>
  </body>
</html>
EOT
  lu_success "Created $dir/index.html"
}

lu_cmd_web_host_python() {
  local dir="${1:-webserver}"
  local port="${2:-8000}"
  [[ -d "$dir" ]] || lu_die "Directory not found: $dir" 10
  lu_has_cmd python3 || lu_die "python3 missing" 11
  lu_run python3 -m http.server "$port" --directory "$dir"
}

lu_cmd_web_host_node() {
  local dir="${1:-webserver}"
  local port="${2:-3000}"
  [[ -d "$dir" ]] || lu_die "Directory not found: $dir" 10
  lu_has_cmd node || lu_die "node missing" 11
  lu_run node -e '
const http=require("http"),fs=require("fs"),path=require("path");
const root=process.argv[1],port=Number(process.argv[2]||3000);
http.createServer((req,res)=>{
  let p=decodeURIComponent(req.url.split("?")[0]); if(p==="/") p="/index.html";
  const f=path.join(root,p); if(!f.startsWith(path.resolve(root))){res.writeHead(403);return res.end("forbidden");}
  fs.readFile(f,(e,d)=>{ if(e){res.writeHead(404); return res.end("not found");}
    res.writeHead(200,{"Content-Type": f.endsWith(".html")?"text/html":"text/plain"}); res.end(d);
  });
}).listen(port,"0.0.0.0",()=>console.log(`http://0.0.0.0:${port}`));' "$dir" "$port"
}

lu_cmd_web_host_c() {
  local dir="${1:-webserver}"
  local port="${2:-8080}"
  [[ -d "$dir" ]] || lu_die "Directory not found: $dir" 10
  lu_has_cmd gcc || lu_die "gcc missing" 11

  local build_dir="${TMPDIR:-/tmp}/linuxutils-c-webserver"
  mkdir -p "$build_dir"
  cat >"$build_dir/server.c" <<'EOT'
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char **argv) {
  const char *root = argc > 1 ? argv[1] : ".";
  int port = argc > 2 ? atoi(argv[2]) : 8080;
  chdir(root);
  int s = socket(AF_INET, SOCK_STREAM, 0), c;
  int opt=1; setsockopt(s,SOL_SOCKET,SO_REUSEADDR,&opt,sizeof(opt));
  struct sockaddr_in a = {.sin_family = AF_INET, .sin_port = htons(port), .sin_addr.s_addr = INADDR_ANY};
  bind(s, (struct sockaddr*)&a, sizeof(a)); listen(s, 16);
  printf("http://0.0.0.0:%d\n", port);
  while ((c = accept(s, NULL, NULL)) >= 0) {
    char req[1024]={0}, path[512]="index.html", buf[8192];
    read(c, req, sizeof(req)-1);
    sscanf(req, "GET /%511s", path);
    char *q=strchr(path,'?'); if(q)*q='\0';
    if (strcmp(path, "HTTP/1.1")==0 || strcmp(path, "HTTP/1.0")==0) strcpy(path, "index.html");
    FILE *f = fopen(path, "rb");
    if (!f) { write(c, "HTTP/1.1 404 Not Found\r\n\r\nnot found\n", 39); close(c); continue; }
    write(c, "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n", 44);
    size_t n; while ((n=fread(buf,1,sizeof(buf),f))>0) write(c, buf, n);
    fclose(f); close(c);
  }
  return 0;
}
EOT

  lu_run gcc "$build_dir/server.c" -O2 -o "$build_dir/server"
  lu_run "$build_dir/server" "$dir" "$port"
}

lu_cmd_web_host_apache() {
  local dir="${1:-webserver}"
  local port="${2:-8081}"
  [[ -d "$dir" ]] || lu_die "Directory not found: $dir" 10

  local apache_bin=""
  if lu_has_cmd apache2ctl; then
    apache_bin="apache2ctl"
  elif lu_has_cmd httpd; then
    apache_bin="httpd"
  else
    lu_die "apache2ctl/httpd missing" 11
  fi

  local conf_dir="${TMPDIR:-/tmp}/linuxutils-apache"
  mkdir -p "$conf_dir"
  cat >"$conf_dir/httpd.conf" <<EOT
ServerRoot "$conf_dir"
PidFile "$conf_dir/httpd.pid"
Listen $port
ServerName localhost
DocumentRoot "$dir"
ErrorLog "$conf_dir/error.log"
LoadModule mpm_event_module /usr/lib/apache2/modules/mod_mpm_event.so
LoadModule authz_core_module /usr/lib/apache2/modules/mod_authz_core.so
LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so
LoadModule mime_module /usr/lib/apache2/modules/mod_mime.so
<Directory "$dir">
  Require all granted
  Options Indexes FollowSymLinks
  AllowOverride None
</Directory>
DirectoryIndex index.html
TypesConfig /etc/mime.types
EOT

  lu_warn "Apache module paths differ by distro. If this fails, edit: $conf_dir/httpd.conf"
  if [[ "$apache_bin" == "apache2ctl" ]]; then
    lu_run apache2ctl -f "$conf_dir/httpd.conf" -DFOREGROUND
  else
    lu_run httpd -f "$conf_dir/httpd.conf" -DFOREGROUND
  fi
}

register_command "web.make-simple-page" "Create a simple index.html in target directory (default: webserver/)" "linuxutils web make-simple-page webserver" lu_cmd_web_make_simple_page
register_command "web.host-python" "Host a directory with Python http.server" "linuxutils web host-python webserver 8000" lu_cmd_web_host_python
register_command "web.host-node" "Host a directory with a simple Node.js HTTP server" "linuxutils web host-node webserver 3000" lu_cmd_web_host_node
register_command "web.host-c" "Host a directory with a compiled C HTTP server" "linuxutils web host-c webserver 8080" lu_cmd_web_host_c
register_command "web.host-apache" "Host a directory with Apache foreground server" "linuxutils web host-apache webserver 8081" lu_cmd_web_host_apache
