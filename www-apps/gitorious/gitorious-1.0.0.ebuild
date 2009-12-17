# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/nginx/nginx-0.7.62.ebuild,v 1.3 2009/09/18 19:22:29 keytoaster Exp $

inherit eutils 

DESCRIPTION="Gitorious aims to provide a great way of doing distributed opensource code collaboration."

HOMEPAGE="http://gitorious.org/gitorious"
SRC_URI="http://adrenlinerush.net/package/${P}.tar.gz"
LICENSE="AGPLv3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="mysql"

DEST_DIR="/var/www/gitorious/site/"
USER="git"

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
	>=dev-ruby/stompserver-0.9.9
	>=dev-ruby/uuid-2.1.0
	>=dev-ruby/mysql-ruby-2.8
	>=dev-ruby/ruby-yadis-0.3.4
	>=dev-ruby/ruby-hmac-0.3.2
	>=dev-ruby/Ruby-MemCache-0.0.4
	>=net-misc/memcached-1.4.1
	>=www-servers/nginx-0.7.62[passenger,gitorious,ssl]
	mysql? ( >=dev-db/mysql-5.0.84-r1 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	ebegin "Creating gitorious user and group"
	enewgroup ${USER}
	enewuser ${USER} -1 /bin/bash ${DEST_DIR} ${USER}",cron,crontab"
	eend ${?}
}

src_unpack() {
	unpack ${A}
}

src_install() {
	insinto "${DEST_DIR}"
	doins -r .
}

pkg_postinst() {
	cp "${FILESDIR}"/gitorious.yml "${DEST_DIR}"config/
	cp "${FILESDIR}"/database.yml "${DEST_DIR}"config/
	cp "${FILESDIR}"/broker.yml  "${DEST_DIR}"config/
	cp "${FILESDIR}"/environment.rb  "${DEST_DIR}"config/
	cp "${FILESDIR}"/createdb.sql  "${DEST_DIR}"config/
	cp "${FILESDIR}"/production.conf  "${DEST_DIR}"config/ultrasphinx/
	cp -r "${FILESDIR}"/cert /etc/nginx
	
	chmod -R 770 "${DEST_DIR}"script
	
	cd /var/www/gitorious/site
	RAILS_ENV="production" rake gems:install
		
	cp "${FILESDIR}"/cookie_secret.sh  "${DEST_DIR}"config/
	"${DEST_DIR}"config/cookie_secret.sh
		
	if use mysql ; then
		mysql < "${FILESDIR}"/createdb.sql
		
		cd /var/www/gitorious/site
		RAILS_ENV="production" rake db:migrate
	fi
	
	crontab -u git "${FILESDIR}"/crontab
	
	mkdir /var/www/gitorious/tmp
	mkdir /var/www/gitorious/tarballs
	mkdir /var/www/gitorious/repositories
	mkdir /var/www/gitorious/pids
	mkdir /var/www/gitorious/site/tmp/pids
	mkdir /var/www/gitorious/site/.ssh
	
	RAILS_ENV="production" rake ultrasphinx:configure
	
	chown -R git:git /var/www/gitorious
	
	echo "If you haven't initialed mysql you will need to."
	echo "# /usr/bin/mysql_install_db"
	echo
	echo "If mysql was not running durring install you will need to create"
	echo "the database and run rake."
	echo "# mysql < /var/www/gitorious/site/config/createdb.sql"
	echo "# cd /var/www/gitorious/site"
	echo "# RAILS_ENV=\"production\" rake db:migrate"
	echo
	echo "Services need to be started are: mysql, nginx, memcahced, stompserver"
	echo "You can either restart or manually start what is in the crontab."
	echo
	echo "You will need to add git.local to /etc/hosts to run as is or create dns entries and edit the gitorious.yml and nginx.conf accordingly"
}

