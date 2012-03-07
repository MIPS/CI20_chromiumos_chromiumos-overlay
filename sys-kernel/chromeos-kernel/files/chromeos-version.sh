#!/bin/sh
#
# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script is given one argument: the base of the source directory of
# the package, and it prints a string on stdout with the numerical version
# number for said repo.

# Matching regexp for all known kernel release tags to date.
PATTERN="v[23].*"

if [ ! -d "$1" ] ; then
    exit
fi

cd "$1" || exit

git describe --match "${PATTERN}" --abbrev=0 HEAD 2>&1 | egrep "${PATTERN}" |
  sed s/v\\.*//g
