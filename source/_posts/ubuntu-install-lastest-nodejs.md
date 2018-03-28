---
title: Ubuntu安装最新版本nodejs
date: 2018-03-29 00:49:33
tags:
  - ubuntu
  - apt
  - apt-get
  - nodejs
  - npm
categories:
  - linux
---
## 最新发行版
  ```bash
  sudo curl -sL https://deb.nodesource.com/setup | sudo -E bash -
  ```

## 指定版本，通常用于安装LTS版本。比如当前最新LTS版本是8
  ```bash
  sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  ```