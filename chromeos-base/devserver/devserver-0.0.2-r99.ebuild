# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="c36bf11fae7706bd1ec6f74b4d7494f737eefa59"
CROS_WORKON_TREE="bba4f49f22dd702c5029cc1e9722d95bcca5b3ea"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon python

DESCRIPTION="Server to cache Chromium OS build artifacts from Google Storage."
HOMEPAGE="http://dev.chromium.org/chromium-os/how-tos-and-troubleshooting/using-the-dev-server"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!<chromeos-base/cros-devutils-0.0.2
	chromeos-base/devserver-deps"
DEPEND=""

src_install() {
	emake install DESTDIR="${D}"

	insinto "$(python_get_sitedir)/update_payload"
	doins $(printf '%s\n' host/lib/update_payload/*.py | grep -v unittest)
	doins host/lib/update_payload/update-payload-key.pub.pem
	dobin host/start_devserver
}
