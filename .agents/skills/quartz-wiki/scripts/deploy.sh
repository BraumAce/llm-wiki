#!/usr/bin/env bash
# deploy.sh — 本地 build + rsync 部署 llm-wiki 到远程 nginx 服务器
#
# 用法（从任意位置）:
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh                # 完整流程
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh --skip-build   # 仅 rsync 已有 public/
#   bash .agents/skills/quartz-wiki/scripts/deploy.sh --dry-run      # rsync 干跑（不实际传输）
#
# 环境变量（可覆盖默认值）:
#   DEPLOY_HOST    SSH 目标，必填，例如 user@server.example.com
#   DEPLOY_PATH    服务器路径，必填，例如 /var/www/llm-wiki
#   DEPLOY_DOMAIN  验证域名，必填，例如 wiki.example.com

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"
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
      sed -n '2,15p' "$0"
      exit 0
      ;;
  esac
done

require_env() {
  local name="$1"
  local value="${!name:-}"
  if [ -z "$value" ]; then
    echo "  ✗ 缺少环境变量 $name" >&2
    echo "    请通过 shell export 或命令前缀设置。" >&2
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

for cmd in rsync npm ssh curl; do
  if ! command -v "$cmd" >/dev/null; then
    echo "  ✗ 未找到 $cmd" >&2
    exit 1
  fi
done

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

if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$DEPLOY_HOST" 'command -v rsync >/dev/null'; then
  echo "  ✗ 远程 $DEPLOY_HOST 未安装 rsync" >&2
  echo "    修复: ssh $DEPLOY_HOST 'dnf install -y rsync'  (或 apt install rsync)" >&2
  exit 1
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
  npm run quartz -- build
  cd "$REPO_ROOT"
else
  echo "[2/4] 跳过 build（--skip-build）"
  [ -d "$REPO_ROOT/quartz/public" ] || {
    echo "  ✗ public/ 不存在，无法跳过 build" >&2
    exit 1
  }
fi

# === [3/4] Rsync ===
echo "[3/4] rsync 到 $DEPLOY_HOST:$DEPLOY_PATH"
RSYNC_FLAGS="-az --delete --exclude=.DS_Store"
[ "$DRY_RUN" = "1" ] && RSYNC_FLAGS="$RSYNC_FLAGS --dry-run -v"

if [ "$DRY_RUN" = "0" ]; then
  ssh "$DEPLOY_HOST" "mkdir -p $DEPLOY_PATH"
fi
# shellcheck disable=SC2086
rsync $RSYNC_FLAGS \
  "$REPO_ROOT/quartz/public/" \
  "$DEPLOY_HOST:$DEPLOY_PATH/"
echo "  ✓ 已传输"

if [ "$DRY_RUN" = "1" ]; then
  echo
  echo "（DRY RUN：未实际写入服务器、未做 HTTP 验证）"
  exit 0
fi

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
