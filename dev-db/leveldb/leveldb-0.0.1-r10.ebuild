# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=4
CROS_WORKON_COMMIT="3d77530aec0e03d7559aa66d31a65fbbe5d84e73"
CROS_WORKON_TREE="aefacde0d1a49d4decc37d696963fdd4786881ad"
CROS_WORKON_PROJECT="chromiumos/third_party/leveldb"

inherit toolchain-funcs cros-debug cros-workon

DESCRIPTION="A fast and lightweight key/value database library by Google."
HOMEPAGE="http://code.google.com/p/leveldb/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="-asan -clang snappy"
REQUIRED_USE="asan? ( clang )"

DEPEND="snappy? ( app-arch/snappy )"
RDEPEND="${DEPEND}"

src_configure() {
	clang-setup-env
	cros-workon_src_configure

	# These vars all get picked up by build_detect_platform
	# which the Makefile runs for us automatically.
	tc-export AR CC CXX
	export OPT="-DNDEBUG ${CPPFLAGS}"
}

src_compile() {
	emake SNAPPY=$(usex snappy) all libmemenv.a
}

src_install() {
	insinto /usr/include/leveldb
	doins include/leveldb/*.h helpers/memenv/memenv.h
	dolib.a libleveldb.a libmemenv.a
}
