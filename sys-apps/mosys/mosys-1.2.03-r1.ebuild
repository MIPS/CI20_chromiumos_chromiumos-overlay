# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="24c0cfb2e0c7ccc8fc0c9464b414e1a51d08f422"
CROS_WORKON_TREE="c1515f89402239e3274a758313d5fd5204b1a6a2"

EAPI="4"
CROS_WORKON_PROJECT="chromiumos/platform/mosys"
CROS_WORKON_LOCALNAME="../platform/mosys"

inherit flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="Utility for obtaining various bits of low-level system info"
HOMEPAGE="http://mosys.googlecode.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
RDEPEND="sys-apps/util-linux
         >=sys-apps/flashmap-0.3-r4"
DEPEND="${RDEPEND}"

src_compile() {
	# Generate a default .config for our target architecture. This will
	# likely become more sophisticated as we broaden board support.
	einfo "using default configuration for $(tc-arch)"
	ARCH=$(tc-arch) make defconfig || die

	tc-export AR AS CC CXX LD NM STRIP OBJCOPY PKG_CONFIG
	export FMAP_LINKOPT="$(${PKG_CONFIG} --libs-only-l fmap)"
	append-ldflags "$(${PKG_CONFIG} --libs-only-L fmap)"
	export LDFLAGS="$(raw-ldflags)"
	append-flags "$(${PKG_CONFIG} --cflags fmap)"
	export CFLAGS

	emake || die
}

src_install() {
	dosbin mosys || die
}
