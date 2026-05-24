#!/usr/bin/env bash
# llm-wiki status: 知识库统计快照
# 用法: scripts/status.sh   (从项目根执行)

set -uo pipefail

WIKI_DIR="${WIKI_DIR:-$(pwd)/ai-wiki/wiki}"
RAW_DIR="${RAW_DIR:-$(pwd)/ai-wiki/raw}"
META="$WIKI_DIR/_meta.json"

count_md() {
  local dir="$1"
  [ -d "$dir" ] || { echo 0; return; }
  find "$dir" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' '
}

count_chars() {
  local dir="$1"
  [ -d "$dir" ] || { echo 0; return; }
  find "$dir" -name '*.md' -type f -print0 2>/dev/null \
    | xargs -0 cat 2>/dev/null \
    | LC_ALL=C.UTF-8 tr -d '[:space:][:punct:]' \
    | wc -m | tr -d ' '
}

ENTITIES=$(count_md "$WIKI_DIR/entities")
TOPICS=$(count_md "$WIKI_DIR/topics")
SOURCES=$(count_md "$WIKI_DIR/sources")
WORDS=$(count_chars "$WIKI_DIR")

RECENT=0
if [ -d "$WIKI_DIR" ]; then
  RECENT=$(find "$WIKI_DIR" -name '*.md' -type f -mtime -7 2>/dev/null | wc -l | tr -d ' ')
fi

RAW_FILES=0
if [ -d "$RAW_DIR" ]; then
  RAW_FILES=$(find "$RAW_DIR" -type f \( -name '*.md' -o -name '*.txt' -o -name '*.pdf' \) 2>/dev/null | wc -l | tr -d ' ')
fi

LAST_LINT="—"
if [ -f "$META" ] && command -v jq >/dev/null 2>&1; then
  LAST_LINT=$(jq -r '.last_lint // "—"' "$META")
fi

cat <<EOF
LLM Wiki Status
===============
实体数:     $ENTITIES
主题数:     $TOPICS
来源数:     $SOURCES
总字数:     $WORDS
最近 7 天:  $RECENT 个文件更新
原始素材:   $RAW_FILES 个文件 (raw/)
最后 lint:  $LAST_LINT
EOF

# --- Graph 摘要（轻量预览，仅读已有 _graph.json，不重写） ---
GRAPH="$WIKI_DIR/_graph.json"
if [ -f "$GRAPH" ] && command -v jq >/dev/null 2>&1; then
  GRAPH_GENERATED=$(jq -r '.generated_at // "—"' "$GRAPH")
  GRAPH_NODES=$(jq -r '.stats.nodes // 0' "$GRAPH")
  GRAPH_EDGES=$(jq -r '.stats.edges // 0' "$GRAPH")
  GRAPH_ORPHANS=$(jq -r '.stats.orphan_links | length' "$GRAPH")
  echo ""
  echo "Graph 摘要 (生成于 $GRAPH_GENERATED)"
  echo "==============="
  echo "节点:       $GRAPH_NODES"
  echo "边:         $GRAPH_EDGES"
  echo "孤儿链接:   $GRAPH_ORPHANS"
  echo "Top 3 入度:"
  jq -r '
    .edges
    | group_by(.to)
    | map({to: .[0].to, indeg: ([.[].weight] | add)})
    | sort_by(-.indeg)
    | .[0:3]
    | .[] | "  \(.indeg)  \(.to)"
  ' "$GRAPH"
  # 时效提示：图谱晚于最近 wiki 改动则提示重跑
  if [ -d "$WIKI_DIR" ]; then
    NEWER=$(find "$WIKI_DIR" -name '*.md' -type f -newer "$GRAPH" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$NEWER" -gt 0 ]; then
      echo ""
      echo "提示: 有 $NEWER 个 .md 文件晚于图谱更新时间，建议重跑 scripts/graph.sh"
    fi
  fi
else
  if [ ! -f "$GRAPH" ]; then
    echo ""
    echo "提示: 未找到 _graph.json，运行 scripts/graph.sh 生成知识图谱"
  fi
fi
