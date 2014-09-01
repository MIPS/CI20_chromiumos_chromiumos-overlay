# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/sigrok-cli/sigrok-cli-9999.ebuild,v 1.1 2014/06/14 06:22:26 vapier Exp $

EAPI="5"

CROS_WORKON_COMMIT="902e368ed1dd50b87dd8a93dcae8ca2983f69cc3"
CROS_WORKON_TREE="b698c884b7a9f775e51bf5855f162397dfe4c73e"
CROS_WORKON_PROJECT="chromiumos/third_party/libsigrok-cli"

PYTHON_COMPAT=( python3_{2,3,4} )
inherit cros-workon eutils python-single-r1 autotools

SRC_URI=""
KEYWORDS="*"

DESCRIPTION="Command-line client for the sigrok logic analyzer software"
HOMEPAGE="http://sigrok.org/wiki/Sigrok-cli"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.28.0
	>=sci-libs/libsigrok-0.3.0
	decode? (
		>=sci-libs/libsigrokdecode-0.3.0
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf

	# This is fixed after the 0.5.0 release.
	sed -i \
		-e '/WITH_SRD=$enableval/s:=$enableval:=$withval:' \
		configure || die
}

src_configure() {
	econf $(use_with decode libsigrokdecode)
}
