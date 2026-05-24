#!/usr/bin/env bash
# llm-wiki lint: 校验知识库健康度
# 用法: scripts/lint.sh   (从项目根执行；或设 WIKI_DIR 环境变量)

set -uo pipefail

WIKI_DIR="${WIKI_DIR:-$(pwd)/ai-wiki/wiki}"
ENTITIES_DIR="$WIKI_DIR/entities"
TOPICS_DIR="$WIKI_DIR/topics"
SOURCES_DIR="$WIKI_DIR/sources"

if [ ! -d "$WIKI_DIR" ]; then
  echo "✗ 找不到 wiki 目录: $WIKI_DIR"
  echo "  请先运行 init workflow"
  exit 1
fi

ERRORS=0
err() { echo "  ✗ $*"; ERRORS=$((ERRORS+1)); }

# --- 1. 链接一致性 ---
echo "[1/5] 链接一致性..."
# 提取所有 [[link]]，去重；macOS bash 3.2 兼容（不用 mapfile）
links=$(
  find "$WIKI_DIR" -name '*.md' -type f -exec grep -oh '\[\[[^]]*\]\]' {} + 2>/dev/null \
    | sort -u \
    | sed 's/^\[\[//; s/\]\]$//' \
    | grep -v '^$' || true
)
if [ -n "$links" ]; then
  while IFS= read -r link; do
    [ -z "$link" ] && continue
    # 跳过分类索引（entities/topics/sources 是 index.md 的入口锚，不是实体）
    case "$link" in entities|topics|sources) continue ;; esac
    if ! find "$ENTITIES_DIR" "$TOPICS_DIR" "$SOURCES_DIR" -maxdepth 1 -name "${link}.md" 2>/dev/null | grep -q .; then
      err "孤儿链接 [[$link]] —— 找不到对应文件"
    fi
  done <<< "$links"
fi

# --- 2. 实体页字数 ---
echo "[2/5] 实体页字数 (≥1500 字符)..."
if [ -d "$ENTITIES_DIR" ]; then
  while IFS= read -r -d '' f; do
    # 中文字符数：去掉空白、ASCII 标点。粗略但够用
    chars=$(LC_ALL=C.UTF-8 tr -d '[:space:][:punct:]' < "$f" | wc -m | tr -d ' ')
    if [ "$chars" -lt 1500 ]; then
      err "$(basename "$f") 仅 $chars 字 (要求 ≥1500)"
    fi
  done < <(find "$ENTITIES_DIR" -maxdepth 1 -name '*.md' -type f -print0 2>/dev/null)
fi

# --- 3. 占位符 ---
echo "[3/5] 占位符 (TODO/XXX/待补充/TBD)..."
# 跳过 ``` 代码块和 `行内代码` —— 里面的 TODO 通常是源码引用，不是真的"待补充"
while IFS= read -r -d '' f; do
  cleaned=$(awk '
    BEGIN {in_fence=0}
    /^```/ {in_fence=!in_fence; next}
    in_fence==1 {next}
    {gsub(/`[^`]*`/, ""); print}
  ' "$f")
  if echo "$cleaned" | grep -qE '(TODO|XXX|待补充|TBD)'; then
    err "占位符出现在: ${f#$WIKI_DIR/}"
  fi
done < <(find "$WIKI_DIR" -name '*.md' -type f -print0 2>/dev/null)

# --- 4. frontmatter sources 非空 ---
echo "[4/5] frontmatter sources 非空 (entities + topics)..."
check_sources() {
  local f="$1"
  # 取 frontmatter 段（第一对 --- 之间）
  local fm
  fm=$(awk '/^---$/{c++; next} c==1' "$f")
  if ! echo "$fm" | grep -qE '^sources:'; then
    err "$(basename "$f") 缺少 sources 字段"
    return
  fi
  # sources 是空数组或下面没列表
  if echo "$fm" | grep -qE '^sources: *\[\] *$'; then
    err "$(basename "$f") sources 为空数组"
  fi
}
for d in "$ENTITIES_DIR" "$TOPICS_DIR"; do
  [ -d "$d" ] || continue
  while IFS= read -r -d '' f; do
    check_sources "$f"
  done < <(find "$d" -maxdepth 1 -name '*.md' -type f -print0 2>/dev/null)
done

# --- 5. 主题页核心要点 ≥5 ---
echo "[5/5] 主题页核心要点 (≥5)..."
if [ -d "$TOPICS_DIR" ]; then
  while IFS= read -r -d '' f; do
    points=$(awk '
      /^## 核心要点/ {flag=1; next}
      /^## / {flag=0}
      flag && /^[0-9]+\./ {n++}
      END {print n+0}
    ' "$f")
    if [ "$points" -lt 5 ]; then
      err "$(basename "$f") 核心要点仅 $points 条 (要求 ≥5)"
    fi
  done < <(find "$TOPICS_DIR" -maxdepth 1 -name '*.md' -type f -print0 2>/dev/null)
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✓ lint 通过"
  exit 0
else
  echo "✗ lint 失败: $ERRORS 个问题"
  exit 1
fi
