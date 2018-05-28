# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome-meson versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="GNOME Shell, next generation desktop shell"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/gnome-shell/3.28/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
