# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

CONFLICT_LIST="chromeos-base/autotest-tests-0.0.1-r524"

inherit toolchain-funcs flag-o-matic cros-workon autotest conflict

DESCRIPTION="login_OwnershipApi autotest"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~arm ~amd64"

IUSE="+autox +xset +tpmtools hardened"
# Enable autotest by default.
IUSE="${IUSE} +autotest"

# Required for .proto files used in Ownership DBus calls.
RDEPEND="
  chromeos-base/chromeos-chrome
"

RDEPEND="${RDEPEND}
  chromeos-base/flimflam-test
  dev-libs/protobuf
  autox? ( chromeos-base/autox )
"

DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_login_OwnershipApi
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_PROJECT=autotest
CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
