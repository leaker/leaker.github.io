# Show HN 提交内容

## Title（注意 HN 标题强烈不建议 "I built / Look at my..."，去主语化最稳）

```
Show HN: Pouch – Desktop browser that runs your userscripts without a browser extension
```

备选：

```
Show HN: Pouch – Turn any website into a desktop app with built-in userscript injection
Show HN: Pouch – Tampermonkey-style script injection, no extension needed
```

## URL 字段

```
https://github.com/leaker/pouch
```

## 第一条评论（首楼自评，HN 惯例，作者自己解释动机；不要长，3 段以内）

Hey HN — author here.

Pouch is a small Rust/Tauri v2 desktop app. It opens any URL as its own window (real site origin, real cookies, no rewriting) and runs your own JavaScript on it at `document_start`. Tampermonkey-style `@match` headers, scripts as plain `.js` files in an `inject/` folder, each one isolated in its own try/catch.

The motivation was personal. I keep a few sites as "apps" and most of them have one small thing I wish I could change — a popup, a font-size, an element I'd rather hide. Userscripts are the natural fix, but post-MV3 Tampermonkey/Violentmonkey now require users to flip a "developer mode" toggle and explicitly allow user scripts before anything runs — fine for me, awkward to recommend to non-technical friends. Pouch sidesteps that entirely: it's a standalone app, scripts run because they're shipped with the app, not because the browser was talked into allowing them.

Multi-window with shared cookies (one account, several dashboards), single TOML config, reveal-data-folder button on the macOS title bar, signed/notarized builds for macOS + Windows. Homebrew on macOS, Scoop on Windows. Source is MIT.

Happy to answer anything, and roast away on the design choices.

---

## 发布注意

- HN Show 提交页：https://news.ycombinator.com/submit
- 一定要带 "Show HN:" 前缀
- 不能在 24h 内重复提交
- 首楼自评最好等帖子上线后再发，作为 reply 不是修改 url
