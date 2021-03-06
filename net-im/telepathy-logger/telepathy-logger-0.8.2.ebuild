# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Telepathy Logger is a session daemon that should be activated whenever telepathy is being used"
HOMEPAGE="https://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="*"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.2[introspection?]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	# --enable-debug needed due to https://bugs.freedesktop.org/show_bug.cgi?id=83390
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_test() {
	virtx emake -j1 check
}
