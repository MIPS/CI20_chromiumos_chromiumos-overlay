# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ntfs3g/ntfs3g-2012.1.15-r1.ebuild,v 1.11 2012/04/16 17:51:58 ssuominen Exp $

EAPI=4
inherit linux-info eutils user

MY_PN=${PN/3g/-3g}
MY_P=${MY_PN}_ntfsprogs-${PV}

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="acl crypt debug +external-fuse extras +ntfsprogs static-libs suid +udev xattr"

RDEPEND="!<sys-apps/util-linux-2.19
	!sys-fs/ntfsprogs
	crypt? (
		>=dev-libs/libgcrypt-1.2.2
		>=net-libs/gnutls-1.4.4
		)
	external-fuse? ( >=sys-fs/fuse-2.8.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-apps/attr"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog CREDITS README"

pkg_setup() {
	if use external-fuse && use kernel_linux; then
		if kernel_is lt 2 6 9; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		FUSE_FS_WARNING="You need to have FUSE module built to use ntfs-3g"
		linux-info_pkg_setup
	fi

	# Chrome OS runs the ntfs-3g process under the 'ntfs-3g' user and group,
	# which are created here in pkg_setup such that src_install can change
	# the ntfs-3g binary to be owned by the 'ntfs-3g' group.
	enewuser "ntfs-3g"
	enewgroup "ntfs-3g"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2014.2.15-no-split-usr.patch
}

src_configure() {
	econf \
		--exec-prefix="${EPREFIX}/usr" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable debug) \
		--enable-ldscript \
		--disable-ldconfig \
		$(use_enable acl posix-acls) \
		$(use_enable xattr xattr-mappings) \
		$(use_enable crypt crypto) \
		$(use_enable ntfsprogs) \
		$(use_enable extras) \
		$(use_enable static-libs static) \
		--with-fuse=$(use external-fuse && echo external || echo internal)
}

src_install() {
	default

	# If suid is used, change the ntfs-3g binary to "root:ntfs-3g rws--x---"
	# See crosbug.com/19887 for details.
	if use suid; then
		fowners root:ntfs-3g /usr/bin/${MY_PN}
		fperms u=rwxs,g=x,o= /usr/bin/${MY_PN}
	fi

	if use udev; then
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/99-ntfs3g.rules
	fi

	find "${ED}" -name '*.la' -exec rm -f {} +

	# http://bugs.gentoo.org/398069
	dodir /usr/sbin
	mv -vf "${D}"/sbin/* "${ED}"/usr/sbin || die
	rm -rf "${D}"/sbin

	dosym mount.ntfs-3g /usr/sbin/mount.ntfs #374197
}
