#!/usr/bin/env bash
# deploy.sh — 本地 build + rsync 部署 llm-wiki 到远程 nginx 服务器
#
# 用法（从任意位置）:
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh                # 完整流程
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh --skip-build   # 仅上传已有的 public/
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh --dry-run      # 干跑（不实际传输）
#
# 环境变量（可覆盖默认值）:
#   DEPLOY_HOST    SSH 目标，必填，例如 user@server.example.com
#   DEPLOY_PATH    服务器路径，必填，例如 /var/www/llm-wiki
#   DEPLOY_DOMAIN  验证域名，必填，例如 wiki.example.com
#
# .env 文件:
#   自动加载仓库根目录的 .env（如果存在），无需手动 source。
#   .env 中未设置的变量仍可通过 shell export 覆盖。

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"

# === 自动加载 .env ===
ENV_FILE="$REPO_ROOT/.env"
if [ -f "$ENV_FILE" ]; then
  echo "加载 $ENV_FILE"
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

DEPLOY_HOST="${DEPLOY_HOST:-}"
DEPLOY_PATH="${DEPLOY_PATH:-}"
DEPLOY_DOMAIN="${DEPLOY_DOMAIN:-}"

SKIP_BUILD=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=1 ;;
    --dry-run)    DRY_RUN=1 ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
  esac
done

require_env() {
  local name="$1"
  local value="${!name:-}"
  if [ -z "$value" ]; then
    echo "  ✗ 缺少环境变量 $name" >&2
    echo "    请在 .env 文件或 shell export 中设置。" >&2
    return 1
  fi
}

echo "═══════════════════════════════════════════════"
echo "  llm-wiki 部署"
echo "═══════════════════════════════════════════════"

require_env DEPLOY_HOST
require_env DEPLOY_PATH
require_env DEPLOY_DOMAIN

echo "  目标:   $DEPLOY_HOST:$DEPLOY_PATH"
echo "  域名:   $DEPLOY_DOMAIN"
echo "  仓库:   $REPO_ROOT"
[ "$DRY_RUN" = "1" ] && echo "  模式:   DRY RUN"
echo

# === [1/4] 前置检查 ===
echo "[1/4] 前置检查"
cd "$REPO_ROOT"

for cmd in npm ssh; do
  if ! command -v "$cmd" >/dev/null; then
    echo "  ✗ 未找到 $cmd" >&2
    exit 1
  fi
done

# 检测可用的远程传输工具
UPLOAD_TOOL=""
if command -v rsync >/dev/null 2>&1; then
  UPLOAD_TOOL="rsync"
  echo "  ✓ 传输工具: rsync"
elif command -v scp >/dev/null 2>&1; then
  UPLOAD_TOOL="scp"
  echo "  ✓ 传输工具: scp（降级模式，不支持增量同步）"
else
  echo "  ✗ 未找到 rsync 或 scp，无法上传" >&2
  exit 1
fi

if [ -n "$(git status --porcelain ai-wiki/ 2>/dev/null)" ]; then
  echo "  ⚠ ai-wiki/ 有未 commit 的修改:"
  git status --short ai-wiki/ | sed 's/^/    /'
  if [ -t 0 ]; then
    read -r -p "  继续部署未提交内容？[y/N] " ans
    [ "$ans" = "y" ] || { echo "已取消"; exit 1; }
  else
    echo "  ✗ 非交互环境（CI）禁止部署未提交内容" >&2
    exit 1
  fi
fi

# 远程 rsync 检查（仅在本地用 rsync 时需要）
if [ "$UPLOAD_TOOL" = "rsync" ]; then
  if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$DEPLOY_HOST" 'command -v rsync >/dev/null'; then
    echo "  ⚠ 远程未安装 rsync，降级为 scp 传输"
    UPLOAD_TOOL="scp"
  fi
fi
echo "  ✓ 环境检查通过"

# === [2/4] Build ===
if [ "$SKIP_BUILD" = "0" ]; then
  echo "[2/4] 同步内容 + Quartz build"
  # 注入生产域名到 Quartz：影响 sitemap/RSS/og:url/canonical 等绝对链接
  export SITE_BASE_URL="$DEPLOY_DOMAIN"
  bash "$REPO_ROOT/.agents/skills/quartz-wiki/scripts/sync-content.sh"
  cd "$REPO_ROOT/quartz"
  rm -rf .quartz-cache public
  if command -v npx >/dev/null 2>&1; then
    npx quartz build
  else
    node quartz/bootstrap-cli.mjs build
  fi
  cd "$REPO_ROOT"
else
  echo "[2/4] 跳过 build（--skip-build）"
  [ -d "$REPO_ROOT/quartz/public" ] || {
    echo "  ✗ public/ 不存在，无法跳过 build" >&2
    exit 1
  }
fi

# === [3/4] 上传 ===
echo "[3/4] 上传到 $DEPLOY_HOST:$DEPLOY_PATH"

if [ "$DRY_RUN" = "1" ]; then
  echo "  （DRY RUN：仅列出待上传文件）"
  if [ "$UPLOAD_TOOL" = "rsync" ]; then
    rsync -az --delete --dry-run -v --exclude=.DS_Store \
      "$REPO_ROOT/quartz/public/" \
      "$DEPLOY_HOST:$DEPLOY_PATH/"
  else
    echo "  scp 模式不支持 dry-run，跳过"
  fi
  echo
  echo "（DRY RUN：未实际写入服务器、未做 HTTP 验证）"
  exit 0
fi

if [ "$UPLOAD_TOOL" = "rsync" ]; then
  ssh "$DEPLOY_HOST" "mkdir -p $DEPLOY_PATH"
  rsync -az --delete --exclude=.DS_Store \
    "$REPO_ROOT/quartz/public/" \
    "$DEPLOY_HOST:$DEPLOY_PATH/"
else
  # scp 降级：先清空远程目录，再全量上传
  echo "  ⚠ scp 模式：清空远程目录后全量上传（较慢）"
  ssh "$DEPLOY_HOST" "rm -rf $DEPLOY_PATH/* && mkdir -p $DEPLOY_PATH"
  scp -r "$REPO_ROOT/quartz/public/." "$DEPLOY_HOST:$DEPLOY_PATH/"
fi
echo "  ✓ 已传输"

# === [4/4] HTTP 验证 ===
echo "[4/4] HTTP 验证"
sleep 1
https_code=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "https://$DEPLOY_DOMAIN/" 2>/dev/null || echo "000")
http_code=$(curl -s -o /dev/null -w "%{http_code}" -m 10 "http://$DEPLOY_DOMAIN/" 2>/dev/null || echo "000")

if [ "$https_code" = "200" ]; then
  echo "  ✓ https://$DEPLOY_DOMAIN/  (HTTPS $https_code)"
elif [ "$http_code" = "200" ]; then
  echo "  ✓ http://$DEPLOY_DOMAIN/   (HTTP $http_code)"
  echo "  ⚠ 尚未配置 HTTPS，参考 references/deployment-nginx-vps.md"
elif [ "$http_code" = "301" ] || [ "$http_code" = "302" ]; then
  echo "  ✓ http://$DEPLOY_DOMAIN/   (HTTP $http_code → 跳转，可能跳 HTTPS)"
  echo "  https://  返回: $https_code"
else
  echo "  ✗ HTTP=$http_code  HTTPS=$https_code"
  echo "  排查: ssh $DEPLOY_HOST 'tail -30 /var/log/nginx/error.log'"
  exit 1
fi

echo
echo "═══════════════════════════════════════════════"
echo "  部署完成"
echo "═══════════════════════════════════════════════"
