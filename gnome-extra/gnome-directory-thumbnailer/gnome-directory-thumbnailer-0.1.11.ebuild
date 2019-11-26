# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org xdg-utils gnome2-utils autotools

DESCRIPTION="Thumbnail generator for directories"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeDirectoryThumbnailer"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gdk-pixbuf-2.39.2:2
	>=gnome-base/gnome-desktop-3.34.1:3=
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update 
}

