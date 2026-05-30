#!/usr/bin/env bash
# sync-content.sh — 把 ai-wiki/wiki/ 同步到 quartz/content/
#
# 用法（从任意位置）:
#   bash .agents/skills/quartz-wiki/scripts/sync-content.sh
#
# 行为:
#   1. 整体替换 quartz/content/ 内容（删除后重建）
#   2. 排除 _meta.json / _graph.json / .DS_Store
#   3. 输出同步的 markdown 数量
#
# 兼容性: 优先使用 rsync，不可用时降级为 cp + find 清理
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"
SRC="$REPO_ROOT/ai-wiki/wiki"
DEST="$REPO_ROOT/quartz/content"

if [ ! -d "$SRC" ]; then
  echo "错误: 找不到源目录 $SRC" >&2
  exit 1
fi

if [ ! -d "$REPO_ROOT/quartz" ]; then
  echo "错误: 找不到 quartz/ 目录（未初始化 Quartz）" >&2
  exit 1
fi

echo "同步 $SRC -> $DEST"
rm -rf "$DEST"
mkdir -p "$DEST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a \
    --exclude='_meta.json' \
    --exclude='_graph.json' \
    --exclude='.DS_Store' \
    "$SRC/" "$DEST/"
else
  echo "  ⚠ 未找到 rsync，降级为 cp（Windows 兼容模式）"
  cp -r "$SRC/." "$DEST/"
  # 清理 rsync 会排除的文件
  find "$DEST" -name '_meta.json' -delete 2>/dev/null || true
  find "$DEST" -name '_graph.json' -delete 2>/dev/null || true
  find "$DEST" -name '.DS_Store' -delete 2>/dev/null || true
fi

count=$(find "$DEST" -name '*.md' | wc -l | xargs)
echo "已同步 $count 个 markdown 文件"
