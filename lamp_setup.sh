#!/bin/bash

# Set-up di un server LAMP + Sendmail + Git + wp-cli + wp-new + Server ftp

# ===============================
# = Installazione dei pacchetti =
# ===============================

apt-get update
apt-get purge apache2 mysql-server php5 libapache2-mod-php5 php-pear php5-xcache php5-mysql php5-suhosin php5-gd sendmail vsftpd
apt-get install apache2 mysql-server php5 libapache2-mod-php5 php-pear php5-xcache php5-mysql php5-suhosin php5-gd sendmail vsftpd

# ===========================
# = Configurazione di Mysql =
# ===========================

mysql_secure_installation

# ===============================
# = Configurazione Apache Httpd =
# ===============================

a2enmod rewrite

# =========================
# = Configurazione di PHP =
# =========================

sed -i 's/memory_limit = 128M/memory_limit = 32M/g' /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart

# ===================
# = WP-Cli + Wp-New =
# ===================

git clone --recursive git://github.com/wp-cli/wp-cli.git ~/wp-cli
ln -s ~/wp-cli/src/bin/wp /usr/local/bin/wp
ln -s ~/server_tools/wp-new.sh /usr/local/bin/wp-new

# ======================
# = Configurazione Ftp =
# ======================

usermod -g www-data -d /var/www -s /sbin/nologin ftp
chown -R www-data:www-data /var/www/
chmod -R g+w /var/www
chmod a-w /var/www

echo "Password per ftp"
passwd ftp

> /etc/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd.conf
echo "anonymous_enable=NO" >> /etc/vsftpd.conf
echo "local_enable=YES" >> /etc/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd.conf
echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
echo "use_localtime=YES" >> /etc/vsftpd.conf
echo "xferlog_enable=YES" >> /etc/vsftpd.conf
echo "connect_from_port_20=YES" >> /etc/vsftpd.conf
echo "chroot_local_user=YES" >> /etc/vsftpd.conf
echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
echo "pam_service_name=login" >> /etc/vsftpd.conf
echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" >> /etc/vsftpd.conf
echo "userlist_enable=YES" >> /etc/vsftpd.conf
echo "userlist_deny=NO" >> /etc/vsftpd.conf
echo "userlist_file=/etc/vsftpd.user_list" >> /etc/vsftpd.conf
echo "local_umask=002" >> /etc/vsftpd.conf
echo "chmod_enable=YES" >> /etc/vsftpd.conf
echo "file_open_mode=0755" >> /etc/vsftpd.conf

> /etc/vsftpd.user_list
echo "ftp" >> /etc/vsftpd.user_list

restart vsftpd