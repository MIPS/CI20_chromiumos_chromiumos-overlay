# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_COMMIT="4985c2014d111024b5a2d17b7853ad5fff5652a7"
CROS_WORKON_TREE="889c074db51fd33a4b9627115ecff8e0ee35d653"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"

PLATFORM_SUBDIR="buffet"

inherit cros-workon libchrome platform

DESCRIPTION="Local and cloud communication services for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	chromeos-base/libchromeos
	!<chromeos-base/platform2-0.0.10
"

DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gmock )
	dev-cpp/gtest
"

src_install() {
	dobin "${OUT}"/buffet
	dobin "${OUT}"/buffet_client

	# DBus configuration.
	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.Buffet.conf

	# Base GCD command definitions.
	insinto /etc/buffet
	doins etc/buffet/gcd.json

	# Upstart script.
	insinto /etc/init
	doins etc/init/buffet.conf
}

platform_pkg_test() {
	local tests=(
		buffet_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}