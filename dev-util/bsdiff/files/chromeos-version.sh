#!/bin/sh
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
exec awk '$1 == "Version:" {print $2}' "$1"/README.chromium
