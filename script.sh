#!/bin/bash

# Instalar PHP


sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php7.2 php7.2-mysql php7.2-intl php7.2-curl php7.2-xml php7.2-gd -y

# Instalar Postgres

sudo apt install wget
sudo echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update -y
sudo apt install postgresql-9.4 -y

# Instalar Apache

sudo apt install apache2 -y
apache2 -v

# Instalar Moodle
sudo apt install git -y
git clone -b MOODLE_38_STABLE git://git.moodle.org/moodle.git
sudo -u postgres psql -c "CREATE USER moodleuser WITH PASSWORD 'moodlepassword';"
sudo -u postgres psql -c "CREATE DATABASE moodle WITH OWNER moodleuser ENCODING 'UTF8';"
mkdir moodledata
chmod 0777 moodledata
chown www-data moodle
cd moodle/admin/cli
sudo -u www-data /usr/bin/php install.php
chown -R root moodle
