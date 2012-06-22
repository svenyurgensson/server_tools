#!/bin/bash

# Set-up di un server Passenger + RVM + Ruby 1.9.3 + Sendmail + Imagemagick + libxml + curl

dpkg-reconfigure tzdata
apt-get -y update
apt-get -y upgrade
apt-get -y install apache2 apache2-prefork-dev autoconf bison build-essential curl git-core imagemagick libapr1-dev libaprutil1-dev libcurl4-openssl-dev libid3-3.8.3-dev libmysqlclient16 libmysqlclient16-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libxml2 libxml2-dev libxslt-dev libyaml-dev mysql-client mysql-common mysql-server openssl sqlite3 zlib1g zlib1g-dev

bash < <( curl -L http://bit.ly/rvm-install-system-wide )
source /usr/local/lib/rvm
rvm install ruby-1.9.3
rvm --default use 1.9.3


echo "[[ -s \"/usr/local/lib/rvm\" ]] && source \"/usr/local/lib/rvm\"" > /etc/profile.d/rvm.sh
chmod +x /etc/profile.d/rvm.sh
gem install bundler rails passenger
passenger-install-apache2-module

echo "LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.2-p136/gems/passenger-3.0.2/ext/apache2/mod_passenger.so" > /etc/apache2/mods-available/passenger.load
echo -e "PassengerRoot /usr/local/rvm/gems/ruby-1.9.2-p136/gems/passenger-3.0.2\nPassengerRuby /usr/local/rvm/wrappers/ruby-1.9.2-p136/ruby" > /etc/apache2/mods-available/passenger.conf
a2enmod rewrite
a2enmod passenger

echo "Grant privileges to mysql rails user"
mysql -u root -p -Bse "grant all on *.* to rails@localhost identified by 'rails'; flush privileges;"

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