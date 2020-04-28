title: 解决ubuntu下dante不能正常启动的问题
tags:
  - dante
  - danted
  - libc
  - ubuntu
id: 311
categories:
  - linux
date: 2012-05-24 06:36:37
---

首先查看日志文件
```shell
[root@ubuntu]# cat /var/log/danted.log
```

发现里面有这样的记录
```text
May 24 13:57:52 (1337839072) danted[13596]: socks_seteuid(): old: 0, new: 65534
May 24 13:57:52 (1337839072) danted[13596]: socks_reseteuid(): current: 65534, new: 0
May 24 13:57:52 (1337839072) danted[13596]: fixsettings(): setting the libwrap uid to 0 is not recommended
May 24 13:57:52 (1337839072) danted[13596]: symbolfunction(): compiletime configuration error? Failed to open "libc.so": /usr/lib/i386-linux-gnu/libc.so: invalid ELF header
```

说明程序在找/usr/lib/i386-linux-gnu/libc.so位置的libc.so没找到，所以解决办法就是创建一个链接命令如下：
```bash
ln -sf /lib/i386-linux-gnu/libc.so.6 /usr/lib/i386-linux-gnu/libc.so
```

再启动下服务
```bash
service danted start
```

看看是不是启动成功啦！
(o≖◡≖)

因为到现在位置在国内没有搜索到这个问题的解决办法，所以记录在这里。或许能帮到有需要的人。

另外，这里有dante socks server的安装说明：
[http://wiki.kartbuilding.net/index.php/Dante_Socks_Server](http://wiki.kartbuilding.net/index.php/Dante_Socks_Server)
