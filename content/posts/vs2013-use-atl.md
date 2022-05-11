---
title: VS2013上直接使用ATL的注意事项
tags:
  - atl
  - com
id: 678
categories:
  - programing
date: 2014-11-21T12:15:21+08:00
---

### 不再需要导入atl.lib库了，直接包含以下头文件就可以了
```cpp
#include <atlbase.h>
#include <atlcom.h>
#include <atlctl.h>
```

### 要使用 AtlAxAttachControl 等函数的话，则必须初始化ATL模块
```cpp
CComModule _Module;
_pAtlModule = &_Module;
```
