# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="+bluetooth +cdr cups"

# Note to developers:
# This is a wrapper for the core apps tightly integrated with GNOME 3
# gtk-engines:2 is still around because it's needed for gtk2 apps
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-${PV}
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}

	>=app-crypt/gcr-${PV}
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-${PV}
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.34
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-3.36
	>=media-gfx/eog-${PV}
	>=media-video/totem-3.34
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/adwaita-icon-theme-${PV}
	>=x11-themes/gnome-themes-standard-3.22

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.34.1 )
	cdr? ( >=app-cdr/brasero-3.12.2 )

	!gnome-base/gnome-applets
"
DEPEND=""

S="${WORKDIR}"
