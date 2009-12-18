# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/nginx/nginx-0.7.62.ebuild,v 1.3 2009/09/18 19:22:29 keytoaster Exp $

inherit eutils 

DESCRIPTION="IBM DS3300 SAN Management Utilities"

HOMEPAGE="http://gitorious.org/gitorious"
SRC_URI="http://adrenlinerush.net/package/${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

DEST_DIR="/"
DEPEND="|| ( >=www-client/mozilla-firefox-bin-3.0.11 >=www-client/mozilla-firefox-3.0.11 )"
RDEPEND="${DEPEND}"

pkg_postinst() {
	tar xvf /usr/portage/distfiles/${A} -C ${DEST_DIR}
}


