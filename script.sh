#!/bin/bash

# Instalar paquetes que son usados en la instalación

echo "---------- INSTALANDO PAQUETES UTILES EN INSTALACION ----------"
sudo apt update -y
sudo apt upgrade -y
sudo apt install software-properties-common wget curl git net-tools -y

# Instalar Apache

echo "---------- INSTALANDO APACHE2 VERSION 2.4 ----------"
sudo apt install apache2 -y
sudo service apache2 restart
# Instalar PHP

echo "---------- INSTALANDO PHP VERSION 7.2 ----------"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php7.2 php7.2-mysql php7.2-intl php7.2-curl php7.2-xml php7.2-gd libapache2-mod-php -y

# Instalar Postgres

echo "---------- INSTALANDO POSTGRESQL VERSION 9.4 ----------"
sudo echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update -y
sudo apt install postgresql-9.4 -y
sudo service postgresql restart

# Verificar versiones de todo

echo "---------- VERSIONES DE LOS PROGRAMAS ----------"
apache2 -v
php -v
psql -V


# Preparando carpetas y archivos de Moodle
echo "---------- PREPARANDO CARPETAS Y ARCHIVOS MOODLE ----------"
cd /opt/
sudo git clone -b MOODLE_38_STABLE git://git.moodle.org/moodle.git
sudo cp -R /opt/moodle/ /var/www/html/
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata/
sudo chmod -R 777 /var/moodledata/
sudo chmod -R 0755 /var/www/html/moodle/

# Creando usuario y base de datos
echo "---------- CREANDO USUARIO Y BASE DE DATOS ----------"
sudo -u postgres psql -c "CREATE USER moodleuser WITH PASSWORD 'moodlepassword';"
sudo -u postgres psql -c "CREATE DATABASE moodle WITH OWNER moodleuser ENCODING 'UTF8';"
sudo -u postgres psql -c "GRANT CONNECT ON DATABASE moodle TO moodleuser;"
sudo -u postgres psql -c "GRANT USAGE ON SCHEMA public TO moodleuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO moodleuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO moodleuser;"