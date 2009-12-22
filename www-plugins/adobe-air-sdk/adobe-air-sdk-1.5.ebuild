# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-10.0.42.34.ebuild,v 1.2 2009/12/18 13:51:56 pacho Exp $

EAPI=1
inherit nsplugins multilib toolchain-funcs

DESCRIPTION="Adobe Flash Player"
SRC_URI="http://airdownload.adobe.com/air/lin/download/latest/AdobeAIRSDK.tbz2"
HOMEPAGE="http://www.adobe.com/"
IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="AdobeFlash-10"

DEST_DIR="/opt/AIR-SDK/"
DEPEND=">=www-plugins/adobe-flash-10.0.22.87"
RDEPEND="${DEPEND}"

pkg_postinst() {
	mkdir ${DEST_DIR}
	tar xvjf /usr/portage/distfiles/${A} -C ${DEST_DIR}

	cp "${FILESDIR}"/air-sdk.sh /etc/profile.d/
}
