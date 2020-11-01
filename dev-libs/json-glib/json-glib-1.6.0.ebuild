# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome3 meson

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="+doc debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc gtk_doc)
		$(meson_feature introspection)
	)

	meson_src_configure
}

