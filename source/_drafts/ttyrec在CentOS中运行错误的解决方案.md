title: ttyrec在CentOS中运行错误的解决方案
id: 581
categories:
  - Uncategorized
tags:
---

ttyrec fails to run properly on Red Hat Enterprise Linux 5.x, giving errors like:

    Out of pty's
    /dev/ttyXX: No such file or directory

This patch allows it to build and run properly on RHEL (and likely CentOS):

    wget http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz
    wget http://paperlined.org/apps/rhel/building/ttyrec-1.0.8.RHEL5.patch
    tar -xvzf ttyrec-1.0.8.tar.gz
    cd ttyrec-1.0.8
    patch -i ../ttyrec-1.0.8.RHEL5.patch