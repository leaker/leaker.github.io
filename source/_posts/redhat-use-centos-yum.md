title: 让RedHat系统使用CentOS的yum
tags:
  - centos
  - redhat
  - sh
  - shell
  - yum
id: 149
categories:
  - linux
date: 2012-04-25 10:04:10
---

<center>![](/wp-content/uploads/2012/04/redhat-300x225.jpg)</center>

# 错误原因
在使用未注册的 RedHat Linux 企业版时。使用yum命令会出现如下提示：
```bash
[root@localhost ~]# yum install httpd
Loaded plugins: rhnplugin, security  
This system is not registered with RHN.  
RHN support will be disabled.  
Setting up Install Process  
No package httpd available.  
Nothing to do
```

# 解决方案
而这种情况可以使用CentOS的yum来代替掉系统本身的yum
脚本如下：
```bash
#!/bin/sh  
rpm -qa | grep yum | xargs rpm -e --nodeps  
wget  http://centos.ustc.edu.cn/centos/5/os/i386/CentOS/yum-metadata-parser-1.1.2-3.el5.centos.i386.rpm  
wget  http://mirrors.ustc.edu.cn/centos/5/os/i386/CentOS/yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm  
wget  http://mirrors.ustc.edu.cn/centos/5/os/i386/CentOS/yum-3.2.22-39.el5.centos.noarch.rpm  
rpm -ivh yum-metadata-parser-1.1.2-3.el5.centos.i386.rpm  
rpm -ivh yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm  
rpm -ivh yum-3.2.22-39.el5.centos.noarch.rpm  
wget http://docs.linuxtone.org/soft/lemp/CentOS-Base.repo  
mv CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo  
rm -f yum-metadata-parser-1.1.2-3.el5.centos.i386.rpm  
rm -f yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm  
rm -f yum-3.2.22-39.el5.centos.noarch.rpm  
rm -f CentOS-Base.repo
```
将上面的脚本保存为：**redhat_use_centos_yum.sh**

点击这里直接下载 [redhat_use_centos_yum.sh](/wp-content/uploads/2012/04/redhat_use_centos_yum.sh)
然后直接运行这个脚本即可。

# 一键脚本
如果闲麻烦也可以依次输入下面几条指令来下载并执行我已经写好的脚本，同样可以达到目的：
```bash
wget http://www.leelib.com/wp-content/uploads/2012/04/redhat_use_centos_yum.sh
chmod 777 redhat_use_centos_yum.sh
sudo ./redhat_use_centos_yum.sh
```
现在再试试yum命令是否已经没有了 This system is not registered with RHN. 提示，并且可以正常使用了呢！ :)
