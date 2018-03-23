title: 'error LNK2026: module unsafe for SAFESEH image 解决方案'
tags:
  - Advanced
  - c
  - error
  - image
  - Linker
  - LNK2026
  - module
  - SAFESEH
  - unsafe
id: 545
categories:
  - programing
date: 2013-10-03 15:21:16
---
# 解决方案
下面两种随便选一种
## 方法1
去掉项目设置中: **Linker -> Advanced -> [Image Has Safe Exception Handlers] = "No"**

## 方法2
直接在代码中:
```cpp
#pragma comment(linker, "/SAFESEH:NO")
```
