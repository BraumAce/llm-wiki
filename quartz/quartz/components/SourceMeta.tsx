import { QuartzComponentConstructor, QuartzComponentProps } from "./types"
import style from "./styles/sourceMeta.scss"

export default (() => {
  function SourceMetaComponent({ fileData, displayClass }: QuartzComponentProps) {
    const fm = fileData.frontmatter
    if (!fm || fm.type !== "source") return null

    const sourceUrl = fm.source_url as string | undefined
    const author = fm.author as string | undefined
    const sourceType = fm.source_type as string | undefined

    if (!sourceUrl && !author && !sourceType) return null

    const items: string[] = []
    if (sourceType) {
      const typeLabels: Record<string, string> = {
        webpage: "🌐 网页",
        wechat: "💬 微信公众号",
        x: "🐦 X/Twitter",
        zhihu: "📕 知乎",
        xiaohongshu: "📕 小红书",
        youtube: "▶️ YouTube",
        pdf: "📄 PDF",
        local: "📁 本地",
      }
      items.push(typeLabels[sourceType] || `📎 ${sourceType}`)
    }
    if (author) {
      items.push(`✍️ ${author}`)
    }

    return (
      <div class={`source-meta ${displayClass ?? ""}`}>
        {items.length > 0 && (
          <p class="source-meta-details">
            {items.map((item, i) => (
              <>
                {i > 0 && <span class="source-meta-sep"> · </span>}
                <span>{item}</span>
              </>
            ))}
          </p>
        )}
        {sourceUrl && (
          <p class="source-meta-link">
            <a href={sourceUrl} target="_blank" rel="noopener noreferrer">
              🔗 查看原文
            </a>
          </p>
        )}
      </div>
    )
  }

  SourceMetaComponent.css = style

  return SourceMetaComponent
}) satisfies QuartzComponentConstructor
