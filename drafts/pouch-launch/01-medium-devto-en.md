# I built a desktop browser that runs your userscripts without a browser extension

For a while now I've been doing something a bit weird: I take websites I use every day and turn each one into its own standalone desktop app. One window per site, its own icon in the Dock, Cmd+Tab between them like normal apps. It keeps my brain from drowning in 40 browser tabs.

That part is easy enough — Fluid, Webcatalog, even just `Cmd+Shift+A` on Chrome will do it. The part that kept bothering me was something else.

## The thing that kept bothering me

Every one of those sites had one or two things I wanted to change.

A floating popup that nags me every visit. A panel where the font is two pixels too small. An ad slot I'd rather hide. A dark-mode CSS that's *almost* right except for one ugly color.

DevTools is great for this — for about thirty seconds. Edit the CSS, see it live, feel clever, hit reload, watch all your changes vanish.

So you reach for Tampermonkey or Violentmonkey. Which still works for me personally, but I noticed something annoying: these extensions, in the post-MV3 world, increasingly require the user to flip a "developer mode" toggle and explicitly "allow user scripts" before anything runs. Fine for me. Not fine when I want to recommend a small fix to a non-technical friend — walking them through Chrome flags is more friction than the fix is worth.

So I built [Pouch](https://github.com/leaker/pouch).

## What it actually is

Pouch is a desktop browser, in Rust + Tauri v2. macOS and Windows builds, both signed/notarized. It does two things:

**1. It turns any URL into a standalone window.** One TOML file lists the URLs you want; Pouch opens each in its own window, sharing cookies/storage with the others. Origin is the real site — login state, sessions, everything works the way Safari or Edge would handle it. No rewriting, no proxy magic.

**2. It runs your JavaScript on the page at `document_start`.** Drop a `.js` file into an `inject/` folder with a Tampermonkey-style `@match` header, and Pouch injects it before the page's own scripts have a chance to run. You can override `window.fetch`, install hooks, hide elements, add keyboard shortcuts — anything a userscript can do, with no browser extension involved and no "enable developer mode" flag to flip first.

The interesting bit isn't either piece on its own — it's that the two together replace the entire awkward "userscript ecosystem" with three components: a TOML file, a folder of `.js` files, and an icon in your Dock.

## What the config looks like

Everything lives in one TOML:

```toml
startup_urls = ["https://www.example.com"]
window_dimensions = "inherit"

ignore_urls = [
  { suffix = "gstatic.com" },
  { suffix = "googletagmanager.com" },
  { suffix = "google-analytics.com" },
  { wildcard = "*.google.com" },
]
```

`ignore_urls` lets you exempt certain URLs from Pouch's internal request handling — typically analytics endpoints, font CDNs, third-party telemetry. Four match modes (host suffix, host wildcard, URL wildcard, URL regex) ordered by increasing precision, so you reach for whichever is cheapest.

## Injecting scripts

If you want to inject your own JavaScript, drop a `.js` file under `inject/` with a Tampermonkey-style header:

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

A few details worth knowing:

- Scripts run at **document_start**, before the page's own JavaScript. You can override `window.fetch` or install hooks before anything has a chance to read them.
- Each script runs in its own try/catch. A thrown error in one doesn't break the others.
- `@match` is glob by default; prefix with `regex:` for a real regex.
- A script without `@match` is skipped at scan time — on purpose, so a forgotten header can't accidentally run a script globally.
- SPA route changes don't re-trigger scripts (no real navigation happens). Hook `history.pushState` yourself if you need that.

## A real example

The use case I personally hit most often: a site has a popup that nags me on every visit. Five lines of userscript at `document_start` kills it for good:

```js
// ==UserScript==
// @name   kill popup
// @match  https://www.example.com/*
// ==/UserScript==

new MutationObserver(() => {
  document.querySelector('.popup-banner')?.remove();
}).observe(document.documentElement, { childList: true, subtree: true });
```

That file lives at `~/Library/Application Support/Pouch/inject/example.com/kill-popup.js`. It runs every time Pouch loads that domain. Nothing to enable, no permission prompts, no syncing to any server.

The same pattern handles every other minor annoyance: hide an element, fix a typo in a label, add a keyboard shortcut, auto-expand a collapsed section, auto-redirect on a slow logout flow. Everything that used to be "I wish I could just…" is now a 10-line file.

## Things that look small but matter

**Multiple windows share storage.** List several `startup_urls`, get several windows — same cookies, same localStorage. Effectively "multiple tabs from one browser, but each in its own OS window." Surprisingly useful when one account spans several dashboards.

**Three buttons in the macOS title bar.** Reveal the data folder in Finder, reload from config, toggle DevTools. The reveal-folder one is what I press most — "I just edited a CSS file, where does it actually live on disk again?" One click.

**First-launch certificate prompt.** Pouch needs to view and modify HTTPS traffic, so it asks the OS once for cert trust on first launch. Approve once, never again.

## Installing

macOS via Homebrew:

```bash
brew install --cask leaker/tap/pouch
```

Windows via Scoop (the portable zip avoids SmartScreen):

```powershell
scoop bucket add leaker https://github.com/leaker/scoop-bucket
scoop install pouch
```

Or grab a `.dmg`/`.exe` from the [releases page](https://github.com/leaker/pouch/releases/latest).

## Who this is for

I think Pouch is most useful if you:

- Already turn favorite websites into "apps" and want them to be *yours*
- Want userscripts without convincing every device's browser to enable developer mode
- Maintain a personal patch on top of a third-party tool that won't ship the fix
- Want to share a small fix with a non-technical friend without walking them through extension permissions

It's *not* trying to be a general browser. No ad blocker, no password manager, no extension ecosystem. If you want those, keep using Chrome or Firefox and you're set.

## Open source

MIT, Rust + Tauri v2, on GitHub: [github.com/leaker/pouch](https://github.com/leaker/pouch).

The motivation was honestly just personal frustration: post-MV3 userscript extensions ask too much of the user before they'll even run, Electron wrappers were too heavy for "wrap-a-website" duty, DevTools edits don't persist. So I built the thing I wanted. It turned out to be useful enough that all my "daily driver" websites now run inside it, each with a small patch of mine attached.

If you've ever thought "I wish I could just change *one thing* about this website" — give it a try.
