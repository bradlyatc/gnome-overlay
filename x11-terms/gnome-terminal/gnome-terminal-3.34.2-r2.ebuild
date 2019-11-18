# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2 gnome.org xdg readme.gentoo-r1

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="debug +gnome-shell +nautilus"

RDEPEND="
	>=dev-libs/glib-2.62.2:2[dbus]
	>=x11-libs/gtk+-3.24.12:3[X]
	>=x11-libs/vte-0.58.0
	>=dev-libs/libpcre2-10
	>=gnome-base/dconf-0.14
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-3 )
"
# itstool required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/gdbus-codegen
	dev-util/itstool
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened
	tab you will need to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte.sh"

PATCHES=(
        ##
        ${FILESDIR}/gnome-terminal-3.32.1-desktop-icon.patch
        ## https://bugs.funtoo.org/browse/FL-1652
        ${FILESDIR}/gnome-terminal-3.28.1-disable-function-keys.patch 
	## https://gitlab.gnome.org/GNOME/gnome-terminal/commit/b3c270b3612acd45f309521cf1167e1abd561c09
	${FILESDIR}/gnome-terminal-3.14.3-fix-broken-transparency-on-startup.patch
	## https://src.fedoraproject.org/rpms/gnome-terminal/tree/f31
	${FILESDIR}/gnome-terminal-3.28.1-build-dont-treat-warnings-as-errors.patch
	${FILESDIR}/gnome-terminal-3.34.0-notify-open-title-transparency.patch
)

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
		gnome2_src_configure \
		--disable-static \
		$(use_enable debug) \
		$(use_enable gnome-shell search-provider) \
		$(use_with nautilus nautilus-extension) \
		VALAC=$(type -P true)
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
