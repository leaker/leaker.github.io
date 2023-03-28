---
title: 文本编码与换行符转换器
date: 2023-03-29T03:03:40+07:00
categories:
  - programing
tags:
  - encoding
  - gbk
  - utf8
---

当遇到某人发来的文本內容内不是标准 utf-8 编码时，可以使用本程序来进行转换。


转换时遇到文本行尾使用了Windows专用的 **CRLF** 换行符时，也会将文本行尾统一更换为 **LF**。这样的好处是可以缩小文本文件的空间占用，并且可以保证该文件可以在基于Unix和Linux的操作系统以相同的格式显示。

*encoding_line_ending_converter.py*
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import os


def main():
    parser = argparse.ArgumentParser(description='Text Encoding and Line Ending Converter')
    parser.add_argument('path', type=str, help='directory to be traversed and processed.')
    parser.add_argument('encoding', type=str, help='encoding of the text file.')
    parser.add_argument('-e', '--extensions', type=str, help='only process specified file extensions. use "|" as the separator, for example: ".txt|.log|.html"', default='')
    parser.add_argument('-q', '--quiet', action='store_true', help='do not output information during processing.')
    parser.add_argument("-v", "--verbose", action="store_true", help="increase output verbosity")
    args = parser.parse_args()
    extensions = tuple(args.extensions.split('|'))

    processed_count = 0
    for root, _, files in os.walk(args.path):
        for file_name in files:
            if len(extensions) == 0 or file_name.endswith(extensions):
                if trans(os.path.join(root, file_name), args.encoding, args.quiet, args.verbose):
                    processed_count += 1

    if not args.quiet:
        print(f'{processed_count} files have been processed.')


def trans(file_path, file_encoding, quiet, verbose) -> bool:
    """Convert file encoding and line endings."""
    # check file encoding
    encoding = 'utf-8'
    content = ''
    try:
        with open(file_path, 'r', encoding=encoding) as f:
            content = f.read()
    except UnicodeDecodeError:
        with open(file_path, 'rb') as f:
            try:
                content = f.read().decode(file_encoding)
                encoding = file_encoding
            except UnicodeDecodeError:
                if not quiet:
                    print(f'{file_path} the file encoding is not {file_encoding}.')
                return False

    # determine if a file uses LF line endings.
    if '\r' in content:
        # convert CRLF line endings to LF.
        content = content.replace('\r\n', '\n')

        # write content
        with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(content)

        if not quiet:
            print(f'{file_path} the file encoding and line endings have been converted to UTF-8 and LF.')
        return True
    if encoding != 'utf-8':
        # write content
        with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(content)

        if not quiet:
            print(f'{file_path} the file encoding has been converted to UTF-8.')
        return True
    if not quiet and verbose:
        print(f'{file_path} the file is now encoded in UTF-8 with LF line endings.')
    return False


if __name__ == '__main__':
    main()

```
点我下载：[encoding_line_ending_converter.py](/files/tools/encoding_line_ending_converter.py)


*> python encoding_line_ending_converter.py -h*
```
usage: encoding_line_ending_converter.py [-h] [-e EXTENSIONS] [-q] [-v] path encoding

Text Encoding and Line Ending Converter

positional arguments:
  path                  directory to be traversed and processed.
  encoding              encoding of the text file.

options:
  -h, --help            show this help message and exit
  -e EXTENSIONS, --extensions EXTENSIONS
                        only process specified file extensions. use "|" as the separator, for example: ".txt|.log|.html"
  -q, --quiet           do not output information during processing.
  -v, --verbose         increase output verbosity
```

其中 **encoding** 就是python中常用的编码代码，例如： *gbk*、*cp437* 等等...
