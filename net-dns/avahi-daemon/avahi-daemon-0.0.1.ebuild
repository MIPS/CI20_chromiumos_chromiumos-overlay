# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Install the upstart job that launches avahi."
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="brillo-debug wifi_bootstrapping"

RDEPEND="
	net-dns/avahi
"

S=${WORKDIR}

src_install() {
	insinto /etc/init
	if use brillo-debug || use wifi_bootstrapping ; then
		newins "${FILESDIR}"/init/auto.conf avahi.conf
	else
		newins "${FILESDIR}"/init/manual.conf avahi.conf
	fi
}
