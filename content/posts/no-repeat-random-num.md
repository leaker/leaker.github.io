---
title: 生成不重复的随机数
tags:
  - algorithms
  - random_shuffle
id: 341
categories:
  - programing
date: 2013-03-15T13:47:47+08:00
---

# 下面代码就可以生成1-100区间的随机数：
```cpp
#include <vector>
#include <algorithms>

std::vector<int> random_numbers;
for (unsigned int i = 0; i < 100; ++i)
    random_numbers.push_back(i + 1);
std::random_shuffle(random_numbers.begin(), random_numbers.end());
```
