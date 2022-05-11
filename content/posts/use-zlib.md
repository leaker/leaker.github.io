---
title: 自己使用过程中使用zlib链接时出的错误总结
tags:
  - comment
  - lib
  - link
  - LNK2005
  - pragma
  - SAFESEH
  - static
  - zlib
id: 548
categories:
  - programing
date: 2013-10-04T06:37:29+08:00
---
# 错误1
**error LNK2019: unresolved external symbol _deflateEnd@4**

## 原因1: 未使用zlib的链接库
* 解决：
```cpp
#pragma comment(lib, "zlibstat.lib") // for static lib
#pragma comment(lib, "zdll.lib") // for dll lib
```

## 原因2：在使用静态库时即使包含了zlibstat.lib没有定义宏“ZLIB_WINAPI”
* 解决：
在项目属性中 C/C++ -> Preprocessor -> Preprocessor Definitions 添加“ZLIB_WINAPI”
注意：这个必须在项目中添加，使用#define来添加是无效的。

# 错误2
**error LNK2026: module unsafe for SAFESEH image**

## 原因：两个项目SAFESEH设置不同
* 解决：
设置项目属性: Linker -> Advanced -> [Image Has Safe Exception Handlers] = "No"
*注意：这个必须在项目中添加，使用#pragma来添加是无效的。*

# 错误3
**error LNK2005: __call_reportfault already defined in LIBCMTD.lib(invarg.obj)或类似其他的error LNK2005:**

## 原因：与libcmt库冲突了
* 解决：
```cpp
#pragma comment(linker, "/NODEFAULTLIB:libcmt.lib")
```
