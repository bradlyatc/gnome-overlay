# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3+ )

inherit gnome2 python-any-r1 vala

DESCRIPTION="Compatibility library for accessing secrets"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeKeyring"

LICENSE="LGPL-2+ GPL-2+" # tests are GPL-2
SLOT="0"
IUSE="debug +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libgcrypt-1.2.2:0=
	>=sys-apps/dbus-1
	>=gnome-base/gnome-keyring-3.1.92
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare

	# FIXME: Remove silly CFLAGS, report upstream
	sed -e 's:CFLAGS="$CFLAGS -g:CFLAGS="$CFLAGS:' \
		-e 's:CFLAGS="$CFLAGS -O0:CFLAGS="$CFLAGS:' \
		-i configure.ac configure || die "sed failed"
}

src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable vala)

	ln -s "${S}"/docs/reference/gnome-keyring/html docs/reference/gnome-keyring/html || die
}

src_install() {
	gnome2_src_install
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch emake check || die "tests failed"
}
