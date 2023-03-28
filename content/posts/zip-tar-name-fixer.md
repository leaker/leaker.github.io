---
title: zip 和 tar 包内乱码文件名修正工具
date: 2023-03-29T03:15:09+07:00
categories:
  - programing
tags:
  - zip
  - tar
---

收到别人发来的压缩包，结果解压出来文件名是乱码。
这种情况在别人和自己使用不同的操作系统平台以及编码时经常发生，为了解决这一问题。自己编写了使用指定编码解压文件的程序。

*zip_name_fixer.py*
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import zipfile


def main():
    parser = argparse.ArgumentParser(description='ZIP filenames fixer')
    parser.add_argument('path', type=str, help='path to the ZIP file.')
    parser.add_argument('encoding', type=str, help='encoding of the filenames inside the ZIP file.')
    parser.add_argument('-o', '--output', type=str, help='output directory for the extracted files.', default='.')
    parser.add_argument('-p', '--password', type=str, help='Decompression password for the ZIP file.', default='')
    args = parser.parse_args()

    with zipfile.ZipFile(args.path, 'r', metadata_encoding=args.encoding) as zip:
        zip.extractall(path=args.output, pwd=args.password.encode('utf-8'))


if __name__ == '__main__':
    main()

```
点我下载：[zip_name_fixer.py](/files/tools/zip_name_fixer.py)

使用方式： python zip_name_fixer.py [-h] [-o OUTPUT] [-p PASSWORD] path encoding

其中 **encoding** 就是python中常用的编码代码，例如： *gbk*、*cp437* 等等...



同时顺手还写了一个针对 tar.gz 压缩包的。

*tar_name_fixer.py*
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import tarfile


def main():
    parser = argparse.ArgumentParser(description='tar.gz filenames fixer')
    parser.add_argument('path', type=str, help='path to the tar.gz file.')
    parser.add_argument('encoding', type=str, help='encoding of the filenames inside the tar.gz file.')
    parser.add_argument('-o', '--output', type=str, help='output directory for the extracted files.', default='.')
    args = parser.parse_args()

    with tarfile.open(args.path, 'r:gz', encoding=args.encoding) as tar:
        tar.extractall(path=args.output)


if __name__ == '__main__':
    main()

```
点我下载：[tar_name_fixer.py](/files/tools/tar_name_fixer.py)

使用方式： python tar_name_fixer.py [-h] [-o OUTPUT] path encoding
