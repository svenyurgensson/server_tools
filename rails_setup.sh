#!/bin/bash

# Set-up di un server Passenger + RVM + Ruby 1.9.3 + Sendmail + Imagemagick + libxml + curl

dpkg-reconfigure tzdata
apt-get -y update
apt-get -y upgrade
apt-get -y install apache2 apache2-prefork-dev build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties

curl -L https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm

rvm install ruby-1.9.3
rvm --default use 1.9.3
adduser --home /var/ror ror
adduser ror sudo
adduser ror rvm

echo "gem: --no-ri --no-rdoc" >> ~/.gemrc

gem install bundler rails passenger
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