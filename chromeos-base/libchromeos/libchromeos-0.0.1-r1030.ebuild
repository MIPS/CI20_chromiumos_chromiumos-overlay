# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CROS_WORKON_COMMIT="2318f108bd7fb5f4a7f0ac29d2f43a20859d28eb"
CROS_WORKON_TREE="810d3fd0bba8741512ffda5eab77b88480c03c67"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_USE_VCSID=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="libchromeos"
PLATFORM_NATIVE_TEST="yes"

inherit cros-workon libchrome multilib platform

DESCRIPTION="Base library for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/platform"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

COMMON_DEPEND="
	!<chromeos-base/bootstat-0.0.2
	chromeos-base/chromeos-minijail
	dev-libs/dbus-c++
	dev-libs/dbus-glib
	dev-libs/openssl
	dev-libs/protobuf
	net-misc/curl
	sys-apps/rootdev
"
RDEPEND="
	${COMMON_DEPEND}
	!cros_host? ( chromeos-base/libchromeos-use-flags )
	chromeos-base/chromeos-ca-certificates
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/protofiles
	dev-cpp/gtest
	test? (
		app-shells/dash
		dev-cpp/gmock
	)
"

src_install() {
	local v
	insinto "/usr/$(get_libdir)/pkgconfig"
	for v in "${LIBCHROME_VERS[@]}"; do
		./platform2_preinstall.sh "${OUT}" "${v}"
		dolib.so "${OUT}"/lib/lib{chromeos,policy}*-"${v}".so
		dolib.a "${OUT}"/libchromeos*-"${v}".a
		doins "${OUT}"/lib/libchromeos*-"${v}".pc
	done

	# Install all the header files from libchromeos/chromeos/*.h into
	# /usr/include/chromeos (recursively, with sub-directories).
	# Exclude the following sub-directories though (they are handled separately):
	#   chromeos/bootstat
	#   chromeos/policy
	local dir
	while read -d $'\0' -r dir; do
		insinto "/usr/include/${dir}"
		doins "${dir}"/*.h
	done < <(find chromeos -type d -not -path "chromeos/bootstat*" -not -path "chromeos/policy*" -print0)

	insinto /usr/include/policy
	doins chromeos/policy/*.h

	insinto /usr/include/metrics
	doins chromeos/bootstat/bootstat.h
}

platform_pkg_test() {
	local v
	for v in "${LIBCHROME_VERS[@]}"; do
		platform_test "run" "${OUT}/libchromeos-${v}_unittests"
		platform_test "run" "${OUT}/libpolicy-${v}_unittests"
		platform_test "run" "${OUT}/libbootstat_unittests"
	done
}
