# X.com 发布稿

主推荐：**Thread（5 条）**，比单条更能讲清楚 + 拿到更多 reach。
若想最简，直接发"主推"那一条。

---

## 单条版（简）

```
Built a tiny Rust/Tauri desktop browser called Pouch.

It opens any URL as its own window and runs your own JavaScript on it. Tampermonkey-style @match headers, scripts as plain .js files, no browser extension, no developer-mode toggle.

MIT. https://github.com/leaker/pouch
```

字符数 ~270，压在 280 内。

---

## Thread 版（推荐）

**1/4 (主推)**

```
I built a small Rust/Tauri desktop browser called Pouch.

It runs your Tampermonkey-style userscripts on any website — without a browser extension, without a developer-mode toggle.

https://github.com/leaker/pouch
```

**2/4**

```
Each URL opens in its own window — real cookies, real origin, multi-window shares storage.

So a site you use daily can live in its own dock icon, with its own userscripts pinned to it.
```

**3/4**

```
Drop a .js file into an inject/ folder with a @match header. It runs at document_start, before the page's own JS.

Each script gets its own try/catch — one script throwing doesn't break the others.

Why not Tampermonkey? Post-MV3 it needs users to flip a developer-mode toggle. Pouch has no such friction.
```

**4/4**

```
MIT licensed, Rust + Tauri v2.

macOS:    brew install --cask leaker/tap/pouch
Windows:  scoop install pouch  (after adding the bucket)

https://github.com/leaker/pouch
```

---

## 发布注意

- X 的 "post composer"：https://x.com/compose/post
- Thread：第一条发完后点 "+" 添加下一条
- 配图建议：截一张 Pouch 的 macOS 主窗口 / 配置文件 highlight 的图片，提升点击率（但今天先不带图发也行）
