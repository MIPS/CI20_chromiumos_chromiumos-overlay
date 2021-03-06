# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="f9d2ab79a15a1bb6a1307f3b608964c81c27791b"
CROS_WORKON_TREE="14966333adb6eef81367fb83c4edef6e9515ab39"
CROS_WORKON_PROJECT="chromiumos/platform/minigbm"
CROS_WORKON_LOCALNAME="../platform/minigbm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-constants cros-workon toolchain-funcs

DESCRIPTION="Mini GBM implementation"
HOMEPAGE="${CROS_GIT_HOST_URL}/${CROS_WORKON_PROJECT}"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
VIDEO_CARDS="exynos intel mediatek rockchip tegra"
IUSE="-asan -clang"
for card in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${card}"
done
REQUIRED_USE="asan? ( clang )"

RDEPEND="
	x11-libs/libdrm
	!media-libs/mesa[gbm]"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cros-workon_src_prepare
}

src_configure() {
	export LIBDIR="/usr/$(get_libdir)"
	use video_cards_exynos && append-cppflags -DGBM_EXYNOS && export GBM_EXYNOS=1
	use video_cards_intel && append-cppflags -DGBM_I915 && export GBM_I915=1
	use video_cards_mediatek && append-cppflags -DGBM_MEDIATEK && export GBM_MEDIATEK=1
	use video_cards_rockchip && append-cppflags -DGBM_ROCKCHIP && export GBM_ROCKCHIP=1
	use video_cards_tegra && append-cppflags -DGBM_TEGRA && export GBM_TEGRA=1
	cros-workon_src_configure
}

src_compile() {
	cros-workon_src_compile
}
