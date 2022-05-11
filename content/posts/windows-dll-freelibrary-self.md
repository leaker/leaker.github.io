---
title: Windows下的DLL卸载本身模块的方法
tags:
  - dll
  - FreeLibrary
  - FreeLibraryAndExitThread
  - windows
id: 845
categories:
  - programing
date: 2015-01-16T01:35:37+08:00
---

在 Windows 里 DLL 卸载自身模块是无法通过字节调用 FreeLibrary 自己来实现的。

## 原因分析

> 在当前线程中调用 FreeLibrary 后，当前模块就会立即被释放掉，而当前线程还没有运行结束。所以程序就运行到了一块不可访问的内存里，产生异常从而导致程序崩溃。

## 解决方案

> Windows 里面 提供了一条可以用来释放自身模块的函数 **FreeLibraryAndExitThread** 可以释放自身。

函数
```cpp
VOID WINAPI FreeLibraryAndExitThread(_In_ HMODULE hLibModule, _In_ DWORD dwExitCode)
```
    