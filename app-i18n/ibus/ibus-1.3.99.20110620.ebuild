# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# How to run the test:
#   (chroot)$ sudo env FEATURES="test" emerge -a ibus

EAPI="2"
inherit eutils flag-o-matic toolchain-funcs multilib python

DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="http://code.google.com/p/ibus/"

SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}_unofficial.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="doc nls python"
#RESTRICT="mirror"

RDEPEND="python? ( >=dev-lang/python-2.5 )
	>=dev-libs/glib-2.26
	python? ( >=dev-python/pygobject-2.14 )
	nls? ( virtual/libintl )
	>=x11-libs/gtk+-2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.9 )
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"
RDEPEND="${RDEPEND}
	python? ( >=dev-python/dbus-python-0.83 )
	python? ( dev-python/pygtk )
	python? ( dev-python/pyxdg )"

pkg_setup() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0/}
}

src_prepare() {
	# Since these two patches are for Python files, we don't have to apply
	# them.
	#epatch "${FILESDIR}"/0001-Merge-xkb-related-changes.patch
	#epatch "${FILESDIR}"/0002-Support-changing-the-global-input-method-engine-with.patch

	epatch "${FILESDIR}"/0003-Change-default-values-of-some-config.patch
	epatch "${FILESDIR}"/0004-Add-api-to-ibus-for-retreiving-unused-config-values.patch
	epatch "${FILESDIR}"/0005-Remove-bus_input_context_register_properties-props_e.patch
	epatch "${FILESDIR}"/0006-Port-the-following-ibus-1.3-patches-to-1.4.patch

	# TODO(yusukes): Submit this to https://github.com/ibus/ibus-cros
	epatch "${FILESDIR}"/ignore_non_fatal_warnings_in_src_tests.patch
}

src_configure() {
	# When cross-compiled, we build the gtk im module. Otherwise we don't
	# since the module is not necessary for host environment.
	if tc-is-cross-compiler ; then
	       GTK2_IM_MODULE_FLAG=--enable-gtk2
	else
	       GTK2_IM_MODULE_FLAG=--disable-gtk2
	fi

	# TODO(yusukes): Fix ibus and remove -Wno-unused-variable.
	append-cflags -Wall -Wno-unused-variable -Werror
	# TODO(petkov): Ideally, configure should support --disable-isocodes but it
	# seems that the current version doesn't, so use the environment variables
	# instead to remove the dependence on iso-codes.
	econf \
		${GTK2_IM_MODULE_FLAG} \
		--disable-gconf \
		--disable-xim \
		--disable-key-snooper \
		--enable-memconf \
		--disable-vala \
		--enable-introspection=no \
		$(use_enable doc gtk-doc) \
		$(use_enable nls) \
		$(use_enable python) \
		CPPFLAGS='-DOS_CHROMEOS=1' \
		ISOCODES_CFLAGS=' ' ISOCODES_LIBS=' ' \
		|| die
}

test_fail() {
	kill $IBUS_DAEMON_PID
	rm -rf /tmp/ibus
	die
}

src_test() {
	# Do not execute the test when cross-compiled.
	if tc-is-cross-compiler ; then
	   return
	fi

	# The chroot environment usually does not have /var/lib/dbus/machine-id.
	# We can safely use "dummy-machine-id" in this case.
	DBUS_MACHINE_ID="dummy-machine-id"
	if [ -f /var/lib/dbus/machine-id ] ; then
	   DBUS_MACHINE_ID=`cat /var/lib/dbus/machine-id`
	fi

	# Start ibus-daemon background. XDG_CONFIG_HOME variable is necessary
	# to make g_get_user_config_dir() Glib function happy.
	env XDG_CONFIG_HOME=/tmp ./bus/ibus-daemon --replace --panel=disable &
	IBUS_DAEMON_PID=$!

	# Wait for the daemon to start.
	if [ ! -f /tmp/ibus/bus/${DBUS_MACHINE_ID}-unix-0 ] ; then
	   sleep .5
	fi

	# Run tests.
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-bus || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-inputcontext || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-inputcontext-create \
	    || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-configservice || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-factory || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-keynames || test_fail
	env XDG_CONFIG_HOME=/tmp ./src/tests/ibus-serializable || test_fail

	# Cleanup.
	kill $IBUS_DAEMON_PID
	rm -rf /tmp/ibus
}

src_install() {
	emake DESTDIR="${D}" install || die
	if [ -f "${D}/usr/share/ibus/component/gtkpanel.xml" ] ; then
		rm "${D}/usr/share/ibus/component/gtkpanel.xml" || die
	fi

	# Remove unnecessary files
	rm -rf "${D}/usr/share/icons" || die
	rm "${D}/usr/share/applications/ibus.desktop" || die

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {

	elog "To use ibus, you should:"
	elog "1. Get input engines from sunrise overlay."
	elog "   Run \"emerge -s ibus-\" in your favorite terminal"
	elog "   for a list of packages we already have."
	elog
	elog "2. Setup ibus:"
	elog
	elog "   $ ibus-setup"
	elog
	elog "3. Set the following in your user startup scripts"
	elog "   such as .xinitrc, .xsession or .xprofile:"
	elog
	elog "   export XMODIFIERS=\"@im=ibus\""
	elog "   export GTK_IM_MODULE=\"ibus\""
	elog "   export QT_IM_MODULE=\"xim\""
	elog "   ibus-daemon -d -x"

	# TODO(yusukes): Add support for a "--root=" option to
	# gtk-query-immodules-2.0 and try to get it upstream.
	( echo '/usr/lib/gtk-2.0/2.10.0/immodules/im-ibus.so';
	  echo '"ibus" "IBus (Intelligent Input Bus)" "ibus" "" "ja:ko:zh:*"' ) > "${ROOT}/${GTK2_CONFDIR}/gtk.immodules"

	if use python; then
		python_mod_optimize /usr/share/${PN}
	fi
}

pkg_postrm() {
	[ "${ROOT}" = "/" -a -x /usr/bin/gtk-query-immodules-2.0 ] && \
		gtk-query-immodules-2.0 > "${ROOT}/${GTK2_CONFDIR}/gtk.immodules"

	if use python; then
		python_mod_cleanup /usr/share/${PN}
	fi
}
