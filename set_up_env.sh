#!/usr/bin/env bash

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

#** Fix locale Mac Lion notice
#********************************************************************
sudo locale-gen

# Update packages and Upgrade system
echo -e "$Cyan \n Updating System.. $Color_Off"
sudo apt update && sudo apt upgrade -y

echo -e "$Cyan \n MySQL Config $Color_Off"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password PassPhp'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password PassPhp'
sudo apt install -y mysql-server
sudo mysqld --initialize

# Create new MySQL user to access database
mysql -uroot -pPassPhp -e "CREATE DATABASE IF NOT EXISTS formation";
mysql -uroot -pPassPhp -e "CREATE USER 'formation'@'localhost' IDENTIFIED BY 'PassPhp'";
mysql -uroot -pPassPhp -e "CREATE USER 'formation'@'%' IDENTIFIED BY 'PassPhp'";
mysql -uroot -pPassPhp -e "GRANT ALL PRIVILEGES ON * . * TO 'formation'@'localhost'";
mysql -uroot -pPassPhp -e "GRANT ALL PRIVILEGES ON *.* TO 'formation'@'%'";
mysql -uroot -pPassPhp -e "FLUSH PRIVILEGES";
# commenter la ligne bind_address de /etc/mysql/mysql.conf.d/mysql.cnf avec sed

## Install LAMP
echo -e "$Cyan \n Installing Apache2 $Color_Off"
sudo apt install apache2 -y
sudo service apache2 restart

echo -e "$Cyan \n Installing PHP extensions $Color_Off"
sudo apt install -y --no-install-recommends php libapache2-mod-php php-mysql php-curl php-json php-gd php-msgpack php-memcached php-intl php-sqlite3 php-gmp php-geoip php-mbstring php-redis php-xml php-zip php-fpdf
sudo apt install -y libcurl4-openssl-dev pkg-config libssl-dev libsslcommon2-dev curl libcurl4-doc libcurl3-dbg libidn11-dev libkrb5-dev libldap2-dev librtmp-dev php-cli php-dev php-common php-cgi libphp-jpgraph

sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install php-phalcon libpcre3-dev gcc make -y

#Install composer 
sudo apt install -y composer

sudo apt install git vim zip unzip -y

sudo service apache2 restart
sudo service mysql restart

exit;
