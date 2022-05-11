---
title: 'VS里std::max和max宏混淆问题的解决方案'
tags:
  - algorithm
  - max
  - min
  - std
id: 849
categories:
  - programing
date: 2015-02-09T11:27:16+08:00
---

有时,把旧项目转换成新版本项目时,旧版本项目里使用的 **max** 和 **min** 宏无法在新版本中正常编译.

原因是: 新版本内有了新的函数 **std::max** 和 **std::min** 函数来实现这一功能

#### 这时可以尝试使用如下方案解决:

1. 包含algorithm文件
```cpp
#include <algorithm>
```
2. 明确使用 **std::max(a,b)** 而非 **max(a,b)**
3. 定义宏 NOMINMAX
```cpp
#define NOMINMAX
```
