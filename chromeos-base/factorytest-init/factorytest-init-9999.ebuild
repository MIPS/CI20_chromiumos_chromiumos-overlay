# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_PROJECT="chromiumos/platform/factory_test_init"

inherit cros-workon

DESCRIPTION="Upstart jobs for the Chrome OS factory test image"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="chromeos-base/chromeos-init
	sys-apps/coreutils
	sys-apps/upstart
	sys-process/procps
	virtual/modutils
	"

CROS_WORKON_LOCALNAME="factory_test_init"

modify_upstart() {
	local upstart_file="$1"
	local new_rules="$2"
	local upstart_path="${ROOT}/etc/init/${upstart_file}"

	if [ ! -f "$upstart_path" ]; then
		ewarn "Ignore non-exist upstart file: ${upstart_file}"
		return
	fi

	grep -q "^start on " "${upstart_path}" ||
		die "Unknown format in upstart file: ${upstart_file}"

	sed -i "s/^start on .*/start on $new_rules/" "${upstart_path}" ||
		die "Failed to modify upstart file: ${upstart_file}"
}

disable_upstart() {
	modify_upstart "$1" "never"
}

pkg_postinst() {
	# Create factory test image tags
	touch "${ROOT}/root/.factory_test"
	touch "${ROOT}/root/.leave_firmware_alone"

	disable_upstart "ui.conf"
	disable_upstart "update-engine.conf"
	disable_upstart "tlsdated.conf"
	disable_upstart "laptop-mode-boot.conf"
	disable_upstart "laptop-mode-resume.conf"
	disable_upstart "powerd.conf"

	modify_upstart "boot-complete.conf" "started boot-services"
	modify_upstart "chromeos-touch-update.conf" "starting factory"
	modify_upstart "chrontel.conf" "factory-ui-started"
}
