---
categories:
- summarys
date: 2012-10-21 10:27:59+08:00
id: 332
tags: []
title: VMware装Win7时网卡驱动问题处理
---

1. 用文本编辑器打开虚拟机的vmx文件 例如：Win7.vmx

2. 解决方法是在文本最后加入如下信息：
```text
ethernet0.virtualDev = "e1000"
```

**记得要先关闭虚拟机哦！**
