# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome3 pax-utils meson

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
KEYWORDS="*"

IUSE="+cairo elibc_glibc examples gtk readline test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=

	sys-libs/readline:0
	dev-lang/spidermonkey:78
	virtual/libffi
	cairo? ( x11-libs/cairo[X] )
	gtk? ( x11-libs/gtk+:3 )
	elibc_glibc? ( >=dev-util/sysprof-3.38 )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs

	local emesonargs=(
		-Dsystemtap=false
		-Ddtrace=false
		$(meson_feature elibc_glibc profiler)
		$(meson_feature readline)
		$(meson_feature cairo)
		$(meson_use test skip_dbus_tests)
		-Dinstalled_tests=false
		$(meson_use gtk skip_gtk_tests)
		-Dverbose_logs=false
		-Dbsymbolic_functions=false
		-Dspidermonkey_rtti=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}
