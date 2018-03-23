title: Windows下编译使用zlib库的程序时出现“无法解析的外部符号 _compress”解决方案
tags:
  - compress
  - windows
  - zlib
id: 444
categories:
  - programing
date: 2013-07-01 05:29:47
---
# 错误描述
**error LNK2019: unresolved external symbol _compress referenced**

# 解决方案
在 **#include <zlib.h>** 之前加上 **#define ZLIB_WINAPI**
```cpp
#define ZLIB_WINAPI
#include <zlib.h>
```
