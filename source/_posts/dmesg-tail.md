title: 一句话经验
tags:
  - dmesg
  - tail
id: 599
categories:
  - linux
date: 2014-04-08 00:37:23
---

当内核加载失败时，使用以下命令查看出错记录，可以帮助找到问题所在：
```bash
dmesg | tail -n 30
```
