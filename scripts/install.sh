#!/bin/bash
# stop on errors

echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >/etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get -y install postgresql-client
apt-get -y install gunicorn

apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
