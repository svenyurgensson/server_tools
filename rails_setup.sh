#!/bin/bash

# Set-up di un server Passenger + RVM + Ruby 1.9.3 + Sendmail + Imagemagick + libxml + curl

dpkg-reconfigure tzdata
apt-get -y update
apt-get -y upgrade

# ==============
# = Dipendenze =
# ==============
BASE="build-essential curl git-core openssl autoconf libc6-dev ncurses-dev automake libtool bison subversion"
APACHE="apache2 apache2-prefork-dev"
LIBXML="libxml2-dev libxslt1-dev"
NODEJS="nodejs"
RUBY_DEPS="libyaml-dev libcurl4-openssl-dev libssl-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev"
SQLITE="libsqlite3-0 libsqlite3-dev sqlite3"
IMAGEMAGICK="imagemagick"
MYSQL="mysql-server libmysqlclient-dev"
SENDMAIL="sendmail"

apt-get -y install $BASE $APACHE $LIBXML $RUBY_DEPS $IMAGEMAGICK $MYSQL $NODEJS

# =======
# = RVM =
# =======
curl -L https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm

rvm install ruby-1.9.3
rvm --default use 1.9.3

# ==================
# = Utente per ROR =
# ==================
adduser --home /var/ror ror
adduser ror sudo
adduser ror rvm

# ======================
# = Gemme fondamentali =
# ======================

echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
gem install bundler passenger

# =============
# = Passenger =
# =============
passenger-install-apache2-module

a2enmod rewrite
a2enmod passenger
service apache2 restart

# =========
# = Mysql =
# =========
echo "Grant privileges to mysql rails user"
mysql -u root -p -Bse "grant all on *.* to rails@localhost identified by 'rails'; flush privileges;"
