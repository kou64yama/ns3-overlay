# -*- tab-width: 4; indent-tabs-mode: t; -*-

EAPI="3"

inherit waf-utils python

DESCRIPTION="ns-3 is a discrete-event network simulator for Internet systems, targeted primarily for research and educational use. ns-3 is free software, licensed under the GNU GPLv2 license, and is publicly available for research, development, and use."
SRC_URI="http://www.nsnam.org/release/${PN}-allinone-${PV}.tar.bz2"
HOMEPAGE="http://www.nsnam.org/"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="sudo examples static-libs python pyviz mpi debug optimization test doc"

S="${WORKDIR}/${PN}-allinone-${PV}/${P}"

RDEPEND="
    dev-libs/libxml2
    mpi? (
        sys-cluster/openmpi
    )
    python? (
        dev-lang/python[threads]
        =dev-python/pybindgen-0.15.0.785
        dev-python/pygccxml
    )
    pyviz? (
        dev-python/gnome-desktop-python
        dev-python/librsvg-python
        dev-python/pygoocanvas
        dev-python/pygraphviz
        dev-python/kiwi
    )"

DEPEND="${RDEPEND}
    dev-lang/python
    sys-devel/bison
    sys-devel/flex
    sys-devel/gcc[-nocxx,nptl]
    doc? (
        app-doc/docygen[latex]
        app-office/dia[cairo,png]
        app-text/texlive[extra,graphics,png]
        media-gfx/imagemagick[graphviz,png,svg]
    )
    static-libs? (
        dev-db/sqlite:3[threadsafe]
    )"

WAF_BINARY="${S}/waf"

src_configure() {

	debug-print-function ${FUNCNAME} "$@"

	# set debug level.
	debuglevel="release"
	use debug && debuglevel="debug"
	use optimization && debuglevel="optimized"

	# make configure options.
	use python || myconf="$myconf --disable-python"
	use mpi && myconf="$myconf --enable-mpi"
	use sudo && myconf="$myconf --enable-sudo"
	use static-libs && myconf="$myconf --enable-static"
	myconf="$myconf $(use_enable examples)"
	myconf="$myconf $(use_enable test)s"

	# run waf configuration.
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" ./waf \
		-d $debuglevel --prefix=$EPREFIX/usr $myconf \
		configure || die "configure failed"

}

src_install() {

	# install python wrapper.
	if use python; then
		insinto "$(python_get_sitedir)"
		doins build/$debuglevel/bindings/python/*
		insinto "$(python_get_sitedir)/ns"
		doins build/$debuglevel/bindings/python/ns/*
	fi

	# install visualizer module.
	if use pyviz; then
		insinto "$(python_get_sitedir)/visualizer"
		doins src/visualizer/visualizer/*
		insinto "$(python_get_sitedir)/visualizer/plugins"
		doins src/visualizer/visualizer/plugins/*
		insinto "$(python_get_sitedir)/visualizer/resource"
		doins src/visualizer/visualizer/resource/*
	fi

	waf-utils_src_install

}
