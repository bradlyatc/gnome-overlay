# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
KEYWORDS="*"

IUSE="+crypt doc debug +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=x11-libs/pango-1.44.7

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gperf
	dev-libs/libxml2
	dev-util/gtk-doc
	sys-devel/gettext
	dev-util/glib-utils

	vala? ( $(vala_depend) )
"
BDEPEND="
	>=dev-util/gtk-doc-am-1.13
        >=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/vte-0.58.0-cntnr-precmd-preexec-scroll.patch

	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use debug debugg)
		$(meson_use doc docs)
		$(meson_use introspection gir)
		$(meson_use crypt gnutls)
		-Dfribidi=true
		-Dgtk3=true
		-Dgtk4=false
		-Diconv=true
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
