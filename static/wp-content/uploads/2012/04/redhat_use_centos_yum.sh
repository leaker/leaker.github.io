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