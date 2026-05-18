import path from "path"
import { FilePath } from "./path"
import { globby } from "globby"

export function toPosixPath(fp: string): string {
  return fp.split(path.sep).join("/")
}

export async function glob(
  pattern: string,
  cwd: string,
  ignorePatterns: string[],
): Promise<FilePath[]> {
  const fps = (
    await globby(pattern, {
      cwd,
      ignore: ignorePatterns,
      // gitignore: false (was true upstream) —— 否则 quartz/content/ 被仓库根 .gitignore
      // 屏蔽后整个内容目录被跳过；衍生物排除已经在仓库根 .gitignore 管理
      gitignore: false,
    })
  ).map(toPosixPath)
  return fps as FilePath[]
}
