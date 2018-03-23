title: boost的编译与安装
id: 389
categories:
  - programing
date: 2013-05-27 09:31:57
tags:
---

# Windows下编译安装

## 生成bjam
```bat
bootstrap.bat
```

## 编译
```bat
bjam --toolset=msvc-11.0 --build-type=complete
```

## 安装
```bat
bjam --prefix=D:\third_party\boost install
```

# Ubuntu仅安装开发包
```bash
sudo apt-get install -y libboost-dev libboost-system-dev
```
