#!/usr/bin/env python
# coding: utf-8

"""
    autoaptitude
    ~~~~~~~~~~~~

    get pure package list from given file.

    :copyleft: 2013 by Jens Diemer
    :license: GNU GPL v3, see LICENSE.txt for more details.
"""

import argparse
import os

def is_valid_file(parser, arg):
    if not os.path.exists(arg):
       parser.error("The file %s does not exist!" % arg)
    else:
       return open(arg, 'r')

def get_package_list(content):
    packages = []
    for line in content:
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("="):
            continue
        line = line.split("#", 1)[0].strip()
        packages.append(line)
    return packages

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="autoaptiude tool to get the package list")
    parser.add_argument("-i",
        dest="filename", required=True,
        help="input file", metavar="FILE",
        type=lambda x: is_valid_file(parser, x))
    args = parser.parse_args()

#     f = open("packagelist_LinuxMint-VM_20130715.txt", "r")
    f = args.filename
    content = f.readlines()
    f.close()

    packages = get_package_list(content)
#     print packages
    print " ".join(packages)
