# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"
PYTHON_COMPAT=( python3_{4,5,6} )

inherit gnome-meson multilib pax-utils python-r1 systemd

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +browser-extension doc +ibus +networkmanager nsplugin -openrc-force +systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"

# libXfixes-5.0 needed for pointer barriers
# FIXME:
#  * gstreamer support is currently automagic
#  * gnome-bluetooth is automagic
#  * BROWSER_PLUGIN_DIR is not set
COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.5.3
	>=dev-libs/atk-2[introspection]
	>=app-crypt/gcr-3.7.5[introspection]
	>=dev-libs/glib-2.53:2[dbus]
	>=dev-libs/gjs-1.47.0
	>=dev-libs/gobject-introspection-1.49.1:=
	dev-libs/libical:=
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-base/gnome-desktop-3.7.90:3=[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.21.3
	>=gnome-extra/evolution-data-server-3.17.2:=
	>=media-libs/gstreamer-0.11.92:1.0
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.19[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-libs/libXfixes-5.0
	x11-libs/libXtst
	>=x11-wm/mutter-3.26.0:0/0[introspection]
	>=x11-libs/startup-notification-0.11

	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	media-libs/libcanberra[gtk3]
	media-libs/mesa
	>=media-sound/pulseaudio-2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11
	x11-libs/gdk-pixbuf:2[introspection]

	x11-apps/mesa-progs

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.9[introspection] )
	networkmanager? (
		>=app-crypt/libsecret-0.18
		>=gnome-extra/nm-applet-0.9.8
		>=net-misc/networkmanager-0.9.8:=[introspection] )
	nsplugin? ( >=dev-libs/json-glib-0.13.2 )
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated using:
#  grep -roe "imports.gi.*" gnome-shell-* | cut -f2 -d: | sort | uniq
# Each block:
# 1. Introspection stuff needed via imports.gi.*
# 2. gnome-session is needed for gnome-session-quit
# 3. Control shell settings
# 4. Systemd needed for suspending support
# 5. xdg-utils needed for xdg-open, used by extension tool
# 6. adwaita-icon-theme and dejavu font neeed for various icons & arrows
# 7. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c
# 8. IBus is needed for nls integration
RDEPEND="${COMMON_DEPEND}
	app-accessibility/at-spi2-core:2[introspection]
	>=app-accessibility/caribou-0.4.8
	dev-libs/libgweather:2[introspection]
	>=sys-apps/accountsservice-0.6.14[introspection]
	>=sys-power/upower-0.99:=[introspection]
	x11-libs/pango[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	!openrc-force? ( >=sys-apps/systemd-31 )

	x11-misc/xdg-utils

	media-fonts/dejavu
	>=x11-themes/adwaita-icon-theme-3.19.90

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	ibus? ( >=app-i18n/ibus-1.4.99[dconf(+),gtk,introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection]
	>=gnome-base/gnome-control-center-3.8.3[bluetooth(+)?,networkmanager(+)?]
	browser-extension? ( gnome-extra/chrome-gnome-shell )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	dev-lang/sassc
	>=dev-util/gdbus-codegen-2.45.3
	>=dev-util/gtk-doc-am-1.17
	gnome-base/gnome-common
	sys-devel/autoconf-archive
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	gnome-meson_src_configure \
		-Dman=true \
		$(meson_use doc gtk_doc) \
		$(meson_use systemd systemd) \
		$(meson_use networkmanager networkmanager) \
		$(meson_use nsplugin browser_plugin) 
}
