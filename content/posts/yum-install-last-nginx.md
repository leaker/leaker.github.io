---
title: 让CentOS的yum命令可以直接安装最新的nginx
id: 632
categories:
  - linux
date: 2014-10-31T22:46:53+08:00
tags:
  - nginx
  - yum
  - repos
---

# 添加nginx的repo
```bash
echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64
gpgcheck=0
enabled=1' > /etc/yum.repos.d/nginx.repo
```

# 安装
```bash
yum update
yum install nginx
```

是不是直接安装了最新版的nginx呢
 ( ͡° ͜ʖ ͡°) 
