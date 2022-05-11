---
categories:
- notices
date: 2021-03-12 03:21:50+08:00
tags: []
title: 卸载 hexo-prism-plugin 代码高亮插件
---
最近用 **Github** 比较频繁，无意间点开 **GitHub Pages** 的代码库时发现一个大大的 **Dependabot alerts** 顶在上面
![](/images/2021/03/github-dependabot-alerts.webp)

点开后发现最大的一个警告就是这个：
![](/images/2021/03/highlightjs-alerts.webp)

顺着这个 **dependencies** 一路追查发现是 **hexo-prism-plugin** 这个插件使用的
由于该插件太久没更新，而且发现 [hexo.io](https://hexo.io) 最新版本已经集成了 **prism** 的代码高亮功能
所以更新 **Hexo** 版本并启用自带的代码高亮功能应该就可以解决了

# 解决方法
1. 卸载 **hexo-prism-plugin** 插件
2. 更新所有相关 **dependencies** 到最新版本
3. 配置 **_config.yml**

```yml _config.yml
prismjs:
  enable: true
  preprocess: true
  line_number: true
  tab_replace: '    '
```

4. 重新生成


引用文章： [Syntax Highlighting | Hexo](https://hexo.io/docs/syntax-highlight)
