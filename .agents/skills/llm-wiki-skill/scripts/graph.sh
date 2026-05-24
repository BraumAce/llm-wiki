#!/usr/bin/env bash
# llm-wiki graph: 解析 [[wikilink]] 关系，输出 _graph.json
# 用法:
#   scripts/graph.sh                       # 默认写到 ai-wiki/wiki/_graph.json
#   WIKI_DIR=/path/to/wiki scripts/graph.sh
#   OUT=/tmp/graph.json scripts/graph.sh

set -uo pipefail

export WIKI_DIR="${WIKI_DIR:-$(pwd)/ai-wiki/wiki}"
export OUT="${OUT:-$WIKI_DIR/_graph.json}"

if [ ! -d "$WIKI_DIR" ]; then
  echo "✗ 找不到 wiki 目录: $WIKI_DIR"
  exit 1
fi

python3 - <<'PY'
import os, re, json, glob, datetime

WIKI_DIR = os.environ['WIKI_DIR']
OUT = os.environ['OUT']

TYPES = {'entities': 'entity', 'topics': 'topic', 'sources': 'source'}
# index.md 中的 [[entities]] [[topics]] [[sources]] 是分类锚，不是真实节点
SKIP_LINKS = {'entities', 'topics', 'sources'}

def parse_frontmatter(text):
    m = re.match(r'^---\n(.*?)\n---', text, re.DOTALL)
    if not m:
        return {}
    fm = m.group(1)
    title_match = re.search(r'^title:\s*"?(.+?)"?\s*$', fm, re.M)
    # tags 支持 block 列表与 inline 数组两种写法
    tags = []
    block = re.search(r'^tags:\s*\n((?:\s+-\s+.+\n?)+)', fm, re.M)
    if block:
        tags = [m.group(1).strip().strip('"') for m in re.finditer(r'\s+-\s+(.+)', block.group(1))]
    inline = re.search(r'^tags:\s*\[(.+?)\]', fm, re.M)
    if inline:
        tags = [t.strip().strip('"') for t in inline.group(1).split(',') if t.strip()]
    return {
        'title': title_match.group(1) if title_match else '',
        'tags': tags,
    }

# Pass 1: 节点
nodes = []
node_ids = set()
for subdir, ntype in TYPES.items():
    for path in sorted(glob.glob(os.path.join(WIKI_DIR, subdir, '*.md'))):
        nid = os.path.splitext(os.path.basename(path))[0]
        if nid.startswith('_'):
            continue
        node_ids.add(nid)
        with open(path, encoding='utf-8') as f:
            text = f.read()
        fm = parse_frontmatter(text)
        nodes.append({
            'id': nid,
            'type': ntype,
            'title': fm.get('title', nid),
            'tags': fm.get('tags', []),
        })

# Pass 2: 边（按 [[link]] 计数）
edges_count = {}
orphan_links = set()
for subdir in TYPES:
    for path in sorted(glob.glob(os.path.join(WIKI_DIR, subdir, '*.md'))):
        src = os.path.splitext(os.path.basename(path))[0]
        if src.startswith('_'):
            continue
        with open(path, encoding='utf-8') as f:
            text = f.read()
        # 跳过 frontmatter 头中的 [[link]]——这些是 sources/related_entities 字段引用，
        # 也算作边。保留全文扫描即可
        for m in re.finditer(r'\[\[([^\]\n]+)\]\]', text):
            tgt = m.group(1).strip()
            if tgt in SKIP_LINKS:
                continue
            if tgt == src:
                continue
            if tgt not in node_ids:
                orphan_links.add(tgt)
                continue
            key = (src, tgt)
            edges_count[key] = edges_count.get(key, 0) + 1

edges = [{'from': s, 'to': t, 'weight': w} for (s, t), w in edges_count.items()]
edges.sort(key=lambda e: (e['from'], e['to']))

# 度统计
in_deg = {}
out_deg = {}
for e in edges:
    in_deg[e['to']] = in_deg.get(e['to'], 0) + e['weight']
    out_deg[e['from']] = out_deg.get(e['from'], 0) + e['weight']

graph = {
    'generated_at': datetime.datetime.now().astimezone().isoformat(timespec='seconds'),
    'wiki_dir': WIKI_DIR,
    'stats': {
        'nodes': len(nodes),
        'edges': len(edges),
        'edge_weight_total': sum(e['weight'] for e in edges),
        'orphan_links': sorted(orphan_links),
        'by_type': {t: sum(1 for n in nodes if n['type'] == t) for t in ('entity', 'topic', 'source')},
    },
    'nodes': sorted(nodes, key=lambda n: (n['type'], n['id'])),
    'edges': edges,
}

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, 'w', encoding='utf-8') as f:
    json.dump(graph, f, ensure_ascii=False, indent=2)

# 控制台报告
print(f"✓ 写入: {OUT}")
print(f"  节点: {len(nodes)} {graph['stats']['by_type']}")
print(f"  边:   {len(edges)} (权重合计 {graph['stats']['edge_weight_total']})")
if orphan_links:
    print(f"  孤儿链接: {sorted(orphan_links)}")

# Top in-degree
print("\nTop 10 入度（被引用最多）:")
for nid, d in sorted(in_deg.items(), key=lambda x: -x[1])[:10]:
    ntype = next((n['type'] for n in nodes if n['id'] == nid), '?')
    print(f"  {d:3d}  [{ntype}] {nid}")
PY
