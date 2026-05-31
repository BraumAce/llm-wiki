"""
通过 Playwright 抓取微信公众号文章 v3
启动可见 Chrome 窗口，用户可手动完成验证
"""

import sys
import json
import time
import os

# Fix encoding for Windows
sys.stdout.reconfigure(encoding='utf-8')

from playwright.sync_api import sync_playwright

OUTPUT_DIR = r"D:\Projects\llm-wiki\ai-wiki\raw\wechat"

WECHAT_URLS = [
    ("Harness-Engineering-来了-SDD-还有意义吗", "https://mp.weixin.qq.com/s/Laz4W0180y9yGW0b6EpUMQ"),
    ("学习笔记-从-Agent-到-Skills", "https://mp.weixin.qq.com/s/RMh2JqHwkjonPTZlwVKxsw"),
    ("Claude-Code-Skills-完全指南", "https://mp.weixin.qq.com/s/M-K8cDwLhpID1gkcZOdUkQ"),
    ("JavaGuide-LLM基础扫盲", "https://mp.weixin.qq.com/s/ZAipp74rijevYjFkzbswjw"),
    ("一文讲透从0构建AI-Agent", "https://mp.weixin.qq.com/s/SAXIAnJ3NtVWPeA-oHIsQA"),
    ("以OpenClaw为例介绍AI-Agent的运作原理", "https://mp.weixin.qq.com/s/78mBt_5efHrTD7tChBRcTw"),
    ("龙虾大脑核心揭秘1", "https://mp.weixin.qq.com/s/29luo-js2RONAMJ2b7lXbQ"),
    ("业务逻辑的坍塌", "https://mp.weixin.qq.com/s/kVE6an0dqnO34SQnRXddWg"),
    ("让AI变成Super员工的秘密", "https://mp.weixin.qq.com/s/JU_PmeOgSNUbNFdl-AIGKQ"),
    ("知识基座-让AI越用越懂业务", "https://mp.weixin.qq.com/s/P-p4-BH8AAOnTBRcpsoKeQ"),
]


def extract_article(page):
    """从页面提取文章内容"""
    return page.evaluate("""() => {
        const title = (document.querySelector('#activity-name')?.textContent || '').trim();
        const author = (document.querySelector('#js_name')?.textContent || '').trim();
        const publishTime = (document.querySelector('#publish_time')?.textContent || '').trim();
        const contentEl = document.querySelector('#js_content');

        if (!contentEl) return { title, author, publishTime, text: '' };

        // 递归提取文本
        function walk(el) {
            let result = '';
            for (const child of el.childNodes) {
                if (child.nodeType === 3) {
                    const t = child.textContent.trim();
                    if (t) result += t + '\\n';
                } else if (child.nodeType === 1) {
                    const tag = child.tagName.toLowerCase();
                    if (tag === 'br') {
                        result += '\\n';
                    } else if (tag === 'pre' || tag === 'code') {
                        result += '```\\n' + child.textContent.trim() + '\\n```\\n';
                    } else if (tag === 'img') {
                        const alt = child.getAttribute('alt') || '';
                        if (alt) result += '[图片: ' + alt + ']\\n';
                    } else if (tag === 'strong' || tag === 'b') {
                        result += '**' + child.textContent.trim() + '**';
                    } else {
                        result += walk(child);
                        if (['p', 'div', 'section', 'h1', 'h2', 'h3', 'h4', 'li', 'blockquote', 'tr'].includes(tag)) {
                            result += '\\n';
                        }
                    }
                }
            }
            return result;
        }

        const text = walk(contentEl);
        return { title, author, publishTime, text };
    }""")


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("=" * 60)
    print("  微信公众号文章抓取工具 (Playwright)")
    print("=" * 60)
    print()
    print("将打开 Chrome 窗口，自动逐篇访问文章。")
    print("如果出现验证页面，请手动完成验证。")
    print()

    with sync_playwright() as p:
        # 启动可见的 Chrome
        browser = p.chromium.launch(
            headless=False,
            channel="chrome",
            args=[
                "--disable-blink-features=AutomationControlled",
                "--no-first-run",
            ]
        )

        context = browser.new_context(
            viewport={"width": 1280, "height": 900},
            locale="zh-CN",
        )

        # 注入脚本隐藏自动化特征
        context.add_init_script("""
            Object.defineProperty(navigator, 'webdriver', { get: () => false });
        """)

        page = context.new_page()

        results = []

        for i, (name, url) in enumerate(WECHAT_URLS):
            print(f"\n[{i+1}/{len(WECHAT_URLS)}] {name}")
            print(f"  URL: {url}")

            try:
                page.goto(url, wait_until="domcontentloaded", timeout=30000)
                time.sleep(3)

                # 检查是否需要验证
                page_content = page.content()
                if "环境异常" in page_content or "完成验证" in page_content:
                    print("  >> 检测到验证页面，请在浏览器中手动完成验证...")
                    print("  >> 完成后按 Enter 继续...")
                    input()
                    time.sleep(2)

                # 尝试等待文章加载
                try:
                    page.wait_for_selector("#js_content", timeout=10000)
                except:
                    print("  >> 文章内容未加载，跳过")
                    results.append({"name": name, "url": url, "success": False})
                    continue

                # 提取内容
                article = extract_article(page)

                if article["text"] and len(article["text"]) > 100:
                    # 保存
                    output_file = os.path.join(OUTPUT_DIR, f"{name}.md")
                    md = f"""# {article['title']}

- 作者: {article['author']}
- 发布时间: {article['publishTime']}
- 原文链接: {url}

---

{article['text']}
"""
                    with open(output_file, "w", encoding="utf-8") as f:
                        f.write(md)

                    print(f"  [OK] 已保存 ({len(article['text'])} 字)")
                    results.append({"name": name, "url": url, "title": article["title"], "success": True})
                else:
                    print("  [FAIL] 内容为空或过短")
                    results.append({"name": name, "url": url, "success": False})

            except Exception as e:
                print(f"  [ERROR] {e}")
                results.append({"name": name, "url": url, "success": False})

            time.sleep(2)

        # 保存汇总
        summary = os.path.join(OUTPUT_DIR, "_fetch_results.json")
        with open(summary, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)

        success = sum(1 for r in results if r["success"])
        print(f"\n{'='*60}")
        print(f"  完成: {success}/{len(results)} 成功")
        print(f"  保存目录: {OUTPUT_DIR}")
        print(f"{'='*60}")

        browser.close()


if __name__ == "__main__":
    main()
