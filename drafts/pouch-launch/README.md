# Pouch 发布套件

仓库：github.com/leaker/pouch
中文介绍文章：`../../content/posts/introduce-pouch.md`（2026-05-24 首发）

## 项目描述偏好

主推角度：**零摩擦的 userscript 注入**——独立 desktop app、Tampermonkey 风格 `@match`、`document_start` 注入、不需要让用户去开发者模式里勾"允许用户脚本"。

**不要再用"persistent on-disk overrides / file swap / DevTools Local Overrides"这类卖点**：那条路径需要用户额外去浏览器里禁用 Network 缓存，macOS 上做不到。

写新稿子时：

1. 标题 / 简介只讲脚本注入
2. 正文里 ignore_urls / overrides 之类内部机制点到为止
3. 不举"改 CSS 文件改字号"那种 file-swap 示例

## 草稿文件清单

- `01-medium-devto-en.md` — 英文长文（Medium / Dev.to 共用底稿）
- `02-show-hn.md` — Show HN 标题 + 首楼自评
- `03-reddit-variants.md` — 4 个 subreddit 的稿件 + 直达提交链接
- `04-x-tweet.md` — X.com 单条 / thread 版
- `05-linkedin-ja.md` — LinkedIn 日文长文

## 各平台发布情况（2026-05-24 首发，后续按描述偏好统一更新）

| 平台 | 状态 |
| ---- | ---- |
| Dev.to（英文） | ✅ 已发布 + 已按新偏好更新 |
| Medium（账号 Illiten） | ✅ 已发布 + 已按新偏好更新 |
| LinkedIn（日文） | ✅ 已发布 + 已按新偏好更新 |
| X.com（英文，单条） | ✅ 已发布（按 X 文化不再编辑） |
| Hacker News | ❌ 账号 too-new 受阻，本轮未发出 |
| Reddit r/rust、r/tauri、r/programming、r/SideProject | ⏳ 草稿就绪，需人工从 `03-reddit-variants.md` 的直达链接发 |
