# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="5b1f276bfb2ca9fe6eb4b86565a9ec1651490516"
CROS_WORKON_TREE="3d53c1ce3137197cd17a8a66290b716f380c6f3e"
CROS_WORKON_PROJECT="chromiumos/third_party/chrontel"
CROS_WORKON_LOCALNAME="../third_party/chrontel"

inherit cros-workon

DESCRIPTION="Chrontel CH7036 User Space Driver"
HOMEPAGE="http://www.chrontel.com"
SRC_URI=""

# TODO: Once the licensing script stops clobbering chromeos-base/* projects
# from BSD to BSD-Google, we can use normal BSD here.  See this CL for info:
# https://chromium-review.googlesource.com/188206
LICENSE="BSD-chrontel"
SLOT="0"
KEYWORDS="*"
IUSE="-asan -bogus_screen_resizes -clang -use_alsa_control"
REQUIRED_USE="asan? ( clang )"

RDEPEND="x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXrandr
	media-libs/alsa-lib
	media-sound/adhd"
DEPEND="${RDEPEND}"

src_configure() {
	clang-setup-env
	cros-workon_src_configure
}

src_compile() {
	tc-export CC PKG_CONFIG
	append-flags -DUSE_AURA
	use bogus_screen_resizes && append-flags -DBOGUS_SCREEN_RESIZES
	use use_alsa_control && append-flags -DUSE_ALSA_CONTROL
	export CCFLAGS="${CFLAGS}"
	emake
}

src_install() {
	dobin ch7036_monitor
	dobin ch7036_debug

	dodir /lib/firmware/chrontel
	insinto /lib/firmware/chrontel
	doins fw7036.bin

	insinto /etc/init
	doins chrontel.conf

	dodir /usr/share/userfeedback/etc
	insinto /usr/share/userfeedback/etc
	doins sys_mon_hdmi.sysinfo.lst
}
