# 部署到自有 VPS（nginx + certbot）

> 本文是公开仓库可提交的占位符版 runbook。真实服务器、域名、路径、SSH 私钥只应保存在本机 shell 环境或未提交的 `.env` 文件中。

## 变量约定

后续命令使用这些占位变量；请在本机 shell 中替换成你的真实值，不要写回仓库：

```bash
export DEPLOY_HOST="user@server.example.com"
export DEPLOY_PATH="/var/www/llm-wiki"
export DEPLOY_DOMAIN="wiki.example.com"
export CERTBOT_EMAIL="admin@example.com"
```

## 总体架构

```
┌─────────────┐   1. sync + build              ┌──────────────┐
│  本地仓库   │ ─────────────────────────────► │ quartz/public│
│ ai-wiki/wiki│                                │  (静态文件)  │
└─────────────┘                                └───────┬──────┘
                                                       │ 2. rsync over SSH
                                                       ▼
                                              ┌──────────────────┐
                                              │   DEPLOY_PATH    │
   DEPLOY_DOMAIN ──► nginx :443 ───────────► │  (static files)  │
                              (HTTPS)         └──────────────────┘
```

入口脚本：`scripts/deploy.sh`（本仓库 `.agents/skills/quartz-wiki/scripts/deploy.sh`）。

## 服务器侧一次性准备

### Step 1: DNS 解析

到你的 DNS 提供商添加 A/AAAA 记录：

```
类型: A
主机: wiki
值:   <server-ip>
TTL:  600
```

验证生效（本地）：

```bash
dig "$DEPLOY_DOMAIN" +short
```

输出应包含你的服务器公网 IP。

### Step 2: 服务器准备目录 + nginx 配置 + rsync

```bash
ssh "$DEPLOY_HOST"

# 部署传输用
dnf install -y rsync   # 或 apt install -y rsync（Debian/Ubuntu）

# 建部署目录（首次 deploy.sh 也会自动建）
mkdir -p "$DEPLOY_PATH"
chown -R root:root "$DEPLOY_PATH"

exit
```

在本地复制 nginx 模板前，先把
`.agents/skills/quartz-wiki/scripts/nginx-llm-wiki.conf` 中的 `server_name` 和 `root`
改成真实域名与部署目录；不要把带真实值的版本提交。

```bash
scp .agents/skills/quartz-wiki/scripts/nginx-llm-wiki.conf \
    "$DEPLOY_HOST:/etc/nginx/conf.d/llm-wiki.conf"

ssh "$DEPLOY_HOST" 'nginx -t && systemctl reload nginx'
```

`nginx -t` 应输出 `syntax is ok` + `test is successful`。

### Step 3: HTTPS 证书（certbot）

确认 DNS 已生效后，在服务器执行：

```bash
ssh "$DEPLOY_HOST"

dnf install -y certbot python3-certbot-nginx

certbot --nginx -d "$DEPLOY_DOMAIN" \
  --non-interactive --agree-tos -m "$CERTBOT_EMAIL" --redirect

systemctl status certbot-renew.timer
# 如果发行版不存在 timer，手动测试续期：
certbot renew --dry-run
```

完成后访问 `https://$DEPLOY_DOMAIN/` 应返回 nginx 默认页或已部署站点。

## 日常部署流程

任意装有 Node 22+ 和 SSH 权限的设备：

```bash
git clone git@github.com:<owner>/llm-wiki.git
cd llm-wiki

cd quartz && npm install && cd ..

export DEPLOY_HOST="user@server.example.com"
export DEPLOY_PATH="/var/www/llm-wiki"
export DEPLOY_DOMAIN="wiki.example.com"

bash .agents/skills/quartz-wiki/scripts/deploy.sh
```

脚本会：

1. 检查环境（rsync/npm/ssh/curl）、检查未 commit 内容修改
2. 同步 `ai-wiki/wiki/` → `quartz/content/`
3. `npm run quartz -- build`
4. rsync `quartz/public/` → 服务器
5. curl 验证 HTTP 200

### 常用模式

```bash
# 只 rsync 已有的 public/，不重新 build
bash .agents/skills/quartz-wiki/scripts/deploy.sh --skip-build

# 干跑，看会传哪些文件，不实际写
bash .agents/skills/quartz-wiki/scripts/deploy.sh --dry-run
```

## 排错

| 症状 | 排查 |
|------|------|
| `dig` 返回空 | DNS 未生效，等 5-10 分钟；或者 DNS 商面板没保存 |
| `certbot --nginx` 报 "Failed authorization" | DNS 还没指过来，或者 80 端口被防火墙挡了 |
| build 提示 "Found 0 input files" | Quartz globby 默认 `gitignore: true` 会跳过被根 `.gitignore` 排除的 `quartz/content/`。已通过修改 `quartz/quartz/util/glob.ts` 关掉，npm 更新 Quartz 后需重新应用此修改 |
| rsync 报 "bash: rsync: command not found" | 远程服务器未装 rsync。`ssh "$DEPLOY_HOST" 'dnf install -y rsync'`（或 apt）。`deploy.sh` 前置检查也会拦截 |
| 部署后 404 | `ssh "$DEPLOY_HOST" "ls \"$DEPLOY_PATH\""` 看文件有没有；看 `error.log` |
| 部署后 403 | 目录权限，`ssh "$DEPLOY_HOST" "chmod -R o+rX \"$DEPLOY_PATH\""` |
| 中文路径 404 | nginx 默认 UTF-8 没问题；若异常加 `charset utf-8;` 到 server block |
| HTTPS 续期失败 | `certbot renew --dry-run` 看具体错；80 端口必须开放 |
| 图谱不展示 | 看浏览器控制台；确认 `contentIndex.json` 200 |
| 部署后样式丢失 | 清浏览器缓存；服务器 `nginx -s reload`；检查 `.quartz-cache` 已清 |

### 看日志

```bash
ssh "$DEPLOY_HOST" 'tail -50 /var/log/nginx/llm-wiki.error.log'
ssh "$DEPLOY_HOST" 'tail -50 /var/log/nginx/llm-wiki.access.log'
```

### 完全重置（保留服务器但清空部署内容）

```bash
ssh "$DEPLOY_HOST" "find \"$DEPLOY_PATH\" -mindepth 1 -maxdepth 1 -exec rm -rf {} +"
bash .agents/skills/quartz-wiki/scripts/deploy.sh
```

## 未来扩展（暂未实现）

- **预览环境**: PR 自动构建 + 部署到独立 preview 路径。
- **CDN 加速**: Cloudflare 套在前面（只代理静态资源，源站不变）。
