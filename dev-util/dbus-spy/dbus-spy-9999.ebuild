# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_PROJECT="chromiumos/third_party/dbus-spy"

inherit cros-workon

DESCRIPTION="python dbus sniffer"
HOMEPAGE="http://vidner.net/martin/software/dbus-spy/"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="dev-lang/python"
DEPEND=""

src_install() {
	newbin dbus-spy.py dbus-spy
}
