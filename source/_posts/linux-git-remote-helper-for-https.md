title: "Linux里Git出现fatal: Unable to find remote helper for 'https'的解决方案"
tags:
  - fatal
  - git
  - https
  - linux
id: 837
categories:
  - linux
date: 2014-12-30 23:42:43
---

在Linux内源码编译安装的Git如果出现了 “**Unable to find remote helper for 'https'**” 错误，则说明**编译的时候没有发现系统有openssl开发包**。

解决办法就是在编译之前安装相关的开发包就可以了。

# 在CentOS系统中使用下面命令来安装
```bash
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
```
