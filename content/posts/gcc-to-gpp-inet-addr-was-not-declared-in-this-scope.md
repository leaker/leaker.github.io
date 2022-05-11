---
title: gcc迁移到g++出现 inet_addr was not declared in this scope 解决方案
tags:
  - declared
  - g++
  - gcc
  - inet_addr
id: 427
categories:
  - programing
date: 2013-06-07T14:06:31+08:00
---
# 错误原因
我手上一个项目本身采用gcc编译。后来因为代码功能需要移植到g++中时，出现了 **"inet_addr" was not declared in this scope** 这个错误。

# 解决方案
```cpp
// 添加该头文件
#include <arpa/inet.h>
```

# 如果出现下面错误：
```text
error: string: No such file or directory
error: vector: No such file or directory
```
* 说明在将g++项目用gcc编译
