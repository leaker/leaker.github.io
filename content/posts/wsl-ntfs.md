---
title: 解决WSL中使用NTFS分区的权限问题
date: 2020-04-30T20:32:27+08:00
tags:
  - mount
  - linux
  - wsl
  - conf
  - powershell
  - lxss
  - drvfs
categories:
  - linux
---
当使用WSL的过程中访问WSL系统以外目录时候出现一些奇奇怪怪问题
通常就是WSL对于NTFS分区的目录权限问题。

使用 **mount -l** 查看，可能长这样

```shell
[root@wsl] mount -l
rootfs on / type lxfs (rw,noatime)
none on /dev type tmpfs (rw,noatime,mode=755)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,noatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,noatime)
devpts on /dev/pts type devpts (rw,nosuid,noexec,noatime,gid=5,mode=620)
none on /run type tmpfs (rw,nosuid,noexec,noatime,mode=755)
none on /run/lock type tmpfs (rw,nosuid,nodev,noexec,noatime)
none on /run/shm type tmpfs (rw,nosuid,nodev,noatime)
none on /run/user type tmpfs (rw,nosuid,nodev,noexec,noatime,mode=755)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
cgroup on /sys/fs/cgroup type tmpfs (rw,relatime,mode=755)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,relatime,devices)
C:\ on /mnt/c type drvfs (rw,noatime,uid=0,gid=0,case=off)
D:\ on /mnt/d type drvfs (rw,noatime,uid=0,gid=0,case=off)
```
可以看到 **C:\\** 和 **D:\\** 加载状况是这样的。这种情况下代表所有目录均以**root**权限进行访问。在使用**ssh**或**git**等工具的时候有可能会因为一些权限问题导致意外情况发生。

### 解决办法很简单，通过DrvFs让WSL可以支持NTFS分区增加文件metadata信息：
1. 挂载配置
```bash
echo '[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=11"
mountFsTab = false' > /etc/wsl.conf
```

2. 在**PowerShell**中重启WSL服务
```powershell
Restart-Service LxssManager
```