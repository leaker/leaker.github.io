# Reddit 各子板块投稿稿件

每个子板块的 rule 略不同，标题与开头都做了针对性微调。

**通用步骤**：点对应"直接提交链接" → 粘贴 Title → 粘贴 Body → 选 flair（如有需要）→ Post。

> Reddit 的 `/submit?type=text` 直接进 self post（讨论帖）模式，跳过"link or text"的二级选项，最省事。

---

## r/rust

**直接提交链接**：https://www.reddit.com/r/rust/submit?type=text

**Title**

```
Pouch — a small Tauri v2 desktop browser that runs Tampermonkey-style userscripts without a browser extension
```

**Body (link post 也行，self post 更易讨论)**

I've been working on a Tauri v2 app called **Pouch** ([github.com/leaker/pouch](https://github.com/leaker/pouch)) — about 99% Rust, a tiny bit of JS for the injected userscript dispatcher.

The idea: open any URL in its own desktop window (Tauri webview, real site origin, real cookies), and run your own JavaScript on it at `document_start`. Tampermonkey-style `@match` headers, multiple scripts per site, each one boxed in its own try/catch. No browser extension involved, no "enable developer mode" toggle, no MV3 lifecycle pain.

Some Rust/Tauri-specific notes:

- The userscript dispatcher is injected via `with_initialization_script`. Scripts are scanned from `inject/` at launch and matched against the frame's `location.href` per request — `@match` is glob by default, prefix with `regex:` for raw regex.
- Multi-window with shared cookies/storage falls out of Tauri v2 naturally — one `WebviewWindow` per `startup_url`, all in the same WebContext.
- The macOS title bar overlays three custom buttons (reveal data folder / reload from config / toggle DevTools) using `tao`/`tauri`'s window decoration hooks; on Windows the app runs without a menu bar to avoid title-bar clutter.
- The updater is `tauri-plugin-updater`-driven on macOS (signed payload, restarts to apply); on Windows it never auto-installs — Scoop installs get a "Copy `scoop update pouch`" button, portable installs get an "Open releases page" button. The reason is brittle Windows updates from interrupted downloads.

MIT, builds with the usual `cargo dev` / `cargo bundle` aliases (see `.cargo/config.toml`). Happy to dig into any of the Rust/Tauri internals — there were some interesting decisions around the injection point and the cert-trust flow on first launch.

---

## r/tauri

**直接提交链接**：https://www.reddit.com/r/tauri/submit?type=text

**Title**

```
Pouch: a Tauri v2 app that turns any URL into a desktop window with Tampermonkey-style userscript injection
```

**Body**

Hi r/tauri — built a small project with Tauri v2 that I thought might be relevant here: [github.com/leaker/pouch](https://github.com/leaker/pouch).

The core idea: open any URL in its own Tauri webview window with real site origin and cookies, then run your own JavaScript on it at `document_start`. Tampermonkey-style `@match` rules, multiple scripts, each in its own try/catch. No browser extension needed, no MV3 lifecycle hassles.

Some Tauri-flavored bits other folks here might find useful:

- **Userscript injection at document_start**: the JS dispatcher is injected via `with_initialization_script`. It scans `inject/` recursively and runs anything whose `@match` rule hits the frame's `location.href`. `@match` is glob by default with a `regex:` prefix for raw regex; scripts are independently isolated so one throwing doesn't break the others.
- **Multi-window with shared storage**: each `startup_url` becomes its own `WebviewWindow` in the same `WebContext`, so cookies/localStorage are shared — basically "multiple tabs but each in their own OS window."
- **Updater split per platform**: `tauri-plugin-updater` for macOS (full auto-update flow), but on Windows I deliberately disable the auto-install path because the install layouts vary (Scoop vs portable .exe vs zip) and a broken install would be worse than a manual one. The Windows dialog instead offers "Copy command" (Scoop) or "Open releases page" (portable).
- **Window dimensions persistence**: VSCode-style `"inherit" / "default" / "maximized" / "fullscreen" / { width, height }`, with the previous session restored from a SQLite DB sibling of the config file.

Code is 99% Rust, MIT, builds with `cargo bundle` / `cargo bundle-universal`. Would love feedback from anyone who's done similar Tauri injection-point or window-management work — there's probably stuff I'm doing the long way around.

---

## r/programming

**直接提交链接**：https://www.reddit.com/r/programming/submit?type=text

> ⚠️ r/programming 对纯 self-promo 不友好，更适合发"技术文章"风格的 link post——指向你博客那篇英文长文（如果有的话）会比发 self post 安全。

**Title**

```
Pouch: a desktop browser that runs your userscripts without a browser extension
```

**Body**

Built a tool that scratches a personal itch: [github.com/leaker/pouch](https://github.com/leaker/pouch).

The premise: turn any URL into a standalone desktop window, and run your own JavaScript on it at `document_start`. Tampermonkey-style `@match` headers, scripts live as plain `.js` files under an `inject/` folder, no browser extension involved.

Why not just use a browser extension? In a post-MV3 world Tampermonkey and Violentmonkey require users to toggle "developer mode" and explicitly allow user scripts before anything runs — fine for me, but awkward to walk a non-technical friend through. Pouch sidesteps that entirely: it's a standalone app, the scripts run because they're shipped with the app, not because the browser was convinced to allow them.

A handful of extras: multi-window mode that shares cookies/storage (one account spanning several dashboards), reveal-data-folder button on the macOS title bar, single TOML config.

Rust + Tauri v2, MIT licensed, signed builds for macOS and Windows. Homebrew/Scoop installable.

---

## r/SideProject

**直接提交链接**：https://www.reddit.com/r/SideProject/submit?type=text

**Title**

```
I built a desktop browser that runs your userscripts without a browser extension — Pouch
```

**Body**

Sharing a side project I've been chipping at: **Pouch** ([github.com/leaker/pouch](https://github.com/leaker/pouch)).

I use a handful of websites every day, each one as its own "app" window. And every one of them has *something* I want to change — a popup that nags me, a font that's too small, an element I'd rather hide. The natural answer is a userscript. But Tampermonkey and friends, after Manifest V3, now require users to flip a "developer mode" toggle and explicitly allow user scripts before anything runs — fine for me, but absolutely the kind of friction I can't recommend to a non-technical friend who just wants the popup gone.

So I built Pouch. Two ideas:

1. **Any URL becomes a standalone desktop window.** One entry in a TOML file, no wrapper code, real cookies and origin, multiple windows share storage.
2. **Drop your .js files into an `inject/` folder, with Tampermonkey-style `@match` headers.** They run at `document_start` — before the page's own JS — and each one is isolated in its own try/catch. No extension, no toggle, no MV3 ceremony.

A few quality-of-life extras: an "ignore list" so analytics/CDN requests don't go through the injection layer, three macOS title-bar buttons (reveal data folder, reload config, toggle DevTools), single TOML config.

Built with Rust + Tauri v2. MIT license. macOS via Homebrew (`brew install --cask leaker/tap/pouch`), Windows via Scoop, or `.dmg`/`.exe` from releases.

All my "daily driver" sites now run inside Pouch with small personal patches attached. Sharing in case anyone else has the same itch.

Happy to take feedback / questions / "have you considered…" suggestions.
