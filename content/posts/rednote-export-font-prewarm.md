---
title: "记一次 RedNote 卡片导出的性能调优——从 4 秒卡顿到 1 秒流畅"
date: 2026-05-04T00:45:30+08:00
categories:
  - programing
tags:
  - performance
  - html-to-image
  - font
  - browser
  - qwik
---

# 起因

最近写了一个小工具：把一段 Markdown 渲染成 6 张小红书风格的 PNG 卡片，然后打包成 ZIP 让用户下载。写完跑了一下，撞见一个反常的现象：

* 单张卡片导出大约 200ms，体感很流畅
* 但点 **Download All as ZIP** 一次导出 6 张，整个过程要 4 ~ 7 秒

数学不对。6 × 200ms 应该是 1.2 秒左右，怎么也不应该是 4 秒以上。

把每一步的耗时打出来后，看到一个明显的冷热交替：

| 卡片序号 | toBlob 耗时 |
| ------- | ----------- |
| 1       | 1300 ms     |
| 2       | 212 ms      |
| 3       | 1205 ms     |
| 4       | 187 ms      |
| 5       | 1189 ms     |
| 6       | 210 ms      |

奇数张全部在 1.2 秒上下，偶数张稳定在 200ms 出头。结果就是 6 张总耗时 ~4.3 秒。

# 第一轮假设：字体内联导致 GC 抖动

