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
