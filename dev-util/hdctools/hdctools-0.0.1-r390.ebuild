# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="a81c1f330c02d5615e3e11543c19a5c7551ce8c5"
CROS_WORKON_TREE="1ac18664880fd35e730f0b54a372cd630cf14b7c"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python2_{6,7} )

inherit cros-workon distutils-r1 toolchain-funcs multilib udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND=">=dev-embedded/libftdi-0.18
	dev-python/numpy
	dev-python/pexpect
	dev-python/pyserial
	dev-python/pyusb
	virtual/libusb:1"
DEPEND="${RDEPEND}
	app-text/htmltidy"

src_configure() {
	cros-workon_src_configure
}

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

src_install() {
	local makeargs=(
		$(usex cros_host '' EXTRA_DIRS=chromeos)
		DESTDIR="${D}"
		LIBDIR=/usr/$(get_libdir)
		UDEV_DEST="${D}$(get_udevdir)/rules.d"
		install
	)
	emake "${makeargs[@]}"
	distutils-r1_src_install
}