ipecho.io 的卡片为了在导出的 SVG 里保留中文字体，需要把字体文件以 base64 形式塞进 `@font-face`，也就是 [`html-to-image`](https://github.com/bubkoo/html-to-image) 的 `buildFontEmbedCSS` 那一套。我用的字体（思源黑体 + 一点 emoji 兜底）跑下来 fontEmbedCSS 大约 8MB。

我的第一反应：**8MB CSS 嵌进每张卡的 SVG，每张卡分配 ~16MB 字符串，两张卡累计 ~32MB 正好够触发 V8 major GC**。奇数张那次卡顿就是 GC stop-the-world，偶数张在新生代里拷贝就快了。

听起来很合理，于是开始按这个假设动手。

# 失败的尝试 1：共享 offscreen host

思路是：让所有卡片共享一个挂在 `document.body` 上的 offscreen host，把 8MB 的 `<style>@font-face`只挂一次，所有卡渲染时复用。

结果：**4.3 秒 → 30 秒，恶化了将近 7 倍。**

排查了一下才反应过来：8MB CSS 一旦挂到 `document.body`，就进了**全局 `document.styleSheets`**。`html-to-image` 在 cloneNode + inline-styles 阶段会对每个克隆出来的节点遍历 styleSheets 做 CSSOM 匹配，等于每张卡都要把这 8MB 走一遍。等于把原本只在 SVG 里一次产生的成本，亲手挪到整个 DOM 上反复吃。

立刻回退。

# 失败的尝试 2：换 modern-screenshot

[`modern-screenshot`](https://github.com/qq15725/modern-screenshot) 的 README 里写着 "2-4x faster than html-to-image"，那就换换看。

结果：**4.3 秒 → 7.2 秒，反而更慢。**

把每张卡的耗时再打出来，看到一个挺反直觉的现象：modern-screenshot 下根本没有冷热交替，6 张稳稳地全都是 1200ms。也就是说，原版 html-to-image 那个 200ms 的"快路径"其实是**它内部某条隐性 cache 起的作用**——modern-screenshot 重写的时候顺手把这条 cache 路径优化掉了，看起来更"现代"，代价是失去了这条本来能复用的 warm path。

回退。

# 失败的尝试 3：用 blob URL 替换 base64 字体

再换个思路：8MB 的 `data:font/woff2;base64,...` 大头都在 base64 编码本身。换成 `blob:http://localhost/xxx` 这种 URL，引用只要几 KB，浏览器还能跨卡片缓存同一个 Blob。

写完跑了一下，pixel diff 直接 = 0，字体没渲染出来。

往下挖才看清楚：导出走的是 `<img src="data:image/svg+xml,...">` 这条路径，浏览器把里面的 SVG 当成 **opaque origin** 上下文。而 `blob:` URL 是 same-origin scoped 的，跨上下文 fetch 直接被同源策略挡住。安全模型层面就走不通，没得绕。

# 一个反常观察推翻了假设

前面几招都走不通，索性反复多跑几轮，看能不能撞出点别的线索。还真撞到一件挺奇怪的事：**同一个会话里再点一次 Download，6 张卡的总时间从 4.3 秒直接掉到 1 秒**。

要真是 GC 触发，每次 ZIP 都该重现冷热抖动才对。可这次抖动**只在第一次跑的时候出现**——第二次同样的代码、同样的字体、同样的数据，6 张全是 warm path：

| 卡片序号 | 第二次 toBlob 耗时 |
| ------- | ------------------ |
| 1       | 198 ms             |
| 2       | 162 ms             |
| 3       | 175 ms             |
| 4       | 168 ms             |
| 5       | 183 ms             |
| 6       | 154 ms             |

**总计 ~1 秒**。

浏览器内部有一层看不见的全局持久缓存。第一次 ZIP 那 4.3 秒里，大头其实是一次性的预热成本：

* base64 解码 8MB woff2
* woff2 二级解压
* font tables 解析 + glyph cache 构建
* V8 在 html-to-image 那条调用链上的 JIT hot path 形成

这套预热做完一次，整个 tab 生命周期里都还命中。回头再看冷热交替——其实就是**奇数张刚好在为下一种新字体做预热**，偶数张正好跑在已经预热好的路径上。根本不是 GC，是按需分摊的预热成本。

# 真正的解药：pre-warm

既然第一次跑就相当于在预热，那让用户**永远遇不到这个第一次**就好了。

办法很朴素：在用户实际点 Download 之前，先悄悄在后台跑一次极小的 dummy export，用同一份 fontEmbedCSS 把整条导出链路完整走一遍，把浏览器的缓存先填好。

实现要点：

1. 在 `useVisibleTask$` 里挂 `requestIdleCallback`，避免和首屏渲染抢 main thread
2. 创建一个 50×50 的 off-screen `<div>`，复用已有的 `exportCardToPng` 函数，`pixelRatio: 1` 跑一次
3. 模块级维护一个 `Set<fontFamilyId>`，每个会话每个字体只 warm 一次

```ts
const warmedFonts = new Set<string>();

export async function prewarmFont(fontFamilyId: string) {
  if (warmedFonts.has(fontFamilyId)) return;
  warmedFonts.add(fontFamilyId);

  const idle = (cb: () => void) =>
    'requestIdleCallback' in window
      ? (window as any).requestIdleCallback(cb, { timeout: 2000 })
      : setTimeout(cb, 0);

  idle(async () => {
    const { exportCardToPng } = await import('./export-card');
    const dummy = document.createElement('div');
    dummy.style.cssText =
      'position:fixed;left:-9999px;top:-9999px;width:50px;height:50px;';
    dummy.textContent = '预热';
    document.body.appendChild(dummy);
    try {
      await exportCardToPng(dummy, { pixelRatio: 1, fontFamilyId });
    } catch {
      // 预热失败不影响业务
    } finally {
      dummy.remove();
    }
  });
}
```

这里有个 Qwik 特有的小坑：`exportCardToPng` 这个函数体很大，依赖了 html-to-image，要是直接在 `useVisibleTask$` 顶层 import，QRL 会试图把它序列化进客户端 chunk，bundle 当场爆炸。改成在 task 内部用 `await import()` 做 dynamic import，就绕过去了。

# 实测结果

加上 pre-warm 之后第一次 Download All as ZIP 的耗时表：

| 卡片序号 | 加预热后 toBlob 耗时 |
| ------- | -------------------- |
| 1       | 215 ms               |
| 2       | 178 ms               |
| 3       | 192 ms               |
| 4       | 165 ms               |
| 5       | 203 ms               |
| 6       | 171 ms               |

**总计 ~1.1 秒**，跟"用户点第二次"的体感几乎完全一致。

相当于把那 ~3 秒的预热成本，悄悄塞进了用户阅读页面的那几秒空闲里。等到他真去点 Download，已经站在 warm path 上了，体感永远只剩那 1 秒。

顺手写下来留个底，免得下次再被同样的 warm path 现象绕一遍。
