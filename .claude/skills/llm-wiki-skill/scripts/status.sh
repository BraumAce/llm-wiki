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
