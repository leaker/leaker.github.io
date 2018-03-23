title: CentOS系统IP设置
tags:
  - centos
  - dhclient
  - dns
  - eth0
  - ifcfg-eth0
  - network
  - resolv
id: 382
categories:
  - linux
date: 2013-05-12 05:54:24
---

> 以最小化安装的CentOS系统默认是不自动设置IP信息的。
>   我们想要正常访问网络，第一步就必须先把IP设置好。

# 设置IP为自动获取：

```bash
[root@centos ~]# dhclient eth0
```

# 设置IP为手动填写：

1. 设置网关

```bash
[root@centos ~]# echo 'GATEWAY="192.168.1.1"' >> /etc/sysconfig/network
```

2. 设置网卡信息
```bash
[root@centos ~]# echo 'DEVICE="eth0"
HWADDR="00:0C:29:28:F9:88"
NM_CONTROLLED="yes"
ONBOOT="yes"
BOOTPROTO="none"
BROADCAST="192.168.1.255"
IPADDR="192.168.1.120"
NETMASK="255.255.255.0"
NETWORK="192.168.1.0"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
TYPE="Ethernet"' > /etc/sysconfig/network-scripts/ifcfg-eth0
```

3. 设置DNS
```bash
[root@centos ~]# echo 'nameserver 8.8.8.8
nameserver 8.8.4.4'> /etc/resolv.conf
```


4. 重启网络
```bash
[root@centos ~]# service network restart
Shutting down loopback interface: [ OK ]
Bringing up loopback interface: [ OK ]
Bringing up interface eth0: [ OK ]
```
