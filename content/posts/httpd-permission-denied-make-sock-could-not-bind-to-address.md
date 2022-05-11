---
title: 'Starting httpd: (13)Permission denied: make_sock: could not bind to address 解决方案'
tags:
  - apache
  - bind
  - conf
  - denied
  - httpd
  - http_port
  - listen
  - permission
  - SELinux
  - semanage
id: 573
categories:
  - linux
date: 2013-11-01T08:36:55+08:00
---

# 原因
修改了conf里面的Listen端口

# 解决
1. 修改成SELinux安全机制里面默认允许的端口（80, 443, 488, 8008, 8009, 8443）等等。
2. 修改SELinux安全设置
  如：
  ```bash
  semanage port -a -t http_port_t -p tcp <listen port>
  ```
