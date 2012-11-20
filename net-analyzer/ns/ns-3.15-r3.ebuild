EAPI="4"

inherit python waf-utils scons-utils

DESCRIPTION="ns-3 is a discrete-event network simulator for Internet
systems, targeted primarily for research and educational use. ns-3 is
free software, licensed under the GNU GPLv2 license, and is publicly
available for research, development, and use."

SRC_URI="http://www.nsnam.org/release/${PN}-allinone-${PV}.tar.bz2"
HOMEPAGE="http://www.nsnam.org/"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="mpi gsl sudo examples static-libs test python debug netanim doc"

RDEPEND="
	mpi? ( sys-cluster/openmpi )
	gsl? ( sci-libs/gsl )
	python? (
		dev-python/gnome-desktop-python
		dev-python/pygccxml
		dev-python/pygoocanvas
		dev-python/pygraphviz
		dev-python/kiwi
	)
	netanim? (
		x11-libs/qt-svg:4
	)
	doc? (
		app-text/texlive[extra,graphics,png]
		app-doc/doxygen
		media-gfx/imagemagick[graphviz,svg,png]
		app-office/dia[cairo]
	)
"

DEPEND="${RDEPEND}
	sys-devel/gcc[-nocxx]
"

PYTHON_DEPEND="2"
S="${WORKDIR}/${PN}-allinone-${PV}/${P}"
WAF_BINARY="${S}/waf"

NETANIM_VERSION="3.101"
NETANIM_PROJECT="NetAnim.pro"

NSC_VERSION="0.5.3"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {

	local conf="$(use_enable examples) $(use_enable test)s"
	local profile="release"

	use debug && profile="debug"
	use sudo && conf="${conf} --enable-sudo"
	use static-libs && conf="${conf} --enable-static"
	use mpi && conf="${conf} --enable-mpi"
	use python || conf="${conf} --disable-python"

	waf-utils_src_configure --build-profile $profile $conf "$@"

	if use netanim; then
		cd "${S}/../netanim-${NETANIM_VERSION}"
		qmake "${NETANIM_PROJECT}"
		cd "${S}"
	fi

}

src_compile() {

	waf-utils_src_compile "$@"

	if use doc; then
		${WAF_BINARY} doxygen
	fi

	if use netanim; then
		cd "${S}/../netanim-${NETANIM_VERSION}"
		make
		cd "${S}"
	fi

}

src_test() {
	if use test; then
		$(PYTHON) test.py || die "test failed"
	fi
}

src_install() {

	waf-utils_src_install "$@"

	if use doc; then
		dodoc -r doc/html
	fi

	if use python; then
		insinto "$(python_get_sitedir)"
		doins -r src/visualizer/visualizer
	fi

	if use netanim; then
		dobin "${S}/../netanim-${NETANIM_VERSION}/NetAnim"
	fi

}
