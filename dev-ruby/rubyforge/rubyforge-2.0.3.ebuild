# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/daemons/daemons-1.0.5.ebuild,v 1.7 2007/07/29 19:07:46 dertobi123 Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A script which automates a limited set of rubyforge operations. * Run 'rubyforge help' for complete usage. * Setup: For first time users AND upgrades to 0.4.0: * rubyforge setup (deletes your username and password, so run sparingly!) * edit ~/.rubyforge/user-config.yml * rubyforge config * For all rubyforge upgrades, run 'rubyforge config' to ensure you have latest."
HOMEPAGE="http://codeforpeople.rubyforge.org/rubyforge/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-ruby/json_pure-1.1.7"
RDEPEND="${DEPEND}"
