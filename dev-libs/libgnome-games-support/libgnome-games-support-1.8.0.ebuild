# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"

inherit gnome3 meson vala

DESCRIPTION="Library for code common to Gnome games"
HOMEPAGE="https://git.gnome.org/browse/libgnome-games-support/"

LICENSE="LGPL-3+"
SLOT="1/3"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-libs/libgee:0.8=
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3
"
DEPEND="${DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome3_src_prepare
}
