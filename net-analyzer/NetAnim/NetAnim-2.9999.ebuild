# -*- tab-width: 4; indent-tabs-mode: t; -*-

EAPI="2"

inherit qt4-r2 mercurial

DESCRIPTION="NetAnim is an animator based on the multi-platform QT4 GUI toolkit. NetAnim can animate a simulation using offline trace files (basic-mode) or it can animate while simulation is running (advanced-mode). NetAnim's advanced-mode also supports some basic statistics collection"

HOMEPAGE="http://www.nsnam.org/wiki/index.php/NetAnim"
KEYWORDS=""
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
x11-libs/qt-core
x11-libs/qt-svg
"

DEPEND="${RDEPEND}"

EHG_REPO_URI="http://code.nsnam.org/jabraham3/netanim"

qt4-r2_src_install () {
	exeinto "${EPREFIX}/usr/bin"
	doexe "${PN}"
}
