"""
通过 Chrome CDP 抓取微信公众号文章 v2
启动独立 Chrome 实例（非 headless），用户可手动完成验证
"""

import sys
import json
import time
import subprocess
import os
from playwright.sync_api import sync_playwright

# 微信文章 URL 列表
WECHAT_URLS = [
    "https://mp.weixin.qq.com/s/Laz4W0180y9yGW0b6EpUMQ",
    "https://mp.weixin.qq.com/s/RMh2JqHwkjonPTZlwVKxsw",
    "https://mp.weixin.qq.com/s/M-K8cDwLhpID1gkcZOdUkQ",
    "https://mp.weixin.qq.com/s/ZAipp74rijevYjFkzbswjw",
    "https://mp.weixin.qq.com/s/SAXIAnJ3NtVWPeA-oHIsQA",
    "https://mp.weixin.qq.com/s/78mBt_5efHrTD7tChBRcTw",
    "https://mp.weixin.qq.com/s/29luo-js2RONAMJ2b7lXbQ",
    "https://mp.weixin.qq.com/s/kVE6an0dqnO34SQnRXddWg",
    "https://mp.weixin.qq.com/s/JU_PmeOgSNUbNFdl-AIGKQ",
    "https://mp.weixin.qq.com/s/P-p4-BH8AAOnTBRcpsoKeQ",
]

OUTPUT_DIR = r"D:\Projects\llm-wiki\ai-wiki\raw\wechat"


def start_chrome_with_debugging():
    """启动带远程调试的 Chrome"""
    chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
    temp_profile = r"D:\Projects\llm-wiki\scripts\chrome_temp_profile"

    os.makedirs(temp_profile, exist_ok=True)

    cmd = [
        chrome_path,
        f"--user-data-dir={temp_profile}",
        "--remote-debugging-port=9222",
        "--no-first-run",
        "--disable-blink-features=AutomationControlled",
        "about:blank"
    ]

    proc = subprocess.Popen(cmd)
    time.sleep(3)  # 等待 Chrome 启动
    return proc


def fetch_article_via_cdp(url: str, page):
    """通过已连接的 CDP 页面抓取文章"""
    print(f"\n正在访问: {url}")
    page.goto(url, wait_until="domcontentloaded", timeout=30000)
    time.sleep(3)

    # 检查是否需要验证
    content = page.content()
    if "环境异常" in content or "完成验证" in content:
        print("⚠️  检测到验证页面！请在浏览器中手动完成验证...")
        print("   完成后按 Enter 继续...")
        input()

    # 等待文章内容加载
    try:
        page.wait_for_selector("#js_content", timeout=15000)
    except:
        print("❌ 未找到文章内容，可能需要验证")
        return None

    # 提取文章
    article = page.evaluate("""() => {
        const title = document.querySelector('#activity-name')?.textContent?.trim() || '';
        const author = document.querySelector('#js_name')?.textContent?.trim() || '';
        const publishTime = document.querySelector('#publish_time')?.textContent?.trim() || '';
        const contentEl = document.querySelector('#js_content');

        if (!contentEl) return { title, author, publishTime, text: '', html: '' };

        // 提取纯文本，保留段落结构
        function extractText(el) {
            let result = '';
            for (const child of el.childNodes) {
                if (child.nodeType === 3) { // Text node
                    const t = child.textContent.trim();
                    if (t) result += t + '\\n';
                } else if (child.nodeType === 1) { // Element node
                    const tag = child.tagName.toLowerCase();
                    if (tag === 'br') {
                        result += '\\n';
                    } else if (tag === 'pre' || tag === 'code') {
                        result += '```\\n' + child.textContent + '\\n```\\n';
                    } else if (tag === 'img') {
                        const alt = child.getAttribute('alt') || '';
                        if (alt) result += alt + '\\n';
                    } else {
                        result += extractText(child);
                        if (['p', 'div', 'h1', 'h2', 'h3', 'h4', 'li', 'blockquote'].includes(tag)) {
                            result += '\\n';
                        }
                    }
                }
            }
            return result;
        }

        const text = extractText(contentEl);
        const html = contentEl.innerHTML;

        return { title, author, publishTime, text, html };
    }""")

    return article


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("=" * 60)
    print("微信公众号文章抓取工具")
    print("=" * 60)

    # 连接到 Chrome CDP
    print("\n正在连接 Chrome CDP (localhost:9222)...")
    print("请确保 Chrome 已启动并开启了远程调试端口")
    print()

    with sync_playwright() as p:
        try:
            browser = p.chromium.connect_over_cdp("http://localhost:9222")
            print("✅ 已连接到 Chrome")
        except Exception as e:
            print(f"❌ 无法连接到 Chrome: {e}")
            print("\n请先在终端运行以下命令启动 Chrome:")
            print(r'  "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir=D:\Projects\llm-wiki\scripts\chrome_temp_profile')
            print("\n或者关闭所有 Chrome 窗口后，我来启动...")
            choice = input("是否自动启动 Chrome？(y/n): ").strip().lower()
            if choice == 'y':
                # 先关闭所有 Chrome
                os.system("taskkill /f /im chrome.exe 2>nul")
                time.sleep(2)
                proc = start_chrome_with_debugging()
                browser = p.chromium.connect_over_cdp("http://localhost:9222")
                print("✅ 已启动并连接 Chrome")
            else:
                return

        context = browser.contexts[0] if browser.contexts else browser.new_context()
        page = context.new_page()

        # 设置中文 UA
        page.set_extra_http_headers({
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        })

        # 逐个抓取
        results = []
        for i, url in enumerate(WECHAT_URLS):
            print(f"\n[{i+1}/{len(WECHAT_URLS)}]")
            article = fetch_article_via_cdp(url, page)

            if article and article["text"]:
                # 生成文件名
                title = article["title"].replace(" ", "").replace("/", "-")[:50]
                safe_name = "".join(c for c in title if c.isalnum() or c in "-_") or f"article_{i}"
                output_file = os.path.join(OUTPUT_DIR, f"{safe_name}.md")

                # 保存为 Markdown
                md_content = f"""# {article['title']}

- 作者: {article['author']}
- 发布时间: {article['publishTime']}
- 原文链接: {url}

---

{article['text']}
"""
                with open(output_file, "w", encoding="utf-8") as f:
                    f.write(md_content)

                print(f"✅ 已保存: {safe_name}.md ({len(article['text'])} 字)")
                results.append({"url": url, "title": article["title"], "success": True})
            else:
                print(f"❌ 抓取失败")
                results.append({"url": url, "success": False})

            time.sleep(2)

        # 保存结果汇总
        summary_file = os.path.join(OUTPUT_DIR, "_fetch_results.json")
        with open(summary_file, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)

        success = sum(1 for r in results if r["success"])
        print(f"\n{'='*60}")
        print(f"完成: {success}/{len(results)} 成功")
        print(f"结果保存到: {OUTPUT_DIR}")

        browser.close()


if __name__ == "__main__":
    main()
