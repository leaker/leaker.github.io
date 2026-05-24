---
title: "把任意网页变成可改造的桌面 App —— 介绍 Pouch"
date: 2026-05-24T15:20:00+08:00
categories:
  - works
tags:
  - pouch
  - rust
  - tauri
  - webview
  - tampermonkey
  - userscript
---

# 起因

最近几年我有个习惯：常用的网页喜欢"装"成独立的桌面 app。一个窗口一个站，Dock 里独立图标，Cmd+Tab 能切，不会和浏览器里几十个 tab 混在一起。

但用着用着会发现一些挠头的小毛病：

- 网页里有一个浮窗挡视线，每次都要手动关
- 某个面板的字号偏小，眼睛累
- 一段广告位想隐藏掉
- 偶尔想改两行 CSS 让深色模式更耐看一点

这种东西用 DevTools 当场都能改，但代价是**一刷新就没了**。装 Tampermonkey / Violentmonkey 也行，但近一两年这类扩展为了配合浏览器的 MV3 安全策略，默认都要用户去开发者模式里手动勾"允许用户脚本"这种选项才能跑——自己用倒还行，想推荐给身边非技术的朋友用一下，光是讲清楚这几步就够费劲了。更别说有些站点的 JS bundle 我想直接换掉一小段——这种活儿用扩展本来也做不到。

我想要的其实很简单：

1. 任何一个网页，输一行 URL 就能当独立 app 跑
2. 我自己写的 userscript，能用 Tampermonkey 那套 `@match` 语法
3. 网页拉下来的任意资源（JS/CSS/图片/HTML），我都能在本地存一份，改完直接顶上去
4. 改动落到磁盘上，重启不丢

