title: 解决yum安装 openssl-devel时产生的Multilib version problems found错误
tags:
  - centos
  - install
  - linux
  - yum
id: 605
categories:
  - linux
date: 2014-06-29 06:56:31
---

今天给一台CentOS系统安装openssl-devel时，出现了如下信息：
```bash
[root@centos]# yum install -y openssl-devel
Loaded plugins: fastestmirror, security
Repository updates is listed more than once in the configuration
Repository centosplus is listed more than once in the configuration
Repository contrib is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Loading mirror speeds from cached hostfile
 * base: mirrors.tuna.tsinghua.edu.cn
 * extras: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.tuna.tsinghua.edu.cn
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package openssl-devel.x86_64 0:1.0.1e-16.el6_5.14 will be installed
--> Processing Dependency: krb5-devel for package: openssl-devel-1.0.1e-16.el6_5.14.x86_64
--> Running transaction check
---> Package krb5-devel.x86_64 0:1.10.3-15.el6_5.1 will be installed
--> Processing Dependency: libselinux-devel for package: krb5-devel-1.10.3-15.el6_5.1.x86_64
--> Processing Dependency: libcom_err-devel for package: krb5-devel-1.10.3-15.el6_5.1.x86_64
--> Processing Dependency: keyutils-libs-devel for package: krb5-devel-1.10.3-15.el6_5.1.x86_64
--> Running transaction check
---> Package keyutils-libs-devel.x86_64 0:1.4-4.el6 will be installed
---> Package libcom_err-devel.x86_64 0:1.41.12-18.el6 will be installed
---> Package libselinux-devel.x86_64 0:2.0.94-5.3.el6_4.1 will be installed
--> Processing Dependency: libselinux = 2.0.94-5.3.el6_4.1 for package: libselinux-devel-2.0.94-5.3.el6_4.1.x86_64
--> Processing Dependency: libsepol-devel >= 2.0.32-1 for package: libselinux-devel-2.0.94-5.3.el6_4.1.x86_64
--> Processing Dependency: pkgconfig(libsepol) for package: libselinux-devel-2.0.94-5.3.el6_4.1.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.0.94-5.3.el6_4.1 will be installed
--> Processing Dependency: libdl.so.2(GLIBC_2.1) for package: libselinux-2.0.94-5.3.el6_4.1.i686
--> Processing Dependency: libdl.so.2(GLIBC_2.0) for package: libselinux-2.0.94-5.3.el6_4.1.i686
--> Processing Dependency: libdl.so.2 for package: libselinux-2.0.94-5.3.el6_4.1.i686
--> Processing Dependency: libc.so.6(GLIBC_2.8) for package: libselinux-2.0.94-5.3.el6_4.1.i686
--> Processing Dependency: ld-linux.so.2(GLIBC_2.3) for package: libselinux-2.0.94-5.3.el6_4.1.i686
--> Processing Dependency: ld-linux.so.2 for package: libselinux-2.0.94-5.3.el6_4.1.i686
---> Package libsepol-devel.x86_64 0:2.0.41-4.el6 will be installed
--> Running transaction check
---> Package glibc.i686 0:2.12-1.132.el6_5.2 will be installed
--> Processing Dependency: libfreebl3.so(NSSRAWHASH_3.12.3) for package: glibc-2.12-1.132.el6_5.2.i686
--> Processing Dependency: libfreebl3.so for package: glibc-2.12-1.132.el6_5.2.i686
--> Running transaction check
---> Package nss-softokn-freebl.i686 0:3.14.3-10.el6_5 will be installed
--> Finished Dependency Resolution
Error:  Multilib version problems found. This often means that the root
       cause is something else and multilib version checking is just
       pointing out that there is a problem. Eg.:

         1\. You have an upgrade for libselinux which is missing some
            dependency that another package requires. Yum is trying to
            solve this by installing an older version of libselinux of the
            different architecture. If you exclude the bad architecture
            yum will tell you what the root cause is (which package
            requires what). You can try redoing the upgrade with
            --exclude libselinux.otherarch ... this should give you an error
            message showing the root cause of the problem.

         2\. You have multiple architectures of libselinux installed, but
            yum can only see an upgrade for one of those arcitectures.
            If you don't want/need both architectures anymore then you
            can remove the one with the missing update and everything
            will work.

         3\. You have duplicate versions of libselinux installed already.
            You can use "yum check" to get yum show these errors.

       ...you can also use --setopt=protected_multilib=false to remove
       this checking, however this is almost never the correct thing to
       do as something else is very likely to go wrong (often causing
       much more problems).

       Protected multilib versions: libselinux-2.0.94-5.3.el6_4.1.i686 != libselinux-2.0.94-5.3.0.1.el6.centos.plus.x86_64
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest
```

**最后在一个日文的网站上找到了解决办法：**
```bash
yum install --enablerepo=centosplus openssl-devel
```

参考：[http://blog.urban-theory.net/2014/06/16/openssl-devel-install-fails-on-centos-with-docker](http://blog.urban-theory.net/2014/06/16/openssl-devel-install-fails-on-centos-with-docker)
