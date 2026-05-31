"""
第三批微信文章抓取
"""

import sys
import json
import time
import os

sys.stdout.reconfigure(encoding='utf-8')

from playwright.sync_api import sync_playwright

OUTPUT_DIR = r"D:\Projects\llm-wiki\ai-wiki\raw\wechat"

WECHAT_URLS = [
    ("软件为何越做越乱", "https://mp.weixin.qq.com/s/Sr_SDdOk80IxgmQZeK3ffQ"),
    ("MCP工具设计技巧", "https://mp.weixin.qq.com/s/wpiROVdoJAHvolkEpYo20w"),
    ("Cursor-Agent流水线CR", "https://mp.weixin.qq.com/s/BtlrcAhqVDv0oIhnoM9hBQ"),
    ("AI-Coding前端实践复盘", "https://mp.weixin.qq.com/s/CqYqbE0HdL7GzLGe_vbMmA"),
    ("规范驱动AI编程指南", "https://mp.weixin.qq.com/s/kLVeNYxfg5xqcxixdttTGQ"),
    ("亿级用户排行榜设计", "https://mp.weixin.qq.com/s/0BM1DItHHwgnrgnzRdk8Gg"),
    ("美团BI指标平台", "https://mp.weixin.qq.com/s/LuCy56KRYk4W-USpDUViyg"),
    ("Superpowers插件攻略", "https://mp.weixin.qq.com/s/n52dg8R2fzgHNIo9XX-HMA"),
    ("AI编程下半场-Agent-Skill", "https://mp.weixin.qq.com/s/ho1l5v5mrNr_f6JXARMlFQ"),
    ("用自然语言替代复杂代码", "https://mp.weixin.qq.com/s/hZgFoLFnAq6-yqd4i1v8ng"),
    ("MySQL-SELECT-索引失效", "https://mp.weixin.qq.com/s/6lzPH4u3HnNjVlFrckNDhw"),
    ("AI-Agent保险业务实践", "https://mp.weixin.qq.com/s/Q9TdK8F8UByCdJjSGAjqaQ"),
    ("火山引擎-OpenClaw内置Mem0", "https://mp.weixin.qq.com/s/9gcyRO_k4dkWRqsszOCiWQ"),
    ("AI-Coding实战报告", "https://mp.weixin.qq.com/s/Gc5P60gqmoXQov3fy0_85A"),
    ("AI-Coding思考范式变革", "https://mp.weixin.qq.com/s/4AXThfVLmhSXeRWK1gh4dA"),
    ("拒绝重复造轮子-AI助手工厂", "https://mp.weixin.qq.com/s/hY-iMyw9faTUtLjvGFw3Bw"),
]


def extract_article(page):
    return page.evaluate("""() => {
        const title = (document.querySelector('#activity-name')?.textContent || '').trim();
        const author = (document.querySelector('#js_name')?.textContent || '').trim();
        const publishTime = (document.querySelector('#publish_time')?.textContent || '').trim();
        const contentEl = document.querySelector('#js_content');
        if (!contentEl) return { title, author, publishTime, text: '' };

        function walk(el) {
            let result = '';
            for (const child of el.childNodes) {
                if (child.nodeType === 3) {
                    const t = child.textContent.trim();
                    if (t) result += t + '\\n';
                } else if (child.nodeType === 1) {
                    const tag = child.tagName.toLowerCase();
                    if (tag === 'br') { result += '\\n'; }
                    else if (tag === 'pre' || tag === 'code') { result += '```\\n' + child.textContent.trim() + '\\n```\\n'; }
                    else if (tag === 'img') { const alt = child.getAttribute('alt') || ''; if (alt) result += '[图片: ' + alt + ']\\n'; }
                    else {
                        result += walk(child);
                        if (['p','div','section','h1','h2','h3','h4','li','blockquote','tr'].includes(tag)) result += '\\n';
                    }
                }
            }
            return result;
        }

        return { title, author, publishTime, text: walk(contentEl) };
    }""")


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False, channel="chrome", args=["--disable-blink-features=AutomationControlled", "--no-first-run"])
        context = browser.new_context(viewport={"width": 1280, "height": 900}, locale="zh-CN")
        context.add_init_script("Object.defineProperty(navigator, 'webdriver', { get: () => false });")
        page = context.new_page()

        results = []
        for i, (name, url) in enumerate(WECHAT_URLS):
            print(f"\n[{i+1}/{len(WECHAT_URLS)}] {name}")
            try:
                page.goto(url, wait_until="domcontentloaded", timeout=30000)
                time.sleep(3)

                if "环境异常" in page.content() or "完成验证" in page.content():
                    print("  >> 请手动完成验证后按 Enter...")
                    input()
                    time.sleep(2)

                try:
                    page.wait_for_selector("#js_content", timeout=10000)
                except:
                    print("  [SKIP]")
                    results.append({"name": name, "success": False})
                    continue

                article = extract_article(page)
                if article["text"] and len(article["text"]) > 100:
                    output_file = os.path.join(OUTPUT_DIR, f"{name}.md")
                    with open(output_file, "w", encoding="utf-8") as f:
                        f.write(f"# {article['title']}\n\n- 作者: {article['author']}\n- 发布时间: {article['publishTime']}\n- 原文链接: {url}\n\n---\n\n{article['text']}")
                    print(f"  [OK] {len(article['text'])} 字")
                    results.append({"name": name, "success": True})
                else:
                    print("  [FAIL]")
                    results.append({"name": name, "success": False})
            except Exception as e:
                print(f"  [ERROR] {e}")
                results.append({"name": name, "success": False})
            time.sleep(2)

        browser.close()

    success = sum(1 for r in results if r["success"])
    print(f"\n完成: {success}/{len(results)} 成功")


if __name__ == "__main__":
    main()
