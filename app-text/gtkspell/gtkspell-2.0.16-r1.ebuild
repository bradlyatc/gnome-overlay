# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Spell checking widget for GTK"
HOMEPAGE="http://gtkspell.sourceforge.net/"
# gtkspell doesn't use sourceforge mirroring system it seems.
SRC_URI="http://${PN}.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="*"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=app-text/enchant-1.1.6"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README ) # NEWS file is empty

src_prepare() {
	# Fix intltoolize broken file, see upstream #577133
	sed -i -e "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" po/Makefile.in.in || die
	epatch "${FILESDIR}"/${P}-enchant2.patch
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files
}
