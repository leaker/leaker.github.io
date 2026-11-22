---
title: "给 Mac 输入法加上边打字边翻译：灵译输入法 RimeLingo"
date: 2026-11-23T00:00:00+08:00
categories:
  - works
tags:
  - rimelingo
  - rime
  - macos
  - swift
  - input-method
  - translation
---

# 起因

我写东西习惯先用中文把意思打出来，要发英文或日文的时候再翻译一遍。流程是打完、复制、切到翻译工具、贴回来，要么就是从输入法的 AI 菜单里点翻译。每次都不长，但每次都断一下。

Gboard 有个翻译输入，打字的时候译文就跟在旁边，满意了直接上屏，我一直想在 Mac 上有一个。用 macOS 的快捷指令凑过一次，键盘触发的时候弹出来的是一个输入对话框，拿不到选中的文字。从菜单里点倒是能用，但那就和原来一样了。

所以干脆改输入法本身。灵译输入法（RimeLingo）基于开源的 [AIME](https://github.com/zoolapp/aime)，引擎是 [RIME](https://rime.im)，平时的拼音输入沿用它们的，我加的是翻译这一块。仓库在 [leaker/rime-lingo](https://github.com/leaker/rime-lingo)。

# 用起来是这样

在任意输入框按 {{< kbd "⌃⌥⌘E" >}}（译成英文）或 {{< kbd "⌃⌥⌘J" >}}（译成日文），然后照常打中文。译文出现在光标旁边，中文改了它跟着变。{{< kbd "⌥↩" >}} 上屏译文，{{< kbd "↩" >}} 上屏中文。

![边打中文边出英文翻译](/images/2026/11/rimelingo-live-translation.webp)

已经写好的文字也行：选中一段，按同样的快捷键，{{< kbd "⌥↩" >}} 替换选区。网页正文和 PDF 这种只读内容里的选区读不到，这个没办法。

![选中文字翻译](/images/2026/11/rimelingo-selection.webp)

翻译默认走 macOS 自带的本机翻译，要开着 Apple 智能，文字不出这台 Mac。也可以在设置里填一个兼容 OpenAI API 的在线服务，这时文字才会发到你填的地址，并且要在设置里单独允许一次。除了英文日文，别的语言可以在设置里加，每种配一个快捷键。

![设置里的翻译页](/images/2026/11/rimelingo-settings-translation.webp)

![安装窗口](/images/2026/11/rimelingo-dmg.webp)

首次安装后我自己先踩了一个：输入法能选中，中文英文都打不出来。系统日志里是这个：

```text
imklaunchagent: LaunchInputMethod() Error, status=-50
```

负责拉起输入法的系统进程从登录起就一直在跑，不认识刚装的输入法。注销再登录，或者执行下面这行就好：

```bash
killall imklaunchagent TextInputMenuAgent TextInputSwitcher
```


# 最后

MIT 许可，代码在 [github.com/leaker/rime-lingo](https://github.com/leaker/rime-lingo)，网站是 [rimelingo.keworks.dev](https://rimelingo.keworks.dev/)。设置界面目前只有中文。
