# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-m17n/ibus-m17n-1.2.0.20090617.ebuild,v 1.1 2009/06/18 15:40:00 matsuu Exp $

EAPI="2"

inherit cros-workon

DESCRIPTION="The M17N engine IMEngine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
#SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.2
	>=dev-libs/m17n-lib-1.6.1
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	=dev-db/m17n-contrib-1.1.10
	>=dev-db/m17n-db-1.6.1
	dev-util/pkgconfig
	>=sys-devel/gettext-0.16.1"

# Chromium OS change:
# - Removed dev-db/m17n-contrib from DEPEND for now since we're still not sure
#   if we really need this package.
# - src_unpack() is inherited from cros-workon
# - Added ./autogen.sh call to src_compile().

CROS_WORKON_SUBDIR="files"

src_prepare() {
	NOCONFIGURE=1 ./autogen.sh
}

src_configure() {
	econf $(use_enable nls) || die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	ewarn "This package is very experimental, please report your bugs to"
	ewarn "http://ibus.googlecode.com/issues/list"
	elog
	elog "You should run ibus-setup and enable IM Engines you want to use!"
	elog
}
