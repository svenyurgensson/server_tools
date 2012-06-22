#!/bin/bash

MyUSER="root"     	    # USERNAME
MyPASS="spigola2"       # PASSWORD

WpMySqlUser="wpuser"
WpMySqlPass="spigola2"

MyHOST="localhost"      # Hostname

#
# Check arguments
#

if [ $# -lt 1 ]; then
	echo
	echo "Error: wrong argument numbers"
	echo "Usage: $0 DOMAIN_NAME [--force]"
	echo
	exit 1
fi

#
# Parse Arguments
#

domain=$1
id=`echo $domain | sed "s/[\.-]/_/g"`

#
# Grant privileges to user
#

mysql -u $MyUSER -h $MyHOST -p$MyPASS -Bse "grant all on *.* to $WpMySqlUser@$MyHOST identified by '$WpMySqlPass';"

#
# Create the document root
#

mkdir -p /var/www/$id
cd /var/www/$id

#
# Apache Virtual Host
#

VHOST=/etc/apache2/sites-available/$id

> $VHOST
echo "<VirtualHost *:80>" >> $VHOST
echo "	ServerName www.$domain" >> $VHOST
echo "	ServerAlias $domain *.$domain" >> $VHOST
echo "	DocumentRoot /var/www/$id" >> $VHOST
echo "" >> $VHOST
echo "	<Directory />" >> $VHOST
echo "		Options FollowSymLinks" >> $VHOST
echo "		AllowOverride All" >> $VHOST
echo "	</Directory>" >> $VHOST
echo "" >> $VHOST
echo "	RewriteEngine On" >> $VHOST
echo "	RewriteOptions Inherit" >> $VHOST
echo "</VirtualHost>" >> $VHOST


chown -R  www-data:www-data /var/www/$id
chmod -R  g+rw /var/www/$id

a2ensite $id
/etc/init.d/apache2 reload

#
# Setup a new wordpress installation
#

wp core download
wp core config --dbname=$id --dbuser=$WpMySqlUser --dbpass=$WpMySqlPass
wp db create

read -p "Site title: " sitetitle
read -s -p "Enter admin password: " adminpass
wp core install --url="$domain" --title="$sitetitle" --admin_password="$adminpass" --admin_email="admin@example.com"

wp plugin install w3-total-cache --activate
wp plugin install wordpress-seo --activate
wp plugin install wp-socializer --activate
wp plugin install advanced-custom-fields --activate
wp plugin install youtube-sidebar-widget --activate
wp plugin install smart-youtube --activate
wp plugin install custom-post-type-ui --activate
wp plugin install wp-photo-album-plus --activate

wp theme install eclipse
wp theme install ifeature
wp theme install responsive
wp theme install pagelines

wp theme activate pagelines


#
# Setting up permalink structure
#

> .htaccess
echo "" >> .htaccess
echo "# BEGIN WordPress" >> .htaccess
echo "<IfModule mod_rewrite.c>" >> .htaccess
echo "RewriteEngine On" >> .htaccess
echo "RewriteBase /" >> .htaccess
echo "RewriteRule ^index\.php$ - [L]" >> .htaccess
echo "RewriteCond %{REQUEST_FILENAME} !-f" >> .htaccess
echo "RewriteCond %{REQUEST_FILENAME} !-d" >> .htaccess
echo "RewriteRule . /index.php [L]" >> .htaccess
echo "</IfModule>" >> .htaccess
echo "" >> .htaccess
echo "# END WordPress" >> .htaccess


#
# Make everything owned by www-data
#

chown -R  www-data:www-data /var/www/$id
chmod -R  g+rw /var/www/$id
