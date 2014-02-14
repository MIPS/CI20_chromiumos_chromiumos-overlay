# Copyright 1999-2011 Gentoo Foundation

EAPI="3"

DESCRIPTION="Zinnia learning data for simplified Chinese"
HOMEPAGE="http://tegaki.org/"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"

RDEPEND="app-i18n/zinnia"

src_install() {
	mkdir -p "${D}/usr/share/tegaki/models/zinnia" || die
	install handwriting-zh_CN.meta handwriting-zh_CN.model \
		"${D}/usr/share/tegaki/models/zinnia/" || die
}
