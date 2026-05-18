# 部署到自有 VPS（nginx + certbot）

> 当前部署目标: `root@47.96.125.148:/home/www/website/llm-wiki/`
> 当前域名:     `wiki.bytelighting.cn`

## 总体架构

```
┌─────────────┐   1. sync + build              ┌──────────────┐
│  本地仓库   │ ─────────────────────────────► │ quartz/public│
│ ai-wiki/wiki│                                │  (静态文件)  │
└─────────────┘                                └───────┬──────┘
                                                       │ 2. rsync over SSH
                                                       ▼
                                              ┌──────────────────┐
                                              │ /home/www/website│
   wiki.bytelighting.cn ──► nginx :443 ───►  │   /llm-wiki/     │
                              (HTTPS)         └──────────────────┘
```

入口脚本：`scripts/deploy.sh`（本仓库 `.claude/skills/quartz-wiki/scripts/deploy.sh`）。

## 服务器侧一次性准备

### Step 1: DNS 解析

到你的 DNS 提供商（bytelighting.cn 当前 DNS 服务方）添加 A 记录：

```
类型: A
主机: wiki                  # 完整记录为 wiki.bytelighting.cn
值:   47.96.125.148
TTL:  600（10 分钟）
```

验证生效（本地）：

```bash
dig wiki.bytelighting.cn +short
# 应输出: 47.96.125.148
```

### Step 2: 服务器准备目录 + nginx 配置

```bash
# 登录
ssh root@47.96.125.148

# 建部署目录（首次会被 deploy.sh 自动建，提前建也行）
mkdir -p /home/www/website/llm-wiki
chown -R root:root /home/www/website/llm-wiki

# 退出，本地把 nginx 配置传上去
exit
```

在**本地**执行：

```bash
scp .claude/skills/quartz-wiki/scripts/nginx-llm-wiki.conf \
    root@47.96.125.148:/etc/nginx/conf.d/llm-wiki.conf

ssh root@47.96.125.148 'nginx -t && systemctl reload nginx'
```

`nginx -t` 应输出 `syntax is ok` + `test is successful`。

### Step 3: HTTPS 证书（certbot）

确认 DNS 已生效后（A 记录必须能解析到服务器），在服务器跑：

```bash
ssh root@47.96.125.148

# 阿里云 Linux 3 装 certbot
dnf install -y certbot python3-certbot-nginx

# 申请证书 + 自动改 nginx 配置 + 加 80→443 跳转
certbot --nginx -d wiki.bytelighting.cn \
  --non-interactive --agree-tos -m your@email.com --redirect

# 验证自动续期定时器
systemctl status certbot-renew.timer
# 如果是别的发行版（不存在 timer），手动测试续期：
certbot renew --dry-run
```

`--email` 用一个你常用的邮箱（Let's Encrypt 用于证书过期提醒）。

完成后访问 https://wiki.bytelighting.cn/ 应返回 nginx 默认页（因为 deploy 还没跑）。

## 日常部署流程

任意装有 Node 22+ 和 SSH 权限的设备：

```bash
git clone git@github.com:<your>/llm-wiki.git
cd llm-wiki

# 首次准备：装依赖
cd quartz && npm install && cd ..

# 部署（每次更新内容后执行）
bash .claude/skills/quartz-wiki/scripts/deploy.sh
```

脚本会：

1. 检查环境（rsync/npx/ssh/curl）、检查未 commit 修改
2. 同步 `ai-wiki/wiki/` → `quartz/content/`
3. `npx quartz build`
4. rsync `quartz/public/` → 服务器
5. curl 验证 HTTP 200

### 常用模式

```bash
# 只 rsync 已有的 public/，不重新 build
bash .claude/skills/quartz-wiki/scripts/deploy.sh --skip-build

# 干跑，看会传哪些文件，不实际写
bash .claude/skills/quartz-wiki/scripts/deploy.sh --dry-run
```

### 覆盖配置（环境变量）

```bash
DEPLOY_HOST=root@another.host \
DEPLOY_PATH=/var/www/wiki \
DEPLOY_DOMAIN=wiki.example.com \
bash .claude/skills/quartz-wiki/scripts/deploy.sh
```

## 多设备维护

| 设备 | 准备项 |
|------|--------|
| 设备 A（已配置） | 已 OK |
| 设备 B、C... | 1. 生成 SSH key  2. pubkey 加到服务器 `/root/.ssh/authorized_keys`  3. pubkey 加到 GitHub（私有仓库需要）  4. clone 仓库 + `npm install` |

部署互不冲突——deploy.sh 用 `rsync --delete`，谁最后部署谁是 latest，无并发数据竞争（rsync 本身是原子的：先传到临时目录再 swap）。

## 排错

| 症状 | 排查 |
|------|------|
| `dig` 返回空 | DNS 未生效，等 5-10 分钟；或者 DNS 商面板没保存 |
| `certbot --nginx` 报 "Failed authorization" | DNS 还没指过来，或者 80 端口被防火墙挡了 |
| 部署后 404 | `ssh root@<host> 'ls /home/www/website/llm-wiki/'` 看文件有没有；看 `error.log` |
| 部署后 403 | 目录权限，`chmod -R o+rX /home/www/website/llm-wiki` |
| 中文路径 404 | nginx 默认 UTF-8 没问题；若异常加 `charset utf-8;` 到 server block |
| HTTPS 续期失败 | `certbot renew --dry-run` 看具体错；80 端口必须开放 |
| 图谱不展示 | 看浏览器控制台；确认 `contentIndex.json` 200 |
| 部署后样式丢失 | 清浏览器缓存；服务器 `nginx -s reload`；检查 `.quartz-cache` 已清 |

### 看日志

```bash
ssh root@47.96.125.148 'tail -50 /var/log/nginx/llm-wiki.error.log'
ssh root@47.96.125.148 'tail -50 /var/log/nginx/llm-wiki.access.log'
```

### 完全重置（保留服务器但清空部署内容）

```bash
ssh root@47.96.125.148 'rm -rf /home/www/website/llm-wiki/*'
bash .claude/skills/quartz-wiki/scripts/deploy.sh
```

## 未来扩展（暂未实现）

- **GitHub Actions 自动部署**: main 分支推送 → CI 跑 build + rsync。需要把 `DEPLOY_SSH_KEY` 加到仓库 Secrets。
- **预览环境**: PR 自动构建 + 部署到 `/home/www/website/llm-wiki-preview/`。
- **CDN 加速**: Cloudflare 套在前面（只代理静态资源，源站不变）。
