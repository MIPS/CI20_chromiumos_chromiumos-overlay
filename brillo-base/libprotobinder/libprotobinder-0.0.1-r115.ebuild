# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CROS_WORKON_COMMIT="bd91f3304cf7f08ea8639827d3354e62986525ee"
CROS_WORKON_TREE="604976cf7589777ce86aa35e3f454e0100894ca2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="libprotobinder"

inherit cros-workon platform

DESCRIPTION="Library to provide Binder IPC."
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!brillo-base/libbrillobinder
	chromeos-base/libchromeos
"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gmock )
	dev-cpp/gtest
"

src_install() {
	./preinstall.sh "${OUT}"
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${OUT}"/*.pc

	dolib.so "${OUT}/lib/libprotobinder.so"

	if use test ; then
		dobin "${OUT}/ping-client"
		dobin "${OUT}/ping-daemon"
	fi

	insinto /usr/include/protobinder
	doins *.h
}