试了一圈现成方案没有完全对得上的，所以索性自己写了一个，叫 [Pouch](https://github.com/leaker/pouch)。Rust + Tauri v2，macOS 和 Windows 都有打好的包。

# 核心思路

Pouch 在概念上其实就两件事：

**第一件，把网页装进窗口里。** 用 Tauri 起一个 webview，cookie、storage、origin 全都是站点真实的那一份，不做任何重写。你登录过的状态、保存过的偏好，跟你在 Safari/Edge 里看完全一样。

**第二件，在 webview 和网络之间夹一层。** 所有出口的 HTTP 请求都先过 Pouch：

- 第一次拉到的响应，扔到本地 `overrides/<host>/<path>` 下，连同 headers 一起存一个 `.meta.json` 兜底
- 下次同样的 URL，**直接从磁盘读**，根本不走网络
- 想改？打开那个文件，编辑保存，下次刷新就是你改完的版本
- 不想要某条本地版本了？删掉文件，Pouch 重新去抓

这就是所谓的 "persist overrides"：网页里看到的所有静态资源，本质上都是你磁盘上的一个文件，可读可写可删。比 DevTools 的 Local Overrides 多了一层无脑持久化——不用一直开着 devtools 面板，不用每次手动配 workspace。

# 配置长什么样

一切都收敛在一个 TOML：

```toml
# 启动时打开哪些 URL，第一条是主窗口，剩下的各自独立窗口、共享 cookie
startup_urls = ["https://www.leelib.com"]

# 窗口初始尺寸：inherit/default/maximized/fullscreen 或自定义 width/height
window_dimensions = "inherit"

# 这些 URL 让它走网络但不要写进 overrides/，避免缓存里塞满 analytics 垃圾
ignore_urls = [
  { suffix = "gstatic.com" },
  { suffix = "googletagmanager.com" },
  { suffix = "google-analytics.com" },
  { suffix = "cdn.jsdelivr.net" },
  { wildcard = "*.google.com" },
]

[updater]
auto_check = true
```

macOS 下这个文件在 `~/Library/Application Support/Pouch/hook.conf.toml`，Windows 下在 `%APPDATA%\Pouch\`。改完按 `Cmd+R`（Windows 重启进程）就生效。

`ignore_urls` 一开始没准备得这么细，后来真用起来才发现是必需品——不加它，你的 `overrides/` 几小时就会被各路埋点和字体 CDN 堵满，过一阵儿连定位"我刚才改的那个文件在哪儿"都费劲。所以四种匹配方式我都留了：host 后缀、host 通配、整 URL 通配、整 URL 正则，按精度递增挑就行。

# 注入脚本

`inject/` 目录下放任意 `.js` 文件，文件头写一个 Tampermonkey 风格的元数据块：

```js
// ==UserScript==
// @name   tweak example
// @match  https://www.example.com/*
// ==/UserScript==

(function () {
  console.log('[tweak] running on', location.host);
  // your tweaks here
})();
```

几条规则值得提一下：

- 脚本运行在 **document_start**，比页面自己的 JS 还早，所以拦改 `window.fetch`、提前注入 hook 都来得及
- 每个脚本各自包在独立的 try/catch 里，一个挂了不会拖累别的
- `@match` 默认是 glob，`*` 跨 `/`；想用正则就写 `@match regex:^https://...`
- 不写 `@match` 的脚本会在扫描阶段被跳过——这是故意的，省得你哪天不小心把全局脚本塞到所有站点里
- iframe 里只跑显式命中的脚本，光写 `@match *` 是不会在 iframe 里运行的；想覆盖 iframe，单独写一条更精确的规则

SPA 的路由切换 **不会** 重新触发脚本（webview 没真正 navigate），如果你想 hook URL 变化，自己挂 `history.pushState` 就行。

# 替换资源的实际用法

举个我自己反复用的小例子：某站点的某个面板字号是 11px，眼睛要瞎了。打开 Pouch 进站，浏览一次让它把 CSS 拖回来，然后：

```
~/Library/Application Support/Pouch/overrides/
└── cdn.example.com/
    └── static/
        ├── site.css
        └── site.css.meta.json
```

用编辑器打开 `site.css`，找到对应的 class，把 `font-size: 11px` 改成 `13px`，保存，回 Pouch 按 `Cmd+R`。完成。

不需要写脚本。不需要写选择器。不需要担心覆盖的 CSS 被什么 specificity 干掉。直接改源头那一份。

带 query string 的 URL 也处理过：`bundle.js?v=1` 会被存成 `bundle.js.__qs_<8 位 hash>__.js`，不同 query 各自一份文件——这样上游悄悄换了一个签名 URL，你之前 pin 在 v=1 的改动也不会"漏"到新版本上去。文件后缀我让它尾巴上再补一遍 `.js`/`.css`，纯粹是为了编辑器能继续给你高亮。

# 一些可能不显眼但其实有用的细节

**多窗口共享 storage。** 配置里 `startup_urls` 写几条，Pouch 就开几个窗口。每个窗口是独立的 webview，但 cookie、localStorage 共享同一份——本质上等价于"同一个浏览器里的多个 tab，只是装在不同 OS 窗口里"。这对一个账号要同时盯多个面板的场景挺香。

**标题栏的三个小按钮（macOS）。** 右上角放了三颗：reveal data folder（直接跳到那一坨 `overrides/`、`inject/` 的位置）、reload from config（重新读 TOML 并重启）、toggle DevTools。原本是为了我自己调试方便，后来发现日常用最多的居然是第一个——改完文件想看磁盘上长啥样，按一下就完事。

**安装走 Homebrew 和 Scoop。** macOS：

```bash
brew install --cask leaker/tap/pouch
```

Windows：

```powershell
scoop bucket add leaker https://github.com/leaker/scoop-bucket
scoop install pouch
```

Windows 走 Scoop 是有意为之的——portable zip 不会被 SmartScreen 拦下来。没装包管理器的话，[Releases 页](https://github.com/leaker/pouch/releases/latest)有 `.dmg` 和 `.exe` 直接下。

**HTTPS 证书提示。** 第一次启动 Pouch 会要一次系统级的信任提示——它需要本地 CA 才能看到、改写 HTTPS 流量。点一次同意，之后再启动都不会再问。

# 适合用 Pouch 吗？

我自己常拿它做几件事：

1. **常驻型网页变 app。** 工作里某个内部仪表盘、某个 webmail、某个 SaaS 控制台——Cmd+Tab 切起来比 tab 快得多
2. **给老旧 web 应用打补丁。** 厂商不更新了，但有个我每天用的 bug；写 5 行 userscript 永久治好
3. **给设计粗糙的页面改皮肤。** 直接改 CSS 文件，不用绕 `!important` 大战
4. **抓本地化 / mock 用。** 偶尔需要把某段返回固定下来做演示，把 JSON response 存成 override 即可

不适合的场景也很明显：你想要 ad block、想要密码管理、想要扩展生态——那应该继续用 Chrome/Firefox + 扩展。Pouch 没那个野心，它只想做"webview + 一个简单粗暴的本地资源覆盖层"。

# 最后

代码全开源，MIT，地址在 [github.com/leaker/pouch](https://github.com/leaker/pouch)。

写这个东西的初衷其实挺朴素：我想要的能力浏览器扩展给不了，Electron 套壳又太重，DevTools 又不持久，那就自己造一个。结果造着造着发现还挺好用——常用的几个网页都已经被我塞进去当独立 app 跑了，每个都带着我自己的几行小补丁，挺安心。

如果你也常觉得"这个网页要是能再改一点点就好了"，可以试试。
