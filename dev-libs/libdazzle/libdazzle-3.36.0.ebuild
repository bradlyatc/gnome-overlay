# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome3 meson vala

DESCRIPTION="Experimental new features for GTK+ and GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"

DEPEND="${RDEPEND}
	>=dev-util/meson-0.47.2
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-lang/vala
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection with_introspection)
		$(meson_use gtk-doc enable_gtk_doc)
	)
	meson_src_configure
}
