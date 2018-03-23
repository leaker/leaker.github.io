title: "在使用boost库时发生 error C4996: 'std::_Copy_impl' 的解决方案"
tags:
  - boost
  - C4996
  - is_any_of
  - mfc
  - split
  - string
id: 578
categories:
  - programing
date: 2013-11-23 13:21:44
---
原本的程序是控制台的。
但最近需要移植到windows下使用。
所以以MFC来做UI，代码照搬。
一面的一处代码使用了如下语句：
```cpp
boost::split(v, data, boost::is_any_of(_T("n")));
```

结果编译时出现了如下错误：
```text
error C4996: 'std::_Copy_impl'
```

而且是无论怎么修改都不认，差点打算重写了。

在网络中搜索了半天未果，只能自己分析。好在被我乱猜给猜对了。

我猜是因为boost的string和std的string产生了冲突而导致的。
所以添加上boost的string引用后，问题得以解决。
```cpp
#include <boost/algorithm/string.hpp>
```
在此留字，希望能帮到遇到同样问题的人。
