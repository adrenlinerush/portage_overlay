# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/nginx/nginx-0.7.62.ebuild,v 1.3 2009/09/18 19:22:29 keytoaster Exp $

inherit eutils 

DESCRIPTION="Gitorious aims to provide a great way of doing distributed opensource code collaboration."

HOMEPAGE="http://gitorious.org/gitorious"
SRC_URI="http://gitorious.org/gitorious/mainline/archive-tarball/master"
LICENSE="AGPLv3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="mysql"

DEPEND=">=dev-util/git-1.6.3.3
	>=app-misc/sphinx-0.9.8
	>=dev-ruby/rails-2.3.5
	>=dev-ruby/chronic-0.2.3
	>=dev-ruby/daemons-1.0.10
	>=dev-ruby/diff-lcs-1.1.2
	>=dev-ruby/echoe-4.0
	>=dev-ruby/eventmachine-0.12.10
	>=dev-ruby/fastthread-1.0.7
	>=dev-ruby/geoip-0.8.6
	>=dev-ruby/highline-1.5.1
	>=dev-ruby/hoe-2.4.0
	>=dev-ruby/json-1.2.0
	>=dev-ruby/json_pure-1.2.0
	>=dev-ruby/macaddr-1.0.0
	>=dev-ruby/mime-types-1.16
	>=dev-ruby/net-scp-1.0.2
	>=dev-ruby/net-ssh-2.0.16
	>=dev-ruby/oniguruma-1.1.0
	>=www-misc/passenger-2.2.5
	>=dev-ruby/rack-1.0.1
	>=dev-ruby/rake-0.8.7
	>=dev-ruby/raspell-1.1
	>=dev-ruby/rdiscount-1.3.1.1
	>=dev-ruby/rmagick-2.12.2
	>=dev-ruby/ruby-openid-2.1.7
	>=dev-ruby/rubyforge-2.0.3
	>=dev-ruby/stomp-1.1
	>=dev-ruby/stompserver-0.9.9
	>=dev-ruby/uuid-2.1.0
	>=dev-ruby/mysql-ruby-2.8
	>=dev-ruby/ruby-yadis-0.3.4
	>=dev-ruby/ruby-hmac-0.3.2
	>=www-servers/nginx-0.7.62[passenger,gitorious,ssl]
	mysql? ( >=dev-db/mysql-5.0.84-r1 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	ebegin "Creating gitorious user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}
}

src_unpack() {
	unpack ${A}
}

src_install() {
	dodir /var/www/gitorious/site/
	cp -R "${S}/" "${D}/" || die "Install failed!"
	
	cp "${FILESDIR}"/gitorious.yml "${D}"/config/
	cp "${FILESDIR}"/database.yml "${D}"/config/
	cp "${D}"/config/broker.yml.example "${D}"/config/broker.yml
	
	cookie_secret="cookie_secret: "$(uuidgen)
	echo "  "$cookie_secret >> "${D}"/gitorious.yml
	
	if use mysql ; then
		mysql < "${FILESDIR}"/createdb.sql
		
		cd /var/www/gitorious/site
		rake db:migrate
	fi
}

pkg_postinst() {
	crontab -u gitorious "${FILESDIR}"/crontab
	
	dodir /var/www/gitorious/tmp
	dodir /var/www/gitorious/tarballs
	dodir /var/www/gitorious/repositories
}

