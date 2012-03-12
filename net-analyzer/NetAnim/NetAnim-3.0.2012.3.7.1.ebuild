# -*- tab-width: 4; indent-tabs-mode: t; -*-

EAPI="2"

inherit qt4-r2 versionator

DESCRIPTION="NetAnim is an animator based on the multi-platform QT4 GUI toolkit. NetAnim can animate a simulation using offline trace files (basic-mode) or it can animate while simulation is running (advanced-mode). NetAnim's advanced-mode also supports some basic statistics collection"

HOMEPAGE="http://www.nsnam.org/wiki/index.php/NetAnim"
KEYWORDS="~amd64 ~x86"

MY_PV="$(get_version_component_range 1-2)-Mar-$(get_version_component_range 5)-$(get_version_component_range 3)-$(get_version_component_range 6)"

SRC_URI="http://www.nsnam.org/tools/netanim.${MY_PV}.tgz"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
x11-libs/qt-core
"
DEPEND="${RDEPEND}"

src_install () {
	exeinto "${EPREFIX}/usr/bin"
	doexe "${PN}"
}
