---
title: 使用 firewall 配置端口转发
date: 2018-03-30T16:36:49+08:00
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

# 只允许指定IP连入指定端口
```bash
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.0.2" port protocol="tcp" port="80" accept'
```

# 只允许指定IP段连入指定端口范围
```bash
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.0.0/24" port protocol="tcp" port="80-8080" accept'
```

# Linux 常用网络优化
```bash
# 发送 KeepAlive 消息的间隔 1200=2分钟
sysctl -w net.ipv4.tcp_keepalive_time=1200
# IP端口重用
sysctl -w net.ipv4.tcp_tw_reuse=1
```