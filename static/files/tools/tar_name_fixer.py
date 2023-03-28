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
