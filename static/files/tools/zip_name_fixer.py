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
