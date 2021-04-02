title: 如何使gedit能够编辑和保存到所属root用户的目录中
tags:
  - gedit
  - gksudo
  - root
  - sudo
  - ubuntu
id: 67
categories:
  - linux
date: 2012-03-20 19:08:43
---

<center>{% img /wp-content/uploads/2012/03/gedit.webp %}</center>

# 解决方案
为了能让gedit能够直接编辑不属于当前用户的文件，我们需要做如下操作：

1. 为gedit创建一个启动器。这个有很多方法，如果不清楚的同学可以跟我一起操作。
   具体方法为：找到 **应用程序-附件-文本编辑器** 点右键选择 **将此启动器添加到面板**
2. 右键点击刚才我们创建的启动器。选择 **属性** 将原命令 **gedit %U** 修改为 **gksudo gedit %U**

> **gksudo** 其实就是对应桌面环境下的 **sudo** 命令.

我才学到的留以记录，希望能帮到需要的人。
