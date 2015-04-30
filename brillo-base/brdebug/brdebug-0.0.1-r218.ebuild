# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_COMMIT="e414f608e4c1caeba772223a22d57be8ef13b212"
CROS_WORKON_TREE="25d1073b234b0e13ab4b759db8c09e7a5d2ae1c0"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="brdebug"
PLATFORM_NATIVE_TEST="yes"

inherit cros-workon platform udev

DESCRIPTION="Manage device properties for Brillo debug link."
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	chromeos-base/libchromeos
	chromeos-base/peerd
"

DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_install() {
	dobin "${OUT}"/brdebugd
	dosbin udev/setup-debug-link

	insinto /etc/init
	doins init/brdebugd.conf

	udev_dorules udev/99-setup-debug-link.rules
}

platform_pkg_test() {
	platform_test "run" "${OUT}/brdebug_unittest"
}