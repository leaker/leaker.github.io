---
categories:
- summarys
date: 2014-03-30 05:05:56+08:00
id: 594
tags: []
title: Alienware系列 COMPAL Embedded System Control 驱动问题解决方案
---

每次重装系统后，装驱动很容易有一个名为“COMPAL Embedded System Control”的驱动未安装。
而使用驱动精灵等驱动智能安装类的软件安装后很容易出现驱动显示是装好了，但会提示个感叹号说明该设备无法正常工作。

网上搜了半天终于找到一个说法：
这个驱动是热量控制，64位win7/win8无法完全安装设备管理器里更新驱动然后手动定位到C盘ProgramData里的Vista64安装即可

尝试后问题解决。
记录此文章，留给跟我出现同样问题的朋友。希望能有所帮助。