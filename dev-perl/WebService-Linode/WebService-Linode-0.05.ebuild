# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON/JSON-2.16.ebuild,v 1.1 2009/10/17 11:14:11 tove Exp $

EAPI=2

MODULE_AUTHOR=MIKEGRB
inherit perl-module

DESCRIPTION="Perl interface to Linode.com API"

SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""


RDEPEND="dev-perl/JSON"
DEPEND="${RDEPEND}"

SRC_TEST="do"

