---
title: 基于 Tailwind CSS 的 Box 布局
date: 2022-10-12T20:45:05+08:00
categories:
- programing
tags:
- html
- css
- style
- layout
- tailwind
---

# Header Content Footer 布局

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tailwind CSS Box Layout</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style type="text/tailwindcss">
      html,
      body {
        font-family: ui-monospace, SFMono-Regular, SF Mono, Menlo, Consolas, Liberation Mono, monospace;
        color: #c9d1d9;
        background-color: #0d1117;
      }
    </style>
  </head>

  <body>
    <div id="box" class="flex flex-col h-screen justify-between">
      <header class="border-b p-5">Header</header>
      <main class="flex flex-1 flex-col justify-center items-center mb-auto h-auto bg-gray-900">Content</main>
      <footer class="flex justify-center items-center border-t border-gray-800 p-6">Footer</footer>
    </div>
  </body>
</html>
```

[线上预览](https://codepen.io/leaker/pen/WNJLaQd)

# 预览

![](/images/2022/10/box-layout.webp)