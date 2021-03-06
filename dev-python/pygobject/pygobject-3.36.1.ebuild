# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ )

inherit eutils virtualx python-r1 meson

SRC_URI="https://download.gnome.org/sources/pygobject/${PV::-2}/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="*"
IUSE="examples +cairo"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.17.0[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
	dev-libs/atk[introspection]
	x11-libs/cairo[glib]
	>=x11-libs/gdk-pixbuf-2.39.2:2[introspection]
	>=x11-libs/gtk+-3.24.12:3[introspection]
	x11-libs/pango[introspection]
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"

src_configure() {

	configuring() {

		# This is run for each python implementation; EPYTHON will be auto-set to the python implementation
		# currently active.

		if ! python_is_python3; then
			# python eclasses install python binaries into this ${T}/${EPYTHON}, and set up python3 ones to be "duds" when
			# we are building for a python2 target (to trigger errors.) Unfortunately, meson.build tries to be
			# smarter than this lame trick and detects that the python3 implementations are broken and dies.
			rm -f ${T}/${EPYTHON}/bin/python3*
		fi

		local emesonargs=(
			-Dpython=${EPYTHON}
			$(meson_use cairo pycairo)
		)

		meson_src_configure
	}

	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir meson_src_install

	dodoc -r examples
}
