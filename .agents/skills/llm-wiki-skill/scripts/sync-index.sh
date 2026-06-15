#!/usr/bin/env bash
# llm-wiki sync-index: 用文件系统真实计数刷新首页 index.md 的「状态」区
#   - 重写 "- 实体数：N ｜ 主题数：M ｜ 来源数：K" 行
#   - 重写 "- 最后更新：YYYY-MM-DD" 行（默认今天，可传参覆盖）
#   - 若有 jq，顺带把 _meta.json 的 stats.{entities,topics,sources} 同步成同一组计数
# 只动这几个机械派生的数字；叙述性的「最近更新」条目由 ingest 流程手动追加。
#
# 用法: scripts/sync-index.sh [YYYY-MM-DD]   (从项目根执行；或设 WIKI_DIR 环境变量)

set -uo pipefail

WIKI_DIR="${WIKI_DIR:-$(pwd)/ai-wiki/wiki}"
INDEX="$WIKI_DIR/index.md"
META="$WIKI_DIR/_meta.json"
DATE="${1:-$(date +%F)}"

if [ ! -f "$INDEX" ]; then
  echo "✗ 找不到首页: $INDEX"
  exit 1
fi

count_md() {
  local dir="$1"
  [ -d "$dir" ] || { echo 0; return; }
  find "$dir" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' '
}

ENTITIES=$(count_md "$WIKI_DIR/entities")
TOPICS=$(count_md "$WIKI_DIR/topics")
SOURCES=$(count_md "$WIKI_DIR/sources")

# --- 刷新 index.md 状态行（整行替换，按行首锚点匹配） ---
tmp=$(mktemp)
awk -v e="$ENTITIES" -v t="$TOPICS" -v s="$SOURCES" -v d="$DATE" '
  /^- 实体数：/   { print "- 实体数：" e " ｜ 主题数：" t " ｜ 来源数：" s; hit_count=1; next }
  /^- 最后更新：/ { print "- 最后更新：" d; hit_date=1; next }
  { print }
  END {
    if (!hit_count) print "WARN_NO_COUNT_LINE" > "/dev/stderr"
    if (!hit_date)  print "WARN_NO_DATE_LINE"  > "/dev/stderr"
  }
' "$INDEX" > "$tmp" 2>"$tmp.warn"

if grep -q 'WARN_NO_COUNT_LINE' "$tmp.warn" 2>/dev/null; then
  echo "✗ index.md 未找到 '- 实体数：' 状态行，未改动。请检查首页格式。"
  rm -f "$tmp" "$tmp.warn"; exit 1
fi
mv "$tmp" "$INDEX"
rm -f "$tmp.warn"

echo "✓ index.md 状态已刷新：实体 $ENTITIES ｜ 主题 $TOPICS ｜ 来源 $SOURCES ｜ 最后更新 $DATE"

# --- 顺带同步 _meta.json stats（需 jq；只改 stats 三个计数，不动 sources 列表） ---
if [ -f "$META" ] && command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  if jq --argjson e "$ENTITIES" --argjson t "$TOPICS" --argjson s "$SOURCES" \
       '.stats.entities=$e | .stats.topics=$t | .stats.sources=$s' "$META" > "$tmp" 2>/dev/null; then
    mv "$tmp" "$META"
    echo "✓ _meta.json stats 已同步（entities=${ENTITIES} topics=${TOPICS} sources=${SOURCES}）"
  else
    rm -f "$tmp"
    echo "⚠ _meta.json 解析失败，已跳过 stats 同步，请手动核对"
  fi
else
  echo "（无 jq 或无 _meta.json，跳过 stats 同步——请手动核对 _meta.json stats）"
fi
