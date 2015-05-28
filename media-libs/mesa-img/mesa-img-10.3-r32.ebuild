# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-7.9.ebuild,v 1.3 2010/12/05 17:19:14 arfrever Exp $

EAPI=4

CROS_WORKON_COMMIT="129178893b2260df22db96327c5ca9c2ce7db046"
CROS_WORKON_TREE="eae32bfb0d15e04a165f2eea7d2aba97b26c3264"

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa"
CROS_WORKON_BLACKLIST="1"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit base autotools multilib flag-o-matic python toolchain-funcs ${GIT_ECLASS} cros-workon

OPENGL_DIR="xorg-x11"

MY_PN="${PN/m/M}"
MY_P="${MY_PN}-${PV/_/-}"
MY_SRC_P="${MY_PN}Lib-${PV/_/-}"

FOLDER="${PV/_rc*/}"
[[ ${PV/_rc*/} == ${PV} ]] || FOLDER+="/RC"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

#SRC_PATCHES="mirror://gentoo/${P}-gentoo-patches-01.tar.bz2"
if [[ $PV = 9999* ]] || [[ -n ${CROS_WORKON_COMMIT} ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/${FOLDER}/${MY_SRC_P}.tar.bz2
		${SRC_PATCHES}"
fi

# Most of the code is MIT/X11.
# ralloc is LGPL-3
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT LGPL-3 SGI-B-2.0"
SLOT="0"
KEYWORDS="*"

INTEL_CARDS="intel"
RADEON_CARDS="radeon"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} mach64 mga nouveau powervr r128 savage sis vmware tdfx via freedreno"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	+classic debug dri egl +gallium -gbm gles1 gles2 +llvm +nptl pic selinux
	shared-glapi kernel_FreeBSD xlib-glx X"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.50"

# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	!media-libs/mesa
	X? (
		!<x11-base/xorg-server-1.7
		!<=x11-proto/xf86driproto-2.0.3
		>=x11-libs/libX11-1.3.99.901
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	dev-libs/expat
	sys-fs/udev
	${LIBDRM_DEPSTRING}
"

DEPEND="${RDEPEND}
	=dev-lang/python-2*
	dev-libs/libxml2
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	>=x11-proto/dri2proto-2.6
	X? (
		>=x11-proto/glproto-1.4.11
		>=x11-proto/xextproto-7.0.99.1
		x11-proto/xf86driproto
		x11-proto/xf86vidmodeproto
	)
	!arm? ( sys-devel/llvm )
	video_cards_powervr? ( virtual/img-ddk )
"

S="${WORKDIR}/${MY_P}"

# It is slow without texrels, if someone wants slow
# mesa without texrels +pic use is worth the shot
QA_EXECSTACK="usr/lib*/opengl/xorg-x11/lib/libGL.so*"
QA_WX_LOAD="usr/lib*/opengl/xorg-x11/lib/libGL.so*"

# Think about: ggi, fbcon, no-X configs

pkg_setup() {
	# workaround toc-issue wrt #386545
	use ppc64 && append-flags -mminimal-toc
}

src_prepare() {
	# apply patches
	if [[ ${PV} != 9999* && -n ${SRC_PATCHES} ]]; then
		EPATCH_FORCE="yes" \
		EPATCH_SOURCE="${WORKDIR}/patches" \
		EPATCH_SUFFIX="patch" \
		epatch
	fi
	# FreeBSD 6.* doesn't have posix_memalign().
	if [[ ${CHOST} == *-freebsd6.* ]]; then
		sed -i \
			-e "s/-DHAVE_POSIX_MEMALIGN//" \
			configure.ac || die
	fi

	epatch "${FILESDIR}"/10.0-cross-compile.patch
	epatch "${FILESDIR}"/9.1-mesa-st-no-flush-front.patch
	epatch "${FILESDIR}"/10.3-state_tracker-gallium-fix-crash-with-st_renderbuffer.patch
	epatch "${FILESDIR}"/10.3-state_tracker-gallium-fix-crash-with-st_renderbuffer-freedreno.patch
	epatch "${FILESDIR}"/10.0-force_s3tc_enable.patch
	epatch "${FILESDIR}"/9.0-i965-Allow-the-case-where-multiple-flush-types-are-e.patch
	epatch "${FILESDIR}"/8.1-array-overflow.patch
	epatch "${FILESDIR}"/10.3-fix-compile-disable-asm.patch
	epatch "${FILESDIR}"/10.3-0004-draw-Move-llvm-stuff-to-be-cached-to-new-struct.patch
	epatch "${FILESDIR}"/10.3-0005-draw-cache-LLVM-compilation.patch
	epatch "${FILESDIR}"/10.3-0006-draw-keep-some-unused-items-in-the-llvm-cache.patch
	epatch "${FILESDIR}"/9.1-i915g-force-xtiling.patch
	epatch "${FILESDIR}"/10.0-no-fail-hwctx.patch
	epatch "${FILESDIR}"/9.1-renderbuffer_0sized.patch
	epatch "${FILESDIR}"/10.0-i965-Disable-ctx-gen6.patch
	epatch "${FILESDIR}"/10.3-dri-i965-Return-NULL-if-we-don-t-have-a-miptree.patch
	epatch "${FILESDIR}"/10.3-Fix-workaround-corner-cases.patch
	epatch "${FILESDIR}"/10.3-drivers-dri-i965-gen6-Clamp-scissor-state-instead-of.patch
	epatch "${FILESDIR}"/10.3-gbm-dlopen-libglapi-so-gbm_create_device-works.patch
	epatch "${FILESDIR}"/10.3-i965-remove-read-only-restriction-of-imported-buffer.patch
	epatch "${FILESDIR}"/10.3-Revert-patches-which-caused-compilation-error-when-u.patch
	epatch "${FILESDIR}"/10.3-egl-dri2-implement-platform_null.patch
	epatch "${FILESDIR}"/10.5-Revert-i965-Delete-CACHE_NEW_BLORP_CONST_COLOR_PROG.patch
	epatch "${FILESDIR}"/10.5-UPSTREAM-i965-Restore-brw_blorp_clear-for-gen6.patch
	epatch "${FILESDIR}"/10.3-egl-dri2-try-to-use-render-node-if-available.patch
	epatch "${FILESDIR}"/10.3-egl-dri2-report-EXT_image_dma_buf_import-extension.patch
	epatch "${FILESDIR}"/10.3-egl-dri2-add-support-for-image-config-query.patch
	epatch "${FILESDIR}"/10.3-egl-dri2-platform_drm-should-also-try-rende.patch
	epatch "${FILESDIR}"/10.3-dri-add-swrast-support-on-top-of-prime-imported.patch
	epatch "${FILESDIR}"/10.3-intel-fix-EGLImage-renderbuffer-_BaseFormat.patch
	epatch "${FILESDIR}"/10.5-i965-Prefer-Meta-over-the-BLT-for-BlitFrame.patch
	epatch "${FILESDIR}"/10.4-enable-GL_EXT_draw_buffers.patch

	# IMG patches
	epatch "${FILESDIR}"/0000-Add-pvr-dri-driver-to-the-Mesa-build.patch
	epatch "${FILESDIR}"/0001-Add-support-for-various-GLES-extensions.patch
	epatch "${FILESDIR}"/0004-Ensure-x-creates-pbuffers-with-non-zero-size.patch
	epatch "${FILESDIR}"/0007-Add-EGL_IMG_context_priority-EGL-extension.patch
	epatch "${FILESDIR}"/0008-Extend-EGL-KHR-sync-object-support.patch
	epatch "${FILESDIR}"/0019-dri-Add-some-new-DRI-formats-and-fourccs.patch
	epatch "${FILESDIR}"/0024-egl-Add-eglQuerySurface-surface-type-check-for-EGL_L.patch
	epatch "${FILESDIR}"/0025-egl-clamp-size-to-0-in-_eglFlattenArray.patch
	epatch "${FILESDIR}"/0028-dri-set-the-__DRI_API_OPENGL-bit-based-on-max-gl-com.patch
	epatch "${FILESDIR}"/0001-GL_EXT_robustness-entry-points.patch
	epatch "${FILESDIR}"/0049-egl-dri-Add-a-bad-access-error-code-to-the-DRI-inter.patch
	epatch "${FILESDIR}"/0050-dri-Add-MT12-DRI-fourcc.patch

	base_src_prepare

	eautoreconf
}

src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	driver_enable pvr

	export LLVM_CONFIG=${SYSROOT}/usr/bin/llvm-config-host

	# --with-driver=dri|xlib|osmesa || do we need osmesa?
	econf \
		--disable-option-checking \
		--with-driver=dri \
		--disable-glu \
		--disable-glut \
		--without-demos \
		--enable-texture-float \
		--disable-dri3 \
		--disable-llvm-shared-libs \
		$(use_enable X glx) \
		$(use_enable llvm llvm-gallium) \
		$(use_enable egl) \
		$(use_enable gbm) \
		$(use_enable gles1) \
		$(use_enable gles2) \
		$(use_enable shared-glapi) \
		$(use_enable gallium) \
		$(use_enable debug) \
		$(use_enable nptl glx-tls) \
		$(use_enable !pic asm) \
		$(use_enable xlib-glx) \
		$(use_enable !xlib-glx dri) \
		--with-dri-drivers=${DRI_DRIVERS} \
		--with-gallium-drivers=${GALLIUM_DRIVERS} \
		$(use egl && ! use X && echo "--with-egl-platforms=null")
}

src_install() {
	base_src_install

	# Remove redundant headers
	# GLU and GLUT
	rm -f "${D}"/usr/include/GL/glu*.h || die "Removing GLU and GLUT headers failed."
	# Glew includes
	rm -f "${D}"/usr/include/GL/{glew,glxew,wglew}.h \
		|| die "Removing glew includes failed."

	# Remove GLES libraries as IMG DDK installs its own versions.
	rm -f "${D}"/usr/$(get_libdir)/libGLES*

	# Move libGL and others from /usr/lib to /usr/lib/opengl/blah/lib
	# because user can eselect desired GL provider.
	ebegin "Moving libGL and friends for dynamic switching"
		dodir /usr/$(get_libdir)/opengl/${OPENGL_DIR}/{lib,extensions,include}
		local x
		for x in "${D}"/usr/$(get_libdir)/libGL.{la,a,so*}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/lib \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${D}"/usr/include/GL/{gl.h,glx.h,glext.h,glxext.h}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/include \
					|| die "Failed to move ${x}"
			fi
		done
	eend $?

	dodir /usr/$(get_libdir)/dri
	insinto "/usr/$(get_libdir)/dri/"
	insopts -m0755
	# install the gallium drivers we use
	local gallium_drivers_files=( i915_dri.so nouveau_dri.so r300_dri.so r600_dri.so msm_dri.so swrast_dri.so )
	for x in ${gallium_drivers_files[@]}; do
		if [ -f "${S}/$(get_libdir)/gallium/${x}" ]; then
			doins "${S}/$(get_libdir)/gallium/${x}"
		fi
	done

	# install classic drivers we use
	local classic_drivers_files=( i810_dri.so i965_dri.so nouveau_vieux_dri.so radeon_dri.so r200_dri.so )
	for x in ${classic_drivers_files[@]}; do
		if [ -f "${S}/$(get_libdir)/${x}" ]; then
			doins "${S}/$(get_libdir)/${x}"
		fi
	done

	# Set driconf option to enable S3TC hardware decompression
	insinto "/etc/"
	doins "${FILESDIR}"/drirc
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			DRI_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					DRI_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
gallium_driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			GALLIUM_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					GALLIUM_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}
