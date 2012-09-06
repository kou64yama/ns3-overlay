# -*- tab-width: 4; indent-tabs-mode: t; -*-

EAPI="3"

inherit waf-utils python

DESCRIPTION="ns-3 is a discrete-event network simulator for Internet systems, targeted primarily for research and educational use. ns-3 is free software, licensed under the GNU GPLv2 license, and is publicly available for research, development, and use."
SRC_URI="http://www.nsnam.org/release/${PN}-allinone-${PV}.tar.bz2"
HOMEPAGE="http://www.nsnam.org/"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="sudo examples static-libs python pyviz mpi debug optimization gsl test"

RDEPEND="
    dev-libs/libxml2
    mpi? ( sys-cluster/openmpi )
    python? (
        dev-lang/python[threads]
        dev-python/pygccxml
    )
    pyviz? (
        dev-python/gnome-desktop-python
        dev-python/librsvg-python
        dev-python/pygoocanvas
        dev-python/pygraphviz
        dev-python/kiwi
    )
    gsl? ( sci-libs/gsl )"

DEPEND="${RDEPEND}
    dev-lang/python
    sys-devel/bison
    sys-devel/flex
    sys-devel/gcc[-nocxx,nptl]
    static-libs? ( dev-db/sqlite:3[threadsafe] )"

S="${WORKDIR}/${PN}-allinone-${PV}/${P}"
WAF_BINARY="${S}/waf"

src_configure() {

	local build_profile myconf

	# set build profile.
	build_profile="release"
	use debug && build_profile="debug"
	use optimization && build_profile="optimized"

	# set configure options.
	myconf="--build-profile $build_profile"
	use sudo && myconf="$myconf --enable-sudo"
	use test && myconf="$myconf --enable-tests"
	myconf="$myconf $(use_enable examples)"
	use static-libs && myconf="$myconf --enable-static"
	use mpi && myconf="$myconf --enable-mpi"
	use python || myconf="$myconf --disable-python"

	# run waf configuration.
	# CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" \
	./waf --prefix=$EPREFIX/usr $myconf configure \
		|| die "configure failed"

}

src_install() {

	waf-utils_src_install

	# # set build profile.
	# build_profile="release"
	# use debug && build_profile="debug"
	# use optimization && build_profile="optimized"

	# # install python wrapper.
	# if use python; then
	# 	insinto "$(python_get_sitedir)"
	# 	doins -r build/$build_profile/bindings/python/*
	# fi

	# install visualizer module.
	if use pyviz; then
		insinto "$(python_get_sitedir)"
		doins -r src/visualizer/visualizer
	fi

}
