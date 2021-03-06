# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# TODO(msb): move this ebuild to net-dns/minifakedns
EAPI="4"
CROS_WORKON_PROJECT="chromiumos/third_party/minifakedns"
CROS_WORKON_LOCALNAME="../third_party/miniFakeDns"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit python cros-workon

DESCRIPTION="Minimal python dns server"
HOMEPAGE="http://code.activestate.com/recipes/491264-mini-fake-dns-server/"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~*"
IUSE=""

pkg_setup() {
	python_pkg_setup
	cros-workon_pkg_setup
}

src_install() {
	insinto "$(python_get_sitedir)"
	doins "src/miniFakeDns.py"
}
