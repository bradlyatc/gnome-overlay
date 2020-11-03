# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )
VALA_USE_DEPEND="vapigen"
VALA_MAX_API_VERSION=0.48

inherit gnome3 meson python-any-r1 vala


DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"
KEYWORDS="*"
RESTRICT="userpriv"

IUSE="gtk-doc gssapi +introspection samba +vala"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND="
	app-arch/brotli
	>=dev-libs/glib-2.66.0:2
	>=net-libs/glib-networking-2.66.0[ssl]
	>=net-libs/libpsl-0.20.0
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-db/sqlite-3.8.2:3
	gssapi? ( virtual/krb5 )
	introspection? ( >=dev-libs/gobject-introspection-1.66.1:= )
	samba? ( net-fs/samba )
	gtk-doc? ( >=dev-util/gtk-doc-1.20
		app-text/docbook-xml-dtd:4.1.2 )
"

DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.20
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1
	vala? ( $(vala_depend) )
"

RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature gssapi)
		$(meson_feature introspection)
		$(meson_feature samba ntlm)
		$(meson_feature vala vapi)
		-Dntlm_auth="${EPREFIX}/usr/bin/ntlm_auth"
		$(meson_use gtk-doc gtk_doc)
)

	meson_src_configure
}
