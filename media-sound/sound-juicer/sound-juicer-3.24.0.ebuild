# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="CD ripper for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/SoundJuicer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="debug flac test vorbis"

COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.62.2:2[dbus]
	>=x11-libs/gtk+-3.24.12:3
	media-libs/libcanberra[gtk3]
	>=app-cdr/brasero-2.90
	sys-apps/dbus
	gnome-base/gsettings-desktop-schemas

	>=media-libs/libdiscid-0.4.0
	>=media-libs/musicbrainz-5.0.1:5=

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[vorbis?]
	flac? ( media-plugins/gst-plugins-flac:1.0 )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[cdda,udev]
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	media-plugins/gst-plugins-meta:1.0
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.3 )
"

src_prepare() {
	gnome2_src_prepare

	# FIXME: gst macros does not take GST_INSPECT override anymore but we need a
	# way to disable inspection due to gst-clutter always creating a GL context
	# which is forbidden in sandbox since it needs write access to
	# /dev/card*/dri
	sed -e "s|\(gstinspect=\).*|\1$(type -P true)|" \
		-i configure || die
}

src_configure() {
	gnome2_src_configure \
		$(usex debug --enable-debug=yes ' ')
}
