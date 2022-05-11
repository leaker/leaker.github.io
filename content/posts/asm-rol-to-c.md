---
title: 汇编中ROL(循环左移)对应的C语言实现
tags:
  - ROL
  - ROR
id: 143
categories:
  - programing
date: 2012-04-24T10:48:29+08:00
---

在汇编语言中，我们可以直接使用ROL ROR等指令进行循环左移和循环右移的操作。
但C语言中却没有对应的操作，没办法只能自己实现了。

## 下面是我最近项目中用到的一个针对WORD类型的循环左移(ROL)实现代码：
```cpp
uint16_t ROL(int val, int n)
{
    return (val << n) | (val >> (16 - n));
}
```

针对BYTE类型的循环左移：
```cpp
uint8_t ROL(int val, int n)
{
    return (val << n) | (val >> (8 - n));
}
```

针对DWORD类型的循环左移：
```cpp
uint32_t ROL(int val, int n)
{
    return (val << n) | (val >> (32 - n));
}
```
