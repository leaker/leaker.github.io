---
title: 使用 firewall 配置端口转发
date: 2018-03-30 16:36:49
tags:
  - linux
  - firewall
  - firewall-cmd
categories:
  - linux
---
# 开启NAT转发
```bash
firewall-cmd --permanent --zone=public --add-masquerade
```

# 本机到本机
```bash
firewall-cmd --permanent --zone=public --add-forward-port=port=80:proto=tcp:toport=8080
firewall-cmd --permanent --zone=public --add-service=http
```

# 本机到其他机器
```bash
firewall-cmd --permanent --zone=public --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=192.168.0.2
firewall-cmd --permanent --zone=public --add-port=80/tcp
```

# 重新加载应用
```bash
firewall-cmd --reload
```