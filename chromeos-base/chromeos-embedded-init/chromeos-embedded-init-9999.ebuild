# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_PROJECT="chromiumos/platform/init"
CROS_WORKON_LOCALNAME="init"

inherit cros-workon

DESCRIPTION="Upstart jobs that will be installed on embedded CrOS images"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+vt"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/rootdev
	sys-apps/upstart
"

src_install() {
	into /	# We want /sbin, not /usr/sbin, etc.

	# Install Upstart configuration files.
	dodir /etc/init
	insinto /etc/init
	doins startup.conf
	doins embedded-init/boot-services.conf
	doins embedded-init/login-prompt-visible.conf

	# TODO(cmasone): Either use getty across the whole source tree, or
	# convince busybox that it can simulate agetty.  Or something.
	# http://crosbug.com/39188
	dosbin embedded-init/agetty

	doins boot-complete.conf cgroups.conf cron-lite.conf dbus.conf
	doins failsafe-delay.conf failsafe.conf halt.conf install-completed.conf
	doins ip6tables.conf iptables.conf pre-shutdown.conf pstore.conf
	doins reboot.conf shill.conf shill_respawn.conf syslog.conf
	doins system-services.conf update-engine.conf wpasupplicant.conf

	use vt && doins tty2.conf

	insinto /etc
	doins issue rsyslog.chromeos

	# Install startup/shutdown scripts.
	dosbin "${S}/embedded-init/chromeos_startup"
	dosbin "${S}/embedded-init/chromeos_shutdown"

	# Install log cleaning script and run it daily.
	into /usr
	dosbin chromeos-cleanup-logs
}
