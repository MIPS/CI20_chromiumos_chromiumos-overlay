# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="6feba4fd14c7ba24fe12b5c73edaf530c4719780"
CROS_WORKON_TREE="2edeb15e3351384ebdb71f86f7a795f8ad5ea1f0"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

inherit cros-workon autotest

DESCRIPTION="Autotests involving the tpm"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_hardware_TPMCheck
	+tests_kernel_TPMPing
	+tests_kernel_TPMStress
	+tests_platform_Attestation
	+tests_platform_Pkcs11InitUnderErrors
	+tests_platform_Pkcs11ChangeAuthData
	+tests_platform_Pkcs11Events
	+tests_platform_Pkcs11LoadPerf
	+tests_platform_TPMEvict
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"