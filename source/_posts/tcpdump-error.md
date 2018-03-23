title: 'Linux调用tcpdump时“tcpdump: USB link-layer type filtering not implemented”解决方案'
tags:
  - ifconfig
  - linux
  - netcap
  - tcpdump
id: 432
categories:
  - linux
date: 2013-06-08 03:00:30
---

当调用tcpdump时，出现错误：**tcpdump: USB link-layer type filtering not implemented**

# 原因
说明系统可能有多块网卡共存。

# 需要指定工作网卡才能开始截包，使用参数举例
```bash
[root@centos]# tcpdump -i eth0 udp port 53
```

*在实际使用中例子中“eth0”“udp”“53”等参数，要根据实际需要来进行修改。*
*虽然一般单网卡默认名称应该是eth0，但也有其他情况。实际中要使用ifconfig查看自己需要使用的网卡。*
