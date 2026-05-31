"""
第二批微信文章抓取
"""

import sys
import json
import time
import os

sys.stdout.reconfigure(encoding='utf-8')

from playwright.sync_api import sync_playwright

OUTPUT_DIR = r"D:\Projects\llm-wiki\ai-wiki\raw\wechat"

WECHAT_URLS = [
    ("Claude-Code-最佳实践", "https://mp.weixin.qq.com/s/RBpKqgDmf_S8l4DmaTJTSw"),
    ("Claude-Code-一篇从入门到精通", "https://mp.weixin.qq.com/s/1FIyJ08MaKb6bHY2PGAmbQ"),
    ("Claude-Code-加-OpenSpec加速AICoding", "https://mp.weixin.qq.com/s/aHAJxvrwobUKsPZ3w7GnYw"),
    ("从IDE到Terminal-Claude-Code工作流", "https://mp.weixin.qq.com/s/x9wUAM6QI1Ogv2B0biawbg"),
    ("Claude-工程师亲授-Skills工程化心法", "https://mp.weixin.qq.com/s/VjBNgfDhJSMMlGw5n6RQMA"),
    ("Agent-Skills-Teams架构演进", "https://mp.weixin.qq.com/s/Z8JYgxUdHSLo4ywgyt4ljg"),
    ("腾讯云-兄弟你真的懂Skill吗", "https://mp.weixin.qq.com/s/h9BKGfLgH7GCNEhvwDBYBg"),
    ("Skills开发技能指南", "https://mp.weixin.qq.com/s/uRpg2tDFvH2KboiHLvq0MA"),
    ("一文搞懂Skills原理及实践", "https://mp.weixin.qq.com/s/efGCTgegcE_Zp3G91uH06A"),
    ("打造高可靠AI助手", "https://mp.weixin.qq.com/s/nClVag8tyw7wuG-V1rhmfQ"),
    ("Skills从配角到核心", "https://mp.weixin.qq.com/s/OmA2xcmpXNITxbR5bTsT6w"),
    ("企业级Agent多智能体架构选型", "https://mp.weixin.qq.com/s/_bz8DEgp4Lqt-xTa_lWN0A"),
    ("RAG优化字典-20种方法", "https://mp.weixin.qq.com/s/HR-Y1IEbHix_N3m0VBo9IQ"),
    ("从RAG到GraphRAG-货拉拉", "https://mp.weixin.qq.com/s/AmbfOJJFypnsAkVTjC9eJQ"),
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
                    print("  [SKIP] 未加载")
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
                    print("  [FAIL] 内容为空")
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
