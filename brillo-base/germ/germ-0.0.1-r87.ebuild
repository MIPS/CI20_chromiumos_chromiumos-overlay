# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_COMMIT="f5166e59ae1488f462f2c64f49d8d8d6094e9de2"
CROS_WORKON_TREE="dca4997499dcdaeaade44be707590ba8f1f8d43b"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="germ"

inherit cros-workon platform

DESCRIPTION="System service for sandboxing"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	brillo-base/libprotobinder
	chromeos-base/chromeos-minijail
	chromeos-base/libchromeos
"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gmock )
	dev-cpp/gtest
"

src_install() {
	dobin "${OUT}/germ"
	dobin "${OUT}/germd"

	# Install Upstart template.
	insinto /etc/init
	doins init/germ_template.conf
}

platform_pkg_test() {
	local tests=( germ_unittest )

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}