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
MYSQL="libmysqlclient-dev"
SENDMAIL="sendmail"

apt-get -y install $BASE $APACHE $LIBXML $RUBY_DEPS $IMAGEMAGICK $MYSQL $NODEJS

curl -L https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm

rvm install ruby-1.9.3
rvm --default use 1.9.3
adduser --home /var/ror ror
adduser ror sudo
adduser ror rvm

echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
gem install bundler passenger

passenger-install-apache2-module

# 
# echo "LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.2-p136/gems/passenger-3.0.2/ext/apache2/mod_passenger.so" > /etc/apache2/mods-available/passenger.load
# echo -e "PassengerRoot /usr/local/rvm/gems/ruby-1.9.2-p136/gems/passenger-3.0.2\nPassengerRuby /usr/local/rvm/wrappers/ruby-1.9.2-p136/ruby" > /etc/apache2/mods-available/passenger.conf
# a2enmod rewrite
# a2enmod passenger
# 
# echo "Grant privileges to mysql rails user"
# mysql -u root -p -Bse "grant all on *.* to rails@localhost identified by 'rails'; flush privileges;"

# adduser somebody
# adduser deploy
# adduser somebody sudo
# adduser somebody rvm
# adduser deploy rvm
# 
# su - somebody
# ssh-keygen -t rsa
# exit
# su - deploy
# ssh-keygen -t rsa
# exit

service apache2 restart