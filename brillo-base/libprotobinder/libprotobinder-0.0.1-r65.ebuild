# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CROS_WORKON_COMMIT="3bf2f93fb8755a8cff448a42bbbd4d78519ac4ed"
CROS_WORKON_TREE="a9a25620ebcbedc198f5bd8218cca6fd5b8b706a"
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
	doins binder_daemon.h
	doins binder_host.h
	doins binder_manager.h
	doins binder_proxy_interface_base.h
	doins binder_proxy.h
	doins ibinder.h
	doins iinterface.h
	doins iservice_manager.h
	doins parcel.h
	doins protobinder.h
}