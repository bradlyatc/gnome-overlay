# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx

HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"

IUSE="aqua debug doc egl gtk +introspection test wayland X"
REQUIRED_USE="
	|| ( aqua wayland X )
	wayland? ( egl )
"

KEYWORDS="*"

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# >=libX11-1.3.1 needed for X Generic Event support
# do not depend on tslib, it does not build and is disabled by default upstream
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/atk-2.5.3[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=media-libs/cogl-1.21.2:1.0=[introspection?,pango]
	>=x11-libs/cairo-1.16.0:=[aqua?,glib]
	>=x11-libs/pango-1.44.7[introspection?]

	virtual/opengl
	x11-libs/libdrm:=

	egl? (
		>=dev-libs/libinput-0.19.0
		media-libs/cogl[gles2]
		>=virtual/libgudev-136
		x11-libs/libxkbcommon
	)
	gtk? ( >=x11-libs/gtk+-3.24.12:3[aqua?] )
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	X? (
		media-libs/fontconfig
		>=x11-libs/libX11-1.3.1
		x11-libs/libXext
		x11-libs/libXdamage
		x11-proto/inputproto
		>=x11-libs/libXi-1.3
		>=x11-libs/libXcomposite-0.4 )
	wayland? (
		dev-libs/wayland
		media-libs/cogl[wayland]
		x11-libs/gdk-pixbuf:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
	test? ( x11-libs/gdk-pixbuf )
"

src_prepare() {
	if ! use wayland; then
		# From GNOME:
		# 	https://git.gnome.org/browse/clutter/commit/?id=be8602fbb491c30c1e2febb92553375b2f4ce584
		eapply "${FILESDIR}"/${PN}-1.26.2-reorganize-backends.patch
	fi

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/mutter/commit/31779404f0e083fba11d1d263f278154e0580374
	eapply "${FILESDIR}"/${PN}-1.26.2-clutter-avoid-unnecessary-relayouts-in-cluttertext.patch

	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1 accessibility conform/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\)[^\]*/\1  accessibility conform/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	gnome2_src_prepare
}

src_configure() {
	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# (GLX error blabla)
	# XXX: coverage disabled for now
	# XXX: What about cex100/win32 backends?
	gnome2_src_configure \
		--disable-maintainer-flags \
		--disable-mir-backend \
		--disable-gcov \
		--disable-cex100-backend \
		--disable-win32-backend \
		--disable-tslib-input \
		$(use_enable aqua quartz-backend) \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable doc docs) \
		$(use_enable egl egl-backend) \
		$(use_enable egl evdev-input) \
		$(use_enable gtk gdk-backend) \
		$(use_enable introspection) \
		$(use_enable test gdk-pixbuf) \
		$(use_enable wayland wayland-backend) \
		$(use_enable wayland wayland-compositor) \
		$(use_enable X xinput) \
		$(use_enable X x11-backend)
}

src_test() {
	virtx emake check -C tests/conform
}
