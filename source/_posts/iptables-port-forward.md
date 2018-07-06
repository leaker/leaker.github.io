---
title: 使用 iptables 配置端口转发
date: 2018-03-29 16:50:14
tags:
  - linux
  - iptables
categories:
  - linux
---
## 配置
  ```bash
  sysctl -w net.ipv4.ip_forward=1 # 启用IP转发功能
  sysctl -p # 立即生效
  echo "net.ipv4.ip_forward=1" >> /usr/lib/sysctl.d/50-default.conf
  iptables -t nat -A POSTROUTING -j MASQUERADE
  ```

## 添加端口转发脚本 portforward.sh
  ```bash
  #!/bin/bash
  # $1=listen port
  # $2=connect address and port example:111.111.111.111:2222
  iptables -t nat -A PREROUTING -p tcp -i eno1 --dport $1 -j DNAT --to $2
  ```

  想要添加端口的时候只要这么用就好
  ```bash
  ./portforward.sh 22 111.111.111.111:22
  ```
