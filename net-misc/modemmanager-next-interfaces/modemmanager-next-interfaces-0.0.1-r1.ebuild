# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Install the XML interface files for modemmanager-next.  Not part of
# the regular modemmanager-next build because we need these headers
# even if modemmanager-next isn't installed.

EAPI="4"
CROS_WORKON_COMMIT="231c26baab39e733c355432a0f8f870c9f640486"
CROS_WORKON_PROJECT="chromiumos/third_party/modemmanager-next"
CROS_WORKON_LOCALNAME="../third_party/modemmanager-next"

inherit cros-workon

DESCRIPTION="DBus interface descriptions and headers for ModemManager v0.6"
HOMEPAGE="http://www.chromium.org/"
#SRC_URI not defined because we get our source locally

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="!net-misc/modemmanager-next"

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/dbus-1/interfaces
	doins introspection/org.freedesktop.ModemManager1.*.xml

	insinto /usr/include/mm
	doins include/ModemManager*.h
}
