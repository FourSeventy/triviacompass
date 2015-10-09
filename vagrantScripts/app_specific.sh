#!/bin/sh
# Original script on https://github.com/orendon/vagrant-rails

# load rbenv and shims
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"

cd /vagrant
bundle install
rbenv rehash

#set up database
sudo sudo -u postgres psql -1 -c "CREATE USER trivia_user WITH PASSWORD 'password';"
sudo sudo -u postgres psql -1 -c "ALTER USER trivia_user WITH SUPERUSER;"

#fix database locale
sudo sudo -u postgres psql -1 -c "update pg_database set datistemplate=false where datname='template1';"
sudo sudo -u postgres psql -1 -c "drop database Template1;"
sudo sudo -u postgres psql -1 -c "create database template1 with owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;"
sudo sudo -u postgres psql -1 -c "update pg_database set datistemplate=true where datname='template1';"

#set timezone to EST
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

#create db
rake db:create
rake db:schema:load
rake db:seed