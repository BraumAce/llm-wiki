"""
通过 Chrome CDP 抓取微信公众号文章
使用 Playwright 连接 Chrome，利用用户已登录的 cookie 绕过验证
"""

import sys
import json
import time
from playwright.sync_api import sync_playwright

def fetch_wechat_article(url: str, output_file: str = None):
    """抓取单篇微信文章"""
    with sync_playwright() as p:
        # 使用用户 Chrome 配置（保留 cookie）
        user_data_dir = r"C:\Users\BraumAce\AppData\Local\Google\Chrome\User Data"

        browser = p.chromium.launch_persistent_context(
            user_data_dir,
            channel="chrome",
            headless=False,  # 非无头模式，绕过检测
            args=[
                "--disable-blink-features=AutomationControlled",
                "--disable-infobars",
            ],
            viewport={"width": 1280, "height": 900},
            ignore_default_args=["--enable-automation"],
        )

        page = browser.new_page()

        # 设置 User-Agent 避免被检测
        page.set_extra_http_headers({
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
        })

        print(f"正在访问: {url}")
        page.goto(url, wait_until="networkidle", timeout=30000)

        # 等待内容加载
        time.sleep(2)

        # 检查是否有验证页面
        if "环境异常" in page.content() or "完成验证" in page.content():
            print("⚠️  检测到验证页面，尝试等待用户操作...")
            # 等待用户手动完成验证（最多 60 秒）
            try:
                page.wait_for_selector("#js_content", timeout=60000)
            except:
                print("❌ 验证超时，无法获取内容")
                browser.close()
                return None

        # 提取文章内容
        article = page.evaluate("""() => {
            const title = document.querySelector('#activity-name')?.textContent?.trim() || '';
            const author = document.querySelector('#js_name')?.textContent?.trim() || '';
            const publishTime = document.querySelector('#publish_time')?.textContent?.trim() || '';
            const content = document.querySelector('#js_content');

            let text = '';
            if (content) {
                // 获取纯文本，保留段落结构
                const walker = document.createTreeWalker(
                    content,
                    NodeFilter.SHOW_TEXT,
                    null,
                    false
                );
                let node;
                const lines = [];
                while (node = walker.nextNode()) {
                    const t = node.textContent.trim();
                    if (t) lines.push(t);
                }
                text = lines.join('\\n');
            }

            // 也获取 HTML 以保留代码块
            const html = content ? content.innerHTML : '';

            return { title, author, publishTime, text, html };
        }""")

        browser.close()

        if not article["text"]:
            print("❌ 未获取到文章内容")
            return None

        print(f"✅ 成功获取: {article['title']}")
        print(f"   作者: {article['author']}")
        print(f"   字数: {len(article['text'])}")

        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(article, f, ensure_ascii=False, indent=2)
            print(f"   保存到: {output_file}")

        return article


def fetch_batch(urls: list, output_dir: str):
    """批量抓取"""
    import os
    os.makedirs(output_dir, exist_ok=True)

    results = []
    for i, url in enumerate(urls):
        print(f"\n[{i+1}/{len(urls)}] 处理中...")
        safe_name = url.split("/")[-1][:20]
        output_file = os.path.join(output_dir, f"{safe_name}.json")
        result = fetch_wechat_article(url, output_file)
        results.append({"url": url, "success": result is not None})
        time.sleep(2)  # 避免请求过快

    return results


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python fetch_wechat.py <url> [output_file]")
        print("      python fetch_wechat.py --batch <urls.json> <output_dir>")
        sys.exit(1)

    if sys.argv[1] == "--batch":
        with open(sys.argv[2], "r") as f:
            urls = json.load(f)
        results = fetch_batch(urls, sys.argv[3])
        print(f"\n完成: {sum(1 for r in results if r['success'])}/{len(results)} 成功")
    else:
        url = sys.argv[1]
        output = sys.argv[2] if len(sys.argv) > 2 else None
        fetch_wechat_article(url, output)
