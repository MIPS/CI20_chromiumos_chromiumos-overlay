# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Chrome OS Kernel virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE_KERNEL_VERS=( kernel_next kernel-3_4 kernel-3_8 kernel-3_10 )
IUSE="${IUSE_KERNEL_VERS[*]} kernel_sources"
REQUIRED_USE="?? ( ${IUSE_KERNEL_VERS[*]} )"

RDEPEND="
	kernel_next? ( sys-kernel/chromeos-kernel-next[kernel_sources=] )
	kernel-3_4? ( sys-kernel/chromeos-kernel[kernel_sources=] )
	kernel-3_8? ( sys-kernel/chromeos-kernel-next[kernel_sources=] )
	kernel-3_10? ( sys-kernel/chromeos-kernel-3_10[kernel_sources=] )
"

# Default to the 3.4 kernel if none has been selected. In the future,
# this should point to the latest kernel.
RDEPEND_DEFAULT="sys-kernel/chromeos-kernel"
# Here be dragons!
RDEPEND+="
	$(printf '!%s? ( ' "${IUSE_KERNEL_VERS[@]}")
	${RDEPEND_DEFAULT}[kernel_sources=]
	$(printf '%0.s) ' "${IUSE_KERNEL_VERS[@]}")
"
