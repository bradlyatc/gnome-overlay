# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome3 vala meson

DESCRIPTION="Nibbles clone for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	dev-libs/libgee:0.8=
	dev-libs/libgnome-games-support:1
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	media-libs/gsound
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.24.12:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.2
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare
	vala_src_prepare
}
